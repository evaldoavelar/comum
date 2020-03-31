unit Util.Thread;

interface

uses
  System.SysUtils, System.Classes;

type

  TOnExceptionThread = reference to procedure(e: Exception);
  TOnAntesExecultar = reference to procedure();
  TOnExecultar = reference to procedure();
  TOnDepoisExecutar = reference to procedure();

  TThreadProcesso = class(TThread)
  private
    FException: Exception;
    FMesaOrigem: string;
    FMesaDestino: string;
    FDataTransf: TDateTime;
    procedure syncException;
    procedure syncOnAntesEnvio;
    procedure syncOnDepoisExecutar;
    procedure syncOnExecultar;

  public

    OnExceptionThread: TOnExceptionThread;
    OnAntesExecultar: TOnAntesExecultar;
    OnExecultar: TOnAntesExecultar;
    OnDepoisExecutar: TOnDepoisExecutar;

    constructor Create(CreateSuspended: Boolean); overload;
    destructor destroy; override;
  protected
    procedure Execute; override;
  end;

  TThreadUtil = class
  public
    class procedure Executar(
      aOnExceptionThread: TOnExceptionThread;
      aOnAntesExecultar: TOnAntesExecultar;
      aOnExecultar: TOnAntesExecultar;
      aOnDepoisExecutar: TOnDepoisExecutar
      );
  end;

implementation

{ TThreadTrasnf }

constructor TThreadProcesso.Create(CreateSuspended: Boolean);
begin
  inherited;
  NameThreadForDebugging('TThreadProcesso');
end;

destructor TThreadProcesso.destroy;
begin

  inherited;
end;

procedure TThreadProcesso.Execute;
begin
  inherited;

  try
    try
      Synchronize(syncOnAntesEnvio);

      (syncOnExecultar);

    except
      on e: Exception do
      begin
        FException := e;
        Synchronize(syncException);
      end;
    end;
  finally
    Synchronize(syncOnDepoisExecutar);
  end;

end;

procedure TThreadProcesso.syncException;
begin
  if Assigned(OnExceptionThread) then
    OnExceptionThread(FException);
end;

procedure TThreadProcesso.syncOnAntesEnvio;
begin
  if Assigned(OnAntesExecultar) then
    OnAntesExecultar();
end;

procedure TThreadProcesso.syncOnDepoisExecutar;
begin
  if Assigned(OnDepoisExecutar) then
    OnDepoisExecutar();
end;

procedure TThreadProcesso.syncOnExecultar;
begin
  if Assigned(OnExecultar) then
    OnExecultar();
end;

{ TThreadUtil }

class procedure TThreadUtil.Executar(aOnExceptionThread: TOnExceptionThread;
  aOnAntesExecultar, aOnExecultar: TOnAntesExecultar;
  aOnDepoisExecutar: TOnDepoisExecutar);
var
  Thread: TThreadProcesso;
begin
  Thread := TThreadProcesso.Create();
  Thread.OnExceptionThread := aOnExceptionThread;
  Thread.OnAntesExecultar := aOnAntesExecultar;
  Thread.OnExecultar := aOnExecultar;
  Thread.OnDepoisExecutar := aOnDepoisExecutar;
  Thread.FreeOnTerminate := true;
  Thread.Resume;
end;

end.
