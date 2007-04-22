library AccountList;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  SysUtils,
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
    xCss: String;
begin
  VarClear(Result);
  xObject := CManInterface.GetConnection;
  if not VarIsEmpty(xObject) then begin
    Result := CManInterface.GetReportText;
    xCss := CManInterface.GetReportCss;
    Result := StringReplace(Result, '[repstyle]', xCss, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '[repfooter]', CManInterface.GetName + ' wer. ' + CManInterface.GetVersion + ', ' + DateTimeToStr(Now), [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '[reptitle]', 'Zestawienie kont', [rfReplaceAll, rfIgnoreCase]);
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
