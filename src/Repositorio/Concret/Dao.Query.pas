unit Dao.Query;

interface

uses
  System.Rtti,
  System.SysUtils,
  System.Classes,
  System.Variants,
  Data.DB,
  Dao.IQueryBuilder,
  Dao.TQueryBuilder,
  Dao.IConection,
  Dao.IResultAdapter,
  Dao.ResultAdapter,
  Model.Atributos.Funcoes,
  Model.Atributos,
  SQLBuilder4D,
  Exceptions,
  System.Generics.Collections,
  Log.ILog,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF}
  System.StrUtils, Dao.DataSet, Model.CampoValor;

type
  TDaoQuery = class(TInterfacedObject)
  private
    FSQL: TStringList;
    FDataSet: TDataSet;
    FParameters: TListaModelCampoValor;
    procedure Log(Log: string); overload;
    procedure Log(CampoValor: TListaModelCampoValor); overload;
    procedure Log(Log: string; const Args: array of const); overload;

  protected
    FLog: ILog;
    FConnection: IConection;
  public
    property Connection: IConection read FConnection;
    property SQL: TStringList read FSQL write FSQL;
    property Parameters: TListaModelCampoValor read FParameters write FParameters;

    function Exec: Integer; overload;
    procedure Open; overload;
    procedure Open(aString: string); overload;
    procedure Clear;
    procedure Prior;
    procedure Next;
    procedure Last;
    procedure First;
    function IsEmpty: Boolean;
    function FieldByName(const FieldName: string): TField;
    function FindField(const FieldName: string): TField;
    procedure Close;
    function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
    function Eof: Boolean;
    function FieldCount: Integer;
    function RecordCount: Integer;

  public
    constructor Create(aConnection: IConection; aLog: ILog = nil);
    destructor destroy; override;
  end;

implementation

{ TDaoQuery }

procedure TDaoQuery.Clear;
begin
  FSQL.Clear;
  FParameters.Clear;
end;

procedure TDaoQuery.Close;
begin
  FDataSet.Close;
end;

constructor TDaoQuery.Create(aConnection: IConection; aLog: ILog);
begin
  self.FConnection := aConnection;
  self.FLog := aLog;
  FSQL := TStringList.Create;
  FDataSet := TDataSet.Create(nil);
  FParameters := TListaModelCampoValor.Create;
end;

destructor TDaoQuery.destroy;
begin
  FreeAndNil(FSQL);
  FreeAndNil(FParameters);
  if Assigned(FDataSet) then
    FDataSet.Free;
  inherited;
end;

function TDaoQuery.Eof: Boolean;
begin
  result := FDataSet.Eof;
end;

function TDaoQuery.Exec: Integer;
begin
  self.Log(FSQL.Text);
  self.Log(FParameters);

  result := FConnection
    .ExecSQL(FSQL.Text, FParameters);
end;

function TDaoQuery.FieldByName(const FieldName: string): TField;
begin
  result := FDataSet.FieldByName(FieldName);
end;

function TDaoQuery.FieldCount: Integer;
begin
  result := FDataSet.FieldCount;
end;

function TDaoQuery.FindField(const FieldName: string): TField;
begin
  result := FDataSet.FindField(FieldName);
end;

procedure TDaoQuery.First;
begin
  FDataSet.First;
end;

function TDaoQuery.IsEmpty: Boolean;
begin
  result := FDataSet.IsEmpty;
end;

procedure TDaoQuery.Last;
begin
  FDataSet.Last;
end;

function TDaoQuery.Locate(const KeyFields: string; const KeyValues: Variant;
  Options: TLocateOptions): Boolean;
begin
  result := FDataSet.Locate(KeyFields, KeyValues, Options);
end;

procedure TDaoQuery.Next;
begin
  FDataSet.Next;
end;

procedure TDaoQuery.Open(aString: string);
begin
  FSQL.Text := aString;
  self.Open();
end;

procedure TDaoQuery.Prior;
begin
  FDataSet.Prior;
end;

function TDaoQuery.RecordCount: Integer;
begin
  result := self.FDataSet.RecordCount;
end;

procedure TDaoQuery.Open;
begin
  if Assigned(FDataSet) then
    FDataSet.Free;

  self.Log(FSQL.Text);
  self.Log(FParameters);

  FDataSet := FConnection
    .Open(FSQL.Text, FParameters);

end;

procedure TDaoQuery.Log(CampoValor: TListaModelCampoValor);
var
  builder: TStringBuilder;
  key: string;
begin
  try

    builder := TStringBuilder.Create;

    for key in CampoValor.Keys do
    begin
      if (CampoValor.Items[key].Value = null) then
        builder.AppendFormat(' %s = null ', [key])
      else
        builder.AppendFormat(' %s = %s ', [key, VarToStr(CampoValor.Items[key].Value)]);
    end;

    if Assigned(FLog) then
    begin
      FLog.d(builder.ToString());
    end;

{$IFDEF MSWINDOWS}
    OutputDebugString(PChar(builder.ToString()));
{$ENDIF}
    FreeAndNil(builder);

  except
    on E: Exception do
    begin
      if Assigned(FLog) then
        FLog.d(E.Message);
    end;
  end;
end;

procedure TDaoQuery.Log(Log: string);
begin
  if Assigned(FLog) then
    FLog.d(Log);
{$IFDEF MSWINDOWS}
  OutputDebugString(PChar(Log));
{$ENDIF}
end;

procedure TDaoQuery.Log(Log: string; const Args: array of const);
begin
  if Assigned(FLog) then
    FLog.d(Log, Args);
{$IFDEF MSWINDOWS}
  OutputDebugString(PChar(Format(Log, Args)));
{$ENDIF}
end;

end.
