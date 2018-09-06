unit JSON.Atributes.Funcoes;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Rtti, JSON.Atributes;

type
  TProperties = array of TRttiProperty;

  TJsonAtributosFuncoes = class
    class function Ignore<T: class>(prop: TRttiProperty): boolean; static;
  end;

implementation

{ TJsonAtributosFuncoes }

class function TJsonAtributosFuncoes.Ignore<T>(prop: TRttiProperty): boolean;
var
  attr: TCustomAttribute;
begin
  Result := false;
  try
    for attr in prop.GetAttributes do
    begin
      if attr is JSONFieldIgnoreAttribute then
      begin
        Result := JSONFieldIgnoreAttribute(attr).Ignore;
        Break;
      end;
    end;

  except
    on E: Exception do
      raise Exception.create('TJsonAtributosFuncoes.Ignore: ' + E.Message);
  end;

end;

end.
