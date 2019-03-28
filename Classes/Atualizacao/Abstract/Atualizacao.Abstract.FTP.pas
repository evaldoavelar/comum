unit Atualizacao.Abstract.FTP;

interface

type

  IAtualizacaoObserve = interface
    ['{079DEEEC-28D4-4FC7-9BE2-77A9CBBC8948}']
    [weak]
    procedure OnUpdate(const aStatus: String; const aProgress: Integer);
  end;

  IAtualizacaoObservable = interface
    ['{82FD4425-47B6-4DF0-8E90-20999AF45C08}']
    procedure addObserver(obs: IAtualizacaoObserve);
    procedure removeObserver(obs: IAtualizacaoObserve);
    procedure NotifyObservers(aStatus: string; const aProgress: Integer);
  end;


  IAtualizacaoFTP = interface
    ['{78097FC3-D203-4A83-8249-FADAE0A9FFA2}']
    function SetUpHOST(aHost: string; aUsername: string; aPassword: string; aPorta: Integer): IAtualizacaoFTP; overload;
    function SetUpClient(aDiretorioFTP: string; aArquivoVersaoFTP: string; aNomeExe: string; aVersaoExeLocal: string): IAtualizacaoFTP; overload;
    function ChecaNovaVersaoDisponivel: boolean;
    procedure Atualizar;
  end;

implementation

end.
