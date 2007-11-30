unit DataobjectTests;

interface

uses TestFrameWork, TestExtensions, GUITestRunner;

type
  TTestCase_CreateDatabase = class(TTestCase)
  protected
    procedure TearDown; override;
    procedure SetUp; override;
  end;

implementation

uses CDatatools, CDatabase, CAdox;

procedure TTestCase_CreateDatabase.SetUp;
begin
end;

procedure TTestCase_CreateDatabase.TearDown;
begin
end;

initialization
  RegisterTest('', TTestCase_CreateDatabase.Suite);
end.
