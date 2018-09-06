unit Dao.Conection.Parametros;

interface

uses Database.SGDB;

type
  TConectionParametros = class(TInterfacedObject)
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
  public
    property Port: Integer read FPort write SetPort;
    property Server: string read FServer write SetServer;
    property Database: string read FDatabase write SetDatabase;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property ApplicationName: string read FApplicationName write SetApplicationName;
    property SGBD : TSGBD read FSGBD write SetSGBD;

    //Ctrl+Shift+Alt+P
    //Ctrl+Al+N+P
    constructor Create(aSGBD:TSGBD; aServer, aDatabase, aUserName, aPassword, aApplicationName: string; aPort: Integer);
    destructor destroy;  override;
  end;

implementation

{ TConectionParametros }

constructor TConectionParametros.Create(aSGBD:TSGBD; aServer, aDatabase, aUserName, aPassword, aApplicationName: string; aPort: Integer);
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
