unit Utils.ArrayUtil;

interface

uses System.SysUtils;

type

  TArrayUtil<T> = class
  public
    class procedure Append(var Arr: TArray<T>; Value: T); overload;
    class procedure Append(var Arr1: TArray<T>; var Arr2: TArray<T>); overload;
    class function ConcatStr(var Arr1: TArray<string>; aDelimitador: Char): string; overload;
    class function Indexof(var Arr1: TArray<string>; aValue: string): Integer; overload;
  end;

implementation

{ TArrayUtil<T> }

class procedure TArrayUtil<T>.Append(var Arr: TArray<T>; Value: T);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := Value;
end;

class procedure TArrayUtil<T>.Append(var Arr1, Arr2: TArray<T>);
var
  I: Integer;
begin
  for I := Low(Arr2) to High(Arr2) do
    Append(Arr1, Arr2[I]);
end;

class function TArrayUtil<T>.ConcatStr(var Arr1: TArray<string>;
  aDelimitador: Char): string;
var
  I: Integer;
begin
  Result := '';
  for I := Low(Arr1) to High(Arr1) do
  begin
    if I > 0 then
      Result := Result + ',';

    Result := Result + QuotedStr(Arr1[I]);

  end;

end;

class function TArrayUtil<T>.Indexof(var Arr1: TArray<string>; aValue: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(Arr1) to High(Arr1) do
  begin
    if Arr1[I] = aValue then
    begin
      Result := I;
      Break;
    end;

  end;

end;

end.
