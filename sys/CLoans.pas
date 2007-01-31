unit CLoans;

interface

uses Contnrs;

type
  TLoanPaymentType = (lptTotal, lptPrincipal);
  TLoanPaymentPeriod = (lppWeekly, lppMonthly);
  TLoanPaymentBalance = (rpbDaily, rpbPeriodicaly);

  TLoanRepayment = class(TObject)
  private
    Fdate: TDateTime;
    Fprincipal: Currency;
    Ftax: Currency;
  public
    constructor Create(Adate: TDateTime; Aprincipal: Currency; Atax: Currency);
  published
    property date: TDateTime read Fdate write Fdate;
    property principal: Currency read Fprincipal write Fprincipal;
    property tax: Currency read Ftax write Ftax;
  end;

  TLoan = class(TObjectList)
  private
    FpaymentType: TLoanPaymentType;
    FpaymentPeriod: TLoanPaymentPeriod;
    FpaymentBalance: TLoanPaymentBalance;
    Fperiods: Integer;
    FtotalCash: Currency;
    FtaxAmount: Currency;
    FfirstDay: TDateTime;
    function GetItems(AIndex: Integer): TLoanRepayment;
    procedure SetItems(AIndex: Integer; const Value: TLoanRepayment);
  public
    constructor Create(APaymentType: TLoanPaymentType; APaymentPeriod: TLoanPaymentPeriod; APaymentBalance: TLoanPaymentBalance; APeriods: Integer; ATotalcash: Currency; ATaxAmount: Currency; AFirstDay: TDateTime);
    procedure CalculateRepayments;
  public
    property Items[AIndex: Integer]: TLoanRepayment read GetItems write SetItems;
  published
    property paymentType: TLoanPaymentType read FPaymentType write FPaymentType;
    property paymentPeriod: TLoanPaymentPeriod read FPaymentPeriod write FPaymentPeriod;
    property paymentBalance: TLoanPaymentBalance read FpaymentBalance write FpaymentBalance;
    property periods: Integer read FPeriods write FPeriods;
    property totalCash: Currency read FTotalcash write FTotalcash;
    property taxAmount: Currency read FTaxAmount write FTaxAmount;
    property firstDay: TDateTime read FfirstDay write FfirstDay;
  end;

implementation

uses Classes, DateUtils;

constructor TLoanRepayment.Create(Adate: TDateTime; Aprincipal, Atax: Currency);
begin
  inherited Create;
  Fdate := Adate;
  Fprincipal := Aprincipal;
  Ftax := Atax;
end;

procedure TLoan.CalculateRepayments;
var xCount: Integer;
begin
  Clear;
  for xCount := 1 to Fperiods do begin
  end;
end;

constructor TLoan.Create(APaymentType: TLoanPaymentType; APaymentPeriod: TLoanPaymentPeriod; APaymentBalance: TLoanPaymentBalance; APeriods: Integer; ATotalcash, ATaxAmount: Currency; AFirstDay: TDateTime);
begin
  inherited Create(True);
  FpaymentType := APaymentType;
  FpaymentPeriod := APaymentPeriod;
  FpaymentBalance := APaymentBalance;
  Fperiods := APeriods;
  FtotalCash := ATotalcash;
  FtaxAmount :=ATaxAmount;
  FfirstDay := AFirstDay;
  CalculateRepayments;
end;

function TLoan.GetItems(AIndex: Integer): TLoanRepayment;
begin
  Result := TLoanRepayment(inherited Items[AIndex]);
end;

procedure TLoan.SetItems(AIndex: Integer; const Value: TLoanRepayment);
begin
  inherited Items[AIndex] := Value;
end;

end.
