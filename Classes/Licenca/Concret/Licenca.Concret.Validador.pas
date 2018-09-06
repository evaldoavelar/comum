unit Licenca.Concret.Validador;

interface

uses

  Controls,
  IniFiles,
  Classes,
  SysUtils,
  DateUtils,
  Helpers.HelperDateTime,
  Utils.Crypt,
  Utils.Funcoes,
  Helpers.HelperString,
  Licenca.Abstract.Validador;

type
  EFileNotFound = class(Exception);

  TLicencaValidador = class(TInterfacedObject, ILicencaValidador)
  private

    fDiasRestantes: Integer;
    fLicencaVencida: Boolean;
    fDataDoSOMenorQueAplicacao: Boolean;
    fDataDoSOMenorQueUltimoAcesso: Boolean;
    fArquivoUltimoAcesso: string;
    fChave: string;
    fCampo: string;
    fDataUltimoAcesso: TDate;
    fDataVencimento: TDate;
    fApp: string;
    FDataHoje: TDate;
    fAppOrigem: string;

    procedure SalvarUltimoAcesso(Data: TDate);
    function GetUltimoAcesso: TDate;
    procedure SetDataHoje(const Value: TDate);
  public

    function CarregaLicenca(aPathArquivo: string): ILicencaValidador;
    function Configura(aAppOrigem: string; aChave: string; aCampo: string; aDataHoje: TDate; aArquivoUltimoAcesso: string): ILicencaValidador;
    function Processa: ILicencaValidador;
    function VerificaDataDoSOMenorQueAplicacao: ILicencaValidador;
    function VerificaDataDoSOMenorQueUltimoAcesso: ILicencaValidador;
    function VerificaLicencaVencida: ILicencaValidador;
    function RetornaDiasRestantes: Integer;

  public

    property DataHoje: TDate read FDataHoje write SetDataHoje;
    property DataVencimento: TDate read fDataVencimento;
    property App: string read fApp;
    property LicencaVencida: Boolean read fLicencaVencida;
    property DataDoSOMenorQueAplicacao: Boolean read fDataDoSOMenorQueAplicacao;
    property DataDoSOMenorQueUltimoAcesso: Boolean read fDataDoSOMenorQueUltimoAcesso;
    property DiasRestantes: Integer read fDiasRestantes;
    property DataUltimoAcesso: TDate read fDataUltimoAcesso;

    property ArquivoUltimoAcesso: string read fArquivoUltimoAcesso write fArquivoUltimoAcesso;
    property Chave: string read fChave write fChave;
    property Campo: string read fCampo write fCampo;

    function SaveToFile(DataVencimento: TDate; AppName: string; NomeArquivoLicenca: string): TDate;
    constructor Create;
    class function New: ILicencaValidador;
  end;

const
  criptografia: string = 'LicencaConsult';

implementation


{ TCSTLicenca }

function TLicencaValidador.Processa: ILicencaValidador;
var
  DataCriacao: TDateTime;
begin
  result := Self;

  if Self.DataVencimento = 0 then
    raise Exception.Create('Informe a Data de Vencimento da Licença');

  if Self.DataHoje = 0 then
    raise Exception.Create('Informe a Data de Hoje da Licença');

  if fAppOrigem <> fApp then
    raise Exception.Create('Licença não pertence a ' + fAppOrigem);

  // DataVencimento.ReplaceTimer;
  // DataHoje.ReplaceTimer;
  DataCriacao := TUtil.DataCriacaoAplicacao();
  DataCriacao.ReplaceTimer;

  fDataUltimoAcesso := GetUltimoAcesso();

  fLicencaVencida := (DataVencimento <= DataHoje);
  fDataDoSOMenorQueAplicacao := (DataHoje < DataCriacao);
  fDataDoSOMenorQueUltimoAcesso := (DataHoje < fDataUltimoAcesso);

  if fLicencaVencida or fDataDoSOMenorQueAplicacao then
    fDiasRestantes := -1
  else
    fDiasRestantes := DaysBetween(DataHoje, DataVencimento);

  if fDiasRestantes < 0 then
    SalvarUltimoAcesso(DataHoje);
end;

function TLicencaValidador.Configura(aAppOrigem: string; aChave: string; aCampo: string; aDataHoje: TDate; aArquivoUltimoAcesso: string): ILicencaValidador;
begin
  result := Self;
  fAppOrigem := aAppOrigem;
  FDataHoje := aDataHoje;
  fChave := aChave;
  fCampo := aCampo;
  fArquivoUltimoAcesso := aArquivoUltimoAcesso;
end;

constructor TLicencaValidador.Create;
begin
  Self.fDiasRestantes := 0;
  Self.fDataVencimento := 0;
  Self.DataHoje := 0;
  fLicencaVencida := False;
  fDataDoSOMenorQueAplicacao := False;
  fArquivoUltimoAcesso := '';
  fChave := '';
  fCampo := '';
  fDataUltimoAcesso := 0;
end;

function TLicencaValidador.GetUltimoAcesso: TDate;
var

  aux: string;
  arq: TiniFile;
  Data: TDateTime;
  dataE: TStringList;
begin
  Data := Now;
  arq := TiniFile.Create(ArquivoUltimoAcesso);
  aux := arq.ReadString(Chave, Campo, '');
  if (aux = '') then
    aux := FormatDateTime('dd-mm-yyyy', Now)
  else
    aux := TCrypt.DecriptografaString(criptografia, aux);
  arq.Free;

  dataE := aux.Explode('-');

  try
    try
      Data.Encode(StrToInt(dataE[0]), StrToInt(dataE[1]), StrToInt(dataE[2]));
      Data.ReplaceTimer;
    except
      Data.SetDateNow;
    end;

  finally
    FreeAndNil(dataE);
  end;

  result := Data;
end;

class function TLicencaValidador.New: ILicencaValidador;
begin
  result := TLicencaValidador.Create;
end;

function TLicencaValidador.CarregaLicenca(aPathArquivo: string): ILicencaValidador;
var
  arquivo: TStringList;
  linha: TStringList;
  aux: String;
  sData: String;
  dData: TDateTime;
begin
  result := Self;

  if not FileExists(aPathArquivo) then
    raise EFileNotFound.Create('Arquivo de Licença não encontrado!' +
      #13 + aPathArquivo);

  arquivo := TStringList.Create;
  try
    arquivo.LoadFromFile(aPathArquivo);
    aux := TCrypt.DecriptografaString(criptografia, arquivo.Text);

    try

      linha := aux.Explode(';');

      try
        sData := (linha[0]); // 25/06/2014
        dData.EncodeStr(sData.SubString(0, 2), sData.SubString(4, 6), sData.SubString(7, 11));

        Self.fDataVencimento := dData;
        Self.fApp := (linha[1]);

      finally
        FreeAndNil(linha);
      end;

    except
      on E: Exception do
        raise Exception.Create('Falha ao abrir licença: ' + E.Message);
    end;

  finally
    FreeAndNil(arquivo);
  end;

end;

procedure TLicencaValidador.SalvarUltimoAcesso(Data: TDate);
var
  aux: string;
  arq: TiniFile;
begin
  arq := TiniFile.Create(ArquivoUltimoAcesso);
  aux := FormatDateTime('dd-mm-yyyy', Data);
  aux := TCrypt.CriptografaString(criptografia, aux);
  arq.WriteString(Chave, Campo, aux);
  arq.Free;
end;

function TLicencaValidador.SaveToFile(DataVencimento: TDate; AppName: string; NomeArquivoLicenca: string): TDate;
var
  arquivo: TStringList;
  aux: string;
begin

  arquivo := TStringList.Create;
  try
    aux := Format('%s;%s', [FormatDateTime('dd-mm-yyyy', DataVencimento), AppName]);

    arquivo.Text := TCrypt.CriptografaString(criptografia, aux);

    arquivo.SaveToFile(NomeArquivoLicenca);

  finally
    FreeAndNil(arquivo);
  end;

end;

procedure TLicencaValidador.SetDataHoje(const Value: TDate);
begin
  FDataHoje := Value;
end;

function TLicencaValidador.VerificaDataDoSOMenorQueAplicacao: ILicencaValidador;
var
  aux: string;
begin
  result := Self;

  if fDataDoSOMenorQueAplicacao then
  begin
    aux := Format('Atenção: A Data do Sistema Operacional(%s) é menor que a data de compilação do SISTEMA. O Acesso está Bloqueado.'
      + #13 + 'Atualize a data do Sistema Operacional.', [DateToStr(Self.DataVencimento)]);

    raise Exception.Create(aux);
  end;
end;

function TLicencaValidador.VerificaDataDoSOMenorQueUltimoAcesso: ILicencaValidador;
var
  aux: string;
begin
  result := Self;

  if fDataDoSOMenorQueUltimoAcesso then
  begin
    aux :=
      Format('Atenção: A Data do Sistema Operacional (%s) é menor que a data do último acesso ao SISTEMA(%s). O ACESSO  está Bloqueado.' + #13 +
      'Atualize a data do Sistema Operacional.', [DateToStr(Self.DataVencimento), DateToStr(Self.DataUltimoAcesso)]);

    raise Exception.Create(aux);
  end;

end;

function TLicencaValidador.VerificaLicencaVencida: ILicencaValidador;
var
  aux: string;
begin
  result := Self;
  if fDiasRestantes = -1 then
  begin

    aux := Format('Atenção: A licença do Sistema está vencida desde %s. O Sistema está bloqueado!' + #13 +
      'Entre em Contato com a Consult.', [DateToStr(Self.DataVencimento)]);

    raise Exception.Create(aux);
  end;
end;

function TLicencaValidador.RetornaDiasRestantes: Integer;
begin
  result := fDiasRestantes;
end;

end.
