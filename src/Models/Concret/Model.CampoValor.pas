unit Model.CampoValor;

interface

uses system.Generics.Collections,
  Types.Nullable;

type
  TModelCampoValor = class
  private
    FField: string;
    FVType: TVarType;
    FValue: variant;
    procedure SetField(const Value: string);
    procedure SetValue(const Value: variant);
    procedure SetVType(const Value: TVarType);
  public
    property Field: string read FField write SetField;
    property Value: variant read FValue write SetValue;
    property vType: TVarType read FVType write SetVType;

    constructor Create(aField: string; aValue: variant; aType: TVarType); overload;
    constructor Create(); overload;
    class function New<T>(aField: string; aValue: TNullable<T>; aType: TVarType): TModelCampoValor;
  end;

  TListaModelCampoValor = class
  private
    FItems: TObjectList<TModelCampoValor>;
    Index: Integer;
    function GetCount: Integer;
    function GetItem(aField: string): TModelCampoValor;
    procedure SetItem(aField: string;
      const Value: TModelCampoValor);

  public
    property Count: Integer read GetCount;
    property Items[aField: string]: TModelCampoValor read GetItem write SetItem; default;

    procedure Add(const Item: TModelCampoValor);
    procedure Add(aField: string; aValue: variant);
    procedure Remove(const Item: TModelCampoValor);
    procedure Clear;
    function ContainsKey(aKey: string): Boolean;
    function Keys: TArray<string>;
    function IndexOf(aKey: string): Integer;

  public
    constructor Create;
    destructor destroy; override;

  end;

implementation

uses Helpers.HelperString, Utils.ArrayUtil, Exceptions, system.Rtti,
  system.Variants;

{ TModelCampoValor }

constructor TModelCampoValor.Create(aField: string; aValue: variant; aType: TVarType);
begin
  inherited Create;
  Field := aField;
  Value := aValue;
  vType := aType;
end;

constructor TModelCampoValor.Create;
begin

end;

class function TModelCampoValor.New<T>(aField: string; aValue: TNullable<T>;
  aType: TVarType): TModelCampoValor;
begin
  result := TModelCampoValor.Create();
  result.Field := aField;
  result.vType := aType;
  result.Value := null;

  if aValue.HasValue then
    result.Value := aValue.ToTValue;

end;

procedure TModelCampoValor.SetField(const Value: string);
begin
  FField := Value;
end;

procedure TModelCampoValor.SetValue(const Value: variant);
begin
  FValue := Value;
end;

procedure TModelCampoValor.SetVType(const Value: TVarType);
begin
  FVType := Value;
end;

{ TListaModelCampoValor }

procedure TListaModelCampoValor.Add(const Item: TModelCampoValor);
begin
  if ContainsKey(Item.FField) then
    raise TValidacaoException.Create('Campo já incluso!');

  FItems.Add(Item);
end;

procedure TListaModelCampoValor.Add(aField: string; aValue: variant);
begin
  if ContainsKey(aField) then
    raise TValidacaoException.Create('Campo já incluso!');

  FItems.Add(TModelCampoValor.Create(aField, aValue, VarType(aValue)));
end;

procedure TListaModelCampoValor.Clear;
begin
  FItems.Clear;
end;

function TListaModelCampoValor.ContainsKey(aKey: string): Boolean;
var
  LItem: TModelCampoValor;
begin
  result := false;
  for LItem in FItems do
  begin
    if LItem.Field.toUpper = aKey.toUpper then
    begin
      result := true;
      break;
    end;
  end;
end;

constructor TListaModelCampoValor.Create;
begin
  FItems := TObjectList<TModelCampoValor>.Create();
end;

destructor TListaModelCampoValor.destroy;
begin
  FItems.free;
  inherited;
end;

function TListaModelCampoValor.GetCount: Integer;
begin
  result := FItems.Count;
end;

function TListaModelCampoValor.GetItem(aField: string): TModelCampoValor;
begin

  result := FItems[IndexOf(aField)]
end;

function TListaModelCampoValor.IndexOf(aKey: string): Integer;
var
  I: Integer;
begin
  result := -1;
  for I := 0 to FItems.Count - 1 do
    if FItems[I].Field.toUpper = aKey.toUpper then
    begin
      result := I;
      break;
    end;
end;

function TListaModelCampoValor.Keys: TArray<string>;
var
  LItem: TModelCampoValor;
begin
  for LItem in FItems do
  begin
    TArrayUtil<string>.Append(result, LItem.Field);
  end;
end;

procedure TListaModelCampoValor.Remove(const Item: TModelCampoValor);
begin
  FItems.Remove(Item);
end;

procedure TListaModelCampoValor.SetItem(aField: string;
  const Value: TModelCampoValor);

begin
  FItems[IndexOf(aField)] := Value;
end;

end.
