unit Model.Atributos.Funcoes;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Rtti,
  Model.Atributos,
  Model.Atributos.Tipos,
  Model.IModelBase, Utils.Funcoes;

type

  // TArrayHelper = record helper for TArray<T>
  // function indexOf(item: T):Integer;
  // end;

  TProperties = array of TRttiProperty;

  TAtributosFuncoes = class
  private
    class function indexOfAttribute(prop: TRttiObject; Attribute: TClass): TCustomAttribute;
    class function GetPropertyByCampo(aCampo: string; properties: TArray<TRttiProperty>): TRttiProperty;

  public
    class function Tabela<T: class>: string; static;
    class function PropertieAutoInc<T: class>: TProperties; static;
    class function PropertiePk<T: class>: TProperties; static;
    class function TabelaAutoInc<T: class>(prop: TRttiProperty): string; static;
    class function Campo<T: class>(prop: TRttiProperty): string; static;
    class function CampoValor<T: class>(Model: T): TDictionary<string, Variant>; static;

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

class function TAtributosFuncoes.CampoValor<T>(Model: T): TDictionary<string, Variant>;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  prop: TRttiProperty;
  index: integer;
  Campo: string;
  attr: TCustomAttribute;
  attrCampo: CampoAttribute;
  value: Variant;

begin
  try

    Result := TDictionary<string, Variant>.create();
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
        value := prop.GetValue(TObject(Model)).AsVariant;

        if (CompareText('string', prop.PropertyType.Name)) = 0 then
          value := prop.GetValue(TObject(Model)).AsString
        else if (CompareText('TDateTime', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varDate
        else if (CompareText('TDate', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varDate
        else if (CompareText('TTime', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varDate
        else if (CompareText('Boolean', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varBoolean
        else if (CompareText('Currency', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varCurrency
        else if (CompareText('Integer', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varInteger
        else if (CompareText('Smallint', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varSmallint
        else if (CompareText('Double', prop.PropertyType.Name)) = 0 then
          TVarData(value).vType := varDouble;

        Result.Add(Campo, value);
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

class function TAtributosFuncoes.indexOfAttribute(prop: TRttiObject; Attribute: TClass):  TCustomAttribute;
var
  attr: TCustomAttribute;
begin
  try
    Result := nil;

    if (prop =nil) or (prop.GetAttributes = nil) then Exit;

<<<<<<< HEAD

=======
>>>>>>> 6476a37bad42c714e6ff9beea1236ec7cd22b62a
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
