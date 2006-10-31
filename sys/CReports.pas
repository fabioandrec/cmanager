unit CReports;

interface

uses Classes, CReportFormUnit, Graphics, Controls, Chart, Series, Contnrs, Windows,
     GraphUtil, CDatabase;

type
  TCReportClass = class of TCBaseReport;
  TCReportFormClass = class of TCReportForm;

  TCBaseReport = class(TObject)
  private
    FForm: TCReportForm;
  protected
    function PrepareReportConditions: Boolean; virtual;
    function GetReportTitle: String; virtual; abstract;
    function GetReportFooter: String; virtual; abstract;
    function GetFormClass: TCReportFormClass; virtual; abstract;
    procedure PrepareReportData; virtual; abstract;
    procedure CleanReportData; virtual; abstract;
  public
    constructor CreateReport; virtual;
    procedure ShowReport;
  end;

  TCHtmlReport = class(TCBaseReport)
  private
    FreportPath: String;
    FreportText: TStringList;
    procedure PrepareReportPath;
  protected
    procedure CleanReportData; override;
    procedure PrepareReportData; override;
    function GetReportBody: String; virtual; abstract;
    function GetReportFooter: String; override;
    function GetFormClass: TCReportFormClass; override;
  public
    constructor CreateReport; override;
    destructor Destroy; override;
  end;

  TCChartReport = class(TCBaseReport)
  protected
    function GetFormClass: TCReportFormClass; override;
    function GetReportFooter: String; override;
    procedure PrepareReportChart; virtual; abstract;
    procedure PrepareReportData; override;
    function GetChart: TChart;
    procedure CleanReportData; override;
  end;

  TAccountBalanceOnDayReport = class(TCHtmlReport)
  private
    FDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TDoneOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TBaseOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetOperationsType: String; virtual; abstract;
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  end;

  TInOperationListReport = class(TBaseOperationsListReport)
  protected
    function GetReportTitle: String; override;
    function GetOperationsType: String; override;
  end;

  TOutOperationListReport = class(TBaseOperationsListReport)
  protected
    function GetReportTitle: String; override;
    function GetOperationsType: String; override;
  end;

  TBaseOperationsByCategoryChart = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetOperationsType: String; virtual; abstract;
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportChart; override;
  end;

  TInOperationsByCategoryChart = class(TBaseOperationsByCategoryChart)
  protected
    function GetReportTitle: String; override;
    function GetOperationsType: String; override;
  end;

  TOutOperationsByCategoryChart = class(TBaseOperationsByCategoryChart)
  protected
    function GetReportTitle: String; override;
    function GetOperationsType: String; override;
  end;

  TPlannedOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TCashFlowListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TAccountHistoryReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIdAccount: TDataGid;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TAccountBalanceChartReport = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIds: TStringList;
  private
    function IsValidAccount(AId: TDataGid): Boolean;
  protected
    procedure PrepareReportChart; override;
    function GetReportTitle: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    constructor CreateReport; override;
    destructor Destroy; override;
  end;


implementation

uses Forms, SysUtils, Adodb, CConfigFormUnit,
     CChooseDateFormUnit, DB, CChoosePeriodFormUnit, CConsts, CDataObjects,
  DateUtils, CSchedules, CChoosePeriodAccountFormUnit, CHtmlReportFormUnit,
  CChartReportFormUnit, TeeProcs, TeCanvas, TeEngine,
  CChoosePeriodAccountListFormUnit, CComponents;

function DayName(ADate: TDateTime): String;
var xDay: Integer;
begin
  xDay := DayOfTheWeek(ADate);
  Result := CShortDayNames[xDay - 1];
end;

function ColToRgb(AColor: TColor): String;
var xRgb: Integer;
begin
  xRgb := ColorToRGB(AColor);
  Result := '"#' + Format('%.2x%.2x%.2x', [GetRValue(xRgb), GetGValue(xRgb), GetBValue(xRgb)]) + '"';
end;

function GetReportPath(ASubpath: String): string;
var i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);
  Result := IncludeTrailingPathDelimiter(Result) + IncludeTrailingPathDelimiter('Cmanager') + IncludeTrailingPathDelimiter(ASubpath);
end;

function TAccountBalanceOnDayReport.GetReportBody: String;
var xAccounts: TADOQuery;
    xOperations: TADOQuery;
    xSum, xDelta: Currency;
    xBody: TStringList;
begin
  xAccounts := GDataProvider.OpenSql('select * from account order by name');
  xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, idAccount from transactions where regDate > %s group by idAccount', [DatetimeToDatabase(FDate, False)]));
  xSum := 0;
  xBody := TStringList.Create;
  with xAccounts, xBody do begin
    Add('<table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="75%">Nazwa konta</td>');
    Add('<td class="headcash" width="25%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=2>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="75%">' + FieldByName('name').AsString + '</td>');
      xOperations.Filter := 'idAccount = ' + DataGidToDatabase(FieldByName('idAccount').AsString);
      xOperations.Filtered := True;
      if xOperations.IsEmpty then begin
        xDelta := 0;
      end else begin
        xDelta := xOperations.FieldByName('cash').AsCurrency;
      end;
      Add('<td class="cash" width="25%">' + CurrencyToString(FieldByName('cash').AsCurrency - xDelta) + '</td>');
      Add('</tr>');
      xSum := xSum + FieldByName('cash').AsCurrency - xDelta;
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="75%">Razem</td>');
    Add('<td class="sumcash" width="25%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xAccounts.Free;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TAccountBalanceOnDayReport.GetReportTitle: String;
begin
  Result := 'Stan kont (' + DayName(FDate) + ', ' + DateToStr(FDate) + ')';
end;

function TAccountBalanceOnDayReport.PrepareReportConditions: Boolean;
begin
  Result := ChooseDateByForm(FDate);
end;

function TDoneOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xInSum, xOutSum: Currency;
    xIn, xOut: String;
    xBody: TStringList;
    xCash: Currency;
begin
  xOperations := GDataProvider.OpenSql(
            Format('select b.*, a.name from balances b' +
                   ' left outer join account a on a.idAccount = b.idAccount ' +
                   '  where movementType <> ''%s'' and b.regDate between %s and %s order by b.regDate, b.created',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xInSum := 0;
  xOutSum := 0;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=6>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headtext" width="20%">Konto</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      xCash := FieldByName('income').AsCurrency;
      if xCash > 0 then begin
        xIn := CurrencyToString(xCash);
        xInSum := xInSum + xCash;
      end else begin
        xIn := '';
      end;
      xCash := FieldByName('expense').AsCurrency;
      if xCash > 0 then begin
        xOut := CurrencyToString(xCash);
        xOutSum := xOutSum + xCash;
      end else begin
        xOut := '';
      end;
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="40%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="10%">' + xIn + '</td>');
      Add('<td class="cash" width="10%">' + xOut + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Razem</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOutSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TDoneOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje wykonane (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TDoneOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TPlannedOperationsListReport.GetReportBody: String;
var xSqlPlanned, xSqlDone: String;
    xPlannedObjects, xDoneObjects: TDataObjectList;
    xOverallInSum, xOverallOutSum: Currency;
    xNotrealInSum, xNotrealOutSum: Currency;
    xBody: TStringList;
    xCount: Integer;
    xList: TObjectList;
    xElement: TPlannedTreeItem;
    xIn, xOut: String;
    xDesc, xStat: String;
    xDate: TDateTime;
begin
  xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (scheduleType = ''O'' and scheduleDate between %s and %s and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                        '  (scheduleType = ''C'' and scheduleDate <= %s)' +
                        ' )', [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), DatetimeToDatabase(FEndDate, False)]);
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (endCondition = ''N'') or ' +
                        '  (endCondition = ''D'' and endDate >= %s) or ' +
                        '  (endCondition = ''T'' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                        ' )', [DatetimeToDatabase(FStartDate, False)]);
  xSqlDone := Format('select * from plannedDone where triggerDate between %s and %s', [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
  GDataProvider.BeginTransaction;
  xPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
  xDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
  xOverallInSum := 0;
  xOverallOutSum := 0;
  xNotrealInSum := 0;
  xNotrealOutSum := 0;
  xBody := TStringList.Create;
  xList := TObjectList.Create(True);
  with xBody do begin
    Add('<table class="base" colspan=6>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headtext" width="20%">Status</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    GetScheduledObjects(xList, xPlannedObjects, xDoneObjects, FStartDate, FEndDate);
    for xCount := 1 to xList.Count do begin
      xElement := TPlannedTreeItem(xList.Items[xCount - 1]);
      if not Odd(xCount) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      if xElement.done <> Nil then begin
        xDesc := xElement.done.description;
        if xElement.planned.movementType = CInMovement then begin
          xIn := CurrencyToString(xElement.done.cash);
          xOut := '';
          xOverallInSum := xOverallInSum + xElement.done.cash;
        end else begin
          xOut := CurrencyToString(xElement.done.cash);
          xIn := '';
          xOverallOutSum := xOverallOutSum + xElement.done.cash;
        end;
        if xElement.done.doneState = CDoneOperation then begin
          xStat := 'Zrealizowana';
        end else if xElement.done.doneState = CDoneDeleted then begin
          xStat := 'Odrzucona';
        end else begin
          xStat := 'Uznana';
        end;
        xDate := xElement.done.doneDate;
      end else begin
        xDesc := xElement.planned.description;
        if xElement.planned.movementType = CInMovement then begin
          xIn := CurrencyToString(xElement.planned.cash);
          xOut := '';
          xOverallInSum := xOverallInSum + xElement.planned.cash;
          xNotrealInSum := xNotrealInSum + xElement.planned.cash;
        end else begin
          xOut := CurrencyToString(xElement.planned.cash);
          xIn := '';
          xOverallOutSum := xOverallOutSum + xElement.planned.cash;
          xNotrealOutSum := xNotrealOutSum + xElement.planned.cash;
        end;
        xStat := '';
        xDate := xElement.triggerDate;
      end;
      Add('<td class="text" width="5%">' + IntToStr(xCount) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(xDate) + '</td>');
      Add('<td class="text" width="40%">' + xDesc + '</td>');
      Add('<td class="text" width="20%">' + xStat + '</td>');
      Add('<td class="cash" width="10%">' + xIn + '</td>');
      Add('<td class="cash" width="10%">' + xOut + '</td>');
      Add('</tr>');
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Suma zrealizowanych operacji</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOverallInSum - xNotrealInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOverallOutSum - xNotrealOutSum) + '</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Suma niezrealizowanych operacji</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xNotrealInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xNotrealOutSum) + '</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Suma wszystkich zaplanowanych operacji</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOverallInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOverallOutSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  GDataProvider.RollbackTransaction;
  xPlannedObjects.Free;
  xDoneObjects.Free;
  xList.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TPlannedOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje zaplanowane (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TPlannedOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TCashFlowListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xBody: TStringList;
    xSum: Currency;
begin
  xOperations := GDataProvider.OpenSql(
             Format('select ' +
                    '  b.created, b.description, b.cash, b.movementType, b.regDate, ' +
                    '  b.idCashpoint as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in ('''+ CInMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.cash, b.movementType, b.regDate, ' +
                    '  a.idAccount as sourceid, a.name as sourcename, ' +
                    '  b.idCashpoint as destid, c.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in (''' + COutMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.cash, b.movementType, b.regDate, ' +
                    '  b.idSourceAccount as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, account c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idAccount = b.idSourceAccount and b.movementType in (''' + CTransferMovement + ''') ' +
                    'order by b.regDate, b.created ',
                   [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xBody := TStringList.Create;
  xSum := 0;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="30%">èrÛd≥o</td>');
    Add('<td class="headtext" width="30%">Cel</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="30%">' + FieldByName('sourcename').AsString + '</td>');
      Add('<td class="text" width="30%">' + FieldByName('destname').AsString + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(FieldByName('cash').AsCurrency) + '</td>');
      Add('</tr>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Razem</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TCashFlowListReport.GetReportTitle: String;
begin
  Result := 'Przep≥yw gotÛwki (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TCashFlowListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TAccountHistoryReport.GetReportBody: String;
var xOperations: TADOQuery;
    xSum: Currency;
    xBody: TStringList;
begin
  xOperations := GDataProvider.OpenSql(Format('select cash, description, regDate from transactions where regDate between %s and %s and idAccount = %s order by regDate',
                                              [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), DataGidToDatabase(FIdAccount)]));
  xSum := TAccount.AccountBalanceOnDay(FIdAccount, FStartDate);
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="60%">Opis</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="5%"></td>');
    Add('<td class="sumtext" width="15%">' + DateToStr(FStartDate) + '</td>');
    Add('<td class="sumtext" width="60%">Stan poczπtkowy</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="60%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(FieldByName('cash').AsCurrency) + '</td>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="5%"></td>');
    Add('<td class="sumtext" width="15%">' + DateToStr(FEndDate) + '</td>');
    Add('<td class="sumtext" width="60%">Stan koÒcowy</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TAccountHistoryReport.GetReportTitle: String;
var xAcc: TAccount;
begin
  GDataProvider.BeginTransaction;
  xAcc := TAccount(TAccount.LoadObject(AccountProxy, FIdAccount, False));
  Result := 'Historia konta ' + xAcc.name + ' (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
  GDataProvider.RollbackTransaction;
end;

function TAccountHistoryReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAccountByForm(FStartDate, FEndDate, FIdAccount);
end;

constructor TCBaseReport.CreateReport;
begin
  inherited Create;
end;

function TCBaseReport.PrepareReportConditions: Boolean;
begin
  Result := True;
end;

procedure TCBaseReport.ShowReport;
begin
  Fform := GetFormClass.Create(Nil);
  if PrepareReportConditions then begin
    PrepareReportData;
    Fform.Caption := 'Raport';
    Fform.ShowConfig(coNone);
    CleanReportData;
  end;
  Fform.Free;
end;

procedure TCHtmlReport.CleanReportData;
var xRec: TSearchRec;
    xRes: Integer;
begin
  xRes := FindFirst(FreportPath + '*.*', faAnyFile, xRec);
  while (xRes = 0) do begin
    DeleteFile(FreportPath + xRec.Name);
    xRes := FindNext(xRec);
  end;
  FindClose(xRec);
  RemoveDir(FreportPath);
end;

constructor TCHtmlReport.CreateReport;
begin
  inherited Create;
  FreportText := TStringList.Create;
end;

destructor TCHtmlReport.Destroy;
begin
  FreportText.Free;
  inherited Destroy;
end;

function TCHtmlReport.GetFormClass: TCReportFormClass;
begin
  Result := TCHtmlReportForm;
end;

function TCHtmlReport.GetReportFooter: String;
begin
  Result := 'CManager wer. ' + FileVersion(ParamStr(0)) + ', ' + DateTimeToStr(Now);
end;

procedure TCHtmlReport.PrepareReportData;
var xText: String;
begin
  PrepareReportPath;
  xText := FreportText.Text;
  xText := StringReplace(xText, '[reptitle]', GetReportTitle, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[repbody]', GetReportBody, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[repfooter]', GetReportFooter, [rfReplaceAll, rfIgnoreCase]);
  FreportText.Text := xText;
  FreportText.SaveToFile(FreportPath + 'report.htm');
  CopyFile('report.css', PChar(FreportPath + 'report.css'), False);
  TCHtmlReportForm(FForm).CBrowser.Navigate('file://' + FreportPath + 'report.htm');
end;

procedure TCHtmlReport.PrepareReportPath;
var xRes: TResourceStream;
begin
  FreportPath := GetReportPath(IntToStr(GetTickCount));
  if not FileExists('report.css') then begin
    xRes := TResourceStream.Create(HInstance, 'REPCSS', RT_RCDATA);
    xRes.SaveToFile('report.css');
    xRes.Free;
  end;
  if not FileExists('report.htm') then begin
    xRes := TResourceStream.Create(HInstance, 'REPBASE', RT_RCDATA);
    xRes.SaveToFile('report.htm');
    xRes.Free;
  end;
  FreportText.LoadFromFile('report.htm');
  ForceDirectories(FreportPath)
end;

procedure TCChartReport.CleanReportData;
begin
end;

function TCChartReport.GetChart: TChart;
begin
  Result := TCChartReportForm(FForm).CChart;
end;

function TCChartReport.GetFormClass: TCReportFormClass;
begin
  Result := TCChartReportForm;
end;

function TCChartReport.GetReportFooter: String;
begin
  Result := 'CManager wer. ' + FileVersion(ParamStr(0)) + ', ' + DateTimeToStr(Now);
end;

procedure TCChartReport.PrepareReportData;
begin
  with GetChart do begin
    Foot.Text.Text := GetReportFooter;
    Title.Text.Text := GetReportTitle;
    with LeftAxis.Axis do begin
      Width := 1;
    end;
    with RightAxis.Axis do begin
      Width := 1;
    end;
    with TopAxis.Axis do begin
      Width := 1;
    end;
    with BottomAxis.Axis do begin
      Width := 1;
    end;
    Legend.LegendStyle := lsSeries;
    Legend.Alignment := laRight;;
    Legend.ShadowSize := 0;
  end;
  PrepareReportChart;
end;

constructor TAccountBalanceChartReport.CreateReport;
begin
  inherited CreateReport;
  FIds := TStringList.Create;
end;

destructor TAccountBalanceChartReport.Destroy;
begin
  FIds.Free;
  inherited Destroy;
end;

function TAccountBalanceChartReport.GetReportTitle: String;
begin
  Result := 'Wykres stanu kont (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TAccountBalanceChartReport.IsValidAccount(AId: TDataGid): Boolean;
begin
  Result := FIds.Count = 0;
  if not Result then begin
    Result := FIds.IndexOf(AId) <> -1;
  end;
end;

procedure TAccountBalanceChartReport.PrepareReportChart;
var xSums: TADOQuery;
    xCount: Integer;
    xAccounts: TDataObjectList;
    xAccount: TAccount;
    xChart: TChart;
    xSerie: TChartSeries;
    xDate: TDateTime;
    xBalance: Currency;
    xEnd: Boolean;
begin
  GDataProvider.BeginTransaction;
  xChart := GetChart;
  xAccounts := TDataObject.GetList(TAccount, AccountProxy, 'select * from account');
  for xCount := 0 to xAccounts.Count - 1 do begin
    xAccount := TAccount(xAccounts.Items[xCount]);
    if IsValidAccount(xAccount.id) then begin
      xBalance := xAccount.cash;
      xSerie := TLineSeries.Create(xChart);
      TLineSeries(xSerie).Pointer.Visible := True;
      TLineSeries(xSerie).Pointer.InflateMargins := True;
      with xSerie do begin
        Title := xAccount.name;
        HorizAxis := aBottomAxis;
        XValues.DateTime := True;
      end;
      xSums := GDataProvider.OpenSql(Format(
                  'select sum(cash) as cash, regDate from transactions where regDate > %s and idAccount = %s group by regDate order by regDate desc',
                  [DatetimeToDatabase(FStartDate, False), DataGidToDatabase(xAccount.id)]));
      while not xSums.Eof do begin
        if (xSums.RecNo = 1) and (xSums.FieldByName('regDate').AsDateTime < FEndDate) then begin
          xDate := FEndDate;
          while (xDate > xSums.FieldByName('regDate').AsDateTime) do begin
            xSerie.AddXY(xDate, xBalance);
            xDate := IncDay(xDate, -1);
          end;
        end;
        xDate := xSums.FieldByName('regDate').AsDateTime;
        if (FStartDate <= xDate) and (xDate <= FEndDate) then begin
          xSerie.AddXY(xDate, xBalance);
        end;
        xBalance := xBalance - xSums.FieldByName('cash').AsCurrency;
        xSums.Next;
        repeat
          xDate := IncDay(xDate, -1);
          if not xSums.Eof then begin
            xEnd := xDate < xSums.FieldByName('regDate').AsDateTime;
          end else begin
            xEnd := xDate < FStartDate;
          end;
          if not xEnd then begin
            xSerie.AddXY(xDate, xBalance);
          end;
        until xEnd;
      end;
      xSums.Free;
      xChart.AddSeries(xSerie);
    end;
  end;
  with xChart.BottomAxis do begin
    DateTimeFormat := 'yyyy-mm-dd';
    ExactDateTime := True;
    Automatic := False;
    AutomaticMaximum := False;
    AutomaticMinimum := False;
    Increment := DateTimeStep[dtOneDay];
    Maximum := FEndDate;
    Minimum := FStartDate;
    LabelsAngle := 90;
    MinorTickCount := 0;
    Title.Caption := '[Data]';
  end;
  with xChart.LeftAxis do begin
    MinorTickCount := 0;
    Title.Caption := '[' + GetCurrencySymbol + ']';
    Title.Angle := 90;
  end;
  xChart.View3D := False;
  xChart.Legend.Alignment := laRight;
  xChart.Legend.ResizeChart := True;
  xAccounts.Free;
  GDataProvider.RollbackTransaction;
end;

function TAccountBalanceChartReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAccountListByForm(FStartDate, FEndDate, FIds);
end;

function TBaseOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xSum: Currency;
    xBody: TStringList;
    xCash: Currency;
begin
  xOperations := GDataProvider.OpenSql(
            Format('select b.*, a.name from transactions b' +
                   ' left outer join account a on a.idAccount = b.idAccount ' +
                   '  where movementType = ''%s'' and b.regDate between %s and %s order by b.regDate, b.created',
                   [GetOperationsType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xSum := 0;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="50%">Opis</td>');
    Add('<td class="headtext" width="20%">Konto</td>');
    Add('<td class="headcash" width="10%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      xCash := Abs(FieldByName('cash').AsCurrency);
      xSum := xSum + xCash;
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="50%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="10%">' + CurrencyToString(xCash) + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="90%">Razem</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TBaseOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TInOperationListReport.GetOperationsType: String;
begin
  Result := CInMovement;
end;

function TInOperationListReport.GetReportTitle: String;
begin
  Result := 'Lista operacji przychodowych (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TOutOperationListReport.GetOperationsType: String;
begin
  Result := COutMovement;
end;

function TOutOperationListReport.GetReportTitle: String;
begin
  Result := 'Lista operacji rozchodowych (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

procedure TBaseOperationsByCategoryChart.PrepareReportChart;
var xSums: TADOQuery;
    xSerie: TPieSeries;
    xChart: TChart;
begin
  xChart := GetChart;
  xSums := GDataProvider.OpenSql(Format('select v.cash, p.name from ( ' +
                                        '  select sum(cash) as cash, idProduct from transactions ' +
                                        '  where movementType = ''%s'' and regDate between %s and %s group by idProduct) as v ' +
                                        '  left outer join product p on p.idProduct = v.idProduct',
                                        [GetOperationsType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xSerie := TPieSeries.Create(xChart);
  while not xSums.Eof do begin
    xSerie.Add(xSums.FieldByName('cash').AsCurrency, xSums.FieldByName('name').AsString);
    xSums.Next;
  end;
  xChart.AddSeries(xSerie);
  xChart.View3D := False;
  xChart.Legend.Visible := False;
  xSums.Free;
end;

function TBaseOperationsByCategoryChart.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TInOperationsByCategoryChart.GetOperationsType: String;
begin
  Result := CInMovement;
end;

function TInOperationsByCategoryChart.GetReportTitle: String;
begin
  Result := 'Operacje przychodowe w/g kategorii (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TOutOperationsByCategoryChart.GetOperationsType: String;
begin
  Result := COutMovement;
end;

function TOutOperationsByCategoryChart.GetReportTitle: String;
begin
  Result := 'Operacje rozchodowe w/g kategorii (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

end.


