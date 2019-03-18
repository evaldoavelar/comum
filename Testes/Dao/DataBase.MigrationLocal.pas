unit DataBase.MigrationLocal;

interface

uses DataBase.IDataseMigration, DataBase.TDataseMigrationBase,
  Test.Model.AUTOINC, Test.Model.Pedido, Test.Model.Item, Test.Model.Produto,
  System.SysUtils;

type

  TMigrationLocal = class(TDataseMigrationBase)
  protected
    function Seed(): IDataseMigration; override;
    function GetObjetos: TArrayObject; override;
  end;

implementation

{ TMigrationLocal }

function TMigrationLocal.GetObjetos: TArrayObject;
begin
  setlength(result, 4);
  result[0] := TAUTOINC;
  result[1] := TProduto;
  result[2] := TPedido;
  result[3] := TItemPedido;
end;

function TMigrationLocal.Seed: IDataseMigration;
var
  Produto: TProduto;
begin
  result := Self;

  Produto := TProduto.create;
  Produto.CODIGO := Random(10000).ToString;
  Produto.DESCRICAO := 'Teste ' + Produto.CODIGO;
  Produto.UND := 'UN';
  Produto.PRECO_VENDA := 556.6;

end;

end.
