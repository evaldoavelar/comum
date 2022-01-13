unit Dao.IDataSet;

interface

uses
  Data.DB, System.Rtti, System.SysUtils;

type

  IDaoDataSet<T: class> = interface
    ['{262A20B9-D025-41E0-8BAE-9E7345A0B4B4}']
    function DataSetToObject(ds: TDataSet): T;
    function CreateInstance: T;
  end;

implementation

end.
