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
  protected
    procedure PrepareReportChart; override;
    function GetReportTitle: String; override;
    function PrepareReportConditions: Boolean; override;
  end;


implementation

uses Forms, SysUtils, Adodb, CConfigFormUnit,
     CChooseDateFormUnit, DB, CChoosePeriodFormUnit, CConsts, CDataObjects,
  DateUtils, CSchedules, CChoosePeriodAccountFormUnit, CHtmlReportFormUnit,
  CChartReportFormUnit, TeeProcs, TeCanvas, TeEngine;

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
                   '  where movementType <> ''%s'' and b.regDate between %s and %s order by b.created',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xInSum := 0;
  xOutSum := 0;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="50%">Opis</td>');
    Add('<td class="headtext" width="20%">Konto</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
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
      Add('<td class="text" width="10%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="50%">' + FieldByName('description').AsString + '</td>');
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
    xInSum, xOutSum: Currency;
    xBody: TStringList;
    xCount: Integer;
    xList: TObjectList;
    xElement: TPlannedTreeItem;
    xIn, xOut: String;
    xDesc, xStat: String;
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
  xInSum := 0;
  xOutSum := 0;
  xBody := TStringList.Create;
  xList := TObjectList.Create(True);
  with xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headtext" width="30%">Status</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
    GetScheduledObjects(xList, Nil, xPlannedObjects, xDoneObjects, FStartDate, FEndDate);
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
          xInSum := xInSum + xElement.done.cash;
        end else begin
          xOut := CurrencyToString(xElement.done.cash);
          xIn := '';
          xOutSum := xOutSum + xElement.done.cash;
        end;
        if xElement.done.doneState = CDoneOperation then begin
          xStat := 'Zrealizowana';
        end else if xElement.done.doneState = CDoneDeleted then begin
          xStat := 'Odrzucona';
        end else begin
          xStat := 'Uznana';
        end;
        xStat := xStat + ' (' + DateToStr(xElement.done.doneDate) + ')';
      end else begin
        xDesc := xElement.planned.description;
        if xElement.planned.movementType = CInMovement then begin
          xIn := CurrencyToString(xElement.planned.cash);
          xOut := '';
          xInSum := xInSum + xElement.planned.cash;
        end else begin
          xOut := CurrencyToString(xElement.planned.cash);
          xIn := '';
          xOutSum := xOutSum + xElement.planned.cash;
        end;
        xStat := '';
      end;
      Add('<td class="text" width="10%">' + IntToStr(xCount) + '</td>');
      Add('<td class="text" width="40%">' + xDesc + '</td>');
      Add('<td class="text" width="30%">' + xStat + '</td>');
      Add('<td class="cash" width="10%">' + xIn + '</td>');
      Add('<td class="cash" width="10%">' + xOut + '</td>');
      Add('</tr>');
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Razem</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOutSum) + '</td>');
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
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="35%">èrÛd≥o</td>');
    Add('<td class="headtext" width="35%">Cel</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="10%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="35%">' + FieldByName('sourcename').AsString + '</td>');
      Add('<td class="text" width="35%">' + FieldByName('destname').AsString + '</td>');
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
    Add('<table class="base" colspan=3>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headtext" width="30%">Data</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Stan poczπtkowy (na ' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ')</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=3>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="10%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="40%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="text" width="30%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(FieldByName('cash').AsCurrency) + '</td>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Stan koÒcowy (na ' + DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')</td>');
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
    Foot.Font.Name := 'Verdana';
    Foot.Font.Size := -10;
    Foot.Font.Color := clNavy;
    Foot.Alignment := taRightJustify;
    Foot.Text.Text := GetReportFooter;
    Title.Font.Name := 'Verdana';
    Title.Font.Height := -16;
    Title.Font.Style := [fsBold];
    Title.Font.Color := clNavy;
    Title.Alignment := taLeftJustify;
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
    Legend.ResizeChart := False;
    Legend.Alignment := laRight;;
    Legend.Frame.Visible := True;
    Legend.ShadowSize := 0;
  end;
  PrepareReportChart;
end;

function TAccountBalanceChartReport.GetReportTitle: String;
begin
  Result := 'Wykres stanu kont (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

procedure TAccountBalanceChartReport.PrepareReportChart;
var xSerie: TLineSeries;
    xChart: TChart;
begin
  xChart := GetChart;
  with xChart do begin
    xSerie := TLineSeries.Create(xChart);
    xSerie.AddArray([2, 1, 4, 5, 4, 6, 7, 8, 9, 10]);
    xSerie.Title := 'tytu≥ pierwszej serii';
    AddSeries(xSerie);
  end;
end;

function TAccountBalanceChartReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

end.

