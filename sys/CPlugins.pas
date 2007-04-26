unit CPlugins;

interface

uses Forms, Windows, CPluginConsts, CPluginTypes, Contnrs, MsXml, CComponents,
     Classes;

type
  TCPlugin = class;

  TCManagerInterfaceObject = class(TObject, ICManagerInterface)
  private
    FParentPlugin: TCPlugin;
  public
    constructor Create(AParentPlugin: TCPlugin);
    function GetConnection: IInterface;
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function GetAppHandle: HWND;
    function GetConfiguration: OleVariant;
    procedure SetConfiguration(AConfigurationBuffer: OleVariant);
    procedure SetCaption(ACaption: OleVariant);
    procedure SetType(AType: Integer);
    procedure SetDescription(ADescription: OleVariant);
    function GetDatafilename: OleVariant;
    function GetWorkdate: OleVariant;
    function GetReportCss: OleVariant;
    function GetReportText: OleVariant;
    function GetName: OleVariant;
    function GetVersion: OleVariant;
  end;

  TCPlugin = class(TCDataListElementObject)
  private
    FFilename: String;
    FShortName: String;
    FHandle: THandle;
    FPlugin_Configure: TCPlugin_Configure;
    FPlugin_Execute: TCPlugin_Execute;
    FPlugin_Initialize: TCPlugin_Initialize;
    FPlugin_Finalize: TCPlugin_Finalize;
    FpluginType: Integer;
    FpluginDescription: String;
    FpluginConfiguration: String;
    FpluginMenu: String;
    FcmanInterface: TCManagerInterfaceObject;
    function GetisConfigurable: Boolean;
  public
    constructor Create(AFilename: String);
    function LoadAndInitialize: Boolean;
    procedure FinalizeAndUnload;
    destructor Destroy; override;
    function Configure: Boolean;
    function Execute: OleVariant;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
  published
    property fileName: String read FFilename;
    property pluginType: Integer read FpluginType write FpluginType;
    property pluginDescription: String read FpluginDescription write FpluginDescription;
    property pluginMenu: String read FpluginMenu write FpluginMenu;
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
    function GetJustExecutePluginCount: Integer;
  end;

var GPlugins: TCPluginList;
    GPluginlogfile: String = '';

implementation

uses SysUtils, CTools, CXml, CDatabase, CInfoFormUnit, ADODB, CPreferences,
  Variants;

function GetObjectDelegate(AObjectName: PChar): Pointer; stdcall; export;
var xName: String;
begin
  Result := Nil;
  if AObjectName <> Nil then begin
    xName := AnsiLowerCase(AObjectName);
    if xName = 'connection' then begin
      Result := Pointer(GDataProvider.Connection.ConnectionObject);
    end;
  end;
end;

function GetBasePluginXml: IXMLDOMDocument;
var xRoot: IXMLDOMNode;
begin
  Result := GetXmlDocument;
  xRoot := Result.createElement('plugin');
  Result.appendChild(xRoot);
end;

function TCPlugin.Configure: Boolean;
begin
  if @FPlugin_Configure <> Nil then begin
    SaveToLog('Konfigurowanie pluginu ' + FShortName, GPluginlogfile);
    try
      Result := FPlugin_Configure;
    except
      Result := False;
    end;
  end else begin
    Result := True;
  end;
end;

constructor TCPlugin.Create(AFilename: String);
begin
  inherited Create;
  FFilename := AFilename;
  FShortName := ExtractFileName(AFilename);
  FHandle := 0;
  FpluginType := CPLUGINTYPE_INCORRECT;
  FcmanInterface := TCManagerInterfaceObject.Create(Self);
end;

destructor TCPlugin.Destroy;
begin
  FinalizeAndUnload;
  FcmanInterface.Free;
  inherited Destroy;
end;

function TCPlugin.Execute: OleVariant;
begin
  SaveToLog('Wykonywanie pluginu ' + FShortName, GPluginlogfile);
  try
    Result := FPlugin_Execute;
  except
    Result := False;
  end;
  if not VarIsEmpty(Result) then begin
    SaveToLog('Otrzymano na wyjœciu ' + FShortName + ' ' + Result, GPluginlogfile);
  end else begin
    SaveToLog('Brak danych na wyjœciu ' + FShortName, GPluginlogfile);
  end;
end;

procedure TCPlugin.FinalizeAndUnload;
begin
  if FHandle <> 0 then begin
    if @FPlugin_Finalize <> Nil then begin
      SaveToLog('Finalizowanie pluginu ' + FShortName, GPluginlogfile);
      try
        FPlugin_Finalize;
      except
      end;
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
begin
  FHandle := LoadLibrary(PChar(FFilename));
  Result := FHandle <> 0;
  SaveToLog('£adowanie i inicjowanie plugin-u ' + FShortName, GPluginlogfile);
  if Result then begin
    @FPlugin_Configure := GetProcAddress(FHandle, 'Plugin_Configure');
    @FPlugin_Execute := GetProcAddress(FHandle, 'Plugin_Execute');
    @FPlugin_Initialize := GetProcAddress(FHandle, 'Plugin_Initialize');
    @FPlugin_Finalize := GetProcAddress(FHandle, 'Plugin_Finalize');
    Result := (@FPlugin_Execute <> Nil) and (@FPlugin_Initialize <> Nil);
    if Result then begin
      try
        Result := FPlugin_Initialize(FcmanInterface);
      except
        Result := False;
      end;
      if Result then begin
        Result := (FpluginType = CPLUGINTYPE_CURRENCYRATE) or
                  (FpluginType = CPLUGINTYPE_JUSTEXECUTE) or
                  (FpluginType = CPLUGINTYPE_HTMLREPORT) or
                  (FpluginType = CPLUGINTYPE_CHARTREPORT);
        if not Result then begin
          SaveToLog('Typ pluginu jest niepoprawny lub nie zosta³ ustawiony ' + FShortName, GPluginlogfile);
        end;
      end else begin
        SaveToLog('Funkcja inicjuj¹ca plugin nie powiod³a siê ' + FShortName, GPluginlogfile);
      end;
    end else begin
      SaveToLog('Brak implementacji wymaganych metod ' + FShortName, GPluginlogfile);
    end;
    if not Result then begin
      FreeLibrary(FHandle);
      FHandle := 0;
    end;
  end else begin
    SaveToLog('B³¹d ³adowania ' + FShortName + ' ' + SysErrorMessage(GetLastError), GPluginlogfile);
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

function TCPluginList.GetJustExecutePluginCount: Integer;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    if TCPlugin(Items[xCount]).pluginType = CPLUGINTYPE_JUSTEXECUTE then begin
      Inc(Result);
    end;
  end;
end;

procedure TCPluginList.ScanForPlugins;
var xS: WIN32_FIND_DATA;
    xHandle: THandle;
    xRes: Boolean;
    xPlugin: TCPlugin;
    xPref: TPluginPref;
begin
  xHandle := FindFirstFile(PChar(FPluginPath + '*.dll'), xS);
  if xHandle <> INVALID_HANDLE_VALUE then begin
    repeat
      xPlugin := TCPlugin.Create(FPluginPath + xS.cFileName);
      if xPlugin.LoadAndInitialize then begin
        xPref := TPluginPref(GPluginsPreferences.ByPrefname[xPlugin.FFilename]);
        if xPref <> Nil then begin
          xPlugin.pluginConfiguration := xPref.configuration;
        end;
        Add(xPlugin);
      end else begin
        xPlugin.Free;
      end;
      xRes := FindNextFile(xHandle, xS);
    until not xRes;
  end;
  Windows.FindClose(xHandle);
end;

function TCManagerInterfaceObject.GetConnection: IInterface;
var xPref: TPluginPref;
    xAsk: Boolean;
    xPermit: Boolean;
    xAlways: Boolean;
begin
  xPref := TPluginPref(GPluginsPreferences.ByPrefname[FParentPlugin.fileName]);
  if xPref <> Nil then begin
    xAsk := False;
    xPermit := xPref.permitGetConnection;
  end else begin
    xAsk := True;
    xPermit := False;
  end;
  if xAsk then begin
    xPermit := ShowInfo(itQuestion, 'Wtyczka "' + FParentPlugin.FpluginDescription + '" ¿¹da dostêpu do pliku danych. Czy chcesz na to zezwoliæ ?', '', @xAlways);
    if xAlways then begin
      if xPref = Nil then begin
        xPref := TPluginPref.CreatePluginPref(FParentPlugin.fileName, FParentPlugin.pluginConfiguration);
        GPluginsPreferences.Add(xPref);
      end;
      xPref.permitGetConnection := xPermit;
    end;
  end;
  if xPermit then begin
    Result := GDataProvider.Connection.ConnectionObject;
  end else begin
    Result := Nil;
  end;
end;

function TCManagerInterfaceObject._AddRef: Integer;
begin
  Result := 0;
end;

function TCManagerInterfaceObject._Release: Integer;
begin
  Result := 0;
end;

function TCManagerInterfaceObject.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  if GetInterface(IID, Obj) then begin
    Result := 0
  end else begin
    Result := E_NOINTERFACE;
  end;
end;

function TCManagerInterfaceObject.GetAppHandle: HWND;
begin
  Result := Application.Handle;
end;

constructor TCManagerInterfaceObject.Create(AParentPlugin: TCPlugin);
begin
  inherited Create;
  FParentPlugin := AParentPlugin;
end;

function TCManagerInterfaceObject.GetConfiguration: OleVariant;
begin
  Result := FParentPlugin.pluginConfiguration;
end;

procedure TCManagerInterfaceObject.SetConfiguration(AConfigurationBuffer: OleVariant);
begin
  FParentPlugin.pluginConfiguration := AConfigurationBuffer;
end;

procedure TCManagerInterfaceObject.SetCaption(ACaption: OleVariant);
begin
  FParentPlugin.pluginMenu := ACaption;
end;

procedure TCManagerInterfaceObject.SetDescription(ADescription: OleVariant);
begin
  FParentPlugin.pluginDescription := ADescription;
end;

procedure TCManagerInterfaceObject.SetType(AType: Integer);
begin
  FParentPlugin.pluginType := AType;
end;

function TCManagerInterfaceObject.GetDatafilename: OleVariant;
begin
  Result := GDatabaseName;
end;

function TCManagerInterfaceObject.GetWorkdate: OleVariant;
begin
  Result := FormatDateTime('yyyymmdd', GWorkDate);
end;

function TCManagerInterfaceObject.GetReportCss: OleVariant;
var xRes: TResourceStream;
    xStr: TStringList;
begin
  if not FileExists(GetSystemPathname('report.css')) then begin
    xRes := TResourceStream.Create(HInstance, 'REPCSS', RT_RCDATA);
    xRes.SaveToFile(GetSystemPathname('report.css'));
    xRes.Free;
  end;
  xStr := TStringList.Create;
  xStr.LoadFromFile(GetSystemPathname('report.css'));
  Result := xStr.Text;
  xStr.Free;
end;

function TCManagerInterfaceObject.GetReportText: OleVariant;
var xRes: TResourceStream;
    xStr: TStringList;
begin
  if not FileExists(GetSystemPathname('report.htm')) then begin
    xRes := TResourceStream.Create(HInstance, 'REPBASE', RT_RCDATA);
    xRes.SaveToFile(GetSystemPathname('report.htm'));
    xRes.Free;
  end;
  xStr := TStringList.Create;
  xStr.LoadFromFile(GetSystemPathname('report.htm'));
  Result := xStr.Text;
  xStr.Free;
end;

function TCManagerInterfaceObject.GetName: OleVariant;
begin
  Result := 'CManager';
end;

function TCManagerInterfaceObject.GetVersion: OleVariant;
begin
  Result := FileVersion(ParamStr(0));
end;

initialization
  GPlugins := TCPluginList.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Wtyczki');
finalization
  GPlugins.Free;
end.
