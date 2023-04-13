unit TesteHelpers;

interface


uses
  TestFramework, Utils.Crypt, System.SysUtils, Helpers.HelperCurrency, Helpers.HelperString;

type
  // Test methods for class TCrypt

  TestHelpers = class(TTestCase)
  strict private

  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure PodeColocarCurrencyEmExtenco;
    procedure PodeColocarLeftPad;

  end;

implementation

{ TestHelpCurrency }

procedure TestHelpers.PodeColocarCurrencyEmExtenco;
var
  Valor: Currency;
  Resultado: string;
begin

  Valor := 1556.25;
  Resultado := 'um mil e quinhentos e cinquenta e seis reais e vinte e cinco centavos.';
  CheckEquals(Resultado, Valor.ToReiasExtenco.ToLower);

  Valor := 156.25;
  Resultado := 'cento e cinquenta e seis reais e vinte e cinco centavos.';
  CheckEquals(Resultado, Valor.ToReiasExtenco.ToLower);

  Valor := 6.25;
  Resultado := 'seis reais e vinte e cinco centavos.';
  CheckEquals(Resultado, Valor.ToReiasExtenco.ToLower);

  Valor := 0.25;
  Resultado := 'vinte e cinco centavos.';
  CheckEquals(Resultado, Valor.ToReiasExtenco.ToLower);

  Valor := 0.05;
  Resultado := 'cinco centavos.';
  CheckEquals(Resultado, Valor.ToReiasExtenco.ToLower);

end;

procedure TestHelpers.PodeColocarLeftPad;
var
  Valor: string;
  Resultado: string;
begin
  inherited;
  Valor := '_';
  Resultado := '__________';

  CheckEquals(Resultado, Valor.LeftPad('_', 10));

end;

procedure TestHelpers.SetUp;
begin
  inherited;

end;

procedure TestHelpers.TearDown;
begin

end;

initialization

// Register any test cases with the test runner
RegisterTest(TestHelpers.Suite);

end.
