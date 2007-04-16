unit CPlugins;

interface

uses Forms, Windows, CPluginConsts, CPluginTypes, Contnrs, MsXml, CComponents;

type
  TCPlugin = class(TCDataListElementObject)
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
    FpluginType: Integer;
    FpluginDescription: String;
    FpluginConfiguration: String;
    FpluginMenu: String;
    function GetisConfigurable: Boolean;
  public
    constructor Create(AFilename: String);
    function LoadAndInitialize: Boolean;
    procedure FinalizeAndUnload;
    destructor Destroy; override;
    function Configure(AIn: String; var AOut: String): Boolean;
    function Execute(AConfiguration: String; var AOutput: String): Boolean;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
  published
    property fileName: String read FFilename;
    property pluginType: Integer read FpluginType;
    property pluginDescription: String read FpluginDescription;
    property pluginMenu: String read FpluginMenu;
    property pluginConfiguration: String read FpluginConfiguration write FpluginConfiguration;
    property isConfigurable: Boolean read GetisConfigurable;
  end;

  TCPluginList = class(TObjectList)
  private
    FPluginPath: String;
  public
    constructor Create(APath: String);
    procedure ScanForPlugins;
    function GetCurrencyRatePluginCount: Integer;
  end;

var GPlugins: TCPluginList;
    GPluginlogfile: String = '';

implementation

uses SysUtils, CTools, CXml;

function GetBasePluginXml: IXMLDOMDocument;
var xRoot: IXMLDOMNode;
begin
  Result := GetXmlDocument;
  xRoot := Result.createElement('plugin');
  Result.appendChild(xRoot);
end;

function TCPlugin.Configure(AIn: String; var AOut: String): Boolean;
var xXml: IXMLDOMDocument;
begin
  AOut := AIn;
  xXml := GetBasePluginXml;
  SetXmlAttribute('configuration', xXml.documentElement, AIn);
  SaveToLog('Wejœciowe dane procedury Plugin_Configure ' + GetStringFromDocument(xXml), GPluginlogfile);
  Result := FPlugin_Configure(xXml);
  if Result then begin
    AOut := GetXmlAttribute('configuration', xXml.documentElement, AIn);
    SaveToLog('Wyjœciowe dane procedury Plugin_Configure ' + GetStringFromDocument(xXml), GPluginlogfile);
  end;
end;

constructor TCPlugin.Create(AFilename: String);
begin
  inherited Create;
  FFilename := AFilename;
  FHandle := 0;
  FIcon := 0;
end;

destructor TCPlugin.Destroy;
begin
  FinalizeAndUnload;
  inherited Destroy;
end;

function TCPlugin.Execute(AConfiguration: String; var AOutput: String): Boolean;
var xXml: IXMLDOMDocument;
begin
  AOutput := '';
  xXml := GetBasePluginXml;
  SetXmlAttribute('configuration', xXml.documentElement, AConfiguration);
  SaveToLog('Wejœciowe dane procedury Plugin_Execute ' + GetStringFromDocument(xXml), GPluginlogfile);
  Result := FPlugin_Execute(xXml);
  if Result then begin
    AOutput := GetStringFromDocument(xXml);
    SaveToLog('Wyjœciowe dane procedury Plugin_Execute ' + AOutput, GPluginlogfile);
  end;
end;

procedure TCPlugin.FinalizeAndUnload;
begin
  if FHandle <> 0 then begin
    if @FPlugin_Finalize <> Nil then begin
      FPlugin_Finalize;
    end;
    FreeLibrary(FHandle);
    FHandle := 0;
  end;
end;

function TCPlugin.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 0 then begin
    Result := ExtractFileName(FFilename);
  end else begin
    Result := FpluginDescription;
  end;
end;

function TCPlugin.GetisConfigurable: Boolean;
begin
  Result := (@FPlugin_Configure <> Nil);
end;

function TCPlugin.LoadAndInitialize: Boolean;
var xInfo: IXMLDOMDocument;
begin
  FHandle := LoadLibrary(PChar(FFilename));
  Result := FHandle <> 0;
  SaveToLog('£adowanie i inicjowanie plugin-u ' + FFilename, GPluginlogfile);
  if Result then begin
    @FPlugin_Configure := GetProcAddress(FHandle, 'Plugin_Configure');
    @FPlugin_Icon := GetProcAddress(FHandle, 'Plugin_Icon');
    @FPlugin_Execute := GetProcAddress(FHandle, 'Plugin_Execute');
    @FPlugin_Initialize := GetProcAddress(FHandle, 'Plugin_Initialize');
    @FPlugin_Finalize := GetProcAddress(FHandle, 'Plugin_Finalize');
    @FPlugin_Info := GetProcAddress(FHandle, 'Plugin_Info');
    Result := (@FPlugin_Execute <> Nil) and (@FPlugin_Info <> Nil);
    if Result then begin
      if @FPlugin_Initialize <> Nil then begin
        Result := FPlugin_Initialize(Application.Handle);
      end;
      if Result then begin
        if @FPlugin_Icon <> Nil then begin
          FIcon := FPlugin_Icon;
        end;
        xInfo := GetBasePluginXml;
        SaveToLog('Wejœciowe dane procedury Plugin_Info ' + GetStringFromDocument(xInfo), GPluginlogfile);
        FPlugin_Info(xInfo);
        SaveToLog('Wyjœciowe dane procedury Plugin_Info ' + GetStringFromDocument(xInfo), GPluginlogfile);
        FpluginType := GetXmlAttribute('type', xInfo.documentElement, CPLUGINTYPE_INCORRECT);
        FpluginDescription := GetXmlAttribute('description', xInfo.documentElement, '');
        FpluginMenu := GetXmlAttribute('menu', xInfo.documentElement, FpluginDescription);
        if FpluginType = CPLUGINTYPE_CURRENCYRATE then begin
        end else begin
          Result := False;
          SaveToLog('Typ pluginu jest niepoprawny ' + IntToStr(FpluginType), GPluginlogfile);
        end;
      end else begin
        SaveToLog('Funkcja inicjuj¹ca plugin nie powiod³a siê', GPluginlogfile);
      end;
    end else begin
      SaveToLog('Brak implementacji wymaganych metod', GPluginlogfile);
    end;
    if not Result then begin
      FreeLibrary(FHandle);
      FHandle := 0;
    end;
  end else begin
    SaveToLog('B³¹d ³adowania ' + SysErrorMessage(GetLastError), GPluginlogfile);
  end;
end;

constructor TCPluginList.Create(APath: String);
begin
  inherited Create(True);
  FPluginPath := IncludeTrailingPathDelimiter(ExpandFileName(APath));
end;

function TCPluginList.GetCurrencyRatePluginCount: Integer;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    if TCPlugin(Items[xCount]).pluginType = CPLUGINTYPE_CURRENCYRATE then begin
      Inc(Result);
    end;
  end;
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
