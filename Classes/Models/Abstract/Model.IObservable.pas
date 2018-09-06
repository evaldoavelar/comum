unit Model.IObservable;

interface

uses Model.IObserve;

type

  IObservable = interface
    ['{062EA0B0-552A-440D-B082-CB49D1AB9695}']
    procedure addObserver(obs: IModelObserve);
    procedure removeObserver(obs: IModelObserve);
    procedure NotifyObservers;
  end;

implementation

end.
