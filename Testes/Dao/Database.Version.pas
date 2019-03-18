unit Database.Version;

interface

uses Database.IDataseMigration, Dao.IConection;

type

  TDatabaseVersion = class(TInterfacedObject, IDatabaseVersion)
  private
    FConection: IConection;
  public

    constructor Create(aConexao: IConection);
    procedure AtualizaVersaoBD(aVersao: string);
    function GetVersaoBD: string;
  end;

implementation

uses
  System.SysUtils, Data.DB;

{ TDatabaseVersion }

procedure TDatabaseVersion.AtualizaVersaoBD(aVersao: string);
var
  sql: TStringBuilder;
begin
  sql := TStringBuilder.Create;
  sql.Append('update ')
    .Append(' parametros  set versaobd = :versaobd  ');

 // FConection.ExecSQL(sql.ToString, [aVersao]);
end;

constructor TDatabaseVersion.Create(aConexao: IConection);
begin
  Self.FConection := aConexao;
end;

function TDatabaseVersion.GetVersaoBD: string;
//var
//  sql: TStringBuilder;
//  ds: TDataset;
begin
//  sql := TStringBuilder.Create;
//  sql.Append('select versaobd ')
//    .Append(' From parametros ');
//
//  ds := FConection.Open(sql.ToString);
//
//  if (ds.IsEmpty) then
//    result := '0.0.0.0'
//  else
//    result := ds.FieldByName('versaobd').AsString;
//
//  if (result.Trim.IsEmpty) then
//    result := '0.0.0.0';

     result := '0.0.0.0';

 // sql.Free;
 // ds.Free;
end;

end.
