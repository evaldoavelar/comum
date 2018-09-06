unit Model.Validadores.DePara;

interface

uses Model.ModelBase, Model.Administradora, Model.Validadores,
  System.Classes, System.SysUtils, Utils.Funcoes, Model.DePara;

type

  TDeParaValidador = class(TInterfacedObject, IValidador)
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

{ TDeParaValidador }

constructor TDeParaValidador.create;
begin
  FErros := TStringList.create;
end;

destructor TDeParaValidador.destroy;
begin
  FErros.Free;
  inherited;
end;

function TDeParaValidador.getErros: TStringList;
begin
  Result := FErros;
end;

procedure TDeParaValidador.setErros(value: TStringList);
begin
  FErros := value;
end;

function TDeParaValidador.Validar(obj: TModelBase): Boolean;
var
  item: TDePara;
begin
  FErros.Clear;

  item := TDePara(obj);

  if (item.IDADMINISTRADORA = 0) then
    FErros.Add('ID ADMINISTRADORA não informado!');

  if (item.NOME.isEmpty) then
    FErros.Add('Nome não informado!');

  if (item.NOME.Length > 30) then
    FErros.Add('Tamanho maximo para Nome é 30!');

  if (item.DESCFORMAPAGTO.isEmpty) then
    FErros.Add('DESCFORMAPAGTO não informado!');

  if (item.IDFORMAPAGTO = 0) then
    FErros.Add('IDFORMAPAGTO não informado!');

  if (item.DESCFORMAPAGTO.Length > 30) then
    FErros.Add('Tamanho maximo para DESCFORMAPAGTO é 30!');

  Result := FErros.count = 0;

end;

end.
