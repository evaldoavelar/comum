unit Helpers.HelperString;

interface

uses Utils.Funcoes, System.RegularExpressions, System.Classes, System.StrUtils,
  System.SysUtils;

type

  TStringHelper = record helper for  string
      public
    function ValidaCPF: Boolean;
    function ValidaCNPJ: Boolean;
    function GetNumbers: string;
    function Explode(const Ch: char): TStringList;
    function SubString(PosInicial, PosFinal: integer): string;
    function LeftPad(Ch: char; Len: integer): string;
    function RightPad(Ch: char; Len: integer): string;
    function ToInt(): Integer;
  end;

implementation

{ TStringHelper }

function TStringHelper.RightPad(Ch: char; Len: integer): string;
var
  RestLen: integer;
begin
  Result := Self;
  RestLen := Len - Length(Self);
  if RestLen > 0 then
    Result := StringOfChar(Ch, RestLen) + Self
  else
    Result := LeftStr(Self, Len);; // StrCopy(PWideChar(S), 1, len);
end;

function TStringHelper.LeftPad(Ch: char; Len: integer): string;
var
  RestLen: integer;
begin
  Result := Self;
  RestLen := Len - Length(Self);
  if RestLen > 0 then
    Result := Self + StringOfChar(Ch, RestLen)
  else
    Result := LeftStr(Self, Len); // StrCopy(PWideChar(S), 1, len);
end;

function TStringHelper.SubString(PosInicial, PosFinal: integer): string;
begin
  Result := Copy(Self, PosInicial, PosFinal - PosInicial);
end;

function TStringHelper.ToInt: Integer;
begin
  result := strToInt(self);
end;

function TStringHelper.Explode(const Ch: char): TStringList;
var
  c: word;
  Source: string;
begin
  Result := TStringList.Create;
  c := 0;

  Source := Self;
  while Source <> '' do
  begin
    if Pos(Ch, Source) > 0 then
    begin
      Result.ADD(Copy(Source, 1, Pos(Ch, Source) - 1));
      Delete(Source, 1, Length(Result[c]) + Length(Ch));
    end
    else
    begin
      Result.ADD(Source);
      Source := '';
    end;
    inc(c);
  end;
end;

function TStringHelper.GetNumbers: string;
begin
  Result := TRegEx.Replace(Self, '\D', '');
end;

function TStringHelper.ValidaCNPJ: Boolean;
begin
  Result := TUtil.ValidaCNPJ(Self);
end;

function TStringHelper.ValidaCPF: Boolean;
begin
  Result := TUtil.ValidaCPF(Self);
end;

end.
