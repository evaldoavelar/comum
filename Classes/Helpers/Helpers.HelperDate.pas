unit Helpers.HelperDate;

interface

uses
  System.SysUtils;

type

  THelperDate = record helper for TDate

    procedure Encode(Dia, mes, ano: Word);
    procedure SetDateNow;
    procedure EncodeStr(Dia, mes, ano: string);
    procedure ReplaceTimer;
  end;

implementation

procedure THelperDate.Encode(Dia, mes, ano: Word);
begin
  Self := EncodeDate(ano, mes, Dia);
end;

procedure THelperDate.EncodeStr(Dia, mes, ano: string);
begin
  try
    Self := EncodeDate(StrToInt(ano), StrToInt(mes), StrToInt(Dia));
  except
    raise Exception.Create('TCSTDate: encode inválido!');
  end;
end;

procedure THelperDate.ReplaceTimer;
var
  newTime: TDateTime;
  data:TDateTime;
begin
  newTime := EncodeTime(0, 0, 0, 0);
  data := Self;
  ReplaceTime(data, newTime);
  self := data;

end;

procedure THelperDate.SetDateNow;
begin
  Self := Now;
end;

end.
