unit Dao.IConection;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Database.SGDB;

type

  IConection = interface
    ['{F4CD79FE-8AB6-449D-9041-C3F44BC18D09}']

    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    function ExecSQL(const ASQL: String): LongInt; overload;
    function ExecSQL(const ASQL: String; aNamedParamns: TDictionary<string, Variant>): LongInt; overload;
    function ExecSQL(const ASQL: String; const AParams: array of Variant): LongInt; overload;
    function Open(const ASQL: String): TDataSet; overload;
    function Open(const ASQL: String; const AParams: array of Variant): TDataSet; overload;
    function Open(const ASQL: String; const AParams: array of Variant; const ATypes: array of TFieldType): TDataSet; overload;
    function Open(const ASQL: String; aNamedParamns: TDictionary<string, Variant>): TDataSet; overload;
    procedure Close();
    function GetSGBDType: TSGBD;
    procedure TesteConection;

  end;

implementation

end.
