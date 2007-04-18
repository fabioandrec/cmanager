library RunCalc;

{$R *.res}

uses
  Windows,
  MsXml,
  ShellApi,
  CPluginConsts in '..\CPluginConsts.pas',
  CXml in '..\..\CXml.pas';

function Plugin_Execute(AXml: IXMLDOMDocument): Boolean; stdcall; export;
begin
  Result := ShellExecute(0, 'open', 'calc.exe', Nil, Nil, SW_NORMAL) > 32;
end;

procedure Plugin_Info(AXml: IXMLDOMDocument); stdcall; export
begin
  SetXmlAttribute('type', AXml.documentElement, CPLUGINTYPE_JUSTEXECUTE);
  SetXmlAttribute('description', AXml.documentElement, 'Uruchamia kalkulator');
  SetXmlAttribute('menu', AXml.documentElement, 'Uruchom kalkulator');
end;

exports
  Plugin_Execute,
  Plugin_Info;
end.
