unit CUpdateCurrencyRatesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, CXmlTlb, CComponents, StdCtrls, Buttons, ExtCtrls,
  VirtualTrees, CTemplates, ActnList, XPStyleActnCtrls, ActnMan, CDataObjects;

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
    procedure BitBtnOkClick(Sender: TObject);
  private
    FXml: IXMLDOMDocument2;
    FRoot: IXMLDOMNode;
    FRates: IXMLDOMNodeList;
    FBindingDate: TDateTime;
    FCashpointName: String;
    procedure SetChecked(AChecked: Boolean);
  public
    procedure InitializeForm;
    property Xml: IXMLDOMDocument2 read FXml write FXml;
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
    FrateType: TBaseEnumeration;
  public
    constructor Create(ARate: IXMLDOMNode; ARateType: TBaseEnumeration; ABindingDate: TDateTime; ACashpointName: String; AQuantity: Integer; ACurRate: Currency);
    function ExpandTemplate(ATemplate: String): String;
    property Rate: IXMLDOMNode read FRate;
    property BindingDate: TDateTime read FBindingDate;
    property CashpointName: String read FCashpointName;
    property Quantity: Integer read FQuantity;
    property CurRate: Currency read FCurRate;
    property RateType: TBaseEnumeration read FrateType write FrateType;
  end;

implementation

uses CDatabase, CXml, CTools, CConsts, CFrameFormUnit,
  CCashpointsFrameUnit, CDataobjectFrameUnit, CPreferences, CInfoFormUnit,
  CBaseFrameUnit, CCurrencydefFrameUnit, CCurrencyRateFrameUnit,
  CWaitFormUnit, CProgressFormUnit;

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
    CellText := CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')), '', False, 4);
  end else if Column = 1 then begin
    CellText := '';
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[4][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xExpander := TCurrencyRateDescriptionHelper.Create(xNode, GetXmlAttribute('type', xNode, CCurrencyRateTypeAverage), FBindingDate, FCashpointName, StrToIntDef(GetXmlAttribute('quantity', xNode, ''), 0), StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')));
      CellText := GCurrencydefTemplatesList.ExpandTemplates(xDesc, xExpander);
    end;
  end else if Column = 0 then begin
    CellText := IntToStr(StrToIntDef(GetXmlAttribute('quantity', xNode, ''), 0));;
  end else begin
    CellText := TCurrencyRate.GetTypeDesc(GetXmlAttribute('type', xNode, CCurrencyRateTypeAverage));
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
              CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')), '', False, 4) + ' ' +
              GetXmlAttribute('targetName', xNode, '');
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCUpdateCurrencyRatesForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText, TCDataobjectFrameData.CreateWithFilter(CCashpointTypeOther));
end;

constructor TCurrencyRateDescriptionHelper.Create(ARate: IXMLDOMNode; ARateType: TBaseEnumeration; ABindingDate: TDateTime; ACashpointName: String; AQuantity: Integer; ACurRate: Currency);
begin
  inherited Create;
  FRate := ARate;
  FBindingDate := ABindingDate;
  FCashpointName := ACashpointName;
  FQuantity := AQuantity;
  FCurRate := ACurRate;
  FrateType := ARateType;
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
  end else if ATemplate = '@typ@' then begin
    Result := TCurrencyRate.GetTypeDesc(FrateType);
  end else if ATemplate = '@ilosc@' then begin
    Result := IntToStr(FQuantity);
  end else if ATemplate = '@kurs@' then begin
    Result := CurrencyToString(FCurRate, '', False, 4);
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

procedure TCUpdateCurrencyRatesForm.BitBtnOkClick(Sender: TObject);
var xCashpoint: TCashPoint;
    xProceed: Boolean;
    xNode: PVirtualNode;
    xXml: IXMLDOMNode;
    xRate: TCurrencyRate;
    xBaseCurrency: TCurrencyDef;
    xTargetCurrency: TCurrencyDef;
    xDesc: String;
    xCashpointId: TDataGid;
    xHelper: TCurrencyRateDescriptionHelper;
begin
  if CStaticCashpoint.DataId = CEmptyDataGid then begin
    if ShowInfo(itQuestion, 'Nie znaleziono kontrahenta o nazwie "' + FCashpointName + '", czy chcesz go utworzyæ teraz ?', '') then begin
      GDataProvider.BeginTransaction;
      xCashpoint := TCashPoint.CreateObject(CashPointProxy, False);
      xCashpoint.name := Copy(FCashpointName, 1, 40);
      xCashpoint.description := xCashpoint.name;
      xCashpoint.cashpointType := CCashpointTypeOther;
      CStaticCashpoint.DataId := xCashpoint.id;
      xCashpointId := xCashpoint.id;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCCashpointsFrame, WM_DATAOBJECTADDED, Integer(@xCashpointId), WMOPT_NONE);
    end;
  end;
  if CStaticCashpoint.DataId <> CEmptyDataGid then begin
    if GDataProvider.GetSqlInteger(Format('select count(*) from currencyRate where bindingDate = %s and idCashpoint = %s',
      [DatetimeToDatabase(FBindingDate, False), DataGidToDatabase(CStaticCashpoint.DataId)]), 0) > 0 then begin
      xProceed := ShowInfo(itQuestion, 'Istniej¹ ju¿ kursy walut w/g "' + FCashpointName + '" z dat¹ obowi¹zywania ' + Date2StrDate(FBindingDate) + '\n' +
                                       'Czy chcesz je uzupe³niæ ?', '');
    end else begin
      xProceed := True;
    end;
    if xProceed then begin
      ShowWaitForm(wtProgressbar, 'Trwa zapisywanie tabeli kursów...', 0, RatesList.RootNodeCount);
      GDataProvider.BeginTransaction;
      xNode := RatesList.GetFirst;
      while (xNode <> Nil) do begin
        if RatesList.CheckState[xNode] = csCheckedNormal then begin
          xXml := IXMLDOMNode(RatesList.GetNodeData(xNode)^);
          xBaseCurrency := TCurrencyDef.FindByIso(GetXmlAttribute('sourceIso', xXml, ''));
          if xBaseCurrency = Nil then begin
            xBaseCurrency := TCurrencyDef.CreateObject(CurrencyDefProxy, False);
            xBaseCurrency.iso := GetXmlAttribute('sourceIso', xXml, '');
            xBaseCurrency.symbol := xBaseCurrency.iso;
            xBaseCurrency.name := GetXmlAttribute('sourceName', xXml, '');
            xBaseCurrency.description := xBaseCurrency.name;
          end;
          xTargetCurrency := TCurrencyDef.FindByIso(GetXmlAttribute('targetIso', xXml, ''));
          if xTargetCurrency = Nil then begin
            xTargetCurrency := TCurrencyDef.CreateObject(CurrencyDefProxy, False);
            xTargetCurrency.iso := GetXmlAttribute('targetIso', xXml, '');
            xTargetCurrency.symbol := xTargetCurrency.iso;
            xTargetCurrency.name := GetXmlAttribute('targetName', xXml, '');
            xTargetCurrency.description := xTargetCurrency.name;
          end;
          xRate := TCurrencyRate.FindRate(GetXmlAttribute('type', xXml, CCurrencyRateTypeAverage), xBaseCurrency.id, xTargetCurrency.id, CStaticCashpoint.DataId, FBindingDate);
          if xRate = Nil then begin
            xRate := TCurrencyRate.CreateObject(CurrencyRateProxy, False);
            xRate.idSourceCurrencyDef := xBaseCurrency.id;
            xRate.idTargetCurrencyDef := xTargetCurrency.id;
            xRate.idCashpoint := CStaticCashpoint.DataId;
            xRate.bindingDate := FBindingDate;
            xRate.rateType := GetXmlAttribute('type', xXml, CCurrencyRateTypeAverage);
          end;
          xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[4][0], '');
          if xDesc <> '' then begin
            xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
            xHelper := TCurrencyRateDescriptionHelper.Create(xXml, GetXmlAttribute('type', xXml, CCurrencyRateTypeAverage), FBindingDate, FCashpointName, StrToIntDef(GetXmlAttribute('quantity', xXml, ''), 0), StrToCurrencyDecimalDot(GetXmlAttribute('rate', xXml, '')));
            xDesc := GCurrencydefTemplatesList.ExpandTemplates(xDesc, xHelper);
          end;
          xRate.description := xDesc;
          xRate.rate := StrToCurrencyDecimalDot(GetXmlAttribute('rate', xXml, ''));
          xRate.quantity := StrToIntDef(GetXmlAttribute('quantity', xXml, ''), 0);
        end;
        GDataProvider.PostProxies;
        xNode := RatesList.GetNext(xNode);
        StepWaitForm(1);
      end;
      GDataProvider.CommitTransaction;
      HideWaitForm;
      SendMessageToFrames(TCCurrencydefFrame, WM_DATAREFRESH, 0, 0);
      SendMessageToFrames(TCCurrencyRateFrame, WM_DATAREFRESH, 0, 0);
      CloseForm;
    end;
  end;
end;

end.

