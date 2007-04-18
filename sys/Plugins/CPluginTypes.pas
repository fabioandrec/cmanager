unit CPluginTypes;

interface

uses MsXml, Windows;

type
  TCManager_GetObject = function (AObjectName: PChar): Pointer; stdcall;
  TCPlugin_Configure = function (AXml: IXMLDOMDocument): Boolean; stdcall;
  TCPlugin_Execute = function (AXml: IXMLDOMDocument): Boolean; stdcall;
  TCPlugin_Initialize = function (AAppHandle: HWND; AGetObjectDelegate: TCManager_GetObject): Boolean; stdcall;
  TCPlugin_Finalize = procedure; stdcall;
  TCPlugin_Info = procedure (AXml: IXMLDOMDocument); stdcall;

implementation

end.
