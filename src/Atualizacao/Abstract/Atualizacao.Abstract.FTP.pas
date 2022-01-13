unit Atualizacao.Abstract.FTP;

interface

type

  IAtualizacaoObserve = interface
    ['{079DEEEC-28D4-4FC7-9BE2-77A9CBBC8948}']
    [weak]
    procedure OnUpdateProgress(const aStatus: String; const aProgress: Integer);
  end;

  TOnUpdate = reference to procedure(const aStatus: String; const aProgress: Integer);
  TOnNotifyObservers = reference to procedure(aStatus: string; const aProgress: Integer);

  IAtualizacaoObservable = interface
    ['{82FD4425-47B6-4DF0-8E90-20999AF45C08}']
    procedure addObserver(obs: IAtualizacaoObserve);
    procedure removeObserver(obs: IAtualizacaoObserve);
    procedure NotifyObservers(aStatus: string; const aProgress: Integer);

    function getTOnUpdate: TOnUpdate;
    procedure setTOnUpdate(aValue: TOnUpdate);
    property OnUpdate: TOnUpdate read getTOnUpdate write setTOnUpdate;

    function getTOnNotifyObservers: TOnNotifyObservers;
    procedure setTOnNotifyObservers(aValue: TOnNotifyObservers);
    property OnNotifyObservers: TOnNotifyObservers read getTOnNotifyObservers write setTOnNotifyObservers;
  end;

  IAtualizacaoFTP = interface(IAtualizacaoObservable)
    ['{78097FC3-D203-4A83-8249-FADAE0A9FFA2}']
    function SetUpHOST(aHost: string; aUsername: string; aPassword: string; aPorta: Integer): IAtualizacaoFTP;
      overload;

    function SetUpClient(aDiretorioFTP: string; aArquivoVersaoFTP: string; aNomeExe: string; aVersaoExeLocal: string): IAtualizacaoFTP; overload;
    function ChecaNovaVersaoDisponivel: boolean;
    procedure Atualizar;
  end;

implementation

end.
