unit Test.Model.Item;

interface

uses
  System.SysUtils, Model.ModelBase, Utils.Funcoes, Exceptions, Model.Atributos, Model.Atributos.Tipos;

type

  [Tabela('ITEMPEDIDO')]
  TItemPedido = class(TModelBase)
  private
    FSEQ: INTEGER;
    FIDPEDIDO: INTEGER;
    FCODPRODUTO: string;
    FDESCRICAO: string;
    FUND: string;
    FQTD: double;
    FVALOR_UNITA: currency;
    FVALOR_DESCONTO: currency;
    FSTATUS: string;
    FDATADAVENDA: TDateTime;
    function GetValorTotal: currency;
    procedure setIDPEDIDO(value: INTEGER);
    procedure SetSTATUS(const Value: string);
    procedure SetDATADAVENDA(const Value: TDateTime);

  public
    [campo('SEQ', tpINTEGER, 0, 0, True)]
    [PrimaryKey('PK_ITEMPEDIDO', 'IDPEDIDO,SEQ')]
    property SEQ: INTEGER read FSEQ write FSEQ;
    [campo('IDPEDIDO', tpINTEGER, 0, 0, True)]
    [ForeignKeyAttribute('FK_ITEMPEDIDO_PEDIDO','IDPEDIDO','PEDIDO', 'ID', Cascade, None)]
    property IDPEDIDO: INTEGER read FIDPEDIDO write setIDPEDIDO;

    [campo('CODPRODUTO', tpVARCHAR, 40)]
    [ForeignKeyAttribute('FK_ITEMPEDIDO_PROD','CODPRODUTO','PRODUTO', 'CODIGO', None, None)]
    property CODPRODUTO: string read FCODPRODUTO write FCODPRODUTO;
    [campo('DESCRICAO', tpVARCHAR, 100)]
    property DESCRICAO: string read FDESCRICAO write FDESCRICAO;
    [campo('UND', tpVARCHAR, 3)]
    property UND: string read FUND write FUND;
    [campo('QTD', tpNUMERIC, 15, 4)]
    property QTD: double read FQTD write FQTD;
    [campo('VALOR_UNITA', tpNUMERIC, 15, 4)]
    property VALOR_UNITA: currency read FVALOR_UNITA write FVALOR_UNITA;
    [campo('VALOR_DESCONTO', tpNUMERIC, 15, 4)]
    property VALOR_DESCONTO: currency read FVALOR_DESCONTO write FVALOR_DESCONTO;
    [campo('VALOR_TOTAL', tpNUMERIC, 15, 4)]
    property VALOR_TOTAL: currency read GetValorTotal;

    [campo('DATAVENDA', tpDATE, 0, 0)]
    property DATADAVENDA: TDateTime read FDATADAVENDA write SetDATADAVENDA;

    [campo('STATUS', tpVARCHAR,1)]
    property STATUS:string read FSTATUS write SetSTATUS;

  public
    constructor create;
    class function CreateItem(
      pSEQ: INTEGER;
      pPRODUTO: string;
      pDESCRICAO: string;
      pUND: string;
      pQTD: double;
      pVALOR_UNITA: currency;
      pVALOR_DESCONTO: currency;
      pVALOR_TOTAL: currency
      ): TItemPedido;
  end;

implementation



{ TItensPedido }

constructor TItemPedido.create;
begin
  inherited;
  Self.Clean();
  DATADAVENDA := Now;
end;

class function TItemPedido.CreateItem(pSEQ: INTEGER; pPRODUTO: string;
  pDESCRICAO, pUND: string; pQTD: double; pVALOR_UNITA, pVALOR_DESCONTO,
  pVALOR_TOTAL: currency): TItemPedido;
begin
  result := TItemPedido.create;
  result.SEQ := pSEQ;
  result.CODPRODUTO := pPRODUTO;
  result.DESCRICAO := pDESCRICAO;
  result.UND := pUND;
  result.QTD := pQTD;
  result.VALOR_UNITA := pVALOR_UNITA;
  result.VALOR_DESCONTO := pVALOR_DESCONTO;

end;

function TItemPedido.GetValorTotal: currency;
begin
  try
    result := (Self.QTD * Self.VALOR_UNITA) - Self.VALOR_DESCONTO;
    result := TUtil.Truncar(result, 3);
  except
    on E: Exception do
      raise TCalculoException.create('Falha no Calculo do Valor Total do Item: ' + E.message);
  end;
end;

procedure TItemPedido.SetDATADAVENDA(const Value: TDateTime);
begin
  FDATADAVENDA := Value;
end;

procedure TItemPedido.setIDPEDIDO(value: INTEGER);
begin
  if value < 0 then
    raise TValidacaoException.create('O valor para IDPEDIDO não é válido');

  Self.FIDPEDIDO := value;
end;

procedure TItemPedido.SetSTATUS(const Value: string);
begin
  FSTATUS := Value;
end;

end.
