unit CSettings;

interface

uses Forms, Windows, CXml;

const
  CSettingsFilename = 'CManager.cfg';

function InitializeSettings(AFileName: String): Boolean;
procedure FinalizeSettings(AFilename: String);
procedure SaveSettings;
procedure SaveFormPosition(AName: String; ALeft, ATop, AWidth, AHeight, AState: Integer); overload;
procedure SaveFormPosition(AForm: TForm); overload;
procedure LoadFormPosition(AForm: TForm);
function GetSettingsRoot: ICXMLDOMNode;
function GetSettingsForms: ICXMLDOMNode;
function GetSettingsPreferences: ICXMLDOMNode;
function GetSettingsFonts: ICXMLDOMNode;
function GetSettingsColumns: ICXMLDOMNode;
function GetSettingsBackups: ICXMLDOMNode;
function GetSettingsPlugins: ICXMLDOMNode;
function GetSettingsCharts: ICXMLDOMNode;

implementation

uses CInfoFormUnit, SysUtils, Types, CDatabase, CBaseFrameUnit, CConsts,
  CPreferences, CTools, CComponents;

var GSettings: ICXMLDOMDocument = Nil;

function GetSettingsRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    Result := GSettings.selectSingleNode('cmanager');
    if Result = Nil then begin
      Result := GSettings.createElement('cmanager');
      GSettings.appendChild(Result);
    end;
  end;
end;

function GetSettingsForms: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsRoot;
    Result := xRoot.selectSingleNode('forms');
    if Result = Nil then begin
      Result := GSettings.createElement('forms');
      xRoot.appendChild(Result);
    end;
  end;
end;

function GetSettingsPreferences: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsRoot;
    Result := xRoot.selectSingleNode('preferences');
    if Result = Nil then begin
      Result := GSettings.createElement('preferences');
      xRoot.appendChild(Result);
    end;
  end;
end;

function GetSettingsColumns: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsPreferences;
    Result := xRoot.selectSingleNode('columns');
    if Result = Nil then begin
      Result := GSettings.createElement('columns');
      xRoot.appendChild(Result);
    end;
  end;
end;

function GetSettingsBackups: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsPreferences;
    Result := xRoot.selectSingleNode('backups');
    if Result = Nil then begin
      Result := GSettings.createElement('backups');
      xRoot.appendChild(Result);
    end;
  end;
end;

function GetSettingsPlugins: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsPreferences;
    Result := xRoot.selectSingleNode('plugins');
    if Result = Nil then begin
      Result := GSettings.createElement('plugins');
      xRoot.appendChild(Result);
    end;
  end;
end;

function GetSettingsCharts: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsPreferences;
    Result := xRoot.selectSingleNode('charts');
    if Result = Nil then begin
      Result := GSettings.createElement('charts');
      xRoot.appendChild(Result);
    end;
  end;
end;

function GetSettingsFonts: ICXMLDOMNode;
var xRoot: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xRoot := GetSettingsPreferences;
    Result := xRoot.selectSingleNode('fonts');
    if Result = Nil then begin
      Result := GSettings.createElement('fonts');
      xRoot.appendChild(Result);
    end;
  end;
end;

procedure SaveFormPosition(AForm: TForm);
var xPlacement: TWindowPlacement;
    xState: Integer;
begin
  xPlacement.length := SizeOf(TWindowPlacement);
  GetWindowPlacement(AForm.Handle, @xPlacement);
  if (xPlacement.showCmd and SW_SHOWMAXIMIZED) = SW_SHOWMAXIMIZED then begin
    xState := 1;
  end else if (xPlacement.showCmd and SW_SHOWMINIMIZED) = SW_SHOWMINIMIZED then begin
    xState := -1;
  end else begin
    xState := 0;
  end;
  SaveFormPosition(AnsiLowerCase(StringReplace(AForm.Name + Copy(AForm.Caption, 1, 12), ' ', '', [rfReplaceAll, rfIgnoreCase])),
                   xPlacement.rcNormalPosition.Left,
                   xPlacement.rcNormalPosition.Top,
                   xPlacement.rcNormalPosition.Right - xPlacement.rcNormalPosition.Left,
                   xPlacement.rcNormalPosition.Bottom - xPlacement.rcNormalPosition.Top,
                   xState);
end;

procedure LoadFormPosition(AForm: TForm);
var xForms: ICXMLDOMNode;
    xNode: ICXMLDOMNode;
    xPlacement: TWindowPlacement;
    xS: Integer;
    xLoaded: Boolean;
begin
  xLoaded := False;
  if GSettings <> Nil then begin
    xForms := GetSettingsForms;
    xNode := xForms.selectSingleNode(AnsiLowerCase(StringReplace(AForm.Name + Copy(AForm.Caption, 1, 12), ' ', '', [rfReplaceAll, rfIgnoreCase])));
    if xNode = Nil then begin
      xNode := xForms.selectSingleNode(AnsiLowerCase(AForm.Name));
    end;
    if xNode <> Nil then begin
      xPlacement.length := SizeOf(TWindowPlacement);
      xPlacement.rcNormalPosition.Left := GetXmlAttribute('left', xNode, AForm.Left);
      xPlacement.rcNormalPosition.Top := GetXmlAttribute('top', xNode, AForm.Top);
      if AForm.BorderStyle <> bsSizeable then begin
        xPlacement.rcNormalPosition.Right := xPlacement.rcNormalPosition.Left + AForm.Width;
        xPlacement.rcNormalPosition.Bottom := xPlacement.rcNormalPosition.Top + AForm.Height;
      end else begin
        xPlacement.rcNormalPosition.Right := xPlacement.rcNormalPosition.Left + GetXmlAttribute('width', xNode, AForm.Width);
        xPlacement.rcNormalPosition.Bottom := xPlacement.rcNormalPosition.Top + GetXmlAttribute('height', xNode, AForm.Height);
      end;
      xPlacement.showCmd := SW_HIDE;
      xS := GetXmlAttribute('state', xNode, 0);
      if xS = 1 then begin
        xPlacement.showCmd := xPlacement.showCmd or SW_SHOWMAXIMIZED;
      end else if xS = -1 then begin
        xPlacement.showCmd := xPlacement.showCmd or SW_SHOWMAXIMIZED
      end;
      SetWindowPlacement(AForm.Handle, @xPlacement);
      xLoaded := True;
    end;
  end;
  if not xLoaded then begin
    AForm.Left := (Screen.WorkAreaWidth - AForm.Width) div 2;
    AForm.Top := (Screen.WorkAreaHeight - AForm.Height) div 2;
  end;
end;

function InitializeSettings(AFileName: String): Boolean;
begin
  Result := IsValidXmlparserInstalled(True);
  if Result then begin
    if (AFileName <> '') and FileExists(AFileName) then begin
      GSettings := GetDocumentFromFile(AFileName, Nil);
      if GSettings <> Nil then begin
        if GSettings.parseError.errorCode <> 0 then begin
          ShowInfo(itError, 'B³¹d wczytywania pliku konfiguracyjnego. Nie mo¿na uruchomiæ aplikacji.', GetParseErrorDescription(GSettings.parseError, True));
          Result := False;
        end else begin
          if GSettings.firstChild <> Nil then begin
            if GSettings.firstChild.nodeType <> CNODE_PROCESSING_INSTRUCTION then begin
              AppendEncoding(GSettings);
            end;
          end;
          GViewsPreferences.LoadFromParentNode(GetSettingsPreferences);
          GColumnsPreferences.LoadAllFromParentNode(GetSettingsColumns);
          GBackupsPreferences.LoadAllFromParentNode(GetSettingsBackups);
          GPluginsPreferences.LoadAllFromParentNode(GetSettingsPlugins);
          GChartPreferences.LoadAllFromParentNode(GetSettingsCharts);
          GBasePreferences.LoadFromXml(GetSettingsPreferences);
          SetEvenListColors(GBasePreferences.evenListColor, GBasePreferences.oddListColor);
        end;
      end else begin
        Result := False;
        ShowInfo(itError, 'B³¹d wczytywania pliku konfiguracyjnego. Nie mo¿na uruchomiæ aplikacji.', SysErrorMessage(GetLastError));
      end;
    end else begin
      GetSettingsRoot;
    end;
  end;
end;

procedure SaveSettings;
begin
  GViewsPreferences.SavetToParentNode(GetSettingsPreferences);
  GColumnsPreferences.SavetToParentNode(GetSettingsColumns);
  GBackupsPreferences.SavetToParentNode(GetSettingsBackups);
  GPluginsPreferences.SavetToParentNode(GetSettingsPlugins);
  GChartPreferences.SavetToParentNode(GetSettingsCharts);
  if GBasePreferences.startupDatafileMode = CStartupFilemodeFirsttime then begin
    GBasePreferences.startupDatafileMode := CStartupFilemodeLastOpened;
  end;
  GBasePreferences.SaveToXml(GetSettingsPreferences);
  FinalizeSettings(GetSystemPathname(CSettingsFilename));
end;

procedure FinalizeSettings(AFilename: String);
begin
  if GSettings <> Nil then begin
    GSettings.save(AFilename);
    GSettings := Nil;
  end;
end;

procedure SaveFormPosition(AName: String; ALeft, ATop, AWidth, AHeight, AState: Integer);
var xForms: ICXMLDOMNode;
    xNode: ICXMLDOMNode;
begin
  if GSettings <> Nil then begin
    xForms := GetSettingsForms;
    xNode := xForms.selectSingleNode(AnsiLowerCase(AName));
    if xNode = Nil then begin
      xNode := GSettings.createElement(AnsiLowerCase(AName));
      xForms.appendChild(xNode);
    end;
    SetXmlAttribute('left', xNode, ALeft);
    SetXmlAttribute('top', xNode, ATop);
    SetXmlAttribute('width', xNode, AWidth);
    SetXmlAttribute('height', xNode, AHeight);
    SetXmlAttribute('state', xNode, AState);
  end;
end;

end.
