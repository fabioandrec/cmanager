unit CPlannedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, ActnList, CScheduleFormUnit, CBaseFrameUnit,
  XPStyleActnCtrls, ActnMan, Contnrs;

type
  TCPlannedForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TCRichEdit;
    GroupBox3: TGroupBox;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label7: TLabel;
    ComboBoxStatus: TComboBox;
    Label1: TLabel;
    CStaticSchedule: TCStatic;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    PageControl: TPageControl;
    TabSheetInOut: TTabSheet;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    Label2: TLabel;
    CStaticCategory: TCStatic;
    Label15: TLabel;
    CCurrEditQuantity: TCCurrEdit;
    Label6: TLabel;
    CStaticCashpoint: TCStatic;
    Label17: TLabel;
    CStaticCurrency: TCStatic;
    Label9: TLabel;
    CCurrEdit: TCCurrEdit;
    TabSheetTransfer: TTabSheet;
    Label3: TLabel;
    CStaticAccoutTransferSource: TCStatic;
    Label8: TLabel;
    CStaticSourceCurrencyDefTransfer: TCStatic;
    Label10: TLabel;
    CCurrEditTransfer: TCCurrEdit;
    Label11: TLabel;
    CStaticAccoutTransferDest: TCStatic;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure ComboBoxModeChange(Sender: TObject);
    procedure CStaticScheduleGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
    procedure CStaticCurrencyChanged(Sender: TObject);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure CStaticAccoutTransferSourceChanged(Sender: TObject);
    procedure CStaticAccoutTransferSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccoutTransferDestGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccoutTransferDestChanged(Sender: TObject);
  private
    FSchedule: TSchedule;
  protected
    procedure UpdateDescription;
    procedure InitializeForm; override;
    function ChooseAccount(var AId: String; var AText: String): Boolean;
    function ChooseCashpoint(var AId: String; var AText: String): Boolean;
    function ChooseProduct(var AId: String; var AText: String): Boolean;
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  public
    destructor Destroy; override;
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CAccountsFrameUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CProductsFrameUnit, CDataObjects, DateUtils, StrUtils, Math,
  CConfigFormUnit, CInfoFormUnit, CConsts, CPlannedFrameUnit, CTemplates,
  CDescpatternFormUnit, CPreferences, CRichtext, CDataobjectFrameUnit,
  CCurrencydefFrameUnit, CDatatools, CTools;

{$R *.dfm}

function TCPlannedForm.ChooseAccount(var AId: String; var AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCAccountsFrame, AId, AText);
end;

procedure TCPlannedForm.ComboBoxTypeChange(Sender: TObject);
begin
  PageControl.ActivePageIndex := IfThen(ComboBoxType.ItemIndex = 2, 1, 0);
  UpdateDescription;
end;

procedure TCPlannedForm.InitializeForm;
begin
  FSchedule := TSchedule.Create;
  if Operation = coAdd then begin
    CStaticCurrency.DataId := GDefaultCurrencyId;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, GDefaultCurrencyId, False)).GetElementText;
    CCurrEdit.SetCurrencyDef(GDefaultCurrencyId, GCurrencyCache.GetSymbol(GDefaultCurrencyId));
    CStaticCategoryChanged(Nil);
  end;
  ComboBoxTypeChange(ComboBoxType);
  CStaticSchedule.Caption := FSchedule.AsString;
  UpdateDescription;
end;

procedure TCPlannedForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

function TCPlannedForm.ChooseCashpoint(var AId, AText: String): Boolean;
var xCt: String;
begin
  if (ComboBoxType.ItemIndex = 0) then begin
    xCt := CCashpointTypeOut;
  end else begin
    xCt := CCashpointTypeIn;
  end;
  Result := TCFrameForm.ShowFrame(TCCashpointsFrame, AId, AText, TCDataobjectFrameData.CreateWithFilter(xCt));
end;

procedure TCPlannedForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

function TCPlannedForm.ChooseProduct(var AId, AText: String): Boolean;
var xProd: String;
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 3) then begin
    xProd := COutProduct;
  end else begin
    xProd := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCProductsFrame, AId, AText, TCDataobjectFrameData.CreateWithFilter(xProd));
end;

procedure TCPlannedForm.CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCPlannedForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[2][ComboBoxType.ItemIndex], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GPlannedMovementTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCPlannedForm.CStaticAccountChanged(Sender: TObject);
begin
  CCurrEdit.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
  UpdateDescription;
end;

function TCPlannedForm.CanAccept: Boolean;
begin
  Result := True;
  if ComboBoxType.ItemIndex = 2 then begin
    if CStaticAccoutTransferSource.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta Ÿród³owego operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticAccoutTransferSource.DoGetDataId;
      end;
    end else if CStaticAccoutTransferDest.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta docelowego operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticAccoutTransferDest.DoGetDataId;
      end;
    end else if CStaticAccoutTransferSource.DataId = CStaticAccoutTransferDest.DataId then begin
      ShowInfo(itError, 'Konto Ÿród³owe nie mo¿e byæ kontem docelowym', '');
      Result := False;
    end;
  end else begin
    if CStaticCategory.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticCategory.DoGetDataId;
      end;
    end else if CStaticCurrency.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano waluty operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticCurrency.DoGetDataId;
      end;
    end;
  end;
end;

procedure TCPlannedForm.FillForm;
begin
  with TPlannedMovement(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    SimpleRichText(description, RichEditDesc);
    if movementType = COutMovement then begin
      ComboBoxType.ItemIndex := 0;
    end else if movementType = CInMovement then begin
      ComboBoxType.ItemIndex := 1;
    end else if movementType = CTransferMovement then begin
      ComboBoxType.ItemIndex := 2;
    end;
    ComboBoxStatus.ItemIndex := IfThen(isActive, 0, 1);
    FSchedule.scheduleType := scheduleType;
    FSchedule.scheduleDate := scheduleDate;
    FSchedule.endCondition := endCondition;
    FSchedule.endCount := endCount;
    FSchedule.endDate := endDate;
    FSchedule.triggerType := triggerType;
    FSchedule.triggerDay := triggerDay;
    FSchedule.freeDays := freeDays;
    CStaticSchedule.Caption := FSchedule.AsString;
    if movementType = CTransferMovement then begin
      CCurrEditTransfer.Value := cash;
      CStaticAccoutTransferSource.DataId := idAccount;
      if idAccount <> CEmptyDataGid then begin
        CStaticAccoutTransferSource.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      end;
      CStaticAccoutTransferDest.DataId := idDestAccount;
      if idDestAccount <> CEmptyDataGid then begin
        CStaticAccoutTransferDest.Caption := TAccount(TAccount.LoadObject(AccountProxy, idDestAccount, False)).name;
      end;
      CStaticSourceCurrencyDefTransfer.DataId := idMovementCurrencyDef;
      if idMovementCurrencyDef <> CEmptyDataGid then begin
        CStaticSourceCurrencyDefTransfer.Caption := GCurrencyCache.GetIso(idMovementCurrencyDef);
      end;
      CCurrEditTransfer.SetCurrencyDef(idMovementCurrencyDef, GCurrencyCache.GetSymbol(idMovementCurrencyDef));
    end else begin
      CCurrEdit.Value := cash;
      CStaticAccount.DataId := idAccount;
      if idAccount <> CEmptyDataGid then begin
        CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      end;
      CStaticCashpoint.DataId := idCashPoint;
      if idCashPoint <> CEmptyDataGid then begin
        CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
      end;
      CStaticCategory.DataId := idProduct;
      CStaticCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
      CStaticCashpoint.DataId := idCashPoint;
      CStaticCurrency.DataId := idMovementCurrencyDef;
      CCurrEditQuantity.Value := quantity;
      if idMovementCurrencyDef <> CEmptyDataGid then begin
        CStaticCurrency.Caption := GCurrencyCache.GetIso(idMovementCurrencyDef);
      end;
      CStaticCategoryChanged(Nil);
      CCurrEdit.SetCurrencyDef(idMovementCurrencyDef, GCurrencyCache.GetSymbol(idMovementCurrencyDef));
    end;
    ComboBoxTypeChange(Nil);
  end;
end;

function TCPlannedForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TPlannedMovement;
end;

procedure TCPlannedForm.ReadValues;
begin
  with TPlannedMovement(Dataobject) do begin
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      movementType := COutMovement;
    end else if ComboBoxType.ItemIndex = 1 then begin
      movementType := CInMovement;
    end else begin
      movementType := CTransferMovement;
    end;
    isActive := ComboBoxStatus.ItemIndex = 0;
    scheduleType := FSchedule.scheduleType;
    scheduleDate := FSchedule.scheduleDate;
    endCondition := FSchedule.endCondition;
    endCount := FSchedule.endCount;
    endDate := FSchedule.endDate;
    triggerType := FSchedule.triggerType;
    triggerDay := FSchedule.triggerDay;
    freeDays := FSchedule.freeDays;
    if ComboBoxType.ItemIndex <> 2 then begin
      cash := CCurrEdit.Value;
      idAccount := CStaticAccount.DataId;
      idCashPoint := CStaticCashpoint.DataId;
      idProduct := CStaticCategory.DataId;
      idMovementCurrencyDef := CStaticCurrency.DataId;
      quantity := CCurrEditQuantity.Value;
      idUnitDef := TProduct.HasQuantity(idProduct);
    end else begin
      cash := CCurrEditTransfer.Value;
      idAccount := CStaticAccoutTransferSource.DataId;
      idDestAccount := CStaticAccoutTransferDest.DataId;
      idCashPoint := CEmptyDataGid;
      idProduct := CEmptyDataGid;
      idMovementCurrencyDef := CStaticSourceCurrencyDefTransfer.DataId;
      quantity := 1;
      idUnitDef := CEmptyDataGid;
    end;
  end;
end;

procedure TCPlannedForm.ComboBoxModeChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCPlannedForm.CStaticScheduleGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := GetSchedule(FSchedule);
  if AAccepted then begin
    ADataGid := '1';
    AText := FSchedule.AsString;
  end;
end;

destructor TCPlannedForm.Destroy;
begin
  FSchedule.Free;
  inherited Destroy;
end;

function TCPlannedForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCPlannedFrame;
end;

procedure TCPlannedForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GPlannedMovementTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCPlannedForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[2][ComboBoxType.ItemIndex], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCPlannedForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@status' then begin
    Result := ComboBoxStatus.Text;
  end else if ATemplate = '@rodzaj@' then begin
    Result := ComboBoxType.Text;
  end else if ATemplate = '@kontozrodlowe@' then begin
    Result := '<konto Ÿród³owe>';
    if ComboBoxType.ItemIndex = 2 then begin
      if CStaticAccoutTransferSource.DataId <> CEmptyDataGid then begin
        Result := CStaticAccoutTransferSource.Caption;
      end;
    end else begin
      if CStaticAccount.DataId <> CEmptyDataGid then begin
        Result := CStaticAccount.Caption;
      end;
    end;
  end else if ATemplate = '@kontodocelowe@' then begin
    Result := '<konto docelowe>';
    if CStaticAccoutTransferDest.DataId <> CEmptyDataGid then begin
      Result := CStaticAccoutTransferDest.Caption;
    end;
  end else if ATemplate = '@kategoria@' then begin
    Result := '<kategoria>';
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      Result := CStaticCategory.Caption;
    end;
  end else if ATemplate = '@pelnakategoria@' then begin
    Result := '<pelnakategoria>';
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      Result := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False)).treeDesc;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<kontrahent>';
    if CStaticCashpoint.DataId <> CEmptyDataGid then begin
      Result := CStaticCashpoint.Caption;
    end;
  end else if ATemplate = '@harmonogram@' then begin
    Result := FSchedule.AsString;
  end;
end;

procedure TCPlannedForm.ComboBoxTemplateChange(Sender: TObject);
begin
  UpdateDescription
end;

procedure TCPlannedForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEdit.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
end;

procedure TCPlannedForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCPlannedForm.CStaticCategoryChanged(Sender: TObject);
var xHasQuant: TDataGid;
begin
  xHasQuant := TProduct.HasQuantity(CStaticCategory.DataId);
  CStaticCategory.Width := IfThen(xHasQuant = CEmptyDataGid, 361, 169);
  SetComponentUnitdef(xHasQuant, CCurrEditQuantity);
  UpdateDescription;
end;

procedure TCPlannedForm.CStaticAccoutTransferSourceChanged(Sender: TObject);
var xCurrencyId: TDataGid;
begin
  if CStaticAccoutTransferSource.DataId <> CEmptyDataGid then begin
    xCurrencyId := TAccount.GetCurrencyDefinition(CStaticAccoutTransferSource.DataId);
    CStaticSourceCurrencyDefTransfer.DataId := xCurrencyId;
    CStaticSourceCurrencyDefTransfer.Caption := GCurrencyCache.GetIso(xCurrencyId);
    CCurrEditTransfer.SetCurrencyDef(CStaticSourceCurrencyDefTransfer.DataId, GCurrencyCache.GetSymbol(CStaticSourceCurrencyDefTransfer.DataId));
  end else begin
    CStaticSourceCurrencyDefTransfer.DataId := CEmptyDataGid;
    CCurrEditTransfer.SetCurrencyDef(CEmptyDataGid, '');
  end;
  UpdateDescription;
end;

procedure TCPlannedForm.CStaticAccoutTransferSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticAccoutTransferDestGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticAccoutTransferDestChanged(Sender: TObject);
begin
  UpdateDescription;
end;

end.
