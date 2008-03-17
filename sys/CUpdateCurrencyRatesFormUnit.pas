unit CUpdateCurrencyRatesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, CComponents, StdCtrls, Buttons, ExtCtrls, CXml,
  VirtualTrees, CTemplates, ActnList, XPStyleActnCtrls, ActnMan, CDataObjects,
  Menus, PngImageList;

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
    ComboBoxType: TComboBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Zaznaczwszystkie1: TMenuItem;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure RatesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure RatesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RatesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure RatesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure Zaznaczwszystkie1Click(Sender: TObject);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    FXml: ICXMLDOMDocument;
    FRoot: ICXMLDOMNode;
    FSourceRates: ICXMLDOMNodeList;
    FTreeDocument: ICXMLDOMDocument;
    FBindingDate: TDateTime;
    FCashpointName: String;
    procedure SetChecked(AChecked: Boolean);
    procedure RecreateTreeRates;
    procedure UpdateIcons;
  public
    procedure InitializeForm;
    property Xml: ICXMLDOMDocument read FXml write FXml;
    property Root: ICXMLDOMNode read FRoot write FRoot;
    property SourceRates: ICXMLDOMNodeList read FSourceRates write FSourceRates;
    property BindingDate: TDateTime read FBindingDate write FBindingDate;
    property CashpointName: String read FCashpointName write FCashpointName;
    destructor Destroy; override;
  end;

  TCurrencyRateDescriptionHelper = class(TInterfacedObject, IDescTemplateExpander)
  private
    FRate: ICXMLDOMNode;
    FBindingDate: TDateTime;
    FCashpointName: String;
    FQuantity: Integer;
    FCurRate: Currency;
    FrateType: TBaseEnumeration;
  public
    constructor Create(ARate: ICXMLDOMNode; ARateType: TBaseEnumeration; ABindingDate: TDateTime; ACashpointName: String; AQuantity: Integer; ACurRate: Currency);
    function ExpandTemplate(ATemplate: String): String;
    property Rate: ICXMLDOMNode read FRate;
    property BindingDate: TDateTime read FBindingDate;
    property CashpointName: String read FCashpointName;
    property Quantity: Integer read FQuantity;
    property CurRate: Currency read FCurRate;
    property RateType: TBaseEnumeration read FrateType write FrateType;
  end;

implementation

uses CDatabase, CTools, CConsts, CFrameFormUnit,
  CCashpointsFrameUnit, CDataobjectFrameUnit, CPreferences, CInfoFormUnit,
  CBaseFrameUnit, CCurrencydefFrameUnit, CCurrencyRateFrameUnit,
  CWaitFormUnit, CProgressFormUnit, CListPreferencesFormUnit, CDatatools;

{$R *.dfm}

procedure TCUpdateCurrencyRatesForm.BitBtnCancelClick(Sender: TObject);
begin
  CloseForm;
end;

procedure TCUpdateCurrencyRatesForm.RatesListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(ICXMLDOMNode);
end;

procedure TCUpdateCurrencyRatesForm.RatesListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  ICXMLDOMNode(RatesList.GetNodeData(Node)^) := FTreeDocument.documentElement.childNodes.item[Node.Index];
  Node.CheckState := csCheckedNormal;
  Node.CheckType := ctCheckBox
end;

procedure TCUpdateCurrencyRatesForm.RatesListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xNode: ICXMLDOMNode;
    xExpander: IDescTemplateExpander;
    xDesc: String;
begin
  xNode := ICXMLDOMNode(RatesList.GetNodeData(Node)^);
  if Column = 2 then begin
    CellText := CurrencyToString(StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')), '', False, 4);
  end else if Column = 1 then begin
    CellText := '';
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[4][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xExpander := TCurrencyRateDescriptionHelper.Create(xNode, GetXmlAttribute('type', xNode, CCurrencyRateTypeAverage), FBindingDate, FCashpointName, StrToIntDef(GetXmlAttribute('quantity', xNode, ''), 1), StrToCurrencyDecimalDot(GetXmlAttribute('rate', xNode, '')));
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
  FSmallIconsButtonsImageList := Nil;
  FBigIconsButtonsImageList := TPngImageList(ActionManager1.Images);
  CStaticCashpoint.TextOnEmpty := FCashpointName;
  CStaticCashpoint.Caption := FCashpointName;
  GDataProvider.BeginTransaction;
  CStaticCashpoint.DataId := GDataProvider.GetSqlString('select idCashpoint from cashpoint where name = ''' + FCashpointName + '''', CEmptyDataGid);
  GDataProvider.RollbackTransaction;
  CDateTime.Value := FBindingDate;
  RatesList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesRatesList]);
  if RatesList.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := RatesList.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  RecreateTreeRates;
end;

procedure TCUpdateCurrencyRatesForm.RatesListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xNode: ICXMLDOMNode;
begin
  xNode := ICXMLDOMNode(RatesList.GetNodeData(Node)^);
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

constructor TCurrencyRateDescriptionHelper.Create(ARate: ICXMLDOMNode; ARateType: TBaseEnumeration; ABindingDate: TDateTime; ACashpointName: String; AQuantity: Integer; ACurRate: Currency);
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
    xXml: ICXMLDOMNode;
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
          xXml := ICXMLDOMNode(RatesList.GetNodeData(xNode)^);
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

procedure TCUpdateCurrencyRatesForm.RecreateTreeRates;
var xRoot: ICXMLDOMNode;
    xCount: Integer;
    xNode: ICXMLDOMNode;
begin
  RatesList.BeginUpdate;
  RatesList.Clear;
  FTreeDocument := GetXmlDocument;
  xRoot := FTreeDocument.createElement('root');
  FTreeDocument.appendChild(xRoot);
  for xCount := 0 to FSourceRates.length - 1 do begin
    if ComboBoxType.ItemIndex = 1 then begin
      xNode := FSourceRates.item[xCount].cloneNode(True);
      xRoot.appendChild(xNode);
    end else begin
      xNode := FSourceRates.item[xCount].cloneNode(True);
      if (GCurrencyCache.ByIso[GetXmlAttribute('sourceIso', xNode, '')] <> Nil) and (GCurrencyCache.ByIso[GetXmlAttribute('targetIso', xNode, '')] <> Nil) then begin
        xRoot.appendChild(xNode);
      end;
    end;
  end;
  RatesList.RootNodeCount := FTreeDocument.documentElement.childNodes.length;
  RatesList.EndUpdate;
  RatesList.UpdateScrollBars(False);
end;

procedure TCUpdateCurrencyRatesForm.ComboBoxTypeChange(Sender: TObject);
begin
  RecreateTreeRates;
end;

procedure TCUpdateCurrencyRatesForm.Zaznaczwszystkie1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(RatesList.ViewPref) then begin
    RatesList.ReinitNode(RatesList.RootNode, True);
    RatesList.Repaint;
  end;
  xPrefs.Free;
end;

destructor TCUpdateCurrencyRatesForm.Destroy;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  inherited Destroy;
end;

procedure TCUpdateCurrencyRatesForm.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if RatesList.ViewPref <> Nil then begin
      RatesList.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCUpdateCurrencyRatesForm.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if RatesList.ViewPref <> Nil then begin
      RatesList.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCUpdateCurrencyRatesForm.UpdateIcons;
var xDummy: TPngImageList;
begin
  xDummy := Nil;
  UpdatePanelIcons(Panel2,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, Nil,
                   ActionManager1, Nil,
                   FSmallIconsButtonsImageList,
                   xDummy);
end;


end.

