unit Atualizacao.Concret.FTP;

interface

uses
  System.Zip, WinInet, System.IOUtils,
  IdException, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP,
  System.SysUtils, Exceptions, System.IniFiles, Utils.Funcoes, Helpers.HelperString,
  IdFTPCommon, Atualizacao.Abstract.FTP, System.Generics.Collections;

type
  TAtualizacaoFTP = class(TInterfacedObject, IAtualizacaoFTP)
  private
    FIndyFTP: TIdFTP;
    FnTamanhoTotal: integer;
    FArquivoDeVersaoFTP: string;
    FDiretorioFTP: string;
    FVersaoExeLocal: string;
    FArquivoAtualizacao: string;
    FNomeExe: string;

    FObserves: TList<IAtualizacaoObserve>;
    FOnNotifyObservers: TOnNotifyObservers;
    FOnUpdate: TOnUpdate;

    function ConectarAoServidorFTP: IAtualizacaoFTP;
    function ObterNumeroVersaoFTP: integer;
    procedure SetArquivoDeVersaoFTP(const Value: string);
    procedure BaixarAtualizacao;
    procedure DescompactarAtualizacao;
    function VerificarExisteConexaoComInternet: boolean;

    procedure OnIndyFTP(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    function getTOnUpdate: TOnUpdate;
    procedure setTOnUpdate(aValue: TOnUpdate);
    function getTOnNotifyObservers: TOnNotifyObservers;
    procedure setTOnNotifyObservers(aValue: TOnNotifyObservers);
  public

    property ArquivoDeVersaoFTP: string read FArquivoDeVersaoFTP write SetArquivoDeVersaoFTP;
    function SetUpHOST(aHost: string; aUsername: string; aPassword: string; aPorta: integer): IAtualizacaoFTP; overload;
    function SetUpClient(aDiretorioFTP: string; aArquivoVersaoFTP: string; aNomeExe: string; aVersaoExeLocal: string): IAtualizacaoFTP; overload;
    function ChecaNovaVersaoDisponivel: boolean;
    procedure Atualizar;

    procedure addObserver(obs: IAtualizacaoObserve);
    procedure NotifyObservers(aStatus: string; const aProgress: integer);
    procedure removeObserver(obs: IAtualizacaoObserve);

    property OnUpdate: TOnUpdate read getTOnUpdate write setTOnUpdate;
    property OnNotifyObservers: TOnNotifyObservers read getTOnNotifyObservers write setTOnNotifyObservers;

  public
    constructor Create();
    destructor Destroy; override;
    class function New: IAtualizacaoFTP;
  end;

implementation

{ TClasseBase }

procedure TAtualizacaoFTP.NotifyObservers(aStatus: string; const aProgress: integer);
var
  i: integer;
begin
  for i := 0 to Pred(FObserves.Count) do
  begin
    try
      FObserves[i].OnUpdateProgress(aStatus, aProgress);
    except
    end;
  end;

end;

procedure TAtualizacaoFTP.removeObserver(obs: IAtualizacaoObserve);
begin
  if (FObserves.IndexOf(obs)) >= 0 then
    FObserves.remove(obs);
end;

procedure TAtualizacaoFTP.addObserver(obs: IAtualizacaoObserve);
begin
  if (FObserves.IndexOf(obs)) < 0 then
    FObserves.Add(obs);
end;

procedure TAtualizacaoFTP.BaixarAtualizacao;
var
  arquivoAtualizacaoLocal: string;
  arquivoAtualizacaoRemoto: string;
begin
  arquivoAtualizacaoLocal := TUtil.DiretorioAplicacao + FArquivoAtualizacao;
  arquivoAtualizacaoRemoto := FDiretorioFTP + FArquivoAtualizacao;

  try
    // deleta o arquivo "Atualizacao.rar", caso exista,
    // evitando erro de arquivo já existente
    if FileExists(arquivoAtualizacaoLocal) then
      DeleteFile(arquivoAtualizacaoLocal);

    // obtém o tamanho da atualização e preenche a variável "FnTamanhoTotal"
    FnTamanhoTotal := FIndyFTP.Size(arquivoAtualizacaoRemoto);

    // faz o download do arquivo "Atualizacao.rar"
    FIndyFTP.Get(arquivoAtualizacaoRemoto, arquivoAtualizacaoLocal, True, True);
  except
    On E: Exception do
    begin
      // ignora a exceção "Connection Closed Gracefully"
      if E is EIdConnClosedGracefully then
        Exit;

      raise TAtualizacaoException.Create('Erro ao baixar a atualização: ' + E.Message);

    end;
  end;
end;

procedure TAtualizacaoFTP.Atualizar;
begin
  NotifyObservers('Verificando novas versões...', 0);

  if ChecaNovaVersaoDisponivel = false then
    raise TAtualizacaoException.Create('Não existe uma nova versão disponível');

  NotifyObservers('Baixando Atualizações...', 0);
  Self.BaixarAtualizacao;

  NotifyObservers('Descompactando...', 0);
  Self.DescompactarAtualizacao;

  if FileExists(FArquivoDeVersaoFTP) then
    DeleteFile(FArquivoDeVersaoFTP);

  NotifyObservers('Concluído!', 0);
end;

function TAtualizacaoFTP.ChecaNovaVersaoDisponivel: boolean;
var
  VersaoFTP, versaoAPP: integer;
begin

  if Self.FVersaoExeLocal = '' then
    raise TAtualizacaoException.Create('A versão da applicação não foi informada');

  if VerificarExisteConexaoComInternet = false then
    raise TAtualizacaoException.Create('Sem Conexão com a Internet');

  Self.ConectarAoServidorFTP();

  VersaoFTP := Self.ObterNumeroVersaoFTP();
  versaoAPP := Self.FVersaoExeLocal.GetNumbers.ToInt;

  result := VersaoFTP > versaoAPP;

end;

function TAtualizacaoFTP.VerificarExisteConexaoComInternet: boolean;
var
  nFlags: Cardinal;
begin
  result := InternetGetConnectedState(@nFlags, 0);
end;

function TAtualizacaoFTP.ConectarAoServidorFTP: IAtualizacaoFTP;
begin
  result := Self;

  // desconecta, caso tenha sido conectado anteriormente
  if FIndyFTP.Connected then
    FIndyFTP.Disconnect;
  try
    FIndyFTP.Connect;
  except
    On E: Exception do
    begin
      raise TAtualizacaoException.Create('Erro ao acessar o servidor de atualização: ' + E.Message);
    end;
  end;
end;

constructor TAtualizacaoFTP.Create;
begin
  FIndyFTP := TIdFTP.Create(nil);
  FIndyFTP.OnWork := OnIndyFTP;

  FObserves := TList<IAtualizacaoObserve>.Create;

  FArquivoDeVersaoFTP := 'VersaoFTP.ini';
end;

procedure TAtualizacaoFTP.DescompactarAtualizacao;
var
  nomeAppBakcup: string;
  arquivoAtualizacaoLocal: string;
  ZipFile: TZipFile;
begin

  nomeAppBakcup := Format('%s%s-%s.exe', [
    ExtractFilePath(FNomeExe),
    TPath.GetFileNameWithoutExtension(FNomeExe),
    FVersaoExeLocal
    ]);

  arquivoAtualizacaoLocal := TUtil.DiretorioAplicacao + FArquivoAtualizacao;

  // deleta o backup anterior, ou melhor, da versão anterior,
  // evitando erro de arquivo já existente
  if FileExists(nomeAppBakcup) then
    DeleteFile(nomeAppBakcup);

  // Renomeia o executável atual (desatualizado) para "Sistema_Backup.exe"
  RenameFile(FNomeExe, nomeAppBakcup);

  ZipFile := TZipFile.Create;

  try
    ZipFile.ExtractZipFile(arquivoAtualizacaoLocal, TUtil.DiretorioAplicacao, nil);
    ZipFile.Close;
  finally
    ZipFile.Free;
  end;

  DeleteFile(arquivoAtualizacaoLocal);
end;

destructor TAtualizacaoFTP.Destroy;
begin
  FIndyFTP.Free;
  FObserves.Free;
  inherited;
end;

function TAtualizacaoFTP.getTOnNotifyObservers: TOnNotifyObservers;
begin
  result := FOnNotifyObservers;
end;

function TAtualizacaoFTP.getTOnUpdate: TOnUpdate;
begin
  result := FOnUpdate;
end;

class
  function TAtualizacaoFTP.New: IAtualizacaoFTP;
begin
  result := Self.Create;
end;

function TAtualizacaoFTP.ObterNumeroVersaoFTP: integer;
var
  sNumeroVersao: string;
  oArquivoINI: TIniFile;
  arquivoFTPLocal: string;
  arquivoFTPRemoto: string;
begin
  arquivoFTPLocal := TUtil.DiretorioAplicacao + ArquivoDeVersaoFTP;
  arquivoFTPRemoto := FDiretorioFTP + ArquivoDeVersaoFTP;

  // deleta o arquivo "VersaoFTP.ini" do computador, caso exista,
  // evitando erro de arquivo já existente
  if FileExists(arquivoFTPLocal) then
    DeleteFile(arquivoFTPLocal);

  // baixa o arquivo "VersaoFTP.ini" para o computador
  FIndyFTP.Get(arquivoFTPRemoto, arquivoFTPLocal, True, True);

  // abre o arquivo "VersaoFTP.ini"
  oArquivoINI := TIniFile.Create(arquivoFTPLocal);
  try
    // lê o número da versão
    sNumeroVersao := oArquivoINI.ReadString('VersaoFTP', 'Numero', EmptyStr);
    FArquivoAtualizacao := oArquivoINI.ReadString('VersaoFTP', 'Arquivo', EmptyStr);

    // retira os pontos (exemplo: de "1.0.1" para "101")
    sNumeroVersao := StringReplace(sNumeroVersao, '.', EmptyStr, [rfReplaceAll]);

    // converte o número da versão para número
    result := StrToIntDef(sNumeroVersao, 0);
  finally
    FreeAndNil(oArquivoINI);
  end;

end;

procedure TAtualizacaoFTP.OnIndyFTP(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
var
  nPorcentagem: integer;
  nTamanhoTotal: Double;
  nTransmitidos: Double;
  sStatus: string;
  iProgresso: integer;
begin
  if FnTamanhoTotal = 0 then
    Exit;

  // obtém o tamanho total do arquivo em bytes
  nTamanhoTotal := FnTamanhoTotal div 1024;

  // obtém a quantidade de bytes já baixados
  nTransmitidos := AWorkCount div 1024;

  // calcula a porcentagem de download
  nPorcentagem := Round((nTransmitidos * 100) / nTamanhoTotal);

  // atualiza o componente TLabel com a porcentagem
  sStatus := Format('Baixando %s%%...', [FormatFloat('##0', nPorcentagem)]);

  // atualiza a barra de preenchimento do componente TProgressBar
  iProgresso := AWorkCount div 1024;

  NotifyObservers(sStatus, nPorcentagem);
end;

procedure TAtualizacaoFTP.SetArquivoDeVersaoFTP(const Value: string);
begin
  FArquivoDeVersaoFTP := Value;
end;

procedure TAtualizacaoFTP.setTOnNotifyObservers(aValue: TOnNotifyObservers);
begin
  FOnNotifyObservers := aValue;
end;

procedure TAtualizacaoFTP.setTOnUpdate(aValue: TOnUpdate);
begin
  FOnUpdate := aValue;
end;

function TAtualizacaoFTP.SetUpClient(aDiretorioFTP, aArquivoVersaoFTP: string; aNomeExe: string; aVersaoExeLocal: string): IAtualizacaoFTP;
begin
  FDiretorioFTP := aDiretorioFTP;
  FArquivoDeVersaoFTP := aArquivoVersaoFTP;
  FVersaoExeLocal := aVersaoExeLocal;
  FNomeExe := aNomeExe;
end;

function TAtualizacaoFTP.SetUpHOST(aHost, aUsername, aPassword: string; aPorta: integer): IAtualizacaoFTP;
begin
  FIndyFTP.Host := aHost;
  FIndyFTP.Username := aUsername;
  FIndyFTP.Password := aPassword;
  FIndyFTP.Port := aPorta;
  FIndyFTP.Passive := True;
  FIndyFTP.TransferType := TIdFTPTransferType.ftBinary;

  result := Self;
end;

end.
