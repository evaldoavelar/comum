unit Model.Validadores.Administradora;

interface

uses Model.ModelBase, Model.Administradora, Model.Validadores,
  System.Classes, System.SysUtils, Utils.Funcoes;

type

  TAdministradoraValidador = class(TInterfacedObject, IValidador)
  private
    FErros: TStringList;
    procedure setErros(value: TStringList);
    function getErros: TStringList;
  public
    property Erros: TStringList read getErros write setErros;
    function Validar(obj: TModelBase): Boolean;

    constructor create;
    destructor destroy; override;
  end;

implementation

{ TAdministradoraValidador }

constructor TAdministradoraValidador.create;
begin
  FErros := TStringList.create;
end;

destructor TAdministradoraValidador.destroy;
begin
  FErros.Free;
  inherited;
end;

function TAdministradoraValidador.getErros: TStringList;
begin
  Result := FErros;
end;

procedure TAdministradoraValidador.setErros(value: TStringList);
begin
  FErros := value;
end;

function TAdministradoraValidador.Validar(obj: TModelBase): Boolean;
var
  item: TAdministradora;
begin
  FErros.Clear;

  item := TAdministradora(obj);

  if (item.NOME.isEmpty) then
    FErros.Add('Nome não informado!');

  if (item.NOME.Length > 30) then
    FErros.Add('Tamanho maximo para Nome é 30!');

  if (item.CNPJCREDENCIADORA.isEmpty) then
    FErros.Add('CNPJ CREDENCIADORA não informado!');

  //if (TUtil.ValidaCNPJ(item.CNPJCREDENCIADORA) = false) then
  //  FErros.Add('CNPJ CREDENCIADORA não é Válido!');

  Result := FErros.count = 0;

end;

end.
