unit Utils.Crypt;

interface

uses
  System.SysUtils, DCPrc4, DCPsha1;

type

  TCrypt = class

  private
   class function StringCripty(chave, buffer: string; Cript: Boolean): string;
  public
    class function CriptografaString(chave: string; buffer: string): string;
    class function DecriptografaString(chave: string; buffer: string): string;
  end;

implementation

{ TCrypt }

class function TCrypt.DecriptografaString(chave: string; buffer: string): string;
begin
  Result := StringCripty(chave, buffer, False);
end;

class function TCrypt.CriptografaString(chave: string; buffer: string): string;
begin
  Result := StringCripty(chave, buffer, True);
end;

class function TCrypt.StringCripty(chave: string; buffer: string;
  Cript: Boolean): string;
var
  Cipher: TDCP_rc4;
begin
  if buffer = '' then
    Exit;
  Cipher := TDCP_rc4.Create(nil);
  Cipher.InitStr(chave, TDCP_sha1);
  // initialize the cipher with a hash of the passphrase[
  if Cript then // se true criptografar
    Result := Cipher.EncryptString(buffer)
  else
    Result := Cipher.DecryptString(buffer);
  Cipher.Burn;
  Cipher.free;

end;

end.
