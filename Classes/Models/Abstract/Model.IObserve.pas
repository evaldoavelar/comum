unit Model.IObserve;

interface

uses Model.IModelBase;

type

  IModelObserve = interface
    ['{E3F57406-7D81-40BD-82F7-1891E0567594}']
    [weak]
    procedure Update(const ModelBase: IModelBase);
  end;

implementation

end.
