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
  Test.Model.Pedido in 'Model\Test.Model.Pedido.pas',
  Model.Atributos in '..\Classes\Models\Concret\Model.Atributos.pas',
  Model.Atributos.Tipos in '..\Classes\Models\Concret\Model.Atributos.Tipos.pas',
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
  Helpers.HelperDateTime in '..\Classes\Helpers\Helpers.HelperDateTime.pas',
  Helpers.HelperDate in '..\Classes\Helpers\Helpers.HelperDate.pas',
  Model.IJSON in '..\Classes\Models\Abstract\Model.IJSON.pas',
  TestJSonUtils in 'TestJSonUtils.pas',
  Database.Tabela.Oracle in '..\Classes\Repositorio\Concret\Database.Tabela.Oracle.pas',
  Helpers.HelperObject in '..\Classes\Helpers\Helpers.HelperObject.pas',
  JSON.Atributes in '..\Classes\JSON\JSON.Atributes.pas',
  JSON.Utils in '..\Classes\JSON\JSON.Utils.pas',
  Dao.Conection.Firedac in '..\Classes\Repositorio\Concret\Dao.Conection.Firedac.pas',
  Helpers.HelperCurrency in '..\Classes\Helpers\Helpers.HelperCurrency.pas',
  TesteHelpers in 'TesteHelpers.pas',
  Atualizacao.Concret.FTP in '..\Classes\Atualizacao\Concret\Atualizacao.Concret.FTP.pas',
  Exceptions in '..\Classes\Exceptions\Exceptions.pas',
  Utils.Funcoes in '..\Classes\Utils\Utils.Funcoes.pas',
  Helpers.HelperString in '..\Classes\Helpers\Helpers.HelperString.pas',
  TestAtualizacaoApp in 'TestAtualizacaoApp.pas',
  TestUtilsArarray in 'TestUtilsArarray.pas',
  Utils.ArrayUtil in '..\Classes\Utils\Utils.ArrayUtil.pas',
  Test.Model.Log in 'Model\Test.Model.Log.pas',
  Atualizacao.Abstract.FTP in '..\Classes\Atualizacao\Abstract\Atualizacao.Abstract.FTP.pas',
  Types.Nullable in '..\Classes\Types\Types.Nullable.pas',
  Dao.IResultAdapter in '..\Classes\Repositorio\Abstract\Dao.IResultAdapter.pas',
  Dao.ResultAdapter in '..\Classes\Repositorio\Concret\Dao.ResultAdapter.pas',
  Neon.Core.Attributes in '..\Classes\Terceiros\delphi-neon\Source\Neon.Core.Attributes.pas',
  Neon.Core.DynamicTypes in '..\Classes\Terceiros\delphi-neon\Source\Neon.Core.DynamicTypes.pas',
  Neon.Core.Types in '..\Classes\Terceiros\delphi-neon\Source\Neon.Core.Types.pas',
  Neon.Core.Persistence in '..\Classes\Terceiros\delphi-neon\Source\Neon.Core.Persistence.pas',
  Neon.Core.Utils in '..\Classes\Terceiros\delphi-neon\Source\Neon.Core.Utils.pas',
  Neon.Core.Persistence.JSON in '..\Classes\Terceiros\delphi-neon\Source\Neon.Core.Persistence.JSON.pas',
  Dao.Abstract.Parametros in '..\Classes\Repositorio\Abstract\Dao.Abstract.Parametros.pas',
  Dao.Conection.Parametros in '..\Classes\Repositorio\Concret\Dao.Conection.Parametros.pas',
  Dao.DataSet in '..\Classes\Repositorio\Concret\Dao.DataSet.pas',
  Dao.IDataSet in '..\Classes\Repositorio\Abstract\Dao.IDataSet.pas';

{$R *.res}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

