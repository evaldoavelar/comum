unit Model.IValidador;

interface

uses Model.ModelBase, System.Classes;

type

  IValidador = interface
    ['{B4262E7B-1208-4834-A2F1-46EF0451889D}']

    procedure setErros(value:TStringList);
    function getErros: TStringList;
    property Erros: TStringList  read getErros write setErros;

    function Validar(obj: TModelBase): Boolean;
  end;

implementation

end.
