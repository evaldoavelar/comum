unit Utils.Mobile;

interface


uses
  System.Classes,
{$IFDEF ANDROID}
  Androidapi.JNI.Os,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.JNI.Widget,
  FMX.Helpers.Android,
{$ENDIF}
  FMX.types,
  FMX.VirtualKeyboard,
  FMX.PlatForm;

type

  TMobileUtils = class
  public
{$IFDEF ANDROID}
    class procedure ShowMessageToast(const pMsg: String; pDuration: Integer); static;
    class procedure Vibrate(aTime: Int64); static;

{$ENDIF}
    class procedure HideKeyVirtualBoard();
    class procedure ShowKeyVirtualBoard(const AControl: TFmxObject);
    class function Mascara(edt: String; str: String): string;
  end;

implementation

{ TMobileUtils }
{$IFDEF ANDROID}


class procedure TMobileUtils.Vibrate(aTime: Int64);
Var
  Vibrator: JVibrator;
begin
{$IFDEF ANDROID}
  Vibrator := TJVibrator.Wrap((SharedActivityContext.getSystemService(TJContext.JavaClass.VIBRATOR_SERVICE) as ILocalObject).GetObjectID);
  // Vibrate for 500 milliseconds
  Vibrator.Vibrate(aTime);
{$ENDIF}
{$IFDEF IOS}
  AudioServicesPlaySystemSound(kSystemSoundID_vibrate);
{$ENDIF}

end;

class procedure TMobileUtils.ShowMessageToast(const pMsg: String; pDuration:
  Integer);
begin
  CallInUiThread(
    procedure
    begin
      TJToast.JavaClass.makeText(SharedActivityContext,
        StrToJCharSequence(pMsg), pDuration).show
    end
    );
  // TJToast.JavaClass.makeText(TAndroidHelper.Context, StrToJCharSequence(pMsg), pDuration).show
  // TThread.Synchronize(nil,
  // procedure
  // begin
  // TJToast.JavaClass.makeText(TAndroidHelper.Context,
  // StrToJCharSequence(pMsg), pDuration).show
  // end);
end;
{$ENDIF}

{ TMobileUtils }

class procedure TMobileUtils.HideKeyVirtualBoard;
var
  FService: IFMXVirtualKeyboardService;
begin
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
  if (FService <> nil) { and (vksVisible in FService.VirtualKeyBoardState) } then
  begin
    FService.HideVirtualKeyboard;
  end;
end;

class function TMobileUtils.Mascara(edt: String; str: String): string;
var
  i: Integer;
begin
  for i := 1 to Length(edt) do
  begin
    if (str[i] = '9') and not(edt[i] in ['0' .. '9']) and (Length(edt) = Length(str) + 1) then
      delete(edt, i, 1);
    if (str[i] <> '9') and (edt[i] in ['0' .. '9']) then
      insert(str[i], edt, i);
  end;
  result := edt;
end;

class procedure TMobileUtils.ShowKeyVirtualBoard(const AControl: TFmxObject);
var
  FService: IFMXVirtualKeyboardService;
begin
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
  if (FService <> nil) { and (vksVisible in FService.VirtualKeyBoardState) } then
  begin
    FService.ShowVirtualKeyboard(AControl);
  end;

end;

end.
