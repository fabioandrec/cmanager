unit CXmlFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees,
  CComponents, CXml, CTools, CDatabase, ExtCtrls, StdCtrls, CBaseFormUnit;

type
  TXmlAdditionalData = class(TObject)
  private
    FXml: ICXMLDOMDocument;
    FCaption: String;
  public
    constructor Create(AXml: ICXMLDOMDocument; ACaption: String);
    property Xml: ICXMLDOMDocument read FXml write FXml;
    property Caption: String read FCaption write FCaption;
  end;

  TXmlListElement = class(TCDataListElementObject)
  private
    Fdescription: String;
    Fnode: ICXMLDOMNode;
    Fid: TDataGid;
    FisElement: Boolean;
  public
    constructor Create(ANode: ICXMLDOMNode);
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementId: String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    property isElement: Boolean read FisElement;
    function GetElementText: String; override;
  end;

  TCXmlFrame = class(TCBaseFrame)
    Panel1: TPanel;
    Panel3: TPanel;
    List: TCDataList;
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
  protected
    function GetSelectedId: ShortString; override;
    function GetSelectedText: String; override;
  public
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    class function GetTitle: String; override;
    function GetList: TCList; override;
    function FindNodeId(ANode: PVirtualNode): ShortString; override;
    function GetCheckType(ANode: PVirtualNode): TCheckType; override;
    class function GetPrefname: String; override;
    procedure UpdateFrameForm(AFormInstance: TCBaseForm); override;
    function CanAcceptSelectedObject: Boolean; override;
  end;

function ShowXmlFile(AXml: ICXMLDOMDocument; AChecks: TStringList; ACaption: String; var ADataId: String; var AText: String): Boolean;

implementation

uses CFrameFormUnit, CConsts, CXmlTlb, StrUtils;

{$R *.dfm}

function ShowXmlFile(AXml: ICXMLDOMDocument; AChecks: TStringList; ACaption: String; var ADataId: String; var AText: String): Boolean;
var xAdditional: TXmlAdditionalData;
    xRect: TRect;
begin
  xAdditional := TXmlAdditionalData.Create(AXml, ACaption);
  xRect := Rect(0, 0, 500, 400);
  Result := TCFrameForm.ShowFrame(TCXmlFrame, ADataId, AText, xAdditional, @xRect, Nil, AChecks, True, Nil, True, True);
end;

constructor TXmlListElement.Create(ANode: ICXMLDOMNode);
begin
  inherited Create;
  Fnode := ANode;
  Fid := GetXmlAttribute('id', Fnode, CEmptyDataGid);
  if Fid = CEmptyDataGid then begin
    Fid := CreateNewGuid;
    SetXmlAttribute('id', ANode, Fid);
  end;
  Fdescription := GetXmlAttribute('description', Fnode, '');
  FisElement := ANode.attributes.getNamedItem('sql') <> Nil;
end;

function TXmlListElement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := Fdescription;
end;

function TCXmlFrame.FindNodeId(ANode: PVirtualNode): ShortString;
begin
  Result := TCListDataElement(List.GetNodeData(ANode)^).Data.GetElementId;
end;

function TCXmlFrame.GetCheckType(ANode: PVirtualNode): TCheckType;
begin
  Result := ctTriStateCheckBox;
end;

function TCXmlFrame.GetList: TCList;
begin
  Result := List;
end;

class function TCXmlFrame.GetPrefname: String;
begin
  Result := CFontPreferencesDefaultdataElements;
end;

class function TCXmlFrame.GetTitle: String;
begin
  Result := 'Konfiguracja pliku danych'
end;

procedure TCXmlFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  List.ReloadTree;
end;

procedure TCXmlFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);

  procedure AppendChildren(ARoot: TCListDataElement; ANodes: ICXMLDOMNodeList);
  var xCount: Integer;
      xNode: ICXMLDOMNode;
      xRoot: TCListDataElement;
  begin
    for xCount := 0 to ANodes.length - 1 do begin
      xNode := ANodes.item[xCount];
      xRoot := TCListDataElement.Create(MultipleChecks <> Nil, Sender, TXmlListElement.Create(xNode), True);
      ARoot.Add(xRoot);
      AppendChildren(xRoot, xNode.childNodes);
    end;
  end;

begin
  if TXmlAdditionalData(AdditionalData).Xml <> Nil then begin
    AppendChildren(ARootElement, TXmlAdditionalData(AdditionalData).Xml.documentElement.childNodes);
  end;
end;

function TXmlListElement.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TXmlListElement.GetElementId: String;
begin
  Result := Fid;
end;

constructor TXmlAdditionalData.Create(AXml: ICXMLDOMDocument; ACaption: String);
begin
  inherited Create;
  FXml := AXml;
  FCaption := ACaption;
end;

procedure TCXmlFrame.ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := IfThen(TXmlListElement(TCListDataElement(AHelper).Data).isElement, 'E', 'T');
end;

procedure TCXmlFrame.UpdateFrameForm(AFormInstance: TCBaseForm);
begin
  inherited UpdateFrameForm(AFormInstance);
  with TCFrameForm(AFormInstance) do begin
    PanelTopInfo.Height := PanelTopInfo.Height + LabelTopPanelInfo.Height * CalculateSubstrings(TXmlAdditionalData(AdditionalData).Caption, sLineBreak);
    LabelTopPanelInfo.Caption := TXmlAdditionalData(AdditionalData).Caption;
    PanelTopInfo.Visible := True;
  end;
end;

procedure TCXmlFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

function TXmlListElement.GetElementText: String;
begin
  Result := Fdescription; 
end;

function TCXmlFrame.CanAcceptSelectedObject: Boolean;
begin
  Result := True;
end;

function TCXmlFrame.GetSelectedId: ShortString;
begin
  Result := List.SelectedId;
end;

function TCXmlFrame.GetSelectedText: String;
begin
  Result := List.SelectedText;
end;

end.
