unit CDepositInvestmentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, ActnMan, CImageListsUnit,
  Contnrs, CDataObjects, XPStyleActnCtrls;

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
    Label18: TLabel;
    CCurrEditCapital: TCCurrEdit;
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
  private
    procedure UpdateNextPeriodDatetime;
    procedure UpdateNextCapitalisationDatetime;
    function GetPeriodType: TBaseEnumeration;
  protected
    procedure ReadValues; override;
    procedure InitializeForm; override;
  public
    property formPeriodType: TBaseEnumeration read GetPeriodType;
  end;

implementation

uses CConsts, CConfigFormUnit;

{$R *.dfm}

function TCDepositInvestmentForm.GetPeriodType: TBaseEnumeration;
begin
  if ComboBoxPeriodType.ItemHeight = 0 then begin
    Result := CDepositPeriodTypeDay;
  end else if ComboBoxPeriodType.ItemHeight = 1 then begin
    Result := CDepositPeriodTypeWeek;
  end else if ComboBoxPeriodType.ItemHeight = 2 then begin
    Result := CDepositPeriodTypeMonth;
  end else begin
    Result := CDepositPeriodTypeYear;
  end;
end;

procedure TCDepositInvestmentForm.InitializeForm;
begin
  inherited InitializeForm;
  CDateTime.Value := Now;
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
    initialCash := CCurrEditCapital.Value;
    noncapitalizedInterest := CCurrEditActualInterest.Value;
    interestRate := CCurrEditRate.Value;
    periodCount := CIntEditPeriodCount.Value;
    dueCount := CIntEditDueCount.Value;
    if Operation = coAdd then begin
      dueLastDatetime := 0;
      periodLastDatetime := 0;
    end;
    dueNextDatetime := CDateTimeNextDue.Value;
    periodNextDatetime := CDateTimeDepositEndDate.Value;
    if ComboBoxDueMode.ItemIndex = 0 then begin
      dueType := CDepositDueTypeOnDepositEnd;
    end else begin
      if ComboBoxDueType.ItemIndex = 0 then begin
        dueType := CDepositDueTypeDay;
      end else if ComboBoxDueType.ItemIndex = 1 then begin
        dueType := CDepositDueTypeWeek;
      end else if ComboBoxDueType.ItemIndex = 2 then begin
        dueType := CDepositDueTypeMonth;
      end else begin
        dueType := CDepositDueTypeYear;
      end;
    end;
    if ComboBoxDueAction.ItemHeight = 0 then begin
      periodAction := CDepositDueActionAutoCapitalisation;
    end else begin
      periodAction := CDepositDueActionLeaveUncapitalised;
    end;
    periodType := formPeriodType;
    if ComboBoxPeriodAction.ItemHeight = 0 then begin
      periodAction := CDepositPeriodActionAutoRenew;
    end else begin
      periodAction := CDepositPeriodActionChangeInactive;
    end;
  end;
end;

procedure TCDepositInvestmentForm.UpdateNextCapitalisationDatetime;
begin

end;

procedure TCDepositInvestmentForm.UpdateNextPeriodDatetime;
begin
  if Operation = coAdd then begin
    CDateTimeDepositEndDate.Value := TDepositInvestment.NextPeriodDatetime(CDateTime.Value, CIntEditPeriodCount.Value, formPeriodType)
  end else begin
    CDateTimeDepositEndDate.Value := TDepositInvestment.NextPeriodDatetime(TDepositInvestment(Dataobject).periodLastDatetime, CIntEditPeriodCount.Value, formPeriodType);
  end;
end;

end.
