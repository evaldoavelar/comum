unit Helpers.TStringListHelper;

interface

USES Classes, StrUtils, System.SysUtils;

TYPE
  TStringListHelper = CLASS HELPER FOR TStrings
    function ToSQL: STRING;
    function ToSQLInt: STRING;
  END;

implementation

{ TStringListHelper }

function TStringListHelper.ToSQL: string;
VAR
  S: string;
  function QuotedStr(CONST S: string): string;
  BEGIN
    Result := '''' + ReplaceStr(S, '''', '''''') + ''''
  END;

BEGIN
  Result := '';
  FOR S IN Self DO
  BEGIN
    IF Result = '' THEN
      Result := '('
    ELSE
      Result := Result + ',';
    Result := Result + QuotedStr(S)
  END;
  IF Result <> '' THEN
    Result := Result + ')'
END;

function TStringListHelper.ToSQLInt: STRING;
VAR
  S: string;
begin
  Result := '';
  FOR S IN Self DO
  BEGIN
    IF Result = '' THEN
      Result := '('
    ELSE if Trim(S) <> '' then
      Result := Result + S + ',';
  END;

  System.Delete(Result, Length(Result), Length(Result) + 1);

  IF Result <> '' THEN
    Result := Result + ')'

end;

end.
