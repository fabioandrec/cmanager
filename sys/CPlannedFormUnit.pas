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
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    Label2: TLabel;
    CStaticCategory: TCStatic;
    Label6: TLabel;
    CStaticCashpoint: TCStatic;
    Label9: TLabel;
    CCurrEdit: TCCurrEdit;
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
    Label17: TLabel;
    CStaticCurrency: TCStatic;
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
  CCurrencydefFrameUnit;

{$R *.dfm}

function TCPlannedForm.ChooseAccount(var AId: String; var AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCAccountsFrame, AId, AText);
end;

procedure TCPlannedForm.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCPlannedForm.InitializeForm;
begin
  FSchedule := TSchedule.Create;
  if Operation = coAdd then begin
    CStaticCurrency.DataId := CCurrencyDefGid_PLN;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CCurrencyDefGid_PLN, False)).GetElementText;
    CCurrEdit.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
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
  UpdateDescription;
end;


function TCPlannedForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticCategory.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCategory.DoGetDataId;
    end;
  end;
end;

procedure TCPlannedForm.FillForm;
begin
  with TPlannedMovement(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    SimpleRichText(description, RichEditDesc);
    CCurrEdit.Value := cash;
    ComboBoxType.ItemIndex := IfThen(movementType = COutMovement, 0, 1);
    ComboBoxStatus.ItemIndex := IfThen(isActive, 0, 1);
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
    FSchedule.scheduleType := scheduleType;
    FSchedule.scheduleDate := scheduleDate;
    FSchedule.endCondition := endCondition;
    FSchedule.endCount := endCount;
    FSchedule.endDate := endDate;
    FSchedule.triggerType := triggerType;
    FSchedule.triggerDay := triggerDay;
    FSchedule.freeDays := freeDays;
    ComboBoxTypeChange(ComboBoxType);
    CStaticSchedule.Caption := FSchedule.AsString;
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
    cash := CCurrEdit.Value;
    movementType := IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement);
    isActive := ComboBoxStatus.ItemIndex = 0;
    idAccount := CStaticAccount.DataId;
    idCashPoint := CStaticCashpoint.DataId;
    idProduct := CStaticCategory.DataId;
    scheduleType := FSchedule.scheduleType;
    scheduleDate := FSchedule.scheduleDate;
    endCondition := FSchedule.endCondition;
    endCount := FSchedule.endCount;
    endDate := FSchedule.endDate;
    triggerType := FSchedule.triggerType;
    triggerDay := FSchedule.triggerDay;
    freeDays := FSchedule.freeDays;
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
    if CStaticAccount.DataId <> CEmptyDataGid then begin
      Result := CStaticAccount.Caption;
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

end.
