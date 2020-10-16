unit Test.Model.Log;

interface

uses
  Log.ILog, System.SysUtils, System.Generics.Collections;

type
  TLogTeste = class(TInterfacedObject, ILog)
  public
    function setAtivo(): ILog;
    function setInativo(): ILog;

    function setOnLog(OnLog: TOnLog): ILog;

    procedure i(Log: string); overload;
    procedure i(Log: string; const Args: array of const); overload;

    procedure e(Log: string); overload;

    procedure d(Log: string); overload;
    procedure d(Log: string; const Args: array of const); overload;
    procedure d(aParamns: TDictionary<string, Variant>); overload;
    procedure d(e:Exception); overload;


  public
    constructor Create();
    destructor Destroy; override;
    class function New: ILog;
  end;

implementation

{ TClasseBase }

constructor TLogTeste.Create;
begin

end;

procedure TLogTeste.d(Log: string; const Args: array of const);
begin

end;

procedure TLogTeste.d(Log: string);
begin

end;

destructor TLogTeste.Destroy;
begin

  inherited;
end;

procedure TLogTeste.e(Log: string);
begin

end;

procedure TLogTeste.i(Log: string; const Args: array of const);
begin

end;

procedure TLogTeste.i(Log: string);
begin

end;

class function TLogTeste.New: ILog;
begin
  result := Self.Create;
end;

function TLogTeste.setAtivo: ILog;
begin

end;

function TLogTeste.setInativo: ILog;
begin

end;

function TLogTeste.setOnLog(OnLog: TOnLog): ILog;
begin

end;

procedure TLogTeste.d(e: Exception);
begin

end;

procedure TLogTeste.d(aParamns: TDictionary<string, Variant>);
begin

end;

end.
