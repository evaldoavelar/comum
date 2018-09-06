unit Test.Model.Observer;

interface

uses Model.IObserve, Model.IModelBase, Model.ModelBase;

type

  TModelObserver = class(TInterfacedObject, IModelObserve)
  private
    FNotificado: boolean;
    function getNofiticado: boolean;
    procedure setNotificado(const Value: boolean);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    procedure clear;
    property Notificado: boolean read getNofiticado write setNotificado;
    procedure Update(const ModelBase: IModelBase);
  end;

implementation

{ TModelObserver }

procedure TModelObserver.clear;
begin
  FNotificado := False;
end;

function TModelObserver.getNofiticado: boolean;
begin
  result := FNotificado;
end;

procedure TModelObserver.setNotificado(const Value: boolean);
begin
  FNotificado := Value;
end;

procedure TModelObserver.Update(const ModelBase: IModelBase);
begin
  TModelBase(ModelBase).StatusBD := stCriar;
  FNotificado := True;
end;

end.
