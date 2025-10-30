unit Helpers.HelperString;

interface

uses Utils.Funcoes,
  System.MaskUtils,
  System.RegularExpressions,
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  IdHashMessageDigest;

type

  TStringHelper = record helper for
    string
      public
    function ValidaCPF: Boolean;
    function ValidaCNPJ: Boolean;
    function FormataCPF: string;
    function FormataCPFParcial: string;
    function ToUpper: string;
    function ToLower: string;
    function FormataCNPJ: string;
    function FormataCNPJParcial: string;
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
    function MD5: string;
    function Count: integer;
    function Upper: string;
    function IsEmpty: Boolean;
    function StartWith(value: string): Boolean;
    function Replace(const OldValue, NewValue: string): string;
    function ValidarCelular(): Boolean;
    function ValidarCEP(): Boolean;
    function FormataTelefone: string;
    function FormataCEP: string;
    function ToTitle: string;
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
{$IFDEF  MSWINDOWS}
type
  USAscii20127 = type AnsiString(20127);
{$ENDIF}
begin

{$IFDEF  MSWINDOWS}
  Result := string(USAscii20127(Self));
{$ENDIF}

end;

function TStringHelper.RightPad(Ch: char; Len: integer): string;
var
  RestLen: integer;
begin
  Result := Self;

  if Len = 0 then
    Exit;

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

  if Len = 0 then
    Exit;

  RestLen := Len - Length(Self);
  if RestLen > 0 then
    Result := Self + StringOfChar(Ch, RestLen)
  else
    Result := LeftStr(Self, Len); // StrCopy(PWideChar(S), 1, len);
end;

function TStringHelper.MD5: string;
begin
  with TIdHashMessageDigest5.Create do
    try
      Result := HashStringAsHex(Self);
    finally
      Free;
    end;
end;

function TStringHelper.Count: integer;
begin
  Result := Length(Self)
end;

function TStringHelper.StartWith(value: string): Boolean;
begin
  Result := ContainsText(Self, value)
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

function TStringHelper.ToLower: string;
begin
  Result := LowerCase(Self);
end;

function TStringHelper.ToUpper: string;
begin
  Result := UpperCase(Self);
end;

function TStringHelper.TrimAll: string;
begin
  Result := Trim(Self);
end;

function TStringHelper.Upper: string;
begin
  Result := UpperCase(Self);
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

function TStringHelper.FormataCNPJParcial: string;
var
  DigitsOnly: string;
  i: integer;
begin
  // Remove todos os caracteres não numéricos
  DigitsOnly := Self.GetNumbers();

  // Formatar conforme o número de dígitos   31.890.124/0001-13
  case Length(DigitsOnly) of
    1 .. 2:
      Result := DigitsOnly; // Se tiver até 2 dígitos, retorna como está
    3 .. 5:
      Result := Format('%s.%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, Length(DigitsOnly) - 2)]);
    6 .. 8:
      Result := Format('%s.%s.%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, 3), Copy(DigitsOnly, 6, Length(DigitsOnly) - 5)]);
    9 .. 12:
      Result := Format('%s.%s.%s/%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, 3), Copy(DigitsOnly, 6, 3), Copy(DigitsOnly, 9, Length(DigitsOnly) - 8)]);
    13 .. 14: // CNPJ
      Result := Format('%s.%s.%s/%s-%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, 3), Copy(DigitsOnly, 6, 3), Copy(DigitsOnly, 9, 4), Copy(DigitsOnly, 13, 2)]);
  else
    // Se não corresponder ao formato de CPF ou CNPJ, apenas devolve os dígitos
    Result := DigitsOnly;
  end;
end;

function TStringHelper.FormataCPF: string;
begin
  Result := FormatmaskText('000\.000\.000\-00;0', Self.GetNumbers());
end;

function TStringHelper.FormataCPFParcial: string;
var
  DigitsOnly: string;
  i: integer;
begin
  // Remove todos os caracteres não numéricos
  DigitsOnly := Self.GetNumbers();

  // Formatar conforme o número de dígitos
  case Length(DigitsOnly) of
    1 .. 3:
      Result := DigitsOnly; // Se tiver até 3 dígitos, retorna como está
    4:
      Result := Format('%s.%s', [Copy(DigitsOnly, 1, 3), Copy(DigitsOnly, 4, 1)]);
    5 .. 6:
      Result := Format('%s.%s', [Copy(DigitsOnly, 1, 3), Copy(DigitsOnly, 4, Length(DigitsOnly) - 3)]);
    7 .. 9:
      Result := Format('%s.%s.%s', [Copy(DigitsOnly, 1, 3), Copy(DigitsOnly, 4, 3), Copy(DigitsOnly, 7, Length(DigitsOnly) - 6)]);
    10 .. 11: // CPF
      Result := Format('%s.%s.%s-%s', [Copy(DigitsOnly, 1, 3), Copy(DigitsOnly, 4, 3), Copy(DigitsOnly, 7, 3), Copy(DigitsOnly, 10, 2)]);
    12 .. 13:
      Result := Format('%s.%s.%s-%s', [Copy(DigitsOnly, 1, 3), Copy(DigitsOnly, 4, 3), Copy(DigitsOnly, 7, 3), Copy(DigitsOnly, 10, Length(DigitsOnly) - 9)]);
    14: // CNPJ
      Result := Format('%s.%s.%s/%s-%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, 3), Copy(DigitsOnly, 6, 3), Copy(DigitsOnly, 9, 4), Copy(DigitsOnly, 13, 2)]);
  else
    // Se não corresponder ao formato de CPF ou CNPJ, apenas devolve os dígitos
    Result := DigitsOnly;
  end;

end;

function TStringHelper.GetNumbers: string;
begin
  Result := TRegEx.Replace(Self, '\D', '');
end;

function TStringHelper.IsEmpty: Boolean;
begin
  Result := Self = ''
end;

function TStringHelper.ValidarCelular(): Boolean;
var
  ipRegExp: string;
begin
  ipRegExp := '^[1-9]{2}(?:[6-9]|9[1-9])[0-9]{4}[0-9]{4}$';
  Result := TRegEx.IsMatch(Self.GetNumbers(), ipRegExp);
end;

function TStringHelper.ValidarCEP(): Boolean;
var
  DigitsOnly: string;
begin
  DigitsOnly := Self.GetNumbers();
  // CEP válido deve ter exatamente 8 dígitos
  Result := Length(DigitsOnly) = 8;
end;

function TStringHelper.ValidaCNPJ: Boolean;
begin
  Result := TUtil.ValidaCNPJ(Self);
end;

function TStringHelper.ValidaCPF: Boolean;
begin
  Result := TUtil.ValidaCPF(Self);
end;

function TStringHelper.FormataTelefone: string;
var
  DigitsOnly: string;
begin
  // Remove todos os caracteres não numéricos
  DigitsOnly := Self.GetNumbers();

  // Formatar conforme o número de dígitos
  case Length(DigitsOnly) of
    0:
      Result := '';
    1 .. 7:
      Result := DigitsOnly; // Retorna como está se tiver menos de 8 dígitos
    8:
      Result := Format('%s-%s', [Copy(DigitsOnly, 1, 4), Copy(DigitsOnly, 5, 4)]); // 1234-5678
    9:
      Result := Format('%s-%s', [Copy(DigitsOnly, 1, 5), Copy(DigitsOnly, 6, 4)]); // 12345-6789
    10:
      Result := Format('(%s) %s-%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, 4), Copy(DigitsOnly, 7, 4)]); // (12) 3456-7890
    11:
      Result := Format('(%s) %s-%s', [Copy(DigitsOnly, 1, 2), Copy(DigitsOnly, 3, 5), Copy(DigitsOnly, 8, 4)]); // (12) 93456-7890
  else
    Result := DigitsOnly; // Retorna os dígitos sem formatação
  end;
end;

function TStringHelper.FormataCEP: string;
var
  DigitsOnly: string;
begin
  // Remove todos os caracteres não numéricos
  DigitsOnly := Self.GetNumbers();

  // Formatar CEP (12345-678)
  if Length(DigitsOnly) = 8 then
    Result := Format('%s-%s', [Copy(DigitsOnly, 1, 5), Copy(DigitsOnly, 6, 3)])
  else if Length(DigitsOnly) > 0 then
    Result := DigitsOnly
  else
    Result := '';
end;

function TStringHelper.ToTitle: string;
var
  i: integer;
  CapitalizeNext: Boolean;
  c: char;
begin
  if Trim(Self) = '' then
  begin
    Result := Self;
    Exit;
  end;

  Result := LowerCase(Trim(Self));
  CapitalizeNext := True;

  for i := 1 to Length(Result) do
  begin
    c := Result[i];

    if CapitalizeNext and (c <> ' ') then
    begin
      Result[i] := UpCase(c);
      CapitalizeNext := False;
    end;

    // Capitalizar após espaço, hífen ou outros separadores
    if CharInSet(c, [' ', '-', '.', '''', '/', '\']) then
      CapitalizeNext := True;
  end;
end;

end.