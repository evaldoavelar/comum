unit Dao.ResultAdapter;

interface

uses
  Data.DB, MidasLib,
  Datasnap.DBClient,
  System.Generics.Collections,
  Dao.IResultAdapter, Dao.DataSet;

type
  TDaoResultAdapter<T: class> = class(TInterfacedObject, IDaoResultAdapter<T>)
  private
    FDataSet: TDataSet;
    FFreeDataSet: boolean;
  public
    function AsDataset(): TDataSet;
    function AsClientDataset(): TClientDataSet;
    function AsList(): TList<T>;
    function AsObject(): T;
    function AsTField(Index: integer): TField;
  public
    constructor Create(aDataSet: TDataSet);
    destructor Destroy; override;
    class function New(aDataSet: TDataSet): IDaoResultAdapter<T>;
  end;

implementation

uses
  Utils.Rtti;

{ TClasseBase }

{ TDaoResultAdapter<T> }

function TDaoResultAdapter<T>.AsClientDataset(): TClientDataSet;
var
  I: integer;
begin
  Result := TClientDataSet.Create(nil);
  Result.Close;
  Result.FieldDefs.Clear;

  for I := 0 to FDataSet.FieldCount - 1 do
  begin
    Result.FieldDefs.Add(FDataSet.Fields[I].FieldName,
      FDataSet.Fields[I].DataType,
      FDataSet.Fields[I].Size,
      FDataSet.Fields[I].Required);
  end;

  Result.CreateDataSet;
  Result.Open;

  FDataSet.First;

  while not FDataSet.Eof do
  begin
    Result.Append;

    for I := 0 to FDataSet.FieldCount - 1 do
    begin
      Result.FieldByName(FDataSet.Fields[I].FieldName).Value := FDataSet.Fields[I].Value;
    end;

    Result.Post;
    FDataSet.Next;
  end;

end;

function TDaoResultAdapter<T>.AsDataset(): TDataSet;
begin
  FFreeDataSet := false;
  Result := FDataSet;
end;

function TDaoResultAdapter<T>.AsList(): TList<T>;
var
  Model: T;
begin
  while not FDataSet.Eof do
  begin
    Model := TDaoDataSet<T>.New.DataSetToObject(FDataSet);
    Result.Add(Model);
    FDataSet.Next;
  end;
end;

function TDaoResultAdapter<T>.AsObject(): T;
begin
  TDaoDataSet<T>.New.DataSetToObject(FDataSet);
end;

function TDaoResultAdapter<T>.AsTField(Index: integer): TField;
begin
 result := FDataSet.Fields[index];
end;

constructor TDaoResultAdapter<T>.Create(aDataSet: TDataSet);
begin
  FDataSet := aDataSet;
  FFreeDataSet := true;
end;

destructor TDaoResultAdapter<T>.Destroy;
begin
  if FFreeDataSet then
    FDataSet.Free;
  inherited;
end;

class function TDaoResultAdapter<T>.New(
  aDataSet: TDataSet): IDaoResultAdapter<T>;
begin
  Result := TDaoResultAdapter<T>.Create(aDataSet);
end;

end.
