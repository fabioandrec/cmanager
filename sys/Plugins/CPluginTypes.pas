unit CPluginTypes;

interface

uses MsXml, Windows;

type
  TCPlugin_Configure = function (AXml: IXMLDOMDocument): Boolean; stdcall;
  TCPlugin_Icon = function: HICON; stdcall;
  TCPlugin_Execute = function (AXml: IXMLDOMDocument): Boolean; stdcall;
  TCPlugin_Initialize = function (AAppHandle: HWND): Boolean; stdcall;
  TCPlugin_Finalize = procedure; stdcall;
  TCPlugin_Info = procedure (AXml: IXMLDOMDocument); stdcall;

implementation

end.
