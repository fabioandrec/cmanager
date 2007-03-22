unit CLoans;

interface

uses Contnrs, Dialogs;

type
  TLoanPaymentType = (lptTotal, lptPrincipal);
  TLoanPaymentPeriod = (lppWeekly, lppMonthly);

  TLoanRepayment = class(TObject)
  private
    Fcaption: String;
    Fdate: TDateTime;
    Fprincipal: Currency;
    Fpayment: Currency;
    Fleft: Currency;
    Ftax: Currency;
  public
    constructor Create(Adate: TDateTime; Aprincipal: Currency; Atax: Currency; ALeft: Currency);
  published
    property date: TDateTime read Fdate write Fdate;
    property principal: Currency read Fprincipal write Fprincipal;
    property tax: Currency read Ftax write Ftax;
    property caption: String read Fcaption write Fcaption;
    property left: Currency read Fleft write Fleft;
    property payment: Currency read Fpayment;
  end;

  TLoan = class(TObjectList)
  private
    FpaymentType: TLoanPaymentType;
    FpaymentPeriod: TLoanPaymentPeriod;
    Fperiods: Integer;
    FtotalCash: Currency;
    FtaxAmount: Currency;
    FfirstDay: TDateTime;
    FotherTaxes: Currency;
    function GetItems(AIndex: Integer): TLoanRepayment;
    procedure SetItems(AIndex: Integer; const Value: TLoanRepayment);
    function GetSumPrincipal: Currency;
    function GetSumTax: Currency;
    function GetSumPayments: Currency;
    function GetYearRate: Currency;
  public
    constructor Create;
    function CalculateRepayments(AAddSums: Boolean = True): Boolean;
    property Items[AIndex: Integer]: TLoanRepayment read GetItems write SetItems;
    function IsSumObject(ANumber: Integer): Boolean;
  published
    property paymentType: TLoanPaymentType read FPaymentType write FPaymentType;
    property paymentPeriod: TLoanPaymentPeriod read FPaymentPeriod write FPaymentPeriod;
    property periods: Integer read FPeriods write FPeriods;
    property totalCash: Currency read FTotalcash write FTotalcash;
    property taxAmount: Currency read FTaxAmount write FTaxAmount;
    property firstDay: TDateTime read FfirstDay write FfirstDay;
    property sumPrincipal: Currency read GetSumPrincipal;
    property sumTax: Currency read GetSumTax;
    property sumPayments: Currency read GetSumPayments;
    property yearRate: Currency read GetYearRate;
    property otherTaxes: Currency read FotherTaxes write FotherTaxes;
  end;

implementation

uses Classes, DateUtils, Math, SysUtils;

constructor TLoanRepayment.Create(Adate: TDateTime; Aprincipal, Atax: Currency; ALeft: Currency);
begin
  inherited Create;
  Fdate := Adate;
  Fprincipal := Aprincipal;
  Ftax := Atax;
  Fleft := ALeft;
  Fpayment := Ftax + Fprincipal;
end;

function TLoan.CalculateRepayments(AAddSums: Boolean = True): Boolean;
var xOnePrincipal, xOneTax: Currency;
    xLeftCash: Currency;
    xPayment: TLoanRepayment;
    xDate: TDateTime;
    xCash: Currency;
    xPayDate: TDateTime;
    xCount: Integer;
    xTaxPerPeriod: Extended;
    xPeriodsPerYear: Byte;
begin
  Clear;
  Result := False;
  try
    xLeftCash := FtotalCash;
    xOnePrincipal := xLeftCash/Fperiods;
    xDate := FfirstDay;
    if FpaymentPeriod = lppWeekly then begin
      xPeriodsPerYear := 52;
    end else begin
      xPeriodsPerYear := 12;
    end;
    xTaxPerPeriod := FtaxAmount / (100 * xPeriodsPerYear);
    for xCount := 1 to Fperiods do begin
      if FpaymentType = lptTotal then begin
        xCash := PeriodPayment(xTaxPerPeriod, xCount, Fperiods,  (-1) * FtotalCash, 0, ptEndOfPeriod);
        xOneTax := InterestPayment(xTaxPerPeriod, xCount, Fperiods,  (-1) * FtotalCash, 0, ptEndOfPeriod);
      end else begin
        xCash := xOnePrincipal;
        xOneTax := xLeftCash * xTaxPerPeriod;
      end;
      if DayOfTheWeek(xDate) = DaySaturday then begin
        xPayDate := IncDay(xDate, 2);
      end else if DayOfTheWeek(xDate) = DaySunday then begin
        xPayDate := IncDay(xDate, 1);
      end else begin
        xPayDate := xDate;
      end;
      xLeftCash := xLeftCash - xCash;
      xPayment := TLoanRepayment.Create(xPayDate, xCash, xOneTax, xLeftCash);
      Add(xPayment);
      xPayment.caption := IntToStr(xCount);
      if FpaymentPeriod = lppWeekly then begin
        xDate := IncWeek(xDate);
      end else begin
        xDate := IncMonth(xDate);
      end;
    end;
    if AAddSums then begin
      Add(TLoanRepayment.Create(0, sumPrincipal, sumTax, 0));
      Items[Count - 1].caption := 'Razem';
    end;
    Result := True;
  except
    Clear;
  end;
end;

constructor TLoan.Create;
begin
  inherited Create(True);
  FpaymentType := lptPrincipal;
  FpaymentPeriod := lppMonthly;
  Fperiods := 12;
  FtotalCash := 0;
  FtaxAmount := 0;
  FfirstDay := 0;
end;

function TLoan.GetItems(AIndex: Integer): TLoanRepayment;
begin
  Result := TLoanRepayment(inherited Items[AIndex]);
end;

function TLoan.GetSumPayments: Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    if IsSumObject(xCount) then begin
      Result := Result + Items[xCount].principal + Items[xCount].tax;
    end;
  end;
end;

function TLoan.GetSumPrincipal: Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    if IsSumObject(xCount) then begin
      Result := Result + Items[xCount].principal;
    end;
  end;
end;

function TLoan.GetSumTax: Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    if IsSumObject(xCount) then begin
      Result := Result + Items[xCount].tax;
    end;
  end;
end;

procedure TLoan.SetItems(AIndex: Integer; const Value: TLoanRepayment);
begin
  inherited Items[AIndex] := Value;
end;

function TLoan.IsSumObject(ANumber: Integer): Boolean;
begin
  Result := StrToIntDef(Items[ANumber].caption, -1) <> -1;
end;

function TLoan.GetYearRate: Currency;
var xArr: array of Double;
    xCount: Integer;
    xPeriods: Integer;
    xOtherRate: Currency;
begin
  SetLength(xArr, Fperiods + 1);
  xArr[0] := (-1) * FtotalCash;
  for xCount := 0 to Count - 1 do begin
    if IsSumObject(xCount) then begin
      xArr[xCount + 1] := Items[xCount].payment;
    end;
  end;
  Result := InternalRateOfReturn(taxAmount/100, xArr);
  xPeriods := IfThen(FpaymentPeriod = lppMonthly, 12, 52);
  Result := (Power(1 + Result, xPeriods) - 1) * 100;
  if FotherTaxes <> 0 then begin
    xOtherRate := (FotherTaxes * 100 / FtotalCash) / (Fperiods / xPeriods);
    Result := Result + xOtherRate;
  end;
end;

end.
