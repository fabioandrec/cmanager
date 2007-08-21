library MbankExtFF;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  Messages,
  SysUtils,
  Classes,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CTools in '..\..\Shared\CTools.pas',
  MbankExtFFFormUnit in 'MbankExtFFFormUnit.pas' {MbankExtFFForm},
  CXml in '..\..\Shared\CXml.pas';

var CManInterface: ICManagerInterface;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_EXTRACTION);
    SetCaption('Importuj wyci¹g mBanku z pliku');
    SetDescription('Importuje wyci¹g mBanku z pliku');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
var xForm: TMbankExtFFForm;
begin
  VarClear(Result);
  xForm := TMbankExtFFForm.Create(Nil);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  if xForm.ShowModal = ID_OK then begin
    Result := xForm.ExtOutput;
  end;
  xForm.Free;
end;

procedure Plugin_About; stdcall; export;
var xInfo: String;
begin
  xInfo := 'MbankExtFF - wtyczka pozalaj¹ca wczytywaæ wyci¹gi z mBanku' + sLineBreak +
           'Dostêpne formaty wyci¹gów to csv i html z rachunków i kart kredytowych';
  CManInterface.ShowDialogBox(xInfo, CDIALOGBOX_INFO);
end;

exports
  Plugin_Initialize,
  Plugin_Execute,
  Plugin_About;
end.
