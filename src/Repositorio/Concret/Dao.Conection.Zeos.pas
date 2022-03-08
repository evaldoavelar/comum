unit Dao.Conection.Zeos;

interface

uses

  Dao.IConection,
  System.Rtti,
  System.Classes,
  System.SysUtils,
  Data.DB,
  Dao.Conection.Parametros,
  Exceptions, Database.SGDB,
  System.Generics.Collections,
  System.Variants,
  ZAbstractConnection, ZConnection,
  ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TDaoZeos = class(TInterfacedObject, IConection)

  private
    FConnection: TZConnection;
    FParametros: TConectionParametros;
    function Conexao(nova: Boolean = false): TZConnection;
    function Query(): TZQuery;
    procedure SetQueryParamns(qry: TZQuery; aNamedParamns: TDictionary<string, Variant>);
    function VariantIsEmptyOrNull(const Value: Variant): Boolean;
  public
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
  public
    constructor Create(aParametros: TConectionParametros);
    class function New(aParametros: TConectionParametros): IConection;
    destructor destroy; override;
  end;

  { TClasseBase }
implementation

/// <summary>
/// Fecha a conexão com o banco de dados
/// </summary>
procedure TDaoZeos.Close;
begin
  Self.FConnection.Disconnect;
end;

/// <summary>
/// Commita as alterações para o banco de dados
/// </summary>
procedure TDaoZeos.Commit;
begin
  Self.FConnection.Commit;
end;

/// <summary>
/// Cria e configura uma Conexao com o banco de dados
/// </summary>
/// <param name="nova">Indica se será criada uma nova instancia</param>
/// <returns>TZConnection</returns>
function TDaoZeos.Conexao(nova: Boolean = false): TZConnection;
begin
  if (FConnection = nil) or nova then
  begin
    if (not Assigned(FParametros)) then
      raise TConectionException.Create('Parametros Não Informado para a classe de conexão!');

    FConnection := TZConnection.Create(nil);

    case FParametros.SGBD of
      tpSQLite:
        begin

        end;

      tpSqlServer:
        begin
          FConnection.Protocol := 'ADO';
          FConnection.LibraryLocation := '';

          // FConnection.HostName := FParametros.Server;
          // FConnection.Database := FParametros.Database;
          // FConnection.User := FParametros.UserName;
          // FConnection.Password := FParametros.Password;

          FConnection.Database := 'Provider=SQLOLEDB.1;Password=' + FParametros.Password
            + ';Persist Security Info=True;User ID=' + FParametros.UserName
            + ';Initial Catalog=' + FParametros.Database + ';Data Source=' + FParametros.Server +
            ';Connect Timeout=60';

          FConnection.Properties.Add('timeout=120');

        end;
      tpOracle:
        begin

        end;

    end;

    FConnection.Connect();
  end;
  result := FConnection;
end;

constructor TDaoZeos.Create(aParametros: TConectionParametros);
begin
  Self.FParametros := aParametros;
end;

destructor TDaoZeos.destroy;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Disconnect;
    FreeAndNil(FConnection);
  end;
  FreeAndNil(FParametros);
  inherited;
end;

function TDaoZeos.VariantIsEmptyOrNull(const Value: Variant): Boolean;
begin
  result := VarIsClear(Value) or VarIsEmpty(Value) or VarIsNull(Value) or (VarCompareValue(Value, Unassigned) = vrEqual);
  if (not result) and VarIsStr(Value) then
    result := Value = '';
end;

/// <summary>
/// Peccorrer os parametros e seta o seu valor na TZQuery de acordo com o seu nome e tipo
/// </summary>
/// <param name="qry">TZQuery a ser parametrizada</param>
/// <param name="aNamedParamns">Lista de Parametros</param>
procedure TDaoZeos.SetQueryParamns(qry: TZQuery; aNamedParamns: TDictionary<string, Variant>);
var
  key: string;
  Value: Variant;
  basicType: Integer;
  paramIsNull: Boolean;
begin

  // pecorrrer os parametros
  for key in aNamedParamns.Keys do
  begin
    // ver se o parametro existe na query
    if qry.Params.FindParam(key) = nil then
      Continue;

    // pegar o valor do parametro
    Value := aNamedParamns.Items[key];

    paramIsNull := VarToStr(Value) = '(NULL)';

    // com o valor do parametro, verificar o seu tipo primitido
    basicType := VarType(Value) and VarTypeMask;
    case basicType of
      varEmpty:
        begin
          qry.ParamByName(key).Clear;
        end;
      varNull:
        begin
          qry.ParamByName(key).Clear;
        end;
      varSmallInt:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftSmallint;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsSmallInt := Value;
        end;
      varInteger:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftInteger;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsInteger := Value;
        end;
      varSingle:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftSingle;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsSingle := Value;
        end;
      varDouble:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftFloat;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsFloat := Value;
        end;
      varCurrency:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftCurrency;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsCurrency := Value;
        end;
      varDate:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftDate;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsDateTime := Value;
        end;
      varBoolean:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftBoolean;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsBoolean := Value;
        end;
      varVariant:
        begin
          qry.ParamByName(key).Value := Value;
        end;
      varUnknown:
        begin
          raise Exception.Create('Tipo Desconhecido por Dao.Conection');
        end;
      varByte:
        begin
          qry.ParamByName(key).AsByte := Value;
        end;
      varUString:
        begin
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftString;
            qry.ParamByName(key).Clear();
          end
          else
          begin
            qry.ParamByName(key).AsString := Value;
            // campos grandes, mudar o tipo para ftMemo
            if qry.ParamByName(key).AsString.Length > 2000 then
            begin
              qry.ParamByName(key).DataType := ftMemo;
              qry.ParamByName(key).AsMemo := Value;

            end;
          end;

        end;
      varString:
        begin
          // qry.ParamByName(key).Size := 100000;
          if paramIsNull then
          begin
            qry.ParamByName(key).DataType := TFieldType.ftString;
            qry.ParamByName(key).Clear();
          end
          else
            qry.ParamByName(key).AsString := Value;
        end;
      VarTypeMask, varArray, varByRef, varOleStr, varDispatch, varError:
        begin
          raise Exception.Create('Tipo não suportado por Dao.Conection');
        end;
    else
      begin
        qry.ParamByName(key).Value := Value;
      end;
    end;
  end;
end;

/// <summary>
/// Execulta uma instrução sql no banco de dados
/// </summary>
/// <param name="AQL">sql a ser execultada</param>
/// <param name="aNamedParamns">Parametros da sql - nome e o valor </param>
/// <returns>Numero de linhas afetadas</returns>
function TDaoZeos.ExecSQL(const ASQL: String; aNamedParamns: TDictionary<string, Variant>): LongInt;
var
  qry: TZQuery;
begin
  qry := Query();
  try

    qry.SQL.Text := ASQL;
    SetQueryParamns(qry, aNamedParamns);

    qry.ExecSQL();
    result := qry.RowsAffected;
  finally
    qry.Free;
  end;

end;

function TDaoZeos.GetSGBDType: TSGBD;
begin
  result := FParametros.SGBD;
end;

class function TDaoZeos.New(aParametros: TConectionParametros): IConection;
begin
  result := TDaoZeos.Create(aParametros);
end;

/// <summary>
/// Execulta uma instrução sql no banco de dados
/// </summary>
/// <returns>Numero de linhas afetadas</returns>
function TDaoZeos.ExecSQL(const ASQL: String): LongInt;
var
  qry: TZQuery;
begin
  try
    qry := Query();
    qry.SQL.Text := ASQL;
    qry.ExecSQL();
    result := qry.RowsAffected;
  finally
    qry.Free;
  end;
end;

/// <summary>
/// Execulta uma instrução sql no banco de dados
/// </summary>
/// <param name="AQL">sql a ser execultada</param>
/// <param name="aParams">parametros da query</param>
/// <returns>Numero de linhas afetadas</returns>
function TDaoZeos.ExecSQL(const ASQL: String; const AParams: array of Variant): LongInt;
var
  qry: TZQuery;
  I: Integer;
begin
  try
    qry := Query();
    qry.SQL.Text := ASQL;

    for I := Low(AParams) to High(AParams) do
    begin
      qry.Params[I].Value := AParams[I];
    end;
    qry.ExecSQL();
    result := qry.RowsAffected;
  finally
    qry.Free;
  end;
end;

/// <summary>
/// Execulta uma consulta sql no banco de dados e Retorna Um Dataset
/// </summary>
/// <param name="AQL">sql a ser execultada</param>
/// <returns>Dataset da consulta</returns>
function TDaoZeos.Open(const ASQL: String): TDataSet;
var
  qry: TZQuery;
begin
  qry := Query();
  qry.SQL.Text := ASQL;
  qry.Open();
  result := qry;
end;

/// <summary>
/// Execulta uma consulta sql no banco de dados e Retorna Um Dataset
/// </summary>
/// <param name="AQL">sql a ser execultada</param>
/// <param name="aParams">parametros da query</param>
/// <returns>Dataset da consulta</returns>
function TDaoZeos.Open(const ASQL: String; const AParams: array of Variant): TDataSet;
var
  qry: TZQuery;
  I: Integer;
begin
  qry := Query();
  qry.SQL.Text := ASQL;
  for I := Low(AParams) to High(AParams) do
  begin
    qry.Params[I].Value := AParams[I];
  end;
  qry.Open();
  result := qry;

end;

/// <summary>
/// Execulta uma consulta sql no banco de dados e Retorna Um Dataset
/// </summary>
/// <param name="AQL">sql a ser execultada</param>
/// <param name="aParams">parametros da query</param>
/// <param name="aTypes">Tipos dos parametros passados</param>
/// <returns>Dataset da consulta</returns>
function TDaoZeos.Open(const ASQL: String; const AParams: array of Variant; const ATypes: array of TFieldType): TDataSet;
var
  qry: TZQuery;
  I: Integer;
begin
  qry := Query();
  qry.SQL.Text := ASQL;

  for I := Low(AParams) to High(AParams) do
  begin
    qry.Params[I].DataType := ATypes[I];
    qry.Params[I].Value := AParams[I];
  end;

  qry.Open();
  result := qry;

end;

/// <summary>
/// Criar, configura e retorna uma query
/// </summary>
function TDaoZeos.Query: TZQuery;
begin
  result := TZQuery.Create(nil);
  result.Connection := Conexao;

end;

/// <summary>
/// Desfaz uma transação
/// </summary>
procedure TDaoZeos.Rollback;
begin
  Conexao.Rollback;
end;

/// <summary>
/// Inicia uma transação
/// </summary>
procedure TDaoZeos.StartTransaction;
begin
  Conexao.StartTransaction;
end;

procedure TDaoZeos.TesteConection;
begin
  Self
    .Conexao()
    .Connect();
end;

/// <summary>
/// Execulta uma consulta sql no banco de dados e Retorna Um Dataset
/// </summary>
/// <param name="AQL">sql a ser execultada</param>
/// <param name="aNamedParamns">Parametros da sql - nome e o valor </param>
/// <returns>Dataset da consulta</returns>

function TDaoZeos.Open(const ASQL: String; aNamedParamns: TDictionary<string, Variant>): TDataSet;
var
  qry: TZQuery;
begin
  qry := Query();
  qry.SQL.Text := ASQL;

  SetQueryParamns(qry, aNamedParamns);

  qry.Open();
  result := qry;
end;

end.
