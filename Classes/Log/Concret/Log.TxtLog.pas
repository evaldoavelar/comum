unit Log.TxtLog;

interface

uses Log.ILog, Log.TTipoLog, System.Classes;

type

  TLogTXT = class(TInterfacedObject, ILog)
  private
    class var
      FInstancia: TLogTXT;
  private
    FDiretorio: string;
    FAtivo: Boolean;
    FNomeArquivo: String;
    FDecorator: ILog;
    FOnLog: TOnLog;

    procedure GravarLog(aTexto: string; aTipo: TTipoLog);
    function getNomeArquivo: string;
    procedure setNomeArquivo(const Value: string);
  public

    property Ativo: Boolean read FAtivo write FAtivo;
    property Diretorio: string read FDiretorio write FDiretorio;
    property NomeArquivo: string read getNomeArquivo write setNomeArquivo;

    procedure i(Log: string); overload;
    procedure i(Log: string; const Args: array of const); overload;

    procedure e(Log: string); overload;
    procedure d(Log: string); overload;
    procedure d(Log: string; const Args: array of const); overload;

    function setOnLog(aOnLog: TOnLog): ILog;
    function setAtivo(): ILog;
    function setInativo(): ILog;

    constructor Create(aDiretorio: string; aNomeArquivo: string; aDecorator: ILog);
    class function New(aDiretorio: string; aNomeArquivo: string; aDecorator: ILog): ILog;
  end;

implementation

uses
  System.SysUtils;

{ TLog }

procedure TLogTXT.d(Log: string);
begin
  GravarLog(Log, TTipoLog.Debug);

  if Assigned(FDecorator) then
    FDecorator.d(Log);
end;

constructor TLogTXT.Create(aDiretorio: string; aNomeArquivo: string; aDecorator: ILog);
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

function TLogTXT.getNomeArquivo: string;
begin
  result := FDiretorio + '\' + FNomeArquivo;
end;

procedure TLogTXT.GravarLog(aTexto: string; aTipo: TTipoLog);
var
  tft: textfile;
  linha: string;
begin
  linha := Format(' %s - %s - %s', [
    FormatDateTime('dd/mm/yy hh:mm:ss', Now),
    aTipo.ToString,
    aTexto]
    );

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
      end
      );
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

class
  function TLogTXT.New(aDiretorio: string; aNomeArquivo: string; aDecorator: ILog): ILog;
begin
  if Assigned(FInstancia) then
    result := FInstancia
  else
  begin
    FInstancia := TLogTXT.Create(aDiretorio, aNomeArquivo, aDecorator);
    result := FInstancia
  end;
end;

function TLogTXT.setAtivo: ILog;
begin
  result := Self;
  FAtivo := True;
end;

function TLogTXT.setInativo: ILog;
begin
  result := Self;
  FAtivo := false;
end;

procedure TLogTXT.setNomeArquivo(const Value: string);
begin
  FNomeArquivo := Value;
end;

function TLogTXT.setOnLog(aOnLog: TOnLog): ILog;
begin
  result := Self;
  FOnLog := aOnLog;
end;

end.
