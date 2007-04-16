unit CUpdateCurrencyRatesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, MsXml, CComponents, StdCtrls, Buttons, ExtCtrls,
  VirtualTrees;

type
  TCUpdateCurrencyRatesForm = class(TCBaseForm)
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    PanelConfig: TPanel;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label2: TLabel;
    CDateTime: TCDateTime;
    CStaticCashpoint: TCStatic;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    RatesList: TCList;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure RatesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure RatesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RatesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure RatesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String;
      var AAccepted: Boolean);
  private
    FXml: IXMLDOMDocument;
    FRoot: IXMLDOMNode;
    FRates: IXMLDOMNodeList;
    FBindingDate: TDateTime;
    FCashpointName: String;
  public
    procedure InitializeForm;
    property Xml: IXMLDOMDocument read FXml write FXml;
    property Root: IXMLDOMNode read FRoot write FRoot;
    property Rates: IXMLDOMNodeList read FRates write FRates;
    property BindingDate: TDateTime read FBindingDate write FBindingDate;
    property CashpointName: String read FCashpointName write FCashpointName;
  end;

implementation

uses CDatabase, CXml, CTools, CDataObjects, CConsts, CFrameFormUnit,
  CCashpointsFrameUnit, CDataobjectFrameUnit;

{$R *.dfm}

procedure TCUpdateCurrencyRatesForm.BitBtnCancelClick(Sender: TObject);
begin
  CloseForm;
end;

procedure TCUpdateCurrencyRatesForm.RatesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(IXMLDOMNode);
end;

procedure TCUpdateCurrencyRatesForm.RatesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  IXMLDOMNode(RatesList.GetNodeData(Node)^) := FRates.item[Node.Index];
  Node.CheckState := csCheckedNormal;
  Node.CheckType := ctCheckBox
end;

procedure TCUpdateCurrencyRatesForm.RatesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xNode: IXMLDOMNode;
begin
  xNode := IXMLDOMNode(RatesList.GetNodeData(Node)^);
  if Column = 3 then begin
    CellText := GetXmlAttribute('targetIso', xNode, '');
  end else if Column = 2 then begin
    CellText := CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')), False, 4);
  end else if Column = 1 then begin
    CellText := GetXmlAttribute('sourceIso', xNode, '');
  end else begin
    CellText := IntToStr(StrToIntDef(GetXmlAttribute('quantity', xNode, ''), 0));;
  end;
end;

procedure TCUpdateCurrencyRatesForm.InitializeForm;
begin
  CStaticCashpoint.TextOnEmpty := FCashpointName;
  CStaticCashpoint.Caption := FCashpointName;
  GDataProvider.BeginTransaction;
  CStaticCashpoint.DataId := GDataProvider.GetSqlString('select idCashpoint from cashpoint where name = ''' + FCashpointName + '''', CEmptyDataGid);
  GDataProvider.RollbackTransaction;
  CDateTime.Value := FBindingDate;
  RatesList.RootNodeCount := FRates.length;
end;

procedure TCUpdateCurrencyRatesForm.RatesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xNode: IXMLDOMNode;
begin
  xNode := IXMLDOMNode(RatesList.GetNodeData(Node)^);
  HintText := IntToStr(StrToIntDef(GetXmlAttribute('quantity', xNode, ''), 0)) + ' ' +
              GetXmlAttribute('sourceName', xNode, '') + ' kosztuje ' +
              CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')), False, 4) + ' ' +
              GetXmlAttribute('targetName', xNode, '');
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCUpdateCurrencyRatesForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText, TCDataobjectFrameData.CreateWithFilter(CCashpointTypeOther));
end;

end.

