unit JSON.Utils;

interface

uses System.JSON,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Rtti, System.DateUtils, Winapi.Windows,
  Soap.EncdDecd,
{$IF DECLARED(FireMonkeyVersion)}
  FMX.Graphics,
{$ELSE}
  Vcl.Graphics,
  Vcl.ExtCtrls,
{$IFEND}
  JSON.Atributes.Funcoes,
  JSON.Utils.ConverterTypes;

type

  TJSONUtil = class
  private
    class var FDateTimeIsUTC: Boolean;
    class var FConverterTypes: TConverterTypes;
    class function Marshal<T: class>(Data: TObject): TJSONObject; static;
    class function Converter<T: class>(p: Pointer; Data: Pointer): TJSONObject;
    class function TListToJson<T: class>(ArRttiType: TRttiType; xValue: TValue): TJSONArray;
    class function ConverterValue(value: TValue; PropertyType: TRttiType): TJSONValue; static;
    class procedure SetDateTimeIsUTC(const value: Boolean);
    class function StrToJson(value: string): TJSONValue;
    class function IntToJson(value: Integer): TJSONValue;
    class function DateTimeToJson(value: TDateTime): TJSONValue;
    class function BooleanToJson(value: Boolean): TJSONValue; static;
    class function CurrencyToJson(value: currency): TJSONValue; static;
    class function DoubleToJson(value: Double): TJSONValue; static;
    class function Base64FromBitmap(Bitmap: TBitmap): TJSONString; static;
    class function IsTlist(rttiType: TRttiType): Boolean; static;
    class function ShouldMarshal<T: class>(Data: Pointer; rttiProp: TRttiProperty): Boolean; static;

    class procedure PopulateFields<T: class>(rttiType: TRttiType; JsonFields: TJSONObject; Data: T);
    class function CreateInstance<T>: T; static;
    class function ClassTypeOf<T>(Field: string): TClass; static;
    class function ExtractTypeFromGenerics(typeObjct: string): TClass; static;
    class procedure SetField(prop: TRttiProperty; Data: TObject; Field: string; value: TObject); overload; static;
    class procedure SetField(prop: TRttiProperty; Data: TObject; Field, value: string); overload; static;
    class procedure SetField(prop: TRttiProperty; Data: TObject; Field: string; value: Boolean); overload; static;
    class procedure SetFieldArray(prop: TRttiProperty; Data: TObject; Field: string; value: TJSONArray); static;
    class function ComposeKey(clazz: TClass; Field: string): string; static;
    class procedure SetFieldNull(prop: TRttiProperty; Data: TObject; Field: string);
    class function StringToTValue(value: string; typeInfo: PTypeInfo): TValue; static;
    class function JSONToTValue(JsonValue: TJSONValue; rttiType: TRttiType): TValue; static;
    class function CreateObject(aClass: TClass; JsonObj: TJSONObject; AObject: TObject = nil): TObject; static;
    class function ObjectInstance(TypeName: string): TObject; static;
    class function JsonDateToDatetime(JSONDate: string): TDateTime; static;
  public
    class function ToJSON<T: Class>(obj: T; ConverterTypes: TConverterTypes = []): TJSONObject;
    class function FromJSON<T: Class>(jsonStr: string): T; overload;
    class procedure FromJSON<T: Class>(jsonStr: string; aObj: T); overload;
  end;

const
  SEP_DOT = '.';

implementation


{ TJSONUtil }

class function TJSONUtil.FromJSON<T>(jsonStr: string): T;
var
  objJson: TJSONValue;
  context: TRttiContext;
  tipo: TRttiType;
  obj: T;
begin
  objJson := TJSONObject.ParseJSONValue(jsonStr);
  context := TRttiContext.Create;

  tipo := context.GetType(typeInfo(T));
  obj := CreateInstance<T>();

  try
    PopulateFields(tipo, TJSONObject(objJson), obj);

    Result := obj;
  except
    raise
  end;

end;

class procedure TJSONUtil.FromJSON<T>(jsonStr: string; aObj: T);
var
  objJson: TJSONValue;
  context: TRttiContext;
  tipo: TRttiType;

begin
  objJson := TJSONObject.ParseJSONValue(jsonStr);
  context := TRttiContext.Create;
  tipo := context.GetType(typeInfo(T));
  try
    PopulateFields(tipo, TJSONObject(objJson), aObj);
  except
    raise
  end;

end;

class function TJSONUtil.ToJSON<T>(obj: T; ConverterTypes: TConverterTypes = []): TJSONObject;
begin
  FConverterTypes := ConverterTypes;
  Result := Marshal<T>(obj);
end;

class procedure TJSONUtil.PopulateFields<T>(rttiType: TRttiType; JsonFields: TJSONObject; Data: T);
var
  JsonPairField: TJSONPair;
  FieldName: string;
  jsonFieldVal: TJSONValue;
  prop: TRttiProperty;
  PropValue: TValue;
  LPopulated: Boolean;
  obj: TObject;
  subObj: TObject;
  tvArray: array of TValue;
  elementType: TRttiType;
  I: Integer;
  len: TValue;
  LFieldType: TClass;
  jsonArray: TJSONArray;
  rFieldHelper: TRTTIField;
  rFieldFcount: TRTTIField;
  LValue: TValue;
  rFieldFItems: TRTTIField;
begin
  for JsonPairField in JsonFields do
  begin
    LPopulated := True;
    jsonFieldVal := JsonPairField.JsonValue;
    FieldName := JsonPairField.JsonString.value;
    if jsonFieldVal.Null then
      Continue;

    obj := TObject(Data);
    prop := rttiType.GetProperty(FieldName);

    if (prop = nil) or (prop.IsWritable = false) then
      Continue;

    if jsonFieldVal is TJSONNumber then
      SetField(prop, obj, FieldName, jsonFieldVal.ToString)
    else if jsonFieldVal is TJSONString then
      SetField(prop, obj, FieldName, jsonFieldVal.value)
    else if jsonFieldVal is TJSONTrue then
      SetField(prop, obj, FieldName, True)
    else if jsonFieldVal is TJSONFalse then
      SetField(prop, obj, FieldName, false)
    else if (jsonFieldVal is TJSONNull) then
      SetFieldNull(prop, obj, FieldName)
    else if (jsonFieldVal is TJSONObject) then
    begin
      LFieldType := rttiType.AsInstance.MetaclassType;
      subObj := CreateObject(LFieldType, TJSONObject(jsonFieldVal));
      PopulateFields<T>(rttiType, TJSONObject(jsonFieldVal), subObj);
    end
    else if (jsonFieldVal is TJSONArray) then
    begin
      // SetLength(tvArray, TJSONArray(jsonFieldVal).Count);
      // if prop.PropertyType is TRttiArrayType then
      // elementType := TRttiArrayType(prop.PropertyType).elementType
      // else
      // elementType := TRttiDynamicArrayType(prop.PropertyType).elementType;
      // for I := 0 to Length(tvArray) - 1 do
      // tvArray[I] := JSONToTValue(TJSONArray(jsonFieldVal).Items[I], elementType);

      if IsTlist(prop.PropertyType) then
      begin

        jsonArray := TJSONArray(jsonFieldVal);
        SetLength(tvArray, jsonArray.Count);
        for I := 0 to jsonArray.Count - 1 do
        begin
          subObj := nil;

          subObj := CreateObject(ExtractTypeFromGenerics(prop.PropertyType.Name), TJSONObject(jsonFieldVal), nil);
          elementType := TRttiContext.Create.GetType((subObj.ClassType));

          PopulateFields(elementType, TJSONObject(TJSONObject.ParseJSONValue(jsonArray.Items[0].ToJSON)), subObj);

          tvArray[I] := subObj;
        end;

        for I := 0 to Length(prop.PropertyType.GetFields) - 1 do
        begin
          rFieldHelper := prop.PropertyType.GetFields[I];
          OutputDebugString(PWideChar(rFieldHelper.Name));
        end;

        // buscar o field FListHelper no objeto
        rFieldHelper := prop.PropertyType.GetField('FListHelper');
        rFieldFcount := rFieldHelper.FieldType.GetField('FCount');
        rFieldFItems := prop.PropertyType.GetField('FItems');

        // Tlist
        PropValue := rFieldHelper.GetValue(obj);

        LValue := rFieldFcount.GetValue(PropValue.GetReferenceToRawData);
        OutputDebugString(PWideChar(LValue.AsInteger.ToString));

        LValue := TValue.FromArray(rFieldFItems.FieldType.Handle, tvArray);
        len := TValue.FromVariant(Length(tvArray));

        rFieldFcount.SetValue(PropValue.GetReferenceToRawData, len); // Update FCount
        rFieldFItems.SetValue(PropValue.GetReferenceToRawData, LValue);

        LValue := rFieldFcount.GetValue(PropValue.GetReferenceToRawData);
        OutputDebugString(PWideChar(LValue.AsInteger.ToString));

        // rFieldHelper.SetValue(obj, PropValue);

      end;
    end
    // else if jsonFieldVal is TJSONArray then
    // SetFieldArray(prop, Data, FieldName, TJSONArray(jsonFieldVal))
    else
      raise Exception.Create(Format('Invalid Json Field Type %s', [FieldName, Data.ClassName]));
  end;
end;

class procedure TJSONUtil.SetFieldNull(prop: TRttiProperty; Data: TObject; Field: string);
begin
  if prop <> nil then
    prop.SetValue(Data, TValue.Empty);
end;

class function TJSONUtil.ComposeKey(clazz: TClass; Field: string): string;
begin
  if clazz <> nil then
    Result := clazz.UnitName + SEP_DOT + clazz.ClassName + SEP_DOT + Field
  else
    Result := '';
end;

class function TJSONUtil.ExtractTypeFromGenerics(typeObjct: string): TClass;
var
  PosIni: Integer;
  PosEnd: Integer;
  sClass: string;
  tRtti: TRttiType;
  context: TRttiContext;
begin
  PosIni := pos('<', typeObjct) + 1;
  PosEnd := pos('>', typeObjct);

  sClass := Copy(typeObjct, PosIni, PosEnd - PosIni);
  context := TRttiContext.Create;
  tRtti := context.FindType(sClass);

  if (tRtti <> nil) and (tRtti is TRttiInstanceType) then
    Result := TRttiInstanceType(tRtti).MetaclassType;
end;

class function TJSONUtil.ClassTypeOf<T>(Field: string): TClass;
var
  tRtti: TRttiType;
  fRtti: TRttiProperty;
  LFieldName: string;
  context: TRttiContext;
begin
  Result := nil;
  context := TRttiContext.Create;
  tRtti := context.GetType(typeInfo(T));
  if tRtti <> nil then
  begin
    LFieldName := Field;
    fRtti := tRtti.GetProperty(LFieldName);
    if (fRtti <> nil) and (fRtti.PropertyType.IsInstance) then
      Result := fRtti.PropertyType.AsInstance.MetaclassType;
  end;
end;

class procedure TJSONUtil.SetField(prop: TRttiProperty; Data: TObject; Field: string; value: TObject);
begin
  if prop <> nil then
    prop.SetValue(Data, value);
end;

class function TJSONUtil.JsonDateToDatetime(JSONDate: string): TDateTime;
var
  Year, Month, Day, Hour, Minute, Second, Millisecond: Word;
begin
  Year := StrToInt(Copy(JSONDate, 1, 4));
  Month := StrToInt(Copy(JSONDate, 6, 2));
  Day := StrToInt(Copy(JSONDate, 9, 2));
  Hour := StrToInt(Copy(JSONDate, 12, 2));
  Minute := StrToInt(Copy(JSONDate, 15, 2));
  Second := StrToInt(Copy(JSONDate, 18, 2));
  Millisecond := Round(StrToFloat(Copy(JSONDate, 21, 3)));

  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, Millisecond);
end;

class function TJSONUtil.StringToTValue(value: string; typeInfo: PTypeInfo): TValue;
var
  vChar: char;
  vWChar: widechar;
  FValue: TValue;
  enumVal: Integer;
  LResultDouble: Double;
begin
  case typeInfo.Kind of
{$IFNDEF NEXTGEN}
    TTypeKind.tkString:
      Exit(TValue.From<ShortString>(ShortString(value)));
    TTypeKind.tkWString:
      Exit(TValue.From<WideString>(WideString(value)));
{$ELSE}
    TTypeKind.tkString, TTypeKind.tkWString,
{$ENDIF !NEXTGEN}
    TTypeKind.tkLString, TTypeKind.tkUString:
      Exit(value);
    TTypeKind.tkFloat:
      if System.JSON.TryJsonToFloat(value, LResultDouble) then
        Exit(LResultDouble)
      else
        Exit(0.0);
    TTypeKind.tkInteger:
      Exit(StrToIntDef(value, 0));
    TTypeKind.tkInt64:
      Exit(StrToInt64Def(value, 0));
    TTypeKind.tkChar:
      begin
        if value = '' then
          vChar := #0
        else
          vChar := value.Chars[0];
        TValue.Make(@vChar, typeInfo, FValue);
        Exit(FValue);
      end;
    TTypeKind.tkWChar:
      begin
        if value = '' then
          vWChar := #0
        else
          vWChar := value.Chars[0];
        TValue.Make(@vWChar, typeInfo, FValue);
        Exit(FValue);
      end;
    TTypeKind.tkEnumeration:
      begin
        enumVal := GetEnumValue(typeInfo, value);
        TValue.Make(@enumVal, typeInfo, FValue);
        Exit(FValue);
      end
  else
    raise Exception.Create(Format('No Conversion Available For Value %s', [value, typeInfo.NameFld.ToString]));
  end;
end;

class procedure TJSONUtil.SetField(prop: TRttiProperty; Data: TObject; Field, value: string);
begin
  if prop = nil then
    Exit;
  if (prop.PropertyType.QualifiedName = 'System.TDateTime') or
    (prop.PropertyType.QualifiedName = 'System.TTime')
  then
  else
    prop.SetValue(Data, StringToTValue(value, prop.PropertyType.Handle));
end;

class procedure TJSONUtil.SetField(prop: TRttiProperty; Data: TObject; Field: string; value: Boolean);
begin

  if prop <> nil then
    prop.SetValue(Data, value);
end;

class function TJSONUtil.JSONToTValue(JsonValue: TJSONValue; rttiType: TRttiType): TValue;
var
  tvArray: array of TValue;
  value: string;
  I: Integer;
  elementType: TRttiType;
  Data: TValue;
  recField: TRTTIField;
  jsonFieldVal: TJSONValue;
  ClassType: TClass;
  Instance: Pointer;
  LFieldType: TClass;
begin
  // null or nil returns empty
  if (JsonValue = nil) or (JsonValue is TJSONNull) then
    Exit(TValue.Empty);

  // for each JSON value type
  if JsonValue is TJSONNumber then
    // get data "as is"
    value := TJSONNumber(JsonValue).ToString
  else if JsonValue is TJSONString then
    value := TJSONString(JsonValue).value
  else if JsonValue is TJSONTrue then
    Exit(True)
  else if JsonValue is TJSONFalse then
    Exit(false)
  else if JsonValue is TJSONObject then
  // object...
  begin
    LFieldType := rttiType.AsInstance.MetaclassType;
    Exit(CreateObject(LFieldType, TJSONObject(JsonValue)))
  end
  else
  begin
    case rttiType.TypeKind of
      TTypeKind.tkDynArray, TTypeKind.tkArray:
        begin
          // array
          SetLength(tvArray, TJSONArray(JsonValue).Count);
          if rttiType is TRttiArrayType then
            elementType := TRttiArrayType(rttiType).elementType
          else
            elementType := TRttiDynamicArrayType(rttiType).elementType;
          for I := 0 to Length(tvArray) - 1 do
            tvArray[I] := JSONToTValue(TJSONArray(JsonValue).Items[I], elementType);

          Exit(TValue.FromArray(rttiType.Handle, tvArray));
        end;
      TTypeKind.tkRecord:
        begin
          // TValue.Make(nil, rttiType.Handle, Data);
          // // match the fields with the array elements
          // I := 0;
          // for recField in rttiType.GetFields do
          // begin
          // Instance := Data.GetReferenceToRawData;
          // jsonFieldVal := TJSONArray(JsonValue).Items[I];
          // // check for type reverter
          // ClassType := nil;
          // if recField.FieldType.IsInstance then
          // ClassType := recField.FieldType.AsInstance.MetaclassType;
          // if (ClassType <> nil) then
          // begin
          // if HasReverter(ComposeKey(ClassType, FIELD_ANY)) then
          // RevertType(recField, Instance, Reverter(ComposeKey(ClassType, FIELD_ANY)), jsonFieldVal)
          // else
          // begin
          // attrRev := FieldTypeReverter(recField.FieldType);
          // if attrRev = nil then
          // attrRev := FieldReverter(recField);
          // if attrRev <> nil then
          // try
          // RevertType(recField, Instance, attrRev, jsonFieldVal)
          // finally
          // attrRev.Free
          // end
          // else
          // recField.SetValue(Instance, JSONToTValue(jsonFieldVal, recField.FieldType));
          // end
          // end
          // else
          // recField.SetValue(Instance, JSONToTValue(jsonFieldVal, recField.FieldType));
          // Inc(I);
          // end;
          Exit(Data);
        end;
    end;
  end;

  // transform value string into TValue based on type info
  Exit(StringToTValue(value, rttiType.Handle));
end;

class procedure TJSONUtil.SetFieldArray(prop: TRttiProperty; Data: TObject; Field: string; value: TJSONArray);
var
  LValue: TValue;
  LFields: TArray<TRttiProperty>;
begin

  if prop <> nil then
    case prop.PropertyType.TypeKind of
      TTypeKind.tkArray, TTypeKind.tkDynArray:
        prop.SetValue(Data, JSONToTValue(value, prop.PropertyType));
      TTypeKind.tkRecord, TTypeKind.tkClass:
        begin

          LFields := prop.PropertyType.GetProperties;
          // Special handling for TList<T>.FListHelper.  Unmashal FCount.  Preserve other FTypeInfo, FNotify, FCompare.
          if (prop.Name = 'List') and
            (value.Count = 1) and
            (Length(LFields) > 1) and
            (LFields[0].Name = 'Count') then
          begin
            LValue := prop.GetValue(Data); // Get FListHelper
            LFields[0].SetValue(LValue.GetReferenceToRawData, JSONToTValue(value.Items[0], LFields[0].PropertyType)); // Update FCount
            prop.SetValue(Data, LValue); // Set FListHelper
          end
          else
            prop.SetValue(Data, JSONToTValue(value, prop.PropertyType));
        end
    else
      raise Exception.Create(Format('Invalid Type For Field %s', [Field, prop.PropertyType.Name]));
    end;
end;

class function TJSONUtil.CreateInstance<T>: T;
var
  AValue: TValue;
  ctx: TRttiContext;
  rType: TRttiType;
  AMethCreate: TRttiMethod;
  instanceType: TRttiInstanceType;
begin

  try
    ctx := TRttiContext.Create;
    rType := ctx.GetType(typeInfo(T));
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

class function TJSONUtil.ObjectInstance(TypeName: string): TObject;
var
  rType: TRttiType;
  mType: TRttiMethod;
  Metaclass: TClass;
  context: TRttiContext;
begin
  context := TRttiContext.Create;
  rType := context.FindType(TypeName);
  if (rType <> nil) then
    for mType in rType.GetMethods do
    begin
      if mType.HasExtendedInfo and mType.IsConstructor then
      begin
        if Length(mType.GetParameters) = 0 then
        begin
          // invoke
          Metaclass := rType.AsInstance.MetaclassType;
          Exit(mType.Invoke(Metaclass, []).AsObject);
        end;
      end;
    end;
  Exit(nil);
end;

class function TJSONUtil.CreateObject(aClass: TClass; JsonObj: TJSONObject; AObject: TObject = nil): TObject;
var
  LObjectType: string;
  LObject: TObject;
  LRttiType: TRttiType;
begin
  Assert(JsonObj <> nil);
  if not Assigned(aClass) then
    Result := nil
  else
  begin
    LObjectType := aClass.QualifiedClassName; // RttiTypeOf(T).QualifiedName;
    if not Assigned(AObject) then
      LObject := ObjectInstance(LObjectType)
    else
      LObject := AObject;
    if LObject = nil then
      raise Exception.Create(Format('o tipo %s não pode ser criado', [LObjectType]));

    Result := LObject;
  end;

end;

class function TJSONUtil.TListToJson<T>(ArRttiType: TRttiType; xValue: TValue): TJSONArray;
var
  recField: TRttiProperty;
  arValue: TValue;
  len: Integer;
  jsonArray: TJSONArray;
  I: Integer;
begin
  // pecorrer as propriedades do objeto
  for recField in ArRttiType.GetProperties do
  begin
    // verificar se a classe possui propriedades do tipo enumerator
    if (recField.PropertyType.TypeKind = TTypeKind.tkDynArray) or
      (recField.PropertyType.TypeKind = TTypeKind.tkArray) then
    begin
      // varrer a lista da propriedade
      arValue := recField.GetValue(xValue.AsObject);

      len := arValue.GetArrayLength;

      // criar um array json
      jsonArray := TJSONArray.Create;

      for I := 0 to len - 1 do
      begin
        if not arValue.GetArrayElement(I).IsEmpty then
        begin
          // processar os objetos do array
          jsonArray.Add(Converter<T>(arValue.GetArrayElement(I).typeInfo, arValue.GetArrayElement(I).AsObject));
        end;
      end;

      Result := jsonArray;
    end
  end;
end;

class function TJSONUtil.Marshal<T>(Data: TObject): TJSONObject;
begin
  if Assigned(Data) and (Data <> nil) then
    Result := Converter<T>(typeInfo(T), Data)
  else
    Result := nil;
end;

class procedure TJSONUtil.SetDateTimeIsUTC(const value: Boolean);
begin
  FDateTimeIsUTC := value;
end;

class function TJSONUtil.StrToJson(value: string): TJSONValue;
begin
  if value.IsEmpty then
    Result := TJSONString.Create()
  else
    Result := TJSONString.Create(value);
end;

class function TJSONUtil.IntToJson(value: Integer): TJSONValue;
begin
  Result := TJSONNumber.Create(value);
end;

class function TJSONUtil.DateTimeToJson(value: TDateTime): TJSONValue;
var
  Data: string;
begin
  // null date
  if (value = 0) then
    Result := TJSONString.Create()
  else
  begin
    Data := DateToISO8601(value, FDateTimeIsUTC);
    Result := TJSONString.Create(Data);
  end;
end;

class function TJSONUtil.CurrencyToJson(value: currency): TJSONValue;
begin
  Result := TJSONNumber.Create(value);
end;

class function TJSONUtil.DoubleToJson(value: Double): TJSONValue;
begin
  Result := TJSONNumber.Create(value);
end;

class function TJSONUtil.BooleanToJson(value: Boolean): TJSONValue;
begin
  Result := TJSONBool.Create(value);
end;

class function TJSONUtil.Base64FromBitmap(Bitmap: TBitmap): TJSONString;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
  Input := TBytesStream.Create;
  try
    Bitmap.SaveToStream(Input);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);
    try
      Soap.EncdDecd.EncodeStream(Input, Output);
      Result := TJSONString.Create(Output.DataString);
    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

class function TJSONUtil.ConverterValue(value: TValue; PropertyType: TRttiType): TJSONValue;
begin

  // propriedades primitivas
  if (CompareText('string', PropertyType.Name) = 0) or
    (CompareText('Char', PropertyType.Name) = 0) or
    (CompareText('WideChar', PropertyType.Name) = 0) then
  begin
    if value.AsString.IsEmpty and FConverterTypes.Contains(cvIgoreEmptyString) then
      Result := nil
    else
      Result := StrToJson(value.AsString);
  end
  else if (CompareText('Integer', PropertyType.Name) = 0) or
    (CompareText('Int64', PropertyType.Name) = 0) then
    Result := (IntToJson(value.AsInteger))
  else if (CompareText('TDateTime', PropertyType.Name)) = 0 then
  begin
    if (value.AsType<TDateTime> = 0) and FConverterTypes.Contains(cvIgoreEmptyDate) then
      Result := nil
    else
      Result := (DateTimeToJson(value.AsType<TDateTime>))
  end
  else if (CompareText('TDate', PropertyType.Name)) = 0 then
  begin
    if (value.AsType<TDate> = 0) and FConverterTypes.Contains(cvIgoreEmptyDate) then
      Result := nil
    else
      Result := (DateTimeToJson(value.AsType<TDate>))
  end
  else if (CompareText('TTime', PropertyType.Name)) = 0 then
  begin
    if (value.AsType<TDate> = 0) and FConverterTypes.Contains(cvIgoreEmptyDate) then
      Result := nil
    else
      Result := (DateTimeToJson(value.AsType<TDate>))
  end
  else if (CompareText('Boolean', PropertyType.Name)) = 0 then
    Result := (BooleanToJson(value.AsBoolean))
  else if (CompareText('Currency', PropertyType.Name)) = 0 then
    Result := (CurrencyToJson(value.AsCurrency))
  else if (CompareText('Double', PropertyType.Name)) = 0 then
    Result := (DoubleToJson(value.AsCurrency))
  else if (CompareText('TImage', PropertyType.Name)) = 0 then
    Result := (Base64FromBitmap(TBitmap(value.AsObject)))

end;

class function TJSONUtil.IsTlist(rttiType: TRttiType): Boolean;
var
  I: Integer;
  fields: TArray<TRTTIField>;
  Field: TRTTIField;
  hasTListHelper: Boolean;
begin
  fields := rttiType.GetFields;
  hasTListHelper := false;

  // verificar se é um TList
  for I := 0 to Pred(Length(fields)) do
  begin
    Field := fields[I];

    if (Field.Name = 'FListHelper') and
      (Length(Field.FieldType.GetFields) > 1) and
      (Field.FieldType.GetFields[0].Name = 'FCount') then
    begin
      hasTListHelper := True;
      Break;
    end
  end;

  Result := hasTListHelper;

end;

class function TJSONUtil.ShouldMarshal<T>(Data: Pointer; rttiProp: TRttiProperty): Boolean;
begin
  Result := True;
  Assert(Data <> nil);

  if rttiProp.Name = 'RefCount' then
    Exit(false);

  Result := TJsonAtributosFuncoes.Ignore<T>(rttiProp) = false;
end;

class function TJSONUtil.Converter<T>(p: Pointer; Data: Pointer): TJSONObject;
var
  context: TRttiContext;
  rttiType: TRttiType;
  prop, recField: TRttiProperty;
  value: TValue;
  xValue: TValue;
  rttiField: TRTTIField;
  jsonArray: TJSONArray;
  ArRttiType: TRttiType;
  key: string;
  JsonValue: TJSONValue;
begin
  // preparar o Json
  Result := TJSONObject.Create();

  context := TRttiContext.Create;
  rttiType := context.GetType(p);

  // pecorrer as propriedades do objeto
  for prop in rttiType.GetProperties do
  begin
    value := prop.GetValue(Data);
    key := prop.Name.ToLower;

    if not ShouldMarshal<T>(Data, prop) then
      Continue;

    if value.IsEmpty then
      Continue;

    case value.Kind of
      tkInteger, tkFloat, tkInt64, tkChar, tkString, tkWChar, tkWString, tkLString, tkUString:
        begin
          JsonValue := ConverterValue(value, prop.PropertyType);
          if JsonValue <> nil then
            Result.AddPair(key, JsonValue);
        end;
      TTypeKind.tkEnumeration: // Enum
        begin
          Result.AddPair(key, GetEnumName(value.typeInfo, TValueData(value).FAsSLong));
        end;
      TTypeKind.tkClass:
        begin
          // verificar se é um TList
          rttiType := context.GetType(value.typeInfo);
          if IsTlist(rttiType) then
          begin
            // recuperar o objeto da propriedade
            xValue := prop.GetValue(Data);
            // verificar o tipo do objeto
            ArRttiType := context.GetType(xValue.typeInfo);
            jsonArray := TListToJson<T>(ArRttiType, xValue);
            if jsonArray.Count > 0 then
              Result.AddPair(key, jsonArray);
          end
          else if (CompareText('TImage', prop.PropertyType.Name)) = 0 then
          begin
            xValue := prop.GetValue(Data);
            Result.AddPair(key, Base64FromBitmap(TImage(xValue.AsObject).Picture.Bitmap));
          end
          else
          begin
            // chama novamente a função para processar suas propriedades
            Result.AddPair(key, Converter<T>(value.typeInfo, value.AsObject));
          end;
        end;

      TTypeKind.tkRecord:
        begin
          // // recuperar o objeto da propriedade
          // xValue := prop.GetValue(Data);
          //
          // // verificar o tipo do objeto
          // rttiRecord := context.GetType(xValue.typeInfo).AsRecord;
          //
          // jsonArray := TJSONArray.create;
          // for rttiField in rttiRecord.GetFields do
          // begin // rttiField.GetValue( xValue.GetReferenceToRawData )
          // obj := TJSONObject.create;
          // obj.AddPair(rttiField.Name, ConverterValue(rttiField.GetValue(xValue.GetReferenceToRawData), rttiField.FieldType));
          // jsonArray.Add(obj);
          // end;
          //
          // Result.AddPair(prop.Name, jsonArray);

        end;

    end;
  end;

end;

end.
