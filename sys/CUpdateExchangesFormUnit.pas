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
    GroupBox4: TGroupBox;
    Label2: TLabel;
    CStaticCashpoint: TCStatic;
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
  private
    FXml: ICXMLDOMDocument;
    FRoot: ICXMLDOMNode;
    FExchanges: ICXMLDOMNodeList;
    FCashpointName: String;
    procedure SetChecked(AChecked: Boolean);
  public
    procedure InitializeForm;
    property Xml: ICXMLDOMDocument read FXml write FXml;
    property Root: ICXMLDOMNode read FRoot write FRoot;
    property Exchanges: ICXMLDOMNodeList read FExchanges write FExchanges;
    property CashpointName: String read FCashpointName write FCashpointName;
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
  CPluginConsts;

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
begin
  ICXMLDOMNode(ExchangesList.GetNodeData(Node)^) := FExchanges.item[Node.Index];
  Node.CheckState := csCheckedNormal;
  Node.CheckType := ctCheckBox
end;

procedure TCUpdateExchangesForm.ExchangesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xNode: ICXMLDOMNode;
begin
  xNode := ICXMLDOMNode(ExchangesList.GetNodeData(Node)^);
  if Column = 2 then begin
    CellText := CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('value', xNode, '')), '', False, 4);
  end else if Column = 1 then begin
    CellText := GetXmlAttribute('identifier', xNode, '');
  end else if Column = 0 then begin
    CellText := Date2StrDate(XsdToDateTime(GetXmlAttribute('regDateTime', xNode, '')), True);
  end;
end;

procedure TCUpdateExchangesForm.InitializeForm;
begin
  CStaticCashpoint.TextOnEmpty := FCashpointName;
  CStaticCashpoint.Caption := FCashpointName;
  GDataProvider.BeginTransaction;
  CStaticCashpoint.DataId := GDataProvider.GetSqlString('select idCashpoint from cashpoint where name = ''' + FCashpointName + '''', CEmptyDataGid);
  GDataProvider.RollbackTransaction;
  ExchangesList.RootNodeCount := FExchanges.length;
end;

procedure TCUpdateExchangesForm.ExchangesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xNode: ICXMLDOMNode;
begin
  xNode := ICXMLDOMNode(ExchangesList.GetNodeData(Node)^);
  HintText := GetXmlAttribute('identifier', xNode, '');
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
var xCashpoint: TCashPoint;
    xNode: PVirtualNode;
    xXml: ICXMLDOMNode;
    xValue: TInstrumentValue;
    xInstrument: TInstrument;
    xRegDateTime: TDateTime;
    xDesc: String;
    xCashpointId: TDataGid;
    xHelper: TExchangeDescriptionHelper;
    xSearchType: TBaseEnumeration;
begin
  if CStaticCashpoint.DataId = CEmptyDataGid then begin
    if ShowInfo(itQuestion, 'Nie znaleziono kontrahenta o nazwie "' + FCashpointName + '", czy chcesz go utworzyæ teraz ?', '') then begin
      GDataProvider.BeginTransaction;
      xCashpoint := TCashPoint.CreateObject(CashPointProxy, False);
      xCashpoint.name := Copy(FCashpointName, 1, 40);
      xCashpoint.description := GetXmlAttribute('cashpointDesc', FRoot, '');
      xCashpoint.cashpointType := CCashpointTypeOther;
      CStaticCashpoint.DataId := xCashpoint.id;
      xCashpointId := xCashpoint.id;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCCashpointsFrame, WM_DATAOBJECTADDED, Integer(@xCashpointId), WMOPT_NONE);
    end;
  end;
  if CStaticCashpoint.DataId <> CEmptyDataGid then begin
    xSearchType := GetXmlAttribute('searchType', FRoot, CINSTRUMENTSEARCHTYPE_BYNAME);
    ShowWaitForm(wtProgressbar, 'Trwa zapisywanie notowañ...', 0, ExchangesList.RootNodeCount);
    GDataProvider.BeginTransaction;
    xNode := ExchangesList.GetFirst;
    while (xNode <> Nil) do begin
      if ExchangesList.CheckState[xNode] = csCheckedNormal then begin
        xXml := ICXMLDOMNode(ExchangesList.GetNodeData(xNode)^);
        if xSearchType = CINSTRUMENTSEARCHTYPE_BYSYMBOL then begin
          xInstrument := TInstrument.FindBySymbol(GetXmlAttribute('identifier', xXml, ''));
        end else begin
          xInstrument := TInstrument.FindByName(GetXmlAttribute('identifier', xXml, ''));
        end;
        if xInstrument = Nil then begin
          xInstrument := TInstrument.CreateObject(InstrumentProxy, False);
          xInstrument.name := GetXmlAttribute('identifier', xXml, '');
          xInstrument.symbol := xInstrument.name;
          xInstrument.description := GetXmlAttribute('desc', xXml, '');
          xInstrument.idCashpoint := xCashpointId;
          xInstrument.idCurrencyDef := CEmptyDataGid;
          xInstrument.instrumentType := CInstrumentTypeUndefined;
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
        GDataProvider.PostProxies;
        xNode := ExchangesList.GetNext(xNode);
      end;
      StepWaitForm(1);
    end;
    GDataProvider.CommitTransaction;
    HideWaitForm;
    SendMessageToFrames(TCInstrumentValueFrame, WM_DATAREFRESH, 0, 0);
    SendMessageToFrames(TCInstrumentFrame, WM_DATAREFRESH, 0, 0);
    SendMessageToFrames(TCCurrencydefFrame, WM_DATAREFRESH, 0, 0);
    CloseForm;
  end;
end;

end.

