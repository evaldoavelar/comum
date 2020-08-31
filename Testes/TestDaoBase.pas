unit TestDaoBase;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, System.SysUtils, System.DateUtils, Model.ModelBase, Dao.Base, Dao.IConection,
  System.Classes, Dao.Conection.Firedac, Data.DB, System.Rtti, Dao.Conection.Parametros,
  Database.SGDB, Test.Model.Produto, Test.Model.Pedido, Test.Model.Item, System.Generics.Collections,
  Winapi.Windows, Model.IModelBase, Test.Model.TMOV;

type
  // Test methods for class TDaoBase

  TestTDaoBase = class(TTestCase)
  strict private
    FDaoBase: TDaoBase;
    Models: TList<TModelBase>;
  private
    function ProdutoTeste(): TProduto;
    function PedidoTeste(): TPedido;
    procedure CheckProdutos(Produto: TProduto; ProdutoBD: TProduto);
    procedure CheckItemPedido(Item: TItemPedido; ItemBD: TItemPedido);
    function GetXML: AnsiString;

  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure GetProdutoSQLBuilder;

    procedure GetProdutoDoisParametros;
    procedure GetProdutoMaisDeDoisParametros;
    procedure GetProdutoSemParametros;
    procedure GetProdutoUmParametros;

    procedure PodeInserirProduto;
    procedure PodeAtualizarProdutoSQlBuilder;
    procedure PodeAtualizarProduto;
    procedure PodeExcluirProduto;
    procedure PodeExcluirProdutoSQLBuilder;

    procedure PodeDarSelectEmObjetoSemAnotacao;

    procedure PodeInserirAtualizarApagarPedido;
  end;

implementation

procedure TestTDaoBase.SetUp;
var
  conexao: TFiredacConection;

begin
  conexao := TFiredacConection.Create(
    TConectionParametros.Create(
    tpSqlServer,
    'LOCALHOST',
    'testeComum',
    'rm',
    'rm',
    'Teste',
    0
    )
    );

  FDaoBase := TDaoBase.Create(conexao);
  Models := TList<TModelBase>.Create;
end;

procedure TestTDaoBase.TearDown;
var
  Model: TModelBase;
begin

  // deletar do banco  os models que ficaram na memoria
  for Model in Models do
  begin
    if (Model is TProduto) then
      FDaoBase.Delete<TProduto>(TProduto(Model))
    else if (Model is TPedido) then
      FDaoBase.Delete<TPedido>(TPedido(Model))
    else if (Model is TItemPedido) then
      FDaoBase.Delete<TItemPedido>(TItemPedido(Model));
  end;

  Models.Free;
  Models := nil;

  FDaoBase.Free;
  FDaoBase := nil;
end;

procedure TestTDaoBase.GetProdutoDoisParametros;
var
  Produto: TProduto;
begin
  Produto := FDaoBase.SelectALL<TProduto>()
    .Where(['CODIGO', 'UND'], ['123456', 'UN'])
    .Get();

end;

procedure TestTDaoBase.GetProdutoSemParametros;
var
  Produto: TList<TProduto>;
begin
  Produto := FDaoBase
    .SelectALL<TProduto>()
    .ToList();
end;

procedure TestTDaoBase.GetProdutoSQLBuilder;
var
  Produtos: TList<TProduto>;
  Produto1: TProduto;
  Produto2: TProduto;
  Produto3: TProduto;
begin
  // ambiente
  Produto1 := ProdutoTeste();
  Produto1.DESCRICAO := 'Descricao Teste';
  FDaoBase.Insert<TProduto>(Produto1);

  Produto2 := ProdutoTeste();
  Produto2.DESCRICAO := 'Descricao Teste';
  FDaoBase.Insert<TProduto>(Produto2);

  Produto3 := ProdutoTeste();
  Produto3.DESCRICAO := 'Descricao Teste';
  FDaoBase.Insert<TProduto>(Produto3);

  // a��o
  Produtos :=
    FDaoBase.Select<TProduto>()
    .Column('DESCRICAO')
    .From('PRODUTO')
    .Where('DESCRICAO').Like('Descricao Teste')
    .&And('UND').Equal('UN')
    .&And('DATA_CADASTRO').GreaterOrEqual(date)
    .&And('PRECO_VENDA').Greater(11.99)
    .&And('PRECO_ATACADO').LessOrEqual(100.50)
    .&Or('BLOQUEADO').Equal(False)
    .OrderBy('DATA_CADASTRO')
    .ToList();

  CheckEquals(FDaoBase.LastSql, 'Select ' + #13#10 + ' DESCRICAO' + #13#10 +
    ' From PRODUTO Where (DESCRICAO Like :DESCRICAO) And (UND = :UND) And (DATA_CADASTRO >= :DATA_CADASTRO) And (PRECO_VENDA > :PRECO_VENDA) And (PRECO_ATACADO <= :PRECO_ATACADO) Or (BLOQUEADO = :BLOQUEADO) Order By DATA_CADASTRO');

  CheckTrue(Produtos.Count >= 3);
  Produtos.Free;
end;

procedure TestTDaoBase.GetProdutoUmParametros;
var
  Produto: TProduto;
begin
  Produto := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], ['123456'])
    .Get();
end;

function TestTDaoBase.PedidoTeste: TPedido;
var
  Item: TItemPedido;
  Produto: TProduto;
begin
  result := TPedido.Create;
  result.NUMERO := Random(99999).ToString;
  result.DATAPEDIDO := now;
  result.HORAPEDIDO := Time;
  result.OBSERVACAO := 'Pedido Teste';
  result.VALORDESC := 0.20;
  result.ValorEntrada := 11.22;
  Models.Add(result);

  Item := TItemPedido.Create;

  Produto := ProdutoTeste();
  Item.SEQ := 1;
  Item.CODPRODUTO := Produto.CODIGO;
  Item.DESCRICAO := Produto.BARRAS;
  Item.UND := Produto.UND;
  Item.QTD := 99;
  Item.VALOR_UNITA := Round(Random(9999) * 0.1);
  Item.VALOR_DESCONTO := 0.6;
  Item.STATUS := 'A';
  result.Itens.Add(Item);
  Models.Add(Item);

  Produto := ProdutoTeste();
  Item := TItemPedido.Create;
  Item.SEQ := 2;
  Item.CODPRODUTO := Produto.CODIGO;
  Item.DESCRICAO := Produto.BARRAS;
  Item.UND := Produto.UND;
  Item.QTD := 55;
  Item.VALOR_UNITA := Round(Random(9999) * 0.1);
  Item.VALOR_DESCONTO := 0.7;
  Item.STATUS := 'A';
  result.Itens.Add(Item);
  Models.Add(Item);

  Produto := ProdutoTeste();
  Item := TItemPedido.Create;
  Item.SEQ := 3;
  Item.CODPRODUTO := Produto.CODIGO;
  Item.DESCRICAO := Produto.BARRAS;
  Item.UND := Produto.UND;
  Item.QTD := 1;
  Item.VALOR_UNITA := Round(Random(9999) * 0.1);
  Item.VALOR_DESCONTO := 0.7;
  Item.STATUS := 'A';
  result.Itens.Add(Item);
  Models.Add(Item);

end;

procedure TestTDaoBase.PodeAtualizarProduto;
var
  Produto: TProduto;
  ProdutoBD: TProduto;
begin
  // ambiente
  Produto := ProdutoTeste();

  FDaoBase.Insert<TProduto>(Produto);

  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [Produto.CODIGO]).Get();
  CheckNotNull(ProdutoBD);
  CheckProdutos(Produto, ProdutoBD);

  // teste
  Produto.DESCRICAO := 'Descri��o Atualizada!!!!';
  Produto.BLOQUEADO := True;
  Produto.PRECO_CUSTO := 1.99;
  Produto.DATA_CADASTRO := date;
  Produto.TESTENULLSTRING := 'TESTENULLSTRING';
  FDaoBase.Update<TProduto>(Produto);

  // assertivas
  FreeAndNil(ProdutoBD);
  ProdutoBD := FDaoBase.SelectALL<TProduto>.Where(['CODIGO'], [Produto.CODIGO]).Get();

  CheckNotNull(ProdutoBD);
  CheckProdutos(Produto, ProdutoBD);
  CheckEquals(Produto.TESTENULLSTRING.HasValue, True);
  CheckEquals(Produto.TESTENULLSTRING.Value, ProdutoBD.TESTENULLSTRING.Value);
end;

procedure TestTDaoBase.PodeAtualizarProdutoSQlBuilder;
var
  Produto: TProduto;
  ProdutoBD: TProduto;
  CODIGO, DESCRICAO: string;
begin
  // ambiente
  Produto := ProdutoTeste();
  CODIGO := Produto.CODIGO;
  FDaoBase.Insert<TProduto>(Produto);

  // confirmar que o produto est� no banco de dados
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [CODIGO])
    .Get();
  CheckNotNull(ProdutoBD);
  FreeAndNil(ProdutoBD);

  DESCRICAO := 'ALterado';
  Produto.DESCRICAO := DESCRICAO;

  Produto.UND := 'CXA';

  // teste
  FDaoBase.Update<TProduto>
    .ColumnSetValue('DESCRICAO', DESCRICAO)
    .ColumnSetValue('UND', 'CXA')
    .Where('CODIGO').Equal(CODIGO)
    .&And('UND').Equal('UN')
    .Exec();

  // assertiva
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where('CODIGO').Equal(CODIGO)
    .Get();

  CheckNotNull(ProdutoBD);
  CheckEquals(ProdutoBD.DESCRICAO, DESCRICAO);

  // CheckEquals(FDaoBase.LastSql, 'Update ' + #13#10 + ' *' + #13#10 +
  // ' PRODUTO set  (DESCRICAO Like :DESCRICAO) And (UND = :UND) And (DATA_CADASTRO >= :DATA_CADASTRO) And (PRECO_VENDA > :PRECO_VENDA) And (PRECO_ATACADO <= :PRECO_ATACADO) Or (BLOQUEADO = :BLOQUEADO) Order By DATA_CADASTRO');

end;

procedure TestTDaoBase.PodeDarSelectEmObjetoSemAnotacao;
var
  tmovs: TList<TMOV>;
begin
 // tmovs := FDaoBase.SelectALL<TMOV>      .ToList;

  //CheckTrue(tmovs.Count > 0);
end;

procedure TestTDaoBase.PodeExcluirProduto;
var
  Produto: TProduto;
  ProdutoBD: TProduto;
  CODIGO: string;
begin
  // ambiente
  Produto := ProdutoTeste();
  CODIGO := Produto.CODIGO;
  FDaoBase.Insert<TProduto>(Produto);

  // confirmar que o produto est� no banco de dados
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [CODIGO])
    .Get();
  CheckNotNull(ProdutoBD);
  FreeAndNil(ProdutoBD);

  // teste
  FDaoBase.Delete<TProduto>(Produto);

  // assertiva
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [CODIGO])
    .Get();
  CheckNull(ProdutoBD);

end;

procedure TestTDaoBase.PodeExcluirProdutoSQLBuilder;
var
  Produto: TProduto;
  ProdutoBD: TProduto;
  CODIGO: string;
begin
  // ambiente
  Produto := ProdutoTeste();
  CODIGO := Produto.CODIGO;
  FDaoBase.Insert<TProduto>(Produto);

  // confirmar que o produto est� no banco de dados
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [CODIGO])
    .Get();
  CheckNotNull(ProdutoBD);
  FreeAndNil(ProdutoBD);

  // teste
  FDaoBase.Delete<TProduto>()
    .Where('CODIGO').Equal(CODIGO)
    .Exec;

  // assertiva
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [CODIGO])
    .Get();
  CheckNull(ProdutoBD);
end;

function TestTDaoBase.GetXML: AnsiString;
var
  builder: TStringBuilder;
begin
  builder := TStringBuilder.Create;
  builder.Append('<eSocial xmlns="http://www.esocial.gov.br/schema/lote/eventos/envio/retornoProcessamento/v1_3_0" ');
  builder.Append('xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">');
  builder.Append('<retornoProcessamentoLoteEventos>');
  builder.Append('<ideEmpregador>');
  builder.Append('<tpInsc>1</tpInsc>');
  builder.Append('<nrInsc>0000000</nrInsc>');
  builder.Append('</ideEmpregador>');
  builder.Append('<ideTransmissor>');
  builder.Append('<tpInsc>1</tpInsc>');
  builder.Append('<nrInsc>0000000000000</nrInsc>');
  builder.Append('</ideTransmissor>');
  builder.Append('<status>');
  builder.Append('<cdResposta>201</cdResposta>');
  builder.Append('<descResposta>Lote processado com sucesso.</descResposta>');
  builder.Append('</status>');
  builder.Append('<dadosRecepcaoLote>');
  builder.Append('<dhRecepcao>2018-05-25T13:25:35.92</dhRecepcao>');
  builder.Append('<versaoAplicativoRecepcao>0.1.0-A0296</versaoAplicativoRecepcao>');
  builder.Append('<protocoloEnvio>1.0.00000.00000000000034539</protocoloEnvio>');
  builder.Append('</dadosRecepcaoLote>');
  builder.Append('<dadosProcessamentoLote>');
  builder.Append('<versaoAplicativoProcessamentoLote>1.0.0.0</versaoAplicativoProcessamentoLote>');
  builder.Append('</dadosProcessamentoLote>');
  builder.Append('<retornoEventos>');
  builder.Append('<evento Id="ID102226813000000000000000000pp325391" evtDupl="true">');
  builder.Append('<retornoEvento>');
  builder.Append('<eSocial xmlns="http://www.esocial.gov.br/schema/evt/retornoEvento/v1_2_0">');
  builder.Append('<retornoEvento Id="0000000000000000">');
  builder.Append('<ideEmpregador>');
  builder.Append('<tpInsc>1</tpInsc>');
  builder.Append('<nrInsc>00000000</nrInsc>');
  builder.Append('</ideEmpregador>');
  builder.Append('<recepcao>');
  builder.Append('<tpAmb>2</tpAmb>');
  builder.Append('<dhRecepcao>2018-05-16T10:01:32.203</dhRecepcao>');
  builder.Append('<versaoAppRecepcao>0.0.0-0000</versaoAppRecepcao>');
  builder.Append('<protocoloEnvioLote>0.0.0000000.0000000000000000</protocoloEnvioLote>');
  builder.Append('</recepcao>');
  builder.Append('<processamento>');
  builder.Append('<cdResposta>201</cdResposta>');
  builder.Append('<descResposta>Sucesso.</descResposta>');
  builder.Append('<versaoAppProcessamento>10.0.0-A3037</versaoAppProcessamento>');
  builder.Append('<dhProcessamento>2018-05-16T10:14:26.74</dhProcessamento>');
  builder.Append('</processamento>');
  builder.Append('<recibo>');
  builder.Append('<nrRecibo>1.2.000000000000000000000</nrRecibo>');
  builder.Append('<hash>ZbOrdPLMaQANu/fIgUxL�ppGx444Pu8y6kc0FNtO6666=</hash>');
  builder.Append('</recibo>');
  builder.Append('</retornoEvento>');
  builder.Append('<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">');
  builder.Append('<SignedInfo>');
  builder.Append('<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>');
  builder.Append('<SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>');
  builder.Append('<Reference URI="">');
  builder.Append('<Transforms>');
  builder.Append('<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>');
  builder.Append('<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>');
  builder.Append('</Transforms>');
  builder.Append('<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>');
  builder.Append('<DigestValue>jdHeYTySiDvbgggkgggwYeogFXN0ndrMl6kPf39Ous=</DigestValue>');
  builder.Append('</Reference>');
  builder.Append('</SignedInfo>');
  builder.Append('<SignatureValue>K7QXnVetYlYaP1gwMmmJTrelKO8NzQAqspNqMa5jNXn/bWDxlDQFmq0PamrBOd38kEdGJWJ4sNC');
  builder.Append('iQ+xADjtLqco3AB9Vov71lCReAtvavWV+NLrHx5/dVKnb90L5298Ltxbq01LyuG+yt929jhipUIWY4bsJ1UStw+B/22QmrY');
  builder.Append('hbuJPR+cUCBVs7MNQQ3GmOhogJWWTNGku38iNwmKQXTEGgtJ90XFGHW3RTMEuvG6iInzyO1m7BepcdUGIj1Pamf3JKkYUaoK5n3g');
  builder.Append('z1G6K8722PiCVItJciR9915QW91XHiMpI9JbuzGdUSOAZtxm8q9mAlmOcb0575ImOgaWzP1Sw==</SignatureValue>');
  builder.Append('<KeyInfo>');
  builder.Append('<X509Data>');
  builder.Append('<X509Certificate>MIIHfDCCBWSgAwIBAgIDAuxpMA0GCSqGSIb3DQEBCwUAMIGOMQswCQYDVQQGEwJCUjETMBEGA1UECgwKSUNQ');
  builder.Append('LUJyYXNpbDE2MDQGA1UECwwtU2VjicmV0YXJpYSBkYSBSZWNlaXRhIEZlZGVyYWwgZG8gQnJhc2lsIC0gUkZCMTIwMAYDVQQDDClBdXRv');
  builder.Append('cmlkYWRlIENlcnRpZmljYWRvcmEgZG8gU0VSUFJPUkZCIFNTTDAeFw0xODA0MDMwOTUwMjNaFw0xOTA0MDMwOTUwMjNaMIG/MQswCQYDVQ');
  builder.Append('QGEwJCUjETMBEGA1UECgwKSUNQLUJyYXNpbDE2MDQGA1UECwwtU2VjcmV0YXJpYSBkYSBSZWNlaXRhIEZlZGVyYWwgZG8gQnJhc2lsIC0g');
  builder.Append('UkZCMREwDwYDVQQLDAhBUlNFUlBSTzEaMBgGA1UECwwRUkZCIGUtU2Vydmlkb3IgQTExNDAyBgNVBAMMK3dlYnNlcnZpY2VzLnByb2R1Y2');
  builder.Append('FvcmVzdHJpdGEuZXNvY2lhbCAA4IBDwAwggEKAoIBAQC2ClBKtKexOc439AhNgl4UZE+Zq66dPwQvpy0vwG7HTFk3j');
  builder.Append('ikkjO3Sq5Gw42wMuG/Z9RuCZ2018cbKoQ9CUNSEmCWUmdSRzlRABhsqm+r2gV/Fq8HEtaiT+sHkKdIMlt+X0ZdEDCHiaYx/pz3YBg1nuJX22XQgLbPxgOz+fzxh');
  builder.Append('RKHFKaU8sXmaLfYq/9NaubDHNEftUyqsQ+lh6ki6OwGkOjFAt1OQrcYF+ttiliejdG2/DQLTnOlGSS1Rdqb/F8T4Z/Y4Usiuoc5/25CbcyQI25V5XdXq53oE4Py');
  builder.Append('5K+kjwZR0vDl1GXH0d8S4XAdOHQNrd3kL1WF6VJZ9MflLWsBRAgMBAAGjggKuMIICqjAfBgNVHSMEGDAWgBQgjRFcVcMBb6tW8YPMaKmrwtq1YzBeBgNVHSAEVz');
  builder.Append('BVMFMGBmBMAQIBWzBJMEcGCCsGAQUFBwIBFjtodHRwOi8vcmVwb3NpdG9yaW8uc2VycHJvLmdvdi5ici9kb2NzL2RwY2Fjc2VycHJvcmZic3NsLnBkZjCBiwYDVR');
  builder.Append('0fBIGDMIGAMD2gO6A5hjdodHRwOii8vcmVwb3NpdG9yaW8uc2VycHJvLmdvdi5ici9sY3IvYWNzZXJwcm9yZmJzc2wuY3JsMD+gPaA7hjlodHRwOi8vY2VydGlmaWN');
  builder.Append('hZG9zMi5zZXJwcm8ub3JmYnNzbC5jcmwwVwYIKwYBBQUHAQEESzBJMEcGCCsGAQUFBzAChjtodHRwOi8vcmVwb3NpdG9yaW8uc2V');
  builder.Append('ycHJvLmdvdi5ici9jYWRlaWFzL2Fjc2VycHJvcmZic3NsLnA3YjCCAQ8GA1UdEQSCAQYwggECoDsGBWBMAQMIoDIEMFNFUlZJQ08gRkVERVJBTCBERSBQUk9DRVNT');
  builder.Append('QU1FTlRPIERFIERBRE9TIFNFUlBST4Ird2Vic2VydmljZXMucHJvZHVjYW9yZXN0cml0YS5lc29jaWFsLmdvdi5icqA4BgVgTAEDBKAvBC0xODAzMTk4MDI4NTYwM');
  builder.Append('TY4ODAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDCgIgYFYEwBAwKgGQQXRURVQVJETyBZT1NISURBIFNBTE9NQU+gGQYFYEwBAwOgEAQOMzM2ODMxMTEwMDAxMDe');
  builder.Append('BHWVkdWFyZG8292LmJyMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDQYJKoZIhvcNAQELBQA');
  builder.Append('DggIBADBkJ0M975whifUoi94dq9pB/vH6gXb28M7q/iBcvuMKTjw2qNJAjDj+0L5ELn4xpnY9zccOUlKh+VaA61b+egmvVQWoycxBVCEmGSPNLoSkXepnlKXYKwU');
  builder.Append('kPZ+OQojeI8Ax/OpD1iw9lp8ETN7myeH0bdKexGlgmpH+2S1LbDQFySZi10TS0t65tTntatWHlasTe9t+XXrN6qHQSVJEmnCDyGpUvVdopZndkp7f7eKKNa3ac8L');
  builder.Append('UtmyaIH0S+rGx0F1xjfRhaiMnkFKP84DpUNptor+R92G+oAd1lhZeI8aCNguNnXTVJ9X2CmY3u47dN5uxgMJxTvzGj/3HgIk4EIha7ajZ');
  builder.Append('+g7VqLbTo+l7hCxkOTTF5hDt/ExEp8tHC08rXS3d1jLQV75NQ07Jto8ElzGqw6+tyj0L8UkKed0WV6KMeyEAwoGhXiUFSyt0uyzn1OWne+wI3OY6CFyE88Cd5Xc8/');
  builder.Append('IMRXHTuV4vl7kI1GeEsesnTZxBr+gM60CQX7P6872tVuM+nSsNCEgk7tzDSt3RnYV/BvJ9AVziLXxwWyIanPwYAcbWFB2I/ZG6gZtkVx3TcbhPw');
  builder.Append('ZbkcNXZiwoQKFQzVLAWSllCfv8HFwHMXCoiXkXaKWqfWHjDu+aAKE0m4brOMae+</X509Certificate>');
  builder.Append('</X509Data>');
  builder.Append('</KeyInfo>');
  builder.Append('</Signature>');
  builder.Append('</eSocial>');
  builder.Append('</retornoEvento>');
  builder.Append('</evento>');
  builder.Append('</retornoEventos>');
  builder.Append('</retornoProcessamentoLoteEventos>');
  builder.Append('</eSocial>');

  result := builder.ToString;
  builder.Free;
end;

procedure TestTDaoBase.CheckProdutos(Produto: TProduto; ProdutoBD: TProduto);
begin
  CheckEquals(Produto.CODIGO, ProdutoBD.CODIGO);
  CheckEquals(Produto.BARRAS, ProdutoBD.BARRAS);
  CheckEquals(Produto.DESCRICAO, ProdutoBD.DESCRICAO);
  CheckEquals(Produto.UND, ProdutoBD.UND);
  CheckEquals(Produto.CUSTO_MEDIO, ProdutoBD.CUSTO_MEDIO);
  CheckEquals(Produto.PRECO_CUSTO, ProdutoBD.PRECO_CUSTO);
  CheckEquals(Produto.PRECO_VENDA, ProdutoBD.PRECO_VENDA);
  CheckEquals(Produto.PRECO_ATACADO, ProdutoBD.PRECO_ATACADO);
  CheckEquals(Produto.MARGEM_LUCRO, ProdutoBD.MARGEM_LUCRO);
  CheckEquals(Produto.ALTERACAO_PRECO, ProdutoBD.ALTERACAO_PRECO);
  CheckEquals(Produto.ULTIMA_COMPRA, ProdutoBD.ULTIMA_COMPRA);
  CheckEquals(DateTimeToStr(Produto.ULTIMA_VENDA), DateTimeToStr(ProdutoBD.ULTIMA_VENDA));
  CheckEquals(Produto.DATA_CADASTRO, ProdutoBD.DATA_CADASTRO);
  CheckEquals(Produto.BLOQUEADO, ProdutoBD.BLOQUEADO);
  CheckEquals(Produto.OBSERVACOES, ProdutoBD.OBSERVACOES);
  CheckEquals(Produto.QUANTIDADEFRACIONADA, ProdutoBD.QUANTIDADEFRACIONADA);

end;

procedure TestTDaoBase.PodeInserirAtualizarApagarPedido;
var
  Pedido: TPedido;
  Item: TItemPedido;
  ItemBD: TItemPedido;
  Lista: TList<TItemPedido>;
  Produto: TProduto;
  sqlEsperado: string;
  I: Integer;
begin
  Pedido := PedidoTeste;
  // teste
  FDaoBase.Insert<TPedido>(Pedido);

  for Item in Pedido.Itens do
  begin
    Produto := ProdutoTeste();
    FDaoBase.Insert<TProduto>(Produto);

    Item.IDPEDIDO := Pedido.ID;
    Item.CODPRODUTO := Produto.CODIGO;
    Item.DESCRICAO := Produto.BARRAS;
    Item.UND := Produto.UND;

    FDaoBase.Insert<TItemPedido>(Item);

    // verificar se o item foi gravado
    ItemBD := FDaoBase.SelectALL<TItemPedido>
      .Where(['IDPEDIDO', 'SEQ'], [Item.IDPEDIDO, Item.SEQ])
      .Get();
    CheckNotNull(ItemBD);
    CheckItemPedido(Item, ItemBD);

    ItemBD.Free;
  end;

  Lista := FDaoBase.SelectALL<TItemPedido>
    .Where(['IDPEDIDO'], [Pedido.ID])
    .OrderBy('SEQ')
    .ToList();

  // CheckEquals(FDaoBase.LastSql, sqlEsperado);
  CheckEquals(Lista.Count, Pedido.ItemCount);

  for I := 0 to Pred(Lista.Count) do
  begin
    Item := Pedido.Itens[I];
    ItemBD := Lista[I];
    CheckItemPedido(Item, ItemBD);
  end;

  // alterar o item
  Item := Pedido.Itens[2];
  Item.DESCRICAO := 'Descri��o alterada!!!!';
  Item.VALOR_UNITA := 5.69;

  FDaoBase.Update<TItemPedido>(Item);

  // verificar se o item foi alterado
  ItemBD := FDaoBase.SelectALL<TItemPedido>
    .Where(['IDPEDIDO', 'SEQ'], [Item.IDPEDIDO, Item.SEQ])
    .Get();
  CheckNotNull(ItemBD);
  CheckItemPedido(Item, ItemBD);

  // deletar o item
  Item := Pedido.Itens[2];
  FDaoBase.Delete<TItemPedido>(Item);

  sqlEsperado := Format('Delete From ITEMPEDIDO Where (IDPEDIDO = %d) And (SEQ = %d)', [Item.IDPEDIDO, Item.SEQ]);
  CheckEquals(FDaoBase.LastSql, sqlEsperado);

  // verificar se o item foi apagado
  ItemBD := FDaoBase.SelectALL<TItemPedido>
    .Where(['IDPEDIDO', 'SEQ'], [Item.IDPEDIDO, Item.SEQ])
    .Get();
  CheckNull(ItemBD);

  // deletar o item
  Item := Pedido.Itens[0];
  FDaoBase.Delete<TItemPedido>(Item);

  sqlEsperado := Format('Delete From ITEMPEDIDO Where (IDPEDIDO = %d) And (SEQ = %d)', [Item.IDPEDIDO, Item.SEQ]);
  CheckEquals(FDaoBase.LastSql, sqlEsperado);

  // verificar se o item foi apagado
  ItemBD := FDaoBase.SelectALL<TItemPedido>
    .Where(['IDPEDIDO', 'SEQ'], [Item.IDPEDIDO, Item.SEQ])
    .Get();
  CheckNull(ItemBD);

  // deletar o item
  Item := Pedido.Itens[1];
  FDaoBase.Delete<TItemPedido>(Item);

  sqlEsperado := Format('Delete From ITEMPEDIDO Where (IDPEDIDO = %d) And (SEQ = %d)', [Item.IDPEDIDO, Item.SEQ]);
  CheckEquals(FDaoBase.LastSql, sqlEsperado);

  // verificar se o item foi apagado
  ItemBD := FDaoBase.SelectALL<TItemPedido>
    .Where(['IDPEDIDO', 'SEQ'], [Item.IDPEDIDO, Item.SEQ])
    .Get();
  CheckNull(ItemBD);

end;

procedure TestTDaoBase.CheckItemPedido(Item: TItemPedido; ItemBD: TItemPedido);
begin
  CheckEquals(Item.SEQ, ItemBD.SEQ);
  CheckEquals(Item.IDPEDIDO, ItemBD.IDPEDIDO);
  CheckEquals(Item.CODPRODUTO, ItemBD.CODPRODUTO);
  CheckEquals(Item.DESCRICAO, ItemBD.DESCRICAO);
  CheckEquals(Item.UND, ItemBD.UND);
  CheckEquals(Item.QTD, ItemBD.QTD);
  CheckEquals(Item.VALOR_UNITA, ItemBD.VALOR_UNITA);
  CheckEquals(Item.VALOR_DESCONTO, ItemBD.VALOR_DESCONTO);
  CheckEquals(Item.VALOR_TOTAL, ItemBD.VALOR_TOTAL);
  CheckEquals(Item.STATUS, ItemBD.STATUS);

end;

procedure TestTDaoBase.PodeInserirProduto;
var
  Produto: TProduto;
  ProdutoBD: TProduto;
begin
  // ambiente
  Produto := ProdutoTeste();

  // teste
  FDaoBase.Insert<TProduto>(Produto);

  // assertivas
  ProdutoBD := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO'], [Produto.CODIGO])
    .Get();
  CheckNotNull(ProdutoBD);
  CheckEquals(GetXML, ProdutoBD.MENSAGEMRETORNO);
  CheckProdutos(Produto, ProdutoBD);
  CheckEquals(Produto.TESTENULLSTRING.HasValue, ProdutoBD.TESTENULLSTRING.HasValue);

end;

function TestTDaoBase.ProdutoTeste(): TProduto;
begin
  result := TProduto.Create;
  result.CODIGO := Random(999999).ToString.PadLeft(6);
  result.BARRAS := Random(999999999).ToString.PadLeft(6);
  result.DESCRICAO := 'Teste de Porduto' + result.CODIGO;
  result.UND := 'UN';
  result.CUSTO_MEDIO := 22.56;
  result.PRECO_CUSTO := 22.80;
  result.PRECO_VENDA := 33.25;
  result.PRECO_ATACADO := 32.00;
  result.MARGEM_LUCRO := 0.05;
  result.ALTERACAO_PRECO := date;
  result.ULTIMA_COMPRA := date;
  result.DATA_CADASTRO := date;
  result.ULTIMA_VENDA := now;
  result.BLOQUEADO := False;
  result.OBSERVACOES := 'Teste de Dao;�������';
  result.QUANTIDADEFRACIONADA := True;
  result.MENSAGEMRETORNO := GetXML;
  result.TESTENULLSTRING.Clear;

  Models.Add(result);
end;

procedure TestTDaoBase.GetProdutoMaisDeDoisParametros;
var
  Produto: TProduto;
begin
  Produto := FDaoBase.SelectALL<TProduto>
    .Where(['CODIGO', 'UND', 'DESCRICAO'], [123456, 'UN', 'TESTE'])
    .Get();
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTDaoBase.Suite);

end.
