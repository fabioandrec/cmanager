unit CLoanCalculatorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CLoans,
  CComponents, VirtualTrees, Menus, ActnList;

type
  TCLoanCalculatorForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    CDateTime: TCDateTime;
    ComboBoxType: TComboBox;
    ComboBoxPeriod: TComboBox;
    Label1: TLabel;
    Label4: TLabel;
    CIntEditTimes: TCIntEdit;
    Label2: TLabel;
    CCurrEditTax: TCCurrEdit;
    Label6: TLabel;
    CCurrEditCash: TCCurrEdit;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    RepaymentList: TCList;
    PanelError: TPanel;
    Label7: TLabel;
    CCurrEditOthers: TCCurrEdit;
    Label8: TLabel;
    Panel2: TPanel;
    CCurrEditRrso: TCCurrEdit;
    PopupMenu1: TPopupMenu;
    Zaznaczwszystkie1: TMenuItem;
    ActionList: TActionList;
    Action1: TAction;
    CButton1: TCButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure ComboBoxPeriodChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CCurrEditCashChange(Sender: TObject);
    procedure CCurrEditTaxChange(Sender: TObject);
    procedure CIntEditTimesChange(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure BitBtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Zaznaczwszystkie1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    Floan: TLoan;
    procedure UpdateLoanData;
  public
    property loan: TLoan read Floan write Floan;
  end;

function ShowLoanCalculator(ACanAccept: Boolean): TLoan;

implementation

uses CDatabase, CReports, CTools, CPreferences, CConsts,
  CListPreferencesFormUnit, CDatatools;

{$R *.dfm}

function ShowLoanCalculator(ACanAccept: Boolean): TLoan;
var xForm: TCLoanCalculatorForm;
    xOperation: TConfigOperation;
begin
  Result := TLoan.Create;
  xForm := TCLoanCalculatorForm.Create(Application);
  xForm.loan := Result;
  if ACanAccept then begin
    xOperation := coAdd;
  end else begin
    xOperation := coNone;
  end;
  xForm.UpdateLoanData;
  if not xForm.ShowConfig(xOperation) then begin
    FreeAndNil(Result);
  end;
  xForm.Free;
end;

procedure TCLoanCalculatorForm.UpdateLoanData;
var xValid: Boolean;
begin
  if not (csLoading in componentState) then begin
    xValid := (CCurrEditCash.Value <> 0) and (CIntEditTimes.Value <> 0) and (CIntEditTimes.Value <> -1);
    if xValid then begin
      with Floan do begin
        periods := CIntEditTimes.Value;
        totalCash := CCurrEditCash.Value;
        taxAmount := CCurrEditTax.Value;
        firstDay := CDateTime.Value;
        otherTaxes := CCurrEditOthers.Value;
        if ComboBoxType.ItemIndex = 0 then begin
          paymentType := lptTotal;
        end else begin
          paymentType := lptPrincipal;
        end;
        if ComboBoxPeriod.ItemIndex = 0 then begin
          paymentPeriod := lppMonthly;
        end else begin
          paymentPeriod := lppWeekly;
        end;
      end;
      xValid := Floan.CalculateRepayments;
    end;
    if xValid then begin
      PanelError.Visible := False;
      with RepaymentList do begin
        BeginUpdate;
        RootNodeCount := Floan.Count;
        EndUpdate;
        if Floan.firstDay <> 0 then begin
          Header.Columns.Items[1].Options := Header.Columns.Items[1].Options + [coVisible];
        end else begin
          Header.Columns.Items[1].Options := Header.Columns.Items[1].Options - [coVisible];
        end;
        Header.Options := Header.Options + [hoVisible];
      end;
      CCurrEditRrso.Value := Floan.yearRate;
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

procedure TCLoanCalculatorForm.ComboBoxPeriodChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CCurrEditCashChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CCurrEditTaxChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CIntEditTimesChange(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateLoanData;
end;

procedure TCLoanCalculatorForm.RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xObj: TLoanRepayment;
begin
  xObj := Floan.Items[Node.Index];
  if Column = 0 then begin
    CellText := xObj.caption;
  end else if Column = 1 then begin
    if Floan.IsSumObject(Floan.IndexOf(xObj)) then begin
      CellText := Date2StrDate(xObj.date);
    end else begin
      CellText := '';
    end;
  end else if Column = 2 then begin
    CellText := CurrencyToString(xObj.payment, '', False);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xObj.principal, '', False);
  end else if Column = 4 then begin
    CellText := CurrencyToString(xObj.tax, '', False);
  end else if Column = 5 then begin
    if Floan.IsSumObject(Floan.IndexOf(xObj)) then begin
      CellText := CurrencyToString(xObj.left, '', False);
    end else begin
      CellText := '';
    end;
  end;
end;

procedure TCLoanCalculatorForm.BitBtnOkClick(Sender: TObject);
var xParams: TLoanReportParams;
    xReport: TLoanReport;
begin
  xParams := TLoanReportParams.Create(Floan);
  xReport := TLoanReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

procedure TCLoanCalculatorForm.FormCreate(Sender: TObject);
begin
  inherited;
  CCurrEditCash.CurrencyStr := '';
  CCurrEditOthers.CurrencyStr := '';
  RepaymentList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesLoancalc]);
end;

procedure TCLoanCalculatorForm.Zaznaczwszystkie1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(RepaymentList.ViewPref) then begin
    RepaymentList.ReinitNode(RepaymentList.RootNode, True);
    RepaymentList.Repaint;
  end;
  xPrefs.Free;
end;

procedure TCLoanCalculatorForm.Action1Execute(Sender: TObject);
var xParams: TLoanReportParams;
    xReport: TLoanReport;
begin
  xParams := TLoanReportParams.Create(Floan);
  xReport := TLoanReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
