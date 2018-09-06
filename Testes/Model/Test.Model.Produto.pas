unit Test.Model.Produto;

interface

uses System.SysUtils, Model.Atributos, Model.Atributos.Tipos, Model.IModelBase, Model.IObserve, Model.ModelBase;

type

  [Tabela('PRODUTO')]
  TProduto = class(TModelBase)
  private
    FCODIGO: string;
    FBARRAS: string;
    FDESCRICAO: string;
    FUND: string;
    FCODFORNECEDOR: string;
    FCUSTO_MEDIO: currency;
    FPRECO_CUSTO: currency;
    FPRECO_VENDA: currency;
    FPRECO_ATACADO: currency;
    FMARGEM_LUCRO: currency;
    FALTERACAO_PRECO: TDateTime;
    FULTIMA_COMPRA: TDateTime;
    FULTIMA_VENDA: TDateTime;
    FDATA_CADASTRO: TDateTime;
    FBLOQUEADO: Boolean;
    FQUANTIDADEFRACIONADA: Boolean;
    FOBSERVACOES: string;
    FID: Integer;
    FXML: AnsiString;

    function getBLOQUEADO: Boolean;
    procedure setBLOQUEADO(const Value: Boolean);
    function getALTERACAO_PRECO: TDateTime;
    function getBARRAS: string;
    function getCODFORNECEDOR: string;
    function getCODIGO: string;
    function getCUSTO_MEDIO: currency;
    function getDATA_CADASTRO: TDateTime;
    function getDESCRICAO: string;
    function getetBLOQUEADO: Boolean;
    function getMARGEM_LUCRO: currency;
    function getOBSERVACOES: string;
    function getPRECO_ATACADO: currency;
    function getPRECO_CUSTO: currency;
    function getPRECO_VENDA: currency;
    function getULTIMA_COMPRA: TDateTime;
    function getULTIMA_VENDA: TDateTime;
    function getUND: string;
    procedure setALTERACAO_PRECO(const Value: TDateTime);
    procedure setBARRAS(const Value: string);
    procedure setCODFORNECEDOR(const Value: string);
    procedure setCODIGO(const Value: string);
    procedure setCUSTO_MEDIO(const Value: currency);
    procedure setDATA_CADASTRO(const Value: TDateTime);
    procedure setDESCRICAO(const Value: string);
    procedure setetBLOQUEADO(const Value: Boolean);
    procedure setMARGEM_LUCRO(const Value: currency);
    procedure setOBSERVACOES(const Value: string);
    procedure setPRECO_ATACADO(const Value: currency);
    procedure setPRECO_CUSTO(const Value: currency);
    procedure setPRECO_VENDA(const Value: currency);
    procedure setULTIMA_COMPRA(const Value: TDateTime);
    procedure setULTIMA_VENDA(const Value: TDateTime);
    procedure setUND(const Value: string);

    function getQUANTIDADEFRACIONADA: Boolean;
    procedure setQUANTIDADEFRACIONADA(const Value: Boolean);
    procedure SetXML(const Value: AnsiString);
  published

    [PrimaryKey('PK_PRODUTO_CODIGO', 'CODIGO')]
    [campo('CODIGO', tpVARCHAR, 40, 0, True)]
    property CODIGO: string read getCODIGO write setCODIGO;

    [campo('BARRAS', tpVARCHAR, 20)]
    property BARRAS: string read getBARRAS write setBARRAS;

    [campo('DESCRICAO', tpVARCHAR, 40)]
    property DESCRICAO: string read getDESCRICAO write setDESCRICAO;

    [campo('UND', tpVARCHAR, 3)]
    property UND: string read getUND write setUND;

    [campo('CUSTO_MEDIO', tpNUMERIC, 15, 4)]
    property CUSTO_MEDIO: currency read getCUSTO_MEDIO write setCUSTO_MEDIO;
    [campo('PRECO_CUSTO', tpNUMERIC, 15, 4)]

    property PRECO_CUSTO: currency read getPRECO_CUSTO write setPRECO_CUSTO;
    [campo('PRECO_VENDA', tpNUMERIC, 15, 4)]

    property PRECO_VENDA: currency read getPRECO_VENDA write setPRECO_VENDA;
    [campo('PRECO_ATACADO', tpNUMERIC, 15, 4)]

    property PRECO_ATACADO: currency read getPRECO_ATACADO write setPRECO_ATACADO;
    [campo('MARGEM_LUCRO', tpNUMERIC, 15, 4)]

    property MARGEM_LUCRO: currency read getMARGEM_LUCRO write setMARGEM_LUCRO;

    [campo('ALTERACAO_PRECO', tpDATE)]
    property ALTERACAO_PRECO: TDateTime read getALTERACAO_PRECO write setALTERACAO_PRECO;

    [campo('ULTIMA_COMPRA', tpDATE)]
    property ULTIMA_COMPRA: TDateTime read getULTIMA_COMPRA write setULTIMA_COMPRA;

    [campo('ULTIMA_VENDA', tpTIMESTAMP)]
    property ULTIMA_VENDA: TDateTime read getULTIMA_VENDA write setULTIMA_VENDA;

    [campo('DATA_CADASTRO', tpDATE)]
    property DATA_CADASTRO: TDateTime read getDATA_CADASTRO write setDATA_CADASTRO;

    [campo('BLOQUEADO', tpBIT, 0, 0)]
    property BLOQUEADO: Boolean read getetBLOQUEADO write setetBLOQUEADO;

    [campo('OBSERVACOES', tpVARCHAR, 35)]
    property OBSERVACOES: string read getOBSERVACOES write setOBSERVACOES;

    [campo('QUANTIDADEFRACIONADA', tpBIT, 0, 0)]
    property QUANTIDADEFRACIONADA: Boolean read getQUANTIDADEFRACIONADA write setQUANTIDADEFRACIONADA;

    [campo('MENSAGEMRETORNO', tpXML)]
    property MENSAGEMRETORNO:AnsiString read FXML write SetXML;


  public
    constructor create();
    class function CreateProduto(
      pCODIGO: string;
      pBARRAS: string;
      pDESCRICAO: string;
      pUND: string;
      pCODFORNECEDOR: string;
      pCUSTO_MEDIO: currency;
      pPRECO_CUSTO: currency;
      pPRECO_VENDA: currency;
      pPRECO_ATACADO: currency;
      pMARGEM_LUCRO: currency;
      pALTERACAO_PRECO: TDateTime;
      pULTIMA_COMPRA: TDateTime;
      pULTIMA_VENDA: TDateTime;
      pDATA_CADASTRO: TDateTime;
      pBLOQUEADo: Boolean;
      pOBSERVACOES: string

      ): TProduto;
    destructor destroy; override;
  end;

implementation

{ TProduto }

constructor TProduto.create;
begin
  inherited;
  Self.Clean();
  // Self.Fornecedor := TFornecedor.create;
end;

class function TProduto.CreateProduto(pCODIGO, pBARRAS, pDESCRICAO, pUND,
  pCODFORNECEDOR: string; pCUSTO_MEDIO, pPRECO_CUSTO, pPRECO_VENDA,
  pPRECO_ATACADO, pMARGEM_LUCRO: currency; pALTERACAO_PRECO, pULTIMA_COMPRA,
  pULTIMA_VENDA, pDATA_CADASTRO: TDateTime; pBLOQUEADo: Boolean;
  pOBSERVACOES: string): TProduto;
begin
  result := TProduto.create;
  result.CODIGO := pCODIGO;
  result.BARRAS := pBARRAS;
  result.DESCRICAO := pDESCRICAO;
  result.UND := pUND;
  result.CUSTO_MEDIO := pCUSTO_MEDIO;
  result.PRECO_CUSTO := pPRECO_CUSTO;
  result.PRECO_VENDA := pPRECO_VENDA;
  result.PRECO_ATACADO := pPRECO_ATACADO;
  result.MARGEM_LUCRO := pMARGEM_LUCRO;
  result.ALTERACAO_PRECO := pALTERACAO_PRECO;
  result.ULTIMA_COMPRA := pULTIMA_COMPRA;
  result.ULTIMA_VENDA := pULTIMA_VENDA;
  result.DATA_CADASTRO := pDATA_CADASTRO;
  result.BLOQUEADO := pBLOQUEADo;
  result.OBSERVACOES := pOBSERVACOES;

end;

destructor TProduto.destroy;
begin

  inherited;
end;

function TProduto.getALTERACAO_PRECO: TDateTime;
begin
  result := FALTERACAO_PRECO;
end;

function TProduto.getBARRAS: string;
begin
  result := FBARRAS;
end;

function TProduto.getBLOQUEADO: Boolean;
begin
  result := FBLOQUEADO;
end;

function TProduto.getCODFORNECEDOR: string;
begin
  result := FCODFORNECEDOR;
end;

function TProduto.getCODIGO: string;
begin
  result := FCODIGO;
end;

function TProduto.getCUSTO_MEDIO: currency;
begin
  result := FCUSTO_MEDIO;
end;

function TProduto.getDATA_CADASTRO: TDateTime;
begin
  result := FDATA_CADASTRO;
end;

function TProduto.getDESCRICAO: string;
begin
  result := FDESCRICAO;
end;

function TProduto.getetBLOQUEADO: Boolean;
begin
  result := FBLOQUEADO;
end;

function TProduto.getMARGEM_LUCRO: currency;
begin
  result := FMARGEM_LUCRO;
end;

function TProduto.getOBSERVACOES: string;
begin
  result := FOBSERVACOES;
end;

function TProduto.getPRECO_ATACADO: currency;
begin
  result := FPRECO_ATACADO;
end;

function TProduto.getPRECO_CUSTO: currency;
begin
  result := FPRECO_CUSTO;
end;

function TProduto.getPRECO_VENDA: currency;
begin
  result := FPRECO_VENDA;
end;

function TProduto.getQUANTIDADEFRACIONADA: Boolean;
begin
  result := FQUANTIDADEFRACIONADA;
end;

function TProduto.getULTIMA_COMPRA: TDateTime;
begin
  result := FULTIMA_COMPRA;
end;

function TProduto.getULTIMA_VENDA: TDateTime;
begin
  result := FULTIMA_VENDA;
end;

function TProduto.getUND: string;
begin
  result := FUND;
end;

procedure TProduto.setALTERACAO_PRECO(const Value: TDateTime);
begin
  if Value <> FALTERACAO_PRECO then
  begin
    FALTERACAO_PRECO := Value;
    NotifyBinding('ALTERACAO_PRECO');
  end;
end;

procedure TProduto.setBARRAS(const Value: string);
begin
  if Value <> FBARRAS then
  begin
    FBARRAS := Value;
    NotifyBinding('BARRAS');
  end;
end;

procedure TProduto.setBLOQUEADO(const Value: Boolean);
begin
  if Value <> FBLOQUEADO then
  begin
    FBLOQUEADO := Value;
    NotifyBinding('BLOQUEADO');
  end;
end;

procedure TProduto.setCODFORNECEDOR(const Value: string);
begin
  if Value <> FCODFORNECEDOR then
  begin
    FCODFORNECEDOR := Value;
    NotifyBinding('CODFORNECEDOR');
  end;
end;

procedure TProduto.setCODIGO(const Value: string);
begin
  if Value <> FCODIGO then
  begin
    FCODIGO := Value;
    NotifyBinding('CODIGO');
  end;
end;

procedure TProduto.setCUSTO_MEDIO(const Value: currency);
begin
  if Value <> FCUSTO_MEDIO then
  begin
    FCUSTO_MEDIO := Value;
    NotifyBinding('CUSTO_MEDIO');
  end;
end;

procedure TProduto.setDATA_CADASTRO(const Value: TDateTime);
begin
  if Value <> FDATA_CADASTRO then
  begin
    FDATA_CADASTRO := Value;
    NotifyBinding('DATA_CADASTRO');
  end;
end;

procedure TProduto.setDESCRICAO(const Value: string);
begin
  if Value <> FDESCRICAO then
  begin
    FDESCRICAO := Value;
    NotifyBinding('DESCRICAO');
  end;
end;

procedure TProduto.setetBLOQUEADO(const Value: Boolean);
begin
  if Value <> FBLOQUEADO then
  begin
    FBLOQUEADO := Value;
    NotifyBinding('BLOQUEADO');
  end;
end;

procedure TProduto.setMARGEM_LUCRO(const Value: currency);
begin
  if Value <> FMARGEM_LUCRO then
  begin
    FMARGEM_LUCRO := Value;
    NotifyBinding('MARGEM_LUCRO');
  end;
end;

procedure TProduto.setOBSERVACOES(const Value: string);
begin
  if Value <> FOBSERVACOES then
  begin
    FOBSERVACOES := Value;
    NotifyBinding('OBSERVACOES');
  end;
end;

procedure TProduto.setPRECO_ATACADO(const Value: currency);
begin
  if Value <> FPRECO_ATACADO then
  begin
    FPRECO_ATACADO := Value;
    NotifyBinding('PRECO_ATACADO');
  end;
end;

procedure TProduto.setPRECO_CUSTO(const Value: currency);
begin
  if Value <> FPRECO_CUSTO then
  begin
    FPRECO_CUSTO := Value;
    NotifyBinding('PRECO_CUSTO');
  end;
end;

procedure TProduto.setPRECO_VENDA(const Value: currency);
begin
  if Value <> FPRECO_VENDA then
  begin
    FPRECO_VENDA := Value;
    NotifyBinding('PRECO_VENDA');
  end;
end;

procedure TProduto.setQUANTIDADEFRACIONADA(const Value: Boolean);
begin
  if Value <> FQUANTIDADEFRACIONADA then
  begin
    FQUANTIDADEFRACIONADA := Value;
    NotifyBinding('QUANTIDADEFRACIONADA');
  end;
end;

procedure TProduto.setULTIMA_COMPRA(const Value: TDateTime);
begin
  if Value <> FULTIMA_COMPRA then
  begin
    FULTIMA_COMPRA := Value;
    NotifyBinding('ULTIMA_COMPRA');
  end;
end;

procedure TProduto.setULTIMA_VENDA(const Value: TDateTime);
begin
  if Value <> FULTIMA_VENDA then
  begin
    FULTIMA_VENDA := Value;
    NotifyBinding('ULTIMA_VENDA');
  end;
end;

procedure TProduto.setUND(const Value: string);
begin
  if Value <> FUND then
  begin
    FUND := Value;
    NotifyBinding('UND');
  end;
end;

procedure TProduto.SetXML(const Value: AnsiString);
begin
  FXML := Value;
end;

end.
