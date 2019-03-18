unit Database.IDataseMigration;

interface

uses System.Generics.Collections;

type
  IDataseMigration = interface
    ['{CCC63C2A-B643-4424-9FB7-7F01439232FD}']

<<<<<<< HEAD
    function Migrate(): IDataseMigration;
    function Seed(): IDataseMigration;
=======
    function Migrate():IDataseMigration;
    function Seed():IDataseMigration;
>>>>>>> 6476a37bad42c714e6ff9beea1236ec7cd22b62a
    function GetErros: TDictionary<TClass, string>;
  end;

  IDatabaseVersion = interface
    ['{8F177BCA-E13C-4C49-B48E-058F4052BF32}']
    procedure AtualizaVersaoBD(aVersao: string);
    function GetVersaoBD: string;
  end;

implementation

end.
