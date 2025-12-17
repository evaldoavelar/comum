unit Log.Performance;

interface

uses
  System.SysUtils, System.Diagnostics, Log.ILog, Log.TLog;

type
  /// <summary>
  /// Classe para medição automática de performance de métodos usando RAII.
  /// Ao sair do escopo, registra automaticamente o tempo decorrido no log.
  /// </summary>
  ILogPerformance = interface
    ['{8F3A5B2C-1D4E-4F6A-9B8C-7E2D3F4A5C6D}']
    /// <summary>
    /// Para a medição e retorna o tempo decorrido em milissegundos.
    /// Chamado automaticamente pelo destrutor.
    /// </summary>
    function Stop: string;

    /// <summary>
    /// Obtém o tempo decorrido até o momento (sem parar a medição).
    /// </summary>
    function GetElapsedMilliseconds: Double;
  end;

  TLogPerformance = class(TInterfacedObject, ILogPerformance)
  private
    FStopwatch: TStopwatch;
    FMetodoNome: string;
    FLog: ILog;
    FUsarTLog: Boolean;
    FParado: Boolean;
  public
    constructor Create();
    destructor Destroy; override;

    /// <summary>
    /// Inicia uma nova medição de performance.
    /// </summary>
    /// <param name="aMetodoNome">Nome do método (ex: 'TMinhaClasse.MeuMetodo')</param>
    /// <param name="aLog">Instância de ILog (opcional). Se nil, usa TLog estático.</param>
    class function Start(): ILogPerformance;

    function Stop: string;
    function GetElapsedMilliseconds: Double;
  end;

implementation

uses
  System.Classes, Winapi.Windows;

{ TLogPerformance }

constructor TLogPerformance.Create();
begin
  inherited Create;
  FParado := False;
  FStopwatch := TStopwatch.StartNew;
end;

destructor TLogPerformance.Destroy;
begin
  if not FParado then
    Stop;
  inherited;
end;

class function TLogPerformance.Start(): ILogPerformance;
begin
  Result := TLogPerformance.Create();
end;

function TLogPerformance.Stop: string;
var
  elapsed: Double;
  mensagem: string;
begin
  if FParado then
  begin
    Result := '';
    Exit;
  end;

  FStopwatch.Stop;
  FParado := True;

  elapsed := FStopwatch.elapsed.TotalMilliseconds;

  // Formata a mensagem apenas com o nome do método e tempo
  if elapsed < 1000 then
    Result := Format(' %.2f ms', [elapsed])
  else
    Result := Format(' %.2f s', [elapsed / 1000]);
end;

function TLogPerformance.GetElapsedMilliseconds: Double;
begin
  Result := FStopwatch.elapsed.TotalMilliseconds;
end;

end.