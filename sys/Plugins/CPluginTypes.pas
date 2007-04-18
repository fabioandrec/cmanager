unit CPluginTypes;

interface

uses MsXml, Windows;

type
  ICManagerInterface = interface
    function GetConnection: Pointer;
    function GetAppHandle: HWND;
    function GetConfiguration(AConfigurationBuffer: PAnsiChar; ABufferSize: Integer): Integer;
    procedure SetConfiguration(AConfigurationBuffer: PAnsiChar);
  end;

  TCPlugin_Configure = function (AXml: IXMLDOMDocument): Boolean; stdcall;
  TCPlugin_Execute = function (AXml: IXMLDOMDocument): Boolean; stdcall;
  TCPlugin_Initialize = function (ACManagerInterface: ICManagerInterface): Boolean; stdcall;
  TCPlugin_Finalize = procedure; stdcall;
  TCPlugin_Info = procedure (AXml: IXMLDOMDocument); stdcall;

implementation

end.
