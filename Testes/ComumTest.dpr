program ComumTest;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Dao.Base in '..\Classes\Repositorio\Concret\Dao.Base.pas',
  Model.ModelBase in '..\Classes\Models\Concret\Model.ModelBase.pas',
  Model.IModelBase in '..\Classes\Models\Abstract\Model.IModelBase.pas',
  Model.IObserve in '..\Classes\Models\Abstract\Model.IObserve.pas',
  Dao.IConection in '..\Classes\Repositorio\Abstract\Dao.IConection.pas',
  Dao.Conection.Parametros in '..\Classes\Repositorio\Concret\Dao.Conection.Parametros.pas',
  Exceptions in '..\Classes\Exceptions\Exceptions.pas',
  Test.Model.Pedido in 'Model\Test.Model.Pedido.pas',
  Model.Atributos in '..\Classes\Models\Concret\Model.Atributos.pas',
  Model.Atributos.Tipos in '..\Classes\Models\Concret\Model.Atributos.Tipos.pas',
  Utils.Funcoes in '..\Classes\Utils\Utils.Funcoes.pas',
  Test.Model.Item in 'Model\Test.Model.Item.pas',
  Database.IDataseMigration in '..\Classes\Repositorio\Abstract\Database.IDataseMigration.pas',
  Database.TTabelaBD in '..\Classes\Repositorio\Abstract\Database.TTabelaBD.pas',
  Database.TDataseMigrationBase in '..\Classes\Repositorio\Concret\Database.TDataseMigrationBase.pas',
  Database.SGDB in '..\Classes\Repositorio\Concret\Database.SGDB.pas',
  TestDatabaseMigration in 'TestDatabaseMigration.pas',
  Database.Version in 'Dao\Database.Version.pas',
  DataBase.MigrationLocal in 'Dao\DataBase.MigrationLocal.pas',
  Test.Model.AUTOINC in 'Model\Test.Model.AUTOINC.pas',
  Database.Tabela.SqlServer in '..\Classes\Repositorio\Concret\Database.Tabela.SqlServer.pas',
  Test.Model.Produto in 'Model\Test.Model.Produto.pas',
  TestDaoBase in 'TestDaoBase.pas',
  Log.TxtLog in '..\Classes\Log\Concret\Log.TxtLog.pas',
  Log.ILog in '..\Classes\Log\Abstract\Log.ILog.pas',
  Log.TTipoLog in '..\Classes\Log\Concret\Log.TTipoLog.pas',
  SQLBuilder4D in '..\Classes\Repositorio\Terceiros\SQLBuilder4Delphi\src\SQLBuilder4D.pas',
  Database.Tabela.Firebird in '..\Classes\Repositorio\Concret\Database.Tabela.Firebird.pas',
  Dao.IQueryBuilder in '..\Classes\Repositorio\Abstract\Dao.IQueryBuilder.pas',
  Dao.TQueryBuilder in '..\Classes\Repositorio\Concret\Dao.TQueryBuilder.pas',
  TestModel in 'TestModel.pas',
  Test.Model.Observer in 'Model\Test.Model.Observer.pas',
  Model.IObservable in '..\Classes\Models\Abstract\Model.IObservable.pas',
  Model.IPrototype in '..\Classes\Models\Abstract\Model.IPrototype.pas',
  Model.Atributos.Funcoes in '..\Classes\Models\Concret\Model.Atributos.Funcoes.pas',
  Utils.Rtti in '..\Classes\Utils\Utils.Rtti.pas',
  Utils.Crypt in '..\Classes\Utils\Utils.Crypt.pas',
  TestUtils in 'TestUtils.pas',
  Test.Model.TMOV in 'Model\Test.Model.TMOV.pas',
  Licenca.Concret.Validador in '..\Classes\Licenca\Concret\Licenca.Concret.Validador.pas',
  Helpers.HelperDateTime in '..\Classes\Helpers\Helpers.HelperDateTime.pas',
  Helpers.HelperDate in '..\Classes\Helpers\Helpers.HelperDate.pas',
  Helpers.HelperString in '..\Classes\Helpers\Helpers.HelperString.pas',
  Licenca.Abstract.Validador in '..\Classes\Licenca\Abstract\Licenca.Abstract.Validador.pas',
  Model.IJSON in '..\Classes\Models\Abstract\Model.IJSON.pas',
  TestJSonUtils in 'TestJSonUtils.pas',
  Database.Tabela.Oracle in '..\Classes\Repositorio\Concret\Database.Tabela.Oracle.pas',
  Helpers.HelperObject in '..\Classes\Helpers\Helpers.HelperObject.pas',
  JSON.Atributes in '..\Classes\JSON\JSON.Atributes.pas',
  JSON.Atributes.Funcoes in '..\Classes\JSON\JSON.Atributes.Funcoes.pas',
  JSON.Utils.ConverterTypes in '..\Classes\JSON\JSON.Utils.ConverterTypes.pas',
  JSON.Utils in '..\Classes\JSON\JSON.Utils.pas',
  Dao.Conection.Firedac in '..\Classes\Repositorio\Concret\Dao.Conection.Firedac.pas',
  Helpers.HelperCurrency in '..\Classes\Helpers\Helpers.HelperCurrency.pas',
  TesteHelpers in 'TesteHelpers.pas';

{$R *.res}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

