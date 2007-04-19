library NBPCurrencyRates;

{$R *.res}

uses
  MsXml,
  Windows,
  Controls,
  Messages,
  Forms,
  CPluginConsts in '..\CPluginConsts.pas',
  CPluginTypes in '..\CPluginTypes.pas',
  CXml in '..\..\CXml.pas',
  NBPCurrencyRatesConfigFormUnit in 'NBPCurrencyRatesConfigFormUnit.pas' {NBPCurrencyRatesConfigForm},
  NBPCurrencyRatesProgressFormUnit in 'NBPCurrencyRatesProgressFormUnit.pas' {NBPCurrencyRatesProgressForm},
  CHttpRequest in '..\..\CHttpRequest.pas',
  CRichtext in '..\..\CRichtext.pas';

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  GCManagerInterface := ACManagerInterface;
  with GCManagerInterface do begin
    SetType(CPLUGINTYPE_CURRENCYRATE);
    SetCaption('Pobierz œrednie kursy walut NBP');
    SetDescription('Pobieranie œrednich kursów walut z NBP');
    Application.Handle := GetAppHandle;
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
begin
  NBPCurrencyRatesProgressForm := TNBPCurrencyRatesProgressForm.Create(Application);
  NBPCurrencyRatesProgressForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  Result := NBPCurrencyRatesProgressForm.RetriveCurrencyRates;
  NBPCurrencyRatesProgressForm.Free;
end;

function Plugin_Configure: Boolean; stdcall; export;
var xForm: TNBPCurrencyRatesConfigForm;
    xConfiguration: String;
begin
  Result := False;
  xForm := TNBPCurrencyRatesConfigForm.Create(Application);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  xConfiguration := GCManagerInterface.GetConfiguration;
  if xConfiguration <> '' then begin
    xForm.EditName.Text := xConfiguration;
  end;
  if xForm.ShowModal = mrOk then begin
    GCManagerInterface.SetConfiguration(xForm.EditName.Text);
    Result := True;
  end;
  xForm.Free;
end;

exports
  Plugin_Initialize,
  Plugin_Configure,
  Plugin_Execute;
end.
