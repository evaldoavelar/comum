unit Dao.Abstract.Parametros;

interface

uses Database.SGDB;

type

  IDaoParametros = interface
    ['{0848FF94-B381-4787-9A00-EBF8BB486457}']

    procedure SetApplicationName(const Value: string);
    procedure SetDatabase(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure SetServer(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetSGBD(const Value: TSGBD);
    function GetPort: Integer;
    function GetServer: string;
    function GetDatabase: string;
    function GetUserName: string;
    function GetPassword: string;
    function GetApplicationName: string;
    function GetSGBD: TSGBD;

    property Port: Integer read GetPort write SetPort;
    property Server: string read GetServer write SetServer;
    property Database: string read GetDatabase write SetDatabase;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property ApplicationName: string read GetApplicationName write SetApplicationName;
    property SGBD: TSGBD read GetSGBD write SetSGBD;
  end;

implementation

end.
