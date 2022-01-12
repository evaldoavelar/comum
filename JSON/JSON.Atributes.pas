unit JSON.Atributes;

interface

uses
  Classes,
  SysUtils,
  Rtti,
  Neon.Core.Attributes;

type

  JSONFieldIgnoreAttribute = class(NeonIgnoreAttribute)
  private
    FIgnore: Boolean;
    procedure SetIgnore(const Value: Boolean);
  public

    property Ignore: Boolean read FIgnore write SetIgnore;

    constructor Create(aIgnore: Boolean = false);
  end;

implementation

{ JSONAtributes }

constructor JSONFieldIgnoreAttribute.Create(aIgnore: Boolean = false);
begin
  FIgnore := aIgnore;
end;

procedure JSONFieldIgnoreAttribute.SetIgnore(const Value: Boolean);
begin
  FIgnore := Value;
end;

end.
