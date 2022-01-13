unit Helpers.HelperObject;

interface

uses System.JSON,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Rtti,
  JSON.Utils;

type
  THelperObject = class helper for TObject
    class function ToJSON<T: Class>: TJSONObject;
    class function FromJSON<T: Class>(obj: TJSONObject): T;
  end;

implementation


{ THelperObject }



{ THelperObject }

class function THelperObject.FromJSON<T>(obj: TJSONObject): T;
begin
 //  result := TJSONUtil.FromJSON<T>(obj);
end;

class function THelperObject.ToJSON<T>: TJSONObject;
begin
  // result := TJSONUtil.ToJSON<T>(self);
end;

end.
