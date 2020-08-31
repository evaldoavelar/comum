unit Model.Atributos.Tipos;

interface

type


  TTipoCampo = (tpNull, tpSMALLINT, tpINTEGER, tpBIGINT, tpDECIMAL, tpNUMERIC, tpFLOAT, tpDOUBLE, tpDATE, tpTIME, tpTIMESTAMP, tpCHAR, tpVARCHAR, tpBLOB,tpBIT,tpXML, tpJSON, tpNVARCHAR);
  TSortingOrder = (NoSort, Ascending, Descending);
  TSequenceType = (NotInc, AutoInc, TableInc, GuidInc);
  TRuleAction = (None, Cascade, SetNull, SetDefault);

   TTipoCampoDesc = record helper for TTipoCampo
      function ToString:string;
   end;


implementation

{ TTipoCampoDesc }

function TTipoCampoDesc.ToString: string;

begin
   case self of
     tpNull: result := 'null' ;
     tpSMALLINT: result := 'SMALLINT';
     tpINTEGER: result := 'INTEGER' ;
     tpBIGINT: result := 'BIGINT';
     tpDECIMAL: result := 'DECIMAL';
     tpNUMERIC: result := 'NUMERIC';
     tpFLOAT: result := 'FLOAT';
     tpDOUBLE: result := 'DOUBLE';
     tpDATE: result := 'DATE';
     tpTIME: result := 'TIME';
     tpTIMESTAMP: result := 'TIMESTAMP';
     tpCHAR: result := 'CHAR';
     tpVARCHAR: result := 'VARCHAR';
     tpBLOB: result := 'BLOB';
     tpBIT : result := 'BIT';
     tpXML : result := 'XML';
     tpJSON : result := 'JSON';
     tpNVARCHAR : result := 'NVARCHAR';
   end;
end;

end.
