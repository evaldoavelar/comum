unit Utils.IO;

interface

uses
  Classes;

type
  TUtilsIO = class
  public
    class function UltimaAlteracao(aFile: string): TDateTime;
    class function ListarArquivos(Diretorio, Extencao: string; SubDiretorio: Boolean): TStringList;
    class procedure DeleteArquivosAntigos(aDiretorio: string; aExtencao: string; SubDiretorio: Boolean; aNumDiasAposCriacao: integer);
  end;

implementation

uses
  SysUtils, Windows, DateUtils;

{ TUtilsIO }

class procedure TUtilsIO.DeleteArquivosAntigos(aDiretorio, aExtencao: string; SubDiretorio: Boolean; aNumDiasAposCriacao: integer);
var
  LArquivos: TStringList;
  LDataAlteracao: TDateTime;
  I: integer;
begin
  LArquivos := ListarArquivos(aDiretorio, aExtencao, SubDiretorio);

  for I := 0 to LArquivos.Count - 1 do
  begin
    LDataAlteracao := UltimaAlteracao(LArquivos[I]);

    if (DaysBetween(now, LDataAlteracao) > aNumDiasAposCriacao) then
      DeleteFile(Pwidechar(LArquivos[I]));
  end;

  LArquivos.Free;
end;

class function TUtilsIO.UltimaAlteracao(aFile: string): TDateTime;
var
  FileH: THandle;
  LocalFT: TFileTime;
  DosFT: DWord;
  FindData: TWin32FindData;
begin

  Result := 0;

  FileH := FindFirstFile(PChar(aFile), FindData);

  if FileH <> INVALID_HANDLE_VALUE then
  begin
    // Windows.FindClose(nil);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFT);
      FileTimeToDosDateTime(LocalFT, LongRec(DosFT).Hi, LongRec(DosFT).Lo);
      Result := FileDateToDatetime(DosFT);
    end;
  end;
end;

class function TUtilsIO.ListarArquivos(Diretorio, Extencao: string; SubDiretorio: Boolean): TStringList;
  function TemAtributo(Attr, Val: integer): Boolean;
  begin
    Result := (Attr and Val = Val);
  end;

var
  F: TSearchRec;
  Ret: integer;
  TempNome: string;
begin

  Result := TStringList.Create;

  Ret := FindFirst(Diretorio + '\*.*', faAnyFile, F);
  try
    while Ret = 0 do
    begin
      if TemAtributo(F.Attr, faDirectory) then
      begin
        if (F.Name <> '.') and (F.Name <> '..') then
          if SubDiretorio then
          begin
            TempNome := Diretorio + '\' + F.Name;
            Result.AddStrings(ListarArquivos(TempNome, Extencao, True));
          end;
      end
      else
      begin
        if Pos(Extencao, LowerCase(F.Name)) > 0 then
          Result.Add(Diretorio + '\' + F.Name);
      end;
      Ret := FindNext(F);
    end;
  finally
    begin
      SysUtils.FindClose(F);
    end;
  end;

end;

end.
