unit Database.TDataseMigrationBase;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Collections,
  System.Rtti,
  Data.DB,
  FireDAC.Comp.Client,
  Model.Atributos,
  Model.Atributos.Tipos,
  Dao.IConection,
  Utils.Funcoes,
  Database.IDataseMigration,
  Database.TTabelaBD,
  Database.SGDB,
  Database.Tabela.Firebird,
  Database.Tabela.SqlServer, Database.Tabela.Oracle;

type

  TArrayObject = array of TClass;

  /// <summary>
  /// Responsável por criar as tabelas e campos do objeto no banco de dados
  /// </summary>
  TDataseMigrationBase = Class(TInterfacedObject, IDataseMigration)
  private

  private
    FTipoBD: TSGBD;
    FErros: TDictionary<TClass, string>;
    FConection: IConection;
    FVersao: IDatabaseVersion;
    function getScript(Entity: TClass): TStringList;
    procedure ExtractedAttributes(var Tabela: TTabelaBD; arAttr: TArray<TCustomAttribute>);
    function Atualiza(AClasse: TClass; AScripts: TStringList): Integer;
    function getTipoTabela: TTabelaBD;
    function PodeMigrar: Boolean;

  protected
    // carga inicial na base
    procedure Seed(); virtual; abstract;
    // sobrescrever este metodo e passar quais sao os objetos que seram usados na migração
    function GetObjetos: TArrayObject; virtual; abstract;

  public
    function Migrate():IDataseMigration;
    function GetErros: TDictionary<TClass, string>;
    constructor create(aConection: IConection; aVersao: IDatabaseVersion; ATipo: TSGBD);
    destructor destroy();
  End;

  { TDataseMigrationFB }

implementation


function TDataseMigrationBase.getScript(Entity: TClass): TStringList;
var
  Rtti: TRttiContext;
  ltype: TRttiType;
  attr: TCustomAttribute;
  prop: TRttiProperty;
  FTabela: TTabelaBD;
begin
//veridicar se vai ser sql,oracle,firebird, etc
  FTabela := getTipoTabela;

  Rtti := TRttiContext.create;
  ltype := Rtti.GetType((Entity));

  // extrair as anotações das classes
  ExtractedAttributes(FTabela, ltype.GetAttributes);

  for prop in ltype.GetProperties do
  begin
   // extrair as anotações das propriedades
    ExtractedAttributes(FTabela, prop.GetAttributes);
  end;

  result := FTabela.toScript();

  FreeAndNil(FTabela);

end;

function TDataseMigrationBase.Migrate(): IDataseMigration;
var
  scripts: TStringList;
  classe: TClass;
  I: Integer;
  objetos: TArrayObject;
  VersaoEXE: string;
begin
  result := Self;
  self.FErros.clear;

  objetos := GetObjetos();

  if PodeMigrar() = false then
    Exit;

  try
    try
	  //pecorrer os objetos uinformados em  GetObjetos
      for I := Low(objetos) to High(objetos) do
      begin
           //recuperar a calsse do objeto
        classe := objetos[I];
        //monta o script sql desse objeto
        scripts := getScript(classe);
        //execulta o script no banco de dados
        Atualiza(classe, scripts);
      end;
    finally
      if Assigned(scripts) then
        FreeAndNil(scripts);
    end;

     //se não houve erros
    if FErros.Count = 0 then
    begin
      //obtem a versão do executável
      VersaoEXE := TUtil.GetVersionInfo();
      //salvar como ultima versao atualizada
      FVersao.AtualizaVersaoBD(VersaoEXE);
    end;

  except
    on E: Exception do
      raise Exception.create('Migrate: ' + classe.ClassName + ' - ' + E.Message);
  end;

end;

function TDataseMigrationBase.Atualiza(AClasse: TClass; AScripts: TStringList): Integer;
var
  sql: string;
begin
  result := 0;

  for sql in AScripts do
  begin
    try
      self.FConection.ExecSQL(sql);
    except
      on E: Exception do
      begin
        self.FErros.Add(AClasse, E.Message + ' - ' + sql);
        Inc(result);
      end;
    end;
  end;

end;

function TDataseMigrationBase.PodeMigrar: Boolean;
var
  VersaoEXE: string;
  VERSAOBD: string;
begin

  VERSAOBD := self.FVersao.GetVersaoBD;
  VersaoEXE := TUtil.GetVersionInfo();

  if (TUtil.CompararVersao(VersaoEXE, VERSAOBD) = stMenor) or (VersaoEXE = '0.0.0.0') then
    result := True;

end;

constructor TDataseMigrationBase.create(aConection: IConection; aVersao: IDatabaseVersion; ATipo: TSGBD);
begin
  self.FConection := aConection;
  self.FTipoBD := ATipo;
  self.FErros := TDictionary<TClass, string>.create();
  self.FVersao := aVersao;
end;

destructor TDataseMigrationBase.destroy;
begin
  self.FErros.clear;
  self.FErros.Free;
end;

function TDataseMigrationBase.getTipoTabela: TTabelaBD;
begin
  case FTipoBD of
    tpMysql:
      ;
    tpFirebird:
      result := TTabelaBDFB.create;
    tpSqlServer:
      result := TTabelaSqlServer.create;
    tpOracle:
     result := TTabelaOracle.create;
  end;
end;
/// <summary>
/// está função vai extrair os atributos dos objetos.
/// </summary>
/// <example>
///Abaixo a propriedade SEQ está notada com o atributo campo e PrimaryKey
/// <code>
///    [campo('SEQ', tpINTEGER, 0, 0, True)]
///    [PrimaryKey('PK_ITEMPEDIDO', 'IDPEDIDO,SEQ')]
///    property SEQ: INTEGER read FSEQ write FSEQ;
/// </code>
/// </example>
procedure TDataseMigrationBase.ExtractedAttributes(var Tabela: TTabelaBD; arAttr: TArray<TCustomAttribute>);
var
  attr: TCustomAttribute;
begin
  for attr in arAttr do
  begin
    if attr is TabelaAttribute then
    begin
      Tabela.Tabela := TabelaAttribute(attr);
    end
    else if attr is CampoAttribute then
    begin
      Tabela.Campos.Add(CampoAttribute(attr));
    end
    else if attr is PrimaryKeyAttribute then
    begin
      Tabela.Pks.Add(PrimaryKeyAttribute(attr));
    end
    else if attr is ForeignKeyAttribute then
    begin
      Tabela.Fks.Add(ForeignKeyAttribute(attr));
    end;
  end;
end;

function TDataseMigrationBase.GetErros: TDictionary<TClass, string>;
begin
  result := FErros;
end;

end.
