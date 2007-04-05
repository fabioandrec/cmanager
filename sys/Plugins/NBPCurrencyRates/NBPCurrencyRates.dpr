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

exports
  Plugin_Execute,
  Plugin_Info;
end.
 