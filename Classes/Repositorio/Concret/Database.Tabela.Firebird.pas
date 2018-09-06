unit Database.Tabela.Firebird;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Collections,
  System.Rtti,
  Database.IDataseMigration,
  Database.TTabelaBD, Model.Atributos, Model.Atributos.Tipos;

type

  TTabelaBDFB = Class(TTabelaBD)
  private
    function CampoToSql(campo: CampoAttribute): string;
    function FkToSql(fk: ForeignKeyAttribute): string;
  public
    function toScript(): TStringList; override;
  End;

  { TDataseMigrationFB }

implementation


{ TTabelaBDFB }

function TTabelaBDFB.CampoToSql(campo: CampoAttribute): string;
var
  default: string;
  NotNull: string;
  tipoSQl: string;
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
      tipoSQl := 'SMALLINT';
    tpINTEGER:
      tipoSQl := 'INTEGER';
    tpBIGINT:
      tipoSQl := 'BIGINT';
    tpDECIMAL:
      tipoSQl := Format('DECIMAL(%d,%d)', [campo.Tamanho, campo.Precisao]);
    tpNUMERIC:
      tipoSQl := Format('NUMERIC(%d,%d)', [campo.Tamanho, campo.Precisao]);
    tpFLOAT:
      tipoSQl := 'FLOAT';
    tpDOUBLE:
      tipoSQl := 'DOUBLE';
    tpDATE:
      tipoSQl := 'DATE';
    tpTIME:
      tipoSQl := 'TIME';
    tpTIMESTAMP:
      tipoSQl := 'TIMESTAMP';
    tpCHAR:
      tipoSQl := Format('CHAR(%d)', [campo.Tamanho]);
    tpVARCHAR:
      tipoSQl := Format('VARCHAR(%d)', [campo.Tamanho]);
    tpBLOB:
      tipoSQl := Format('BLOB SUB_TYPE %d SEGMENT SIZE %d ', [campo.Tamanho, campo.Precisao]);
  end;

  result := Format(' %s %s %s %s', [campo.campo, tipoSQl, default, NotNull]);
end;

function TTabelaBDFB.FkToSql(fk: ForeignKeyAttribute): string;
var
  ruleDelete: string;
  ruleUpdate: string;
begin

  case fk.ruleDelete of
    None:
      ruleDelete := 'NO ACTION';
    Cascade:
      ruleDelete := 'CASCADE';
    SetNull:
      ruleDelete := 'SET NULL';
    SetDefault:
      ruleDelete := 'SET DEFAULT';
  end;

  ruleDelete := ' ON DELETE ' + ruleDelete;

  case fk.ruleUpdate of
    None:
      ruleUpdate := 'NO ACTION';
    Cascade:
      ruleUpdate := 'CASCADE';
    SetNull:
      ruleUpdate := 'SET NULL';
    SetDefault:
      ruleUpdate := 'SET DEFAULT';
  end;

  ruleUpdate := ' ON UPDATE ' + ruleUpdate;

  result := Format(' %s FOREIGN KEY (%s) REFERENCES %s (%S) %s %s ',
    [fk.Name, fk.Columns, fk.ReferenceTableName, fk.ReferenceFieldName,
    ruleDelete, ruleUpdate
    ]);
end;

function TTabelaBDFB.toScript: TStringList;
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
    'EXECUTE block ' +
    '  AS begin ' +
    ' if (not exists(select 1 from rdb$relations where rdb$relation_name = ''%s'')) then ' +
    ' execute statement ''create table %s ( %s );''; ' +
    ' end'
    , [Self.Tabela.Tabela,
    Self.Tabela.Tabela, CampoToSql(campo)]);

  result.Add(UpperCase(sql));

  for campo in Self.Campos do
  begin

    sql := Format(
      'EXECUTE block '
      + '  AS '
      + 'begin IF (NOT EXISTS '
      + '  ( '
      + '         SELECT 1 '
      + '         FROM   rdb$relation_fields rf '
      + '         WHERE  rf.rdb$relation_name = ''%s'' '
      + '         AND    rf.rdb$field_name = ''%s'')) then '
      + 'EXECUTE statement '
      + '    ''ALTER TABLE %s ADD %s '';'
      + ' end'
      , [Self.Tabela.Tabela, campo.campo,
      Self.Tabela.Tabela, CampoToSql(campo)]);

    result.Add(UpperCase(sql));
  end;

  for pk in Self.Pks do
  begin

    sql := Format(
      'EXECUTE block '
      + '  AS begin '
      + ' IF ( NOT EXISTS '
      + '  ( '
      + '         SELECT 0 '
      + '         FROM   rdb$relation_constraints '
      + '         WHERE  rdb$constraint_name = ''%s'')) then'
      + ' EXECUTE statement '
      + '    ''ALTER TABLE %s ADD CONSTRAINT %s PRIMARY KEY (%s)'';'
      + 'END'
      , [pk.Name, Self.Tabela.Tabela, pk.Name, pk.CatColumns]);

    result.Add(UpperCase(sql));
  end;

  for fk in Self.Fks do
  begin

    sql := Format(
      'EXECUTE block '
      + '  AS begin '
      + ' IF ( NOT EXISTS '
      + '  ( '
      + '         SELECT 0 '
      + '         FROM   rdb$relation_constraints '
      + '         WHERE  rdb$constraint_name = ''%s'')) then'
      + ' EXECUTE statement '
      + '    ''ALTER TABLE %s ADD CONSTRAINT %s '';'
      + 'END'
      , [fk.Name, Self.Tabela.Tabela, FkToSql(fk)]);

    result.Add(UpperCase(sql));
  end;
end;

end.
