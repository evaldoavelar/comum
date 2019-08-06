unit Helpers.HelperCurrency;

interface

uses
  System.SysUtils;

type

  THelperCurrency = record helper for Currency
    function ToReais: string;
    function ToStrDuasCasas: string;
    function ToReiasExtenco: string;
  end;

resourcestring
  strNumeroForaIntervalo = 'THelperCurrency: O valor está fora do intervalo permitido.';

const
  Unidades: array [1 .. 9] of string = ('Um', 'Dois', 'Tres', 'Quatro', 'Cinco', 'Seis', 'Sete', 'Oito', 'Nove');
  Dez: array [1 .. 9] of string = ('Onze', 'Doze', 'Treze', 'Quatorze', 'Quinze', 'Dezesseis', 'Dezessete', 'Dezoito', 'Dezenove');
  Dezenas: array [1 .. 9] of string = ('Dez', 'Vinte', 'Trinta', 'Quarenta', 'Cinquenta', 'Sessenta', 'Setenta', 'Oitenta', 'Noventa');
  Centenas: array [1 .. 9] of string = ('Cento', 'Duzentos', 'Trezentos', 'Quatrocentos', 'Quinhentos', 'Seiscentos', 'Setecentos', 'Oitocentos', 'Novecentos');
  MoedaSigular = 'Real';
  MoedaPlural = 'Reais';
  CentSingular = 'Centavo';
  CentPlural = 'Centavos';

implementation

{ THelperCurrency }

function THelperCurrency.ToReais: string;
begin
  Result := FormatFloat('R$ 0.,00', Self);
end;

function THelperCurrency.ToReiasExtenco: string;
var
  Texto, Milhar, Centena, Centavos: string;
  /// /////////////////////////////fucao auxiliar extenso////////////////////////////////
  function ifs(Expressao: Boolean; CasoVerdadeiro, CasoFalso: string): string;
  begin
    if Expressao then
      Result := CasoVerdadeiro
    else
      Result := CasoFalso;
  end;
/// /////////////////////////funcao auxiliar extenso/////////////////////////
  function MiniExtenso(trio: string): string;
  var
    Unidade, Dezena, Centena: string;
  begin
    Unidade := '';
    Dezena := '';
    Centena := '';
    if (trio[2] = '1') and (trio[3] <> '0') then
    begin
      Unidade := Dez[strtoint(trio[3])];
      Dezena := '';
    end
    else
    begin
      if trio[2] <> '0' then
        Dezena := Dezenas[strtoint(trio[2])];
      if trio[3] <> '0' then
        Unidade := Unidades[strtoint(trio[3])];
    end;
    if (trio[1] = '1') and (Unidade = '') and (Dezena = '') then
      Centena := 'Cem'
    else if trio[1] <> '0' then
      Centena := Centenas[strtoint(trio[1])]
    else
      Centena := '';
    Result := Centena + ifs((Centena <> '') and ((Dezena <> '') or (Unidade <> '')), ' e ', '')
      + Dezena + ifs((Dezena <> '') and (Unidade <> ''), ' e ', '') + Unidade;
  end;

begin
  if (Self > 999999.99) or (Self < 0) then
  begin
    raise Exception.Create(strNumeroForaIntervalo);
  end;
  if Self = 0 then
  begin
    Result := '';
    Exit;
  end;
  Texto := FormatFloat('000000.00', Self);
  Milhar := MiniExtenso(Copy(Texto, 1, 3));
  Centena := MiniExtenso(Copy(Texto, 4, 3));
  Centavos := MiniExtenso('0' + Copy(Texto, 8, 2));
  Result := Milhar;
  if Milhar <> '' then
  begin
    if Copy(Texto, 4, 3) = '000' then
      Result := Result + ' Mil Reais'
    else
      Result := Result + ' Mil ';
  end;
  if (((Copy(Texto, 4, 2) = '00') and (Milhar <> '') and (Copy(Texto, 6, 1) <> '0'))) or (Centavos <> '') and (Milhar <> '') then
    Result := Result + ' e ';
  if (Milhar + Centena <> '') then
    Result := Result + Centena;
  if (Milhar = '') and (Copy(Texto, 4, 3) = '001') then
    Result := Result + ' Real'
  else if (Copy(Texto, 4, 3) <> '000') then
    Result := Result + ' Reais';
  if Centavos = '' then
  begin
    Result := Result + '.';
    Exit;
  end
  else
  begin
    if Milhar + Centena = '' then
      Result := Centavos
    else
      Result := Result + ' e ' + Centavos;
  end;
  if (Copy(Texto, 8, 2) = '01') and (Centavos <> '') then
    Result := Result + ' Centavo.'
  else
    Result := Result + ' Centavos.';

end;

function THelperCurrency.ToStrDuasCasas: string;
begin
    Result := FormatFloat('0.,00', Self);
end;

end.
