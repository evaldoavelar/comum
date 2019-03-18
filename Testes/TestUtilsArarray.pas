unit TestUtilsArarray;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, Utils.ArrayUtil;

type
  // Test methods for class TArrayUtil

  TestTArrayUtil = class(TTestCase)
  strict private

  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAppend;
    procedure TestAppend1;
  end;

implementation

procedure TestTArrayUtil.SetUp;
begin

end;

procedure TestTArrayUtil.TearDown;
begin

end;

procedure TestTArrayUtil.TestAppend;
var
  array1: TArray<Integer>;
  array2: TArray<Integer>;
begin

  SetLength(array1, 5);
  array1[0] := 1;
  array1[1] := 2;
  array1[2] := 3;
  array1[3] := 4;
  array1[4] := 5;

  SetLength(array2, 5);
  array2[0] := 6;
  array2[1] := 7;
  array2[2] := 8;
  array2[3] := 9;
  array2[4] := 10;

  // TODO: Setup method call parameters

  TArrayUtil<Integer>.Append(array1, array2);


  // TODO: Validate method results

  CheckEquals(Length(array1), 10);
  CheckEquals(array1[5], 6);
  CheckEquals(array1[6], 7);
  CheckEquals(array1[7], 8);
  CheckEquals(array1[8], 9);
  CheckEquals(array1[9], 10);

end;

procedure TestTArrayUtil.TestAppend1;
var
  array1: TArray<Integer>;
begin
  // TODO: Setup method call parameters
  SetLength(array1, 5);
  array1[0] := 1;
  array1[1] := 2;
  array1[2] := 3;
  array1[3] := 4;
  array1[4] := 5;

  TArrayUtil<Integer>.Append(array1, 6);

  CheckEquals(Length(array1), 6);
   CheckEquals(array1[5], 6);
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTArrayUtil.Suite);

end.
