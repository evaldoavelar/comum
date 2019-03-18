unit Utils.Funcoes;

interface

uses
  Winapi.Windows,
  Winapi.ImageHlp,
  System.StrUtils,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.TypInfo,
  System.Generics.Defaults,
  Winapi.ShellAPI,
  IdHashMessageDigest, System.Variants;

type
  TStrArray = array of string;
  TComparaVersao = (stMenor, stMaior, stIguais);

  TUtil = class
  private

  public
    class function FileVersionInfo(Arquivo: string): string;
    class function GetVersionInfo: string;
    class function Explode(text: string; const Ch: char): TStringList; overload; static;
    class function ExplodeTrim(text: string; const Ch: char): TStringList; static;
    class function Explode(var AFields: TStrArray; ADelimiter, ATexto: String): Integer; overload; static;
    class function ValidaCPF(cpfcnpj: string): Boolean; static;
    class function ValidaCNPJ(CNPJ: string): Boolean; static;
    class function Truncar(Valor: currency; casas: Integer): currency;
    class function CompararVersao(const versao1: TFileName; const versao2: TFileName): TComparaVersao;
    class function IFF<T>(aExpressao: Boolean; aResultFalse: T; aResultTrue: T): T;
    class function IsEmptyOrNull(const Value: Variant): Boolean;
    class function MD5String(text: string): string;
    class function ExtrairNumeros(text: string): string;
    class function DiretorioAplicacao: string;
    class procedure AbrirDiretorio(aHandle: HWND; aDir: string);
    class function DataCriacaoAplicacao(): TDate;
    class function RemoveChar(text: string; Caracter: char): string;

    class function AppIsRunning(ActivateIt: Boolean; ApplicationTitle: string): Boolean;
  end;

implementation

class function TUtil.DataCriacaoAplicacao(): TDate;
var
  LI: TLoadedImage;
begin
  Win32Check(MapAndLoad(PAnsiChar(AnsiString(ParamStr(0))), nil, @LI, False, True));
  Result := LI.FileHeader.FileHeader.TimeDateStamp / SecsPerDay +
    UnixDateDelta;
  UnMapAndLoad(@LI);
end;

class function TUtil.DiretorioAplicacao: string;
begin
  Result := ExtractFileDir(ParamStr(0)) + TPath.DirectorySeparatorChar;
end;

class function TUtil.RemoveChar(text: string; Caracter: char): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(text) do
  begin
    if text[i] <> Caracter then
    begin
      Result := Result + text[i];
    end;
  end;
end;

class procedure TUtil.AbrirDiretorio(aHandle: HWND; aDir: string);
begin
  ShellExecute(aHandle, 'open', 'explorer.exe',
    PChar('"' + aDir + '"'), nil, SW_NORMAL);
end;

class function TUtil.AppIsRunning(ActivateIt: Boolean; ApplicationTitle: string): Boolean;
var
  hSem: THandle;
  hWndMe: HWND;
  AppTitle: string;
begin
  Result := False;
  AppTitle := ApplicationTitle;
  hSem := CreateSemaphore(nil, 0, 1, PChar(AppTitle));
  if ((hSem <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS)) then
  begin
    CloseHandle(hSem);
    Result := True;
  end;
  if Result and ActivateIt then
  begin
    ApplicationTitle := 'zzzzzzz';
    hWndMe := FindWindow(nil, PChar(AppTitle));
    if (hWndMe <> 0) then
    begin
      if IsIconic(hWndMe) then
      begin
        ShowWindow(hWndMe, SW_SHOWNORMAL);
      end
      else
      begin
        SetForegroundWindow(hWndMe);
      end;
    end;
  end;

end;

class function TUtil.CompararVersao(const versao1: TFileName; const versao2: TFileName): TComparaVersao;
var
  Items1: TStrings;
  Items2: TStrings;
  i: Integer;
  e1: Integer;
  e2: Integer;
begin
  Result := stIguais;
  Items1 := TStringList.Create;
  Items2 := TStringList.Create;
  try
    Items1.Delimiter := '.';
    Items1.DelimitedText := versao1;
    Items2.Delimiter := '.';
    Items2.DelimitedText := versao2;
    if Items1.Count <> Items2.Count then
      raise Exception.Create('Não é possível comparar as versões, numero de pontos diverge!');

    for i := 0 to Items1.Count - 1 do
    begin
      e1 := StrToIntDef(Items1[i], -1);
      e2 := StrToIntDef(Items2[i], -1);
      if e2 > e1 then
        Result := stMaior
      else if e2 < e1 then
        Result := stMenor;
      if Result <> stIguais then
        Exit;
    end;
  finally
    Items1.free;
    Items2.free;
  end;
end;

class function TUtil.Truncar(Valor: currency; casas: Integer): currency;
var
  stValor: string;
begin
  stValor := CurrToStr(Valor);
  if Pos(FormatSettings.DecimalSeparator, stValor) = 0 then
    stValor := stValor + FormatSettings.DecimalSeparator;
  stValor := stValor + '0000';
  stValor := Copy(stValor, 1, Pos(FormatSettings.DecimalSeparator, stValor) + casas);
  Result := StrToCurr(stValor);
end;

class function TUtil.FileVersionInfo(Arquivo: string): string;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PWideChar(Arquivo), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(Arquivo), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
          Result := Format('%d.%d.%d.%d', [
            HiWord(dwFileVersionMS), // Major
            LoWord(dwFileVersionMS), // Minor
            HiWord(dwFileVersionLS), // Release
            LoWord(dwFileVersionLS)]); // Build
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;

end;

class function TUtil.GetVersionInfo: string;
begin
  Result := FileVersionInfo(ParamStr(0));
end;

class function TUtil.IFF<T>(aExpressao: Boolean; aResultFalse, aResultTrue: T): T;
begin
  if (aExpressao) then
  begin
    Result := aResultTrue
  end
  else
  begin
    Result := aResultFalse
  end;
end;

class function TUtil.IsEmptyOrNull(const Value: Variant): Boolean;
begin
  Result := VarIsClear(Value) or VarIsEmpty(Value) or VarIsNull(Value) or (VarCompareValue(Value, Unassigned) = vrEqual);
  if (not Result) and VarIsStr(Value) then
    Result := Value = '';
end;

class function TUtil.MD5String(text: string): string;
begin
  with TIdHashMessageDigest5.Create do
    try
      Result := HashStringAsHex(text);
    finally
      free;
    end;
end;

class function TUtil.Explode(text: string; const Ch: char): TStringList;
var
  c: word;
  Source: string;
begin
  Result := TStringList.Create;
  c := 0;

  Source := text;
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

class function TUtil.Explode(var AFields: TStrArray; ADelimiter, ATexto: String): Integer;
var
  sTexto: String;
begin
  Result := 0;
  sTexto := ATexto + ADelimiter;
  if Copy(sTexto, 1, 1) = ADelimiter then
    Delete(sTexto, 1, 1);
  repeat
    SetLength(AFields, Length(AFields) + 1);
    AFields[Result] := Copy(sTexto, 0, Pos(ADelimiter, sTexto) - 1);
    Delete(sTexto, 1, Length(AFields[Result] + ADelimiter));
    inc(Result);
  until (sTexto = '');
end;

class function TUtil.ExplodeTrim(text: string; const Ch: char): TStringList;
var
  i: Integer;
begin
  Result := Explode(text, Ch);

  for i := 0 to Result.Count - 1 do
  begin
    Result.Strings[i] := Trim(Result.Strings[i]);
  end;
end;

class function TUtil.ExtrairNumeros(text: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(text) do
    if (text[i] in ['0' .. '9']) then
    begin
      Result := Result + text[i];
    end;
end;

class function TUtil.ValidaCNPJ(CNPJ: string): Boolean;
var
  dg1, dg2: Integer;
  x, total: Integer;
  ret: Boolean;
begin
  ret := False;

  // Analisa os formatos
  if Length(CNPJ) = 18 then
    if (Copy(CNPJ, 3, 1) + Copy(CNPJ, 7, 1) + Copy(CNPJ, 11, 1) + Copy(CNPJ, 16, 1) = '../-') then
    begin
      CNPJ := Copy(CNPJ, 1, 2) + Copy(CNPJ, 4, 3) + Copy(CNPJ, 8, 3) + Copy(CNPJ, 12, 4) + Copy(CNPJ, 17, 2);
      ret := True;
    end;
  if Length(CNPJ) = 14 then
  begin
    ret := True;
  end;
  // Verifica
  if ret then
  begin
    try
      // 1° digito
      total := 0;
      for x := 1 to 12 do
      begin
        if x < 5 then
          inc(total, StrToInt(Copy(CNPJ, x, 1)) * (6 - x))
        else
          inc(total, StrToInt(Copy(CNPJ, x, 1)) * (14 - x));
      end;
      dg1 := 11 - (total mod 11);
      if dg1 > 9 then
        dg1 := 0;
      // 2° digito
      total := 0;
      for x := 1 to 13 do
      begin
        if x < 6 then
          inc(total, StrToInt(Copy(CNPJ, x, 1)) * (7 - x))
        else
          inc(total, StrToInt(Copy(CNPJ, x, 1)) * (15 - x));
      end;
      dg2 := 11 - (total mod 11);
      if dg2 > 9 then
        dg2 := 0;
      // Validação final
      if (dg1 = StrToInt(Copy(CNPJ, 13, 1))) and (dg2 = StrToInt(Copy(CNPJ, 14, 1))) then
        ret := True
      else
        ret := False;
    except
      ret := False;
    end;
    // Inválidos
    case AnsiIndexStr(CNPJ, ['00000000000000', '11111111111111', '22222222222222', '33333333333333', '44444444444444',
      '55555555555555', '66666666666666', '77777777777777', '88888888888888', '99999999999999']) of

      0 .. 9:
        ret := False;

    end;
  end;
  Result := ret;

end;

class function TUtil.ValidaCPF(cpfcnpj: string): Boolean;
var
  i: Integer;
  Want: char;
  Wvalid: Boolean;
  Wdigit1, Wdigit2: Integer;

begin

  if cpfcnpj = '' then
  begin
    Result := False;
    Exit;
  end;

  Wdigit1 := 0;
  Wdigit2 := 0;
  Want := cpfcnpj[1]; // variavel para testar se o cpfcnpj é repetido como 111.111.111-11
  Delete(cpfcnpj, ansipos('.', cpfcnpj), 1); // retira as mascaras se houver
  Delete(cpfcnpj, ansipos('.', cpfcnpj), 1);
  Delete(cpfcnpj, ansipos('-', cpfcnpj), 1);

  if Length(cpfcnpj) <> 11 then
  begin
    Result := False;
    Exit;
  end;

  // testar se o cpfcnpj é repetido como 111.111.111-11
  for i := 1 to Length(cpfcnpj) do
  begin
    if cpfcnpj[i] <> Want then
    begin
      Wvalid := True; // se o cpfcnpj possui um digito diferente ele passou no primeiro teste
      Break
    end
    else
      Wvalid := False;
  end;
  // se o cpfcnpj é composto por numeros repetido retorna falso
  if Wvalid = False then
  begin
    Result := False;
    Exit;
  end;

  // executa o calculo para o primeiro verificador
  for i := 1 to 9 do
  begin
    Wdigit1 := Wdigit1 + (StrToInt(cpfcnpj[10 - i]) * (i + 1));
  end;

  // Wdigit1 :=( (  (11 – (Wdigit1 mod 11) ) mod 11) mod 10 );
  Wdigit1 := (((11 - (Wdigit1 mod 11)) mod 11) mod 10);

  // verifica se o 1° digito confere
  if IntToStr(Wdigit1) <> cpfcnpj[10] then
  begin
    Result := False;
    Exit;
  end;

  for i := 1 to 10 do
  begin
    Wdigit2 := Wdigit2 + (StrToInt(cpfcnpj[11 - i]) * (i + 1));
  end;
  Wdigit2 := (((11 - (Wdigit2 mod 11)) mod 11) mod 10);
  { formula do segundo verificador
    soma=1°*2+2°*3+3°*4.. até 10°*11
    digito1 = 11 – soma mod 11
    se digito > 10 digito1 =0
  }

  // confere o 2° digito verificador
  if IntToStr(Wdigit2) <> cpfcnpj[11] then
  begin
    Result := False;
    Exit;
  end;

  // se chegar até aqui o cpf é valido
  Result := True;
end;

end.
