unit Utils.Rtti;

{
  Auth: Base: https://delphihaven.wordpress.com/2011/06/09/object-cloning-using-rtti/
}

interface

uses System.Classes,
  System.TypInfo,
  System.sysutils,
  System.Generics.Collections,
  System.Rtti;

Type
  TRttiUtil = Class
  private

  public
    class procedure Copy<T: Class>(ASource: T; ATarget: T; AIgnore: string = ''); static;
    class function Clone<T: Class>(ASource: T): T; static;
    class function New<T>(aType: TClass): T; static;

    class procedure ListDisposeOf<T: Class>(aList: TList<T>); static;
    class procedure Initialize<T: Class>(ASource: T);

    class procedure EnumToValues<T>(Values: TStrings);
    class function EnumName<T>(value: integer): string;
    class function StringToEnum<T>(value: string): T;
    class function EnumToString<T>(value: T): String;
    class function CreateInstance<T>(const Args: array of TValue): T;
    class procedure Validation<T: Exception>(aExpressao: Boolean; aMessage: string);
  end;

implementation


class procedure TRttiUtil.Validation<T>(aExpressao: Boolean; aMessage: string);
begin
  if aExpressao then
    raise CreateInstance<T>([aMessage]);
end;

class function TRttiUtil.CreateInstance<T>(const Args: array of TValue): T;
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
      if (AMethCreate.IsConstructor) and (Length(AMethCreate.GetParameters) =  Length(Args) ) then
      begin
        instanceType := rType.AsInstance;

        AValue := AMethCreate.Invoke(instanceType.MetaclassType, Args);

        Result := AValue.AsType<T>;

        Exit;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.CreateInstance<T>: ' + E.Message);
  end;

end;

class procedure TRttiUtil.ListDisposeOf<T>(aList: TList<T>);
var
  item: T;
begin
  try
    if (Assigned(aList) = False) or (aList.Count <= 0) then
      Exit;

    for item in aList do
    begin
      item.Free;
    end;

    aList.Clear;
    aList.Free;

  except
    on E: Exception do
      raise Exception.Create('TRttiUtil.ListDisposeOf ' + E.Message);
  end;
end;

class function TRttiUtil.EnumName<T>(value: integer): string;
begin
  Result := GetEnumName(TypeInfo(T), (value));
end;

class procedure TRttiUtil.EnumToValues<T>(Values: TStrings);
var
  i: integer;
  Pos: integer;
  Aux: string;
begin

  Values.Clear;
  i := 0;
  repeat
    Aux := GetEnumName(TypeInfo(T), i);
    Pos := GetEnumValue(TypeInfo(T), Aux);

    if (Pos <> -1) then
      Values.ADD(Aux);
    inc(i);
  until (Pos < 0);
end;

class function TRttiUtil.EnumToString<T>(value: T): String;
begin
  case Sizeof(T) of
    1:
      Result := GetEnumName(TypeInfo(T), PByte(@value)^);
    2:
      Result := GetEnumName(TypeInfo(T), PWord(@value)^);
    4:
      Result := GetEnumName(TypeInfo(T), PCardinal(@value)^);
  end;
end;

class function TRttiUtil.StringToEnum<T>(value: string): T;
begin
  try
    case Sizeof(T) of
      1:
        PByte(@Result)^ := GetEnumValue(TypeInfo(T), value);
      2:
        PWord(@Result)^ := GetEnumValue(TypeInfo(T), value);
      4:
        PCardinal(@Result)^ := GetEnumValue(TypeInfo(T), value);
    end;

  except
    on E: Exception do
      raise Exception.Create('TRttiUtil.StringToEnum ' + E.Message);
  end;

end;

class procedure TRttiUtil.Initialize<T>(ASource: T);
var
  context: TRttiContext;
  rType: TRttiType;
  Field: TRttiField;
  method: TRttiMethod;
  prop: TRttiProperty;
  oSource: TObject;
begin
  context := TRttiContext.Create;
  rType := context.GetType(ASource.ClassType);
  oSource := TObject(ASource);

  for prop in rType.GetProperties do
  begin

    if prop.IsWritable then
    begin
      case prop.PropertyType.TypeKind of
        tkUnknown:
          prop.SetValue(oSource, varEmpty);
        tkInteger, tkFloat, tkInt64:
          prop.SetValue(oSource, TValue.From(0));
        tkWChar, tkChar, tkString,
          tkLString, tkWString, tkUString:
          prop.SetValue(oSource, TValue.From(''));
        tkVariant:
          prop.SetValue(oSource, varEmpty);
      end;
    end;
  end;

end;

class procedure TRttiUtil.Copy<T>(ASource, ATarget: T;
  AIgnore: string = '');
var
  context: TRttiContext;
  IsComponent, LookOutForNameProp: Boolean;
  RttiType: TRttiType;
  method: TRttiMethod;
  MinVisibility: TMemberVisibility;
  Params: TArray<TRttiParameter>;
  prop: TRttiProperty;
  Fld: TRttiField;
  SourceAsPointer, ResultAsPointer: Pointer;
begin
  AIgnore := ',' + AIgnore.ToLower + ',';
  RttiType := context.GetType(ASource.ClassType);
  // find a suitable constructor, though treat components specially
  IsComponent := (ASource is TComponent);
  try
    // loop through the props, copying values across for ones that are read/write
    Move(ASource, SourceAsPointer, Sizeof(Pointer));
    Move(ATarget, ResultAsPointer, Sizeof(Pointer));

    if ASource is TComponent then
    begin
      Fld := RttiType.GetField('Parent');
      if Assigned(Fld) then
      begin
        Fld.SetValue(ResultAsPointer, Fld.GetValue(SourceAsPointer));
      end
      else
        IsComponent := False;
    end;

    LookOutForNameProp := IsComponent and (TComponent(ASource).Owner <> nil);
    if IsComponent then
      MinVisibility := mvPublished
      // an alternative is to build an exception list
    else
      MinVisibility := mvPublic;

    for Fld in RttiType.GetFields do
    begin
      if Fld.Visibility >= MinVisibility then
        Fld.SetValue(ResultAsPointer, Fld.GetValue(SourceAsPointer));
    end;

    for prop in RttiType.GetProperties do
      if (prop.Visibility >= MinVisibility) and prop.IsReadable and prop.IsWritable
      then
        try
          if Pos(',' + prop.Name.ToLower + ',', AIgnore) = 0 then
          begin
            if LookOutForNameProp and (prop.Name = 'Name') and
              (prop.PropertyType is TRttiStringType) then
              LookOutForNameProp := False
            else
            begin
              if (prop.PropertyType.TypeKind = tkClass) then
              begin

              end;

              prop.SetValue(ResultAsPointer, prop.GetValue(SourceAsPointer));
            end;
          end;
        except
        end;
  except
    raise;
  end;
end;


class function TRttiUtil.New<T>(aType: TClass): T;
var
  AValue: TValue;
  ctx: TRttiContext;
  rType: TRttiType;
  AMethCreate: TRttiMethod;
  instanceType: TRttiInstanceType;
begin
  ctx := TRttiContext.Create;
  rType := ctx.GetType(aType);
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
end;

class function TRttiUtil.Clone<T>(ASource: T): T;
var
  context: TRttiContext;
  IsComponent, LookOutForNameProp: Boolean;
  RttiType: TRttiType;
  method: TRttiMethod;
  MinVisibility: TMemberVisibility;
  Params: TArray<TRttiParameter>;
  prop: TRttiProperty;
  SourceAsPointer, ResultAsPointer: Pointer;
begin
  RttiType := context.GetType(ASource.ClassType);
  // find a suitable constructor, though treat components specially
  IsComponent := (ASource is TComponent);
  for method in RttiType.GetMethods do
    if method.IsConstructor then
    begin
      Params := method.GetParameters;
      if Params = nil then
        Break;
      if (Length(Params) = 1) and IsComponent and
        (Params[0].ParamType is TRttiInstanceType) and
        SameText(method.Name, 'Create') then
        Break;
    end;
  if Params = nil then
    Result := method.Invoke(ASource.ClassType, []).AsType<T>
  else
    Result := method.Invoke(ASource.ClassType, [TComponent(ASource).Owner])
      .AsType<T>;
  TRttiUtil.Copy(ASource, Result);

end;

end.
