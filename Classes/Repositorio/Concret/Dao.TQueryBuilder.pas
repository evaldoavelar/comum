unit Dao.TQueryBuilder;

interface

uses
  Data.DB, System.Classes, System.Generics.Collections, System.Rtti,
  System.SysUtils, Dao.IConection, SQLBuilder4D, Dao.IQueryBuilder,
  Model.Atributos.Funcoes;

type

  TQueryBuilder<T: class> = class(TInterfacedObject, IQueryBuilder<T>)
  public
    type
    TOnGet = function(aCmd: string; aCampoValor: TDictionary<string, Variant>): T of object;
    TOnExec = function(aCmd: string; aCampoValor: TDictionary<string, Variant>): Integer of object;
    TOnToList = function(aCmd: string; aCampoValor: TDictionary<string, Variant>): TList<T> of object;

  private
    FSQLSelect: ISQLSelect;
    FSQLDelete: ISQLDelete;
    FConn: IConection;
    FSQLWhere: ISQLWhere;
    FSQLUpdate: ISQLUpdate;
    FSQLOrderBy: ISQLOrderBy;
    FColumn: string;
    FCampoValor: TDictionary<string, Variant>;
    FOnGet: TOnGet;
    FOnToList: TOnToList;
    FOnExec: TOnExec;

    function VariantToISQLValue(const pValue: Variant): ISQLValue;
    function ReturnParamName(aColumn: string): string;
    procedure Inicilize(aConn: IConection);

  public
    property OnGet: TOnGet read FOnGet write FOnGet;
    property OnExec: TOnExec read FOnExec write FOnExec;
    property OnToList: TOnToList read FOnToList write FOnToList;
  public
    function Get(): T;
    function ToList(): TList<T>;
    function Exec(): LongInt;

    function From(const pTable: string): IQueryBuilder<T>; overload;
    function From(const pTables: array of string): IQueryBuilder<T>; overload;

    function AllColumns: IQueryBuilder<T>; overload;
    function Column(const pColumn: ISQLAggregate): IQueryBuilder<T>; overload;
    function Column(const pColumn: string): IQueryBuilder<T>; overload;
    function Column(const pColumn: ISQLCoalesce): IQueryBuilder<T>; overload;
    function Column(const pColumn: ISQLCase): IQueryBuilder<T>; overload;

    function Where(const AParams: array of string; const AValues: array of Variant): IQueryBuilder<T>; overload;
    function Where(const pColumn: string): IQueryBuilder<T>; overload;

    function &And(const pColumn: string): IQueryBuilder<T>; overload;

    function &Or(const pColumn: string): IQueryBuilder<T>; overload;
    function Equal(const pValue: Variant; isParam: Boolean = True): IQueryBuilder<T>; overload;

    function Different(const pValue: Variant; isParam: Boolean = True): IQueryBuilder<T>; overload;

    function Greater(const pValue: Variant): IQueryBuilder<T>; overload;

    function GreaterOrEqual(const pValue: Variant): IQueryBuilder<T>; overload;

    function Less(const pValue: Variant): IQueryBuilder<T>; overload;

    function LessOrEqual(const pValue: Variant): IQueryBuilder<T>; overload;

    function FullJoin(const pTable, pCondition: string): IQueryBuilder<T>;
    function LeftJoin(const pTable, pCondition: string): IQueryBuilder<T>;
    function RightJoin(const pTable, pCondition: string): IQueryBuilder<T>;

    function Like(const pValue: string; const pOp: TSQLLikeOperator = loEqual): IQueryBuilder<T>; overload;
    function Like(const pValues: array of string; const pOp: TSQLLikeOperator = loEqual): IQueryBuilder<T>; overload;

    function NotLike(const pValue: string; const pOp: TSQLLikeOperator = loEqual): IQueryBuilder<T>; overload;
    function NotLike(const pValues: array of string; const pOp: TSQLLikeOperator = loEqual): IQueryBuilder<T>; overload;

    function IsNull(): IQueryBuilder<T>;
    function IsNotNull(): IQueryBuilder<T>;

    function InList(const pValues: array of TValue): IQueryBuilder<T>; overload;

    function NotInList(const pValues: array of TValue): IQueryBuilder<T>; overload;
    function NotIn(const pValues: string): IQueryBuilder<T>; overload;

    function Between(const pStart, pEnd: Variant): IQueryBuilder<T>; overload;

    function OrderBy(const AParams: array of string; aSort: TSQLSort): IQueryBuilder<T>; overload;
    function OrderBy(const AParams: array of string): IQueryBuilder<T>; overload;
    function OrderBy(const AParam: string): IQueryBuilder<T>; overload;

    function ColumnSetValue(const pColumn: string; const pValue: Variant): IQueryBuilder<T>; overload;

  public

    constructor Create(var aSqlBase: ISQLSelect; aConn: IConection); overload;
    constructor Create(var aSqlBase: ISQLUpdate; aConn: IConection); overload;
    constructor Create(var aSqlBase: ISQLDelete; aConn: IConection); overload;
    destructor destroy; override;

  end;

implementation

{ TPrepared<T> }

function TQueryBuilder<T>.&And(const pColumn: string): IQueryBuilder<T>;
begin
  FColumn := pColumn;
  FSQLWhere := FSQLWhere.&And(pColumn);
  result := Self;
end;

function TQueryBuilder<T>.Between(const pStart, pEnd: Variant): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.Between(VariantToISQLValue(pEnd), VariantToISQLValue(pEnd));
  result := Self;
end;

function TQueryBuilder<T>.&Or(const pColumn: string): IQueryBuilder<T>;
begin
  FColumn := pColumn;
  FSQLWhere := FSQLWhere.&Or(pColumn);
  result := Self;
end;

function TQueryBuilder<T>.ColumnSetValue(const pColumn: string; const pValue: Variant): IQueryBuilder<T>;
begin
  if FSQLUpdate = nil then
    raise Exception.Create('FSQLUpdate não foi inicializado!');

  result := Self;
  FColumn := pColumn;
  FSQLUpdate := FSQLUpdate.ColumnSetValue(FColumn, VariantToISQLValue(pValue));

end;

constructor TQueryBuilder<T>.Create(var aSqlBase: ISQLSelect; aConn: IConection);
begin
  FSQLSelect := aSqlBase;
  Inicilize(aConn);
end;

constructor TQueryBuilder<T>.Create(var aSqlBase: ISQLUpdate; aConn: IConection);
begin
  FSQLUpdate := aSqlBase;
  Inicilize(aConn);
end;

constructor TQueryBuilder<T>.Create(var aSqlBase: ISQLDelete; aConn: IConection);
begin
  FSQLDelete := aSqlBase;
  Inicilize(aConn);
end;

procedure TQueryBuilder<T>.Inicilize(aConn: IConection);
begin
  FConn := aConn;
  FCampoValor := TDictionary<string, Variant>.Create();
  // FSQLWhere := SQL.Where;
end;

function TQueryBuilder<T>.Get: T;
var
  cmd: string;
begin
  cmd := FSQLSelect.ToString ;


  if (Assigned(FSQLWhere)) then
    cmd := cmd + FSQLWhere.ToString;

  result := OnGet(cmd, FCampoValor);
end;

function TQueryBuilder<T>.Greater(const pValue: Variant): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.Greater(VariantToISQLValue(pValue));
  result := Self;
end;

/// <summary>
/// Cria um nome unico para o parametro
/// </summary>
function TQueryBuilder<T>.ReturnParamName(aColumn: string): string;
var
  paramName: string;
  Cont: Integer;
begin
  Cont := 1;

  paramName := aColumn;
  while FCampoValor.ContainsKey(paramName) = True do
  begin
    paramName := aColumn + Cont.ToString;
    Inc(Cont);
  end;

  result := paramName;

end;

function TQueryBuilder<T>.RightJoin(const pTable, pCondition: string): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.RightJoin(pTable, pCondition);
  result := Self;
end;

/// <summary>
/// Da o nome ao parametro e armazena seu valor
/// </summary>
/// <param name="pValue">Parametro</param>
function TQueryBuilder<T>.VariantToISQLValue(const pValue: Variant): ISQLValue;
var
  Value: ISQLValue;
  paramName: string;
begin

  paramName := ReturnParamName(FColumn);

  Value := SQL.Value(':' + paramName);
  Value.Expression.IsColumn;

  FCampoValor.Add(paramName, pValue);

  result := Value;
end;

function TQueryBuilder<T>.GreaterOrEqual(const pValue: Variant): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.GreaterOrEqual(VariantToISQLValue(pValue));
  result := Self;
end;

function TQueryBuilder<T>.InList(const pValues: array of TValue): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.InList(pValues);
  result := Self;
end;

function TQueryBuilder<T>.IsNotNull: IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.IsNotNull;
  result := Self;
end;

function TQueryBuilder<T>.IsNull: IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.IsNull;
  result := Self;
end;

function TQueryBuilder<T>.LeftJoin(const pTable, pCondition: string): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.LeftJoin(pTable, pCondition);
  result := Self;
end;

function TQueryBuilder<T>.Less(const pValue: Variant): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.Less(VariantToISQLValue(pValue));
  result := Self;
end;

function TQueryBuilder<T>.LessOrEqual(const pValue: Variant): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.LessOrEqual(VariantToISQLValue(pValue));
  result := Self;
end;

function TQueryBuilder<T>.Like(const pValues: array of string; const pOp: TSQLLikeOperator): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.Like(pValues, pOp);
  result := Self;
end;

function TQueryBuilder<T>.Like(const pValue: string; const pOp: TSQLLikeOperator): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.Like(VariantToISQLValue(pValue));
  result := Self;
end;

function TQueryBuilder<T>.NotIn(const pValues: string): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere
  .NotIn(pValues ) ;

  result := Self;
end;

function TQueryBuilder<T>.NotInList(const pValues: array of TValue): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.NotInList(pValues);
  result := Self;
end;

function TQueryBuilder<T>.NotLike(const pValues: array of string; const pOp: TSQLLikeOperator): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.NotLike(pValues, pOp);
  result := Self;
end;

function TQueryBuilder<T>.NotLike(const pValue: string; const pOp: TSQLLikeOperator): IQueryBuilder<T>;
begin
  FSQLWhere := FSQLWhere.NotLike(pValue);
  result := Self;
end;

function TQueryBuilder<T>.OrderBy(const AParams: array of string): IQueryBuilder<T>;
begin
  result := OrderBy(AParams, TSQLSort.srNone);
end;

function TQueryBuilder<T>.OrderBy(const AParams: array of string; aSort: TSQLSort): IQueryBuilder<T>;
begin
  FSQLOrderBy := SQL
    .OrderBy(AParams, aSort);

  result := Self;
end;

function TQueryBuilder<T>.OrderBy(const AParam: string): IQueryBuilder<T>;
begin
  result := OrderBy([AParam], TSQLSort.srNone);
end;

function TQueryBuilder<T>.Where(const AParams: array of string; const AValues: array of Variant): IQueryBuilder<T>;
var
  I: Integer;
begin

  if (Length(AParams) <> Length(AValues)) then
    raise Exception.Create('Parametros e valores devem ter o mesmo tamanho ');

  if (Length(AParams) > 0) then
  begin

    FSQLWhere := SQL
      .Where(AParams[0].ToUpper).Equal(TValue.FromVariant(AValues[0]));

    for I := 1 to High(AParams) do
    begin
      FSQLWhere.&And(AParams[I].ToUpper).Equal(TValue.FromVariant(AValues[I]));
    end;
  end;

  result := Self;
end;

function TQueryBuilder<T>.ToList: TList<T>;
var
  cmd: string;
begin

  cmd := FSQLSelect.ToString;

  if (Assigned(FSQLWhere)) then
    cmd := cmd + FSQLWhere.ToString;

  if (Assigned(FSQLOrderBy)) then
    cmd := cmd + FSQLOrderBy.ToString;

  result := Self.OnToList(cmd, FCampoValor);
end;

function TQueryBuilder<T>.Where(const pColumn: string): IQueryBuilder<T>;
begin
  FColumn := pColumn;
  FSQLWhere := SQL.Where;
  FSQLWhere := FSQLWhere.Column(pColumn);
  result := Self;
end;

destructor TQueryBuilder<T>.destroy;
begin
  FreeAndNil(FCampoValor);
  inherited;
end;

function TQueryBuilder<T>.Different(const pValue: Variant; isParam: Boolean = True): IQueryBuilder<T>;
begin
 if isParam then
  FSQLWhere := FSQLWhere.Different(VariantToISQLValue(pValue))
  else
    FSQLWhere := FSQLWhere.Different(TValue.FromVariant(pValue));
  result := Self;
end;

function TQueryBuilder<T>.Equal(const pValue: Variant; isParam: Boolean = True): IQueryBuilder<T>;
begin
  if isParam then
    FSQLWhere := FSQLWhere.Equal(VariantToISQLValue(pValue))
  else
    FSQLWhere := FSQLWhere.Equal(pValue);

  result := Self;
end;

function TQueryBuilder<T>.Exec: LongInt;
var
  cmd: string;
begin

  if Assigned(FSQLUpdate) then
    cmd := FSQLUpdate.ToString
  else if Assigned(FSQLDelete) then
    cmd := FSQLDelete.ToString
  else
    raise Exception.Create('FSQLUpdate or FSQLDelete não informados!');

  if (Assigned(FSQLWhere)) then
    cmd := cmd + FSQLWhere.ToString;

  result := Self.OnExec(cmd, FCampoValor);
end;

function TQueryBuilder<T>.Column(const pColumn: ISQLAggregate): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.Column(pColumn);
  result := Self;
end;

function TQueryBuilder<T>.Column(const pColumn: ISQLCoalesce): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.Column(pColumn);
  result := Self;
end;

function TQueryBuilder<T>.Column(const pColumn: string): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.Column(pColumn);
  result := Self;
end;

function TQueryBuilder<T>.AllColumns: IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.AllColumns();
  result := Self;
end;

function TQueryBuilder<T>.From(const pTables: array of string): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.From(pTables);
  result := Self;

end;

function TQueryBuilder<T>.FullJoin(const pTable, pCondition: string): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.FullJoin(pTable, pCondition);
  result := Self;
end;

function TQueryBuilder<T>.From(const pTable: string): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.From(pTable);
  result := Self;
end;

function TQueryBuilder<T>.Column(const pColumn: ISQLCase): IQueryBuilder<T>;
begin
  FSQLSelect := FSQLSelect.Column(pColumn);
  result := Self;
end;

end.
