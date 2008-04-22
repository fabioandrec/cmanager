unit CDepositInvestmentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, ActnMan, CImageListsUnit,
  Contnrs, CDataObjects, XPStyleActnCtrls, Math;

type
  TCDepositInvestmentForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    RichEditDesc: TCRichEdit;
    GroupBox3: TGroupBox;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    CButton1: TCButton;
    ActionTemplate: TAction;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    CDateTime: TCDateTime;
    Label5: TLabel;
    ComboBoxState: TComboBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    CStaticCashpoint: TCStatic;
    Label2: TLabel;
    EditName: TEdit;
    Label10: TLabel;
    CStaticCurrency: TCStatic;
    Label4: TLabel;
    CCurrEditRate: TCCurrEdit;
    Label6: TLabel;
    CIntEditPeriodCount: TCIntEdit;
    ComboBoxPeriodType: TComboBox;
    ComboBoxPeriodAction: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    ComboBoxDueMode: TComboBox;
    Label9: TLabel;
    CIntEditDueCount: TCIntEdit;
    ComboBoxDueType: TComboBox;
    Label11: TLabel;
    ComboBoxDueAction: TComboBox;
    Label12: TLabel;
    CDateTimeDepositEndDate: TCDateTime;
    Label13: TLabel;
    CDateTimeNextDue: TCDateTime;
    Label15: TLabel;
    CCurrEditActualCash: TCCurrEdit;
    Label16: TLabel;
    CCurrEditActualInterest: TCCurrEdit;
    procedure CDateTimeChanged(Sender: TObject);
    procedure ComboBoxPeriodTypeChange(Sender: TObject);
    procedure CIntEditPeriodCountChange(Sender: TObject);
    procedure ComboBoxDueModeChange(Sender: TObject);
    procedure CIntEditDueCountChange(Sender: TObject);
    procedure ComboBoxDueTypeChange(Sender: TObject);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyChanged(Sender: TObject);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointChanged(Sender: TObject);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
    procedure ComboBoxStateChange(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
  private
    procedure UpdateNextPeriodDatetime;
    procedure UpdateNextCapitalisationDatetime;
    procedure UpdateDescription;
    function GetPeriodType: TBaseEnumeration;
    function GetDueType: TBaseEnumeration;
    procedure SetDueType(const Value: TBaseEnumeration);
    procedure SetPeriodType(const Value: TBaseEnumeration);
  protected
    procedure ReadValues; override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function GetDataobjectClass: TDataObjectClass; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure FillForm; override;
  public
    property formPeriodType: TBaseEnumeration read GetPeriodType write SetPeriodType;
    property formDueType: TBaseEnumeration read GetDueType write SetDueType;
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CConsts, CConfigFormUnit, CFrameFormUnit, CCurrencydefFrameUnit,
  CAccountsFrameUnit, CCashpointFormUnit, CCashpointsFrameUnit, CTemplates,
  CDescpatternFormUnit, CPreferences, CRichtext, CTools, CInfoFormUnit,
  CDepositInvestmentFrameUnit;

{$R *.dfm}

function TCDepositInvestmentForm.GetPeriodType: TBaseEnumeration;
begin
  if ComboBoxPeriodType.ItemIndex = 0 then begin
    Result := CDepositPeriodTypeDay;
  end else if ComboBoxPeriodType.ItemIndex = 1 then begin
    Result := CDepositPeriodTypeWeek;
  end else if ComboBoxPeriodType.ItemIndex = 2 then begin
    Result := CDepositPeriodTypeMonth;
  end else begin
    Result := CDepositPeriodTypeYear;
  end;
end;

procedure TCDepositInvestmentForm.InitializeForm;
begin
  inherited InitializeForm;
  CDateTime.Value := Now;
  ComboBoxDueModeChange(ComboBoxDueMode);
  CStaticCurrency.DataId := CCurrencyDefGid_PLN;
  CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CCurrencyDefGid_PLN, False)).GetElementText;
  CCurrEditActualCash.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
  CCurrEditActualInterest.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
  if Operation = coAdd then begin
    CCurrEditActualInterest.Enabled := False;
    ComboBoxState.Enabled := False;
  end;
  UpdateNextPeriodDatetime;
  UpdateNextCapitalisationDatetime;
end;

procedure TCDepositInvestmentForm.ReadValues;
begin
  inherited ReadValues;
  with TDepositInvestment(Dataobject) do begin
    if ComboBoxState.ItemIndex = 0 then begin
      depositState := CDepositInvestmentActive;
    end else if ComboBoxState.ItemIndex = 1 then begin
      depositState := CDepositInvestmentClosed;
    end else begin
      depositState := CDepositInvestmentInactive;
    end;
    name := EditName.Text;
    description := RichEditDesc.Text;
    idAccount := CStaticAccount.DataId;
    idCashPoint := CStaticCashpoint.DataId;
    idCurrencyDef := CStaticCurrency.DataId;
    currentCash := CCurrEditActualCash.Value;
    if Operation = coAdd then begin
      initialCash := CCurrEditActualCash.Value;
    end;
    noncapitalizedInterest := CCurrEditActualInterest.Value;
    interestRate := CCurrEditRate.Value;
    periodCount := CIntEditPeriodCount.Value;
    dueCount := CIntEditDueCount.Value;
    if Operation = coAdd then begin
      dueLastDate := CDateTime.Value;
      periodLastDate := CDateTime.Value;
      openDate := CDateTime.Value;
    end;
    dueNextDate := CDateTimeNextDue.Value;
    periodNextDate := CDateTimeDepositEndDate.Value;
    dueType := formDueType;
    if ComboBoxDueAction.ItemIndex = 0 then begin
      dueAction := CDepositDueActionAutoCapitalisation;
    end else begin
      dueAction := CDepositDueActionLeaveUncapitalised;
    end;
    periodType := formPeriodType;
    if ComboBoxPeriodAction.ItemIndex = 0 then begin
      periodAction := CDepositPeriodActionAutoRenew;
    end else begin
      periodAction := CDepositPeriodActionChangeInactive;
    end;
  end;
end;

procedure TCDepositInvestmentForm.UpdateNextCapitalisationDatetime;
var xNextDue: TDateTime;
begin
  if ComboBoxDueMode.ItemIndex = 0 then begin
    xNextDue := CDateTimeDepositEndDate.Value;
  end else begin
    xNextDue := TDepositInvestment.NextDueDatetime(CDateTime.Value, CIntEditDueCount.Value, formDueType);
  end;
  CDateTimeNextDue.Value := xNextDue;
end;

procedure TCDepositInvestmentForm.UpdateNextPeriodDatetime;
begin
  CDateTimeDepositEndDate.Value := TDepositInvestment.NextPeriodDatetime(CDateTime.Value, CIntEditPeriodCount.Value, formPeriodType)
end;

procedure TCDepositInvestmentForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateNextPeriodDatetime;
  UpdateNextCapitalisationDatetime;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[9][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GDepositInvestmentTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCDepositInvestmentForm.ComboBoxPeriodTypeChange(Sender: TObject);
begin
  UpdateNextPeriodDatetime;
  UpdateNextCapitalisationDatetime;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CIntEditPeriodCountChange(Sender: TObject);
begin
  UpdateNextPeriodDatetime;
  UpdateNextCapitalisationDatetime;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.ComboBoxDueModeChange(Sender: TObject);
begin
  Label9.Enabled := ComboBoxDueMode.ItemIndex = 1;
  CIntEditDueCount.Enabled := ComboBoxDueMode.ItemIndex = 1;
  ComboBoxDueType.Enabled := ComboBoxDueMode.ItemIndex = 1;
  Label11.Enabled := ComboBoxDueMode.ItemIndex = 1;
  ComboBoxDueAction.Enabled := ComboBoxDueMode.ItemIndex = 1;
  UpdateNextCapitalisationDatetime;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CIntEditDueCountChange(Sender: TObject);
begin
  UpdateNextCapitalisationDatetime;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.ComboBoxDueTypeChange(Sender: TObject);
begin
  UpdateNextCapitalisationDatetime;
  UpdateDescription;
end;

function TCDepositInvestmentForm.GetDueType: TBaseEnumeration;
begin
  if ComboBoxDueMode.ItemIndex = 0 then begin
    Result := CDepositDueTypeOnDepositEnd;
  end else begin
    if ComboBoxDueType.ItemIndex = 0 then begin
      Result := CDepositDueTypeDay;
    end else if ComboBoxDueType.ItemIndex = 1 then begin
      Result := CDepositDueTypeWeek;
    end else if ComboBoxDueType.ItemIndex = 2 then begin
      Result := CDepositDueTypeMonth;
    end else begin
      Result := CDepositDueTypeYear;
    end;
  end;
end;

procedure TCDepositInvestmentForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEditActualCash.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
  CCurrEditActualInterest.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CStaticAccountChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.CStaticCashpointChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GDepositInvestmentTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCDepositInvestmentForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[9][0], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCDepositInvestmentForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@data@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@stan@' then begin
    Result := ComboBoxState.Text;
  end else if ATemplate = '@nazwa@' then begin
    if EditName.Text = '' then begin
      Result := '<nazwa lokaty>';
    end else begin
      Result := EditName.Text;
    end;
  end else if ATemplate = '@konto@' then begin
    Result := '<konto stowarzyszone>';
    if CStaticAccount.DataId <> CEmptyDataGid then begin
      Result := CStaticAccount.Caption;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<prowadz¹cy lokatê>';
    if CStaticCashpoint.DataId <> CEmptyDataGid then begin
      Result := CStaticCashpoint.Caption;
    end;
  end else if ATemplate = '@isowaluty@' then begin
    Result := '<iso waluty lokaty>';
    if CStaticCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetIso(CStaticCurrency.DataId);
    end;
  end else if ATemplate = '@symbolwaluty@' then begin
    Result := '<symbol waluty lokaty>';
    if CStaticCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetSymbol(CStaticCurrency.DataId);
    end;
  end else if ATemplate = '@iloscOkres@' then begin
    Result := IntToStr(CIntEditPeriodCount.Value);
  end else if ATemplate = '@typOkres@' then begin
    Result := ComboBoxPeriodType.Text;
  end else if ATemplate = '@iloscOdsetki@' then begin
    Result := IntToStr(CIntEditDueCount.Value);
  end else if ATemplate = '@typOdsetki@' then begin
    if ComboBoxDueMode.ItemIndex = 0 then begin
      Result := ComboBoxDueMode.Text;
    end else begin
      Result := ComboBoxDueType.Text;
    end;
  end;
end;

procedure TCDepositInvestmentForm.EditNameChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.ComboBoxStateChange(Sender: TObject);
begin
  UpdateDescription;
end;

function TCDepositInvestmentForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa lokaty nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if CStaticCurrency.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty lokaty. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCurrency.DoGetDataId;
    end;
  end else if ComboBoxDueMode.ItemIndex <> 0 then begin
    if CDateTimeNextDue.Value > CDateTimeDepositEndDate.Value then begin
      Result := False;
      ShowInfo(itError, 'Okres naliczania odsetek nie byæ wiêkszy od czasu trwania lokaty', '');
      ComboBoxDueType.SetFocus;
    end;
  end;
end;

function TCDepositInvestmentForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TDepositInvestment;
end;

function TCDepositInvestmentForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCDepositInvestmentFrame;
end;

procedure TCDepositInvestmentForm.FillForm;
begin
  with TDepositInvestment(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    CCurrEditActualCash.Value := currentCash;
    CDateTime.Value := openDate;
    CDateTime.Enabled := (dueLastDate = 0);
    CCurrEditActualInterest.Value := noncapitalizedInterest;
    CCurrEditRate.Value := interestRate;
    CIntEditPeriodCount.Value := periodCount;
    CIntEditDueCount.Value := dueCount;
    CDateTimeNextDue.Value := dueNextDate;
    CDateTimeDepositEndDate.Value := periodNextDate;
    GDataProvider.BeginTransaction;
    if idAccount <> CEmptyDataGid then begin
      CStaticAccount.DataId := idAccount;
      CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
    end;
    if idCashPoint <> CEmptyDataGid then begin
      CStaticCashpoint.DataId := idAccount;
      CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
    end;
    CStaticCurrency.DataId := idCurrencyDef;
    CStaticCurrency.Caption := GCurrencyCache.GetIso(idCurrencyDef);
    GDataProvider.RollbackTransaction;
    CCurrEditActualCash.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    CCurrEditActualInterest.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    if periodAction = CDepositPeriodActionAutoRenew then begin
      ComboBoxPeriodAction.ItemIndex := 0;
    end else if periodAction = CDepositPeriodActionChangeInactive then begin
      ComboBoxPeriodAction.ItemIndex := 1;
    end;
    if dueAction = CDepositDueActionAutoCapitalisation then begin
      ComboBoxDueAction.ItemIndex := 0;
    end else if dueAction = CDepositDueActionLeaveUncapitalised then begin
      ComboBoxDueAction.ItemIndex := 1;
    end;
    if depositState = CDepositInvestmentActive then begin
      ComboBoxState.ItemIndex := 0;
    end else if depositState = CDepositInvestmentClosed then begin
      ComboBoxState.ItemIndex := 1;
    end else if depositState = CDepositInvestmentInactive then begin
      ComboBoxState.ItemIndex := 2;
    end;
    formDueType := dueType;
    formPeriodType := periodType;
  end;
end;

procedure TCDepositInvestmentForm.SetDueType(const Value: TBaseEnumeration);
begin
  if Value = CDepositDueTypeOnDepositEnd then begin
    ComboBoxDueMode.ItemIndex := 0;
  end else begin
    ComboBoxDueMode.ItemIndex := 1;
    if Value = CDepositDueTypeDay then begin
      ComboBoxDueType.ItemIndex := 0;
    end else if Value = CDepositDueTypeWeek then begin
      ComboBoxDueType.ItemIndex := 1;
    end else if Value = CDepositDueTypeMonth then begin
      ComboBoxDueType.ItemIndex := 2;
    end else if Value = CDepositDueTypeYear then begin
      ComboBoxDueType.ItemIndex := 3;
    end;
  end;
  ComboBoxDueModeChange(Nil);
end;

procedure TCDepositInvestmentForm.SetPeriodType(const Value: TBaseEnumeration);
begin
  if Value = CDepositPeriodTypeDay then begin
    ComboBoxPeriodType.ItemIndex := 0;
  end else if Value = CDepositPeriodTypeWeek then begin
    ComboBoxPeriodType.ItemIndex := 1;
  end else if Value = CDepositPeriodTypeMonth then begin
    ComboBoxPeriodType.ItemIndex := 2;
  end else if Value = CDepositPeriodTypeYear then begin
    ComboBoxPeriodType.ItemIndex := 3;
  end;
end;

procedure TCDepositInvestmentForm.ComboBoxTemplateChange(Sender: TObject);
begin
  UpdateDescription;
end;

end.
