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
  Dao.Base in '..\src\Repositorio\Concret\Dao.Base.pas',
  Model.ModelBase in '..\src\Models\Concret\Model.ModelBase.pas',
  Model.IModelBase in '..\src\Models\Abstract\Model.IModelBase.pas',
  Model.IObserve in '..\src\Models\Abstract\Model.IObserve.pas',
  Dao.IConection in '..\src\Repositorio\Abstract\Dao.IConection.pas',
  Test.Model.Pedido in 'Model\Test.Model.Pedido.pas',
  Model.Atributos in '..\src\Models\Concret\Model.Atributos.pas',
  Model.Atributos.Tipos in '..\src\Models\Concret\Model.Atributos.Tipos.pas',
  Test.Model.Item in 'Model\Test.Model.Item.pas',
  Database.IDataseMigration in '..\src\Repositorio\Abstract\Database.IDataseMigration.pas',
  Database.TTabelaBD in '..\src\Repositorio\Abstract\Database.TTabelaBD.pas',
  Database.TDataseMigrationBase in '..\src\Repositorio\Concret\Database.TDataseMigrationBase.pas',
  Database.SGDB in '..\src\Repositorio\Concret\Database.SGDB.pas',
  TestDatabaseMigration in 'TestDatabaseMigration.pas',
  Database.Version in 'Dao\Database.Version.pas',
  DataBase.MigrationLocal in 'Dao\DataBase.MigrationLocal.pas',
  Test.Model.AUTOINC in 'Model\Test.Model.AUTOINC.pas',
  Database.Tabela.SqlServer in '..\src\Repositorio\Concret\Database.Tabela.SqlServer.pas',
  Test.Model.Produto in 'Model\Test.Model.Produto.pas',
  TestDaoBase in 'TestDaoBase.pas',
  Log.TxtLog in '..\src\Log\Concret\Log.TxtLog.pas',
  Log.ILog in '..\src\Log\Abstract\Log.ILog.pas',
  Log.TTipoLog in '..\src\Log\Concret\Log.TTipoLog.pas',
  SQLBuilder4D in '..\src\Repositorio\Terceiros\SQLBuilder4Delphi\src\SQLBuilder4D.pas',
  Database.Tabela.Firebird in '..\src\Repositorio\Concret\Database.Tabela.Firebird.pas',
  Dao.IQueryBuilder in '..\src\Repositorio\Abstract\Dao.IQueryBuilder.pas',
  Dao.TQueryBuilder in '..\src\Repositorio\Concret\Dao.TQueryBuilder.pas',
  TestModel in 'TestModel.pas',
  Test.Model.Observer in 'Model\Test.Model.Observer.pas',
  Model.IObservable in '..\src\Models\Abstract\Model.IObservable.pas',
  Model.IPrototype in '..\src\Models\Abstract\Model.IPrototype.pas',
  Model.Atributos.Funcoes in '..\src\Models\Concret\Model.Atributos.Funcoes.pas',
  Utils.Rtti in '..\src\Utils\Utils.Rtti.pas',
  Utils.Crypt in '..\src\Utils\Utils.Crypt.pas',
  TestUtils in 'TestUtils.pas',
  Test.Model.TMOV in 'Model\Test.Model.TMOV.pas',
  Helpers.HelperDateTime in '..\src\Helpers\Helpers.HelperDateTime.pas',
  Helpers.HelperDate in '..\src\Helpers\Helpers.HelperDate.pas',
  Model.IJSON in '..\src\Models\Abstract\Model.IJSON.pas',
  TestJSonUtils in 'TestJSonUtils.pas',
  Database.Tabela.Oracle in '..\src\Repositorio\Concret\Database.Tabela.Oracle.pas',
  Helpers.HelperObject in '..\src\Helpers\Helpers.HelperObject.pas',
  JSON.Atributes in '..\src\JSON\JSON.Atributes.pas',
  JSON.Utils in '..\src\JSON\JSON.Utils.pas',
  Dao.Conection.Firedac in '..\src\Repositorio\Concret\Dao.Conection.Firedac.pas',
  Helpers.HelperCurrency in '..\src\Helpers\Helpers.HelperCurrency.pas',
  TesteHelpers in 'TesteHelpers.pas',
  Atualizacao.Concret.FTP in '..\src\Atualizacao\Concret\Atualizacao.Concret.FTP.pas',
  Exceptions in '..\src\Exceptions\Exceptions.pas',
  Utils.Funcoes in '..\src\Utils\Utils.Funcoes.pas',
  Helpers.HelperString in '..\src\Helpers\Helpers.HelperString.pas',
  TestUtilsArarray in 'TestUtilsArarray.pas',
  Utils.ArrayUtil in '..\src\Utils\Utils.ArrayUtil.pas',
  Test.Model.Log in 'Model\Test.Model.Log.pas',
  Atualizacao.Abstract.FTP in '..\src\Atualizacao\Abstract\Atualizacao.Abstract.FTP.pas',
  Types.Nullable in '..\src\Types\Types.Nullable.pas',
  Dao.IResultAdapter in '..\src\Repositorio\Abstract\Dao.IResultAdapter.pas',
  Dao.ResultAdapter in '..\src\Repositorio\Concret\Dao.ResultAdapter.pas',
  Dao.Abstract.Parametros in '..\src\Repositorio\Abstract\Dao.Abstract.Parametros.pas',
  Dao.Conection.Parametros in '..\src\Repositorio\Concret\Dao.Conection.Parametros.pas',
  Dao.DataSet in '..\src\Repositorio\Concret\Dao.DataSet.pas',
  Dao.IDataSet in '..\src\Repositorio\Abstract\Dao.IDataSet.pas',
  DCPbase64 in '..\src\Criptografia\DCPbase64.pas',
  DCPconst in '..\src\Criptografia\DCPconst.pas',
  DCPcrypt2 in '..\src\Criptografia\DCPcrypt2.pas',
  DCPrc4 in '..\src\Criptografia\DCPrc4.pas',
  DCPripemd160 in '..\src\Criptografia\DCPripemd160.pas',
  DCPsha1 in '..\src\Criptografia\DCPsha1.pas',
  Model.CampoValor in '..\src\Models\Concret\Model.CampoValor.pas',
  TestStringHelpers in 'TestStringHelpers.pas';

{$R *.res}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

