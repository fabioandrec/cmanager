unit CPlugins;

interface

uses Forms, Windows, CPluginConsts, CPluginTypes, Contnrs, MsXml;

type
  TCPlugin = class(TObject)
  private
    FFilename: String;
    FHandle: THandle;
    FIcon: HICON;
    FPlugin_Configure: TCPlugin_Configure;
    FPlugin_Icon: TCPlugin_Icon;
    FPlugin_Execute: TCPlugin_Execute;
    FPlugin_Initialize: TCPlugin_Initialize;
    FPlugin_Finalize: TCPlugin_Finalize;
    FPlugin_Info: TCPlugin_Info;
    FInfo: IXMLDOMDocument;
    FPluginType: Byte;
    function GetInfo: IXMLDOMDocument;
  public
    constructor Create(AFilename: String);
    function LoadAndInitialize: Boolean;
    procedure FinalizeAndUnload;
    destructor Destroy; override;
  published
    property Info: IXMLDOMDocument read GetInfo;
  end;

  TCPluginList = class(TObjectList)
  private
    FPluginPath: String;
  public
    constructor Create(APath: String);
    procedure ScanForPlugins;
  end;

var GPlugins: TCPluginList;

implementation

uses SysUtils, CTools, CXml;

function GetBaseXml: IXMLDOMDocument;
var xRoot: IXMLDOMNode;
begin
  Result := CoDOMDocument.Create;
  xRoot := Result.createElement('cplugin');
  Result.appendChild(xRoot);
end;

constructor TCPlugin.Create(AFilename: String);
begin
  inherited Create;
  FFilename := AFilename;
  FHandle := 0;
  FInfo := Nil;
end;

destructor TCPlugin.Destroy;
begin
  FinalizeAndUnload;
  inherited Destroy;
end;

procedure TCPlugin.FinalizeAndUnload;
begin
  if FHandle <> 0 then begin
    FPlugin_Finalize;
    FreeLibrary(FHandle);
    FHandle := 0;
  end;
end;

function TCPlugin.GetInfo: IXMLDOMDocument;
begin
  if FInfo = Nil then begin
    FInfo := GetBaseXml;
    FPlugin_Info(FInfo);
  end;
  Result := FInfo;
end;

function TCPlugin.LoadAndInitialize: Boolean;
var xInfo: IXMLDOMDocument;
begin
  FHandle := LoadLibrary(PChar(FFilename));
  Result := FHandle <> 0;
  if Result then begin
    @FPlugin_Configure := GetProcAddress(FHandle, 'Plugin_Configure');
    @FPlugin_Icon := GetProcAddress(FHandle, 'Plugin_Icon');
    @FPlugin_Execute := GetProcAddress(FHandle, 'Plugin_Execute');
    @FPlugin_Initialize := GetProcAddress(FHandle, 'Plugin_Initialize');
    @FPlugin_Finalize := GetProcAddress(FHandle, 'Plugin_Finalize');
    @FPlugin_Info := GetProcAddress(FHandle, 'Plugin_Info');
    Result := (@FPlugin_Configure <> Nil) and (@FPlugin_Icon <> Nil) and (@FPlugin_Execute <> Nil) and
              (@FPlugin_Initialize <> Nil) and (@FPlugin_Finalize <> Nil) and (@FPlugin_Info <> Nil);
    if Result then begin
      Result := FPlugin_Initialize(Application.MainForm.Handle);
      if Result then begin
        xInfo := Info;
        FPluginType := GetXmlAttribute('pluginType', xInfo.documentElement, -1);
        if FPluginType = CPLUGINTYPE_CURRENCYRATE then begin
          FIcon := FPlugin_Icon;
        end else begin
          Result := False;
        end;
      end;
    end;
    if not Result then begin
      FreeLibrary(FHandle);
      FHandle := 0;
    end;
  end;
end;

constructor TCPluginList.Create(APath: String);
begin
  inherited Create(True);
  FPluginPath := IncludeTrailingPathDelimiter(ExpandFileName(APath));
end;

procedure TCPluginList.ScanForPlugins;
var xS: WIN32_FIND_DATA;
    xHandle: THandle;
    xRes: Boolean;
    xPlugin: TCPlugin;
begin
  xHandle := FindFirstFile(PChar(FPluginPath + '*.dll'), xS);
  if xHandle <> INVALID_HANDLE_VALUE then begin
    repeat
      xPlugin := TCPlugin.Create(FPluginPath + xS.cFileName);
      if xPlugin.LoadAndInitialize then begin
        Add(xPlugin);
      end else begin
        xPlugin.Free;
      end;
      xRes := FindNextFile(xHandle, xS);
    until not xRes;
  end;
  Windows.FindClose(xHandle);
end;

initialization
  GPlugins := TCPluginList.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Wtyczki');
finalization
  GPlugins.Free;
end.
