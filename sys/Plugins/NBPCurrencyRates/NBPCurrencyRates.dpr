library NBPCurrencyRates;

{$R *.res}

uses
  MsXml,
  Windows,
  CPluginConsts in '..\CPluginConsts.pas',
  CXml in '..\..\CXml.pas';

function Plugin_Execute(AXml: IXMLDOMDocument): Boolean; stdcall; export;
begin
  Result := True;
end;

procedure Plugin_Info(AXml: IXMLDOMDocument); stdcall; export
begin
  SetXmlAttribute('type', AXml.documentElement, CPLUGINTYPE_CURRENCYRATE);
  SetXmlAttribute('description', AXml.documentElement, 'Pobieranie œrednich kursów walut z NBP');
end;

function Plugin_Configure(AXml: IXMLDOMDocument): Boolean; stdcall; export;
begin
  MessageBox(0, 'Ta wtyczka nie ma nic do konfigurowania', 'Informacja', MB_OK + MB_ICONINFORMATION);
  SetXmlAttribute('configuration', AXml.documentElement, GetXmlAttribute('configuration', AXml.documentElement, '') + '_test');
  Result := True;
end;

exports
  Plugin_Configure,
  Plugin_Execute,
  Plugin_Info;
end.
 