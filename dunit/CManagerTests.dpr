program CManagerTests;

uses
  Forms,
  TestFramework,
  TestExtensions,
  GUITestRunner,
  DataobjectTests in 'DataobjectTests.pas',
  CDatabase in '..\sys\CDatabase.pas',
  CPluginTypes in '..\sys\Plugins\CPluginTypes.pas',
  CPluginConsts in '..\sys\Plugins\CPluginConsts.pas',
  CDatatools in '..\sys\CDatatools.pas',
  CAdox in '..\sys\CAdox.pas';

begin
  Application.Initialize;
  TGUITestRunner.runRegisteredTests;
end.
