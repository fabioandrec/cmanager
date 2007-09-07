library SqlConsole;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  SysUtils,
  Classes,
  AdoInt,
  Messages,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CTools in '..\..\Shared\CTools.pas',
  SqlConsoleFormUnit in 'SqlConsoleFormUnit.pas' {SqlConsoleForm},
  CRichtext in '..\..\Shared\CRichtext.pas',
  CAdotools in '..\..\Shared\CAdotools.pas',
  CXml in '..\..\Shared\CXml.pas';

var CManInterface: ICManagerInterface;
    CConnection: _Connection;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_JUSTEXECUTE);
    SetCaption('Konsola Sql');
    SetDescription('Konsola Sql');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
begin
  VarClear(Result);
  CConnection := CManInterface.GetConnection as _Connection;
  if CConnection <> Nil then begin
    SqlConsoleForm := TSqlConsoleForm.Create(Nil);
    SqlConsoleForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
    SqlConsoleForm.Connection := CConnection;
    SqlConsoleForm.ShowModal;
    SqlConsoleForm.Free;
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
