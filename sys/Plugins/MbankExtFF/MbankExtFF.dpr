library MbankExtFF;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  SysUtils,
  Classes,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CTools in '..\..\Shared\CTools.pas';

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
begin
  VarClear(Result);
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
