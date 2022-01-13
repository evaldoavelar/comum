unit Helpers.HelperDate;

interface

uses
  System.SysUtils, System.DateUtils;

type

  THelperDate = record helper for TDate

    procedure Encode(Dia, mes, ano: Word);
    procedure SetDateNow;
    procedure EncodeStr(Dia, mes, ano: string);
    procedure ReplaceTimer; overload;
    procedure ReplaceTimer(aHora, aMin, aSec, aMil: Word); overload;
    function ToString: string;
    function FormatoDataBr: string;

    function DiaSemana: Integer;
    function PrimeiroDiaSemana: TDate;
    function UltimoDiaSemana: TDate;
    function PrimeiroDiaMes: Integer;
    function ano: Integer;
    function mes: Integer;
    function UltimoDiaMes: Integer;
  end;

implementation

function THelperDate.DiaSemana: Integer;
begin
  Result := DayOfTheWeek(Self)
end;

function THelperDate.UltimoDiaMes: Integer;
var
  ano, mes, Dia: Word;
  temp: TDate;
begin
  DecodeDate(Self, ano, mes, Dia);

  mes := mes + 1;
  if mes = 13 then
  begin
    mes := 1;
    ano := ano + 1;
  end;
  temp := EncodeDate(ano, mes, 1) - 1;

  Result := DayOf(temp);
end;

function THelperDate.PrimeiroDiaSemana: TDate;
var
  dtSunday: TDateTime;
begin
  Result := StartOfTheWeek(Self);
end;

function THelperDate.UltimoDiaSemana: TDate;
var
  dtSunday: TDateTime;
begin
  Result := EndOfTheWeek(Self);
end;

function THelperDate.PrimeiroDiaMes: Integer;
begin
  Result := 1;
end;

function THelperDate.ano: Integer;
var
  ano, mes, Dia: Word;
begin
  DecodeDate(Self, ano, mes, Dia);
  Result := ano;
end;

function THelperDate.mes: Integer;
var
  ano, mes, Dia: Word;
begin
  DecodeDate(Self, ano, mes, Dia);
  Result := mes;
end;

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

function THelperDate.FormatoDataBr: string;
begin
  Result := FormatDateTime('dd/mm/yyyy', Self);
end;

procedure THelperDate.ReplaceTimer(aHora, aMin, aSec, aMil: Word);
var
  newTime: TDateTime;
  data: TDateTime;
begin
  newTime := EncodeTime(aHora, aMin, aSec, aMil);
  data := Self;
  ReplaceTime(data, newTime);
  Self := data;

end;

procedure THelperDate.ReplaceTimer;
var
  newTime: TDateTime;
  data: TDateTime;
begin
  newTime := EncodeTime(0, 0, 0, 0);
  data := Self;
  ReplaceTime(data, newTime);
  Self := data;

end;

procedure THelperDate.SetDateNow;
begin
  Self := Now;
end;

function THelperDate.ToString: string;
begin
  Result := DateToStr(Self);
end;

end.
