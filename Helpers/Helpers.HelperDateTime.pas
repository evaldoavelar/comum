unit Helpers.HelperDateTime;

interface

uses
  System.SysUtils;

type

  THelperDateTime = record helper for TDateTime

    procedure Encode(Dia, mes, ano: Word);
    procedure EncodeStr(Dia, mes, ano: string);
    procedure ReplaceTimer;
    procedure SetDateNow;
    function FormatoDataBr: string;
    function FormatoDataBrExtenco: string;
    function FormatoDataHoraBr: string;
  end;

implementation


procedure THelperDateTime.Encode(Dia, mes, ano: Word);
begin
  Self := EncodeDate(ano, mes, Dia);
end;

procedure THelperDateTime.EncodeStr(Dia, mes, ano: string);
begin
  try
    Self := EncodeDate(StrToInt(ano), StrToInt(mes), StrToInt(Dia));
  except
    raise Exception.Create('TCSTDate: encode inválido!');
  end;
end;

function THelperDateTime.FormatoDataBr: string;
begin
  Result := FormatDateTime('dd/mm/yyyy', Self);
end;

function THelperDateTime.FormatoDataBrExtenco: string;
begin
  Result := Format('%s de %s de %s', [
    FormatDateTime('dd', Self),
    FormatDateTime('mmmm', Self),
    FormatDateTime('yyyy', Self)
    ]);
end;

function THelperDateTime.FormatoDataHoraBr: string;
begin
  Result := FormatDateTime('dd/mm/yyyy hh:mm:ss', Self);
end;

procedure THelperDateTime.ReplaceTimer;
var
  newTime: TDateTime;
begin
  newTime := EncodeTime(0, 0, 0, 0);
  ReplaceTime(Self, newTime);
end;

procedure THelperDateTime.SetDateNow;
begin
  Self := Now;
end;

end.
