unit Test.Model.TMOV;

interface

uses
  Model.ModelBase;

type

  TMOV = class(TModelBase)
  private
    FMODELOECFMD5: string;
    FCPFCNPJMD5: string;
    FINTEGRADOBONUM: integer;
    FCODCCUSTO: string;
    FPESOBRUTO: currency;
    FVALORDESC: currency;
    FVALORFRETE: currency;
    FCODRPR: string;
    FTBCLOG: string;
    FHORASAIDA: TDateTime;
    FUSUARIOCRIACAOMOV: string;
    FCODLAFE: string;
    FIDLOTEPROCESSO: integer;
    FCODCOLCFO: SmallInt;
    FSATMENSAGEMSEFAZ: string;
    FSERVICOFISCAL: string;
    FVALORDESPMD5: string;
    FDATARETORNO: TDateTime;
    FCODENTREGA: string;
    FCODLOCEXP: string;
    FDATAFECHAMENTO: TDateTime;
    FCODVEN4: string;
    FVALORBRUTO: currency;
    FSATNCFE: string;
    FSATSESSAO: integer;
    FSATRETORNO: string;
    FNFCSERIE: string;
    FDATAEMISSAOMD5: string;
    FSTATUSMD5: string;
    FPTOCFIDELIDADE: currency;
    FCRO: integer;
    FVINCULADOESTOQUEFL: integer;
    FOBSERVACAO: string;
    FCODLOCDESTINO: string;
    FSATCPFCNPJVALUE: string;
    FNFCXMLCANCELAMENTO: string;
    FTPNF: string;
    Ftroco: currency;
    FIDREDUCAOZ: integer;
    FPONTOVENDA: string;
    FVALORFRETECTRC: currency;
    FGEROUFATURA: SmallInt;
    FNUMEROTRIBUTOS: SmallInt;
    FSATEEEEE: integer;
    FNFCID: string;
    FNSEQDATAFECHAMENTO: SmallInt;
    FDATAPROGRAMACAO: TDateTime;
    FCODFILIALENTREGA: SmallInt;
    FSTATUSLIBERACAO: SmallInt;
    FFLAGEXPORFAZENDA: SmallInt;
    FIDMOVPEDDESDOBRADO: integer;
    FESPECIE: string;
    FNOMECLIENTE: string;
    FNFCTIPOEMISSAO: string;
    FPROTOCOLONFE: string;
    FCODGERENTE: string;
    FCODMUNSERVICO: string;
    FFLAGEXPORFISC: SmallInt;
    FEMITEBOLETA: string;
    FNUMEROLCTGERADO: SmallInt;
    FCODTB2FAT: string;
    FCODCPG: string;
    FCODTDO: string;
    FDATAENTREGA: TDateTime;
    FCODCOLCFONATUREZA: SmallInt;
    FCODTB3FAT: string;
    FCODMEN2: string;
    FNFCSTATUS: integer;
    FVALORLIQUIDOMD5: string;
    Fcentralizado: string;
    FEXPORTADOCANC: string;
    FFLAGEFEITOSALDO: SmallInt;
    FIDOBJOF: string;
    FFRETECIFOUFOB: SmallInt;
    FCODMOEVALORLIQUIDO: string;
    FCODCFOAUX: string;
    FCODTB1FAT: string;
    FMFADICIONAL: string;
    FNFEINTEGRADO: integer;
    FNFCNPROT: string;
    FNFCHAVE: string;
    FNUMEROCUPOMMD5: string;
    FSUBSERIE: string;
    FNUMERORECIBO: string;
    FVALORADIANTAMENTO: currency;
    FCODLOC: string;
    FNUMEROUSUARIO: string;
    FNROSERIE: string;
    FEXPORTADO: string;
    FAPROPRIADO: SmallInt;
    FTIPOCONSUMO: SmallInt;
    FCODMENFRETE: string;
    FCODETDPLACA: string;
    FSATCHAVECONSULTA: string;
    FCCFMD5: string;
    FEXPORTADOREDZ: string;
    FCHAPARESP: string;
    FCODMENDESPESA: string;
    FCODTB4FAT: string;
    FPERCENTUALSEGURO: currency;
    FSATCHAVECANCELAMENTO: string;
    FSATSERIAL: string;
    FIDMOVDESTINO: integer;
    FSATXMLCANCELAMENTO: string;
    FCODMOELANCAMENTO: string;
    FCODLOTE: integer;
    FCODDEPARTAMENTO: string;
    FCODCOLCXA: string;
    FCODTB5FAT: string;
    FPERCENTUALDESP: currency;
    FCOMISSAOREPRES: currency;
    FSERIE: string;
    FORDEMAPLICACAO: string;
    FNFCVERSAOAPLICACAO: string;
    FNOTAMANUAL: string;
    FSTATUSNFE: string;
    FSTATUSEXPORTCONT: SmallInt;
    FCODTRA2: string;
    FMODELOECF: string;
    FCPFCNPJ: string;
    FPAFECF: string;
    FVALORBRUTOINTEGERERNO: currency;
    FCOCXA: string;
    FCODDIARIO: string;
    FIDCONTATOCOBRANCA: integer;
    FIDCONTATOENTREGA: integer;
    FCODAGENDAMENTO: integer;
    FSTATUSCHEQUE: SmallInt;
    FTIPODESCONTOMD5: string;
    FSATTIMESTAMP: TDateTime;
    FDATACANCELAMENTO: TDateTime;
    FCODETDMUNSERV: string;
    FVALORBRUTOINTERNO: currency;
    FIDNAT2: integer;
    FIDMOVRELAC: integer;
    FNUMERO: integer;
    FCODMEN: string;
    FVALORSEGURO: currency;
    FCODCFO: string;
    FVALORDESCMD5: string;
    FIDMOVRM: integer;
    FCODIGOSERVICO: string;
    FCONTABILIZADOPORTOTAL: integer;
    FSTSCOMPRAS: string;
    FUSADESPFINANC: SmallInt;
    FNUMEROLCTABERTO: SmallInt;
    FVALORDESP: currency;
    FCODCOLIGADADESTINO: integer;
    FSATVALORTOTALCFE: currency;
    FSATARQUIVOCFE64: string;
    FNFCXML: string;
    FMULCFIDELIDADE: currency;
    FVERIFICADO: string;
    FSTSEMAIL: integer;
    FSTATUSSEPARACAO: string;
    FDATAEXTRA2: TDateTime;
    FDATAEMISSAO: TDateTime;
    FFATIMPRESSA: SmallInt;
    FSTATUS: string;
    FCNABCARTEIRA: string;
    FVALORBRUTOMD5: string;
    FPONTUADORM: string;
    FIDAIDF: SmallInt;
    FCODLAF: string;
    FCAMPOLIVRE2: string;
    FCODMENDESCONTO: string;
    FIDMOVLCTFLUXUS: integer;
    FDOCIMPRESSO: SmallInt;
    FCODLOCENTREGA: string;
    FIDSALDOESTOQUE: integer;
    FDTHENTREGA: TDateTime;
    FCODFAIXAENTREGA: string;
    FCAMPOLIVRE3: string;
    FCODEVENTO: SmallInt;
    FGERADOPORLOTE: SmallInt;
    FCODUSUARIO: string;
    FSEGUNDONUMERO: string;
    FIDMOV: Integer;
    FSATNCFECANCELAMENTO: string;
    FIDMOVPREVENDA: integer;
    FIDFORMAPAGTO: integer;
    FCODFILIALDESTINO: SmallInt;
    FDATACANCELAMENTOMOV: TDateTime;
    FIDLOT: integer;
    FCODTB2FLX: string;
    FPESOLIQUIDO: currency;
    FPERCENTUALEXTRA2: currency;
    FDATAEXTRA1: TDateTime;
    FNUMEROMOV: string;
    FSEQDIARIO: string;
    FPRAZOENTREGA: integer;
    FINDUSOOBJ: string;
    FCAMPOLIVRE1: string;
    FFLAGEXPORTACAO: SmallInt;
    FCODTB3FLX: string;
    FQUANTIDADE: integer;
    FCODCFONATUREZA: string;
    FNOMECLIENTEMD5: string;
    FDATAIMPORTACAO: TDateTime;
    FCARTEIRA: string;
    FHORARIOEMISSAO: TDateTime;
    FCODTRA: string;
    FVALOROUTROS: currency;
    FVALORLIQUIDO: currency;
    FCODTMV: string;
    FSATCOD: integer;
    FSATMENSAGEM: string;
    FNFECHAVE: string;
    FSTATUSORIGRM: string;
    FNAONUMERADO: string;
    FIDLOTEPROCESSOREFAT: integer;
    FCODTB1FLX: string;
    FPERCCOMISSAO: currency;
    FPERCENTUALEXTRA1: currency;
    FNFCXJUST: string;
    FNFCDHRECBTO: TDateTime;
    FNUMEROCUPOM: integer;
    FIDNAT: integer;
    FCODCCUSTODESTINO: string;
    FMARCA: string;
    FVALOREXTRA2: currency;
    FDATASAIDA: TDateTime;
    FCODCOLIGADA: SmallInt;
    FNFCNUMEROLOTE: integer;
    FDATADEDUCAO: TDateTime;
    FABATIMENTOICMS: currency;
    FFLAGAGRUPADOFLUXUS: SmallInt;
    FVALORRECEBIDO: currency;
    FDATABASEMOV: TDateTime;
    FPLACA: string;
    FVIADETRANSPORTE: string;
    FMFADICIONALMD5: string;
    FSATXML: string;
    FCCF: integer;
    FSEQDIARIOESTORNO: string;
    FFLAGPROCESSADO: integer;
    FIDCLASSMOV: integer;
    FPERCCOMISSAOVEN2: currency;
    FCODTB4FLX: string;
    FSATASSINATURAQRCODE: string;
    FUSUARIOCRIACAO: string;
    FNUMEROUSUARIOMD5: string;
    Fnroseriemd5: string;
    FCNABBANCO: string;
    FCODVEN2: string;
    FCODCXA: string;
    FFLAGIMPRESSAOFAT: string;
    FCODTB5FLX: string;
    FVALOREXTRA1: currency;
    FPERCENTUALDESC: currency;
    FPERCENTUALFRETE: currency;
    FTIPO: string;
    FCODFILIAL: SmallInt;
    FPVENTREGA: string;
    FCODVEN3: string;
    FDATAMOVIMENTO: TDateTime;
    FNFCMOTIVO: string;
    FCODVENIMPORTACAO: string;
    FIDPRJ: integer;
    FORDEMAPLICACAOMD5: string;
    FTIPODESCONTO: string;
    FSATCCCC: integer;
    FINTEGEREGRADOBONUM: integer;
    FEXPORTADOPV: string;
    FCODFORMAPAGTO: string;
    FDATACRIACAO: TDateTime;
    FNUMEROCAIXA: integer;
    FHORULTIMAALTERACAO: TDateTime;
    FCODVEN1: string;
    FITENSAGRUPADOS: SmallInt;
    FNORDEM: string;
    FMOVIMPRESSO: SmallInt;
    procedure SetABATIMENTOICMS(const Value: currency);
    procedure SetAPROPRIADO(const Value: SmallInt);
    procedure SetCAMPOLIVRE1(const Value: string);
    procedure SetCAMPOLIVRE2(const Value: string);
    procedure SetCAMPOLIVRE3(const Value: string);
    procedure SetCARTEIRA(const Value: string);
    procedure SetCCF(const Value: integer);
    procedure SetCCFMD5(const Value: string);
    procedure Setcentralizado(const Value: string);
    procedure SetCHAPARESP(const Value: string);
    procedure SetCNABBANCO(const Value: string);
    procedure SetCNABCARTEIRA(const Value: string);
    procedure SetCOCXA(const Value: string);
    procedure SetCODAGENDAMENTO(const Value: integer);
    procedure SetCODCCUSTO(const Value: string);
    procedure SetCODCCUSTODESTINO(const Value: string);
    procedure SetCODCFO(const Value: string);
    procedure SetCODCFOAUX(const Value: string);
    procedure SetCODCFONATUREZA(const Value: string);
    procedure SetCODCOLCFO(const Value: SmallInt);
    procedure SetCODCOLCFONATUREZA(const Value: SmallInt);
    procedure SetCODCOLCXA(const Value: string);
    procedure SetCODCOLIGADA(const Value: SmallInt);
    procedure SetCODCOLIGADADESTINO(const Value: integer);
    procedure SetCODCPG(const Value: string);
    procedure SetCODCXA(const Value: string);
    procedure SetCODDEPARTAMENTO(const Value: string);
    procedure SetCODDIARIO(const Value: string);
    procedure SetCODENTREGA(const Value: string);
    procedure SetCODETDMUNSERV(const Value: string);
    procedure SetCODETDPLACA(const Value: string);
    procedure SetCODEVENTO(const Value: SmallInt);
    procedure SetCODFAIXAENTREGA(const Value: string);
    procedure SetCODFILIAL(const Value: SmallInt);
    procedure SetCODFILIALDESTINO(const Value: SmallInt);
    procedure SetCODFILIALENTREGA(const Value: SmallInt);
    procedure SetCODFORMAPAGTO(const Value: string);
    procedure SetCODGERENTE(const Value: string);
    procedure SetCODIGOSERVICO(const Value: string);
    procedure SetCODLAF(const Value: string);
    procedure SetCODLAFE(const Value: string);
    procedure SetCODLOC(const Value: string);
    procedure SetCODLOCDESTINO(const Value: string);
    procedure SetCODLOCENTREGA(const Value: string);
    procedure SetCODLOCEXP(const Value: string);
    procedure SetCODLOTE(const Value: integer);
    procedure SetCODMEN(const Value: string);
    procedure SetCODMEN2(const Value: string);
    procedure SetCODMENDESCONTO(const Value: string);
    procedure SetCODMENDESPESA(const Value: string);
    procedure SetCODMENFRETE(const Value: string);
    procedure SetCODMOELANCAMENTO(const Value: string);
    procedure SetCODMOEVALORLIQUIDO(const Value: string);
    procedure SetCODMUNSERVICO(const Value: string);
    procedure SetCODRPR(const Value: string);
    procedure SetCODTB1FAT(const Value: string);
    procedure SetCODTB1FLX(const Value: string);
    procedure SetCODTB2FAT(const Value: string);
    procedure SetCODTB2FLX(const Value: string);
    procedure SetCODTB3FAT(const Value: string);
    procedure SetCODTB3FLX(const Value: string);
    procedure SetCODTB4FAT(const Value: string);
    procedure SetCODTB4FLX(const Value: string);
    procedure SetCODTB5FAT(const Value: string);
    procedure SetCODTB5FLX(const Value: string);
    procedure SetCODTDO(const Value: string);
    procedure SetCODTMV(const Value: string);
    procedure SetCODTRA(const Value: string);
    procedure SetCODTRA2(const Value: string);
    procedure SetCODUSUARIO(const Value: string);
    procedure SetCODVEN1(const Value: string);
    procedure SetCODVEN2(const Value: string);
    procedure SetCODVEN3(const Value: string);
    procedure SetCODVEN4(const Value: string);
    procedure SetCODVENIMPORTACAO(const Value: string);
    procedure SetCOMISSAOREPRES(const Value: currency);
    procedure SetCONTABILIZADOPORTOTAL(const Value: integer);
    procedure SetCPFCNPJ(const Value: string);
    procedure SetCPFCNPJMD5(const Value: string);
    procedure SetCRO(const Value: integer);
    procedure SetDATABASEMOV(const Value: TDateTime);
    procedure SetDATACANCELAMENTO(const Value: TDateTime);
    procedure SetDATACANCELAMENTOMOV(const Value: TDateTime);
    procedure SetDATACRIACAO(const Value: TDateTime);
    procedure SetDATADEDUCAO(const Value: TDateTime);
    procedure SetDATAEMISSAO(const Value: TDateTime);
    procedure SetDATAEMISSAOMD5(const Value: string);
    procedure SetDATAENTREGA(const Value: TDateTime);
    procedure SetDATAEXTRA1(const Value: TDateTime);
    procedure SetDATAEXTRA2(const Value: TDateTime);
    procedure SetDATAFECHAMENTO(const Value: TDateTime);
    procedure SetDATAIMPORTACAO(const Value: TDateTime);
    procedure SetDATAMOVIMENTO(const Value: TDateTime);
    procedure SetDATAPROGRAMACAO(const Value: TDateTime);
    procedure SetDATARETORNO(const Value: TDateTime);
    procedure SetDATASAIDA(const Value: TDateTime);
    procedure SetDOCIMPRESSO(const Value: SmallInt);
    procedure SetDTHENTREGA(const Value: TDateTime);
    procedure SetEMITEBOLETA(const Value: string);
    procedure SetESPECIE(const Value: string);
    procedure SetEXPORTADO(const Value: string);
    procedure SetEXPORTADOCANC(const Value: string);
    procedure SetEXPORTADOPV(const Value: string);
    procedure SetEXPORTADOREDZ(const Value: string);
    procedure SetFATIMPRESSA(const Value: SmallInt);
    procedure SetFLAGAGRUPADOFLUXUS(const Value: SmallInt);
    procedure SetFLAGEFEITOSALDO(const Value: SmallInt);
    procedure SetFLAGEXPORFAZENDA(const Value: SmallInt);
    procedure SetFLAGEXPORFISC(const Value: SmallInt);
    procedure SetFLAGEXPORTACAO(const Value: SmallInt);
    procedure SetFLAGIMPRESSAOFAT(const Value: string);
    procedure SetFLAGPROCESSADO(const Value: integer);
    procedure SetFRETECIFOUFOB(const Value: SmallInt);
    procedure SetGERADOPORLOTE(const Value: SmallInt);
    procedure SetGEROUFATURA(const Value: SmallInt);
    procedure SetHORARIOEMISSAO(const Value: TDateTime);
    procedure SetHORASAIDA(const Value: TDateTime);
    procedure SetHORULTIMAALTERACAO(const Value: TDateTime);
    procedure SetIDAIDF(const Value: SmallInt);
    procedure SetIDCLASSMOV(const Value: integer);
    procedure SetIDCONTATOCOBRANCA(const Value: integer);
    procedure SetIDCONTATOENTREGA(const Value: integer);
    procedure SetIDFORMAPAGTO(const Value: integer);
    procedure SetIDLOT(const Value: integer);
    procedure SetIDLOTEPROCESSO(const Value: integer);
    procedure SetIDLOTEPROCESSOREFAT(const Value: integer);
    procedure SetIDMOV(const Value: Integer);
    procedure SetIDMOVDESTINO(const Value: integer);
    procedure SetIDMOVLCTFLUXUS(const Value: integer);
    procedure SetIDMOVPEDDESDOBRADO(const Value: integer);
    procedure SetIDMOVPREVENDA(const Value: integer);
    procedure SetIDMOVRELAC(const Value: integer);
    procedure SetIDMOVRM(const Value: integer);
    procedure SetIDNAT(const Value: integer);
    procedure SetIDNAT2(const Value: integer);
    procedure SetIDOBJOF(const Value: string);
    procedure SetIDPRJ(const Value: integer);
    procedure SetIDREDUCAOZ(const Value: integer);
    procedure SetIDSALDOESTOQUE(const Value: integer);
    procedure SetINDUSOOBJ(const Value: string);
    procedure SetINTEGEREGRADOBONUM(const Value: integer);
    procedure SetINTEGRADOBONUM(const Value: integer);
    procedure SetITENSAGRUPADOS(const Value: SmallInt);
    procedure SetMARCA(const Value: string);
    procedure SetMFADICIONAL(const Value: string);
    procedure SetMFADICIONALMD5(const Value: string);
    procedure SetMODELOECF(const Value: string);
    procedure SetMODELOECFMD5(const Value: string);
    procedure SetMOVIMPRESSO(const Value: SmallInt);
    procedure SetMULCFIDELIDADE(const Value: currency);
    procedure SetNAONUMERADO(const Value: string);
    procedure SetNFCDHRECBTO(const Value: TDateTime);
    procedure SetNFCHAVE(const Value: string);
    procedure SetNFCID(const Value: string);
    procedure SetNFCMOTIVO(const Value: string);
    procedure SetNFCNPROT(const Value: string);
    procedure SetNFCNUMEROLOTE(const Value: integer);
    procedure SetNFCSERIE(const Value: string);
    procedure SetNFCSTATUS(const Value: integer);
    procedure SetNFCTIPOEMISSAO(const Value: string);
    procedure SetNFCVERSAOAPLICACAO(const Value: string);
    procedure SetNFCXJUST(const Value: string);
    procedure SetNFCXML(const Value: string);
    procedure SetNFCXMLCANCELAMENTO(const Value: string);
    procedure SetNFECHAVE(const Value: string);
    procedure SetNFEINTEGRADO(const Value: integer);
    procedure SetNOMECLIENTE(const Value: string);
    procedure SetNOMECLIENTEMD5(const Value: string);
    procedure SetNORDEM(const Value: string);
    procedure SetNOTAMANUAL(const Value: string);
    procedure SetNROSERIE(const Value: string);
    procedure Setnroseriemd5(const Value: string);
    procedure SetNSEQDATAFECHAMENTO(const Value: SmallInt);
    procedure SetNUMERO(const Value: integer);
    procedure SetNUMEROCAIXA(const Value: integer);
    procedure SetNUMEROCUPOM(const Value: integer);
    procedure SetNUMEROCUPOMMD5(const Value: string);
    procedure SetNUMEROLCTABERTO(const Value: SmallInt);
    procedure SetNUMEROLCTGERADO(const Value: SmallInt);
    procedure SetNUMEROMOV(const Value: string);
    procedure SetNUMERORECIBO(const Value: string);
    procedure SetNUMEROTRIBUTOS(const Value: SmallInt);
    procedure SetNUMEROUSUARIO(const Value: string);
    procedure SetNUMEROUSUARIOMD5(const Value: string);
    procedure SetOBSERVACAO(const Value: string);
    procedure SetORDEMAPLICACAO(const Value: string);
    procedure SetORDEMAPLICACAOMD5(const Value: string);
    procedure SetPAFECF(const Value: string);
    procedure SetPERCCOMISSAO(const Value: currency);
    procedure SetPERCCOMISSAOVEN2(const Value: currency);
    procedure SetPERCENTUALDESC(const Value: currency);
    procedure SetPERCENTUALDESP(const Value: currency);
    procedure SetPERCENTUALEXTRA1(const Value: currency);
    procedure SetPERCENTUALEXTRA2(const Value: currency);
    procedure SetPERCENTUALFRETE(const Value: currency);
    procedure SetPERCENTUALSEGURO(const Value: currency);
    procedure SetPESOBRUTO(const Value: currency);
    procedure SetPESOLIQUIDO(const Value: currency);
    procedure SetPLACA(const Value: string);
    procedure SetPONTOVENDA(const Value: string);
    procedure SetPONTUADORM(const Value: string);
    procedure SetPRAZOENTREGA(const Value: integer);
    procedure SetPROTOCOLONFE(const Value: string);
    procedure SetPTOCFIDELIDADE(const Value: currency);
    procedure SetPVENTREGA(const Value: string);
    procedure SetQUANTIDADE(const Value: integer);
    procedure SetSATARQUIVOCFE64(const Value: string);
    procedure SetSATASSINATURAQRCODE(const Value: string);
    procedure SetSATCCCC(const Value: integer);
    procedure SetSATCHAVECANCELAMENTO(const Value: string);
    procedure SetSATCHAVECONSULTA(const Value: string);
    procedure SetSATCOD(const Value: integer);
    procedure SetSATCPFCNPJVALUE(const Value: string);
    procedure SetSATEEEEE(const Value: integer);
    procedure SetSATMENSAGEM(const Value: string);
    procedure SetSATMENSAGEMSEFAZ(const Value: string);
    procedure SetSATNCFE(const Value: string);
    procedure SetSATNCFECANCELAMENTO(const Value: string);
    procedure SetSATRETORNO(const Value: string);
    procedure SetSATSERIAL(const Value: string);
    procedure SetSATSESSAO(const Value: integer);
    procedure SetSATTIMESTAMP(const Value: TDateTime);
    procedure SetSATVALORTOTALCFE(const Value: currency);
    procedure SetSATXML(const Value: string);
    procedure SetSATXMLCANCELAMENTO(const Value: string);
    procedure SetSEGUNDONUMERO(const Value: string);
    procedure SetSEQDIARIO(const Value: string);
    procedure SetSEQDIARIOESTORNO(const Value: string);
    procedure SetSERIE(const Value: string);
    procedure SetSERVICOFISCAL(const Value: string);
    procedure SetSTATUS(const Value: string);
    procedure SetSTATUSCHEQUE(const Value: SmallInt);
    procedure SetSTATUSEXPORTCONT(const Value: SmallInt);
    procedure SetSTATUSLIBERACAO(const Value: SmallInt);
    procedure SetSTATUSMD5(const Value: string);
    procedure SetSTATUSNFE(const Value: string);
    procedure SetSTATUSORIGRM(const Value: string);
    procedure SetSTATUSSEPARACAO(const Value: string);
    procedure SetSTSCOMPRAS(const Value: string);
    procedure SetSTSEMAIL(const Value: integer);
    procedure SetSUBSERIE(const Value: string);
    procedure SetTBCLOG(const Value: string);
    procedure SetTIPO(const Value: string);
    procedure SetTIPOCONSUMO(const Value: SmallInt);
    procedure SetTIPODESCONTO(const Value: string);
    procedure SetTIPODESCONTOMD5(const Value: string);
    procedure SetTPNF(const Value: string);
    procedure Settroco(const Value: currency);
    procedure SetUSADESPFINANC(const Value: SmallInt);
    procedure SetUSUARIOCRIACAO(const Value: string);
    procedure SetUSUARIOCRIACAOMOV(const Value: string);
    procedure SetVALORADIANTAMENTO(const Value: currency);
    procedure SetVALORBRUTO(const Value: currency);
    procedure SetVALORBRUTOINTEGERERNO(const Value: currency);
    procedure SetVALORBRUTOINTERNO(const Value: currency);
    procedure SetVALORBRUTOMD5(const Value: string);
    procedure SetVALORDESC(const Value: currency);
    procedure SetVALORDESCMD5(const Value: string);
    procedure SetVALORDESP(const Value: currency);
    procedure SetVALORDESPMD5(const Value: string);
    procedure SetVALOREXTRA1(const Value: currency);
    procedure SetVALOREXTRA2(const Value: currency);
    procedure SetVALORFRETE(const Value: currency);
    procedure SetVALORFRETECTRC(const Value: currency);
    procedure SetVALORLIQUIDO(const Value: currency);
    procedure SetVALORLIQUIDOMD5(const Value: string);
    procedure SetVALOROUTROS(const Value: currency);
    procedure SetVALORRECEBIDO(const Value: currency);
    procedure SetVALORSEGURO(const Value: currency);
    procedure SetVERIFICADO(const Value: string);
    procedure SetVIADETRANSPORTE(const Value: string);
    procedure SetVINCULADOESTOQUEFL(const Value: integer);

  public

    property CODCOLIGADA: SmallInt read FCODCOLIGADA write SetCODCOLIGADA;
    property IDMOV: Integer read FIDMOV write SetIDMOV;
    property CODFILIAL: SmallInt read FCODFILIAL write SetCODFILIAL;
    property CODLOC: string read FCODLOC write SetCODLOC;
    property CODLOCENTREGA: string read FCODLOCENTREGA write SetCODLOCENTREGA;
    property CODLOCDESTINO: string read FCODLOCDESTINO write SetCODLOCDESTINO;
    property CODCFO: string read FCODCFO write SetCODCFO;
    property CODCFONATUREZA: string read FCODCFONATUREZA write SetCODCFONATUREZA;
    property NUMEROMOV: string read FNUMEROMOV write SetNUMEROMOV;
    property SERIE: string read FSERIE write SetSERIE;
    property CODTMV: string read FCODTMV write SetCODTMV;
    property TIPO: string read FTIPO write SetTIPO;
    property STATUS: string read FSTATUS write SetSTATUS;
    property MOVIMPRESSO: SmallInt read FMOVIMPRESSO write SetMOVIMPRESSO;
    property DOCIMPRESSO: SmallInt read FDOCIMPRESSO write SetDOCIMPRESSO;
    property FATIMPRESSA: SmallInt read FFATIMPRESSA write SetFATIMPRESSA;
    property DATAEMISSAO: TDateTime read FDATAEMISSAO write SetDATAEMISSAO;
    property DATASAIDA: TDateTime read FDATASAIDA write SetDATASAIDA;
    property DATAEXTRA1: TDateTime read FDATAEXTRA1 write SetDATAEXTRA1;
    property DATAEXTRA2: TDateTime read FDATAEXTRA2 write SetDATAEXTRA2;
    property CODRPR: string read FCODRPR write SetCODRPR;
    property COMISSAOREPRES: currency read FCOMISSAOREPRES write SetCOMISSAOREPRES;
    property NORDEM: string read FNORDEM write SetNORDEM;
    property CODCPG: string read FCODCPG write SetCODCPG;
    property NUMEROTRIBUTOS: SmallInt read FNUMEROTRIBUTOS write SetNUMEROTRIBUTOS;
    property VALORBRUTO: currency read FVALORBRUTO write SetVALORBRUTO;
    property VALORLIQUIDO: currency read FVALORLIQUIDO write SetVALORLIQUIDO;
    property VALOROUTROS: currency read FVALOROUTROS write SetVALOROUTROS;
    property OBSERVACAO: string read FOBSERVACAO write SetOBSERVACAO;
    property PERCENTUALFRETE: currency read FPERCENTUALFRETE write SetPERCENTUALFRETE;
    property VALORFRETE: currency read FVALORFRETE write SetVALORFRETE;
    property PERCENTUALSEGURO: currency read FPERCENTUALSEGURO write SetPERCENTUALSEGURO;
    property VALORSEGURO: currency read FVALORSEGURO write SetVALORSEGURO;
    property PERCENTUALDESC: currency read FPERCENTUALDESC write SetPERCENTUALDESC;
    property VALORDESC: currency read FVALORDESC write SetVALORDESC;
    property PERCENTUALDESP: currency read FPERCENTUALDESP write SetPERCENTUALDESP;
    property VALORDESP: currency read FVALORDESP write SetVALORDESP;
    property PERCENTUALEXTRA1: currency read FPERCENTUALEXTRA1 write SetPERCENTUALEXTRA1;
    property VALOREXTRA1: currency read FVALOREXTRA1 write SetVALOREXTRA1;
    property PERCENTUALEXTRA2: currency read FPERCENTUALEXTRA2 write SetPERCENTUALEXTRA2;
    property VALOREXTRA2: currency read FVALOREXTRA2 write SetVALOREXTRA2;
    property PERCCOMISSAO: currency read FPERCCOMISSAO write SetPERCCOMISSAO;
    property CODMEN: string read FCODMEN write SetCODMEN;
    property CODMEN2: string read FCODMEN2 write SetCODMEN2;
    property VIADETRANSPORTE: string read FVIADETRANSPORTE write SetVIADETRANSPORTE;
    property PLACA: string read FPLACA write SetPLACA;
    property CODETDPLACA: string read FCODETDPLACA write SetCODETDPLACA;
    property PESOLIQUIDO: currency read FPESOLIQUIDO write SetPESOLIQUIDO;
    property PESOBRUTO: currency read FPESOBRUTO write SetPESOBRUTO;
    property MARCA: string read FMARCA write SetMARCA;
    property NUMERO: integer read FNUMERO write SetNUMERO;
    property QUANTIDADE: integer read FQUANTIDADE write SetQUANTIDADE;
    property ESPECIE: string read FESPECIE write SetESPECIE;
    property CODTB1FAT: string read FCODTB1FAT write SetCODTB1FAT;
    property CODTB2FAT: string read FCODTB2FAT write SetCODTB2FAT;
    property CODTB3FAT: string read FCODTB3FAT write SetCODTB3FAT;
    property CODTB4FAT: string read FCODTB4FAT write SetCODTB4FAT;
    property CODTB5FAT: string read FCODTB5FAT write SetCODTB5FAT;
    property CODTB1FLX: string read FCODTB1FLX write SetCODTB1FLX;
    property CODTB2FLX: string read FCODTB2FLX write SetCODTB2FLX;
    property CODTB3FLX: string read FCODTB3FLX write SetCODTB3FLX;
    property CODTB4FLX: string read FCODTB4FLX write SetCODTB4FLX;
    property CODTB5FLX: string read FCODTB5FLX write SetCODTB5FLX;
    property IDMOVRELAC: integer read FIDMOVRELAC write SetIDMOVRELAC;
    property IDMOVLCTFLUXUS: integer read FIDMOVLCTFLUXUS write SetIDMOVLCTFLUXUS;
    property IDMOVPEDDESDOBRADO: integer read FIDMOVPEDDESDOBRADO write SetIDMOVPEDDESDOBRADO;
    property CODMOEVALORLIQUIDO: string read FCODMOEVALORLIQUIDO write SetCODMOEVALORLIQUIDO;
    property DATABASEMOV: TDateTime read FDATABASEMOV write SetDATABASEMOV;
    property DATAMOVIMENTO: TDateTime read FDATAMOVIMENTO write SetDATAMOVIMENTO;
    property NUMEROLCTGERADO: SmallInt read FNUMEROLCTGERADO write SetNUMEROLCTGERADO;
    property GEROUFATURA: SmallInt read FGEROUFATURA write SetGEROUFATURA;
    property NUMEROLCTABERTO: SmallInt read FNUMEROLCTABERTO write SetNUMEROLCTABERTO;
    property FLAGEXPORTACAO: SmallInt read FFLAGEXPORTACAO write SetFLAGEXPORTACAO;
    property EMITEBOLETA: string read FEMITEBOLETA write SetEMITEBOLETA;
    property CODMENDESCONTO: string read FCODMENDESCONTO write SetCODMENDESCONTO;
    property CODMENDESPESA: string read FCODMENDESPESA write SetCODMENDESPESA;
    property CODMENFRETE: string read FCODMENFRETE write SetCODMENFRETE;
    property FRETECIFOUFOB: SmallInt read FFRETECIFOUFOB write SetFRETECIFOUFOB;
    property USADESPFINANC: SmallInt read FUSADESPFINANC write SetUSADESPFINANC;
    property FLAGEXPORFISC: SmallInt read FFLAGEXPORFISC write SetFLAGEXPORFISC;
    property FLAGEXPORFAZENDA: SmallInt read FFLAGEXPORFAZENDA write SetFLAGEXPORFAZENDA;
    property VALORADIANTAMENTO: currency read FVALORADIANTAMENTO write SetVALORADIANTAMENTO;
    property CODTRA: string read FCODTRA write SetCODTRA;
    property CODTRA2: string read FCODTRA2 write SetCODTRA2;
    property STATUSLIBERACAO: SmallInt read FSTATUSLIBERACAO write SetSTATUSLIBERACAO;
    property CODCFOAUX: string read FCODCFOAUX write SetCODCFOAUX;
    property IDLOT: integer read FIDLOT write SetIDLOT;
    property ITENSAGRUPADOS: SmallInt read FITENSAGRUPADOS write SetITENSAGRUPADOS;
    property FLAGIMPRESSAOFAT: string read FFLAGIMPRESSAOFAT write SetFLAGIMPRESSAOFAT;
    property DATACANCELAMENTOMOV: TDateTime read FDATACANCELAMENTOMOV write SetDATACANCELAMENTOMOV;
    property VALORRECEBIDO: currency read FVALORRECEBIDO write SetVALORRECEBIDO;
    property SEGUNDONUMERO: string read FSEGUNDONUMERO write SetSEGUNDONUMERO;
    property CODCCUSTO: string read FCODCCUSTO write SetCODCCUSTO;
    property CODCXA: string read FCODCXA write SetCODCXA;
    property CODVEN1: string read FCODVEN1 write SetCODVEN1;
    property CODVEN2: string read FCODVEN2 write SetCODVEN2;
    property CODVEN3: string read FCODVEN3 write SetCODVEN3;
    property CODVEN4: string read FCODVEN4 write SetCODVEN4;
    property PERCCOMISSAOVEN2: currency read FPERCCOMISSAOVEN2 write SetPERCCOMISSAOVEN2;
    property CODCOLCFO: SmallInt read FCODCOLCFO write SetCODCOLCFO;
    property CODCOLCFONATUREZA: SmallInt read FCODCOLCFONATUREZA write SetCODCOLCFONATUREZA;
    property CODUSUARIO: string read FCODUSUARIO write SetCODUSUARIO;
    property CODFILIALENTREGA: SmallInt read FCODFILIALENTREGA write SetCODFILIALENTREGA;
    property CODFILIALDESTINO: SmallInt read FCODFILIALDESTINO write SetCODFILIALDESTINO;
    property FLAGAGRUPADOFLUXUS: SmallInt read FFLAGAGRUPADOFLUXUS write SetFLAGAGRUPADOFLUXUS;
    property CODCOLCXA: string read FCODCOLCXA write SetCODCOLCXA;
    property GERADOPORLOTE: SmallInt read FGERADOPORLOTE write SetGERADOPORLOTE;
    property CODDEPARTAMENTO: string read FCODDEPARTAMENTO write SetCODDEPARTAMENTO;
    property CODCCUSTODESTINO: string read FCODCCUSTODESTINO write SetCODCCUSTODESTINO;
    property CODEVENTO: SmallInt read FCODEVENTO write SetCODEVENTO;
    property STATUSEXPORTCONT: SmallInt read FSTATUSEXPORTCONT write SetSTATUSEXPORTCONT;
    property CODLOTE: integer read FCODLOTE write SetCODLOTE;
    property STATUSCHEQUE: SmallInt read FSTATUSCHEQUE write SetSTATUSCHEQUE;
    property DATAENTREGA: TDateTime read FDATAENTREGA write SetDATAENTREGA;
    property DATAPROGRAMACAO: TDateTime read FDATAPROGRAMACAO write SetDATAPROGRAMACAO;
    property IDNAT: integer read FIDNAT write SetIDNAT;
    property IDNAT2: integer read FIDNAT2 write SetIDNAT2;
    property CAMPOLIVRE1: string read FCAMPOLIVRE1 write SetCAMPOLIVRE1;
    property CAMPOLIVRE2: string read FCAMPOLIVRE2 write SetCAMPOLIVRE2;
    property CAMPOLIVRE3: string read FCAMPOLIVRE3 write SetCAMPOLIVRE3;
    property HORULTIMAALTERACAO: TDateTime read FHORULTIMAALTERACAO write SetHORULTIMAALTERACAO;
    property CODLAF: string read FCODLAF write SetCODLAF;
    property DATAFECHAMENTO: TDateTime read FDATAFECHAMENTO write SetDATAFECHAMENTO;
    property NSEQDATAFECHAMENTO: SmallInt read FNSEQDATAFECHAMENTO write SetNSEQDATAFECHAMENTO;
    property NUMERORECIBO: string read FNUMERORECIBO write SetNUMERORECIBO;
    property IDLOTEPROCESSO: integer read FIDLOTEPROCESSO write SetIDLOTEPROCESSO;
    property IDOBJOF: string read FIDOBJOF write SetIDOBJOF;
    property CODAGENDAMENTO: integer read FCODAGENDAMENTO write SetCODAGENDAMENTO;
    property CHAPARESP: string read FCHAPARESP write SetCHAPARESP;
    property IDLOTEPROCESSOREFAT: integer read FIDLOTEPROCESSOREFAT write SetIDLOTEPROCESSOREFAT;
    property INDUSOOBJ: string read FINDUSOOBJ write SetINDUSOOBJ;
    property SUBSERIE: string read FSUBSERIE write SetSUBSERIE;
    property STSCOMPRAS: string read FSTSCOMPRAS write SetSTSCOMPRAS;
    property CODLOCEXP: string read FCODLOCEXP write SetCODLOCEXP;
    property IDCLASSMOV: integer read FIDCLASSMOV write SetIDCLASSMOV;
    property CODENTREGA: string read FCODENTREGA write SetCODENTREGA;
    property CODFAIXAENTREGA: string read FCODFAIXAENTREGA write SetCODFAIXAENTREGA;
    property DTHENTREGA: TDateTime read FDTHENTREGA write SetDTHENTREGA;
    property CONTABILIZADOPORTOTAL: integer read FCONTABILIZADOPORTOTAL write SetCONTABILIZADOPORTOTAL;
    property CODLAFE: string read FCODLAFE write SetCODLAFE;
    property IDPRJ: integer read FIDPRJ write SetIDPRJ;
    property NUMEROCUPOM: integer read FNUMEROCUPOM write SetNUMEROCUPOM;
    property NUMEROCAIXA: integer read FNUMEROCAIXA write SetNUMEROCAIXA;
    property FLAGEFEITOSALDO: SmallInt read FFLAGEFEITOSALDO write SetFLAGEFEITOSALDO;
    property INTEGRADOBONUM: integer read FINTEGRADOBONUM write SetINTEGRADOBONUM;
    property CODMOELANCAMENTO: string read FCODMOELANCAMENTO write SetCODMOELANCAMENTO;
    property NAONUMERADO: string read FNAONUMERADO write SetNAONUMERADO;
    property FLAGPROCESSADO: integer read FFLAGPROCESSADO write SetFLAGPROCESSADO;
    property ABATIMENTOICMS: currency read FABATIMENTOICMS write SetABATIMENTOICMS;
    property TIPOCONSUMO: SmallInt read FTIPOCONSUMO write SetTIPOCONSUMO;
    property HORARIOEMISSAO: TDateTime read FHORARIOEMISSAO write SetHORARIOEMISSAO;
    property DATARETORNO: TDateTime read FDATARETORNO write SetDATARETORNO;
    property USUARIOCRIACAOMOV: string read FUSUARIOCRIACAOMOV write SetUSUARIOCRIACAOMOV;
    property DATACRIACAO: TDateTime read FDATACRIACAO write SetDATACRIACAO;
    property IDCONTATOENTREGA: integer read FIDCONTATOENTREGA write SetIDCONTATOENTREGA;
    property IDCONTATOCOBRANCA: integer read FIDCONTATOCOBRANCA write SetIDCONTATOCOBRANCA;
    property STATUSSEPARACAO: string read FSTATUSSEPARACAO write SetSTATUSSEPARACAO;
    property STSEMAIL: integer read FSTSEMAIL write SetSTSEMAIL;
    property VALORFRETECTRC: currency read FVALORFRETECTRC write SetVALORFRETECTRC;
    property PONTOVENDA: string read FPONTOVENDA write SetPONTOVENDA;
    property PRAZOENTREGA: integer read FPRAZOENTREGA write SetPRAZOENTREGA;
    property VALORBRUTOINTERNO: currency read FVALORBRUTOINTERNO write SetVALORBRUTOINTERNO;
    property IDAIDF: SmallInt read FIDAIDF write SetIDAIDF;
    property IDSALDOESTOQUE: integer read FIDSALDOESTOQUE write SetIDSALDOESTOQUE;
    property VINCULADOESTOQUEFL: integer read FVINCULADOESTOQUEFL write SetVINCULADOESTOQUEFL;
    property IDREDUCAOZ: integer read FIDREDUCAOZ write SetIDREDUCAOZ;
    property HORASAIDA: TDateTime read FHORASAIDA write SetHORASAIDA;
    property CODMUNSERVICO: string read FCODMUNSERVICO write SetCODMUNSERVICO;
    property CODETDMUNSERV: string read FCODETDMUNSERV write SetCODETDMUNSERV;
    property APROPRIADO: SmallInt read FAPROPRIADO write SetAPROPRIADO;
    property CODIGOSERVICO: string read FCODIGOSERVICO write SetCODIGOSERVICO;
    property DATADEDUCAO: TDateTime read FDATADEDUCAO write SetDATADEDUCAO;
    property CODDIARIO: string read FCODDIARIO write SetCODDIARIO;
    property SEQDIARIO: string read FSEQDIARIO write SetSEQDIARIO;
    property SEQDIARIOESTORNO: string read FSEQDIARIOESTORNO write SetSEQDIARIOESTORNO;
    property CODGERENTE: string read FCODGERENTE write SetCODGERENTE;
    property EXPORTADO: string read FEXPORTADO write SetEXPORTADO;
    property CODTDO: string read FCODTDO write SetCODTDO;
    property COCXA: string read FCOCXA write SetCOCXA;
    property CODFORMAPAGTO: string read FCODFORMAPAGTO write SetCODFORMAPAGTO;
    property CARTEIRA: string read FCARTEIRA write SetCARTEIRA;
    property IDFORMAPAGTO: integer read FIDFORMAPAGTO write SetIDFORMAPAGTO;
    property CNABBANCO: string read FCNABBANCO write SetCNABBANCO;
    property CRO: integer read FCRO write SetCRO;
    property EXPORTADOCANC: string read FEXPORTADOCANC write SetEXPORTADOCANC;
    property IDMOVRM: integer read FIDMOVRM write SetIDMOVRM;
    property IDMOVPREVENDA: integer read FIDMOVPREVENDA write SetIDMOVPREVENDA;
    property EXPORTADOREDZ: string read FEXPORTADOREDZ write SetEXPORTADOREDZ;
    property STATUSORIGRM: string read FSTATUSORIGRM write SetSTATUSORIGRM;
    property EXPORTADOPV: string read FEXPORTADOPV write SetEXPORTADOPV;
    property INTEGEREGRADOBONUM: integer read FINTEGEREGRADOBONUM write SetINTEGEREGRADOBONUM;
    property VALORBRUTOINTEGERERNO: currency read FVALORBRUTOINTEGERERNO write SetVALORBRUTOINTEGERERNO;

    property VERIFICADO: string read FVERIFICADO write SetVERIFICADO;
    property PVENTREGA: string read FPVENTREGA write SetPVENTREGA;
    property PTOCFIDELIDADE: currency read FPTOCFIDELIDADE write SetPTOCFIDELIDADE;
    property MULCFIDELIDADE: currency read FMULCFIDELIDADE write SetMULCFIDELIDADE;
    property PONTUADORM: string read FPONTUADORM write SetPONTUADORM;
    property NROSERIE: string read FNROSERIE write SetNROSERIE;
    property PAFECF: string read FPAFECF write SetPAFECF;
    property CCF: integer read FCCF write SetCCF;
    property troco: currency read Ftroco write Settroco;
    property centralizado: string read Fcentralizado write Setcentralizado;
    property DATACANCELAMENTO: TDateTime read FDATACANCELAMENTO write SetDATACANCELAMENTO;
    property STATUSNFE: string read FSTATUSNFE write SetSTATUSNFE;
    property PROTOCOLONFE: string read FPROTOCOLONFE write SetPROTOCOLONFE;
    property NFECHAVE: string read FNFECHAVE write SetNFECHAVE;
    property nroseriemd5: string read Fnroseriemd5 write Setnroseriemd5;
    property CCFMD5: string read FCCFMD5 write SetCCFMD5;
    property NUMEROCUPOMMD5: string read FNUMEROCUPOMMD5 write SetNUMEROCUPOMMD5;
    property VALORLIQUIDOMD5: string read FVALORLIQUIDOMD5 write SetVALORLIQUIDOMD5;
    property STATUSMD5: string read FSTATUSMD5 write SetSTATUSMD5;
    property CODVENIMPORTACAO: string read FCODVENIMPORTACAO write SetCODVENIMPORTACAO;
    property DATAIMPORTACAO: TDateTime read FDATAIMPORTACAO write SetDATAIMPORTACAO;
    property TPNF: string read FTPNF write SetTPNF;
    property NOTAMANUAL: string read FNOTAMANUAL write SetNOTAMANUAL;
    property NUMEROUSUARIO: string read FNUMEROUSUARIO write SetNUMEROUSUARIO;
    property NUMEROUSUARIOMD5: string read FNUMEROUSUARIOMD5 write SetNUMEROUSUARIOMD5;
    property DATAEMISSAOMD5: string read FDATAEMISSAOMD5 write SetDATAEMISSAOMD5;
    property VALORBRUTOMD5: string read FVALORBRUTOMD5 write SetVALORBRUTOMD5;
    property VALORDESCMD5: string read FVALORDESCMD5 write SetVALORDESCMD5;
    property VALORDESPMD5: string read FVALORDESPMD5 write SetVALORDESPMD5;
    property USUARIOCRIACAO: string read FUSUARIOCRIACAO write SetUSUARIOCRIACAO;
    property NFCID: string read FNFCID write SetNFCID;
    property NFCSTATUS: integer read FNFCSTATUS write SetNFCSTATUS;
    property NFCMOTIVO: string read FNFCMOTIVO write SetNFCMOTIVO;
    property NFCHAVE: string read FNFCHAVE write SetNFCHAVE;
    property NFCDHRECBTO: TDateTime read FNFCDHRECBTO write SetNFCDHRECBTO;
    property NFCSERIE: string read FNFCSERIE write SetNFCSERIE;
    property NFCNPROT: string read FNFCNPROT write SetNFCNPROT;
    property NFCXJUST: string read FNFCXJUST write SetNFCXJUST;
    property NFCTIPOEMISSAO: string read FNFCTIPOEMISSAO write SetNFCTIPOEMISSAO;
    property NFCNUMEROLOTE: integer read FNFCNUMEROLOTE write SetNFCNUMEROLOTE;
    property NFCXMLCANCELAMENTO: string read FNFCXMLCANCELAMENTO write SetNFCXMLCANCELAMENTO;
    property NFCVERSAOAPLICACAO: string read FNFCVERSAOAPLICACAO write SetNFCVERSAOAPLICACAO;
    property NFCXML: string read FNFCXML write SetNFCXML;
    property SERVICOFISCAL: string read FSERVICOFISCAL write SetSERVICOFISCAL;
    property SATRETORNO: string read FSATRETORNO write SetSATRETORNO;
    property SATEEEEE: integer read FSATEEEEE write SetSATEEEEE;
    property SATSESSAO: integer read FSATSESSAO write SetSATSESSAO;
    property SATCCCC: integer read FSATCCCC write SetSATCCCC;
    property SATMENSAGEMSEFAZ: string read FSATMENSAGEMSEFAZ write SetSATMENSAGEMSEFAZ;
    property SATMENSAGEM: string read FSATMENSAGEM write SetSATMENSAGEM;
    property SATCOD: integer read FSATCOD write SetSATCOD;
    property SATXML: string read FSATXML write SetSATXML;
    property SATXMLCANCELAMENTO: string read FSATXMLCANCELAMENTO write SetSATXMLCANCELAMENTO;
    property SATARQUIVOCFE64: string read FSATARQUIVOCFE64 write SetSATARQUIVOCFE64;
    property SATTIMESTAMP: TDateTime read FSATTIMESTAMP write SetSATTIMESTAMP;
    property SATCHAVECONSULTA: string read FSATCHAVECONSULTA write SetSATCHAVECONSULTA;
    property SATVALORTOTALCFE: currency read FSATVALORTOTALCFE write SetSATVALORTOTALCFE;
    property SATCPFCNPJVALUE: string read FSATCPFCNPJVALUE write SetSATCPFCNPJVALUE;
    property SATASSINATURAQRCODE: string read FSATASSINATURAQRCODE write SetSATASSINATURAQRCODE;
    property NFEINTEGRADO: integer read FNFEINTEGRADO write SetNFEINTEGRADO;
    property CNABCARTEIRA: string read FCNABCARTEIRA write SetCNABCARTEIRA;
    property CPFCNPJ: string read FCPFCNPJ write SetCPFCNPJ;
    property IDMOVDESTINO: integer read FIDMOVDESTINO write SetIDMOVDESTINO;
    property CODCOLIGADADESTINO: integer read FCODCOLIGADADESTINO write SetCODCOLIGADADESTINO;
    property TBCLOG: string read FTBCLOG write SetTBCLOG;
    property CPFCNPJMD5: string read FCPFCNPJMD5 write SetCPFCNPJMD5;
    property NOMECLIENTE: string read FNOMECLIENTE write SetNOMECLIENTE;
    property NOMECLIENTEMD5: string read FNOMECLIENTEMD5 write SetNOMECLIENTEMD5;
    property MFADICIONAL: string read FMFADICIONAL write SetMFADICIONAL;
    property MFADICIONALMD5: string read FMFADICIONALMD5 write SetMFADICIONALMD5;
    property MODELOECF: string read FMODELOECF write SetMODELOECF;
    property MODELOECFMD5: string read FMODELOECFMD5 write SetMODELOECFMD5;
    property TIPODESCONTO: string read FTIPODESCONTO write SetTIPODESCONTO;
    property TIPODESCONTOMD5: string read FTIPODESCONTOMD5 write SetTIPODESCONTOMD5;
    property ORDEMAPLICACAO: string read FORDEMAPLICACAO write SetORDEMAPLICACAO;
    property ORDEMAPLICACAOMD5: string read FORDEMAPLICACAOMD5 write SetORDEMAPLICACAOMD5;
    property SATNCFE: string read FSATNCFE write SetSATNCFE;
    property SATSERIAL: string read FSATSERIAL write SetSATSERIAL;
    property SATCHAVECANCELAMENTO: string read FSATCHAVECANCELAMENTO write SetSATCHAVECANCELAMENTO;
    property SATNCFECANCELAMENTO: string read FSATNCFECANCELAMENTO write SetSATNCFECANCELAMENTO;

  end;

implementation

{ TMOV }

procedure TMOV.SetABATIMENTOICMS(const Value: currency);
begin
  FABATIMENTOICMS := Value;
end;

procedure TMOV.SetAPROPRIADO(const Value: SmallInt);
begin
  FAPROPRIADO := Value;
end;

procedure TMOV.SetCAMPOLIVRE1(const Value: string);
begin
  FCAMPOLIVRE1 := Value;
end;

procedure TMOV.SetCAMPOLIVRE2(const Value: string);
begin
  FCAMPOLIVRE2 := Value;
end;

procedure TMOV.SetCAMPOLIVRE3(const Value: string);
begin
  FCAMPOLIVRE3 := Value;
end;

procedure TMOV.SetCARTEIRA(const Value: string);
begin
  FCARTEIRA := Value;
end;

procedure TMOV.SetCCF(const Value: integer);
begin
  FCCF := Value;
end;

procedure TMOV.SetCCFMD5(const Value: string);
begin
  FCCFMD5 := Value;
end;

procedure TMOV.Setcentralizado(const Value: string);
begin
  Fcentralizado := Value;
end;

procedure TMOV.SetCHAPARESP(const Value: string);
begin
  FCHAPARESP := Value;
end;

procedure TMOV.SetCNABBANCO(const Value: string);
begin
  FCNABBANCO := Value;
end;

procedure TMOV.SetCNABCARTEIRA(const Value: string);
begin
  FCNABCARTEIRA := Value;
end;

procedure TMOV.SetCOCXA(const Value: string);
begin
  FCOCXA := Value;
end;

procedure TMOV.SetCODAGENDAMENTO(const Value: integer);
begin
  FCODAGENDAMENTO := Value;
end;

procedure TMOV.SetCODCCUSTO(const Value: string);
begin
  FCODCCUSTO := Value;
end;

procedure TMOV.SetCODCCUSTODESTINO(const Value: string);
begin
  FCODCCUSTODESTINO := Value;
end;

procedure TMOV.SetCODCFO(const Value: string);
begin
  FCODCFO := Value;
end;

procedure TMOV.SetCODCFOAUX(const Value: string);
begin
  FCODCFOAUX := Value;
end;

procedure TMOV.SetCODCFONATUREZA(const Value: string);
begin
  FCODCFONATUREZA := Value;
end;

procedure TMOV.SetCODCOLCFO(const Value: SmallInt);
begin
  FCODCOLCFO := Value;
end;

procedure TMOV.SetCODCOLCFONATUREZA(const Value: SmallInt);
begin
  FCODCOLCFONATUREZA := Value;
end;

procedure TMOV.SetCODCOLCXA(const Value: string);
begin
  FCODCOLCXA := Value;
end;

procedure TMOV.SetCODCOLIGADA(const Value: SmallInt);
begin
  FCODCOLIGADA := Value;
end;

procedure TMOV.SetCODCOLIGADADESTINO(const Value: integer);
begin
  FCODCOLIGADADESTINO := Value;
end;

procedure TMOV.SetCODCPG(const Value: string);
begin
  FCODCPG := Value;
end;

procedure TMOV.SetCODCXA(const Value: string);
begin
  FCODCXA := Value;
end;

procedure TMOV.SetCODDEPARTAMENTO(const Value: string);
begin
  FCODDEPARTAMENTO := Value;
end;

procedure TMOV.SetCODDIARIO(const Value: string);
begin
  FCODDIARIO := Value;
end;

procedure TMOV.SetCODENTREGA(const Value: string);
begin
  FCODENTREGA := Value;
end;

procedure TMOV.SetCODETDMUNSERV(const Value: string);
begin
  FCODETDMUNSERV := Value;
end;

procedure TMOV.SetCODETDPLACA(const Value: string);
begin
  FCODETDPLACA := Value;
end;

procedure TMOV.SetCODEVENTO(const Value: SmallInt);
begin
  FCODEVENTO := Value;
end;

procedure TMOV.SetCODFAIXAENTREGA(const Value: string);
begin
  FCODFAIXAENTREGA := Value;
end;

procedure TMOV.SetCODFILIAL(const Value: SmallInt);
begin
  FCODFILIAL := Value;
end;

procedure TMOV.SetCODFILIALDESTINO(const Value: SmallInt);
begin
  FCODFILIALDESTINO := Value;
end;

procedure TMOV.SetCODFILIALENTREGA(const Value: SmallInt);
begin
  FCODFILIALENTREGA := Value;
end;

procedure TMOV.SetCODFORMAPAGTO(const Value: string);
begin
  FCODFORMAPAGTO := Value;
end;

procedure TMOV.SetCODGERENTE(const Value: string);
begin
  FCODGERENTE := Value;
end;

procedure TMOV.SetCODIGOSERVICO(const Value: string);
begin
  FCODIGOSERVICO := Value;
end;

procedure TMOV.SetCODLAF(const Value: string);
begin
  FCODLAF := Value;
end;

procedure TMOV.SetCODLAFE(const Value: string);
begin
  FCODLAFE := Value;
end;

procedure TMOV.SetCODLOC(const Value: string);
begin
  FCODLOC := Value;
end;

procedure TMOV.SetCODLOCDESTINO(const Value: string);
begin
  FCODLOCDESTINO := Value;
end;

procedure TMOV.SetCODLOCENTREGA(const Value: string);
begin
  FCODLOCENTREGA := Value;
end;

procedure TMOV.SetCODLOCEXP(const Value: string);
begin
  FCODLOCEXP := Value;
end;

procedure TMOV.SetCODLOTE(const Value: integer);
begin
  FCODLOTE := Value;
end;

procedure TMOV.SetCODMEN(const Value: string);
begin
  FCODMEN := Value;
end;

procedure TMOV.SetCODMEN2(const Value: string);
begin
  FCODMEN2 := Value;
end;

procedure TMOV.SetCODMENDESCONTO(const Value: string);
begin
  FCODMENDESCONTO := Value;
end;

procedure TMOV.SetCODMENDESPESA(const Value: string);
begin
  FCODMENDESPESA := Value;
end;

procedure TMOV.SetCODMENFRETE(const Value: string);
begin
  FCODMENFRETE := Value;
end;

procedure TMOV.SetCODMOELANCAMENTO(const Value: string);
begin
  FCODMOELANCAMENTO := Value;
end;

procedure TMOV.SetCODMOEVALORLIQUIDO(const Value: string);
begin
  FCODMOEVALORLIQUIDO := Value;
end;

procedure TMOV.SetCODMUNSERVICO(const Value: string);
begin
  FCODMUNSERVICO := Value;
end;

procedure TMOV.SetCODRPR(const Value: string);
begin
  FCODRPR := Value;
end;

procedure TMOV.SetCODTB1FAT(const Value: string);
begin
  FCODTB1FAT := Value;
end;

procedure TMOV.SetCODTB1FLX(const Value: string);
begin
  FCODTB1FLX := Value;
end;

procedure TMOV.SetCODTB2FAT(const Value: string);
begin
  FCODTB2FAT := Value;
end;

procedure TMOV.SetCODTB2FLX(const Value: string);
begin
  FCODTB2FLX := Value;
end;

procedure TMOV.SetCODTB3FAT(const Value: string);
begin
  FCODTB3FAT := Value;
end;

procedure TMOV.SetCODTB3FLX(const Value: string);
begin
  FCODTB3FLX := Value;
end;

procedure TMOV.SetCODTB4FAT(const Value: string);
begin
  FCODTB4FAT := Value;
end;

procedure TMOV.SetCODTB4FLX(const Value: string);
begin
  FCODTB4FLX := Value;
end;

procedure TMOV.SetCODTB5FAT(const Value: string);
begin
  FCODTB5FAT := Value;
end;

procedure TMOV.SetCODTB5FLX(const Value: string);
begin
  FCODTB5FLX := Value;
end;

procedure TMOV.SetCODTDO(const Value: string);
begin
  FCODTDO := Value;
end;

procedure TMOV.SetCODTMV(const Value: string);
begin
  FCODTMV := Value;
end;

procedure TMOV.SetCODTRA(const Value: string);
begin
  FCODTRA := Value;
end;

procedure TMOV.SetCODTRA2(const Value: string);
begin
  FCODTRA2 := Value;
end;

procedure TMOV.SetCODUSUARIO(const Value: string);
begin
  FCODUSUARIO := Value;
end;

procedure TMOV.SetCODVEN1(const Value: string);
begin
  FCODVEN1 := Value;
end;

procedure TMOV.SetCODVEN2(const Value: string);
begin
  FCODVEN2 := Value;
end;

procedure TMOV.SetCODVEN3(const Value: string);
begin
  FCODVEN3 := Value;
end;

procedure TMOV.SetCODVEN4(const Value: string);
begin
  FCODVEN4 := Value;
end;

procedure TMOV.SetCODVENIMPORTACAO(const Value: string);
begin
  FCODVENIMPORTACAO := Value;
end;

procedure TMOV.SetCOMISSAOREPRES(const Value: currency);
begin
  FCOMISSAOREPRES := Value;
end;

procedure TMOV.SetCONTABILIZADOPORTOTAL(const Value: integer);
begin
  FCONTABILIZADOPORTOTAL := Value;
end;

procedure TMOV.SetCPFCNPJ(const Value: string);
begin
  FCPFCNPJ := Value;
end;

procedure TMOV.SetCPFCNPJMD5(const Value: string);
begin
  FCPFCNPJMD5 := Value;
end;

procedure TMOV.SetCRO(const Value: integer);
begin
  FCRO := Value;
end;

procedure TMOV.SetDATABASEMOV(const Value: TDateTime);
begin
  FDATABASEMOV := Value;
end;

procedure TMOV.SetDATACANCELAMENTO(const Value: TDateTime);
begin
  FDATACANCELAMENTO := Value;
end;

procedure TMOV.SetDATACANCELAMENTOMOV(const Value: TDateTime);
begin
  FDATACANCELAMENTOMOV := Value;
end;

procedure TMOV.SetDATACRIACAO(const Value: TDateTime);
begin
  FDATACRIACAO := Value;
end;

procedure TMOV.SetDATADEDUCAO(const Value: TDateTime);
begin
  FDATADEDUCAO := Value;
end;

procedure TMOV.SetDATAEMISSAO(const Value: TDateTime);
begin
  FDATAEMISSAO := Value;
end;

procedure TMOV.SetDATAEMISSAOMD5(const Value: string);
begin
  FDATAEMISSAOMD5 := Value;
end;

procedure TMOV.SetDATAENTREGA(const Value: TDateTime);
begin
  FDATAENTREGA := Value;
end;

procedure TMOV.SetDATAEXTRA1(const Value: TDateTime);
begin
  FDATAEXTRA1 := Value;
end;

procedure TMOV.SetDATAEXTRA2(const Value: TDateTime);
begin
  FDATAEXTRA2 := Value;
end;

procedure TMOV.SetDATAFECHAMENTO(const Value: TDateTime);
begin
  FDATAFECHAMENTO := Value;
end;

procedure TMOV.SetDATAIMPORTACAO(const Value: TDateTime);
begin
  FDATAIMPORTACAO := Value;
end;

procedure TMOV.SetDATAMOVIMENTO(const Value: TDateTime);
begin
  FDATAMOVIMENTO := Value;
end;

procedure TMOV.SetDATAPROGRAMACAO(const Value: TDateTime);
begin
  FDATAPROGRAMACAO := Value;
end;

procedure TMOV.SetDATARETORNO(const Value: TDateTime);
begin
  FDATARETORNO := Value;
end;

procedure TMOV.SetDATASAIDA(const Value: TDateTime);
begin
  FDATASAIDA := Value;
end;

procedure TMOV.SetDOCIMPRESSO(const Value: SmallInt);
begin
  FDOCIMPRESSO := Value;
end;

procedure TMOV.SetDTHENTREGA(const Value: TDateTime);
begin
  FDTHENTREGA := Value;
end;

procedure TMOV.SetEMITEBOLETA(const Value: string);
begin
  FEMITEBOLETA := Value;
end;

procedure TMOV.SetESPECIE(const Value: string);
begin
  FESPECIE := Value;
end;

procedure TMOV.SetEXPORTADO(const Value: string);
begin
  FEXPORTADO := Value;
end;

procedure TMOV.SetEXPORTADOCANC(const Value: string);
begin
  FEXPORTADOCANC := Value;
end;

procedure TMOV.SetEXPORTADOPV(const Value: string);
begin
  FEXPORTADOPV := Value;
end;

procedure TMOV.SetEXPORTADOREDZ(const Value: string);
begin
  FEXPORTADOREDZ := Value;
end;

procedure TMOV.SetFATIMPRESSA(const Value: SmallInt);
begin
  FFATIMPRESSA := Value;
end;

procedure TMOV.SetFLAGAGRUPADOFLUXUS(const Value: SmallInt);
begin
  FFLAGAGRUPADOFLUXUS := Value;
end;

procedure TMOV.SetFLAGEFEITOSALDO(const Value: SmallInt);
begin
  FFLAGEFEITOSALDO := Value;
end;

procedure TMOV.SetFLAGEXPORFAZENDA(const Value: SmallInt);
begin
  FFLAGEXPORFAZENDA := Value;
end;

procedure TMOV.SetFLAGEXPORFISC(const Value: SmallInt);
begin
  FFLAGEXPORFISC := Value;
end;

procedure TMOV.SetFLAGEXPORTACAO(const Value: SmallInt);
begin
  FFLAGEXPORTACAO := Value;
end;

procedure TMOV.SetFLAGIMPRESSAOFAT(const Value: string);
begin
  FFLAGIMPRESSAOFAT := Value;
end;

procedure TMOV.SetFLAGPROCESSADO(const Value: integer);
begin
  FFLAGPROCESSADO := Value;
end;

procedure TMOV.SetFRETECIFOUFOB(const Value: SmallInt);
begin
  FFRETECIFOUFOB := Value;
end;

procedure TMOV.SetGERADOPORLOTE(const Value: SmallInt);
begin
  FGERADOPORLOTE := Value;
end;

procedure TMOV.SetGEROUFATURA(const Value: SmallInt);
begin
  FGEROUFATURA := Value;
end;

procedure TMOV.SetHORARIOEMISSAO(const Value: TDateTime);
begin
  FHORARIOEMISSAO := Value;
end;

procedure TMOV.SetHORASAIDA(const Value: TDateTime);
begin
  FHORASAIDA := Value;
end;

procedure TMOV.SetHORULTIMAALTERACAO(const Value: TDateTime);
begin
  FHORULTIMAALTERACAO := Value;
end;

procedure TMOV.SetIDAIDF(const Value: SmallInt);
begin
  FIDAIDF := Value;
end;

procedure TMOV.SetIDCLASSMOV(const Value: integer);
begin
  FIDCLASSMOV := Value;
end;

procedure TMOV.SetIDCONTATOCOBRANCA(const Value: integer);
begin
  FIDCONTATOCOBRANCA := Value;
end;

procedure TMOV.SetIDCONTATOENTREGA(const Value: integer);
begin
  FIDCONTATOENTREGA := Value;
end;

procedure TMOV.SetIDFORMAPAGTO(const Value: integer);
begin
  FIDFORMAPAGTO := Value;
end;

procedure TMOV.SetIDLOT(const Value: integer);
begin
  FIDLOT := Value;
end;

procedure TMOV.SetIDLOTEPROCESSO(const Value: integer);
begin
  FIDLOTEPROCESSO := Value;
end;

procedure TMOV.SetIDLOTEPROCESSOREFAT(const Value: integer);
begin
  FIDLOTEPROCESSOREFAT := Value;
end;

procedure TMOV.SetIDMOV(const Value: Integer);
begin
  FIDMOV := Value;
end;

procedure TMOV.SetIDMOVDESTINO(const Value: integer);
begin
  FIDMOVDESTINO := Value;
end;

procedure TMOV.SetIDMOVLCTFLUXUS(const Value: integer);
begin
  FIDMOVLCTFLUXUS := Value;
end;

procedure TMOV.SetIDMOVPEDDESDOBRADO(const Value: integer);
begin
  FIDMOVPEDDESDOBRADO := Value;
end;

procedure TMOV.SetIDMOVPREVENDA(const Value: integer);
begin
  FIDMOVPREVENDA := Value;
end;

procedure TMOV.SetIDMOVRELAC(const Value: integer);
begin
  FIDMOVRELAC := Value;
end;

procedure TMOV.SetIDMOVRM(const Value: integer);
begin
  FIDMOVRM := Value;
end;

procedure TMOV.SetIDNAT(const Value: integer);
begin
  FIDNAT := Value;
end;

procedure TMOV.SetIDNAT2(const Value: integer);
begin
  FIDNAT2 := Value;
end;

procedure TMOV.SetIDOBJOF(const Value: string);
begin
  FIDOBJOF := Value;
end;

procedure TMOV.SetIDPRJ(const Value: integer);
begin
  FIDPRJ := Value;
end;

procedure TMOV.SetIDREDUCAOZ(const Value: integer);
begin
  FIDREDUCAOZ := Value;
end;

procedure TMOV.SetIDSALDOESTOQUE(const Value: integer);
begin
  FIDSALDOESTOQUE := Value;
end;

procedure TMOV.SetINDUSOOBJ(const Value: string);
begin
  FINDUSOOBJ := Value;
end;

procedure TMOV.SetINTEGEREGRADOBONUM(const Value: integer);
begin
  FINTEGEREGRADOBONUM := Value;
end;

procedure TMOV.SetINTEGRADOBONUM(const Value: integer);
begin
  FINTEGRADOBONUM := Value;
end;

procedure TMOV.SetITENSAGRUPADOS(const Value: SmallInt);
begin
  FITENSAGRUPADOS := Value;
end;

procedure TMOV.SetMARCA(const Value: string);
begin
  FMARCA := Value;
end;

procedure TMOV.SetMFADICIONAL(const Value: string);
begin
  FMFADICIONAL := Value;
end;

procedure TMOV.SetMFADICIONALMD5(const Value: string);
begin
  FMFADICIONALMD5 := Value;
end;

procedure TMOV.SetMODELOECF(const Value: string);
begin
  FMODELOECF := Value;
end;

procedure TMOV.SetMODELOECFMD5(const Value: string);
begin
  FMODELOECFMD5 := Value;
end;

procedure TMOV.SetMOVIMPRESSO(const Value: SmallInt);
begin
  FMOVIMPRESSO := Value;
end;

procedure TMOV.SetMULCFIDELIDADE(const Value: currency);
begin
  FMULCFIDELIDADE := Value;
end;

procedure TMOV.SetNAONUMERADO(const Value: string);
begin
  FNAONUMERADO := Value;
end;

procedure TMOV.SetNFCDHRECBTO(const Value: TDateTime);
begin
  FNFCDHRECBTO := Value;
end;

procedure TMOV.SetNFCHAVE(const Value: string);
begin
  FNFCHAVE := Value;
end;

procedure TMOV.SetNFCID(const Value: string);
begin
  FNFCID := Value;
end;

procedure TMOV.SetNFCMOTIVO(const Value: string);
begin
  FNFCMOTIVO := Value;
end;

procedure TMOV.SetNFCNPROT(const Value: string);
begin
  FNFCNPROT := Value;
end;

procedure TMOV.SetNFCNUMEROLOTE(const Value: integer);
begin
  FNFCNUMEROLOTE := Value;
end;

procedure TMOV.SetNFCSERIE(const Value: string);
begin
  FNFCSERIE := Value;
end;

procedure TMOV.SetNFCSTATUS(const Value: integer);
begin
  FNFCSTATUS := Value;
end;

procedure TMOV.SetNFCTIPOEMISSAO(const Value: string);
begin
  FNFCTIPOEMISSAO := Value;
end;

procedure TMOV.SetNFCVERSAOAPLICACAO(const Value: string);
begin
  FNFCVERSAOAPLICACAO := Value;
end;

procedure TMOV.SetNFCXJUST(const Value: string);
begin
  FNFCXJUST := Value;
end;

procedure TMOV.SetNFCXML(const Value: string);
begin
  FNFCXML := Value;
end;

procedure TMOV.SetNFCXMLCANCELAMENTO(const Value: string);
begin
  FNFCXMLCANCELAMENTO := Value;
end;

procedure TMOV.SetNFECHAVE(const Value: string);
begin
  FNFECHAVE := Value;
end;

procedure TMOV.SetNFEINTEGRADO(const Value: integer);
begin
  FNFEINTEGRADO := Value;
end;

procedure TMOV.SetNOMECLIENTE(const Value: string);
begin
  FNOMECLIENTE := Value;
end;

procedure TMOV.SetNOMECLIENTEMD5(const Value: string);
begin
  FNOMECLIENTEMD5 := Value;
end;

procedure TMOV.SetNORDEM(const Value: string);
begin
  FNORDEM := Value;
end;

procedure TMOV.SetNOTAMANUAL(const Value: string);
begin
  FNOTAMANUAL := Value;
end;

procedure TMOV.SetNROSERIE(const Value: string);
begin
  FNROSERIE := Value;
end;

procedure TMOV.Setnroseriemd5(const Value: string);
begin
  Fnroseriemd5 := Value;
end;

procedure TMOV.SetNSEQDATAFECHAMENTO(const Value: SmallInt);
begin
  FNSEQDATAFECHAMENTO := Value;
end;

procedure TMOV.SetNUMERO(const Value: integer);
begin
  FNUMERO := Value;
end;

procedure TMOV.SetNUMEROCAIXA(const Value: integer);
begin
  FNUMEROCAIXA := Value;
end;

procedure TMOV.SetNUMEROCUPOM(const Value: integer);
begin
  FNUMEROCUPOM := Value;
end;

procedure TMOV.SetNUMEROCUPOMMD5(const Value: string);
begin
  FNUMEROCUPOMMD5 := Value;
end;

procedure TMOV.SetNUMEROLCTABERTO(const Value: SmallInt);
begin
  FNUMEROLCTABERTO := Value;
end;

procedure TMOV.SetNUMEROLCTGERADO(const Value: SmallInt);
begin
  FNUMEROLCTGERADO := Value;
end;

procedure TMOV.SetNUMEROMOV(const Value: string);
begin
  FNUMEROMOV := Value;
end;

procedure TMOV.SetNUMERORECIBO(const Value: string);
begin
  FNUMERORECIBO := Value;
end;

procedure TMOV.SetNUMEROTRIBUTOS(const Value: SmallInt);
begin
  FNUMEROTRIBUTOS := Value;
end;

procedure TMOV.SetNUMEROUSUARIO(const Value: string);
begin
  FNUMEROUSUARIO := Value;
end;

procedure TMOV.SetNUMEROUSUARIOMD5(const Value: string);
begin
  FNUMEROUSUARIOMD5 := Value;
end;

procedure TMOV.SetOBSERVACAO(const Value: string);
begin
  FOBSERVACAO := Value;
end;

procedure TMOV.SetORDEMAPLICACAO(const Value: string);
begin
  FORDEMAPLICACAO := Value;
end;

procedure TMOV.SetORDEMAPLICACAOMD5(const Value: string);
begin
  FORDEMAPLICACAOMD5 := Value;
end;

procedure TMOV.SetPAFECF(const Value: string);
begin
  FPAFECF := Value;
end;

procedure TMOV.SetPERCCOMISSAO(const Value: currency);
begin
  FPERCCOMISSAO := Value;
end;

procedure TMOV.SetPERCCOMISSAOVEN2(const Value: currency);
begin
  FPERCCOMISSAOVEN2 := Value;
end;

procedure TMOV.SetPERCENTUALDESC(const Value: currency);
begin
  FPERCENTUALDESC := Value;
end;

procedure TMOV.SetPERCENTUALDESP(const Value: currency);
begin
  FPERCENTUALDESP := Value;
end;

procedure TMOV.SetPERCENTUALEXTRA1(const Value: currency);
begin
  FPERCENTUALEXTRA1 := Value;
end;

procedure TMOV.SetPERCENTUALEXTRA2(const Value: currency);
begin
  FPERCENTUALEXTRA2 := Value;
end;

procedure TMOV.SetPERCENTUALFRETE(const Value: currency);
begin
  FPERCENTUALFRETE := Value;
end;

procedure TMOV.SetPERCENTUALSEGURO(const Value: currency);
begin
  FPERCENTUALSEGURO := Value;
end;

procedure TMOV.SetPESOBRUTO(const Value: currency);
begin
  FPESOBRUTO := Value;
end;

procedure TMOV.SetPESOLIQUIDO(const Value: currency);
begin
  FPESOLIQUIDO := Value;
end;

procedure TMOV.SetPLACA(const Value: string);
begin
  FPLACA := Value;
end;

procedure TMOV.SetPONTOVENDA(const Value: string);
begin
  FPONTOVENDA := Value;
end;

procedure TMOV.SetPONTUADORM(const Value: string);
begin
  FPONTUADORM := Value;
end;

procedure TMOV.SetPRAZOENTREGA(const Value: integer);
begin
  FPRAZOENTREGA := Value;
end;

procedure TMOV.SetPROTOCOLONFE(const Value: string);
begin
  FPROTOCOLONFE := Value;
end;

procedure TMOV.SetPTOCFIDELIDADE(const Value: currency);
begin
  FPTOCFIDELIDADE := Value;
end;

procedure TMOV.SetPVENTREGA(const Value: string);
begin
  FPVENTREGA := Value;
end;

procedure TMOV.SetQUANTIDADE(const Value: integer);
begin
  FQUANTIDADE := Value;
end;

procedure TMOV.SetSATARQUIVOCFE64(const Value: string);
begin
  FSATARQUIVOCFE64 := Value;
end;

procedure TMOV.SetSATASSINATURAQRCODE(const Value: string);
begin
  FSATASSINATURAQRCODE := Value;
end;

procedure TMOV.SetSATCCCC(const Value: integer);
begin
  FSATCCCC := Value;
end;

procedure TMOV.SetSATCHAVECANCELAMENTO(const Value: string);
begin
  FSATCHAVECANCELAMENTO := Value;
end;

procedure TMOV.SetSATCHAVECONSULTA(const Value: string);
begin
  FSATCHAVECONSULTA := Value;
end;

procedure TMOV.SetSATCOD(const Value: integer);
begin
  FSATCOD := Value;
end;

procedure TMOV.SetSATCPFCNPJVALUE(const Value: string);
begin
  FSATCPFCNPJVALUE := Value;
end;

procedure TMOV.SetSATEEEEE(const Value: integer);
begin
  FSATEEEEE := Value;
end;

procedure TMOV.SetSATMENSAGEM(const Value: string);
begin
  FSATMENSAGEM := Value;
end;

procedure TMOV.SetSATMENSAGEMSEFAZ(const Value: string);
begin
  FSATMENSAGEMSEFAZ := Value;
end;

procedure TMOV.SetSATNCFE(const Value: string);
begin
  FSATNCFE := Value;
end;

procedure TMOV.SetSATNCFECANCELAMENTO(const Value: string);
begin
  FSATNCFECANCELAMENTO := Value;
end;

procedure TMOV.SetSATRETORNO(const Value: string);
begin
  FSATRETORNO := Value;
end;

procedure TMOV.SetSATSERIAL(const Value: string);
begin
  FSATSERIAL := Value;
end;

procedure TMOV.SetSATSESSAO(const Value: integer);
begin
  FSATSESSAO := Value;
end;

procedure TMOV.SetSATTIMESTAMP(const Value: TDateTime);
begin
  FSATTIMESTAMP := Value;
end;

procedure TMOV.SetSATVALORTOTALCFE(const Value: currency);
begin
  FSATVALORTOTALCFE := Value;
end;

procedure TMOV.SetSATXML(const Value: string);
begin
  FSATXML := Value;
end;

procedure TMOV.SetSATXMLCANCELAMENTO(const Value: string);
begin
  FSATXMLCANCELAMENTO := Value;
end;

procedure TMOV.SetSEGUNDONUMERO(const Value: string);
begin
  FSEGUNDONUMERO := Value;
end;

procedure TMOV.SetSEQDIARIO(const Value: string);
begin
  FSEQDIARIO := Value;
end;

procedure TMOV.SetSEQDIARIOESTORNO(const Value: string);
begin
  FSEQDIARIOESTORNO := Value;
end;

procedure TMOV.SetSERIE(const Value: string);
begin
  FSERIE := Value;
end;

procedure TMOV.SetSERVICOFISCAL(const Value: string);
begin
  FSERVICOFISCAL := Value;
end;

procedure TMOV.SetSTATUS(const Value: string);
begin
  FSTATUS := Value;
end;

procedure TMOV.SetSTATUSCHEQUE(const Value: SmallInt);
begin
  FSTATUSCHEQUE := Value;
end;

procedure TMOV.SetSTATUSEXPORTCONT(const Value: SmallInt);
begin
  FSTATUSEXPORTCONT := Value;
end;

procedure TMOV.SetSTATUSLIBERACAO(const Value: SmallInt);
begin
  FSTATUSLIBERACAO := Value;
end;

procedure TMOV.SetSTATUSMD5(const Value: string);
begin
  FSTATUSMD5 := Value;
end;

procedure TMOV.SetSTATUSNFE(const Value: string);
begin
  FSTATUSNFE := Value;
end;

procedure TMOV.SetSTATUSORIGRM(const Value: string);
begin
  FSTATUSORIGRM := Value;
end;

procedure TMOV.SetSTATUSSEPARACAO(const Value: string);
begin
  FSTATUSSEPARACAO := Value;
end;

procedure TMOV.SetSTSCOMPRAS(const Value: string);
begin
  FSTSCOMPRAS := Value;
end;

procedure TMOV.SetSTSEMAIL(const Value: integer);
begin
  FSTSEMAIL := Value;
end;

procedure TMOV.SetSUBSERIE(const Value: string);
begin
  FSUBSERIE := Value;
end;

procedure TMOV.SetTBCLOG(const Value: string);
begin
  FTBCLOG := Value;
end;

procedure TMOV.SetTIPO(const Value: string);
begin
  FTIPO := Value;
end;

procedure TMOV.SetTIPOCONSUMO(const Value: SmallInt);
begin
  FTIPOCONSUMO := Value;
end;

procedure TMOV.SetTIPODESCONTO(const Value: string);
begin
  FTIPODESCONTO := Value;
end;

procedure TMOV.SetTIPODESCONTOMD5(const Value: string);
begin
  FTIPODESCONTOMD5 := Value;
end;

procedure TMOV.SetTPNF(const Value: string);
begin
  FTPNF := Value;
end;

procedure TMOV.Settroco(const Value: currency);
begin
  Ftroco := Value;
end;

procedure TMOV.SetUSADESPFINANC(const Value: SmallInt);
begin
  FUSADESPFINANC := Value;
end;

procedure TMOV.SetUSUARIOCRIACAO(const Value: string);
begin
  FUSUARIOCRIACAO := Value;
end;

procedure TMOV.SetUSUARIOCRIACAOMOV(const Value: string);
begin
  FUSUARIOCRIACAOMOV := Value;
end;

procedure TMOV.SetVALORADIANTAMENTO(const Value: currency);
begin
  FVALORADIANTAMENTO := Value;
end;

procedure TMOV.SetVALORBRUTO(const Value: currency);
begin
  FVALORBRUTO := Value;
end;

procedure TMOV.SetVALORBRUTOINTEGERERNO(const Value: currency);
begin
  FVALORBRUTOINTEGERERNO := Value;
end;

procedure TMOV.SetVALORBRUTOINTERNO(const Value: currency);
begin
  FVALORBRUTOINTERNO := Value;
end;

procedure TMOV.SetVALORBRUTOMD5(const Value: string);
begin
  FVALORBRUTOMD5 := Value;
end;

procedure TMOV.SetVALORDESC(const Value: currency);
begin
  FVALORDESC := Value;
end;

procedure TMOV.SetVALORDESCMD5(const Value: string);
begin
  FVALORDESCMD5 := Value;
end;

procedure TMOV.SetVALORDESP(const Value: currency);
begin
  FVALORDESP := Value;
end;

procedure TMOV.SetVALORDESPMD5(const Value: string);
begin
  FVALORDESPMD5 := Value;
end;

procedure TMOV.SetVALOREXTRA1(const Value: currency);
begin
  FVALOREXTRA1 := Value;
end;

procedure TMOV.SetVALOREXTRA2(const Value: currency);
begin
  FVALOREXTRA2 := Value;
end;

procedure TMOV.SetVALORFRETE(const Value: currency);
begin
  FVALORFRETE := Value;
end;

procedure TMOV.SetVALORFRETECTRC(const Value: currency);
begin
  FVALORFRETECTRC := Value;
end;

procedure TMOV.SetVALORLIQUIDO(const Value: currency);
begin
  FVALORLIQUIDO := Value;
end;

procedure TMOV.SetVALORLIQUIDOMD5(const Value: string);
begin
  FVALORLIQUIDOMD5 := Value;
end;

procedure TMOV.SetVALOROUTROS(const Value: currency);
begin
  FVALOROUTROS := Value;
end;

procedure TMOV.SetVALORRECEBIDO(const Value: currency);
begin
  FVALORRECEBIDO := Value;
end;

procedure TMOV.SetVALORSEGURO(const Value: currency);
begin
  FVALORSEGURO := Value;
end;

procedure TMOV.SetVERIFICADO(const Value: string);
begin
  FVERIFICADO := Value;
end;

procedure TMOV.SetVIADETRANSPORTE(const Value: string);
begin
  FVIADETRANSPORTE := Value;
end;

procedure TMOV.SetVINCULADOESTOQUEFL(const Value: integer);
begin
  FVINCULADOESTOQUEFL := Value;
end;

end.
