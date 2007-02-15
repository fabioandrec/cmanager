unit CSettings;

interface

uses MsXml, Forms, Windows;

const
  CSettingsFilename = 'CManager.cfg';

function InitializeSettings(AFileName: String): Boolean;
procedure FinalizeSettings(AFilename: String);
procedure SaveSettings;
procedure SaveFormPosition(AName: String; ALeft, ATop, AWidth, AHeight, AState: Integer); overload;
procedure SaveFormPosition(AForm: TForm); overload;
procedure LoadFormPosition(AForm: TForm);
function GetSettingsRoot: IXMLDOMNode;
function GetSettingsForms: IXMLDOMNode;
function GetSettingsPreferences: IXMLDOMNode;
function GetSettingsFonts: IXMLDOMNode;

implementation

uses CInfoFormUnit, SysUtils, Types, CDatabase, CBaseFrameUnit, CConsts,
  CPreferences, CXml;

var GSettings: IXMLDOMDocument = Nil;

function GetSettingsRoot: IXMLDOMNode;
begin
  if GSettings <> Nil then begin
    Result := GSettings.selectSingleNode('cmanager');
    if Result = Nil then begin
      Result := GSettings.createElement('cmanager');
      GSettings.appendChild(Result);
    end;
  end;
end;

function GetSettingsForms: IXMLDOMNode;
var xRoot: IXMLDOMNode;
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

function GetSettingsPreferences: IXMLDOMNode;
var xRoot: IXMLDOMNode;
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

function GetSettingsFonts: IXMLDOMNode;
var xRoot: IXMLDOMNode;
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
  SaveFormPosition(AnsiLowerCase(AForm.Name),
                   xPlacement.rcNormalPosition.Left,
                   xPlacement.rcNormalPosition.Top,
                   xPlacement.rcNormalPosition.Right - xPlacement.rcNormalPosition.Left,
                   xPlacement.rcNormalPosition.Bottom - xPlacement.rcNormalPosition.Top,
                   xState);
end;

procedure LoadFormPosition(AForm: TForm);
var xForms: IXMLDOMNode;
    xNode: IXMLDOMNode;
    xPlacement: TWindowPlacement;
    xS: Integer;
begin
  if GSettings <> Nil then begin
    xForms := GetSettingsForms;
    xNode := xForms.selectSingleNode(AnsiLowerCase(AForm.Name));
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
      SetWindowPlacement(AForm.Handle, @xPlacement);
      xS := GetXmlAttribute('state', xNode, 0);
      if xS = 1 then begin
        PostMessage(AForm.Handle, WM_FORMMAXIMIZE, 0, 0);
      end else if xS = -1 then begin
        PostMessage(AForm.Handle, WM_FORMMINIMIZE, 0, 0);
      end;
    end;
  end;
end;

function InitializeSettings(AFileName: String): Boolean;
begin
  Result := True;
  GSettings := CoDOMDocument.Create;
  if (AFileName <> '') and FileExists(AFileName) then begin
    GSettings.validateOnParse := True;
    GSettings.resolveExternals := True;
    GSettings.load(AFileName);
    if GSettings.parseError.errorCode <> 0 then begin
      ShowInfo(itError, 'B³¹d wczytywania pliku konfiguracyjnego. Nie mo¿na uruchomiæ aplikacji.', GSettings.parseError.reason);
      Result := False;
    end else begin
      GViewsPreferences.LoadFromParentNode(GetSettingsPreferences);
      GBasePreferences.LoadFromXml(GetSettingsPreferences);
    end;
  end else begin
    GetSettingsRoot;
  end;
end;

procedure SaveSettings;
begin
  GViewsPreferences.SavetToParentNode(GetSettingsPreferences);
  if GDataProvider.IsConnected then begin
    GBasePreferences.lastOpenedDatafilename := GDatabaseName;
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
var xForms: IXMLDOMNode;
    xNode: IXMLDOMNode;
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
