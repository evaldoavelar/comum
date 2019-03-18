unit Database.TTabelaBD;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Collections,
  System.Rtti,
  Database.IDataseMigration,
  Model.Atributos,
  Model.Atributos.Tipos;

type
  TTabelaBD = class
  public
    Tabela: TabelaAttribute;
    Campos: TObjectList<CampoAttribute>;
    Pks: TObjectList<PrimaryKeyAttribute>;
    Fks: TObjectList<ForeignKeyAttribute>;

    function toScript: TStringList; virtual; abstract;
    constructor Create;
    destructor destroy;override;
  end;

implementation

{ ITabelaBD }

constructor TTabelaBD.Create;
begin
  Campos := TObjectList<CampoAttribute>.Create(false);
  Fks := TObjectList<ForeignKeyAttribute>.Create(false);
  Pks := TObjectList<PrimaryKeyAttribute>.Create(false);
end;

destructor TTabelaBD.destroy;
begin
  Campos.Clear;
  FreeAndNil(Campos);

  Fks.Clear;
  FreeAndNil(Fks);

  Pks.Clear;
  FreeAndNil(Pks);

  inherited;
end;

end.
