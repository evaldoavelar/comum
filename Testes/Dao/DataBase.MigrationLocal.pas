unit DataBase.MigrationLocal;

interface

uses DataBase.IDataseMigration, DataBase.TDataseMigrationBase,
Test.Model.AUTOINC, Test.Model.Pedido, Test.Model.Item, Test.Model.Produto;

type

  TMigrationLocal = class(TDataseMigrationBase)
  protected
    procedure Seed(); override;
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

procedure TMigrationLocal.Seed;
begin
  inherited;



end;

end.
