unit Model.Atributos.Funcoes;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Rtti,
  Model.Atributos,
  Model.Atributos.Tipos,
  Model.IModelBase,
  Model.CampoValor,
  System.Variants,
  System.StrUtils,
  Utils.Funcoes;

type

  TProperties = array of TRttiProperty;

  TAtributosFuncoes = class
  private
    class function indexOfAttribute(prop: TRttiObject; Attribute: TClass): TCustomAttribute;
    class function GetPropertyByCampo(aCampo: string; properties: TArray<TRttiProperty>): TRttiProperty;
    class function SetTypeVariant(value: Variant; prop: TRttiProperty): Variant; static;
    class function GetPropertyValue<T: class>(Model: T; aProp: TRttiProperty): Variant; static;
    class function PropertyInNullableValue(aProp: TRttiProperty): Boolean; static;
    class function GetPropertyTypeString(aValue: TValue; aProp: TRttiProperty): string; static;
    class function GetTypeVariant(aValue: TValue; aProp: TRttiProperty): TVarType; static;

  public
    class function Tabela<T: class>: string; static;
    class function PropertieAutoInc<T: class>: TProperties; static;
    class function PropertiePk<T: class>: TProperties; static;
    class function TabelaAutoInc<T: class>(prop: TRttiProperty): string; static;
    class function Campo<T: class>(prop: TRttiProperty): string; static;
    class function CampoValor<T: class>(Model: T): TListaModelCampoValor; overload; static;
    class function CampoValor<T: class>(Model: T; ValidaForeinkey: Boolean): TListaModelCampoValor; overload; static;

  end;

implementation

{ TModelHelper }

class function TAtributosFuncoes.PropertieAutoInc<T>: TProperties;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  prop: TRttiProperty;
  index: integer;
begin
  try

    Rtti := TRttiContext.create;
    ltype := Rtti.GetType(TypeInfo(T));
    index := 0;

    // pecorrer as propriedades
    for prop in ltype.GetProperties do
    begin
      // verificar se apropriedade esta anotada com AutoInc
      if (indexOfAttribute(prop, AutoIncAttribute) <> nil) then
      begin
        SetLength(Result, index + 1);
        Result[index] := prop;

        Inc(index);
      end;
    end;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.PropertieAutoInc<T>: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.PropertiePk<T>: TProperties;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  prop: TRttiProperty;
  propPk: TRttiProperty;
  index: integer;
  attr: TCustomAttribute;
  columns: TArray<string>;
  I: integer;
begin
  try
    Rtti := TRttiContext.create;
    ltype := Rtti.GetType(TypeInfo(T));
    index := 0;

    // pecorrer as propriedades
    for prop in ltype.GetProperties do
    begin
      // verificar se a propriedade esta anotada com PrimaryKey
      attr := indexOfAttribute(prop, PrimaryKeyAttribute);

      if (attr <> nil) then
      begin
        // pegar as colunas anotadas na primary key
        columns := PrimaryKeyAttribute(attr).columns;

        // para cada coluna, pegar a propertie
        for I := Low(columns) to High(columns) do
        begin

          // pegar a propertie correspondente a coluna
          propPk := GetPropertyByCampo(columns[I], ltype.GetProperties);

          if (propPk = nil) then
            raise Exception.create('Composição da Primary key: Nenhuma propriedade anotada com ' + columns[I]);

          index := Length(Result);
          SetLength(Result, index + 1);
          Result[index] := propPk;
        end;

      end;
    end;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.PropertiePk<T>: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.GetTypeVariant(aValue: TValue; aProp: TRttiProperty): TVarType;
var
  LPropName: string;
begin

  LPropName := GetPropertyTypeString(aValue, aProp);

  Result := varVariant;
  if (CompareText('String', LPropName)) = 0 then
    Result := varString;
  if (CompareText('TDateTime', LPropName)) = 0 then
    Result := varDate
  else if (CompareText('TDate', LPropName)) = 0 then
    Result := varDate
  else if (CompareText('TTime', LPropName)) = 0 then
    Result := varDate
  else if (CompareText('Boolean', LPropName)) = 0 then
    Result := varBoolean
  else if (CompareText('Currency', LPropName)) = 0 then
    Result := varCurrency
  else if (CompareText('Integer', LPropName)) = 0 then
    Result := varInteger
  else if (CompareText('Smallint', LPropName)) = 0 then
    Result := varSmallint
  else if (CompareText('Double', LPropName)) = 0 then
    Result := varDouble;

end;

class function TAtributosFuncoes.SetTypeVariant(value: Variant; prop: TRttiProperty): Variant;
begin
  Result := value;

  // if (CompareText('string', prop.PropertyType.Name)) = 0 then
  // BEGIN
  // TVarData(Result).vType := varString;
  //
  // END ELSE
  if (CompareText('TDateTime', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varDate
  else if (CompareText('TDate', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varDate
  else if (CompareText('TTime', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varDate
  else if (CompareText('Boolean', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varBoolean
  else if (CompareText('Currency', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varCurrency
  else if (CompareText('Integer', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varInteger
  else if (CompareText('Smallint', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varSmallint
  else if (CompareText('Double', prop.PropertyType.Name)) = 0 then
    TVarData(Result).vType := varDouble;

end;

class function TAtributosFuncoes.CampoValor<T>(Model: T): TListaModelCampoValor;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  prop: TRttiProperty;

  index: integer;
  Campo: string;
  attr: TCustomAttribute;
  attrCampo: CampoAttribute;
  value: Variant;
  LRecord: TRttiRecordType;
  LVarType: TVarType;
  propName: string;
  isNullable: Boolean;
  LPropValue: TValue;

begin
  try

    Result := TListaModelCampoValor.create();
    Rtti := TRttiContext.create;
    ltype := Rtti.GetType(TypeInfo(T));

    // pecorrer as propriedades
    for prop in ltype.GetProperties do
    begin
      // IgnoreNoInsertAttribute

      attr := indexOfAttribute(prop, IgnoreNoInsertAttribute);

      // ignorar a propriedade
      if attr is IgnoreNoInsertAttribute then
        continue;

      attr := indexOfAttribute(prop, CampoAttribute);

      if (attr <> nil) then
      begin
         LPropValue := prop.GetValue(TObject(Model));
        attrCampo := CampoAttribute(attr);
        Campo := attrCampo.Campo;
        // propName := GetPropertyTypeString(LPropValue, prop);
        // isNullable := PropertyInNullableValue(prop);
        value := GetPropertyValue<T>(Model, prop);

        // definir o tipo da variant
        LVarType := GetTypeVariant(LPropValue,prop);

        Result.Add(TModelCampoValor.create(Campo, value, LVarType));
      end;
    end;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.CampoValor: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.PropertyInNullableValue(aProp: TRttiProperty): Boolean;
begin
  Result := StartsText('TNullable<', aProp.PropertyType.Name);
end;

class function TAtributosFuncoes.GetPropertyTypeString(aValue: TValue; aProp: TRttiProperty): string;
var
  method: TRttiMethod;
  Rtti: TRttiContext;

begin
  method := Rtti.GetType(aValue.TypeInfo).GetMethod('GetTypeString');
  if method <> nil then
    Result := method.Invoke(aValue, []).AsString
  else
    Result := aProp.PropertyType.Name;
end;

class function TAtributosFuncoes.GetPropertyValue<T>(Model: T; aProp: TRttiProperty): Variant;
var
  LValue: TValue;
  propName: string;
  method: TRttiMethod;
  Rtti: TRttiContext;
begin

  // verificar se eh do tipo Nullable
  if PropertyInNullableValue(aProp) then
  begin
    // get Nullable<T> instance...
    LValue := aProp.GetValue(TObject(Model));

    // pegar o nome da propriedade
    propName := GetPropertyTypeString(LValue, aProp);

    // verificar se tem dado
    method := Rtti.GetType(LValue.TypeInfo).GetMethod('HasValue');
    if (not method.Invoke(LValue, []).AsBoolean) then
    begin
      Result := null; // '(NULL)';
    end
    else
    begin
      method := Rtti.GetType(LValue.TypeInfo).GetMethod('ToTValue');
      Result := method.Invoke(LValue, []).AsVariant;
    end;
  end
  else
  begin
    Result := aProp.GetValue(TObject(Model)).AsVariant;
  end;
end;

class function TAtributosFuncoes.CampoValor<T>(Model: T; ValidaForeinkey: Boolean): TListaModelCampoValor;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  prop: TRttiProperty;
  index: integer;
  Campo: string;
  attr: TCustomAttribute;
  attrCampo: CampoAttribute;
  value: Variant;
  fk: TCustomAttribute;
  blIncluir: Boolean;
  LVarType: TVarType;
  LPropValue: TValue;
begin
  try

    Result := TListaModelCampoValor.create();
    Rtti := TRttiContext.create;
    ltype := Rtti.GetType(TypeInfo(T));
    index := 0;

    // pecorrer as propriedades
    for prop in ltype.GetProperties do
    begin

      attr := indexOfAttribute(prop, CampoAttribute);

      if (attr <> nil) then
      begin
        attrCampo := CampoAttribute(attr);
        Campo := attrCampo.Campo;
        LPropValue := prop.GetValue(TObject(Model));
        value := GetPropertyValue<T>(Model, prop);

        // definir o tipo da variant
        LVarType := GetTypeVariant(LPropValue, prop);

        blIncluir := True;

        fk := indexOfAttribute(prop, ForeignKeyAttribute);
        if fk <> nil then
        begin
          if LVarType = varInteger then
            if value = 0 then
              blIncluir := false;
        end;

        if blIncluir then
          Result.Add(TModelCampoValor.create(Campo, value, LVarType));
      end;
    end;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.CampoValor: ' + E.Message);
  end;

end;

class function TAtributosFuncoes.GetPropertyByCampo(aCampo: string; properties: TArray<TRttiProperty>): TRttiProperty;
var
  prop: TRttiProperty;
  attr: TCustomAttribute;
begin
  try
    for prop in properties do
    begin

      attr := indexOfAttribute(prop, CampoAttribute);

      if (attr <> nil) then
      begin
        if (CampoAttribute(attr).Campo.ToUpper = aCampo.ToUpper) then
        begin
          Result := prop;
          Break;
        end;
      end;
    end;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.GetPropertyByCampo: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.indexOfAttribute(prop: TRttiObject; Attribute: TClass): TCustomAttribute;
var
  attr: TCustomAttribute;
begin
  try
    Result := nil;

    if (prop = nil) or (prop.GetAttributes = nil) then
      Exit;

    for attr in prop.GetAttributes do
    begin
      if (attr is Attribute) then
      begin
        Result := attr;
        Break;
      end;
    end;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.indexOfAttribute: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.Tabela<T>: string;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  attr: TCustomAttribute;
  prop: TRttiProperty;
begin
  try
    Rtti := TRttiContext.create;
    ltype := Rtti.GetType(TypeInfo(T));

    for attr in ltype.GetAttributes do
    begin
      if attr is TabelaAttribute then
      begin
        Result := TabelaAttribute(attr).Tabela;
        Break;
      end;
    end;

    if Result = '' then
      Result := ltype.Name;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.Tabela<T>: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.TabelaAutoInc<T>(prop: TRttiProperty): string;
var
  attr: TCustomAttribute;
begin
  try

    attr := indexOfAttribute(prop, AutoIncAttribute);

    if (attr <> nil) then
      Result := AutoIncAttribute(attr).TabelaIncremento;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.TabelaAutoInc<T>: ' + E.Message);
  end;
end;

class function TAtributosFuncoes.Campo<T>(prop: TRttiProperty): string;
var
  attr: TCustomAttribute;
begin
  try

    attr := indexOfAttribute(prop, CampoAttribute);

    if (attr <> nil) then
      Result := CampoAttribute(attr).Campo
    else
      Result := prop.Name;
  except
    on E: Exception do
      raise Exception.create('TModelHelper.Campo<T>: ' + E.Message);
  end;
end;

end.
