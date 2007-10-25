unit CUpdateExchangesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, CComponents, StdCtrls, Buttons, ExtCtrls, CXml,
  VirtualTrees, CTemplates, ActnList, XPStyleActnCtrls, ActnMan, CDataObjects;

type
  TCUpdateExchangesForm = class(TCBaseForm)
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    PanelConfig: TPanel;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    ExchangesList: TCList;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action3: TAction;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure ExchangesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ExchangesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ExchangesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ExchangesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure ExchangesListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
  private
    FXml: ICXMLDOMDocument;
    FRoot: ICXMLDOMNode;
    procedure SetChecked(AChecked: Boolean);
  public
    procedure InitializeForm;
    property Xml: ICXMLDOMDocument read FXml write FXml;
    property Root: ICXMLDOMNode read FRoot write FRoot;
  end;

  TExchangeDescriptionHelper = class(TInterfacedObject, IDescTemplateExpander)
  private
    FExchange: ICXMLDOMNode;
    FInstrument: TInstrument;
  public
    constructor Create(AExchange: ICXMLDOMNode; AInstrument: TInstrument);
    function ExpandTemplate(ATemplate: String): String;
    property Exchange: ICXMLDOMNode read FExchange;
  end;

implementation

uses CDatabase, CTools, CConsts, CFrameFormUnit,
  CCashpointsFrameUnit, CDataobjectFrameUnit, CPreferences, CInfoFormUnit,
  CBaseFrameUnit, CWaitFormUnit, CProgressFormUnit,
  CInstrumentValueFrameUnit, CInstrumentFrameUnit, CCurrencydefFrameUnit,
  CPluginConsts, CXmlTlb;

{$R *.dfm}

procedure TCUpdateExchangesForm.BitBtnCancelClick(Sender: TObject);
begin
  CloseForm;
end;

procedure TCUpdateExchangesForm.ExchangesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(ICXMLDOMNode);
end;

procedure TCUpdateExchangesForm.ExchangesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xParentNode: ICXMLDOMNode;
begin
  if ParentNode = Nil then begin
    ICXMLDOMNode(ExchangesList.GetNodeData(Node)^) := FRoot.childNodes.item[Node.Index];
    Node.CheckType := ctNone;
    if FRoot.childNodes.item[Node.Index].childNodes.length > 0 then begin
      InitialStates := InitialStates + [ivsHasChildren, ivsExpanded]
    end;
  end else begin
    xParentNode := ICXMLDOMNode(ExchangesList.GetNodeData(ParentNode)^);
    ICXMLDOMNode(ExchangesList.GetNodeData(Node)^) := xParentNode.childNodes.item[Node.Index];
    Node.CheckState := csCheckedNormal;
    Node.CheckType := ctCheckBox
  end;
end;

procedure TCUpdateExchangesForm.ExchangesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xNode: ICXMLDOMNode;
    xParent: PVirtualNode;
begin
  xParent := ExchangesList.NodeParent[Node];
  xNode := ICXMLDOMNode(ExchangesList.GetNodeData(Node)^);
  if xParent = Nil then begin
    if Column = 0 then begin
      CellText := GetXmlAttribute('cashpointName', xNode, '');
    end else begin
      CellText := '';;
    end;
  end else begin
    if Column = 2 then begin
      CellText := CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('value', xNode, '')), '', False, 4);
    end else if Column = 0 then begin
      CellText := GetXmlAttribute('identifier', xNode, '');
    end else if Column = 1 then begin
      CellText := Date2StrDate(XsdToDateTime(GetXmlAttribute('regDateTime', xNode, '')), True);
    end;
  end;
end;

procedure TCUpdateExchangesForm.InitializeForm;
begin
  ExchangesList.RootNodeCount := FRoot.childNodes.length;
end;

procedure TCUpdateExchangesForm.ExchangesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xNode: ICXMLDOMNode;
begin
  xNode := ICXMLDOMNode(ExchangesList.GetNodeData(Node)^);
  if ExchangesList.NodeParent[Node] <> Nil then begin
    HintText := GetXmlAttribute('identifier', xNode, '');
  end else begin
    HintText := GetXmlAttribute('cashpointName', xNode, '');
  end;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCUpdateExchangesForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText, TCDataobjectFrameData.CreateWithFilter(CCashpointTypeOther));
end;

constructor TExchangeDescriptionHelper.Create(AExchange: ICXMLDOMNode; AInstrument: TInstrument);
begin
  inherited Create;
  FExchange := AExchange;
  FInstrument := AInstrument;
end;

function TExchangeDescriptionHelper.ExpandTemplate(ATemplate: String): String;
var xRegDateTime: TDateTime;
    xType: TBaseEnumeration;
begin
  xRegDateTime := XsdToDateTime(GetXmlAttribute('regDateTime', FExchange, ''));
  xType := GetXmlAttribute('type', FExchange, '');
  if ATemplate = '@datanotowania@' then begin
    Result := GetFormattedDate(xRegDateTime, 'yyyy-MM-dd');
  end else if ATemplate = '@dataczasnotowania@' then begin
    Result := GetFormattedDate(xRegDateTime, 'yyyy-MM-dd') + ' ' + GetFormattedTime(xRegDateTime, 'HH:mm');
  end else if ATemplate = '@instrument@' then begin
    Result := FInstrument.name;
  end else if ATemplate = '@symbol@' then begin
    Result := FInstrument.symbol;
  end else if ATemplate = '@rodzaj@' then begin
    if xType = CInstrumentTypeIndex then begin
      Result := CInstrumentTypeIndexDesc;
    end else if xType = CInstrumentTypeStock then begin
      Result := CInstrumentTypeStockDesc;
    end else if xType = CInstrumentTypeBond then begin
      Result := CInstrumentTypeBondDesc;
    end else if xType = CInstrumentTypeFund then begin
      Result := CInstrumentTypeFundDesc;
    end else if xType = CInstrumentTypeUndefined then begin
      Result := CInstrumentTypeUndefinedDesc;
    end;
  end;
end;

procedure TCUpdateExchangesForm.Action1Execute(Sender: TObject);
begin
  SetChecked(True);
end;

procedure TCUpdateExchangesForm.SetChecked(AChecked: Boolean);
var xNode: PVirtualNode;
    xState: TCheckState;
begin
  xNode := ExchangesList.GetFirst;
  while (xNode <> Nil) do begin
    if AChecked then begin
      xState := csCheckedNormal;
    end else begin
      xState := csUncheckedNormal;
    end;
    ExchangesList.CheckState[xNode] := xState;
    xNode := ExchangesList.GetNext(xNode);
  end;
end;

procedure TCUpdateExchangesForm.Action3Execute(Sender: TObject);
begin
  SetChecked(False);
end;

procedure TCUpdateExchangesForm.BitBtnOkClick(Sender: TObject);
var xNode: PVirtualNode;
    xInstrumentList: TDataObjectList;
    xXml: ICXMLDOMNode;
    xValue: TInstrumentValue;
    xInstrument: TInstrument;
    xRegDateTime: TDateTime;
    xDesc: String;
    xCashpointName, xCashpointId: TDataGid;
    xCashpoint: TCashPoint;
    xAnyCashpointAdded, xAnyInstrumentAdded, xAnyValueAdded: Boolean;
    xHelper: TExchangeDescriptionHelper;
    xSearchType: TBaseEnumeration;
begin
  ShowWaitForm(wtProgressbar, 'Trwa zapisywanie notowañ...', 0, ExchangesList.RootNode.TotalCount);
  GDataProvider.BeginTransaction;
  xInstrumentList := TInstrument.GetAllObjects(InstrumentProxy);
  xNode := ExchangesList.GetFirst;
  xCashpointName := '';
  xCashpointId := CEmptyDataGid;
  xAnyCashpointAdded := False;
  xAnyInstrumentAdded := False;
  xAnyValueAdded := False;
  while (xNode <> Nil) do begin
    xXml := ICXMLDOMNode(ExchangesList.GetNodeData(xNode)^);
    if ExchangesList.NodeParent[xNode] = Nil then begin
      xCashpointName := GetXmlAttribute('cashpointName', xXml, '');
      xCashpointId := CEmptyDataGid;
      xSearchType := GetXmlAttribute('searchType', xXml, CINSTRUMENTSEARCHTYPE_BYNAME);
    end else begin
      if ExchangesList.CheckState[xNode] = csCheckedNormal then begin
        if xSearchType = CINSTRUMENTSEARCHTYPE_BYNAME then begin
          xInstrument := TInstrument(xInstrumentList.ObjectByHash[GetXmlAttribute('identifier', xXml, ''), CHASH_INSTRUMENT_NAME]);
        end else begin
          xInstrument := TInstrument(xInstrumentList.ObjectByHash[GetXmlAttribute('identifier', xXml, ''), CHASH_INSTRUMENT_SYMBOL]);
        end;
        if xInstrument = Nil then begin
          xAnyInstrumentAdded := True;
          xInstrument := TInstrument.CreateObject(InstrumentProxy, False);
          xInstrument.name := GetXmlAttribute('identifier', xXml, '');
          xInstrument.symbol := xInstrument.name;
          xInstrument.description := GetXmlAttribute('desc', xXml, '');
          xCashpointId := GDataProvider.GetSqlString('select idCashpoint from cashpoint where name = ''' + xCashpointName + '''', CEmptyDataGid);
          if xCashpointId = CEmptyDataGid then begin
            xAnyCashpointAdded := True;
            xCashpoint := TCashPoint.CreateObject(CashPointProxy, False);
            xCashpoint.name := xCashpointName;
            xCashpoint.description := name;
            xCashpoint.cashpointType := CCashpointTypeOther;
            xCashpointId := xCashpoint.id;
          end;
          xInstrument.idCashpoint := xCashpointId;
          xInstrument.idCurrencyDef := CEmptyDataGid;
          xInstrument.instrumentType := CInstrumentTypeUndefined;
          xInstrumentList.Add(xInstrument);
        end;
        xRegDateTime := XsdToDateTime(GetXmlAttribute('regDateTime', xXml, ''));
        xValue := TInstrumentValue.FindValue(xInstrument.id, xRegDateTime);
        if xValue = Nil then begin
          xValue := TInstrumentValue.CreateObject(InstrumentValueProxy, False);
          xValue.idInstrument := xInstrument.id;
          xValue.regDateTime := xRegDateTime;
        end;
        xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[7][0], '');
        if xDesc <> '' then begin
          xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
          xHelper := TExchangeDescriptionHelper.Create(xXml, xInstrument);
          xDesc := GInstrumentValueTemplatesList.ExpandTemplates(xDesc, xHelper);
        end;
        xValue.description := xDesc;
        xValue.valueOf := StrToCurrencyDecimalDot(GetXmlAttribute('value', xXml, ''));
        xAnyValueAdded := True;
        GDataProvider.PostProxies;
      end;
    end;
    xNode := ExchangesList.GetNext(xNode);
    StepWaitForm(1);
  end;
  xInstrumentList.Free;
  GDataProvider.CommitTransaction;
  HideWaitForm;
  if xAnyValueAdded then begin
    SendMessageToFrames(TCInstrumentValueFrame, WM_DATAREFRESH, 0, 0);
  end;
  if xAnyInstrumentAdded then begin
    SendMessageToFrames(TCInstrumentFrame, WM_DATAREFRESH, 0, 0);
  end;
  if xAnyCashpointAdded then begin
    SendMessageToFrames(TCCashpointsFrame, WM_DATAREFRESH, 0, 0);
  end;
  CloseForm;
end;

procedure TCUpdateExchangesForm.ExchangesListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  ChildCount := ICXMLDOMNode(ExchangesList.GetNodeData(Node)^).childNodes.length;
end;

end.

