unit Rest.Concret.ClientAPI;

interface

uses Rest.Abstract.ClientAPI, System.Net.HttpClient,
  Rest.Client, Rest.Types,
{$IF DECLARED(FireMonkeyVersion)}
  FMX.Types,
{$ENDIF}
  System.sysutils,
  Rest.Authenticator.Basic;

type

  TRestClientAPI = class(TInterfacedObject, IRestClientAPI)
  private
    function GetHTTPBasicAuthenticator: THTTPBasicAuthenticator;
  protected
    FOnLog: TProc<string>;
    FRESTClient: TRestClient;
    FHTTPBasicAuthenticator: THTTPBasicAuthenticator;
    FRESTRequest: TRESTRequest;
    procedure Log(aValue: string);
  public

    function BaseURL(aBaseURL: string): IRestClientAPI;
    function Accept(aAccept: string): IRestClientAPI;
    function AcceptCharset(aAcceptCharset: string): IRestClientAPI;
    function ContentType(aContentType: string): IRestClientAPI;
    function TokenBearer(aToken: string): IRestClientAPI;

    function Method(aMethod: TRESTRequestMethod): IRestClientAPI;
    function Resource(aResource: string): IRestClientAPI;
    function Params: TRESTRequestParameterList;
    function AddParam_x_www_form_urlencoded(const AName, aValue: string): IRestClientAPI;
    function Body: TCustomRESTRequest.Tbody;
    function Execute(aGeraLog: boolean = true): TCustomRESTResponse;
    function Timeout(aTimeOut: integer): IRestClientAPI;

    function UserName(aUserName: string): IRestClientAPI;
    function Password(aPassword: string): IRestClientAPI;

    function SetLog(OnLog: TProc<string>): IRestClientAPI;

  public
    constructor Create();
    destructor Destroy; override;
    class function New: IRestClientAPI;
  end;

implementation

uses
  Exceptions;

{ TClasseBase }

function TRestClientAPI.AddParam_x_www_form_urlencoded(const AName, aValue: string): IRestClientAPI;
begin
  result := self;

  FRESTRequest.AddParameter(AName, aValue);
  FRESTRequest.Params[0].ContentType := TRESTContentType.ctAPPLICATION_X_WWW_FORM_URLENCODED;
end;

function TRestClientAPI.Accept(aAccept: string): IRestClientAPI;
begin
  result := self;
  FRESTClient.Accept := aAccept;
end;

function TRestClientAPI.AcceptCharset(aAcceptCharset: string): IRestClientAPI;
begin
  result := self;
  FRESTClient.AcceptCharset := aAcceptCharset;
end;

function TRestClientAPI.BaseURL(aBaseURL: string): IRestClientAPI;
begin
  result := self;
  FRESTClient.BaseURL := aBaseURL;
end;

function TRestClientAPI.Body: TCustomRESTRequest.Tbody;
begin
  result := FRESTRequest.Body;
end;

function TRestClientAPI.ContentType(aContentType: string): IRestClientAPI;
begin
  result := self;
  FRESTClient.ContentType := aContentType;
end;

function TRestClientAPI.GetHTTPBasicAuthenticator: THTTPBasicAuthenticator;
begin
  if FHTTPBasicAuthenticator = nil then
    FHTTPBasicAuthenticator := THTTPBasicAuthenticator.Create(nil);

  result := FHTTPBasicAuthenticator;
end;

constructor TRestClientAPI.Create;
begin

  Log('>>> Entrando em  TRestClientAPI.Create ');
  FHTTPBasicAuthenticator := nil;
  FRESTClient := TRestClient.Create(nil);
  FRESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  FRESTClient.BaseURL := 'http://localhost:8080';
  FRESTClient.RaiseExceptionOn500 := false;
  FRESTClient.ContentType := 'application/json';
  FRESTClient.SecureProtocols := [THTTPSecureProtocol.SSL3, THTTPSecureProtocol.TLS1, THTTPSecureProtocol.TLS11, THTTPSecureProtocol.TLS12];

  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Timeout := 10000;
  Log('<<< Saindo de TRestClientAPI.Create ');
end;

destructor TRestClientAPI.Destroy;
begin
  Log('>>> Entrando em  TRestClientAPI.Destroy ');

  FRESTRequest.DisposeOf;
  FRESTRequest := nil;

  FHTTPBasicAuthenticator.DisposeOf;
  FHTTPBasicAuthenticator := nil;

  FRESTClient.DisposeOf;
  FRESTClient := nil;
  Log('<<< Saindo de TRestClientAPI.Destroy ');
  inherited;
end;

function TRestClientAPI.Execute(aGeraLog: boolean = true): TCustomRESTResponse;
begin
  Log('>>> Entrando em  TRestClientAPI.Execute ');
  try

    Log(Format('%s%s', [FRESTClient.BaseURL, FRESTRequest.Resource]));

    FRESTClient.Authenticator := FHTTPBasicAuthenticator;
    FRESTRequest.Execute;

    Log('FRESTRequest.Response.StatusCode ' + FRESTRequest.Response.StatusCode.ToString + ' ' + FRESTRequest.Response.StatusText);
    if aGeraLog then
      Log(FRESTRequest.Response.Content);

    // if not(FRESTRequest.Response.StatusCode in [200, 201]) then
    // raise TConectionException.Create(FRESTRequest.Response.StatusText);

    result := FRESTRequest.Response;
    Log('<<< Saindo de TRestClientAPI.Execute ');
  except
    on E: Exception do
    begin
      Log(E.message);
      raise TConectionException.Create(E.message);
    end;

  end;
end;

procedure TRestClientAPI.Log(aValue: string);
begin
  if Assigned(FOnLog) then
    FOnLog(aValue);
end;

function TRestClientAPI.Method(aMethod: TRESTRequestMethod): IRestClientAPI;
begin
  result := self;
  FRESTRequest.Method := aMethod;
end;

class function TRestClientAPI.New: IRestClientAPI;
begin
  result := self.Create;
end;

function TRestClientAPI.Params: TRESTRequestParameterList;
begin
  result := FRESTRequest.Params;
end;

function TRestClientAPI.Password(aPassword: string): IRestClientAPI;
begin
  result := self;
  GetHTTPBasicAuthenticator.Password := aPassword;
end;

function TRestClientAPI.Resource(aResource: string): IRestClientAPI;
begin
  result := self;
  FRESTRequest.Resource := aResource;
end;

function TRestClientAPI.SetLog(OnLog: TProc<string>): IRestClientAPI;
begin
  result := self;
  FOnLog := OnLog;
end;

function TRestClientAPI.Timeout(aTimeOut: integer): IRestClientAPI;
begin
  result := self;
  self.FRESTRequest.Timeout := aTimeOut;
end;

function TRestClientAPI.TokenBearer(aToken: string): IRestClientAPI;
begin
  result := self;
  FRESTRequest.Params.AddItem(
    'Authorization',
    Format('Bearer %s', [aToken]),
    TRESTRequestParameterKind.pkHTTPHEADER,
    [poDoNotEncode]
    );
end;

function TRestClientAPI.UserName(aUserName: string): IRestClientAPI;
begin
  result := self;
  GetHTTPBasicAuthenticator.UserName := aUserName;
end;

end.
