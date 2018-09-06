unit Licenca.Abstract.Validador;

interface

type
  ILicencaValidador = interface
    ['{F8F7FA4D-CB44-4019-9D70-A6372C430ACB}']

    function CarregaLicenca(aPathArquivo: string): ILicencaValidador;
    function Processa: ILicencaValidador;
    function Configura(aAppOrigem: string; aChave: string; aCampo: string; aDataHoje: TDate; aArquivoUltimoAcesso: string): ILicencaValidador;
    function VerificaDataDoSOMenorQueAplicacao: ILicencaValidador;
    function VerificaDataDoSOMenorQueUltimoAcesso: ILicencaValidador;
    function VerificaLicencaVencida: ILicencaValidador;
    function RetornaDiasRestantes: Integer;

  end;

implementation

end.
