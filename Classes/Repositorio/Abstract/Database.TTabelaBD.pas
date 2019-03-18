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
<<<<<<< HEAD
  Campos := TObjectList<CampoAttribute>.Create(false);
  Fks := TObjectList<ForeignKeyAttribute>.Create(false);
  Pks := TObjectList<PrimaryKeyAttribute>.Create(false);
=======
  Campos := TObjectList<CampoAttribute>.Create(False);
  Fks := TObjectList<ForeignKeyAttribute>.Create(False);
  Pks := TObjectList<PrimaryKeyAttribute>.Create(False);
>>>>>>> 6476a37bad42c714e6ff9beea1236ec7cd22b62a
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
