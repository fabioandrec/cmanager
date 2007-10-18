library Metastock;

{$R *.res}
{$R 'Default.res' 'Default.rc'}

uses
  Windows,
  Controls,
  Messages,
  Forms,
  SysUtils,
  CPluginConsts in '..\CPluginConsts.pas',
  CPluginTypes in '..\CPluginTypes.pas',
  CXmlTlb in '..\..\Shared\CXmlTlb.pas',
  CXml in '..\..\Shared\CXml.pas',
  CHttpRequest in '..\..\Shared\CHttpRequest.pas',
  CTools in '..\..\Shared\CTools.pas',
  CRichtext in '..\..\Shared\CRichtext.pas',
  MetastockConfigFormUnit in 'MetastockConfigFormUnit.pas' {MetastockConfigForm},
  CBase64 in '..\..\Shared\CBase64.pas',
  MetastockEditFormUnit in 'MetastockEditFormUnit.pas' {MetastockEditForm},
  CBasics in '..\..\Shared\CBasics.pas',
  MetastockProgressFormUnit in 'MetastockProgressFormUnit.pas' {MetastockProgressForm};

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  GCManagerInterface := ACManagerInterface;
  with GCManagerInterface do begin
    SetType(CPLUGINTYPE_CURRENCYRATE);
    SetCaption('Pobierz notowania GPW');
    SetDescription('Pobieranie notowañ GPW w formacie Metastock');
    Application.Handle := GetAppHandle;
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
begin
  MetastockProgressForm := TMetastockProgressForm.Create(Application);
  MetastockProgressForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  Result := MetastockProgressForm.RetriveStockExchanges;
  MetastockProgressForm.Free;
end;

function Plugin_Configure: Boolean; stdcall; export;
var xForm: TMetastockConfigForm;
    xXml: ICXMLDOMDocument;
    xError: String;
    xConfigurationDecoded, xConfigurationEncoded: String;
begin
  Result := False;
  xForm := TMetastockConfigForm.Create(Application);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  xXml := TMetastockConfigForm.GetConfigurationAsXml(GCManagerInterface.GetConfiguration, xError);
  if (xXml = Nil) or (xError <> '') then begin
    GCManagerInterface.ShowDialogBox(xError, CDIALOGBOX_WARNING);
  end;
  xForm.SetConfigXml(xXml);
  if xForm.ShowModal = mrOk then begin
    xConfigurationDecoded := xForm.GetConfigXml;
    EncodeBase64Buffer(xConfigurationDecoded, xConfigurationEncoded);
    GCManagerInterface.SetConfiguration(xConfigurationEncoded);
    Result := True;
  end;
  xXml := Nil;
  xForm.Free;
end;

exports
  Plugin_Initialize,
  Plugin_Configure,
  Plugin_Execute;
end.
