unit JSON.Utils.ConverterTypes;

interface

type
  TJsonUtilConverter = (cvIgoreEmptyString, cvIgoreEmptyDate);
  TConverterTypes = array of TJsonUtilConverter;

  TConverterTypesHelper = record helper for TConverterTypes
    function Contains(value: TJsonUtilConverter): Boolean;
  end;

implementation

{ TConverterTypesHelper }

function TConverterTypesHelper.Contains(value: TJsonUtilConverter): Boolean;
var
  item: Integer;
begin
  result := False;

  for item := 0 to Length(self) -1 do
  begin
    if self[item] = value then
      Exit(True);
  end;

end;

end.
