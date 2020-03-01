unit Dao.Conection.Parametros;

interface

uses Database.SGDB, Dao.Abstract.Parametros;

type
  TConectionParametros = class(TInterfacedObject, IDaoParametros)
  private
    FPort: Integer;
    FDatabase: string;
    FPassword: string;
    FApplicationName: string;
    FUserName: string;
    FServer: string;
    FSGBD: TSGBD;
    procedure SetApplicationName(const Value: string);
    procedure SetDatabase(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure SetServer(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetSGBD(const Value: TSGBD);
    function GetApplicationName: string;
    function GetDatabase: string;
    function GetPassword: string;
    function GetPort: Integer;
    function GetServer: string;
    function GetSGBD: TSGBD;
    function GetUserName: string;

  public
    property Port: Integer read GetPort write SetPort;
    property Server: string read GetServer write SetServer;
    property Database: string read GetDatabase write SetDatabase;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property ApplicationName: string read GetApplicationName write SetApplicationName;
    property SGBD: TSGBD read GetSGBD write SetSGBD;

    // Ctrl+Shift+Alt+P
    // Ctrl+Al+N+P

    constructor Create(aSGBD: TSGBD; aServer, aDatabase, aUserName, aPassword, aApplicationName: string; aPort: Integer);
    destructor destroy; override;

    class function New(aPort: Integer; aServer: string; Database: string; UserName: string; Password: string; ApplicationName: string; aSGBD: TSGBD): TConectionParametros;
  end;

implementation

{ TConectionParametros }

constructor TConectionParametros.Create(aSGBD: TSGBD; aServer, aDatabase, aUserName, aPassword, aApplicationName: string; aPort: Integer);
begin
  Self.SGBD := aSGBD;
  Self.Port := aPort;
  Self.Server := aServer;
  Self.Database := aDatabase;
  Self.UserName := aUserName;
  Self.Password := aPassword;
  Self.ApplicationName := aApplicationName;
end;

destructor TConectionParametros.destroy;
begin

end;

function TConectionParametros.GetApplicationName: string;
begin
  result := FApplicationName;
end;

function TConectionParametros.GetDatabase: string;
begin
  result := FDatabase
end;

function TConectionParametros.GetPassword: string;
begin
  result := FPassword
end;

function TConectionParametros.GetPort: Integer;
begin
  result := FPort
end;

function TConectionParametros.GetServer: string;
begin
  result := FServer
end;

function TConectionParametros.GetSGBD: TSGBD;
begin
  result := FSGBD
end;

function TConectionParametros.GetUserName: string;
begin
  result := FUserName
end;

class function TConectionParametros.New(aPort: Integer; aServer, Database, UserName, Password, ApplicationName: string; aSGBD: TSGBD): TConectionParametros;
begin
  result := TConectionParametros.Create(aSGBD, aServer, Database, UserName, Password, ApplicationName, aPort);
end;

procedure TConectionParametros.SetApplicationName(const Value: string);
begin
  FApplicationName := Value;
end;

procedure TConectionParametros.SetDatabase(const Value: string);
begin
  FDatabase := Value;
end;

procedure TConectionParametros.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TConectionParametros.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

procedure TConectionParametros.SetServer(const Value: string);
begin
  FServer := Value;
end;

procedure TConectionParametros.SetSGBD(const Value: TSGBD);
begin
  FSGBD := Value;
end;

procedure TConectionParametros.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

end.
