unit CDeposits;

interface

uses CDataObjects, CDatabase, SysUtils, CConsts, DateUtils, Contnrs;

procedure UpdateDepositInvestments(ADataProvider: TDataProvider);

implementation

uses CTools, Math;

procedure UpdateDepositInvestmentDues(ADepositInvestment: TDepositInvestment; AToDate: TDateTime);
begin
end;

procedure UpdateDepositInvestmentPeriods(ADi: TDepositInvestment; AToDate: TDateTime);
{
var xMove: TDepositMovement;
    xRatePeriodCount, xRateDivider: Integer;
    xRatePeriodType: TBaseEnumeration;
    xDueDate: TDateTime;
    xCalculatedInterest: Currency;
}
begin
{
  xRatePeriodCount := ADi.periodCount;
  xRatePeriodType := ADi.periodType;
  if ADi.dueType <> CDepositDueTypeOnDepositEnd then begin
    xRatePeriodCount := ADi.dueCount;
    xRatePeriodType := ADi.dueType;
  end;
  if xRatePeriodType = CDepositTypeDay then begin
    xRateDivider := DaysInYear(ADi.periodEndDate);
  end else if xRatePeriodType = CDepositTypeWeek then begin
    xRateDivider := WeeksInYear(ADi.periodEndDate);
  end else if xRatePeriodType = CDepositTypeMonth then begin
    xRateDivider := MonthsPerYear;
  end else begin
    xRateDivider := 1;
  end;
  if ADi.dueType <> CDepositDueTypeOnDepositEnd then begin
    //przeliczyæ odsetki z okresu nierozliczonego
  end;

  while (ADi.periodEndDate <= AToDate) and (ADi.depositState = CDepositInvestmentActive) do begin
    if ADi.dueType = CDepositDueTypeOnDepositEnd then begin
      xDueDate := ADi.periodEndDate;
      xCalculatedInterest := SimpleRoundTo((ADi.cash * xRatePeriodCount * ADi.interestRate) / (100 * xRateDivider), -2);
    end else begin
      //przeliczyæ odsetki z okresu nierozliczonego
      xDueDate := 0;
    end;
    if xDueDate <> 0 then begin
      xMove := TDepositMovement.CreateObject(DepositMovementProxy, False);
      xMove.regDate := xDueDate;
      xMove.cash := xCalculatedInterest;
      xMove.idDepositInvestment := ADi.id;
      xMove.idAccount := CEmptyDataGid;
      xMove.idAccountCurrencyDef := CEmptyDataGid;
      xMove.accountCash := 0;
      xMove.idCurrencyRate := CEmptyDataGid;
      xMove.currencyQuantity := 0;
      xMove.currencyRate := 0;
      xMove.rateDescription := '';
      xMove.idProduct := CEmptyDataGid;
      xMove.idBaseMovement := CEmptyDataGid;
      xMove.movementType := CDepositMovementDue;
      xMove.description := 'Naliczenie odsetek dla lokaty ' + ADi.name;
      ADi.noncapitalizedInterest := xCalculatedInterest;
      if ADi.dueAction = CDepositDueActionAutoCapitalisation then begin
        ADi.cash := ADi.cash + ADi.noncapitalizedInterest;
        ADi.noncapitalizedInterest := 0;
      end;
    end;
    xMove := TDepositMovement.CreateObject(DepositMovementProxy, False);
    xMove.regDate := ADi.periodEndDate;
    xMove.cash := ADi.cash;
    xMove.idDepositInvestment := ADi.id;
    xMove.idAccount := CEmptyDataGid;
    xMove.idAccountCurrencyDef := CEmptyDataGid;
    xMove.accountCash := 0;
    xMove.idCurrencyRate := CEmptyDataGid;
    xMove.currencyQuantity := 0;
    xMove.currencyRate := 0;
    xMove.rateDescription := '';
    xMove.idProduct := CEmptyDataGid;
    xMove.idBaseMovement := CEmptyDataGid;
    if ADi.periodAction = CDepositPeriodActionAutoRenew then begin
      xMove.movementType := CDepositMovementRenew;
      xMove.description := 'Odnowienie lokaty ' + ADi.name;
    end else begin
      xMove.movementType := CDepositMovementInactivate;
      xMove.description := 'Zakoñczenie lokaty ' + ADi.name;
      ADi.depositState := CDepositInvestmentInactive;
    end;
    ADi.periodStartDate := IncDay(ADi.periodEndDate, 1);
    ADi.periodEndDate := ADi.EndPeriodDatetime(ADi.periodStartDate, ADi.periodCount, ADi.periodType);
    if (ADi.depositState = CDepositInvestmentActive) then begin
      if (ADi.dueType = CDepositDueTypeOnDepositEnd) then begin
        ADi.dueStartDate := ADi.periodStartDate;
        ADi.dueEndDate := ADi.periodEndDate;
      end;
    end;
  end;
}
end;

procedure UpdateDepositInvestments(ADataProvider: TDataProvider);
var xList: TDataObjectList;
    xCount: Integer;
    xDeposit: TDepositInvestment;
begin
  ADataProvider.BeginTransaction;
  xList := TDepositInvestment.GetList(TDepositInvestment, DepositInvestmentProxy, 'select * from depositInvestment where depositState = ' + QuotedStr(CDepositInvestmentActive));
  for xCount := 0 to xList.Count - 1 do begin
    xDeposit := TDepositInvestment(xList.Items[xCount]);
    UpdateDepositInvestmentPeriods(xDeposit, GWorkDate);
  end;
  ADataProvider.CommitTransaction;
  xList.Free;
end;

end.
