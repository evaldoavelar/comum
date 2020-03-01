unit Helpers.HelperString;

interface

uses Utils.Funcoes,
  System.MaskUtils,
  System.RegularExpressions,
  System.Classes,
  System.StrUtils,
  System.SysUtils;

type

  TStringHelper = record helper for
    string
      public
    function ValidaCPF: Boolean;
    function ValidaCNPJ: Boolean;
    function FormataCPF: string;
    function FormataCNPJ: string;
    function ValidaEMAIL: Boolean;
    function ToCurrency: Currency;
    function GetNumbers: string;
    function RemoveAcentos: string;
    function Explode(const Ch: char): TStringList;
    function SubString(PosInicial, PosFinal: integer): string;
    function LeftPad(Ch: char; Len: integer): string;
    function RightPad(Ch: char; Len: integer): string;
    function ToInt(): integer;
    function TrimAll(): string;
    function Count: integer;
    function IsEmpty: Boolean;
    function Replace(const OldValue, NewValue: string): string;
  end;

implementation

{ TStringHelper }



function TStringHelper.Replace(const OldValue, NewValue: string): string;
begin
  Result := System.SysUtils.StringReplace(Self, OldValue, NewValue, [rfReplaceAll]);
end;

function TStringHelper.ValidaEMAIL: Boolean;
var
  aStr: string;
begin
  Result := True;
  aStr := Self.TrimAll;

  if aStr.IsEmpty then
    Exit;

  if Pos('@', aStr) > 1 then
  begin
    Delete(aStr, 1, Pos('@', aStr));
    Result := (Length(aStr) > 0) and (Pos('.', aStr) > 2);
  end
  else
    Result := False;
end;

function TStringHelper.RemoveAcentos: string;
{$IFdef  MSWINDOWS}
type
  USAscii20127 = type AnsiString(20127);
{$ENDIF}
begin

{$IFdef  MSWINDOWS}
  RESULT := string(USAscii20127(Self));
{$ENDIF}

end;

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

function TStringHelper.Count: integer;
begin
  Result := Length(Self)
end;

function TStringHelper.SubString(PosInicial, PosFinal: integer): string;
begin
  Result := Copy(Self, PosInicial, PosFinal - PosInicial);
end;

function TStringHelper.ToCurrency: Currency;
var
  aux: string;
begin
  aux := StringReplace(Self, '.', '', [rfReplaceAll]);
  aux := StringReplace(aux, 'R$', '', [rfReplaceAll]);
  Result := StrToCurr(aux);
end;

function TStringHelper.ToInt: integer;
begin
  Result := strToInt(Self);
end;

function TStringHelper.TrimAll: string;
begin
  Result := Trim(Self);
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

function TStringHelper.FormataCNPJ: string;
begin
  Result := FormatmaskText('00\.000\.000\/0000\-00;0;', Self.GetNumbers());
end;

function TStringHelper.FormataCPF: string;
begin
  Result := FormatmaskText('000\.000\.000\-00;0', Self.GetNumbers());
end;

function TStringHelper.GetNumbers: string;
begin
  Result := TRegEx.Replace(Self, '\D', '');
end;

function TStringHelper.IsEmpty: Boolean;
begin
  Result := Self = ''
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
