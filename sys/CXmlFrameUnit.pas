unit CXmlFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees,
  CComponents, CXml, CTools, CDatabase, ExtCtrls, StdCtrls;

type
  TXmlAdditionalData = class(TObject)
  private
    FXml: ICXMLDOMDocument;
  public
    constructor Create(AXml: ICXMLDOMDocument);
    property Xml: ICXMLDOMDocument read FXml write FXml;
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
  end;

  TCXmlFrame = class(TCBaseFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    List: TCDataList;
    Label1: TLabel;
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
  private
  public
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    class function GetTitle: String; override;
    function GetList: TCList; override;
    function FindNodeId(ANode: PVirtualNode): ShortString; override;
    function GetCheckType(ANode: PVirtualNode): TCheckType; override;
    class function GetPrefname: String; override;
  end;

function ShowXmlFile(AXml: ICXMLDOMDocument; AChecks: TStringList): Boolean;

implementation

uses CFrameFormUnit, CConsts, CXmlTlb, StrUtils;

{$R *.dfm}

function ShowXmlFile(AXml: ICXMLDOMDocument; AChecks: TStringList): Boolean;
var xDataId, xText: String;
    xAdditional: TXmlAdditionalData;
    xRect: TRect;
begin
  xAdditional := TXmlAdditionalData.Create(AXml);
  xRect := Rect(0, 0, 500, 400);
  Result := TCFrameForm.ShowFrame(TCXmlFrame, xDataId, xText, xAdditional, @xRect, Nil, AChecks, True, Nil, False);
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
  Result := 'Domyœlne dane pliku'
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
  AppendChildren(ARootElement, TXmlAdditionalData(AdditionalData).Xml.documentElement.childNodes);
end;

function TXmlListElement.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TXmlListElement.GetElementId: String;
begin
  Result := Fid;
end;

constructor TXmlAdditionalData.Create(AXml: ICXMLDOMDocument);
begin
  inherited Create;
  FXml := AXml;
end;

procedure TCXmlFrame.ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := IfThen(TXmlListElement(TCListDataElement(AHelper).Data).isElement, 'E', 'T');
end;

end.
