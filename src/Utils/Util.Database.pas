unit Util.Database;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Log.Ilog,
  System.RegularExpressions;

type
  TUtilDatabase = class
  private
    class function ProcessSelectStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
    class function ProcessInsertStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
    class function ProcessUpdateStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
    class function ProcessDeleteStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
  public
    /// <summary>
    /// Adiciona o schema nas tabelas do SQL
    /// Suporta SELECT, INSERT, UPDATE e DELETE
    /// </summary>
    /// <param name="ASQL">SQL a ser processado</param>
    /// <param name="ASchema">Schema a ser adicionado (ex: 'dbo' para SQL Server, '' para Oracle). Se vazio, detecta automaticamente</param>
    /// <returns>SQL com schema adicionado</returns>
    class function AddSchema(const ASQL: string; const ASchema: string; aLog: Ilog): string;
  end;

implementation


{ TUtilDatabase }

class function TUtilDatabase.AddSchema(const ASQL: string; const ASchema: string; aLog: Ilog): string;
var
  LSQL: string;
  LSchemaPrefix: string;
begin
  aLog.d('>>> Entrando em TUtilDatabase.AddSchema');
  aLog.d('Schema: ' + ASchema);
  aLog.d('SQL Original: ' + ASQL);

  LSQL := Trim(ASQL);
  // Se não tem schema configurado, retorna como está
  if ASchema = '' then
  begin
    aLog.d('Schema vazio, retornando SQL original');
    Result := ASQL;
    aLog.d('<<< Saindo de TUtilDatabase.AddSchema');
    Exit;
  end;

  // Se já tem schema qualificado, retorna como está
  if (Pos('.', LSQL) > 0) and (Pos(' ', Copy(LSQL, 1, Pos('.', LSQL))) = 0) then
  begin
    aLog.d('SQL já possui schema qualificado, retornando SQL original');
    Result := ASQL;
    aLog.d('<<< Saindo de TUtilDatabase.AddSchema');
    Exit;
  end;

  LSchemaPrefix := ASchema + '.';
  aLog.d('Schema Prefix: ' + LSchemaPrefix);

  // Detecta o tipo de comando e processa adequadamente
  if StartsText('SELECT', LSQL) then
  begin
    aLog.d('Processando SELECT');
    Result := ProcessSelectStatement(LSQL, LSchemaPrefix, aLog);
  end
  else if StartsText('INSERT', LSQL) then
  begin
    aLog.d('Processando INSERT');
    Result := ProcessInsertStatement(LSQL, LSchemaPrefix, aLog);
  end
  else if StartsText('UPDATE', LSQL) then
  begin
    aLog.d('Processando UPDATE');
    Result := ProcessUpdateStatement(LSQL, LSchemaPrefix, aLog);
  end
  else if StartsText('DELETE', LSQL) then
  begin
    aLog.d('Processando DELETE');
    Result := ProcessDeleteStatement(LSQL, LSchemaPrefix, aLog);
  end
  else
  begin
    aLog.d('Comando não reconhecido, retornando SQL original');
    Result := ASQL; // Retorna sem alteração se não for comando conhecido
  end;

  aLog.d('SQL Processado: ' + Result);
  aLog.d('<<< Saindo de TUtilDatabase.AddSchema');
end;

class function TUtilDatabase.ProcessSelectStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
var
  LPattern: string;
  LRegex: TRegEx;
  LMatch: TMatch;
  LResult: string;
  LTableNames: TStringList;
  I: Integer;
  LTableName: string;
begin
  aLog.d('>>> Entrando em TUtilDatabase.ProcessSelectStatement');
  LResult := ASQL;

  // Padrão para capturar nomes de tabelas após FROM e JOIN
  // Ignora subconsultas e já qualificados com schema
  LPattern := '\b(FROM|JOIN)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*(?!\.)';

  LRegex := TRegEx.Create(LPattern, [roIgnoreCase, roMultiline]);
  LTableNames := TStringList.Create;
  try
    LTableNames.Duplicates := dupIgnore;
    LTableNames.Sorted := True;

    // Primeiro, identifica todas as tabelas
    LMatch := LRegex.Match(ASQL);
    while LMatch.Success do
    begin
      LTableName := Trim(LMatch.Groups[2].Value);
      // Ignora palavras reservadas e aliases comuns
      if not SameText(LTableName, 'NOLOCK') and
        not SameText(LTableName, 'WITH') and
        not SameText(LTableName, 'INNER') and
        not SameText(LTableName, 'LEFT') and
        not SameText(LTableName, 'RIGHT') and
        not SameText(LTableName, 'OUTER') and
        not SameText(LTableName, 'FULL') then
      begin
        LTableNames.Add(LTableName);
      end;
      LMatch := LMatch.NextMatch;
    end;

    // Agora substitui cada tabela pelo schema.tabela
    aLog.d('Tabelas identificadas: ' + LTableNames.CommaText);
    for I := 0 to LTableNames.Count - 1 do
    begin
      LTableName := LTableNames[I];
      aLog.d('Adicionando schema em: ' + LTableName);
      // Substitui usando word boundary para não afetar nomes parciais
      LPattern := '\b(FROM|JOIN)\s+(' + LTableName + ')\b';
      LRegex := TRegEx.Create(LPattern, [roIgnoreCase, roMultiline]);
      LResult := LRegex.Replace(LResult, '$1 ' + aSchemaPrefix + '$2');
    end;
  finally
    LTableNames.Free;
  end;

  Result := LResult;
  aLog.d('<<< Saindo de TUtilDatabase.ProcessSelectStatement');
end;

class function TUtilDatabase.ProcessInsertStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
var
  LPattern: string;
  LRegex: TRegEx;
begin
  aLog.d('>>> Entrando em TUtilDatabase.ProcessInsertStatement');

  // Padrão: INSERT INTO tabela
  LPattern := '\bINSERT\s+INTO\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*(?!\.';
  LRegex := TRegEx.Create(LPattern, [roIgnoreCase]);

  Result := LRegex.Replace(ASQL, 'INSERT INTO ' + aSchemaPrefix + '$1 ');
  aLog.d('<<< Saindo de TUtilDatabase.ProcessInsertStatement');
end;

class function TUtilDatabase.ProcessUpdateStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
var
  LPattern: string;
  LRegex: TRegEx;
begin
  aLog.d('>>> Entrando em TUtilDatabase.ProcessUpdateStatement');

  // Padrão: UPDATE tabela SET ou UPDATE TOP (n) tabela SET
  LPattern := '\bUPDATE(\s+TOP\s*\(\s*\d+\s*\))?\s+([a-zA-Z_][a-zA-Z0-9_]*)\s+(?!\.';
  LRegex := TRegEx.Create(LPattern, [roIgnoreCase]);

  Result := LRegex.Replace(ASQL, 'UPDATE$1 ' + aSchemaPrefix + '$2 ');
  aLog.d('<<< Saindo de TUtilDatabase.ProcessUpdateStatement');
end;

class function TUtilDatabase.ProcessDeleteStatement(const ASQL: string; aSchemaPrefix: string; aLog: Ilog): string;
var
  LPattern: string;
  LRegex: TRegEx;
begin
  aLog.d('>>> Entrando em TUtilDatabase.ProcessDeleteStatement');

  // Padrão: DELETE FROM tabela
  LPattern := '\bDELETE\s+FROM\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*(?!\.';
  LRegex := TRegEx.Create(LPattern, [roIgnoreCase]);

  Result := LRegex.Replace(ASQL, 'DELETE FROM ' + aSchemaPrefix + '$1 ');
  aLog.d('<<< Saindo de TUtilDatabase.ProcessDeleteStatement');
end;

end.