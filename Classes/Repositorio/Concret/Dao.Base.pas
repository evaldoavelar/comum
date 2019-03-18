unit Dao.Base;

interface


uses
  System.Rtti,
  System.SysUtils, System.Classes, System.Variants,
  Data.DB, Dao.IQueryBuilder, Dao.TQueryBuilder,
  Dao.IConection, Model.Atributos.Funcoes,
  SQLBuilder4D, Exceptions,
  System.Generics.Collections, Log.ILog;

type
  TDaoBase = class(TInterfacedObject)
  private
    FLastSql: string;
    function GetWhere<T: class>(Model: T): string; overload;
    function GetWhere<T: class>(const AParams: array of string; const AValues: array of Variant): string; overload;
    function CampoIsPk<T: class>(pks: TProperties; key: string): Boolean;

    function OnExec<T: class>(aCmd: string; aCampoValor: TDictionary<string, Variant>): LongInt;
    function OnGet<T: class>(aCmd: string; aCampoValor: TDictionary<string, Variant>): T;
    function OnToList<T: class>(aCmd: string; aCampoValor: TDictionary<string, Variant>): TList<T>;

    function DataSetToObject<T: class>(ds: TDataSet): T;
    function CreateInstance<T: class>: T;

  protected
    FLog: ILog;
    FConnection: IConection;
    function AutoIncremento(TabelaAutoIncremento, TabelaOrigem, campo: string): Integer;

    procedure Log(Log: string); overload;
    procedure Log(CampoValor: TDictionary<string, Variant>); overload;
    procedure Log(Log: string; const Args: array of const); overload;

  public

    property LastSql: string read FLastSql;

    function SelectALL<T: class>(): IQueryBuilder<T>; overload;
    function Select<T: class>(): IQueryBuilder<T>; overload;
    function Insert<T: class>(Model: T): LongInt;
    function Update<T: class>(Model: T): LongInt; overload;
    function Update<T: class>(): IQueryBuilder<T>; overload;
    function Delete<T: class>(Model: T): LongInt; overload;
    function Delete<T: class>(): IQueryBuilder<T>; overload;

    function SQLToList<T: class>(aCmd: string; aCampoValor: TDictionary<string, Variant>): TList<T>;

    constructor Create(aConnection: IConection; aLog: ILog = nil);
    destructor destroy; override;
  end;

implementation

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
end;

procedure TDaoBase.Log(Log: string; const Args: array of const);
begin
  if Assigned(FLog) then
    FLog.d(Log, Args);

end;

function TDaoBase.OnExec<T>(aCmd: string; aCampoValor: TDictionary<string, Variant>): LongInt;
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

function TDaoBase.OnGet<T>(aCmd: string; aCampoValor: TDictionary<string, Variant>): T;
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
      Result := self.DataSetToObject<T>(ds)
    else
      Result := nil;

    FreeAndNil(ds);
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.OnGet<T>: ' + E.Message);
  end;
  self.Log('<<< Saindo de TDaoBase.OnGet<T> ');
end;

function TDaoBase.OnToList<T>(aCmd: string; aCampoValor: TDictionary<string, Variant>): TList<T>;
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
      Model := self.DataSetToObject<T>(ds);
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

function TDaoBase.CreateInstance<T>: T;
var
  AValue: TValue;
  ctx: TRttiContext;
  rType: TRttiType;
  AMethCreate: TRttiMethod;
  instanceType: TRttiInstanceType;
begin

  try
    ctx := TRttiContext.Create;
    rType := ctx.GetType(TypeInfo(T));
    for AMethCreate in rType.GetMethods do
    begin
      if (AMethCreate.IsConstructor) and (Length(AMethCreate.GetParameters) = 0) then
      begin
        instanceType := rType.AsInstance;

        AValue := AMethCreate.Invoke(instanceType.MetaclassType, []);

        Result := AValue.AsType<T>;

        Exit;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.CreateInstance<T>: ' + E.Message);
  end;

end;

function TDaoBase.DataSetToObject<T>(ds: TDataSet): T;
var
  context: TRttiContext;
  rType: TRttiType;
  method: TRttiMethod;
  prop: TRttiProperty;
  Field: TField;
  Entity: T;
  campo: string;
begin

  try

    context := TRttiContext.Create;
    rType := context.GetType(T.ClassInfo);

    Entity := CreateInstance<T>();

    for prop in rType.GetProperties do
    begin

      if prop.IsWritable then
      begin
        // pegar o campo corresponte a property
        campo := TAtributosFuncoes.campo<T>(prop);

        // procurar o campo  no dataset
        Field := ds.Fields.FindField(campo);
        if Field <> nil then
        begin
          try

            if (CompareText('string', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsString)
            else if (CompareText('Char', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsString)
            else if (CompareText('TDateTime', prop.PropertyType.Name)) = 0 then
            begin
              if (Field.IsNull = false) or (Field.AsString <> '' ) then
                prop.SetValue(TObject(Entity), Field.AsDateTime)
              else
                prop.SetValue(TObject(Entity), 0)
            end
            else if (CompareText('TDate', prop.PropertyType.Name)) = 0 then
            begin
              if Field.IsNull = false then
                prop.SetValue(TObject(Entity), Field.AsDateTime)
              else
                prop.SetValue(TObject(Entity), 0);
            end
            else if (CompareText('TTime', prop.PropertyType.Name)) = 0 then
            begin
              if Field.IsNull = false then
                prop.SetValue(TObject(Entity), Field.AsDateTime)
              else
                prop.SetValue(TObject(Entity), 0);
            end
            else if (CompareText('Boolean', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsBoolean)
            else if (CompareText('Currency', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsCurrency)
            else if (CompareText('Double', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsFloat)
            else if (CompareText('Integer', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsInteger)
            else if (CompareText('SmallInt', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsInteger)
            else
              prop.SetValue(TObject(Entity), TValue.FromVariant(Field.Value));

          except
            on E: Exception do
            begin
              raise Exception.Create('SetValue: prop.PropertyType.Name=' + prop.PropertyType.Name
                + ' FieldName=' + Field.FieldName + ' - '
                + E.Message);
            end;
          end;
        end;

      end;
    end;

    Result := Entity;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.DataSetToObject: ' + E.Message);
  end;

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

    // retornar uma query builder para o usuário continuar construindo a query
    builder := TQueryBuilder<T>.Create(Delete, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
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

procedure TDaoBase.Log(CampoValor: TDictionary<string, Variant>);
var
  builder: TStringBuilder;
  key: string;
begin
  try
    if Assigned(FLog) then
    begin
      builder := TStringBuilder.Create;

      for key in CampoValor.Keys do
      begin
        builder.AppendFormat(' %s = %s ', [key, VarToStr(CampoValor.Items[key])]);
      end;

      FLog.d(builder.ToString());

      FreeAndNil(builder);
    end;
  except
    on E: Exception do
      FLog.d(E.Message);
  end;
end;

destructor TDaoBase.destroy;
begin
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

function TDaoBase.CampoIsPk<T>(pks: TProperties; key: string): Boolean;
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
  CampoValor: TDictionary<string, Variant>;
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

    // retornar uma query builder para o usuário continuar construindo a query
    builder := TQueryBuilder<T>.Create(Select, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;

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

    // retornar uma query builder para o usuário continuar construindo a query
    builder := TQueryBuilder<T>.Create(Select, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;

    Result := builder;

  except
    on E: Exception do
    begin
      raise TDaoException.Create('SelectALL Exception: ' + E.Message);
    end;
  end;
end;

function TDaoBase.SQLToList<T>(aCmd: string; aCampoValor: TDictionary<string, Variant>): TList<T>;
begin
  Result := self.OnToList<T>(aCmd, aCampoValor);
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

    // retornar uma query builder para o usuário continuar construindo a query
    builder := TQueryBuilder<T>.Create(Update, self.FConnection);
    builder.OnGet := self.OnGet<T>;
    builder.OnToList := self.OnToList<T>;
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
  CampoValor: TDictionary<string, Variant>;
  key: string;
  isPk: Boolean;
begin
  Log('>> Update');
  try

    // tabela
    tabela := TAtributosFuncoes.tabela<T>;

    // campos e valores
    CampoValor := TAtributosFuncoes.CampoValor<T>(Model);

    // primary keys
    pks := TAtributosFuncoes.PropertiePk<T>;

    Update := SQL.Update.Table(tabela);

    for key in CampoValor.Keys do
    begin

      // verificar se o campo é uma primary key
      isPk := CampoIsPk<T>(pks, key);

      // se não é pk
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

end.
