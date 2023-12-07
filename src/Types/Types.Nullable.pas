unit Types.Nullable;

interface

uses
  Classes, SysUtils, System.Rtti, System.TypInfo;

type

  TNullable<T> = record
  private
    FHasValue: Boolean;
    FValue: T;
  public
    function GetValueType: PTypeInfo;
    function GetValue: T;
    procedure SetValue(AValue: T);
    function GetHasValue: Boolean;
  public
    procedure Clear;
    property Value: T read GetValue write SetValue;
    class operator Implicit(A: T): TNullable<T>;
    class operator Implicit(A: Pointer): TNullable<T>;
    function ToString: string;
    function ToTValue: Variant;
    function GetTypeString: string;
    function HasValue: Boolean;
    procedure FromValue(Value: T);
  end;

implementation

{ TNullable }

function TNullable<T>.ToString: string;
begin
  if HasValue then
  begin
    // converter para string
    if TypeInfo(T) = TypeInfo(TDateTime) then
      Result := DateTimeToStr(PDateTime(@FValue)^)
    else if TypeInfo(T) = TypeInfo(TDate) then
      Result := DateToStr(PDateTime(@FValue)^)
    else if TypeInfo(T) = TypeInfo(TTime) then
      Result := TimeToStr(PDateTime(@FValue)^)
    else
      Result := TValue.From<T>(FValue).ToString;
  end
  else
    Result := '';
end;

function TNullable<T>.ToTValue: Variant;
begin
  Result := TValue.From<T>(FValue).AsVariant;
end;

procedure TNullable<T>.FromValue(Value: T);
begin
  SetValue(Value);
end;

function TNullable<T>.GetHasValue: Boolean;
begin
  Result := HasValue;
end;

function TNullable<T>.GetTypeString: string;
var
  PropInfo: TPropInfo;
  Rtti: TRttiContext;
  ltype: TRttiType;
begin
  Rtti := TRttiContext.Create;
  ltype := Rtti.GetType(TypeInfo(T));

  Result := ltype.Name;

end;

function TNullable<T>.GetValue: T;
begin
  if FHasValue then
    Result := FValue
  else
    raise Exception.Create('variável é nula');
end;

function TNullable<T>.GetValueType: PTypeInfo;
begin
  Result := TypeInfo(T);
end;

function TNullable<T>.HasValue: Boolean;
begin
  Result := FHasValue
end;

procedure TNullable<T>.SetValue(AValue: T);
begin
  FValue := AValue;
  FHasValue := True;
end;

procedure TNullable<T>.Clear;
begin
  FHasValue := False;
end;

class operator TNullable<T>.Implicit(A: T): TNullable<T>;
begin
  Result.Value := A;
end;

class operator TNullable<T>.Implicit(A: Pointer): TNullable<T>;
begin
  if A = nil then
    Result.Clear
  else
    raise Exception.Create('Pointer value not allowed');
end;

end.
