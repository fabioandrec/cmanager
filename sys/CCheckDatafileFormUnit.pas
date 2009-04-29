unit CCheckDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase, StrUtils;

type
  TCCheckDatafileForm = class(TCProgressForm)
  private
    FDataProvider: TDataProvider;
  protected
    procedure InitializeLabels; override;
    procedure InitializeForm; override;
    function DoWork: TDoWorkResult; override;
    procedure FinalizeLabels; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, CMainFormUnit, CDatatools, CDataObjects, CTools,
  CBaseFrameUnit, CAccountsFrameUnit, CConsts,
  CInvestmentPortfolioFrameUnit, CMovementFrameUnit, Math;

function TCCheckDatafileForm.DoWork: TDoWorkResult;
var xText: String;
    xAccounts: TDataObjectList;
    xInvestments: TDataObjectList;
    xStep, xCount, xSuspectedCount: Integer;
    xAccount: TAccount;
    xInvestment: TInvestmentItem;
    xInstrument: TInstrument;
    xSum: Currency;
    xQuantitySum: Double;
begin
  AddToReport('Rozpoczêcie wykonywania sprawdzania pliku danych...');
  try
    FDataProvider.BeginTransaction;
    xSuspectedCount := 0;
    xAccounts := TAccount.GetAllObjects(AccountProxy);
    xInvestments := TInvestmentItem.GetAllObjects(InvestmentItemProxy);
    if xAccounts.Count > 0 then begin
      xStep := Trunc(100 / (xAccounts.Count + xInvestments.Count));
      for xCount := 0 to xAccounts.Count - 1 do begin
        xAccount := TAccount(xAccounts.Items[xCount]);
        AddToReport('Sprawdzanie konta ' + xAccount.name);
        xSum := FDataProvider.GetSqlCurrency('select sum(cash) as cash from transactions where idAccount = ' + DataGidToDatabase(xAccount.id), 0);
        if xSum + xAccount.initialBalance <> xAccount.cash then begin
          AddToReport('Stan konta ' + xAccount.name + Format(' wynosi %.2f, powinien wynosiæ %.2f', [xAccount.cash, xSum + xAccount.initialBalance]));
          xAccount.cash := xAccount.initialBalance + xSum;
          AddToReport('Zmodyfikowano stan konta ' + xAccount.name);
          inc(xSuspectedCount);
        end else begin
          AddToReport('Stan konta ' + xAccount.name + ' jest poprawny');
        end;
        ProgressBar.StepBy(xStep);
      end;
      for xCount := 0 to xInvestments.Count - 1 do begin
        xInvestment := TInvestmentItem(xInvestments.Items[xCount]);
        xAccount := TAccount(TAccount.LoadObject(AccountProxy, xInvestment.idAccount, False));
        xInstrument := TInstrument(TInstrument.LoadObject(InstrumentProxy, xInvestment.idInstrument, False));
        AddToReport('Sprawdzanie inwestycji ' + xAccount.name + ' - ' + xInstrument.name);
        xQuantitySum := FDataProvider.GetSqlFloat('select sum(quantity) as quantity from investments where idAccount = ' + DataGidToDatabase(xInvestment.idAccount) + ' and idInstrument = ' + DataGidToDatabase(xInvestment.idInstrument), 0);
        if not SameValue(xQuantitySum, xInvestment.quantity) then begin
          AddToReport('Stan inwestycji ' + xAccount.name + ' - ' + xInstrument.name + Format(' wynosi %.6f, powinien wynosiæ %.6f', [xInvestment.quantity, xQuantitySum]));
          xInvestment.quantity := xQuantitySum;
          AddToReport('Zmodyfikowano stan inwestycji ' + xAccount.name + ' - ' + xInstrument.name);
          inc(xSuspectedCount);
        end else begin
          AddToReport('Stan inwestycji ' + xAccount.name + ' - ' + xInstrument.name + ' jest poprawny');
        end;
        ProgressBar.StepBy(xStep);
      end;
      AddToReport('Uaktualnianie statystyk');
      FDataProvider.ExecuteSql('delete from movementStatistics');
      FDataProvider.ExecuteSql(
         'insert into movementStatistics select count(*) as movementCount, sum(cash) as cash, movementType, idAccount, idSourceAccount, idCashPoint, idProduct, ' +
         'idAccountCurrencyDef, idMovementCurrencyDef, sum(movementCash) as movementCash ' +
         'from baseMovement group by movementType, idAccount, idSourceAccount, idCashPoint, idProduct, idAccountCurrencyDef, idMovementCurrencyDef;');
    end;
    GDataProvider.CommitTransaction;
    xAccounts.Free;
    xInvestments.Free;
    if xSuspectedCount = 0 then begin
      AddToReport('Nie znaleziono ¿adnych nieprawid³owoœci');
    end else begin
      AddToReport(Format('Skorygowano %d nieprawid³owoœci', [xSuspectedCount]));
      SendMessageToFrames(TCAccountsFrame, WM_DATAREFRESH, 0, 0);
      SendMessageToFrames(TCInvestmentPortfolioFrame, WM_DATAREFRESH, 0, 0);
    end;
    if xSuspectedCount > 0 then begin
      Result := dwrWarning;
    end else begin
      Result := dwrSuccess;
    end;
  except
    Result := dwrError;
  end;
  xText := 'Procedura sprawdzania pliku danych zakoñczona ';
  if Result = dwrSuccess then begin
    xText := xText + 'poprawnie';
  end else if Result = dwrError then begin
    xText := xText + 'z b³edem';
  end else if Result = dwrWarning then begin
    xText := xText + 'poprawnie, plik zawiera³ niepoprawne dane';
  end;
  AddToReport(xText);
end;

procedure TCCheckDatafileForm.FinalizeLabels;
begin
  if DoWorkResult = dwrSuccess then begin
    LabelInfo.Caption := 'Plik danych zosta³ sprawdzony';
    SendMessageToFrames(TCMovementFrame, WM_NOTIFYMESSAGE, 0, WMOPT_REFRESHQUICKPATTERNS);
  end else if DoWorkResult = dwrWarning then begin
    LabelInfo.Caption := 'Plik danych zawiera³ niepoprawne dane';
  end else if DoWorkResult = dwrError then begin
    LabelInfo.Caption := 'B³¹d sprawdzania pliku danych';
  end;
end;

procedure TCCheckDatafileForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
end;

procedure TCCheckDatafileForm.InitializeLabels;
begin
  LabelInfo.Caption := 'Trwa sprawdzanie pliku danych';
end;

end.
 