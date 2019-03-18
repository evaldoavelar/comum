unit Utils.ArrayUtil;

interface

type

  TArrayUtil<T> = class
  public
    class procedure Append(var Arr: TArray<T>; Value: T); overload;
    class procedure Append(var Arr1: TArray<T>; var Arr2: TArray<T>); overload;
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

end.
