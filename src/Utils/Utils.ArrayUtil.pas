unit Utils.ArrayUtil;

interface

uses System.Classes, System.SysUtils, System.RTLConsts, System.Rtti,
  System.Generics.Defaults, System.Generics.Collections;

type

  // callback function for function ForEach
  TArrayForEachCallback<T> = reference to procedure(var Value: T; Index: integer);

  // callback function for function Map
  TArrayMapCallback<T> = reference to function(var Value: T; Index: integer): boolean;

  // callback function for function MapTo
  TArrayConvert<T, TTo> = reference to function(const Value: T): TTo;

  // callback function for function Find
  TArrayFindCallback<T> = reference to function(const Value: T): boolean;

  TArrayUtil = class
  public
    class procedure Append<T>(var Arr: TArray<T>; Value: T); overload;
    class procedure Append<T>(var Arr1: TArray<T>; const Arr2: array of T); overload;
    class function ConcatStr<T>(var Arr1: TArray<string>; aDelimitador: Char): string; overload;
    class function ConcatStr<T>(var Arr1: TArray<integer>; aDelimitador: Char): string; overload;
    class function Indexof<T>(var Values: TArray<T>; Item: T): integer; overload; static;
    class function Indexof<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): integer; overload; static;

    class procedure Delete<T>(var Values: TArray<T>; Index: integer); static;
    class procedure Insert<T>(var Values: TArray<T>; Index: integer; Value: T); static;
    class function Contains<T>(var Values: TArray<T>; Item: T): boolean; overload; static;
    class function Contains<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): boolean; overload; static;

    class function Compare<T>(const Values, ValuesToCompare: array of T): boolean; overload; static;
    class function Compare<T>(const Values, ValuesToCompare: array of T; const Comparer: IComparer<T>): boolean; overload; static;
    class procedure ForEach<T>(var Values: TArray<T>; const Callback: TArrayForEachCallback<T>); static;
    class function Find<T>(const Values: TArray<T>; const Callback: TArrayFindCallback<T>; const StartIndex: integer = 0): integer; overload; static;
    class function Map<T>(const Values: TArray<T>; const Callback: TArrayMapCallback<T>): TArray<T>; static;

    class function ToVariant<T>(const Values: TArray<T>): TArray<TValue>;
  end;

implementation

{ TArrayUtil }

class procedure TArrayUtil.Append<T>(var Arr: TArray<T>; Value: T);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := Value;
end;

class procedure TArrayUtil.Append<T>(var Arr1: TArray<T>; const Arr2: array of T);
var
  I, Index: integer;
begin
  Index := Length(Arr1);
  SetLength(Arr1, Length(Arr1) + Length(Arr2));
  for I := Low(Arr2) to High(Arr2) do
    Arr1[Index + I] := Arr2[I];
end;

class function TArrayUtil.Compare<T>(const Values,
  ValuesToCompare: array of T; const Comparer: IComparer<T>): boolean;
var
  I: integer;
begin
  if Length(Values) <> Length(ValuesToCompare) then
    EXIT(FALSE);
  for I := Low(Values) to High(Values) do
    if Comparer.Compare(Values[I], ValuesToCompare[I]) <> 0 then
      EXIT(FALSE);
  Result := TRUE;
end;

class function TArrayUtil.Compare<T>(const Values,
  ValuesToCompare: array of T): boolean;
begin
  Result := Compare<T>(Values, ValuesToCompare, TComparer<T>.Default);
end;

class function TArrayUtil.ConcatStr<T>(var Arr1: TArray<integer>;
  aDelimitador: Char): string;
var
  I: integer;
begin
  Result := '';
  for I := Low(Arr1) to High(Arr1) do
  begin
    if I > 0 then
      Result := Result + ',';

    Result := Result + QuotedStr(Arr1[I].ToString);

  end;
end;

class function TArrayUtil.Contains<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): boolean;
begin
  Result := Indexof<T>(Values, Item, Comparer) <> -1;
end;

class function TArrayUtil.Contains<T>(var Values: TArray<T>; Item: T): boolean;
begin
  Result := Contains<T>(Values, Item, TComparer<T>.Default);
end;

class procedure TArrayUtil.Delete<T>(var Values: TArray<T>; Index: integer);
var
  I: integer;
begin
  if (Index < Low(Values)) or (Index > High(Values)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  for I := Index + 1 to High(Values) do
    Values[I - 1] := Values[I];
  SetLength(Values, Length(Values) - 1);
end;

class function TArrayUtil.Find<T>(const Values: TArray<T>;
  const Callback: TArrayFindCallback<T>; const StartIndex: integer): integer;
begin
  if (Length(Values) = 0) or (StartIndex < 0) or (StartIndex > High(Values)) then
    EXIT(-1);
  for Result := StartIndex to High(Values) do
    if Callback(Values[Result]) then
      EXIT;
  Result := -1;
end;

class procedure TArrayUtil.ForEach<T>(var Values: TArray<T>;
  const Callback: TArrayForEachCallback<T>);
var
  I: integer;
begin
  for I := Low(Values) to High(Values) do
    Callback(Values[I], I);
end;

class function TArrayUtil.Indexof<T>(var Values: TArray<T>; Item: T; const Comparer: IComparer<T>): integer;
begin
  for Result := Low(Values) to High(Values) do
    if Comparer.Compare(Values[Result], Item) = 0 then
      EXIT;
  Result := -1;
end;

class function TArrayUtil.Indexof<T>(var Values: TArray<T>; Item: T): integer;
begin
  Result := Indexof<T>(Values, Item, TComparer<T>.Default);
end;

class procedure TArrayUtil.Insert<T>(var Values: TArray<T>; Index: integer;
  Value: T);
var
  I, H: integer;
begin
  if (Index < Low(Values)) or (Index > Length(Values)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
  H := High(Values);
  SetLength(Values, Length(Values) + 1);
  for I := H downto Index do
    Values[I + 1] := Values[I];
  Values[Index] := Value;
end;

class function TArrayUtil.Map<T>(const Values: TArray<T>;
  const Callback: TArrayMapCallback<T>): TArray<T>;
var
  Item: T;
  I: integer;
begin
  Result := NIL;
  for I := Low(Values) to High(Values) do
  begin
    Item := Values[I];
    if Callback(Item, I) then
      Append<T>(Result, Item);
  end;
end;

class function TArrayUtil.ToVariant<T>(
  const Values: TArray<T>): TArray<TValue>;
var
  Item: T;
  I: integer;
begin
  SetLength(Result, Length(Values));
  for I := Low(Values) to High(Values) do
  begin
    Result[I] := TValue.From<T>(Values[I]);
  end;
end;

class function TArrayUtil.ConcatStr<T>(var Arr1: TArray<string>;
  aDelimitador: Char): string;
var
  I: integer;
begin
  Result := '';
  for I := Low(Arr1) to High(Arr1) do
  begin
    if I > 0 then
      Result := Result + ',';

    Result := Result + QuotedStr(Arr1[I]);
  end;
end;

end.
