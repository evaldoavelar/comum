unit Dao.DataSet;

interface

uses
  Data.DB, System.Rtti, System.SysUtils, Dao.IDataSet, Model.Atributos.Funcoes,
  System.StrUtils;

type

  TDaoDataSet<T: class> = class(TInterfacedObject, IDaoDataSet<T>)
  private
    function TValueFromField(const aField: TField): TValue;
  public
    function DataSetToObject(ds: TDataSet): T;
    function CreateInstance: T;
    class function New: IDaoDataSet<T>;
  end;

implementation

{ TDaoDataSet }

function TDaoDataSet<T>.CreateInstance: T;
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

function TDaoDataSet<T>.TValueFromField(const aField: TField): TValue;
var
  atype: TFieldType;
begin
  atype := aField.DataType;
  case atype of
    ftBCD, ftFMTBcd:
      Result := TValue.FromVariant(aField.AsExtended);
    ftDate, ftDateTime, ftTime, ftTimeStamp:
      Result := TValue.FromVariant(aField.AsDateTime);
  else
    Result := TValue.FromVariant(aField.Value);
  end;
end;

function TDaoDataSet<T>.DataSetToObject(ds: TDataSet): T;
var
  context: TRttiContext;
  rType: TRttiType;
  method: TRttiMethod;
  ARecord: TRttiType;
  prop: TRttiProperty;
  Field: TField;
  Entity: T;
  campo: string;
  LPropNullable: TValue;
begin

  try

    context := TRttiContext.Create;
    rType := context.GetType(T.ClassInfo);

    Entity := CreateInstance();

    for prop in rType.GetProperties do
    begin
      // a propriedade é de escrita
      if prop.IsWritable then
      begin
        // pegar o campo corresponte a property
        campo := TAtributosFuncoes.campo<T>(prop);

        // procurar o campo  no dataset
        Field := ds.Fields.FindField(campo);
        if Field <> nil then
        begin
          try

            if StartsText('TNullable<', prop.PropertyType.Name) then
            begin
              // get Nullable<T> instance...
              LPropNullable := prop.GetValue(TObject(Entity));

              // se o campo eh nulo
              if (Field.IsNull) then
              begin
                // invocar Clear par zerar a variavel
                method := context.GetType(LPropNullable.TypeInfo).GetMethod('Clear');
                method.Invoke(LPropNullable, []);
              end
              else
              begin

                // invocar FromValue para passar o valor de Field
                method := context.GetType(LPropNullable.TypeInfo).GetMethod('FromValue');
                method.Invoke(LPropNullable, [TValueFromField(Field)]);

                // passar o valor para a property
                prop.SetValue(TObject(Entity), LPropNullable);
              end;
            end
            else if (CompareText('string', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsString)
            else if (CompareText('Char', prop.PropertyType.Name)) = 0 then
              prop.SetValue(TObject(Entity), Field.AsString)
            else if (CompareText('TDateTime', prop.PropertyType.Name)) = 0 then
            begin
              if (Field.IsNull = false) or (Field.AsString <> '') then
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

class function TDaoDataSet<T>.New: IDaoDataSet<T>;
begin
  Result := TDaoDataSet<T>.Create;
end;

end.
