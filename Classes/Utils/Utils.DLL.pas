unit Utils.DLL;

interface

uses System.SysUtils, System.Classes, Winapi.Windows;

Type
  TLibHandle = THandle;

  TDLLUtil = Class
  private
    class function FunctionDetect(const LibName, FuncName: String; var LibPointer: Pointer; var LibHandle: TLibHandle): Boolean; overload;
    class function FunctionDetect(const LibName, FuncName: String; var LibPointer: Pointer): Boolean; overload;

  public
    class procedure LoadDLL(NomeDLL, FuncName: String; var LibPointer: Pointer); static;
    class function UnLoadDLL(const LibName: String): Boolean; static;

  End;

implementation


class procedure TDLLUtil.LoadDLL(NomeDLL: string; FuncName: String; var LibPointer: Pointer);
var
  sLibName: String;
begin
  if not Assigned(LibPointer) then
  begin
    sLibName := NomeDLL;
    if ExtractFilePath(sLibName) <> '' then
      if not FileExists(sLibName) then
        raise Exception.Create('Arquivo não encontrado: ' + sLibName);

    if not TDLLUtil.FunctionDetect(sLibName, FuncName, LibPointer) then
    begin
      LibPointer := NIL;
      raise Exception.Create(Format('Função não encontrada:', [FuncName, sLibName]));
    end;
  end;
end;

class function TDLLUtil.UnLoadDLL(const LibName: String): Boolean;
var
  LibHandle: TLibHandle;
begin
  Result := True;

  if LibName = '' then
    Exit;

{$IFDEF FPC}
  LibHandle := dynlibs.LoadLibrary(LibName);
  if LibHandle <> 0 then
    Result := dynlibs.FreeLibrary(LibHandle);
{$ELSE}
{$IFDEF DELPHI12_UP}
  LibHandle := GetModuleHandle(PWideChar(String(LibName)));
{$ELSE}
  LibHandle := GetModuleHandle(PChar(LibName));
{$ENDIF}
  if LibHandle <> 0 then
    Result := FreeLibrary(LibHandle)
{$ENDIF}
end;

class function TDLLUtil.FunctionDetect(const LibName, FuncName: String; var LibPointer: Pointer): Boolean;
Var
  LibHandle: TLibHandle;
begin
  Result := FunctionDetect(LibName, FuncName, LibPointer, LibHandle);
end;

class function TDLLUtil.FunctionDetect(const LibName, FuncName: String; var LibPointer: Pointer;
  var LibHandle: TLibHandle): Boolean;
begin
  Result := false;
  LibPointer := NIL;

  if LoadLibrary(PChar(LibName)) = 0 then
    Exit; { não consegiu ler a DLL }

  LibHandle := GetModuleHandle(PChar(LibName)); { Pega o handle da DLL }

  if LibHandle <> 0 then { Se 0 não pegou o Handle, falhou }
  begin
    LibPointer := GetProcAddress(LibHandle, PChar(FuncName)); { Procura a função }
    if LibPointer <> NIL then
      Result := True;
  end;
end;

end.
