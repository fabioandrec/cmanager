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
  private
    FConfigXml: ICXMLDOMDocument;
    FSourceNodes: ICXMLDOMNodeList;
    procedure SetconfigXml(const Value: ICXMLDOMDocument);
    procedure UpdateButtons;
  public
    property ConfigXml: ICXMLDOMDocument read FConfigXml write SetconfigXml;
  end;

var GCManagerInterface: ICManagerInterface;

implementation

uses CXmlTlb;

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

procedure TMetastockConfigForm.SetconfigXml(const Value: ICXMLDOMDocument);
var xNode: ICXMLDOMNode;
    xCount: Integer;
    xItem: TListItem;
begin
  FConfigXml := Value;
  ListView.Items.BeginUpdate;
  ListView.Items.Clear;
  if FConfigXml = Nil then begin
    FConfigXml := GetXmlDocument;
    FConfigXml.appendChild(FConfigXml.createElement('sources'));
  end;
  FSourceNodes := FConfigXml.documentElement.selectNodes('source');
  for xCount := 0 to FSourceNodes.length - 1 do begin
    xNode := FSourceNodes.item[xCount];
    xItem := ListView.Items.Add;
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

end.
