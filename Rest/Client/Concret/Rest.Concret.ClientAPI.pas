unit Rest.Concret.ClientAPI;

interface

uses Rest.Abstract.ClientAPI,
  Rest.Client, Rest.types,
{$IF DECLARED(FireMonkeyVersion)}
  FMX.types,
{$ENDIF}
  system.sysutils,
  Rest.Authenticator.Basic;

type

  TRestClientAPI = class(TInterfacedObject, IRestClientAPI)
  protected
    FRESTClient: TRestClient;
    FHTTPBasicAuthenticator: THTTPBasicAuthenticator;
    FRESTRequest: TRESTRequest;
    procedure Log(aValue: string);
  public

    function BaseURL(aBaseURL: string): IRestClientAPI;
    function Accept(aAccept: string): IRestClientAPI;
    function AcceptCharset(aAcceptCharset: string): IRestClientAPI;
    function ContentType(aContentType: string): IRestClientAPI;

    function Method(aMethod: TRESTRequestMethod): IRestClientAPI;
    function Resource(aResource: string): IRestClientAPI;
    function Params: TRESTRequestParameterList;
    function Body: TCustomRESTRequest.Tbody;
    function Execute: TCustomRESTResponse;
    function Timeout(aTimeOut: integer): IRestClientAPI;

    function UserName(aUserName: string): IRestClientAPI;
    function Password(aPassword: string): IRestClientAPI;

  public
    constructor Create();
    destructor Destroy; override;
    class function New: IRestClientAPI;
  end;

implementation

uses
  Exceptions;

{ TClasseBase }

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

constructor TRestClientAPI.Create;
begin

  Log('>>> Entrando em  TRestClientAPI.Create ');
  FHTTPBasicAuthenticator := THTTPBasicAuthenticator.Create(nil);

  FRESTClient := TRestClient.Create(nil);
  FRESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  FRESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  FRESTClient.BaseURL := 'http://localhost:8080';
  FRESTClient.RaiseExceptionOn500 := false;
  FRESTClient.ContentType := 'application/json';

  FRESTClient.Authenticator := FHTTPBasicAuthenticator;

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

function TRestClientAPI.Execute: TCustomRESTResponse;
begin
  Log('>>> Entrando em  TRestClientAPI.Execute ');
  try

    FRESTRequest.Execute;

    Log('FRESTRequest.Response.StatusCode ' + FRESTRequest.Response.StatusCode.ToString + ' ' + FRESTRequest.Response.StatusText);
    Log(FRESTRequest.Response.Content);

   // if not(FRESTRequest.Response.StatusCode in [200, 201]) then
    //  raise TConectionException.Create(FRESTRequest.Response.StatusText);

    result := FRESTRequest.Response;
    Log('<<< Saindo de TRestClientAPI.Execute ');
  except
    on E: Exception do
    begin
      Log(E.message);
      raise TConectionException.Create(e.Message);
    end;

  end;
end;

procedure TRestClientAPI.Log(aValue: string);
begin

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
  FHTTPBasicAuthenticator.Password := aPassword;
end;

function TRestClientAPI.Resource(aResource: string): IRestClientAPI;
begin
  result := self;
  FRESTRequest.Resource := aResource;
end;

function TRestClientAPI.Timeout(aTimeOut: integer): IRestClientAPI;
begin
  result := self;
  self.FRESTRequest.Timeout := aTimeOut;
end;

function TRestClientAPI.UserName(aUserName: string): IRestClientAPI;
begin
  result := self;
  FHTTPBasicAuthenticator.UserName := aUserName;
end;

end.
