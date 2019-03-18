unit Exceptions;

interface

uses System.sysutils;

type

  TCalculoException = class(Exception);

  TValidacaoException = class(Exception);

  TDaoException = class(Exception);

  TConectionException = class(Exception);

  TAtualizacaoException = class(Exception);

implementation

end.
