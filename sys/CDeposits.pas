unit CDeposits;

interface

uses CDataObjects, CDatabase, SysUtils, CConsts, DateUtils;

procedure UpdateDepositInvestments(ADataProvider: TDataProvider);

implementation

uses CTools;

procedure UpdateDepositInvestmentDues(ADepositInvestment: TDepositInvestment; AToDate: TDateTime);
begin
end;

procedure UpdateDepositInvestmentPeriods(ADepositInvestment: TDepositInvestment; AToDate: TDateTime);
var xFinished: Boolean;
    xMovement: TDepositMovement;
begin
  xFinished := False;
  repeat
    {
    UpdateDepositInvestmentDues(ADepositInvestment, AToDate);
    if ADepositInvestment.periodEndDate <= AToDate then begin
      xMovement := TDepositMovement.CreateObject(DepositMovementProxy, False);
      xMovement.regDate := ADepositInvestment.periodEndDate;
      if ADepositInvestment.periodAction = CDepositPeriodActionAutoRenew then begin
        xMovement.movementType := CDepositMovementRenew;
        with ADepositInvestment do begin
          perperiodLastDate := periodNextDate;
          periodNextDate := NextPeriodDatetime(periodNextDate, periodCount, periodType);
        end;
        xMovement.description := 'Odnowienie lokaty ' + ADepositInvestment.name;
      end else begin
        xMovement.movementType := CDepositMovementInactivate;
        ADepositInvestment.depositState := CDepositInvestmentInactive;
        xMovement.description := 'Wygaœniêcie lokaty ' + ADepositInvestment.name;
        xFinished := True;
      end;
      xMovement.cash := ADepositInvestment.cash;
      xMovement.idDepositInvestment := ADepositInvestment.id;
      xMovement.idAccount := CEmptyDataGid;
      xMovement.idAccountCurrencyDef := CEmptyDataGid;
      xMovement.accountCash := 0;
      xMovement.idCurrencyRate := CEmptyDataGid;
      xMovement.currencyQuantity := 0;
      xMovement.currencyRate := 0;
      xMovement.rateDescription := '';
      xMovement.idProduct := CEmptyDataGid;
      xMovement.idBaseMovement := CEmptyDataGid;
    end else begin
      xFinished := True;
    end;
    }
  until xFinished;
end;

procedure UpdateDepositInvestments(ADataProvider: TDataProvider);
var xList: TDataObjectList;
    xCount: Integer;
begin
  ADataProvider.BeginTransaction;
  xList := TDepositInvestment.GetList(TDepositInvestment, DepositInvestmentProxy, 'select * from depositInvestment where depositState = ' + QuotedStr(CDepositInvestmentActive));
  for xCount := 0 to xList.Count - 1 do begin
    UpdateDepositInvestmentPeriods(TDepositInvestment(xList.Items[xCount]), GWorkDate);
  end;
  xList.Free;
  ADataProvider.CommitTransaction;
end;

end.
