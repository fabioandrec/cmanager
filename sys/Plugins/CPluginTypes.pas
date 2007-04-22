unit CPluginTypes;

interface

uses Windows;

type
  ICManagerInterface = interface
    function GetName: OleVariant;
    function GetVersion: OleVariant;
    function GetConnection: OleVariant;
    function GetDatafilename: OleVariant;
    function GetWorkdate: OleVariant;
    function GetAppHandle: HWND;
    function GetConfiguration: OleVariant;
    procedure SetConfiguration(AConfigurationBuffer: OleVariant);
    procedure SetType(AType: Integer);
    procedure SetDescription(ADescription: OleVariant);
    procedure SetCaption(ACaption: OleVariant);
    function GetReportText: OleVariant;
    function GetReportCss: OleVariant;
  end;

  TCPlugin_Configure = function: Boolean; stdcall;
  TCPlugin_Execute = function: OleVariant; stdcall;
  TCPlugin_Initialize = function (ACManagerInterface: ICManagerInterface): Boolean; stdcall;
  TCPlugin_Finalize = procedure; stdcall;

implementation

end.
