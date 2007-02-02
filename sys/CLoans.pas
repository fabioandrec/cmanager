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
  end;

  TLoan = class(TObjectList)
  private
    FpaymentType: TLoanPaymentType;
    FpaymentPeriod: TLoanPaymentPeriod;
    Fperiods: Integer;
    FtotalCash: Currency;
    FtaxAmount: Currency;
    FfirstDay: TDateTime;
    function GetItems(AIndex: Integer): TLoanRepayment;
    procedure SetItems(AIndex: Integer; const Value: TLoanRepayment);
  public
    constructor Create;
    procedure CalculateRepayments;
  public
    property Items[AIndex: Integer]: TLoanRepayment read GetItems write SetItems;
  published
    property paymentType: TLoanPaymentType read FPaymentType write FPaymentType;
    property paymentPeriod: TLoanPaymentPeriod read FPaymentPeriod write FPaymentPeriod;
    property periods: Integer read FPeriods write FPeriods;
    property totalCash: Currency read FTotalcash write FTotalcash;
    property taxAmount: Currency read FTaxAmount write FTaxAmount;
    property firstDay: TDateTime read FfirstDay write FfirstDay;
  end;

implementation

uses Classes, DateUtils, Math, SysUtils;

function RoundCurrency(ACurrency: Currency; ADigits: Byte = 2): Currency;
begin
  Result := RoundTo(ACurrency, (-1) * ADigits);
end;

constructor TLoanRepayment.Create(Adate: TDateTime; Aprincipal, Atax: Currency; ALeft: Currency);
begin
  inherited Create;
  Fdate := Adate;
  Fprincipal := Aprincipal;
  Ftax := Atax;
  Fleft := ALeft;
end;

procedure TLoan.CalculateRepayments;
var xOnePrincipal, xOneTax: Currency;
    xLeftCash: Currency;
    xPayment: TLoanRepayment;
    xDate: TDateTime;
    xCash: Currency;
    xPayDate: TDateTime;
    xCount: Integer;
begin
  Clear;
  try
    xLeftCash := FtotalCash;
    xOnePrincipal := RoundCurrency(xLeftCash/Fperiods);
    xDate := FfirstDay;
    for xCount := 1 to Fperiods do begin
      if FpaymentType = lptTotal then begin
        xOneTax := RoundCurrency((FtotalCash * (FtaxAmount / (100 * 12))) / Fperiods);
      end else begin
        xOneTax := RoundCurrency(xLeftCash * (FtaxAmount / (100 * 12)))
      end;
      if xLeftCash > xOnePrincipal then begin
        xCash := xOnePrincipal;
      end else begin
        xCash := xLeftCash;
      end;
      if DayOfWeek(xDate) = DaySaturday then begin
        xPayDate := IncDay(xDate, 2);
      end else if DayOfWeek(xDate) = DaySunday then begin
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
  except
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

procedure TLoan.SetItems(AIndex: Integer; const Value: TLoanRepayment);
begin
  inherited Items[AIndex] := Value;
end;

end.
