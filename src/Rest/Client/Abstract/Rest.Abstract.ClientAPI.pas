unit Rest.Abstract.ClientAPI;

interface

uses
  Rest.Client, Rest.types,
  Rest.Authenticator.Basic;

type
  IRestClientAPI = interface
    function BaseURL(aBaseURL: string): IRestClientAPI;
    function Accept(aAccept: string): IRestClientAPI;
    function AcceptCharset(aAcceptCharset: string): IRestClientAPI;
    function ContentType(aContentType: string): IRestClientAPI;
    function TokenBearer(aToken: string): IRestClientAPI;

    function Method(aMethod: TRESTRequestMethod): IRestClientAPI;
    function Resource(aResource: string): IRestClientAPI;
    function AddParam_x_www_form_urlencoded(const AName, aValue: string): IRestClientAPI;
    function Params: TRESTRequestParameterList;
    function Body: TCustomRESTRequest.Tbody;
    function Execute(aGeraLog: boolean = true): TCustomRESTResponse;

    function UserName(aUserName: string): IRestClientAPI;
    function Password(aPassword: string): IRestClientAPI;
    function TimeOut(aTimeOut: integer): IRestClientAPI;

  end;

implementation

end.
