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
    procedure PodeFormatarCPF;
    procedure PodeFormatarCPFParcial;
    procedure PodeFormatarCNPJParcial;

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

procedure TestHelpers.PodeFormatarCNPJParcial;
var
  Valor: string;
  Resultado: string;
begin

  // 1 digito
  Valor := '3';
  Resultado := '3';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '1 digito');

  // 2 digitos
  Valor := '31';
  Resultado := '31';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '2 digitos');

  // 3 digitos
  Valor := '318';
  Resultado := '31.8';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '3 digitos');

  // 4 digitos
  Valor := '3189';
  Resultado := '31.89';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '4 digitos');

  // 5 digitos
  Valor := '31890';
  Resultado := '31.890';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '5 digitos');

  // 6 digitos
  Valor := '318901';
  Resultado := '31.890.1';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '6 digitos');

  // 7 digitos
  Valor := '3189012';
  Resultado := '31.890.12';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '7 digitos');

  // 8 digitos
  Valor := '31890124';
  Resultado := '31.890.124';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '8 digitos');

  // 9 digitos
  Valor := '318901240';
  Resultado := '31.890.124/0';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '9 digitos');

  // 10 digitos
  Valor := '3189012400';
  Resultado := '31.890.124/00';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '10 digitos');

  // 11 digitos
  Valor := '31890124000';
  Resultado := '31.890.124/000';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '11 digitos');

  // 12 digitos
  Valor := '318901240001';
  Resultado := '31.890.124/0001';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '12 digitos');

  // 13 digitos
  Valor := '3189012400011';
  Resultado := '31.890.124/0001-1';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '13 digitos');

  // 14 digitos
  Valor := '31890124000113';
  Resultado := '31.890.124/0001-13';
  CheckEquals(Resultado, Valor.FormataCNPJParcial, '14 digitos');

end;

procedure TestHelpers.PodeFormatarCPF;
var
  Valor: string;
  Resultado: string;
begin
  Valor := '07934743025';
  Resultado := '079.347.430-25';
  CheckEquals(Resultado, Valor.FormataCPF);
end;

procedure TestHelpers.PodeFormatarCPFParcial;
var
  Valor: string;
  Resultado: string;
begin
  // 1 digito
  Valor := '0';
  Resultado := '0';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '1 digito');

  // 2 digitos
  Valor := '07';
  Resultado := '07';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '2 digitos');

  // 3 digitos
  Valor := '079';
  Resultado := '079';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '3 digitos');

  // 4 digitos
  Valor := '0793';
  Resultado := '079.3';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '4 digitos');

  // 5 digitos
  Valor := '07934';
  Resultado := '079.34';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '5 digitos');

  // 6 digitos
  Valor := '079347';
  Resultado := '079.347';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '6 digitos');

  // 7 digitos
  Valor := '0793474';
  Resultado := '079.347.4';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '7 digitos');

  // 8 digitos
  Valor := '07934743';
  Resultado := '079.347.43';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '8 digitos');

  // 9 digitos
  Valor := '079347430';
  Resultado := '079.347.430';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '9 digitos');

  // 10 digitos
  Valor := '0793474302';
  Resultado := '079.347.430-2';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '10 digitos');

  // 11 digitos
  Valor := '07934743025';
  Resultado := '079.347.430-25';
  CheckEquals(Resultado, Valor.FormataCPFParcial, '11 digitos');

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
