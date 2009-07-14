library ShowAccountList;

{$R *.res}

uses
  Windows,
  Variants,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas';

var GCmanagerInterface: ICManagerInterface;

function Plugin_Execute: OleVariant; stdcall; export;
var xResult: OleVariant;
begin
  xResult := GCmanagerInterface.ShowDataobjectFrame(CFRAMETYPE_ACCOUNTSFRAME);
  if VarIsEmpty(xResult) then begin
    GCmanagerInterface.ShowDialogBox('Nie wybrano ¿adnego obiektu', CDIALOGBOX_INFO);
  end else begin
    GCmanagerInterface.ShowDialogBox('Wybrano obiekt o id = ' + xResult, CDIALOGBOX_INFO);
  end;
end;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  GCmanagerInterface := ACManagerInterface;
  with ACManagerInterface do begin
    SetType(CPLUGINTYPE_JUSTEXECUTE);
    SetCaption('Poka¿ listê kont');
    SetDescription('Pokazuje listê kont');
  end;
  Result := True;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
