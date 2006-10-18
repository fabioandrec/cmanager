unit CSettings;

interface

uses MsXml, Forms, Windows;

const
  CSettingsFilename = 'CManager.cfg';

function InitializeSettings(AFileName: String): Boolean;
procedure FinalizeSettings(AFilename: String);
procedure SaveFormPosition(AName: String; ALeft, ATop, AWidth, AHeight, AState: Integer); overload;
procedure SaveFormPosition(AForm: TForm); overload;
procedure LoadFormPosition(AForm: TForm);
function GetSettingsRoot: IXMLDOMNode;
function GetSettingsForms: IXMLDOMNode;

implementation

uses CInfoFormUnit, SysUtils, Types, CDatabase, CBaseFrameUnit;

var GSettings: IXMLDOMDocument = Nil;

function GetXmlAttribute(AName: String; ANode: IXMLDOMNode; ADefault: OleVariant): OleVariant;
var xNode: IXMLDOMNode;
begin
  xNode := ANode.attributes.getNamedItem(AName);
  if xNode <> Nil then begin
    Result := xNode.nodeValue;
  end else begin
    Result := ADefault;
  end;
end;

procedure SetXmlAttribute(AName: String; ANode: IXMLDOMNode; AValue: OleVariant);
var xNode: IXMLDOMNode;
begin
  xNode := ANode.ownerDocument.createAttribute(AName);
  ANode.attributes.setNamedItem(xNode);
  xNode.nodeValue := AValue;
end;

function GetSettingsRoot: IXMLDOMNode;
begin
  Result := GSettings.selectSingleNode('cmanager');
  if Result = Nil then begin
    Result := GSettings.createElement('cmanager');
    GSettings.appendChild(Result);
  end;
end;

function GetSettingsForms: IXMLDOMNode;
var xRoot: IXMLDOMNode;
begin
  xRoot := GetSettingsRoot;
  Result := xRoot.selectSingleNode('forms');
  if Result = Nil then begin
    Result := GSettings.createElement('forms');
    xRoot.appendChild(Result);
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
  xForms := GetSettingsForms;
  xNode := xForms.selectSingleNode(AnsiLowerCase(AForm.Name));
  if xNode <> Nil then begin
    xPlacement.length := SizeOf(TWindowPlacement);
    xPlacement.rcNormalPosition.Left := GetXmlAttribute('left', xNode, AForm.Left);
    xPlacement.rcNormalPosition.Top := GetXmlAttribute('top', xNode, AForm.Top);
    xPlacement.rcNormalPosition.Right := xPlacement.rcNormalPosition.Left + GetXmlAttribute('width', xNode, AForm.Width);
    xPlacement.rcNormalPosition.Bottom := xPlacement.rcNormalPosition.Top + GetXmlAttribute('height', xNode, AForm.Height);
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
    end;
  end else begin
    GetSettingsRoot;
  end;
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

end.
