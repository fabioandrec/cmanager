unit MetastockConfigFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CPluginTypes, ComCtrls, CXml;

type
  TMetastockConfigForm = class(TForm)
    PanelConfig: TPanel;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    ListView: TListView;
    BitBtnAdd: TBitBtn;
    BitBtnEdit: TBitBtn;
    BitBtnDel: TBitBtn;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure BitBtnDelClick(Sender: TObject);
    procedure BitBtnEditClick(Sender: TObject);
    procedure BitBtnAddClick(Sender: TObject);
  private
    FConfigXml: ICXMLDOMDocument;
    procedure UpdateButtons;
  public
    procedure SetConfigXml(const Value: ICXMLDOMDocument);
    function GetConfigXml: String;
    class function GetConfigurationAsXml(AConfiguration: String; var AErrorText: String): ICXMLDOMDocument;
  end;

var GCManagerInterface: ICManagerInterface;

implementation

uses CXmlTlb, CBase64, MetastockEditFormUnit, CTools;

{$R *.dfm}

procedure TMetastockConfigForm.BitBtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TMetastockConfigForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMetastockConfigForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    Close;
  end;
end;

procedure TMetastockConfigForm.SetConfigXml(const Value: ICXMLDOMDocument);
var xNode: ICXMLDOMNode;
    xCount: Integer;
    xItem: TListItem;
    xSourceNodes: ICXMLDOMNodeList;
begin
  FConfigXml := Value;
  ListView.Items.BeginUpdate;
  ListView.Items.Clear;
  if FConfigXml = Nil then begin
    FConfigXml := GetXmlDocument;
    FConfigXml.appendChild(FConfigXml.createElement('sources'));
  end;
  xSourceNodes := FConfigXml.documentElement.selectNodes('source');
  for xCount := 0 to xSourceNodes.length - 1 do begin
    xNode := xSourceNodes.item[xCount];
    xItem := ListView.Items.Add;
    xItem.Data := @xNode;
    xItem.Caption := GetXmlAttribute('name', xNode, 'èrÛd≥o ' + IntToStr(xCount + 1));
  end;
  ListView.Items.EndUpdate;
  UpdateButtons;
end;

procedure TMetastockConfigForm.UpdateButtons;
begin
  BitBtnEdit.Enabled := ListView.Selected <> Nil;
  BitBtnDel.Enabled := ListView.Selected <> Nil;
end;

procedure TMetastockConfigForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  UpdateButtons;
end;

procedure TMetastockConfigForm.BitBtnDelClick(Sender: TObject);
var xIndex: Integer;
begin
  if ListView.Selected <> Nil then begin
    xIndex := ListView.Selected.Index;
    ListView.DeleteSelected;
    FConfigXml.documentElement.removeChild(FConfigXml.documentElement.childNodes.item[xIndex]);
    UpdateButtons;
  end;
end;

procedure TMetastockConfigForm.BitBtnEditClick(Sender: TObject);
var xName, xUrl, xCashpoint, xIso, xType: String;
    xNode: IXMLDOMNode;
begin
  xNode := FConfigXml.documentElement.childNodes.item[ListView.Selected.Index];
  xName := GetXmlAttribute('name', xNode, '');
  xUrl := GetXmlAttribute('link', xNode, '');
  xCashpoint := GetXmlAttribute('cashpointName', xNode, '');
  xIso := GetXmlAttribute('currency', xNode, '');
  xType := GetXmlAttribute('type', xNode, '');
  if EditSource(xName, xUrl, xCashpoint, xIso, xType) then begin
    SetXmlAttribute('name', xNode, xName);
    SetXmlAttribute('link', xNode, xUrl);
    SetXmlAttribute('cashpointName', xNode, xCashpoint);
    SetXmlAttribute('currency', xNode, xIso);
    SetXmlAttribute('type', xNode, xType);
    ListView.Selected.Caption := xName;
  end;
end;

procedure TMetastockConfigForm.BitBtnAddClick(Sender: TObject);
var xName, xUrl, xCashpoint, xIso, xType: String;
    xNode: IXMLDOMNode;
    xItem: TListItem;
begin
  xName := '';
  xUrl := '';
  xCashpoint := '';
  xIso := '';
  xType := '';
  if EditSource(xName, xUrl, xCashpoint, xIso, xType) then begin
    xNode := FConfigXml.createElement('source');
    FConfigXml.documentElement.appendChild(xNode);
    SetXmlAttribute('name', xNode, xName);
    SetXmlAttribute('link', xNode, xUrl);
    SetXmlAttribute('cashpointName', xNode, xCashpoint);
    SetXmlAttribute('currency', xNode, xIso);
    SetXmlAttribute('type', xNode, xType);
    xItem := ListView.Items.Add;
    xItem.Caption := xName;
    ListView.Selected := xItem;
  end;
end;

function TMetastockConfigForm.GetConfigXml: String;
begin
  Result := GetStringFromDocument(FConfigXml);
end;

class function TMetastockConfigForm.GetConfigurationAsXml(AConfiguration: String; var AErrorText: String): ICXMLDOMDocument;
var xConfigurationEncoded, xConfigurationDecoded: String;
begin
  Result := Nil;
  AErrorText := '';
  xConfigurationEncoded := AConfiguration;
  if xConfigurationEncoded <> '' then begin
    if not DecodeBase64Buffer(xConfigurationEncoded, xConfigurationDecoded) then begin
      xConfigurationDecoded := '';
      AErrorText := 'Nie uda≥o siÍ odczytaÊ konfiguracji wtyczki. PrzyjÍto konfiguracjÍ domyúlnπ';
    end else begin
      Result := GetDocumentFromString(xConfigurationDecoded, Nil);
      if Result <> Nil then begin
        if Result.parseError.errorCode <> 0 then begin
          AErrorText := 'Konfiguracja wtyczki jest niepoprawna. PrzyjÍto konfiguracjÍ domyúlnπ';
          Result := Nil;
        end;
      end else begin
        AErrorText := 'Konfiguracja wtyczki jest niepoprawna. PrzyjÍto konfiguracjÍ domyúlnπ';
      end;
    end;
  end;
  if (xConfigurationDecoded = '') or (Result = Nil) then begin
    xConfigurationDecoded := GetStringFromResources('DEFAULTXML');
    Result := GetDocumentFromString(xConfigurationDecoded, Nil);
    if Result.parseError.errorCode <> 0 then begin
      AErrorText := 'Konfiguracja wtyczki jest niepoprawna';
      Result := Nil;
    end;
  end;
end;

end.
