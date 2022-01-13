unit Database.Tabela.Oracle;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Collections,
  System.Rtti,
  Database.IDataseMigration,
  Database.TTabelaBD, Model.Atributos, Model.Atributos.Tipos, Utils.Funcoes;

type

  TTabelaOracle = Class(TTabelaBD)
  private
    function CampoToSql(campo: CampoAttribute): string;
    function FkToSql(fk: ForeignKeyAttribute): string;
  public
    function toScript(): TStringList; override;
  End;

  { TDataseMigrationFB }

implementation


{ TTabelaBDFB }

function TTabelaOracle.CampoToSql(campo: CampoAttribute): string;
var
  default: string;
  NotNull: string;
  tipoSQl: string;
  maxTam: Integer;
begin
  if campo.DefaultValue <> '' then
    if (campo.Tipo = tpVARCHAR) or (campo.Tipo = tpCHAR) then
      default := Format(' DEFAULT ''''%s'''' ', [campo.DefaultValue])
    else
      default := Format(' DEFAULT %s ', [campo.DefaultValue])
  else
    default := '';

  if campo.NotNull then
    NotNull := ' NOT NULL'
  else
    NotNull := '';

  case campo.Tipo of
    tpNull:
      tipoSQl := 'null';
    tpSMALLINT:
      tipoSQl := 'NUMBER(5,0)';
    tpINTEGER:
      tipoSQl := 'NUMBER(10,0)';
    tpBIGINT:
      tipoSQl := 'NUMBER(19)';
    tpDECIMAL:
      tipoSQl := Format('NUMBER(%d,%d)', [campo.Tamanho, campo.Precisao]);
    tpNUMERIC:
      tipoSQl := Format('NUMERIC(%d,%d)', [campo.Tamanho, campo.Precisao]);
    tpFLOAT:
      tipoSQl := 'BINARY_FLOAT';
    tpDOUBLE:
      tipoSQl := 'BINARY_DOUBLE';
    tpDATE:
      tipoSQl := 'TIMESTAMP';
    tpTIME:
      tipoSQl := 'TIMESTAMP';
    tpTIMESTAMP:
      tipoSQl := 'TIMESTAMP';
    tpCHAR:
      tipoSQl := Format('CHAR(%d)', [campo.Tamanho]);
    tpVARCHAR:
      begin
        maxTam := TUtil.IFF<Integer>(campo.Tamanho > 4000, campo.Tamanho, 4000);
        tipoSQl := Format('VARCHAR(%d)', [maxTam]);
      end;
    tpBLOB:
      tipoSQl := Format('BLOB(%d)', [campo.Tamanho]);
    tpBIT:
      tipoSQl := 'NUMBER(1)';
    tpXML:
      tipoSQl := 'CLOB';
  else
    raise Exception.Create('TTabelaOracle: Campo não mapeado');

  end;

  result := Format(' %s %s %s %s', [campo.campo, tipoSQl, default, NotNull]);
end;

function TTabelaOracle.FkToSql(fk: ForeignKeyAttribute): string;
var
  ruleDelete: string;
  ruleUpdate: string;
begin

  case fk.ruleDelete of
    None:
      ruleDelete := ' ';
    Cascade:
      ruleDelete := 'ON DELETE CASCADE';
    SetNull:
      ruleDelete := 'ON DELETE SET NULL';
    SetDefault:
      ruleDelete := 'ON DELETE SET DEFAULT';
  end;



  // case fk.ruleUpdate of
  // None:
  // ruleUpdate := 'NO ACTION';
  // Cascade:
  // ruleUpdate := 'CASCADE';
  // SetNull:
  // ruleUpdate := 'SET NULL';
  // SetDefault:
  // ruleUpdate := 'SET DEFAULT';
  // end;
  //
  // ruleUpdate := ' ON UPDATE ' + ruleUpdate;

  result := Format(' %s FOREIGN KEY (%s) REFERENCES %s (%S) %s  ',
    [fk.Name, fk.Columns, fk.ReferenceTableName, fk.ReferenceFieldName,
    ruleDelete
    ]);
end;

function TTabelaOracle.toScript: TStringList;
var
  sql: string;
  campo: CampoAttribute;
  pk: PrimaryKeyAttribute;
  fk: ForeignKeyAttribute;
begin
  result := TStringList.Create;

  // Firebird não permite criar tabela sem campos,
  // então se não houver campos para criar a tabela, sai
  if Self.Campos.Count = 0 then
    Exit;

  campo := Self.Campos[0];
  sql := Format(
    'DECLARE '
    + '    ncount NUMBER; '
    + '    v_sql  LONG; '
    + 'BEGIN '
    + '    SELECT Count(*) '
    + '    INTO   ncount '
    + '    FROM   dba_tables '
    + '    WHERE  table_name = ''%s''; '
    + ' '
    + '    IF( ncount <= 0 ) THEN '
    + '      v_sql := '' create table %s ( %s )''; '
    + ' '
    + '      EXECUTE IMMEDIATE v_sql; '
    + '    END IF; '
    + 'END; '
    , [Self.Tabela.Tabela,
    Self.Tabela.Tabela, CampoToSql(campo)]);

  result.Add(UpperCase(sql));

  result.Add(UpperCase(sql));

  for campo in Self.Campos do
  begin

    sql := Format(
      'DECLARE '
      + '  v_column_exists number := 0; '
      + 'BEGIN '
      + '  Select count(*) into v_column_exists '
      + '    from user_tab_cols '
      + '    where column_name = ''%s'' '
      + '      and table_name = ''%s''; '
      + ' '
      + '  if (v_column_exists = 0) then '
      + '      execute immediate ''alter table %s add (%s)''; '
      + '  end if; '
      + 'end;'
      , [
      campo.campo,
      Self.Tabela.Tabela,
      Self.Tabela.Tabela,
      CampoToSql(campo)]);

    result.Add(UpperCase(sql));
  end;

  for pk in Self.Pks do
  begin

    sql := Format(
      'DECLARE '
      + '  v_pk_exists number := 0; '
      + 'BEGIN '
      + '  SELECT count(*) into v_pk_exists '
      + '  FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME = ''%s''  AND CONSTRAINT_TYPE = ''P''   ; '
      + ' '
      + '  if (v_pk_exists = 0) then '
      + '      execute immediate ''ALTER TABLE %s ADD CONSTRAINT %s PRIMARY KEY (%s)''; '
      + '  end if; '
      + 'end;'
      , [pk.Name, Self.Tabela.Tabela, pk.Name, pk.CatColumns]);

    result.Add(UpperCase(sql));
  end;

  for fk in Self.Fks do
  begin

    sql := Format(
      'DECLARE '
      + '  v_pk_exists number := 0; '
      + 'BEGIN '
      + '  SELECT count(*) into v_pk_exists '
      + '  FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME = ''%s''  AND CONSTRAINT_TYPE = ''R''   ; '
      + ' '
      + '  if (v_pk_exists = 0) then '
      + '      execute immediate ''ALTER TABLE %s ADD CONSTRAINT %s ''; '
      + '  end if; '
      + 'end;'
      , [fk.Name, Self.Tabela.Tabela, FkToSql(fk)]);

    result.Add(UpperCase(sql));
  end;
end;

end.
