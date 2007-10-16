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
  MetastockEditFormUnit in 'MetastockEditFormUnit.pas' {MetastockEditForm};

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
  VarClear(Result);
end;

function Plugin_Configure: Boolean; stdcall; export;
var xForm: TMetastockConfigForm;
    xConfigurationEncoded, xConfigurationDecoded: String;
    xXml: ICXMLDOMDocument;
begin
  Result := False;
  xForm := TMetastockConfigForm.Create(Application);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  xConfigurationEncoded := GCManagerInterface.GetConfiguration;
  xXml := Nil;
  if xConfigurationEncoded <> '' then begin
    if not DecodeBase64Buffer(xConfigurationEncoded, xConfigurationDecoded) then begin
      xConfigurationDecoded := '';
      GCManagerInterface.ShowDialogBox('Nie uda³o siê odczytaæ konfiguracji wtyczki. Przyjêto konfiguracjê domyœln¹', CDIALOGBOX_WARNING);
    end else begin
      xXml := GetDocumentFromString(xConfigurationDecoded, Nil);
      if xXml <> Nil then begin
        if xXml.parseError.errorCode <> 0 then begin
          GCManagerInterface.ShowDialogBox('Konfiguracja wtyczki jest niepoprawna. Przyjêto konfiguracjê domyœln¹', CDIALOGBOX_WARNING);
          xXml := Nil;
        end;
      end else begin
        GCManagerInterface.ShowDialogBox('Konfiguracja wtyczki jest niepoprawna. Przyjêto konfiguracjê domyœln¹', CDIALOGBOX_WARNING);
      end;
    end;
  end;
  if (xConfigurationDecoded = '') or (xXml = Nil) then begin
    xConfigurationDecoded := GetStringFromResources('DEFAULTXML');
    xXml := GetDocumentFromString(xConfigurationDecoded, Nil);
    if xXml.parseError.errorCode <> 0 then begin
      GCManagerInterface.ShowDialogBox('Konfiguracja wtyczki jest niepoprawna', CDIALOGBOX_WARNING);
      xXml := Nil;
    end;
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
