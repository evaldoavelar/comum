unit Model.IModelBase;

interface

uses
  Model.IPrototype, System.Rtti;

type

  IModelBase = interface
    ['{074B33E1-D728-4B64-9D9C-3E89E93408E6}']

    function Prototype: IModelPrototype<IModelBase>;
    function New: IModelBase;
  end;

implementation

end.
