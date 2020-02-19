unit Test.Model.AUTOINC;

interface

uses Model.Atributos, Model.Atributos.Tipos, Model.IModelBase, Model.IObserve, Model.ModelBase;

type

  [Tabela('AUTOINC')]
  TAUTOINC = class(TModelBase)
  private
    FCODIGO: string;
    FVALOR: STRING;
    FTabela: string;
    procedure SetCODIGO(const Value: string);
    procedure SetTabela(const Value: string);
    procedure SetVALOR(const Value: STRING);
  public
    [PrimaryKey('PK_AUTOINC', 'CAMPO, VALOR, TABELA')]
    [campo('CAMPO', tpVARCHAR, 40, 0, True)]
    property campo: string read FCODIGO write SetCODIGO;

    [campo('VALOR', tpINTEGER, 0, 0, True)]
    property VALOR: STRING read FVALOR write SetVALOR;


    [campo('TABELA', tpVARCHAR, 40, 0, True)]
    property Tabela: string read FTabela write SetTabela;
  end;

implementation

{ TAUTOINC }

procedure TAUTOINC.SetCODIGO(const Value: string);
begin
  FCODIGO := Value;
end;

procedure TAUTOINC.SetTabela(const Value: string);
begin
  FTabela := Value;
end;

procedure TAUTOINC.SetVALOR(const Value: STRING);
begin
  FVALOR := Value;
end;

end.
