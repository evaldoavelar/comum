unit JSON.Utils;

interface

uses
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  System.Rtti, System.DateUtils,
  Soap.EncdDecd,
{$IF DECLARED(FireMonkeyVersion)}
  FMX.Graphics,
{$ELSE}
  Vcl.Graphics,
  Vcl.ExtCtrls,
  Winapi.Windows,
{$ELSE}
  FMX.Graphics,
{$IFEND}
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  Neon.Core.Utils,
  Neon.Core.Types,

  System.JSON;

type

  TJSONUtil = class
  private
    class function ClassTypeOf<T>(Field: string): TClass; static;
    class function CreateInstance<T>: T; static;
    class function BuildSerializerConfig: INeonConfiguration; static;
  public

    class function FromJSON<T: Class>(jsonStr: string): T; overload;
    class procedure FromJSON(jsonStr: string; aObj: TObject); overload;
    class function ToJSON(obj: TObject): TJSONObject;
  end;

  PPByte = ^PByte;

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

  LReader: TNeonDeserializerJSON;
begin
  objJson := TJSONObject.ParseJSONValue(jsonStr);
  context := TRttiContext.Create;

  tipo := context.GetType(typeInfo(T));
  obj := CreateInstance<T>();

  objJson := TJSONObject.ParseJSONValue(jsonStr);
  if not Assigned(objJson) then
    raise Exception.Create('Error parsing JSON string');

end;

class function TJSONUtil.ToJSON(obj: TObject): TJSONObject;
var
  LReader: TNeonSerializerJSON;
begin
  LReader := TNeonSerializerJSON.Create(BuildSerializerConfig);
  try
    result := TJSONObject(LReader.ObjectToJSON(obj));
    // LogError(LReader.Errors);
  finally
    FreeAndNil(LReader);
  end;

end;

class procedure TJSONUtil.FromJSON(jsonStr: string; aObj: TObject);
var
  objJson: TJSONValue;
  Serializer: TNeonDeserializerJSON;
begin
  objJson := TJSONObject.ParseJSONValue(jsonStr);

  Serializer := TNeonDeserializerJSON.Create(BuildSerializerConfig);
  Serializer.JSONToObject(aObj, objJson);
  Serializer.Free;
  objJson.Free;
end;

class function TJSONUtil.ClassTypeOf<T>(Field: string): TClass;
var
  tRtti: TRttiType;
  fRtti: TRttiProperty;
  LFieldName: string;
  context: TRttiContext;
begin
  result := nil;
  context := TRttiContext.Create;
  tRtti := context.GetType(typeInfo(T));
  if tRtti <> nil then
  begin
    LFieldName := Field;
    fRtti := tRtti.GetProperty(LFieldName);
    if (fRtti <> nil) and (fRtti.PropertyType.IsInstance) then
      result := fRtti.PropertyType.AsInstance.MetaclassType;
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

        result := AValue.AsType<T>;

        Exit;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('TDaoBase.CreateInstance<T>: ' + E.Message);
  end;

end;

class function TJSONUtil.BuildSerializerConfig: INeonConfiguration;
var
  LVis: TNeonVisibility;
begin
  LVis := [];
  result := TNeonConfiguration.Default;

  // Case settings
  result.SetMemberCustomCase(nil);
  result.SetMemberCase(TNeonCase.LowerCase);

  result.SetMembers([TNeonMembers.Properties]);

  // F Prefix setting
  result.SetIgnoreFieldPrefix(false);

  // Use UTC Date
  result.SetUseUTCDate(true);

  // Pretty Printing
  result.SetPrettyPrint(true);

  // Visibility settings
  LVis := [mvPublic];
  result.SetVisibility(LVis);

  // // RTL serializers
  // result.GetSerializers.RegisterSerializer(TGUIDSerializer);
  // result.GetSerializers.RegisterSerializer(TStreamSerializer);
  // // DB serializers
  // result.GetSerializers.RegisterSerializer(TDataSetSerializer);
  // // VCL serializers
  // result.GetSerializers.RegisterSerializer(TImageSerializer);
  //
  // // Demo Serializers
  // result.GetSerializers.RegisterSerializer(TPoint3DSerializer);
  // result.GetSerializers.RegisterSerializer(TParameterSerializer);
  // result.GetSerializers.RegisterSerializer(TFontSerializer);
  // result.GetSerializers.RegisterSerializer(TCaseClassSerializer);
end;

end.
