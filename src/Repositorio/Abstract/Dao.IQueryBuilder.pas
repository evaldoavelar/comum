unit Dao.IQueryBuilder;

interface

uses System.Generics.Collections, SQLBuilder4D, System.Rtti,
  Dao.IResultAdapter, Model.CampoValor;

type

  IQueryBuilder<T: class> = interface
    ['{F649F94B-C9B2-4C73-8C77-C49E2D4FE48F}']

    function Get(): T;
    function ToList(): TList<T>;
    function Exec(): LongInt;
    function ToAdapter: IDaoResultAdapter<T>;
    function ToObjectList(): TObjectList<T>;
    function GetFieldValue: TListaModelCampoValor;
    function GetCMD: string;

    function AllColumns: IQueryBuilder<T>; overload;
    function Column(const pColumn: ISQLAggregate): IQueryBuilder<T>; overload;
    function Column(const pColumn: string): IQueryBuilder<T>; overload;
    function Column(const pColumn: ISQLCoalesce): IQueryBuilder<T>; overload;
    function Column(const pColumn: ISQLCase): IQueryBuilder<T>; overload;

    function SubSelect(pSelect: ISQLSelect; const pAlias: string): IQueryBuilder<T>; overload;
    function SubSelect(pWhere: ISQLWhere; const pAlias: string): IQueryBuilder<T>; overload;
    function SubSelect(pGroupBy: ISQLGroupBy; const pAlias: string): IQueryBuilder<T>; overload;
    function SubSelect(pHaving: ISQLHaving; const pAlias: string): IQueryBuilder<T>; overload;
    function SubSelect(pOrderBy: ISQLOrderBy; const pAlias: string): IQueryBuilder<T>; overload;

    function From(const pTable: string): IQueryBuilder<T>; overload;
    function From(const pTables: array of string): IQueryBuilder<T>; overload;
    function From(pSelect: IQueryBuilder<T>; const pAlias: string): IQueryBuilder<T>; overload;

    function FullJoin(const pTable, pCondition: string): IQueryBuilder<T>;
    function LeftJoin(const pTable, pCondition: string): IQueryBuilder<T>;
    function RightJoin(const pTable, pCondition: string): IQueryBuilder<T>;

    function Where(const AParams: array of string; const AValues: array of Variant): IQueryBuilder<T>; overload;
    function Where(const Column: string): IQueryBuilder<T>; overload;

    function &And(const pColumn: string): IQueryBuilder<T>; overload;
    function &And(pWhere: ISQLWhere): IQueryBuilder<T>; overload;

    function &Or(const pColumn: string): IQueryBuilder<T>; overload;
    function Equal(const pValue: Variant; isExpression: Boolean = false): IQueryBuilder<T>; overload;

    function Different(const pValue: Variant; isExpression: Boolean = false): IQueryBuilder<T>; overload;

    function Greater(const pValue: Variant; isExpression: Boolean = false): IQueryBuilder<T>; overload;

    function GreaterOrEqual(const pValue: Variant): IQueryBuilder<T>; overload;

    function Less(const pValue: Variant): IQueryBuilder<T>; overload;

    function LessOrEqual(const pValue: Variant; isExpression: Boolean = false): IQueryBuilder<T>; overload;

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
  end;

implementation

end.
