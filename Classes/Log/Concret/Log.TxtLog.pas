unit Log.TxtLog;

interface

uses Log.ILog, Log.TTipoLog, System.Classes, Winapi.Windows, System.SysUtils,
  System.Generics.Collections, System.Variants;

type

  TLogTXT = class(TInterfacedObject, ILog)
  private
    class var FInstancia: ILog;
  private
    FDiretorio: string;

  CLASS VAR
    FAtivo: Boolean;
    FNomeArquivo: String;
    FDecorator: ILog;
    FOnLog: TOnLog;

    procedure GravarLog(aTexto: string; aTipo: TTipoLog);
    function getNomeArquivo: string;
    procedure setNomeArquivo(const Value: string);
    function GETAtivo: Boolean;
  public

    property Ativo: Boolean read GETAtivo;
    property Diretorio: string read FDiretorio write FDiretorio;
    property NomeArquivo: string read getNomeArquivo write setNomeArquivo;

    procedure i(Log: string); overload;
    procedure i(Log: string; const Args: array of const); overload;

    procedure e(Log: string); overload;
    procedure d(Log: string); overload;
    procedure d(Log: string; const Args: array of const); overload;
    procedure d(aParamns: TDictionary<string, Variant>); overload;
    procedure d(e: Exception); overload;

    function setOnLog(aOnLog: TOnLog): ILog;
    function setAtivo(): ILog;
    function setInativo(): ILog;

    class procedure ClearInstance;

    constructor Create(aDiretorio: string; aNomeArquivo: string; aDecorator: ILog);
    class function New(aDiretorio: string; aNomeArquivo: string; aDecorator: ILog): ILog;

    destructor Destroy; override;
  end;

implementation

{ TLog }

procedure TLogTXT.d(Log: string);
begin
  GravarLog(Log, TTipoLog.Debug);

  if Assigned(FDecorator) then
    FDecorator.d(Log);
end;

class procedure TLogTXT.ClearInstance;
begin
  if Assigned(FInstancia) then
    freeAndNil(FInstancia);
end;

constructor TLogTXT.Create(aDiretorio: string; aNomeArquivo: string;
  aDecorator: ILog);
begin
  FDecorator := aDecorator;
  FDiretorio := aDiretorio;
  FNomeArquivo := aNomeArquivo;
end;

procedure TLogTXT.d(Log: string; const Args: array of const);
begin
  GravarLog(Format(Log, Args), TTipoLog.Custom);
  if Assigned(FDecorator) then
    FDecorator.d(Log, Args);
end;

procedure TLogTXT.e(Log: string);
begin
  GravarLog(Log, TTipoLog.Erro);
  if Assigned(FDecorator) then
    FDecorator.e(Log);
end;

function TLogTXT.GETAtivo: Boolean;
begin
  Result := FAtivo;
end;

function TLogTXT.getNomeArquivo: string;
begin
  Result := FDiretorio + '\' + FNomeArquivo;
end;

procedure TLogTXT.GravarLog(aTexto: string; aTipo: TTipoLog);
var
  tft: textfile;
  linha: string;
begin
  try

    linha := Format(' %s - %s - %s', [FormatDateTime('dd/mm/yy hh:mm:ss', Now),
      aTipo.ToString, aTexto]);

    OutputDebugString(PWideChar(linha));

    if Ativo then
    begin
      AssignFile(tft, NomeArquivo);
      if FileExists(NomeArquivo) then
        Append(tft)
      else
        ReWrite(tft);

      Writeln(tft, linha);
      Closefile(tft);
    end;

    if Assigned(FOnLog) then
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          FOnLog(linha, aTipo);
        end);
    end;
  except
    on e: Exception do
  end;
end;

procedure TLogTXT.i(Log: string; const Args: array of const);
begin
  GravarLog(Format(Log, Args), TTipoLog.Info);
  if Assigned(FDecorator) then
    FDecorator.i(Log, Args);
end;

procedure TLogTXT.i(Log: string);
begin
  GravarLog(Log, Info);

  if Assigned(FDecorator) then
    FDecorator.i(Log);
end;

class function TLogTXT.New(aDiretorio: string; aNomeArquivo: string;
aDecorator: ILog): ILog;
begin

  if Assigned(FInstancia)  then
    Result := FInstancia
  else
  begin
    FInstancia := TLogTXT.Create(aDiretorio, aNomeArquivo, aDecorator);
    Result := FInstancia
  end;
end;

function TLogTXT.setAtivo: ILog;
begin
  Result := Self;
  FAtivo := True;
end;

function TLogTXT.setInativo: ILog;
begin
  Result := Self;
  FAtivo := false;
end;

procedure TLogTXT.setNomeArquivo(const Value: string);
begin
  FNomeArquivo := Value;
end;

function TLogTXT.setOnLog(aOnLog: TOnLog): ILog;
begin
  Result := Self;
  FOnLog := aOnLog;
end;

procedure TLogTXT.d(e: Exception);
begin
  d(e.Message);
end;

destructor TLogTXT.Destroy;
begin

  inherited;
end;

procedure TLogTXT.d(aParamns: TDictionary<string, Variant>);
var
  builder: TStringBuilder;
  key: string;
begin
  try

    builder := TStringBuilder.Create;

    for key in aParamns.Keys do
    begin
      builder.AppendFormat(' %s = %s ', [key, VarToStr(aParamns.Items[key])]);
    end;

    d(builder.ToString());

    freeAndNil(builder);

  except
    on e: Exception do
      d(e.Message);
  end;

end;

// initialization
//
// finalization
// TLogTXT.ClearInstance;

end.
