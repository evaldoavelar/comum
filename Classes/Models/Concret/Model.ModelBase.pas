unit Model.ModelBase;

interface

uses System.Classes,
  System.Rtti,
  System.Generics.Collections,
  System.SysUtils,
  Data.DBXJSONReflect,
  System.JSON,
  System.Bindings.Expression,
  System.Bindings.Helper,
  Model.IModelBase,
  Model.IObserve,
  Model.IObservable,
  Model.Atributos,
  Model.Atributos.Tipos,
  Model.IPrototype, System.TypInfo,
  Model.Atributos.Funcoes,
  Utils.Rtti,
  JSON.Atributes,
  JSON.Utils;

type

  TModelBase = class(TInterfacedObject, IModelBase, IObservable, IModelPrototype<IModelBase>)
  protected
    type
    TExpressionList = TObjectList<TBindingExpression>;
  public
    type
    TStatusBD = (stNenhum, stCriar, stDeletado, stAtualizar, stAdicionado);

  private
    FObserves: TList<IModelObserve>;

    [JSONMarshalled(false)]
    FBindings: TExpressionList;

    [JSONMarshalled(false)]
    FStatusBD: TStatusBD;

    procedure SetStatusBD(const Value: TStatusBD);
  protected
    procedure NotifyBinding(const APropertyName: string);

  public
    [JSONFieldIgnoreAttribute()]
    property StatusBD: TStatusBD read FStatusBD write SetStatusBD;
    procedure Clean(); virtual;

    procedure Bind(const AProperty: string; const ABindToObject: TObject;
      const ABindToProperty: string; const ACreateOptions:
      TBindings.TCreateOptions = [coNotifyOutput, coEvaluate]);
    procedure BindReadOnly(const AProperty: string; const ABindToObject: TObject;
      const ABindToProperty: string; const ACreateOptions:
      TBindings.TCreateOptions = [coNotifyOutput, coEvaluate]);
    procedure ClearBindings;

    procedure addObserver(obs: IModelObserve);
    procedure removeObserver(obs: IModelObserve);
    procedure NotifyObservers;

    function Prototype: IModelPrototype<IModelBase>;
    function Clone: IModelBase; virtual;

    procedure LoadFromJson(aJson: string); virtual;
    function ToJson(): TJSonObject;

    function New: IModelBase; virtual;
    function AsType: TValue;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

{ TModelBase }

function TModelBase.New: IModelBase;
begin
  result := TRttiUtil.CreateInstance<TModelBase>(Self.ClassType, []);
end;

procedure TModelBase.NotifyBinding(const APropertyName: string);
begin
  TBindings.Notify(Self, APropertyName);
end;

[Weak]
procedure TModelBase.addObserver(obs: IModelObserve);
begin
  FObserves.add(obs);
end;

constructor TModelBase.Create;
begin
  FObserves := TList<IModelObserve>.Create;
  FBindings := TExpressionList.Create(false { AOwnsObjects } );
end;

destructor TModelBase.Destroy;
begin
  if Assigned(FObserves) then
  begin
    FObserves.Clear;
    FreeAndNil(FObserves);
  end;
  ClearBindings;
  if Assigned(FBindings) then
    FreeAndNil(FBindings);
  inherited;
end;

procedure TModelBase.LoadFromJson(aJson: string);
begin
  TJSONUtil.FromJSON(aJson, Self);
end;

procedure TModelBase.Clean;
begin
  TRttiUtil.Initialize<TModelBase>(Self);
end;

procedure TModelBase.NotifyObservers;
var
  i: Integer;
begin
  for i := 0 to Pred(FObserves.Count) do
  begin
    try
      FObserves[i].Update(Self);
    except
    end;
  end;
end;

function TModelBase.Prototype: IModelPrototype<IModelBase>;
begin
  result := Self;
end;

procedure TModelBase.removeObserver(obs: IModelObserve);
begin
  if (FObserves.IndexOf(obs)) >= 0 then
    FObserves.remove(obs);
end;

procedure TModelBase.SetStatusBD(const Value: TStatusBD);
begin
  FStatusBD := Value;
end;

function TModelBase.ToJson: TJSonObject;
begin
  result := TJSONUtil.ToJson(Self);
end;

function TModelBase.Clone: IModelBase;
var
  Model: IModelBase;
begin
  // Model := Self.New as TModelBase;

  Model := TRttiUtil.Clone<TModelBase>(Self);

  result := Model;
end;

function TModelBase.AsType: TValue;
begin
  result := Self;
end;

procedure TModelBase.Bind(const AProperty: string; const ABindToObject: TObject; const ABindToProperty: string; const ACreateOptions: TBindings.TCreateOptions);
begin
  // From source to dest
  FBindings.add(TBindings.CreateManagedBinding(
    { inputs }
    [TBindings.CreateAssociationScope([Associate(Self, 'src')])],
    'src.' + AProperty,
    { outputs }
    [TBindings.CreateAssociationScope([Associate(ABindToObject, 'dst')])],
    'dst.' + ABindToProperty,
    nil, nil, ACreateOptions));
  // From dest to source
  FBindings.add(TBindings.CreateManagedBinding(
    { inputs }
    [TBindings.CreateAssociationScope([Associate(ABindToObject, 'src')])],
    'src.' + ABindToProperty,
    { outputs }
    [TBindings.CreateAssociationScope([Associate(Self, 'dst')])],
    'dst.' + AProperty,
    nil, nil, ACreateOptions));
end;

procedure TModelBase.BindReadOnly(const AProperty: string;
  const ABindToObject: TObject; const ABindToProperty: string;
  const ACreateOptions: TBindings.TCreateOptions);
begin
  // From source to dest
  FBindings.add(TBindings.CreateManagedBinding(
    { inputs }
    [TBindings.CreateAssociationScope([Associate(Self, 'src')])],
    'src.' + AProperty,
    { outputs }
    [TBindings.CreateAssociationScope([Associate(ABindToObject, 'dst')])],
    'dst.' + ABindToProperty,
    nil, nil, ACreateOptions));
end;

procedure TModelBase.ClearBindings;
var
  i: TBindingExpression;
begin
  if Assigned(FBindings) then
  begin
    for i in FBindings do
      TBindings.RemoveBinding(i);

    FBindings.Clear;
  end;
end;

end.
