unit Database.IDataseMigration;

interface

uses System.Generics.Collections;

type
  IDataseMigration = interface
    ['{CCC63C2A-B643-4424-9FB7-7F01439232FD}']

    function Migrate(): IDataseMigration;
    function Seed(): IDataseMigration;
    function GetErros: TDictionary<TClass, string>;
  end;

  IDatabaseVersion = interface
    ['{8F177BCA-E13C-4C49-B48E-058F4052BF32}']
    procedure AtualizaVersaoBD(aVersao: string);
    function GetVersaoBD: string;
  end;

implementation

end.
