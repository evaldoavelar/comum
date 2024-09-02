unit Dao.Base;

interface


uses
  System.Rtti,
  System.SysUtils,
  System.Classes,
  System.JSON,
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
  TDaoBase = class(TInterfacedObject)
  private
    FLastSql: string;
    function GetWhere<T: class>(Model: T): string; overload;
    function GetWhere<T: class>(const AParams: array of string; const AValues: array of Variant): string; overload;
    function CampoIsPk<T: class>(pks: TProperties; key: string): Boolean;

    function OnExec<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): LongInt;
    function OnGet<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): T;
    function OnToList<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): TList<T>;
    function OnObjectList<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): TObjectList<T>;
    function GetParameterFromJson(const aPair: TJSONPair): TModelCampoValor;

  protected
    FLog: ILog;
    FConnection: IConection;

  public

    procedure Log(Log: string); overload;
    procedure Log(CampoValor: TListaModelCampoValor); overload;
    procedure Log(Log: string; const Args: array of const); overload;

    property LastSql: string read FLastSql;
    property Connection: IConection read FConnection;

    function SelectALL<T: class>(): IQueryBuilder<T>; overload;
    function SelectOnly<T: class>(): IQueryBuilder<T>; overload;
    function Select<T: class>(): IQueryBuilder<T>; overload;
    function Insert<T: class>(Model: T): LongInt; overload;
    function Insert<T: class>(Model: T; aFields: TArray<string>): LongInt; overload;
    function Insert(const TableName: string; const JsonObject: TJSONObject): LongInt; overload;
    function Update<T: class>(Model: T): LongInt; overload;
    function Update<T: class>(): IQueryBuilder<T>; overload;
    function Update(const TableName: string; const aWhereClause: string; const JsonObject: TJSONObject): LongInt; overload;
    function Delete<T: class>(Model: T): LongInt; overload;
    function Delete<T: class>(): IQueryBuilder<T>; overload;

    function SQLToList<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): TList<T>; overload;
    function SQLToT<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): T; overload;
    function SQLToAdapter<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): IDaoResultAdapter<T>; overload;

    function SQLExec<T: class>(aCmd: string; aCampoValor: TListaModelCampoValor): Integer;

    function AutoIncremento(TabelaAutoIncremento, TabelaOrigem, campo: string): Integer;
    constructor Create(aConnection: IConection; aLog: ILog = nil);
    destructor destroy; override;
  end;

implementation

uses Helpers.HelperTJsonValue;

{ TDaoBase }

function TDaoBase.AutoIncremento(TabelaAutoIncremento, TabelaOrigem, campo: string): Integer;
var
  cmd: string;
  ds: TDataSet;
  inResult: Integer;
begin

  try

    try

      cmd :=
        SQL.Select
        .Column('VALOR')
        .From(TabelaAutoIncremento)
        .Where('CAMPO').Equal(TValue.From(campo))
        .&And('TABELA').Equal(TValue.From(TabelaOrigem))
        .ToString();

      ds := FConnection.Open(cmd);

      if ds.IsEmpty then
      begin

        ds.Free;
        cmd :=
          SQL.Select
          .Column('MAX(' + campo + ')').&As('PROX')
          .From(TabelaOrigem)
          .ToString();

        ds := FConnection.Open(cmd);

        if ds.IsEmpty or ds.FieldByName('PROX').IsNull then
          inResult := 1
        else
          inResult := ds.FieldByName('PROX').AsInteger + 1;

        FreeAndNil(ds);

        cmd :=
          SQL.Insert
          .Into(TabelaAutoIncremento)
          .Columns(['CAMPO', 'VALOR', 'TABELA'])
          .Values([campo, inResult, TabelaOrigem])
          .ToString();

        FConnection.ExecSQL(cmd);
      end
      else
      begin
        if ds.FieldByName('VALOR').IsNull or
          (ds.FieldByName('VALOR').AsFloat = 0) then
        begin

          FreeAndNil(ds);

          cmd :=
            SQL.Select
            .Column('MAX(' + campo + ')').&As('PROX')
            .From(TabelaOrigem)
            .ToString();

          ds := FConnection.Open(cmd);
          inResult := ds.FieldByName('PROX').AsInteger + 1;
        end
        else
          inResult := ds.FieldByName('VALOR').AsInteger + 1;

        FreeAndNil(ds);

        cmd := SQL.Update.Table(TabelaAutoIncremento)
          .Columns(['VALOR'])
          .SetValues([inResult])
          .Where('CAMPO').Equal(TValue.From(campo))
          .&And('TABELA').Equal(TValue.From(TabelaOrigem))
          .ToString();

        FConnection.ExecSQL(cmd);
      end;

      Result := inResult;

    finally
      // FreeAndNil(qry);
    end;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.AutoIncremento: Falha ao gerar ID: ' + E.Message);
  end;

end;

constructor TDaoBase.Create(aConnection: IConection; aLog: ILog = nil);
begin
  self.FConnection := aConnection;
  self.FLog := aLog;
end;

procedure TDaoBase.Log(Log: string);
begin
  if Assigned(FLog) then
    FLog.d(Log);
{$IFDEF MSWINDOWS}
  OutputDebugString(PChar(Log));
{$ENDIF}
end;

procedure TDaoBase.Log(Log: string; const Args: array of const);
begin
  if Assigned(FLog) then
    FLog.d(Log, Args);
{$IFDEF MSWINDOWS}
  OutputDebugString(PChar(Format(Log, Args)));
{$ENDIF}
end;

function TDaoBase.OnExec<T>(aCmd: string; aCampoValor: TListaModelCampoValor): LongInt;
begin
  self.Log('>>> Entrando em  TDaoBase.OnExec<T> ');
  try
    FLastSql := aCmd;

    self.Log(FLastSql);
    self.Log(aCampoValor);

    Result := FConnection.ExecSQL(FLastSql, aCampoValor);

  except
    on E: Exception do
      raise Exception.Create('TDaoBase.OnExec<T>: ' + E.Message);
  end;
  self.Log('<<< Saindo de TDaoBase.OnExec<T> ');
end;

function TDaoBase.OnGet<T>(aCmd: string; aCampoValor: TListaModelCampoValor): T;
var
  ds: TDataSet;
  cmd: string;
begin
  self.Log('>>> Entrando em  TDaoBase.OnGet<T> ');
  try
    FLastSql := aCmd;
    self.Log(FLastSql);
    self.Log(aCampoValor);

    ds := FConnection.Open(FLastSql, aCampoValor);
    if (ds.IsEmpty = false) then
      Result := TDaoDataSet<T>.New.DataSetToObject(ds)
    else
      Result := nil;

    FreeAndNil(ds);
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.OnGet<T>: ' + E.Message);
  end;
  self.Log('<<< Saindo de TDaoBase.OnGet<T> ');
end;

function TDaoBase.OnObjectList<T>(aCmd: string;
  aCampoValor: TListaModelCampoValor): TObjectList<T>;
var
  Model: T;
  ds: TDataSet;
  cmd: string;
begin
  self.Log('>>> Entrando em  TDaoBase.OnObjectList<T> ');
  try
    Result := TObjectList<T>.Create;

    FLastSql := aCmd;

    self.Log(FLastSql);
    self.Log(aCampoValor);

    ds := FConnection.Open(FLastSql, aCampoValor);

    while not ds.Eof do
    begin
      Model := TDaoDataSet<T>.New.DataSetToObject(ds);
      Result.Add(Model);
      ds.Next;
    end;

    FreeAndNil(ds);
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.OnObjectList<T>: ' + E.Message);
  end;
  self.Log('<<< Saindo de TDaoBase.OnObjectList<T> ');

end;

function TDaoBase.OnToList<T>(aCmd: string; aCampoValor: TListaModelCampoValor): TList<T>;
var
  Model: T;
  ds: TDataSet;
  cmd: string;
begin
  self.Log('>>> Entrando em  TDaoBase.OnToList<T> ');
  try
    Result := TList<T>.Create;

    FLastSql := aCmd;

    self.Log(FLastSql);
    self.Log(aCampoValor);

    ds := FConnection.Open(FLastSql, aCampoValor);

    while not ds.Eof do
    begin
      Model := TDaoDataSet<T>.New.DataSetToObject(ds);
      Result.Add(Model);
      ds.Next;
    end;

    FreeAndNil(ds);
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.OnToList<T>: ' + E.Message);
  end;
  self.Log('<<< Saindo de TDaoBase.OnToList<T> ');
end;

function TDaoBase.Delete<T>(): IQueryBuilder<T>;
var
  Delete: ISQLDelete;
  builder: TQueryBuilder<T>;
begin

  try

    Delete := SQL
      .Delete
      .From(TAtributosFuncoes.tabela<T>());

    // retornar uma query builder para o usu�rio continuar construindo a query
    builder := TQueryBuilder<T>.Create(Delete, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
    builder.OnToObjectList := self.OnObjectList<T>;
    builder.OnExec := self.OnExec<T>;

    Result := builder;

  except
    on E: Exception do
    begin
      Log('<< Select Exception');
      raise TDaoException.Create(E.Message);
    end;
  end;

end;

procedure TDaoBase.Log(CampoValor: TListaModelCampoValor);
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

destructor TDaoBase.destroy;
begin
  // FConnection.close;
  inherited;
end;

function TDaoBase.GetWhere<T>(const AParams: array of string; const AValues: array of Variant): string;
var
  Where: ISQLWhere;
  I: Integer;
begin
  Result := '';
  try
    if (Length(AParams) <> Length(AValues)) then
      raise Exception.Create('Parametros e valores devem ter o mesmo tamanho ');

    if (Length(AParams) > 0) then
    begin

      Where := SQL
        .Where(AParams[0].ToUpper).Equal(TValue.FromVariant(AValues[0]));

      for I := 1 to High(AParams) do
      begin
        Where.&And(AParams[I].ToUpper).Equal(TValue.FromVariant(AValues[I]));
      end;

      Result := Where.ToString;
    end;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.GetWhere<T>: ' + E.Message);
  end;
end;

function TDaoBase.Insert(const TableName: string; const JsonObject: TJSONObject): LongInt;
var
  Keys, Values: TStringList;
  Pair: TJSONPair;
  ValueStr: string;
  LCampoValor: TListaModelCampoValor;
begin
  Keys := TStringList.Create;
  Values := TStringList.Create;
  LCampoValor := TListaModelCampoValor.Create;

  try
    for Pair in JsonObject do
    begin
      // Adiciona a chave à lista de colunas
      Keys.Add(Pair.JsonString.Value);
      Values.Add(':' + Pair.JsonString.Value);

      if Pair.JsonValue is TJSONNull then
        LCampoValor.Add(Pair.JsonString.Value, 'null')
      else
        LCampoValor.Add(GetParameterFromJson(Pair));
    end;

    // Monta a instrução SQL INSERT
    FLastSql := Format('INSERT INTO %s (%s) VALUES (%s)', [TableName, Keys.CommaText, Values.CommaText]);

    self.Log(FLastSql);
    self.Log(LCampoValor);

    Result := self.FConnection.ExecSQL(FLastSql, LCampoValor);

  finally
    Keys.Free;
    Values.Free;
    LCampoValor.Free;
  end;

end;

function TDaoBase.Insert<T>(Model: T;
  aFields:
  TArray<string>): LongInt;
var
  props: TProperties;
  prop: TRttiProperty;
  valor: Integer;
  campo: string;
  I: Integer;
  Into: ISQLInsert;
  CampoValor: TListaModelCampoValor;
  key: string;
  sqlCmd: string;
  tabela: string;
  aTableAutoInc: string;
begin
  try
    tabela := TAtributosFuncoes.tabela<T>;
    CampoValor := TAtributosFuncoes.CampoValor<T>(Model);

    Into := SQL
      .Insert
      .Into(tabela);

    for I := Low(aFields) to High(aFields) do
    begin
      Into := Into.ColumnValue(aFields[I], ':' + aFields[I]);
    end;

    FLastSql := Into.ToString;

    self.Log(FLastSql);
    self.Log(CampoValor);

    Result := self.FConnection.ExecSQL(FLastSql, CampoValor);

    FreeAndNil(CampoValor);
  except
    on E: Exception do
    begin
      Log(' Insert Exception');
      raise TDaoException.Create(' Insert Exception: ' + E.Message);
    end;
  end;
end;

function TDaoBase.CampoIsPk<T>(pks: TProperties;
  key:
  string): Boolean;
var
  prop: TRttiProperty;
  campo: string;
begin
  try
    Result := false;
    // pecorrer as primary keys do objeto
    for prop in pks do
    begin
      // pegar o nome do campo
      campo := TAtributosFuncoes.campo<T>(prop);

      // se o campo for igual
      if key.ToUpper = campo.ToUpper then
      begin
        Result := True;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.CampoIsPk<T>: ' + E.Message);
  end;
end;

function TDaoBase.Insert<T>(Model: T): LongInt;
var
  props: TProperties;
  prop: TRttiProperty;
  valor: Integer;
  tabela: string;
  TabelaAutoInc: string;
  campo: string;
  I: Integer;
  Into: ISQLInsert;
  CampoValor: TListaModelCampoValor;
  key: string;
  sqlCmd: string;
begin

  try

    // tabela
    tabela := TAtributosFuncoes.tabela<T>;

    // pegar as propriedades anotadas com AutoInc
    props := TAtributosFuncoes.PropertieAutoInc<T>;

    for I := Low(props) to High(props) do
    begin
      TabelaAutoInc := TAtributosFuncoes.TabelaAutoInc<T>(props[I]);
      campo := TAtributosFuncoes.campo<T>(props[I]);

      self.Log('AutoIncremento: TabelaAutoInc: %s Tabela Origem:%s Campo:%s', [TabelaAutoInc, tabela, campo]);
      valor := AutoIncremento(TabelaAutoInc, tabela, campo);

      self.Log('AutoIncremento: valor:%d', [valor]);
      props[I].SetValue(TObject(Model), valor);

    end;

    CampoValor := TAtributosFuncoes.CampoValor<T>(Model);

    Into := SQL
      .Insert
      .Into(tabela);

    for key in CampoValor.Keys do
    begin
      Into := Into.ColumnValue(key, ':' + key);
    end;

    FLastSql := Into.ToString;

    self.Log(FLastSql);
    self.Log(CampoValor);

    Result := self.FConnection.ExecSQL(FLastSql, CampoValor);

    FreeAndNil(CampoValor);
  except
    on E: Exception do
    begin
      Log(' Insert Exception');
      raise TDaoException.Create(' Insert Exception: ' + E.Message);
    end;
  end;
end;

function TDaoBase.Select<T>: IQueryBuilder<T>;
var
  Select: ISQLSelect;
  builder: TQueryBuilder<T>;
begin
  try

    Select := SQL.Select;

    // retornar uma query builder para o usu�rio continuar construindo a query
    builder := TQueryBuilder<T>.Create(Select, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
    builder.OnToObjectList := self.OnObjectList<T>;
    builder.OnToAdapter := self.SQLToAdapter<T>;

    Result := builder;

  except
    on E: Exception do
    begin
      raise TDaoException.Create('Select Exception: ' + E.Message);
    end;
  end;

end;

function TDaoBase.SelectALL<T>(): IQueryBuilder<T>;
var
  Select: ISQLSelect;
  builder: TQueryBuilder<T>;
begin
  try

    Select := SQL
      .Select
      .AllColumns
      .From(TAtributosFuncoes.tabela<T>);

    // retornar uma query builder para o usu�rio continuar construindo a query
    builder := TQueryBuilder<T>.Create(Select, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
    builder.OnToObjectList := self.OnObjectList<T>;
    builder.OnToAdapter := self.SQLToAdapter<T>;
    Result := builder;

  except
    on E: Exception do
    begin
      raise TDaoException.Create('SelectALL Exception: ' + E.Message);
    end;
  end;
end;

function TDaoBase.SelectOnly<T>: IQueryBuilder<T>;
var
  Select: ISQLSelect;
  builder: TQueryBuilder<T>;
  camposAttr: TArray<CampoAttribute>;
  I: Integer;
begin
  try

    Select := SQL.Select;

    camposAttr := TAtributosFuncoes.Campos<T>();

    for I := Low(camposAttr) to High(camposAttr) do
      Select := Select.Column(camposAttr[I].campo);

    Select := Select.From(TAtributosFuncoes.tabela<T>);

    // retornar uma query builder para o usu�rio continuar construindo a query
    builder := TQueryBuilder<T>.Create(Select, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
    builder.OnToObjectList := self.OnObjectList<T>;
    builder.OnToAdapter := self.SQLToAdapter<T>;
    Result := builder;

  except
    on E: Exception do
    begin
      raise TDaoException.Create('SelectOnly Exception: ' + E.Message);
    end;
  end;

end;

function TDaoBase.SQLExec<T>(aCmd: string;
  aCampoValor:
  TListaModelCampoValor): Integer;
begin
  Result := self.OnExec<T>(aCmd, aCampoValor);
end;

function TDaoBase.SQLToList<T>(aCmd: string;
  aCampoValor:
  TListaModelCampoValor): TList<T>;
begin
  Result := self.OnToList<T>(aCmd, aCampoValor);
end;

function TDaoBase.SQLToT<T>(aCmd: string;
  aCampoValor:
  TListaModelCampoValor): T;
begin
  Result := self.OnGet<T>(aCmd, aCampoValor);
end;

function TDaoBase.GetParameterFromJson(const aPair: TJSONPair): TModelCampoValor;
begin
  if aPair.JsonValue.IsInteger then
    Result := (TModelCampoValor.Create(aPair.JsonString.Value, aPair.JsonValue.Value, varInteger))
  else if aPair.JsonValue.IsCurrency then
    Result := (TModelCampoValor.Create(aPair.JsonString.Value, aPair.JsonValue.Value, varCurrency))
  else if aPair.JsonValue.IsDouble then
    Result := (TModelCampoValor.Create(aPair.JsonString.Value, aPair.JsonValue.Value, varDouble))
  else if aPair.JsonValue.IsDate then
    Result := (TModelCampoValor.Create(aPair.JsonString.Value, aPair.JsonValue.Value, varDate))
  else
    Result := TModelCampoValor.Create(aPair.JsonString.Value, aPair.JsonValue.Value, varString);
end;

function TDaoBase.Update(const TableName: string; const aWhereClause: string; const JsonObject: TJSONObject): LongInt;
var
  UpdateList: TStringList;
  Pair: TJSONPair;
  ValueStr: string;
  LCampoValor: TListaModelCampoValor;
begin
  if JsonObject = nil then
    raise Exception.Create('JsonObject is null');

  UpdateList := TStringList.Create;
  UpdateList.Delimiter := ',';
  UpdateList.StrictDelimiter := True;
  LCampoValor := TListaModelCampoValor.Create;

  self.Log(JsonObject.ToJSON);

  try
    for Pair in JsonObject do
    begin
      // Adiciona a chave à lista de colunas
      UpdateList.Add(Format('%s = :%s', [Pair.JsonString.Value, Pair.JsonString.Value]));
      if Pair.JsonValue is TJSONNull then
        LCampoValor.Add(Pair.JsonString.Value, 'null')
      else
        LCampoValor.Add(GetParameterFromJson(Pair));
    end;

    // Monta a instrução SQL UPDATE
    if aWhereClause = EmptyStr then
      FLastSql := Format('UPDATE %s SET %s', [TableName, UpdateList.CommaText])
    else
      FLastSql := Format('UPDATE %s SET %s WHERE %s', [TableName, UpdateList.DelimitedText, aWhereClause]);

    self.Log(FLastSql);
    self.Log(LCampoValor);

    Result := self.FConnection.ExecSQL(FLastSql, LCampoValor);

  finally
    UpdateList.Free;
    LCampoValor.Free;
  end;

end;

function TDaoBase.Update<T>: IQueryBuilder<T>;
var
  Update: ISQLUpdate;
  builder: TQueryBuilder<T>;
begin

  try

    Update := SQL
      .Update
      .Table(TAtributosFuncoes.tabela<T>());

    // retornar uma query builder para o usu�rio continuar construindo a query
    builder := TQueryBuilder<T>.Create(Update, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
    builder.OnToObjectList := self.OnObjectList<T>;
    builder.OnExec := self.OnExec<T>;

    Result := builder;

  except
    on E: Exception do
    begin

      raise TDaoException.Create('Update Exception' + E.Message);
    end;
  end;

end;

function TDaoBase.GetWhere<T>(Model: T): string;
var
  pks: TProperties;
  prop: TRttiProperty;
  campo: string;
  Where: ISQLWhere;
  I: Integer;
begin
  try
    Result := '';
    // primary keys
    pks := TAtributosFuncoes.PropertiePk<T>;

    // se tem primary keys
    if (Length(pks) > 0) then
    begin
      // primeira primary key
      prop := pks[0];
      campo := TAtributosFuncoes.campo<T>(prop);
      Where := SQL.Where(campo).Equal(prop.GetValue(TObject(Model)));

      // demais primary keys
      for I := 1 to High(pks) do
      begin
        prop := pks[I];
        campo := TAtributosFuncoes.campo<T>(prop);
        Where := Where.&And(campo).Equal(prop.GetValue(TObject(Model)));
      end;

      Result := Where.ToString;
    end
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.GetWhere<T>: ' + E.Message);
  end;
end;

function TDaoBase.Delete<T>(Model: T): LongInt;
var
  tabela: string;
begin
  Log('>> Delete');
  try
    // tabela
    tabela := TAtributosFuncoes.tabela<T>;

    Log('Montando o sql: ' + tabela);
    FLastSql := SQL.Delete.From(tabela)
      .ToString +
      GetWhere<T>(Model);

    Log(FLastSql);
    Result := self.FConnection.ExecSQL(FLastSql);

    Log('<< Delete');
  except
    on E: Exception do
    begin
      Log('<< Delete Exception');
      Log(E.Message);
      raise TDaoException.Create(E.Message);
    end;
  end;
end;

function TDaoBase.Update<T>(Model: T): LongInt;
var
  pks: TProperties;
  tabela: string;
  I: Integer;
  Update: ISQLUpdate;
  CampoValor: TListaModelCampoValor;
  key: string;
  isPk: Boolean;
begin
  Log('>> Update');
  try

    // tabela
    tabela := TAtributosFuncoes.tabela<T>;

    // campos e valores
    CampoValor := TAtributosFuncoes.CampoValor<T>(Model, True);

    // primary keys
    pks := TAtributosFuncoes.PropertiePk<T>;

    Update := SQL.Update.Table(tabela);

    for key in CampoValor.Keys do
    begin

      // verificar se o campo � uma primary key
      isPk := CampoIsPk<T>(pks, key);

      // se n�o � pk
      if isPk = false then
      begin
        // coloca no update
        Update := Update.ColumnSetValue(key, ':' + key);
      end;
    end;

    FLastSql := Update.ToString +
      GetWhere<T>(Model);

    Log(FLastSql);
    self.Log(CampoValor);

    try
      Result := self.FConnection.ExecSQL(FLastSql, CampoValor);
    finally
      CampoValor.Clear;
      CampoValor.Free;
    end;

    Log('<< Update');
  except
    on E: Exception do
    begin
      Log('<< Update Exception');
      raise TDaoException.Create(E.Message);
    end;
  end;

end;

function TDaoBase.SQLToAdapter<T>(aCmd: string;
  aCampoValor:
  TListaModelCampoValor): IDaoResultAdapter<T>;
var
  ds: TDataSet;
begin
  try
    FLastSql := aCmd;

    self.Log(FLastSql);
    self.Log(aCampoValor);

    ds := FConnection.Open(FLastSql, aCampoValor);

    Result := TDaoResultAdapter<T>.New(ds);
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.SQLToAdapter<T>: ' + E.Message);
  end;
end;

end.
