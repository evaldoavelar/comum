unit TestAtualizacaoApp;

interface

uses
  Exceptions, Atualizacao.IAtualizacaoFTP, Atualizacao.Concret.FTP, System.Zip,
  IdException, IdExplicitTLSClientServerBase, IdBaseComponent, TestFramework,
  IdTCPConnection, IdFTPCommon, IdTCPClient, IdFTP, IdComponent, Helpers.HelperString,
  WinInet, System.SysUtils, System.IniFiles, Utils.Funcoes, Vcl.Forms;

type
  // Test methods for class TAtualizacaoFTP

  TestTAtualizacaoFTP = class(TTestCase)
  strict private
    FAtualizacaoFTP: TAtualizacaoFTP;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestChecaNovaVersaoDisponivel;
    procedure TestPodeAtualizar;
  end;

implementation

procedure TestTAtualizacaoFTP.SetUp;
begin
  FAtualizacaoFTP := TAtualizacaoFTP.Create;

end;

procedure TestTAtualizacaoFTP.TearDown;
begin
  FAtualizacaoFTP.Free;
  FAtualizacaoFTP := nil;
end;

procedure TestTAtualizacaoFTP.TestChecaNovaVersaoDisponivel;
var
  ReturnValue: Boolean;
begin

  FAtualizacaoFTP.SetUpHOST(
    'ftp.evaldo.com.br',
    'update@evaldo.com.br',
    'update@evaldo',
    21
    );

  FAtualizacaoFTP.SetUpClient(
    '/atualizacao/teste/',
    'versaoFTP.ini',
    application.ExeName,
    '2.0.0.0');

  ReturnValue := FAtualizacaoFTP.ChecaNovaVersaoDisponivel();

  CheckTrue(ReturnValue, 'Não retornou versão disponível');
end;

procedure TestTAtualizacaoFTP.TestPodeAtualizar;
var
  ReturnValue: Boolean;
begin

  FAtualizacaoFTP.SetUpHOST(
    'ftp.evaldo.com.br',
    'update@evaldo.com.br',
    'update@evaldo',
    21
    );

  FAtualizacaoFTP.SetUpClient(
    '/atualizacao/teste/',
    'versaoFTP.ini',
    application.ExeName,
    '2.0.0.0');



  FAtualizacaoFTP.Atualizar();


end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTAtualizacaoFTP.Suite);

end.
