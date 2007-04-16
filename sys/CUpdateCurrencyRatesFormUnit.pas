unit CUpdateCurrencyRatesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, MsXml, CComponents, StdCtrls, Buttons, ExtCtrls,
  VirtualTrees, CTemplates, ActnList, XPStyleActnCtrls, ActnMan;

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
    ActionManager1: TActionManager;
    Action1: TAction;
    Action3: TAction;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure RatesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure RatesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RatesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure RatesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
  private
    FXml: IXMLDOMDocument;
    FRoot: IXMLDOMNode;
    FRates: IXMLDOMNodeList;
    FBindingDate: TDateTime;
    FCashpointName: String;
    procedure SetChecked(AChecked: Boolean);
  public
    procedure InitializeForm;
    property Xml: IXMLDOMDocument read FXml write FXml;
    property Root: IXMLDOMNode read FRoot write FRoot;
    property Rates: IXMLDOMNodeList read FRates write FRates;
    property BindingDate: TDateTime read FBindingDate write FBindingDate;
    property CashpointName: String read FCashpointName write FCashpointName;
  end;

  TCurrencyRateDescriptionHelper = class(TInterfacedObject, IDescTemplateExpander)
  private
    FRate: IXMLDOMNode;
    FBindingDate: TDateTime;
    FCashpointName: String;
    FQuantity: Integer;
    FCurRate: Currency;
  public
    constructor Create(ARate: IXMLDOMNode; ABindingDate: TDateTime; ACashpointName: String; AQuantity: Integer; ACurRate: Currency);
    function ExpandTemplate(ATemplate: String): String;
  end;

implementation

uses CDatabase, CXml, CTools, CDataObjects, CConsts, CFrameFormUnit,
  CCashpointsFrameUnit, CDataobjectFrameUnit, CPreferences;

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
    xExpander: IDescTemplateExpander;
    xDesc: String;
begin
  xNode := IXMLDOMNode(RatesList.GetNodeData(Node)^);
  if Column = 2 then begin
    CellText := CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')), False, 4);
  end else if Column = 1 then begin
    CellText := '';
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[4][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xExpander := TCurrencyRateDescriptionHelper.Create(xNode, FBindingDate, FCashpointName, StrToIntDef(GetXmlAttribute('quantity', xNode, ''), 0), StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')));
      CellText := GCurrencydefTemplatesList.ExpandTemplates(xDesc, xExpander);
    end;
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

constructor TCurrencyRateDescriptionHelper.Create(ARate: IXMLDOMNode; ABindingDate: TDateTime; ACashpointName: String; AQuantity: Integer; ACurRate: Currency);
begin
  inherited Create;
  FRate := ARate;
  FBindingDate := ABindingDate;
  FCashpointName := ACashpointName;
  FQuantity := AQuantity;
  FCurRate := ACurRate;
end;

function TCurrencyRateDescriptionHelper.ExpandTemplate(ATemplate: String): String;
begin
  if ATemplate = '@datakursu@' then begin
    Result := GetFormattedDate(FBindingDate, 'yyyy-MM-dd');
  end else if ATemplate = '@isobazowej@' then begin
    Result := GetXmlAttribute('sourceIso', FRate, '');
  end else if ATemplate = '@isodocelowej@' then begin
    Result := GetXmlAttribute('targetIso', FRate, '');
  end else if ATemplate = '@symbolbazowej@' then begin
    Result := GetXmlAttribute('sourceIso', FRate, '');
  end else if ATemplate = '@symboldocelowej@' then begin
    Result := GetXmlAttribute('targetIso', FRate, '');
  end else if ATemplate = '@kontrahent@' then begin
    Result := FCashpointName;
  end else if ATemplate = '@ilosc@' then begin
    Result := IntToStr(FQuantity);
  end else if ATemplate = '@kurs@' then begin
    Result := CurrencyToString(FCurRate, False, 4);
  end;
end;

procedure TCUpdateCurrencyRatesForm.Action1Execute(Sender: TObject);
begin
  SetChecked(True);
end;

procedure TCUpdateCurrencyRatesForm.SetChecked(AChecked: Boolean);
var xNode: PVirtualNode;
    xState: TCheckState;
begin
  xNode := RatesList.GetFirst;
  while (xNode <> Nil) do begin
    if AChecked then begin
      xState := csCheckedNormal;
    end else begin
      xState := csUncheckedNormal;
    end;
    RatesList.CheckState[xNode] := xState;
    xNode := RatesList.GetNext(xNode);
  end;
end;

procedure TCUpdateCurrencyRatesForm.Action3Execute(Sender: TObject);
begin
  SetChecked(False);
end;

end.

