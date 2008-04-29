unit CDepositCalculatorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CDeposits,
  CComponents, VirtualTrees, Menus, ActnList, CTools, CDatabase, CDataObjects;

type
  TCDepositCalculatorForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    RepaymentList: TCList;
    PanelError: TPanel;
    Label8: TLabel;
    Panel2: TPanel;
    CCurrEditRor: TCCurrEdit;
    PopupMenu1: TPopupMenu;
    Zaznaczwszystkie1: TMenuItem;
    ActionList: TActionList;
    Action1: TAction;
    CButton1: TCButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label6: TLabel;
    CIntEditPeriodCount: TCIntEdit;
    ComboBoxPeriodType: TComboBox;
    Label7: TLabel;
    ComboBoxPeriodAction: TComboBox;
    Label1: TLabel;
    ComboBoxDueMode: TComboBox;
    Label9: TLabel;
    CIntEditDueCount: TCIntEdit;
    ComboBoxDueType: TComboBox;
    Label11: TLabel;
    ComboBoxDueAction: TComboBox;
    Label3: TLabel;
    CDateTimeStart: TCDateTime;
    Label2: TLabel;
    CDateTimeEnd: TCDateTime;
    Label15: TLabel;
    CCurrEditActualCash: TCCurrEdit;
    Label4: TLabel;
    CCurrEditRate: TCCurrEdit;
    Label5: TLabel;
    CDateTimeProg: TCDateTime;
    Label10: TLabel;
    CDateTimeDueEnd: TCDateTime;
    procedure RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Zaznaczwszystkie1Click(Sender: TObject);
    procedure CCurrEditActualCashChange(Sender: TObject);
    procedure CCurrEditRateChange(Sender: TObject);
    procedure CIntEditPeriodCountChange(Sender: TObject);
    procedure ComboBoxPeriodTypeChange(Sender: TObject);
    procedure ComboBoxPeriodActionChange(Sender: TObject);
    procedure ComboBoxDueModeChange(Sender: TObject);
    procedure CIntEditDueCountChange(Sender: TObject);
    procedure ComboBoxDueTypeChange(Sender: TObject);
    procedure ComboBoxDueActionChange(Sender: TObject);
    procedure CDateTimeStartChanged(Sender: TObject);
    procedure CDateTimeProgChanged(Sender: TObject);
    procedure RepaymentListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
  private
    Fdeposit: TDeposit;
    procedure UpdateDepositData;
    function GetDueType: TBaseEnumeration;
    function GetPeriodType: TBaseEnumeration;
  protected
    procedure FillForm; override;
    procedure UpdatePeriodEndDate;
    procedure UpdateDueEndPeriod;
    procedure UpdateProgDateEnd;
    procedure UpdateDues;
  public
    property deposit: TDeposit read Fdeposit write Fdeposit;
    property formPeriodType: TBaseEnumeration read GetPeriodType;
    property formDueType: TBaseEnumeration read GetDueType;
  end;

function ShowDepositCalculator(ACanAccept: Boolean): TDeposit;

implementation

uses CReports, CPreferences, CConsts, CListPreferencesFormUnit, CDatatools;

{$R *.dfm}

function ShowDepositCalculator(ACanAccept: Boolean): TDeposit;
var xForm: TCDepositCalculatorForm;
    xOperation: TConfigOperation;
begin
  Result := TDeposit.Create;
  xForm := TCDepositCalculatorForm.Create(Application);
  xForm.deposit := Result;
  if ACanAccept then begin
    xOperation := coAdd;
  end else begin
    xOperation := coNone;
  end;
  xForm.UpdateDepositData;
  if not xForm.ShowConfig(xOperation) then begin
    FreeAndNil(Result);
  end;
  xForm.Free;
end;

procedure TCDepositCalculatorForm.UpdateDepositData;
var xValid: Boolean;
begin
  if not (csLoading in componentState) then begin
    xValid := (CCurrEditActualCash.Value > 0) and (CIntEditPeriodCount.Value > 0) and
              (CDateTimeStart.Value <> 0) and (CDateTimeEnd.Value <> 0) and (CDateTimeProg.Value <> 0);
    if xValid then begin
      with Fdeposit do begin
        cash := CCurrEditActualCash.Value;
        interestRate := CCurrEditRate.Value;
        noncapitalizedInterest := 0;
        periodCount := CIntEditPeriodCount.Value;
        periodEndDate := CDateTimeEnd.Value;
        periodStartDate := CDateTimeStart.Value;
        dueStartDate := CDateTimeStart.Value;
        dueEndDate := CDateTimeDueEnd.Value;
        progEndDate := CDateTimeProg.Value;
        dueCount := CIntEditDueCount.Value;
        if ComboBoxDueAction.ItemIndex = 0 then begin
          dueAction := CDepositDueActionAutoCapitalisation;
        end else begin
          dueAction := CDepositDueActionLeaveUncapitalised;
        end;
        if ComboBoxPeriodAction.ItemIndex = 1 then begin
          periodAction := CDepositPeriodActionAutoRenew;
        end else begin
          periodAction := CDepositPeriodActionChangeInactive;
        end;
        dueType := formDueType;
        periodType := formPeriodType;
      end;
      xValid := Fdeposit.CalculateProg;
    end;
    if xValid then begin
      CCurrEditRor.Value := Fdeposit.rateOfReturn;
      PanelError.Visible := False;
      with RepaymentList do begin
        BeginUpdate;
        RootNodeCount := Fdeposit.Count;
        EndUpdate;
        Header.Options := Header.Options + [hoVisible];
      end;
      CCurrEditRor.Value := Fdeposit.rateOfReturn;
    end else begin
      PanelError.Visible := True;
      with RepaymentList do begin
        BeginUpdate;
        RootNodeCount := 0;
        EndUpdate;
        Header.Options := Header.Options - [hoVisible];
      end;
    end;
    Action1.Enabled := xValid;
  end;
end;

procedure TCDepositCalculatorForm.RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xObj: TDepositProgItem;
begin
  xObj := Fdeposit.Items[Node.Index];
  if Column = 0 then begin
    CellText := xObj.caption;
  end else if Column = 1 then begin
    CellText := Date2StrDate(xObj.date);
  end else if Column = 2 then begin
    CellText := xObj.operation;
  end else if Column = 3 then begin
    CellText := CurrencyToString(xObj.cash, '', False);
  end else if Column = 4 then begin
    if xObj.movementType = CDepositMovementDue then begin
      CellText := CurrencyToString(xObj.interest, '', False);
    end else begin
      CellText := '';
    end;
  end else if Column = 5 then begin
    if xObj.movementType = CDepositMovementDue then begin
      CellText := CurrencyToString(xObj.cashInterest, '', False);
    end else begin
      CellText := '';
    end;
  end else if Column = 6 then begin
    CellText := CurrencyToString(xObj.noncapitalizedInterest, '', False);
  end;
end;

procedure TCDepositCalculatorForm.FormCreate(Sender: TObject);
begin
  inherited;
  CCurrEditActualCash.CurrencyStr := '';
  RepaymentList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesDepositcalc]);
end;

procedure TCDepositCalculatorForm.Action1Execute(Sender: TObject);
{
var xParams: TLoanReportParams;
    xReport: TLoanReport;
    }
begin
{
  xParams := TLoanReportParams.Create(Floan);
  xReport := TLoanReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
  }
end;

procedure TCDepositCalculatorForm.Zaznaczwszystkie1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(RepaymentList.ViewPref) then begin
    RepaymentList.ReinitNode(RepaymentList.RootNode, True);
    RepaymentList.Repaint;
  end;
  xPrefs.Free;
end;

function TCDepositCalculatorForm.GetDueType: TBaseEnumeration;
begin
  if ComboBoxDueMode.ItemIndex = 0 then begin
    Result := CDepositDueTypeOnDepositEnd;
  end else begin
    if ComboBoxDueType.ItemIndex = 0 then begin
      Result := CDepositTypeDay;
    end else if ComboBoxDueType.ItemIndex = 1 then begin
      Result := CDepositTypeWeek;
    end else if ComboBoxDueType.ItemIndex = 2 then begin
      Result := CDepositTypeMonth;
    end else begin
      Result := CDepositTypeYear;
    end;
  end;
end;

function TCDepositCalculatorForm.GetPeriodType: TBaseEnumeration;
begin
  if ComboBoxPeriodType.ItemIndex = 0 then begin
    Result := CDepositTypeDay;
  end else if ComboBoxPeriodType.ItemIndex = 1 then begin
    Result := CDepositTypeWeek;
  end else if ComboBoxPeriodType.ItemIndex = 2 then begin
    Result := CDepositTypeMonth;
  end else begin
    Result := CDepositTypeYear;
  end;
end;

procedure TCDepositCalculatorForm.CCurrEditActualCashChange(Sender: TObject);
begin
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.CCurrEditRateChange(Sender: TObject);
begin
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.CIntEditPeriodCountChange(Sender: TObject);
begin
  UpdatePeriodEndDate;
  UpdateProgDateEnd;
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.ComboBoxPeriodTypeChange(Sender: TObject);
begin
  UpdatePeriodEndDate;
  UpdateProgDateEnd;
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.ComboBoxPeriodActionChange(Sender: TObject);
begin
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.ComboBoxDueModeChange(Sender: TObject);
begin
  UpdateDues;
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.CIntEditDueCountChange(Sender: TObject);
begin
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.ComboBoxDueTypeChange(Sender: TObject);
begin
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.ComboBoxDueActionChange(Sender: TObject);
begin
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.CDateTimeStartChanged(Sender: TObject);
begin
  UpdatePeriodEndDate;
  UpdateProgDateEnd;
  UpdateDueEndPeriod;
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.FillForm;
begin
  inherited FillForm;
  CDateTimeStart.Value := GWorkDate;
  UpdateDues;
  UpdatePeriodEndDate;
  UpdateProgDateEnd;
  UpdateDueEndPeriod;
end;

procedure TCDepositCalculatorForm.UpdatePeriodEndDate;
begin
  if CIntEditPeriodCount.Value > 0 then begin
    CDateTimeEnd.Value := TDepositInvestment.EndPeriodDatetime(CDateTimeStart.Value, CIntEditPeriodCount.Value, formPeriodType);
  end else begin
    CDateTimeEnd.Caption := '<brak danych>';
  end;
end;

procedure TCDepositCalculatorForm.UpdateDueEndPeriod;
begin
  if ComboBoxDueMode.ItemIndex = 0 then begin
    CDateTimeDueEnd.Value := CDateTimeEnd.Value;
  end else begin
    if CIntEditDueCount.Value > 0 then begin
      CDateTimeDueEnd.Value := TDepositInvestment.EndDueDatetime(CDateTimeStart.Value, CIntEditDueCount.Value, formDueType);
    end else begin
      CDateTimeDueEnd.Caption := '<brak danych>';
    end;
  end;
end;

procedure TCDepositCalculatorForm.UpdateProgDateEnd;
begin
  if CDateTimeEnd.Value <> 0 then begin
    CDateTimeProg.Value := CDateTimeEnd.Value;
  end else begin
    CDateTimeProg.Caption := '<brak danych>';
  end;
end;

procedure TCDepositCalculatorForm.CDateTimeProgChanged(Sender: TObject);
begin
  UpdateDepositData;
end;

procedure TCDepositCalculatorForm.RepaymentListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xObj: TDepositProgItem;
begin
  xObj := Fdeposit.Items[Node.Index];
  LineBreakStyle := hlbForceMultiLine;
  if xObj.movementType = CDepositMovementDue then begin
    HintText := 'Odsetki za okres ' + Date2StrDate(xObj.dueStart) + ' - ' + Date2StrDate(xObj.dueEnd);
  end else begin
    HintText := 'Za okres trwania lokaty ' + Date2StrDate(xObj.periodStart) + ' - ' + Date2StrDate(xObj.periodEnd);
  end;
end;

procedure TCDepositCalculatorForm.UpdateDues;
begin
  Label9.Enabled := ComboBoxDueMode.ItemIndex = 1;
  CIntEditDueCount.Enabled := ComboBoxDueMode.ItemIndex = 1;
  ComboBoxDueType.Enabled := ComboBoxDueMode.ItemIndex = 1;
end;

end.
