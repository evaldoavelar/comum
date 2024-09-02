unit Helpers.HelperTJsonValue;

interface

uses
  System.SysUtils,
  System.JSON,
  System.RegularExpressions;

type
  THelperTJsonObject = class helper for TJSONValue

     function IsDate(): Boolean;
     function IsDouble(): Boolean;
     function IsCurrency(): Boolean;
     function IsInteger(): Boolean;
  end;

implementation

{ THelperTJsonObject }

 function THelperTJsonObject.IsCurrency(
  ): Boolean;
var
  CurrencyValue: Currency;
begin
  Result := False;
  if Self is TJSONNumber then
    Result := TryStrToCurr(self.Value, CurrencyValue);

end;

 function THelperTJsonObject.IsDate(): Boolean;
var
  DateStr: string;
  DateOut: TDateTime;
  DateFormat: TFormatSettings;
  Regex: TRegEx;
begin
  Result := False;

  if self is TJSONString then
  begin
    DateStr := self.Value;

    // Tenta analisar a string como uma data
    DateFormat := TFormatSettings.Create;
    DateFormat.DateSeparator := '-';
    DateFormat.ShortDateFormat := 'yyyy-mm-dd';

    // Verifica se é uma data no formato 'yyyy-mm-dd'
    if TryStrToDate(DateStr, DateOut, DateFormat) then
      Exit(True);

    // Expressão regular para verificar formatos de data ISO 8601
    Regex := TRegEx.Create('^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}Z)?$');

    if Regex.IsMatch(DateStr) then
      Exit(True);
  end;
end;

 function THelperTJsonObject.IsDouble(
  ): Boolean;
var
  DoubleValue: Double;
begin
  Result := False;

  // Verifica se o JsonValue é um número
  if self is TJSONNumber then
  begin
    // Tenta converter o valor para Double
    Result := TryStrToFloat(self.Value, DoubleValue);
  end;

end;

 function THelperTJsonObject.IsInteger(
  ): Boolean;
var
  IntValue: Integer;
begin
  Result := False;
  if self is TJSONNumber then
    Result := TryStrToInt(self.value, IntValue);
end;

end.
