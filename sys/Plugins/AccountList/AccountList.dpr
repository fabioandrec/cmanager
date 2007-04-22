library AccountList;

{$R *.res}

uses
  Windows,
  Dialogs,
  AdoInt,
  Forms,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas';

var CManInterface: ICManagerInterface;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_HTMLREPORT);
    SetCaption('Zestawienie kont');
    SetDescription('Wyœwietla zestawienie kont');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
var xObject: OleVariant;
begin
  VarClear(Result);
  xObject := CManInterface.GetConnection;
  ShowMessage(xObject.ConnectionString);
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
