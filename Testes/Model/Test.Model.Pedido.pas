unit Test.Model.Pedido;

interface

uses Model.ModelBase, Exceptions, System.Generics.Collections, Test.Model.Item, Utils.Funcoes, Model.Atributos, Model.Atributos.Tipos;

type

  [Tabela('PEDIDO')]
  TPedido = class(TModelBase)
  private
    FID: Integer;
    FNUMERO: string;
    FDATAPEDIDO: TDateTime;
    FHORAPEDIDO: TTime;
    FOBSERVACAO: string;
    FVALORDESC: currency;
    FVALORENTRADA: currency;
    FSTATUS: string;
    FItens: TObjectList<TItemPedido>;

    function getDesconto: currency;
    function getItemCount: Integer;
    function getOBSERVACAO: string;
    function GetValorBruto: currency;
    function getVALORENTRADA: currency;
    function getValorLiquido: currency;
    procedure SetDesconto(const Value: currency);
    procedure setOBSERVACAO(const Value: string);
    procedure setVALORENTRADA(const Value: currency);
  public
    constructor Create; override;
    destructor Destroy; override;

  public
    [AutoInc('AUTOINC')]
    [campo('ID', tpINTEGER, 0, 0, True)]
    [PrimaryKey('PK_PEDIDO', 'ID')]
    property ID: Integer read FID write FID;
    [campo('NUMERO', tpVARCHAR, 10)]
    property NUMERO: string read FNUMERO write FNUMERO;
    [campo('DATAPEDIDO', tpDATE)]
    property DATAPEDIDO: TDateTime read FDATAPEDIDO write FDATAPEDIDO;
    [campo('HORAPEDIDO', tpTIME)]
    property HORAPEDIDO: TTime read FHORAPEDIDO write FHORAPEDIDO;
    [campo('OBSERVACAO', tpVARCHAR, 1000)]
    property OBSERVACAO: string read getOBSERVACAO write setOBSERVACAO;
    [campo('VALORBRUTO', tpNUMERIC, 15, 4)]
    property ValorBruto: currency read GetValorBruto;
    property ItemCount: Integer read getItemCount;
    [campo('VALORDESC', tpNUMERIC, 15, 4)]
    property VALORDESC: currency read getDesconto write SetDesconto;
    [campo('VALORENTRADA', tpNUMERIC, 15, 4, True, '0')]
    property ValorEntrada: currency read getVALORENTRADA write setVALORENTRADA;
    [campo('VALORLIQUIDO', tpNUMERIC, 15, 4)]
    property ValorLiquido: currency read getValorLiquido;

    property Itens: TObjectList<TItemPedido> read FItens write FItens;

  end;

implementation

uses
  System.SysUtils;

{ TTestModel }

constructor TPedido.Create;
begin
  inherited;
  FItens := TObjectList<TItemPedido>.Create(false);
end;

destructor TPedido.Destroy;
begin
  FItens.Clear;
  FreeAndNil(FItens);
  inherited;
end;

function TPedido.getDesconto: currency;
begin
  result := FVALORDESC;
end;

function TPedido.getItemCount: Integer;
begin
  result := Self.FItens.Count;
end;

function TPedido.getOBSERVACAO: string;
begin
  result := FOBSERVACAO;
end;

function TPedido.GetValorBruto: currency;
var
  Item: TItemPedido;
begin
  result := 0;
  try

    if not Assigned(Self.FItens) then
      Exit;

    for Item in Self.FItens do
    begin
      result := result + Item.VALOR_TOTAL;
    end;

    result := TUtil.Truncar(result, 2);
  except
    on E: Exception do
      raise TCalculoException.Create('Falha no Calculo do Valor Bruto ' + E.Message);
  end;

end;

function TPedido.getVALORENTRADA: currency;
begin
  result := Self.FVALORENTRADA;
end;

function TPedido.getValorLiquido: currency;
begin
  result := Self.ValorBruto - Self.FVALORDESC - Self.FVALORENTRADA;
  result := TUtil.Truncar(result, 2);
end;


procedure TPedido.SetDesconto(const Value: currency);
begin
  if Value < 0 then
    raise TValidacaoException.Create('Valor do Desconto é Inválido');

  Self.FVALORDESC := Value;

end;

procedure TPedido.setOBSERVACAO(const Value: string);
begin
  if Value <> FOBSERVACAO then
  begin
    FOBSERVACAO := Value;
    NotifyBinding('OBSERVACAO');
  end;
end;

procedure TPedido.setVALORENTRADA(const Value: currency);
begin
  if Value < 0 then
    raise TValidacaoException.Create('Valor da Entrada precisa ser mair que zero! ' + CurrToStr(Value));

  if (Value >= Self.ValorLiquido) and (Self.ValorLiquido > 0) then
    raise TValidacaoException.Create('O Valor da Entrada precisa ser menor que o valor do Pedido! ' + CurrToStr(Value));

  Self.FVALORENTRADA := Value;

end;

end.
