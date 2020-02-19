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
  end;

implementation

{ TStringHelper }

function TStringHelper.ValidaEMAIL: Boolean;
var
  aStr: string;
begin
  RESULT := True;
  aStr := Self.TrimAll;

  if aStr.IsEmpty then
    Exit;

  if Pos('@', aStr) > 1 then
  begin
    Delete(aStr, 1, Pos('@', aStr));
    RESULT := (Length(aStr) > 0) and (Pos('.', aStr) > 2);
  end
  else
    RESULT := False;
end;

function TStringHelper.RemoveAcentos: string;
{$IF  MSWINDOWS}
type
  USAscii20127 = type AnsiString(20127);
{$ENDIF}
begin
{$IF  MSWINDOWS}
  RESULT := string(USAscii20127(Self));
{$ENDIF}
end;

function TStringHelper.RightPad(Ch: char; Len: integer): string;
var
  RestLen: integer;
begin
  RESULT := Self;
  RestLen := Len - Length(Self);
  if RestLen > 0 then
    RESULT := StringOfChar(Ch, RestLen) + Self
  else
    RESULT := LeftStr(Self, Len);; // StrCopy(PWideChar(S), 1, len);
end;

function TStringHelper.LeftPad(Ch: char; Len: integer): string;
var
  RestLen: integer;
begin
  RESULT := Self;
  RestLen := Len - Length(Self);
  if RestLen > 0 then
    RESULT := Self + StringOfChar(Ch, RestLen)
  else
    RESULT := LeftStr(Self, Len); // StrCopy(PWideChar(S), 1, len);
end;

function TStringHelper.Count: integer;
begin
  RESULT := Length(Self)
end;

function TStringHelper.SubString(PosInicial, PosFinal: integer): string;
begin
  RESULT := Copy(Self, PosInicial, PosFinal - PosInicial);
end;

function TStringHelper.ToCurrency: Currency;
var
  aux: string;
begin
  aux := StringReplace(Self, '.', '', [rfReplaceAll]);
  aux := StringReplace(aux, 'R$', '', [rfReplaceAll]);
  RESULT := StrToCurr(aux);
end;

function TStringHelper.ToInt: integer;
begin
  RESULT := strToInt(Self);
end;

function TStringHelper.TrimAll: string;
begin
  RESULT := Trim(Self);
end;

function TStringHelper.Explode(const Ch: char): TStringList;
var
  c: word;
  Source: string;
begin
  RESULT := TStringList.Create;
  c := 0;

  Source := Self;
  while Source <> '' do
  begin
    if Pos(Ch, Source) > 0 then
    begin
      RESULT.ADD(Copy(Source, 1, Pos(Ch, Source) - 1));
      Delete(Source, 1, Length(RESULT[c]) + Length(Ch));
    end
    else
    begin
      RESULT.ADD(Source);
      Source := '';
    end;
    inc(c);
  end;
end;

function TStringHelper.FormataCNPJ: string;
begin
  RESULT := FormatmaskText('00\.000\.000\/0000\-00;0;', Self.GetNumbers());
end;

function TStringHelper.FormataCPF: string;
begin
  RESULT := FormatmaskText('000\.000\.000\-00;0', Self.GetNumbers());
end;

function TStringHelper.GetNumbers: string;
begin
  RESULT := TRegEx.Replace(Self, '\D', '');
end;

function TStringHelper.IsEmpty: Boolean;
begin
  RESULT := Self = ''
end;

function TStringHelper.ValidaCNPJ: Boolean;
begin
  RESULT := TUtil.ValidaCNPJ(Self);
end;

function TStringHelper.ValidaCPF: Boolean;
begin
  RESULT := TUtil.ValidaCPF(Self);
end;

end.
