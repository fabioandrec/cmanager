library DBStats;

{$R *.res}

uses
  Windows,
  MsXml,
  ShellApi,
  Dialogs,
  AdoInt,
  Forms,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CXml in '..\..\CXml.pas';

var CManInterface: ICManagerInterface;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  Application.Handle := ACManagerInterface.GetAppHandle;
  CManInterface := ACManagerInterface;
  Result := True;
end;

function Plugin_Execute(AXml: IXMLDOMDocument): Boolean; stdcall; export;
var xObject: Connection;
begin
  Result := True;
  xObject := Connection(CManInterface.GetConnection);
  ShowMessage(xObject.ConnectionString);
end;

procedure Plugin_Info(AXml: IXMLDOMDocument); stdcall; export
begin
  SetXmlAttribute('type', AXml.documentElement, CPLUGINTYPE_JUSTEXECUTE);
  SetXmlAttribute('description', AXml.documentElement, 'Pokazuje informacje o pliku danych');
  SetXmlAttribute('menu', AXml.documentElement, 'Poka¿ informacje o pliku danych');
end;

exports
  Plugin_Initialize,
  Plugin_Execute,
  Plugin_Info;
end.
