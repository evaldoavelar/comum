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
  Dao.Base in '..\Repositorio\Concret\Dao.Base.pas',
  Model.ModelBase in '..\Models\Concret\Model.ModelBase.pas',
  Model.IModelBase in '..\Models\Abstract\Model.IModelBase.pas',
  Model.IObserve in '..\Models\Abstract\Model.IObserve.pas',
  Dao.IConection in '..\Repositorio\Abstract\Dao.IConection.pas',
  Test.Model.Pedido in 'Model\Test.Model.Pedido.pas',
  Model.Atributos in '..\Models\Concret\Model.Atributos.pas',
  Model.Atributos.Tipos in '..\Models\Concret\Model.Atributos.Tipos.pas',
  Test.Model.Item in 'Model\Test.Model.Item.pas',
  Database.IDataseMigration in '..\Repositorio\Abstract\Database.IDataseMigration.pas',
  Database.TTabelaBD in '..\Repositorio\Abstract\Database.TTabelaBD.pas',
  Database.TDataseMigrationBase in '..\Repositorio\Concret\Database.TDataseMigrationBase.pas',
  Database.SGDB in '..\Repositorio\Concret\Database.SGDB.pas',
  TestDatabaseMigration in 'TestDatabaseMigration.pas',
  Database.Version in 'Dao\Database.Version.pas',
  DataBase.MigrationLocal in 'Dao\DataBase.MigrationLocal.pas',
  Test.Model.AUTOINC in 'Model\Test.Model.AUTOINC.pas',
  Database.Tabela.SqlServer in '..\Repositorio\Concret\Database.Tabela.SqlServer.pas',
  Test.Model.Produto in 'Model\Test.Model.Produto.pas',
  TestDaoBase in 'TestDaoBase.pas',
  Log.TxtLog in '..\Log\Concret\Log.TxtLog.pas',
  Log.ILog in '..\Log\Abstract\Log.ILog.pas',
  Log.TTipoLog in '..\Log\Concret\Log.TTipoLog.pas',
  SQLBuilder4D in '..\Repositorio\Terceiros\SQLBuilder4Delphi\src\SQLBuilder4D.pas',
  Database.Tabela.Firebird in '..\Repositorio\Concret\Database.Tabela.Firebird.pas',
  Dao.IQueryBuilder in '..\Repositorio\Abstract\Dao.IQueryBuilder.pas',
  Dao.TQueryBuilder in '..\Repositorio\Concret\Dao.TQueryBuilder.pas',
  TestModel in 'TestModel.pas',
  Test.Model.Observer in 'Model\Test.Model.Observer.pas',
  Model.IObservable in '..\Models\Abstract\Model.IObservable.pas',
  Model.IPrototype in '..\Models\Abstract\Model.IPrototype.pas',
  Model.Atributos.Funcoes in '..\Models\Concret\Model.Atributos.Funcoes.pas',
  Utils.Rtti in '..\Utils\Utils.Rtti.pas',
  Utils.Crypt in '..\Utils\Utils.Crypt.pas',
  TestUtils in 'TestUtils.pas',
  Test.Model.TMOV in 'Model\Test.Model.TMOV.pas',
  Helpers.HelperDateTime in '..\Helpers\Helpers.HelperDateTime.pas',
  Helpers.HelperDate in '..\Helpers\Helpers.HelperDate.pas',
  Model.IJSON in '..\Models\Abstract\Model.IJSON.pas',
  TestJSonUtils in 'TestJSonUtils.pas',
  Database.Tabela.Oracle in '..\Repositorio\Concret\Database.Tabela.Oracle.pas',
  Helpers.HelperObject in '..\Helpers\Helpers.HelperObject.pas',
  JSON.Atributes in '..\JSON\JSON.Atributes.pas',
  JSON.Utils in '..\JSON\JSON.Utils.pas',
  Dao.Conection.Firedac in '..\Repositorio\Concret\Dao.Conection.Firedac.pas',
  Helpers.HelperCurrency in '..\Helpers\Helpers.HelperCurrency.pas',
  TesteHelpers in 'TesteHelpers.pas',
  Atualizacao.Concret.FTP in '..\Atualizacao\Concret\Atualizacao.Concret.FTP.pas',
  Exceptions in '..\Exceptions\Exceptions.pas',
  Utils.Funcoes in '..\Utils\Utils.Funcoes.pas',
  Helpers.HelperString in '..\Helpers\Helpers.HelperString.pas',
  TestAtualizacaoApp in 'TestAtualizacaoApp.pas',
  TestUtilsArarray in 'TestUtilsArarray.pas',
  Utils.ArrayUtil in '..\Utils\Utils.ArrayUtil.pas',
  Test.Model.Log in 'Model\Test.Model.Log.pas',
  Atualizacao.Abstract.FTP in '..\Atualizacao\Abstract\Atualizacao.Abstract.FTP.pas',
  Types.Nullable in '..\Types\Types.Nullable.pas',
  Dao.IResultAdapter in '..\Repositorio\Abstract\Dao.IResultAdapter.pas',
  Dao.ResultAdapter in '..\Repositorio\Concret\Dao.ResultAdapter.pas',
  Dao.Abstract.Parametros in '..\Repositorio\Abstract\Dao.Abstract.Parametros.pas',
  Dao.Conection.Parametros in '..\Repositorio\Concret\Dao.Conection.Parametros.pas',
  Dao.DataSet in '..\Repositorio\Concret\Dao.DataSet.pas',
  Dao.IDataSet in '..\Repositorio\Abstract\Dao.IDataSet.pas',
  Neon.Core.Attributes in '..\modules\delphi-neon\Source\Neon.Core.Attributes.pas',
  Neon.Core.DynamicTypes in '..\modules\delphi-neon\Source\Neon.Core.DynamicTypes.pas',
  Neon.Core.Nullables in '..\modules\delphi-neon\Source\Neon.Core.Nullables.pas',
  Neon.Core.Persistence.JSON in '..\modules\delphi-neon\Source\Neon.Core.Persistence.JSON.pas',
  Neon.Core.Persistence in '..\modules\delphi-neon\Source\Neon.Core.Persistence.pas',
  Neon.Core.Persistence.Swagger in '..\modules\delphi-neon\Source\Neon.Core.Persistence.Swagger.pas',
  Neon.Core.Serializers.DB in '..\modules\delphi-neon\Source\Neon.Core.Serializers.DB.pas',
  Neon.Core.Serializers.RTL in '..\modules\delphi-neon\Source\Neon.Core.Serializers.RTL.pas',
  Neon.Core.Serializers.VCL in '..\modules\delphi-neon\Source\Neon.Core.Serializers.VCL.pas',
  Neon.Core.TypeInfo in '..\modules\delphi-neon\Source\Neon.Core.TypeInfo.pas',
  Neon.Core.Types in '..\modules\delphi-neon\Source\Neon.Core.Types.pas',
  Neon.Core.Utils in '..\modules\delphi-neon\Source\Neon.Core.Utils.pas',
  DCPbase64 in '..\Criptografia\DCPbase64.pas',
  DCPconst in '..\Criptografia\DCPconst.pas',
  DCPcrypt2 in '..\Criptografia\DCPcrypt2.pas',
  DCPrc4 in '..\Criptografia\DCPrc4.pas',
  DCPripemd160 in '..\Criptografia\DCPripemd160.pas',
  DCPsha1 in '..\Criptografia\DCPsha1.pas';

{$R *.res}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

