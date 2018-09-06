unit Log.TTipoLog;

interface


type
  TTipoLog = (Custom, Info, Debug, Erro);

  TTipoLogHelp = record helper for TTipoLog
    function ToString: string;
  end;

implementation

{ TTipoLogHelp }

function TTipoLogHelp.ToString: string;
begin
  case Self of
    Custom:
      result := 'custom';
    Info:
      result := 'info';
    Debug:
      result := 'debug';
    Erro:
      result := 'erro'
  end;
end;

end.
