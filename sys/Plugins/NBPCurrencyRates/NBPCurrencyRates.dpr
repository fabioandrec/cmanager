library NBPCurrencyRates;

{$R *.res}

uses
  MsXml,
  Windows,
  Controls,
  Messages,
  Forms,
  SysUtils,
  CPluginConsts in '..\CPluginConsts.pas',
  CPluginTypes in '..\CPluginTypes.pas',
  CXml in '..\..\Shared\CXml.pas',
  NBPCurrencyRatesConfigFormUnit in 'NBPCurrencyRatesConfigFormUnit.pas' {NBPCurrencyRatesConfigForm},
  NBPCurrencyRatesProgressFormUnit in 'NBPCurrencyRatesProgressFormUnit.pas' {NBPCurrencyRatesProgressForm},
  CHttpRequest in '..\..\Shared\CHttpRequest.pas',
  CRichtext in '..\..\Shared\CRichtext.pas';

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
    if AnsiUpperCase(Copy(xConfiguration, 1, 2)) = 'F;' then begin
      xForm.ComboBoxSource.ItemIndex := 1;
    end else begin
      xForm.ComboBoxSource.ItemIndex := 0;
    end;
    xForm.EditName.Text := Copy(xConfiguration, 3, Length(xConfiguration) - 2);
    xForm.ComboBoxSourceChange(xForm.ComboBoxSource);
  end;
  if xForm.ShowModal = mrOk then begin
    if xForm.ComboBoxSource.ItemIndex = 0 then begin
      xConfiguration := 'N;';
    end else begin
      xConfiguration := 'F;';
    end;
    GCManagerInterface.SetConfiguration(xConfiguration + xForm.EditName.Text);
    Result := True;
  end;
  xForm.Free;
end;

exports
  Plugin_Initialize,
  Plugin_Configure,
  Plugin_Execute;
end.
