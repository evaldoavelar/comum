unit Dao.IResultAdapter;

interface

uses
  Data.DB, Datasnap.DBClient, System.Generics.Collections;

type

  IDaoResultAdapter<T: class> = interface
    ['{FAA0D30A-BB07-43D3-A872-C9FB61437A98}']

    function AsDataset(): TDataSet;
    function AsClientDataset(): TClientDataSet;
    function AsList(): TList<T>;
    function AsObject(): T;
    function AsTField(Index: integer): TField;
  end;

implementation

end.
