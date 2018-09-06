unit Model.IJSON;

interface

uses System.JSON;

type

  IModelJson = interface
    ['{31A63D97-20FA-4434-88C1-5A190BEE73DB}']

    function ToJson: TJSonValue;
  end;

implementation

end.
