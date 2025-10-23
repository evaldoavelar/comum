unit Log.ILog;

interface

uses Log.TTipoLog, System.Generics.Collections, System.SysUtils;

type

  TOnLog = procedure(msg: string; tipo: TTipoLog) of object;

  ILog = interface
    ['{D8F68DA7-901E-45FF-ACE6-7FB56F0D8DD0}']

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

    procedure Clean(aDiasAposCriacao: integer);
  end;

implementation

end.
