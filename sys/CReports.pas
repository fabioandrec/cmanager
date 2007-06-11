unit CReports;

interface

uses Classes, CReportFormUnit, Graphics, Controls, Chart, Series, Contnrs, Windows,
     GraphUtil, CDatabase, Db, VirtualTrees, SysUtils, CLoans, CPlugins, MsXml,
     CComponents;

type
  TSumForDayItem = class(TObject)
  private
    Fsum: Currency;
    Fdate: TDateTime;
  public
    constructor Create(ADate: TDateTime; ASum: Currency = 0);
  published
    property sum: Currency read Fsum write Fsum;
    property date: TDateTime read Fdate write Fdate;
  end;

  TRegresionData = record
    a: Double;
    b: Double;
  end;

  TPeriodSums = class(TObjectList)
  private
    FstartDate: TDateTime;
    FendDate: TDateTime;
    function Getitems(AIndex: Integer): TSumForDayItem;
    procedure Setitems(AIndex: Integer; const Value: TSumForDayItem);
    function GetbyDateTime(ADateTime: TDateTime): Currency;
    procedure SetbyDateTime(ADateTime: TDateTime; const Value: Currency);
    function Getsum: Currency;
    function GetDayAvg: Currency;
    function GetregresionData: TRegresionData;
    function GetMonthAvg: Currency;
    function GetWeekAvg: Currency;
  public
    constructor Create(AStartDate, AEndDate: TDateTime);
    procedure FromDataset(ADataset: TDataSet; ASumName: String = 'fieldsum'; ADateName: String = 'fielddate');
    property Items[AIndex: Integer]: TSumForDayItem read Getitems write Setitems;
    property ByDate[ADateTime: TDateTime]: Currency read GetbyDateTime write SetbyDateTime;
    function GetRegLin(AStartDate, AEndDate: TDateTime): TPeriodSums;
  published
    property startDate: TDateTime read FstartDate;
    property endDate: TDateTime read FendDate;
    property sum: Currency read Getsum;
    property dayAvg: Currency read GetDayAvg;
    property weekAvg: Currency read GetWeekAvg;
    property monthAvg: Currency read GetMonthAvg;
    property regresion: TRegresionData read GetregresionData;
  end;

  TCReportClass = class of TCBaseReport;
  TCReportFormClass = class of TCReportForm;
  TCReportParams = class(TObject);

  TCSelectedMovementTypeParams = class(TCReportParams)
  private
    FmovementType: String;
  public
    constructor Create(AType: String);
  published
    property movementType: String read FmovementType;
  end;

  TCPluginReportParams = class(TCReportParams)
  private
    Fplugin: TCPlugin;
  public
    constructor Create(APlugin: TCPlugin);
  published
    property plugin: TCPlugin read Fplugin;
  end;

  TCWithGidParams = class(TCReportParams)
  private
    FId: TDataGid;
  public
    constructor Create(AId: TDataGid);
  published
    property id: TDataGid read FId;
  end;

  TCVirtualStringTreeParams = class(TCReportParams)
  private
    Flist: TCList;
    Ftitle: String;
  public
    constructor Create(AList: TCList; ATitle: String);
  published
    property list: TCList read Flist;
    property title: String read Ftitle;
  end;

  TCBaseReport = class(TObject)
  private
    FForm: TCReportForm;
    FParams: TCReportParams;
  protected
    function PrepareReportConditions: Boolean; virtual;
    function GetReportTitle: String; virtual; abstract;
    function GetReportFooter: String; virtual; abstract;
    function GetFormClass: TCReportFormClass; virtual; abstract;
    procedure PrepareReportData; virtual; abstract;
    procedure SaveContentToFile(AFilename: String); virtual; abstract;
  public
    constructor CreateReport(AParams: TCReportParams); virtual;
    procedure ShowReport;
    destructor Destroy; override;
    property Params: TCReportParams read FParams;
  end;

  TCHtmlReport = class(TCBaseReport)
  private
    FreportText: TStringList;
    FreportStyle: TStringList;
    procedure PrepareReportPath;
    procedure PrepareReportContent;
  protected
    procedure PrepareReportData; override;
    function GetReportBody: String; virtual; abstract;
    function GetReportFooter: String; override;
    function GetFormClass: TCReportFormClass; override;
  public
    constructor CreateReport(AParams: TCReportParams); override;
    function PrepareContent: String;
    destructor Destroy; override;
    property reportText: TStringList read FreportText;
  end;

  TCChartReport = class(TCBaseReport)
  private
    FisPie: Boolean;
    procedure Setmarks(const Value: Integer);
  protected
    function GetFormClass: TCReportFormClass; override;
    function GetReportFooter: String; override;
    procedure PrepareReportChart; virtual; abstract;
    procedure PrepareReportData; override;
    procedure SetChartProps; virtual;
    function GetChart: TChart;
  public
    function GetPrefname: String; virtual;
    property isPie: Boolean read FisPie;
    property marks: Integer write Setmarks;
  end;

  {+}TAccountBalanceOnDayReport = class(TCHtmlReport)
  private
    FDate: TDateTime;
    FIds: TStringList;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    destructor Destroy; override;
    constructor CreateReport(AParams: TCReportParams); override;
  end;

  {+}TDoneOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FFilterId: TDataGid;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  {+}TTodayOperationsListReport = class(TDoneOperationsListReport)
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportTitle: String; override;
  end;

  {+}TOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
    function GetReportTitle: String; override;
  end;

  TOperationsBySomethingChart = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetSql: String; virtual; abstract;
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportChart; override;
  end;

  {+}TOperationsBySomethingList = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetSql: String; virtual; abstract;
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  end;

  TOperationsByCategoryChart = class(TOperationsBySomethingChart)
  protected
    function GetSql: String; override;
    function GetReportTitle: String; override;
  end;

  TOperationsByCashpointChart = class(TOperationsBySomethingChart)
  protected
    function GetSql: String; override;
    function GetReportTitle: String; override;
  end;

  {+}TOperationsByCategoryList = class(TOperationsBySomethingList)
  protected
    function GetSql: String; override;
    function GetReportTitle: String; override;
  end;

  {+}TOperationsByCashpointList = class(TOperationsBySomethingList)
  protected
    function GetSql: String; override;
    function GetReportTitle: String; override;
  end;

  {+}TPlannedOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FFilterId: TDataGid;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  {+}TCashFlowListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  {+}TAccountHistoryReport = class(TCHtmlReport)
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
  protected
    procedure PrepareReportChart; override;
    function GetReportTitle: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    constructor CreateReport(AParams: TCReportParams); override;
    destructor Destroy; override;
  end;

  {+}TSumReportList = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIds: TStringList;
    FGroupBy: String;
  private
    function GetDescription(ADate: TDateTime): String;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    constructor CreateReport(AParams: TCReportParams); override;
    destructor Destroy; override;
  end;

  TSumReportChart = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIds: TStringList;
    FGroupBy: String;
  private
    function GetDescription(ADate: TDateTime): String;
  protected
    function GetReportTitle: String; override;
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportChart; override;
  public
    constructor CreateReport(AParams: TCReportParams); override;
    destructor Destroy; override;
  end;

  TAveragesReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIdFilter: TDataGid;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
  end;

  TPeriodSumsReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIdFilter: TDataGid;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
  end;

  TFuturesReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FStartFuture: TDateTime;
    FEndFuture: TDateTime;
    FIdFilter: TDataGid;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
  end;

  {+}TVirtualStringReport = class(TCHtmlReport)
  private
    FWidth: Integer;
    function GetColumnPercentage(AColumn: TVirtualTreeColumn): Integer;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
  public
    constructor CreateReport(AParams: TCReportParams); override;
  end;

  TLoanReportParams = class(TCReportParams)
  private
    Floan: TLoan;
  public
    constructor Create(ALoan: TLoan);
  published
    property loan: TLoan read Floan write Floan;
  end;

  TLoanReport = class(TCHtmlReport)
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
  end;

  TCurrencyRatesHistoryReport = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FSourceId: TDataGid;
    FTargetId: TDataGid;
    FSourceIso: TDataGid;
    FTargetIso: TDataGid;
    FCashpointId: TDataGid;
    FrateTypes: String;
    FAxisName: String;
  protected
    procedure PrepareReportChart; override;
    function GetReportTitle: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TPluginHtmlReport = class(TCHtmlReport)
  private
    FBody: OleVariant;
  protected
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportData; override;
  end;

  TPluginChartReport = class(TCChartReport)
  private
    FXml: IXMLDOMDocument;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportTitle: String; override;
    function GetReportFooter: String; override;
    procedure PrepareReportChart; override;
  public
    function GetPrefname: String; override;
  end;


implementation

uses Forms, Adodb, CConfigFormUnit, Math,
     CChooseDateFormUnit, CChoosePeriodFormUnit, CConsts, CDataObjects,
     DateUtils, CSchedules, CChoosePeriodAccountFormUnit, CHtmlReportFormUnit,
     CChartReportFormUnit, TeeProcs, TeCanvas, TeEngine,
     CChoosePeriodAccountListFormUnit, CChoosePeriodAccountListGroupFormUnit,
     CChooseDateAccountListFormUnit, CChoosePeriodFilterFormUnit, CDatatools,
     CChooseFutureFilterFormUnit, CTools, CChoosePeriodRatesHistoryFormUnit,
     StrUtils, Variants, CPreferences, CXml, CInfoFormUnit, CPluginConsts;

function DayCount(AEndDay, AStartDay: TDateTime): Integer;
begin
  Result := DaysBetween(AEndDay, AStartDay) + 1;
end;

function WeekCount(AEndDay, AStartDay: TDateTime): Integer;
begin
  Result := Trunc(DayCount(AEndDay, AStartDay) / DaysPerWeek);
end;

function MonthCount(AEndDay, AStartDay: TDateTime): Integer;
begin
  Result := Trunc(DayCount(AEndDay, AStartDay) / ApproxDaysPerMonth);
end;

procedure RegLin(DBx, DBy: array of Double; var A, B: Double);
var SigX, SigY : Double;
    SigXY : Double;
    SigSqrX : Double;
    n, i : Word;
begin
  n := High(DBx) + 1;
  SigX := 0; SigY := 0;
  SigXY := 0;
  SigSqrX := 0;
  for i := 0 to n-1 do begin
    SigX := SigX + DBx[i];
    SigY := SigY + DBy[i];
    SigXY := SigXY + (DBx[i] * DBy[i]);
    SigSqrX := SigSqrX + Sqr(DBx[i]);
  end;
  A := (n * SigXY - SigX * SigY) / (n * SigSqrX - Sqr(Sigx));
  B := 1/n * (SigY - A * SigX);
end;

function ColToRgb(AColor: TColor): String;
var xRgb: Integer;
begin
  xRgb := ColorToRGB(AColor);
  Result := '"#' + Format('%.2x%.2x%.2x', [GetRValue(xRgb), GetGValue(xRgb), GetBValue(xRgb)]) + '"';
end;

function IsValidAccount(AId: TDataGid; AIds: TStringList): Boolean;
begin
  Result := AIds.Count = 0;
  if not Result then begin
    Result := AIds.IndexOf(AId) <> -1;
  end;
end;

function IsValidFilter(AAcountId, ACashpointId, AProductId: TDataGid; AFilter: TMovementFilter): Boolean;
begin
  Result := True;
  if AFilter <> Nil then begin
    AFilter.LoadSubfilters;
    Result := AFilter.IsValid(AAcountId, ACashpointId, AProductId);
  end;
end;

function GetReportPath(ASubpath: String): string;
var i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);
  Result := IncludeTrailingPathDelimiter(Result) + IncludeTrailingPathDelimiter('Cmanager') + IncludeTrailingPathDelimiter(ASubpath);
end;

constructor TAccountBalanceOnDayReport.CreateReport(AParams: TCReportParams);
begin
  inherited CreateReport(AParams);
  FIds := TStringList.Create;
end;

destructor TAccountBalanceOnDayReport.Destroy;
begin
  FIds.Free;
  inherited Destroy;
end;

function TAccountBalanceOnDayReport.GetReportBody: String;
var xAccounts: TADOQuery;
    xOperations: TADOQuery;
    xDelta: Currency;
    xBody: TStringList;
    xRec: Integer;
    xSums: TSumList;
    xCount: Integer;
begin
  xAccounts := GDataProvider.OpenSql('select * from account order by name');
  xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, idAccount from transactions where regDate > %s group by idAccount', [DatetimeToDatabase(FDate, False)]));
  xSums := TSumList.Create(True);
  xBody := TStringList.Create;
  with xAccounts, xBody do begin
    Add('<table class="base" colspan=3>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="75%">Nazwa konta</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="15%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=3>');
    xRec := 1;
    while not Eof do begin
      if IsValidAccount(FieldByName('idAccount').AsString, FIds) then begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="75%">' + FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idCurrencyDef').AsString) + '</td>');
        xOperations.Filter := 'idAccount = ' + DataGidToDatabase(FieldByName('idAccount').AsString);
        xOperations.Filtered := True;
        if xOperations.IsEmpty then begin
          xDelta := 0;
        end else begin
          xDelta := xOperations.FieldByName('cash').AsCurrency;
        end;
        Add('<td class="cash" width="15%">' + CurrencyToString(FieldByName('cash').AsCurrency - xDelta, '', False) + '</td>');
        Add('</tr>');
        xSums.AddSum(FieldByName('idCurrencyDef').AsString, FieldByName('cash').AsCurrency - xDelta);
        Inc(xRec);
      end;
      Next;
    end;
    Add('</table><hr>');
    if xSums.Count > 0 then begin
      Add('<table class="base" colspan=3>');
      for xCount := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        Add('<td class="sumtext" width="75%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSums.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="15%">' + CurrencyToString(xSums.Items[xCount].value, '', False) + '</td>');
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xAccounts.Free;
  xOperations.Free;
  Result := xBody.Text;
  xSums.Free;
  xBody.Free;
end;

function TAccountBalanceOnDayReport.GetReportTitle: String;
begin
  Result := 'Stan kont (' + GetFormattedDate(FDate, CLongDateFormat) + ')';
end;

function TAccountBalanceOnDayReport.PrepareReportConditions: Boolean;
begin
  Result := ChooseDateAccountListByForm(FDate, FIds);
end;

function TDoneOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xInSum, xOutSum: TSumList;
    xIn, xOut: String;
    xBody: TStringList;
    xCash: Currency;
    xFilter: TMovementFilter;
    xRec: Integer;
    xCount: Integer;
    xIdCur: String;
    xIC, xOC: Currency;
    xIS, xOS: String;
begin
  xOperations := GDataProvider.OpenSql(
            Format('select b.*, a.name from balances b' +
                   ' left outer join account a on a.idAccount = b.idAccount ' +
                   '  where movementType <> ''%s'' and b.regDate between %s and %s order by b.regDate, b.created',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  if FFilterId <> CEmptyDataGid then begin
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, FFilterId, False));
  end else begin
    xFilter := Nil;
  end;
  xInSum := TSumList.Create(True);
  xOutSum := TSumList.Create(True);
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=7>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="30%">Opis</td>');
    Add('<td class="headtext" width="20%">Konto</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=7>');
    xRec := 1;
    while not Eof do begin
      if IsValidFilter(FieldByName('idAccount').AsString, FieldByName('idCashpoint').AsString, FieldByName('idProduct').AsString, xFilter) then begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        xCash := FieldByName('movementIncome').AsCurrency;
        if xCash > 0 then begin
          xIn := CurrencyToString(xCash, '', False);
          xInSum.AddSum(FieldByName('idMovementCurrencyDef').AsString, xCash);
        end else begin
          xIn := '';
        end;
        xCash := FieldByName('movementExpense').AsCurrency;
        if xCash > 0 then begin
          xOut := CurrencyToString(xCash, '', False);
          xOutSum.AddSum(FieldByName('idMovementCurrencyDef').AsString, xCash);
        end else begin
          xOut := '';
        end;
        Add('<td class="text" width="5%">' + IntToStr(xRec) + '</td>');
        Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
        Add('<td class="text" width="30%">' + FieldByName('description').AsString + '</td>');
        Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idMovementCurrencyDef').AsString) + '</td>');
        Add('<td class="cash" width="10%">' + xIn + '</td>');
        Add('<td class="cash" width="10%">' + xOut + '</td>');
        Add('</tr>');
        Inc(xRec);
      end;
      Next;
    end;
    Add('</table><hr>');
    if xInSum.Count + xOutSum.Count > 0 then begin
      Add('<table class="base" colspan=4>');
      for xCount := 0 to Max(xInSum.Count, xOutSum.Count) do begin
        xIdCur := '';
        if xCount <= xInSum.Count - 1 then begin
          xIdCur := xInSum.Items[xCount].name;
        end else if xCount <= xOutSum.Count - 1 then begin
          xIdCur := xOutSum.Items[xCount].name;
        end;
        if xIdCur <> '' then begin
          xIC := xInSum.GetSum(xIdCur);
          xOC := xOutSum.GetSum(xIdCur);
          if xIC > 0 then begin
            xIS := CurrencyToString(xIC, '', False);
          end;
          if xOC > 0 then begin
            xOS := CurrencyToString(xOC, '', False);
          end;
          Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
          Add('<td class="sumtext" width="70%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
          Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xIdCur) + '</td>');
          Add('<td class="sumcash" width="10%">' + xIS + '</td>');
          Add('<td class="sumcash" width="10%">' + xOS + '</td>');
          Add('</tr>');
        end;
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xOperations.Free;
  Result := xBody.Text;
  xInSum.Free;
  xOutSum.Free;
  xBody.Free;
end;

function TDoneOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje wykonane (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TDoneOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FFilterId, True);
end;

function TPlannedOperationsListReport.GetReportBody: String;
var xSqlPlanned, xSqlDone: String;
    xPlannedObjects, xDoneObjects: TDataObjectList;
    xOverallInSum, xOverallOutSum: TSumList;
    xNotrealInSum, xNotrealOutSum: TSumList;
    xRelizedInSum, xRealizedOutSum: TSumList;
    xBody: TStringList;
    xCount: Integer;
    xList: TObjectList;
    xElement: TPlannedTreeItem;
    xIn, xOut: String;
    xDesc, xStat: String;
    xDate: TDateTime;
    xRec: Integer;
    xFilter: TMovementFilter;
    xIdCurrency: TDataGid;
    xIC, xOC: Currency;
    xIS, xOS: String;
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
  xPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
  xDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
  xOverallInSum := TSumList.Create(True);
  xOverallOutSum := TSumList.Create(True);
  xNotrealInSum := TSumList.Create(True);
  xNotrealOutSum := TSumList.Create(True);
  xRelizedInSum := TSumList.Create(True);
  xRealizedOutSum := TSumList.Create(True);
  xBody := TStringList.Create;
  xList := TObjectList.Create(True);
  if FFilterId <> CEmptyDataGid then begin
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, FFilterId, False));
  end else begin
    xFilter := Nil;
  end;
  with xBody do begin
    Add('<table class="base" colspan=7>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="30%">Opis</td>');
    Add('<td class="headtext" width="20%">Status</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=7>');
    GetScheduledObjects(xList, xPlannedObjects, xDoneObjects, FStartDate, FEndDate, sosBoth);
    xRec := 1;
    for xCount := 1 to xList.Count do begin
      xElement := TPlannedTreeItem(xList.Items[xCount - 1]);
      Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
      if IsValidFilter(xElement.planned.idAccount, xElement.planned.idCashPoint, xElement.planned.idProduct, xFilter) then begin
        if xElement.done <> Nil then begin
          xDesc := xElement.done.description;
          xIdCurrency := xElement.done.idDoneCurrencyDef;
          if xElement.planned.movementType = CInMovement then begin
            xIn := CurrencyToString(xElement.done.cash, '', False);
            xOut := '';
            xOverallInSum.AddSum(xIdCurrency, xElement.done.cash);
            xRelizedInSum.AddSum(xIdCurrency, xElement.done.cash);
          end else begin
            xOut := CurrencyToString(xElement.done.cash, '', False);
            xIn := '';
            xOverallOutSum.AddSum(xIdCurrency, xElement.done.cash);
            xRealizedOutSum.AddSum(xIdCurrency, xElement.done.cash);
          end;
          if xElement.done.doneState = CDoneOperation then begin
            xStat := CPlannedDoneDescription;
          end else if xElement.done.doneState = CDoneDeleted then begin
            xStat := CPlannedRejectedDescription;
          end else begin
            xStat := CPlannedAcceptedDescription;
          end;
          xDate := xElement.done.doneDate;
        end else begin
          xDesc := xElement.planned.description;
          xIdCurrency := xElement.planned.idMovementCurrencyDef;
          if xElement.planned.movementType = CInMovement then begin
            xIn := CurrencyToString(xElement.planned.cash, '', False);
            xOut := '';
            xOverallInSum.AddSum(xIdCurrency, xElement.planned.cash);
            xNotrealInSum.AddSum(xIdCurrency, xElement.planned.cash);
          end else begin
            xOut := CurrencyToString(xElement.planned.cash, '', False);
            xIn := '';
            xOverallOutSum.AddSum(xIdCurrency, xElement.planned.cash);
            xNotrealOutSum.AddSum(xIdCurrency, xElement.planned.cash);
          end;
          xStat := '';
          xDate := xElement.triggerDate;
        end;
        Add('<td class="text" width="5%">' + IntToStr(xRec) + '</td>');
        Add('<td class="text" width="15%">' + DateToStr(xDate) + '</td>');
        Add('<td class="text" width="30%">' + xDesc + '</td>');
        Add('<td class="text" width="20%">' + xStat + '</td>');
        Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(xIdCurrency) + '</td>');
        Add('<td class="cash" width="10%">' + xIn + '</td>');
        Add('<td class="cash" width="10%">' + xOut + '</td>');
        Add('</tr>');
        Inc(xRec);
      end;
    end;
    Add('</table><hr>');
    if xRelizedInSum.Count + xRealizedOutSum.Count > 0 then begin
      Add('<table class="base" colspan=4>');
      for xCount := 0 to Max(xRelizedInSum.Count, xRealizedOutSum.Count) do begin
        xIdCurrency := '';
        if xCount <= xRelizedInSum.Count - 1 then begin
          xIdCurrency := xRelizedInSum.Items[xCount].name;
        end else if xCount <= xRealizedOutSum.Count - 1 then begin
          xIdCurrency := xRealizedOutSum.Items[xCount].name;
        end;
        if xIdCurrency <> '' then begin
          xIC := xRelizedInSum.GetSum(xIdCurrency);
          xOC := xRealizedOutSum.GetSum(xIdCurrency);
          if xIC > 0 then begin
            xIS := CurrencyToString(xIC, '', False);
          end;
          if xOC > 0 then begin
            xOS := CurrencyToString(xOC, '', False);
          end;
          Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
          Add('<td class="sumtext" width="70%">' + IfThen(xCount = 0, 'Suma zrealizowanych operacji', '') + '</td>');
          Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xIdCurrency) + '</td>');
          Add('<td class="sumcash" width="10%">' + xIS + '</td>');
          Add('<td class="sumcash" width="10%">' + xOS + '</td>');
          Add('</tr>');
        end;
      end;
      Add('</table><hr>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Suma zrealizowanych operacji</td></tr></table><hr>');
    end;
    if xNotrealInSum.Count + xNotrealOutSum.Count > 0 then begin
      Add('<table class="base" colspan=4>');
      for xCount := 0 to Max(xNotrealInSum.Count, xNotrealOutSum.Count) do begin
        xIdCurrency := '';
        if xCount <= xNotrealInSum.Count - 1 then begin
          xIdCurrency := xNotrealInSum.Items[xCount].name;
        end else if xCount <= xNotrealOutSum.Count - 1 then begin
          xIdCurrency := xNotrealOutSum.Items[xCount].name;
        end;
        if xIdCurrency <> '' then begin
          xIC := xNotrealInSum.GetSum(xIdCurrency);
          xOC := xNotrealOutSum.GetSum(xIdCurrency);
          if xIC > 0 then begin
            xIS := CurrencyToString(xIC, '', False);
          end;
          if xOC > 0 then begin
            xOS := CurrencyToString(xOC, '', False);
          end;
          Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
          Add('<td class="sumtext" width="70%">' + IfThen(xCount = 0, 'Suma niezrealizowanych operacji', '') + '</td>');
          Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xIdCurrency) + '</td>');
          Add('<td class="sumcash" width="10%">' + xIS + '</td>');
          Add('<td class="sumcash" width="10%">' + xOS + '</td>');
          Add('</tr>');
        end;
      end;
      Add('</table><hr>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Suma niezrealizowanych operacji</td></tr></table><hr>');
    end;
    if xOverallInSum.Count + xOverallOutSum.Count > 0 then begin
      Add('<table class="base" colspan=4>');
      for xCount := 0 to Max(xOverallInSum.Count, xOverallOutSum.Count) do begin
        xIdCurrency := '';
        if xCount <= xOverallInSum.Count - 1 then begin
          xIdCurrency := xOverallInSum.Items[xCount].name;
        end else if xCount <= xOverallOutSum.Count - 1 then begin
          xIdCurrency := xOverallOutSum.Items[xCount].name;
        end;
        if xIdCurrency <> '' then begin
          xIC := xOverallInSum.GetSum(xIdCurrency);
          xOC := xOverallOutSum.GetSum(xIdCurrency);
          if xIC > 0 then begin
            xIS := CurrencyToString(xIC, '', False);
          end;
          if xOC > 0 then begin
            xOS := CurrencyToString(xOC, '', False);
          end;
          Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
          Add('<td class="sumtext" width="70%">' + IfThen(xCount = 0, 'Suma wszystkich zaplanowanych operacji', '') + '</td>');
          Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xIdCurrency) + '</td>');
          Add('<td class="sumcash" width="10%">' + xIS + '</td>');
          Add('<td class="sumcash" width="10%">' + xOS + '</td>');
          Add('</tr>');
        end;
      end;
      Add('</table><hr>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Suma wszystkich zaplanowanych operacji</td></tr></table><hr>');
    end;
  end;
  xPlannedObjects.Free;
  xDoneObjects.Free;
  xList.Free;
  Result := xBody.Text;
  xBody.Free;
  xOverallInSum.Free;
  xOverallOutSum.Free;
  xNotrealInSum.Free;
  xNotrealOutSum.Free;
  xRelizedInSum.Free;
  xRealizedOutSum.Free;
end;

function TPlannedOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje zaplanowane (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TPlannedOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FFilterId, True);
end;

function TCashFlowListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xBody: TStringList;
    xSums: TSumList;
    xCount: Integer;
begin
  xSums := TSumList.Create(True);
  xOperations := GDataProvider.OpenSql(
             Format('select ' +
                    '  b.created, b.description, b.movementCash, b.idMovementCurrencyDef, b.movementType, b.regDate, ' +
                    '  b.idCashpoint as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in ('''+ CInMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.movementCash, b.idMovementCurrencyDef, b.movementType, b.regDate, ' +
                    '  a.idAccount as sourceid, a.name as sourcename, ' +
                    '  b.idCashpoint as destid, c.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in (''' + COutMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.movementCash, b.idMovementCurrencyDef, b.movementType, b.regDate, ' +
                    '  b.idSourceAccount as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, account c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idAccount = b.idSourceAccount and b.movementType in (''' + CTransferMovement + ''') ' +
                    'order by b.regDate, b.created ',
                   [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=6>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="25%">èrÛd≥o</td>');
    Add('<td class="headtext" width="25%">Cel</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    while not Eof do begin
      Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="25%">' + FieldByName('sourcename').AsString + '</td>');
      Add('<td class="text" width="25%">' + FieldByName('destname').AsString + '</td>');
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idMovementCurrencyDef').AsString) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(FieldByName('movementCash').AsCurrency, '', False) + '</td>');
      Add('</tr>');
      xSums.AddSum(FieldByName('idMovementCurrencyDef').AsString, FieldByName('movementCash').AsCurrency);
      Next;
    end;
    Add('</table><hr>');
    if xSums.Count > 0 then begin
      Add('<table class="base" colspan=3>');
      for xCount := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        Add('<td class="sumtext" width="70%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSums.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="20%">' + CurrencyToString(xSums.Items[xCount].value, '', False) + '</td>');
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
  xSums.Free;
end;

function TCashFlowListReport.GetReportTitle: String;
begin
  Result := 'Przep≥yw gotÛwki (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TCashFlowListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TAccountHistoryReport.GetReportBody: String;
var xOperations: TADOQuery;
    xSum: Currency;
    xBody: TStringList;
    xAccountCurrencyDef: TDataGid;
begin
  xOperations := GDataProvider.OpenSql(Format('select movementType, idAccount, cash, movementCash, idMovementCurrencyDef, description, regDate from transactions where regDate between %s and %s and idAccount = %s order by regDate',
                                              [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), DataGidToDatabase(FIdAccount)]));
  xSum := TAccount.AccountBalanceOnDay(FIdAccount, FStartDate);
  xAccountCurrencyDef := TAccount.GetCurrencyDefinition(FIdAccount);
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=6>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="15%">Kwota operacji</td>');
    Add('<td class="headcash" width="15%">Kwota konta [' + GCurrencyCache.GetSymbol(xAccountCurrencyDef) + ']</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    Add('<tr class="sum">');
    Add('<td class="sumtext" width="5%"></td>');
    Add('<td class="sumtext" width="15%">' + DateToStr(FStartDate) + '</td>');
    Add('<td class="sumtext" width="65%">Stan poczπtkowy</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum, '', False) + '</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    while not Eof do begin
      Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="40%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idMovementCurrencyDef').AsString) + '</td>');
      Add('<td class="cash" width="15%">' + CurrencyToString(FieldByName('movementCash').AsCurrency, '', False) + '</td>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Add('<td class="cash" width="15%">' + CurrencyToString(FieldByName('cash').AsCurrency, '', False) + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=6>');
    Add('<tr class="sum">');
    Add('<td class="sumtext" width="5%"></td>');
    Add('<td class="sumtext" width="15%">' + DateToStr(FEndDate) + '</td>');
    Add('<td class="sumtext" width="65%">Stan koÒcowy</td>');
    Add('<td class="sumcash" width="15%">' + CurrencyToString(xSum, '', False) + '</td>');
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
  xAcc := TAccount(TAccount.LoadObject(AccountProxy, FIdAccount, False));
  Result := 'Historia konta ' + xAcc.name + ' (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TAccountHistoryReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAccountByForm(FStartDate, FEndDate, FIdAccount);
end;

constructor TCBaseReport.CreateReport(AParams: TCReportParams);
begin
  inherited Create;
  FParams := AParams;
end;

destructor TCBaseReport.Destroy;
begin
  inherited Destroy;
end;

function TCBaseReport.PrepareReportConditions: Boolean;
begin
  Result := True;
end;

procedure TCBaseReport.ShowReport;
begin
  Fform := GetFormClass.CreateForm(Self);
  if PrepareReportConditions then begin
    GDataProvider.BeginTransaction;
    PrepareReportData;
    GDataProvider.RollbackTransaction;
    Fform.Caption := 'Raport';
    Fform.ShowConfig(coNone);
  end;
  Fform.Free;
end;

constructor TCHtmlReport.CreateReport(AParams: TCReportParams);
begin
  inherited CreateReport(AParams);
  FreportText := TStringList.Create;
  FreportStyle := TStringList.Create;
end;

destructor TCHtmlReport.Destroy;
begin
  FreportText.Free;
  FreportStyle.Free;
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

function TCHtmlReport.PrepareContent: String;
begin
  GDataProvider.BeginTransaction;
  PrepareReportPath;
  PrepareReportContent;
  GDataProvider.RollbackTransaction;
  Result := FreportText.Text;
end;

procedure TCHtmlReport.PrepareReportContent;
var xText: String;
begin
  xText := FreportText.Text;
  xText := StringReplace(xText, '[repstyle]', FreportStyle.Text, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[reptitle]', GetReportTitle, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[repbody]', GetReportBody, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[repfooter]', GetReportFooter, [rfReplaceAll, rfIgnoreCase]);
  FreportText.Text := xText;
end;

procedure TCHtmlReport.PrepareReportData;
begin
  PrepareReportPath;
  PrepareReportContent;
  TCHtmlReportForm(FForm).CBrowser.LoadFromString(FreportText.Text);
end;

procedure TCHtmlReport.PrepareReportPath;
var xRes: TResourceStream;
begin
  if not FileExists(GetSystemPathname('report.css')) then begin
    xRes := TResourceStream.Create(HInstance, 'REPCSS', RT_RCDATA);
    xRes.SaveToFile(GetSystemPathname('report.css'));
    xRes.Free;
  end;
  if not FileExists(GetSystemPathname('report.htm')) then begin
    xRes := TResourceStream.Create(HInstance, 'REPBASE', RT_RCDATA);
    xRes.SaveToFile(GetSystemPathname('report.htm'));
    xRes.Free;
  end;
  FreportText.LoadFromFile(GetSystemPathname('report.htm'));
  FreportStyle.LoadFromFile(GetSystemPathname('report.css'));
end;

function TCChartReport.GetChart: TChart;
begin
  Result := TCChartReportForm(FForm).CChart;
end;

function TCChartReport.GetFormClass: TCReportFormClass;
begin
  Result := TCChartReportForm;
end;

function TCChartReport.GetPrefname: String;
begin
  Result := ClassName;
end;

function TCChartReport.GetReportFooter: String;
begin
  Result := 'CManager wer. ' + FileVersion(ParamStr(0)) + ', ' + DateTimeToStr(Now);
end;

procedure TCChartReport.PrepareReportData;
var xCount: Integer;
    xTemp: TPieSeries;
    xChart: TChart;
begin
  xChart := GetChart;
  with xChart do begin
    Foot.Text.Text := GetReportFooter;
    Foot.Font.Height := -10;
    Title.Text.Text := GetReportTitle;
    Title.Font.Height := -14;
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
    PrepareReportChart;
    FisPie := False;
    xCount := 0;
    xTemp := TPieSeries.Create(Nil);
    while (xCount <= SeriesCount - 1) and (not FisPie) do begin
      FisPie := Series[xCount].SameClass(xTemp);
      Inc(xCount);
    end;
    xTemp.Free;
  end;
  SetChartProps;
end;

constructor TAccountBalanceChartReport.CreateReport(AParams: TCReportParams);
begin
  inherited CreateReport(AParams);
  FIds := TStringList.Create;
end;

destructor TAccountBalanceChartReport.Destroy;
begin
  FIds.Free;
  inherited Destroy;
end;

function TAccountBalanceChartReport.GetReportTitle: String;
var xAccount: String;
begin
  if Params = Nil then begin
    Result := 'Wykres stanu kont (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end else begin
    GDataProvider.BeginTransaction;
    xAccount := TAccount(TAccount.LoadObject(AccountProxy, FIds.Strings[0], False)).name;
    GDataProvider.RollbackTransaction;
    Result := 'Wykres stanu konta ' + xAccount + ' (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
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
  xChart := GetChart;
  xAccounts := TDataObject.GetList(TAccount, AccountProxy, 'select * from account');
  for xCount := 0 to xAccounts.Count - 1 do begin
    xAccount := TAccount(xAccounts.Items[xCount]);
    if IsValidAccount(xAccount.id, FIds) then begin
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
            xSerie.AddXY(xDate, xBalance, '');
            xDate := IncDay(xDate, -1);
          end;
        end;
        xDate := xSums.FieldByName('regDate').AsDateTime;
        if (FStartDate <= xDate) and (xDate <= FEndDate) then begin
          xSerie.AddXY(xDate, xBalance, '');
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
            xSerie.AddXY(xDate, xBalance, '');
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
  xAccounts.Free;
end;

function TAccountBalanceChartReport.PrepareReportConditions: Boolean;
begin
  if Params = Nil then begin
    Result := ChoosePeriodAccountListByForm(FStartDate, FEndDate, FIds);
  end else begin
    Result := ChoosePeriodByForm(FStartDate, FEndDate);
    FIds.Add(TCWithGidParams(Params).id);
  end;
end;

function TOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xSums: TSumList;
    xBody: TStringList;
    xCash: Currency;
    xCount: Integer;
begin
  xOperations := GDataProvider.OpenSql(
            Format('select b.*, a.name from transactions b' +
                   ' left outer join account a on a.idAccount = b.idAccount ' +
                   '  where movementType = ''%s'' and b.regDate between %s and %s order by b.regDate, b.created',
                   [TCSelectedMovementTypeParams(FParams).movementType , DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xSums := TSumList.Create(True);
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=6>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headtext" width="20%">Konto</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="10%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      xCash := Abs(FieldByName('cash').AsCurrency);
      xSums.AddSum(FieldByName('idMovementCurrencyDef').AsString, xCash);
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="40%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idMovementCurrencyDef').AsString) + '</td>');
      Add('<td class="cash" width="10%">' + CurrencyToString(xCash) + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr>');
    if xSums.Count > 0 then begin
      Add('<table class="base" colspan=3>');
      for xCount := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        Add('<td class="sumtext" width="80%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSums.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="10%">' + CurrencyToString(xSums.Items[xCount].value, '', False) + '</td>');
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xOperations.Free;
  Result := xBody.Text;
  xSums.Free;
  xBody.Free;
end;

function TOperationsListReport.GetReportTitle: String;
begin
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := 'Lista operacji przychodowych'; 
  end else begin
    Result := 'Lista operacji rozchodowych';
  end;
  Result := Result + ' (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

procedure TOperationsBySomethingChart.PrepareReportChart;
var xSums: TADOQuery;
    xSerie: TPieSeries;
    xChart: TChart;
    xCash: Currency;
    xLabel: String;
    xSum: Currency;
    xPercent: Double;
begin
  xChart := GetChart;
  xSums := GDataProvider.OpenSql(GetSql);
  xSerie := TPieSeries.Create(xChart);
  xSerie.Title := 'Wszystkie dane';
  xSum := 0;
  while not xSums.Eof do begin
    xSum := xSum + Abs(xSums.FieldByName('cash').AsCurrency);
    xSums.Next;
  end;
  xSums.First;
  while not xSums.Eof do begin
    xCash := Abs(xSums.FieldByName('cash').AsCurrency);
    xPercent := (xCash * 100) / xSum;
    xLabel := Format('%3.2f', [xPercent]) + '% - ' + xSums.FieldByName('name').AsString + ' (' + CurrencyToString(xCash) + ')';
    xSerie.Add(xCash, xLabel);
    xSums.Next;
  end;
  xSerie.Marks.Style := smsLabel;
  with xChart do begin
    AddSeries(xSerie);
  end;
  xSums.Free;
end;

function TOperationsBySomethingChart.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TOperationsByCategoryChart.GetReportTitle: String;
begin
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := 'Operacje przychodowe w/g kategorii (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end else begin
    Result := 'Operacje rozchodowe w/g kategorii (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end;
end;

function TOperationsByCategoryChart.GetSql: String;
begin
  Result := Format('select v.cash, p.name from ( ' +
                '  select sum(cash) as cash, idProduct from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by idProduct) as v ' +
                '  left outer join product p on p.idProduct = v.idProduct',
                [TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
end;

function TOperationsByCashpointChart.GetReportTitle: String;
begin
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := 'Operacje przychodowe w/g kontrahentÛw (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end else begin
    Result := 'Operacje rozchodowe w/g kontrahentÛw (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end;
end;

function TOperationsByCashpointChart.GetSql: String;
begin
  Result := Format('select v.cash, p.name from ( ' +
                '  select sum(cash) as cash, idCashpoint from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by idCashpoint) as v ' +
                '  left outer join cashpoint p on p.idCashpoint = v.idCashpoint',
                [TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
end;

function TOperationsBySomethingList.GetReportBody: String;
var xSums: TADOQuery;
    xCash: Currency;
    xSum: Currency;
    xPercent: Double;
    xBody: TStringList;
    xCurrs: TDataGids;
    xCount: Integer;
begin
  xSums := GDataProvider.OpenSql(GetSql);
  xCurrs := GetCurrencyDefsFromDataset(xSums, 'idMovementCurrencyDef');
  xBody := TStringList.Create;
  with xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="45%">Nazwa</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('<td class="headcash" width="20%">Procent ca≥oúci</td>');
    Add('</tr>');
    Add('</table><hr>');
  end;
  for xCount := 0 to xCurrs.Count - 1 do begin
    xSum := 0;
    xSums.Filter := 'idMovementCurrencyDef = ' + DataGidToDatabase(xCurrs.Strings[xCount]);
    xSums.Filtered := True;
    xSums.First;
    while not xSums.Eof do begin
      xSum := xSum + Abs(xSums.FieldByName('cash').AsCurrency);
      xSums.Next;
    end;
    with xSums, xBody do begin
      First;
      if xCount > 0 then begin
        Add('<hr>');
      end;
      with xBody do begin
        Add('<table class="base" colspan=1>');
        Add('<tr class="subhead">');
        Add('<td class="subheadtext" width="100%">[' + GCurrencyCache.GetIso(xCurrs.Strings[xCount]) + ']' + '</td>');
        Add('</tr>');
        Add('</table><hr>');
      end;
      Add('<table class="base" colspan=5>');
      while not Eof do begin
        if not Odd(RecNo) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        xCash := Abs(FieldByName('cash').AsCurrency);
        xPercent := (xCash * 100) / xSum;
        Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
        Add('<td class="text" width="45%">' + FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(xCurrs.Strings[xCount]) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xCash, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + Format('%3.2f', [xPercent]) + '%</td>');
        Add('</tr>');
        Next;
      end;
      Add('</table><hr><table class="base" colspan=3>');
      Add('<tr class="sum">');
      Add('<td class="sumtext" width="50%">Razem</td>');
      Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xCurrs.Strings[xCount]) + '</td>');
      Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum, '', False) + '</td>');
      Add('<td class="sumcash" width="20%"></td>');
      Add('</tr>');
      Add('</table>');
    end;
  end;
  Result := xBody.Text;
  xBody.Free;
  xSums.Free;
  xCurrs.Free;
end;

function TOperationsBySomethingList.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TOperationsByCategoryList.GetReportTitle: String;
begin
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := 'Operacje przychodowe w/g kategorii (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end else begin
    Result := 'Operacje rozchodowe w/g kategorii (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end;
end;

function TOperationsByCategoryList.GetSql: String;
begin
  Result := Format('select v.cash, p.name, v.idMovementCurrencyDef from ( ' +
                '  select sum(cash) as cash, idProduct, idMovementCurrencyDef from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by idProduct, idMovementCurrencyDef) as v ' +
                '  left outer join product p on p.idProduct = v.idProduct',
                [TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
end;

function TOperationsByCashpointList.GetReportTitle: String;
begin
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := 'Operacje przychodowe w/g kontrahentÛw (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end else begin
    Result := 'Operacje rozchodowe w/g kontrahentÛw (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end;
end;

function TOperationsByCashpointList.GetSql: String;
begin
  Result := Format('select v.cash, p.name, v.idMovementCurrencyDef from ( ' +
                '  select sum(cash) as cash, idCashpoint, idMovementCurrencyDef from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by idCashpoint, idMovementCurrencyDef) as v ' +
                '  left outer join cashpoint p on p.idCashpoint = v.idCashpoint',
                [TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
end;

constructor TCSelectedMovementTypeParams.Create(AType: String);
begin
  inherited Create;
  FmovementType := AType;
end;

constructor TSumReportList.CreateReport(AParams: TCReportParams);
begin
  inherited CreateReport(AParams);
  FIds := TStringList.Create;
end;

destructor TSumReportList.Destroy;
begin
  FIds.Free;
  inherited Destroy;
end;

function TSumReportList.GetDescription(ADate: TDateTime): String;
begin
  Result := GetFormattedDate(ADate, CBaseDateFormat);
  if FGroupBy = CGroupByDay then begin
    Result := GetFormattedDate(ADate, CBaseDateFormat);
  end else if FGroupBy = CGroupByWeek then begin
    Result := GetFormattedDate(ADate, CBaseDateFormat) + ' - ' + GetFormattedDate(EndOfTheWeek(ADate), CBaseDateFormat);
  end else if FGroupBy = CGroupByMonth then begin
    Result := GetFormattedDate(ADate, CMonthnameDateFormat);
  end;
end;

function TSumReportList.GetReportBody: String;
var xOperations: TADOQuery;
    xGb: String;
    xGbSum, xSums: TSumList;
    xBody: TStringList;
    xName: String;
    xCurDate: TDateTime;
    xRec, xCount: Integer;
begin
  xGb := 'regDate';
  xName := 'DzieÒ';
  if FGroupBy = CGroupByWeek then begin
    xGb := 'weekDate';
    xName := 'TydzieÒ';
  end else if FGroupBy = CGroupByMonth then begin
    xGb := 'monthDate';
    xName := 'Miesiπc';
  end;
  xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, sum(movementCash) as movementCash, %s, idAccount, idMovementCurrencyDef from transactions where movementType = ''%s'' and regDate between %s and %s group by idMovementCurrencyDef, %s, idAccount order by %s',
                             [xGb, TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), xGb, xGb]));
  xSums := TSumList.Create(True);
  xRec := 1;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=3>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="70%">' + xName + '</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=3>');
    if FGroupBy = CGroupByWeek then begin
      xCurDate := StartOfTheWeek(FStartDate);
    end else if FGroupBy = CGroupByMonth then begin
      xCurDate := StartOfTheMonth(FStartDate);
    end else begin
      xCurDate := FStartDate;
    end;
    while (xCurDate <= FEndDate) do begin
      Filter := xGb + ' = ' + DatetimeToDatabase(xCurDate, False);
      Filtered := True;
      First;
      xGbSum := TSumList.Create(True);
      while not Eof do begin
        if IsValidAccount(FieldByName('idAccount').AsString, FIds) then begin
          xGbSum.AddSum(FieldByName('idMovementCurrencyDef').AsString, Abs(FieldByName('movementCash').AsCurrency));
        end;
        Next;
      end;
      if xGbSum.Count > 0 then begin
        for xCount := 0 to xGbSum.Count - 1 do begin
          Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
          Add('<td class="text" width="70%">' + IfThen(xCount = 0, GetDescription(xCurDate), '') + '</td>');
          Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(xGbSum.Items[xCount].name) + '</td>');
          Add('<td class="cash" width="20%">' + CurrencyToString(xGbSum.Items[xCount].value, '', False) + '</td>');
          Add('</tr>');
          Inc(xRec);
          xSums.AddSum(xGbSum.Items[xCount].name, xGbSum.Items[xCount].value);
        end;
      end else begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="70%">' + GetDescription(xCurDate) + '</td>');
        Add('<td class="cash" width="10%">-</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(0, '', False) + '</td>');
        Add('</tr>');
        Inc(xRec);
      end;
      xGbSum.Free;
      if FGroupBy = CGroupByWeek then begin
        xCurDate := IncWeek(xCurDate, 1);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := IncMonth(xCurDate, 1);
      end else begin
        xCurDate := IncDay(xCurDate, 1);
      end;
    end;
    Add('</table><hr>');
    if xSums.Count > 0 then begin
      Add('<table class="base" colspan=3>');
      for xCount := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        Add('<td class="sumtext" width="70%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSums.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="20%">' + CurrencyToString(xSums.Items[xCount].value, '', False) + '</td>');
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
  xSums.Free;
end;

function TSumReportList.GetReportTitle: String;
begin
  Result := 'Sumy ';
  if FGroupBy = CGroupByDay then begin
    Result := Result + 'dziennych ';
  end else if FGroupBy = CGroupByWeek then begin
    Result := Result + 'tygodniowych ';
  end else if FGroupBy = CGroupByMonth then begin
    Result := Result + 'miesiÍcznych ';
  end;
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := Result + 'przychodÛw ';
  end else if TCSelectedMovementTypeParams(FParams).movementType = COutMovement then begin
    Result := Result + 'rozchodÛw ';
  end;
  Result := Result + '(' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TSumReportList.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAccountListGroupByForm(FStartDate, FEndDate, FIds, FGroupBy);
end;

constructor TSumReportChart.CreateReport(AParams: TCReportParams);
begin
  inherited CreateReport(AParams);
  FIds := TStringList.Create;
end;

destructor TSumReportChart.Destroy;
begin
  FIds.Free;
  inherited Destroy;
end;

function TSumReportChart.GetDescription(ADate: TDateTime): String;
begin
  Result := GetFormattedDate(ADate, CBaseDateFormat);
  if FGroupBy = CGroupByDay then begin
    Result := GetFormattedDate(ADate, CBaseDateFormat);
  end else if FGroupBy = CGroupByWeek then begin
    Result := GetFormattedDate(ADate, CBaseDateFormat) + ' - ' + GetFormattedDate(EndOfTheWeek(ADate), CBaseDateFormat);
  end else if FGroupBy = CGroupByMonth then begin
    Result := GetFormattedDate(ADate, CMonthnameDateFormat);
  end;
end;

function TSumReportChart.GetReportTitle: String;
begin
  Result := 'Sumy ';
  if FGroupBy = CGroupByDay then begin
    Result := Result + 'dziennych ';
  end else if FGroupBy = CGroupByWeek then begin
    Result := Result + 'tygodniowych ';
  end else if FGroupBy = CGroupByMonth then begin
    Result := Result + 'miesiÍcznych ';
  end;
  if TCSelectedMovementTypeParams(FParams).movementType = CInMovement then begin
    Result := Result + 'przychodÛw ';
  end else if TCSelectedMovementTypeParams(FParams).movementType = COutMovement then begin
    Result := Result + 'rozchodÛw ';
  end else begin
    Result := Result + 'przychodÛw i rozchodÛw';
  end;
  Result := Result + '(' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

procedure TSumReportChart.PrepareReportChart;
var xOperations: TADOQuery;
    xGb: String;
    xGbSum: Currency;
    xName: String;
    xCurDate: TDateTime;
    xInSerie, xOutSerie: TBarSeries;
    xInMovements: Boolean;
    xOutMovements: Boolean;
begin
  xGb := 'regDate';
  xName := 'DzieÒ';
  if FGroupBy = CGroupByWeek then begin
    xGb := 'weekDate';
    xName := 'TydzieÒ';
  end else if FGroupBy = CGroupByMonth then begin
    xGb := 'monthDate';
    xName := 'Miesiπc';
  end;
  xInSerie := Nil;
  xOutSerie := Nil;
  xInMovements := Pos(CInMovement, TCSelectedMovementTypeParams(FParams).movementType) > 0;
  xOutMovements := Pos(COutMovement, TCSelectedMovementTypeParams(FParams).movementType) > 0;
  if xInMovements then begin
    xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, %s, idAccount from transactions where movementType = ''%s'' and regDate between %s and %s group by %s, idAccount order by %s',
                               [xGb, CInMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), xGb, xGb]));
    with xOperations do begin
      if FGroupBy = CGroupByWeek then begin
        xCurDate := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := StartOfTheMonth(FStartDate);
      end else begin
        xCurDate := FStartDate;
      end;
      xInSerie := TBarSeries.Create(GetChart);
      with TBarSeries(xInSerie) do begin
        Title := xName;
        Marks.ArrowLength := 0;
        Marks.Style := smsValue;
        HorizAxis := aBottomAxis;
        XValues.DateTime := True;
      end;
      while (xCurDate <= FEndDate) do begin
        Filter := xGb + ' = ' + DatetimeToDatabase(xCurDate, False);
        Filtered := True;
        First;
        xGbSum := 0;
        while not Eof do begin
          if IsValidAccount(FieldByName('idAccount').AsString, FIds) then begin
            xGbSum := xGbSum + Abs(FieldByName('cash').AsCurrency);
          end;
          Next;
        end;
        xInSerie.AddXY(xCurDate, xGbSum, GetDescription(xCurDate));
        if FGroupBy = CGroupByWeek then begin
          xCurDate := IncWeek(xCurDate, 1);
        end else if FGroupBy = CGroupByMonth then begin
          xCurDate := IncMonth(xCurDate, 1);
        end else begin
          xCurDate := IncDay(xCurDate, 1);
        end;
      end;
    end;
    xOperations.Free;
  end;
  if xOutMovements then begin
    xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, %s, idAccount from transactions where movementType = ''%s'' and regDate between %s and %s group by %s, idAccount order by %s',
                               [xGb, COutMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), xGb, xGb]));
    with xOperations do begin
      if FGroupBy = CGroupByWeek then begin
        xCurDate := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := StartOfTheMonth(FStartDate);
      end else begin
        xCurDate := FStartDate;
      end;
      xOutSerie := TBarSeries.Create(GetChart);
      with TBarSeries(xOutSerie) do begin
        Title := xName;
        Marks.ArrowLength := 0;
        Marks.Style := smsValue;
        HorizAxis := aBottomAxis;
        XValues.DateTime := True;
      end;
      while (xCurDate <= FEndDate) do begin
        Filter := xGb + ' = ' + DatetimeToDatabase(xCurDate, False);
        Filtered := True;
        First;
        xGbSum := 0;
        while not Eof do begin
          if IsValidAccount(FieldByName('idAccount').AsString, FIds) then begin
            xGbSum := xGbSum + Abs(FieldByName('cash').AsCurrency);
          end;
          Next;
        end;
        xOutSerie.AddXY(xCurDate, xGbSum, GetDescription(xCurDate));
        if FGroupBy = CGroupByWeek then begin
          xCurDate := IncWeek(xCurDate, 1);
        end else if FGroupBy = CGroupByMonth then begin
          xCurDate := IncMonth(xCurDate, 1);
        end else begin
          xCurDate := IncDay(xCurDate, 1);
        end;
      end;
    end;
    xOperations.Free;
  end;
  with GetChart do begin
    with BottomAxis do begin
      Automatic := False;
      AutomaticMaximum := False;
      AutomaticMinimum := False;
      if FGroupBy = CGroupByWeek then begin
        Maximum := EndOfTheWeek(FEndDate);
        Minimum := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        Maximum := EndOfTheMonth(FEndDate);
        Minimum := StartOfTheMonth(FStartDate);
      end else begin
        Maximum := FEndDate;
        Minimum := FStartDate;
      end;
      LabelsAngle := 90;
      MinorTickCount := 0;
      Title.Caption := xName
    end;
    with LeftAxis do begin
      MinorTickCount := 0;
      Title.Caption := '[' + GetCurrencySymbol + ']';
      Title.Angle := 90;
    end;
    if xInMovements then begin
      AddSeries(xInSerie);
    end;
    if xOutMovements then begin
      AddSeries(xOutSerie);
    end;
    if xInMovements and xOutMovements then begin
      xInSerie.Title := 'Przychody';
      xOutSerie.Title := 'Rozchody';
    end;
  end;
end;

function TSumReportChart.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAccountListGroupByForm(FStartDate, FEndDate, FIds, FGroupBy);
end;

function TAveragesReport.GetReportBody: String;
var xBody: TStringList;
    xRec: Integer;
    xSql: String;
    xDaysBetween: Integer;
    xWeeksBetween: Integer;
    xMonthsBetween: Integer;
    xQuery: TADOQuery;
    xFilter: String;
begin
  xBody := TStringList.Create;
  xDaysBetween := DayCount(FEndDate, FStartDate);
  xWeeksBetween := WeekCount(FEndDate, FStartDate);
  xMonthsBetween := MonthCount(FEndDate, FStartDate);
  with xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="40%">årednie ogÛ≥em (wszystkie konta)</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xRec := 1;
    xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True);
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses from balances where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xQuery := GDataProvider.OpenSql(xSql);
    if xDaysBetween > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">Dzienne</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xDaysBetween) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xDaysBetween) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xDaysBetween) + '</td>');
      Add('</tr>');
      Inc(xRec);
    end;
    if xWeeksBetween > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">Tygodniowe</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xWeeksBetween) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xWeeksBetween) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xWeeksBetween) + '</td>');
      Add('</tr>');
      Inc(xRec);
    end;
    if xMonthsBetween > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">MiesiÍcznie</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xMonthsBetween) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xMonthsBetween) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xMonthsBetween) + '</td>');
      Add('</tr>');
    end;
    Add('</table>');
    xQuery.Free;
    //konta
    Add('<hr>');
    Add('<p>');
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, balances.idAccount, account.name from balances ' +
                   ' left outer join account on account.idAccount = balances.idAccount ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by balances.idAccount, account.name';
    xQuery := GDataProvider.OpenSql(xSql);
    if xDaysBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie dzienne (dla konta)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xDaysBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xDaysBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xDaysBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    if xWeeksBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie tygodniowe (dla konta)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xWeeksBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xWeeksBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xWeeksBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    if xMonthsBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie miesiÍczne (dla konta)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xMonthsBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xMonthsBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xMonthsBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    xQuery.Free;
    //kontrahenci
    Add('<hr>');
    Add('<p>');
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, balances.idCashpoint, cashpoint.name from balances ' +
                   ' left outer join cashpoint on cashpoint.idCashpoint = balances.idCashpoint ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by balances.idCashpoint, cashpoint.name';
    xQuery := GDataProvider.OpenSql(xSql);
    if xDaysBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie dzienne (dla kontrahenta)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xDaysBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xDaysBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xDaysBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    if xWeeksBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie tygodniowe (dla kontrahenta)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xWeeksBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xWeeksBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xWeeksBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    if xMonthsBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie miesiÍczne (dla kontrahenta)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xMonthsBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xMonthsBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xMonthsBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    xQuery.Free;
    //kategorie
    Add('<hr>');
    Add('<p>');
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, balances.idProduct, product.name from balances ' +
                   ' left outer join product on product.idProduct = balances.idProduct ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by balances.idProduct, product.name';
    xQuery := GDataProvider.OpenSql(xSql);
    if xDaysBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie dzienne (dla kategorii)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xDaysBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xDaysBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xDaysBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    if xWeeksBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie tygodniowe (dla kategorii)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xWeeksBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xWeeksBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xWeeksBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    if xMonthsBetween > 0 then begin
      Add('<hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="100%">årednie miesiÍczne (dla kategorii)</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=4>');
      xQuery.First;
      xRec := 1;
      while not xQuery.Eof do begin
        if not Odd(xRec) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xMonthsBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xMonthsBetween) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xMonthsBetween) + '</td>');
        Add('</tr>');
        Inc(xRec);
        xQuery.Next;
      end;
      Add('</table>');
    end;
    xQuery.Free;
  end;
  Result := xBody.Text;
  xBody.Free;
end;

function TAveragesReport.GetReportTitle: String;
begin
  Result := 'årednie (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TAveragesReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FIdFilter, True);
end;

function TPeriodSumsReport.GetReportBody: String;
var xBody: TStringList;
    xRec: Integer;
    xSql: String;
    xQuery: TADOQuery;
    xFilter: String;
begin
  xBody := TStringList.Create;
  with xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="40%">Sumy ogÛ≥em (wszystkie konta)</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xRec := 1;
    xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True);
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses from balances where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xQuery := GDataProvider.OpenSql(xSql);
    if not Odd(xRec) then begin
      Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
    end else begin
      Add('<tr class="base">');
    end;
    Add('<td class="text" width="40%">W wybranym okresie</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency)) + '</td>');
    Add('</tr>');
    Add('</table>');
    xQuery.Free;
    //konta
    Add('<hr>');
    Add('<p>');
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, balances.idAccount, account.name from balances ' +
                   ' left outer join account on account.idAccount = balances.idAccount ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by balances.idAccount, account.name';
    xQuery := GDataProvider.OpenSql(xSql);
    Add('<hr>');
    Add('<table class="base" colspan=1>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="100%">Sumy ogÛ≥em (dla konta)</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xQuery.First;
    xRec := 1;
    while not xQuery.Eof do begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency)) + '</td>');
      Add('</tr>');
      Inc(xRec);
      xQuery.Next;
    end;
    Add('</table>');
    xQuery.Free;
    //kontrahenci
    Add('<hr>');
    Add('<p>');
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, balances.idCashpoint, cashpoint.name from balances ' +
                   ' left outer join cashpoint on cashpoint.idCashpoint = balances.idCashpoint ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by balances.idCashpoint, cashpoint.name';
    xQuery := GDataProvider.OpenSql(xSql);
    Add('<hr>');
    Add('<table class="base" colspan=1>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="100%">Sumy ogÛ≥em (dla kontrahenta)</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xQuery.First;
    xRec := 1;
    while not xQuery.Eof do begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency)) + '</td>');
      Add('</tr>');
      Inc(xRec);
      xQuery.Next;
    end;
    Add('</table>');
    xQuery.Free;
    //kategorie
    Add('<hr>');
    Add('<p>');
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, balances.idProduct, product.name from balances ' +
                   ' left outer join product on product.idProduct = balances.idProduct ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by balances.idProduct, product.name';
    xQuery := GDataProvider.OpenSql(xSql);
    Add('<hr>');
    Add('<table class="base" colspan=1>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="100%">Sumy ogÛ≥em (dla kategorii)</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xQuery.First;
    xRec := 1;
    while not xQuery.Eof do begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">' + xQuery.FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency)) + '</td>');
      Add('</tr>');
      Inc(xRec);
      xQuery.Next;
    end;
    Add('</table>');
    xQuery.Free;
  end;
  Result := xBody.Text;
  xBody.Free;
end;

function TPeriodSumsReport.GetReportTitle: String;
begin
  Result := 'Podsumowanie (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
end;

function TPeriodSumsReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FIdFilter, True);
end;

function TFuturesReport.GetReportBody: String;
var xBody: TStringList;
    xSql: String;
    xRec: Integer;
    xQuery: TADOQuery;
    xFilter: String;
    xBasePeriodIn, xBasePeriodOut: TPeriodSums;
    xFuturePeriodIn, xFuturePeriodOut: TPeriodSums;
begin
  xBody := TStringList.Create;
  with xBody do begin
    xRec := 1;
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="40%">Podsumowanie okresu bazowego</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True);
    xSql := Format('select sum(income) as incomes, sum(expense) as expenses, regdate from balances where movementType <> ''%s'' and regDate between %s and %s',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by regDate';
    xQuery := GDataProvider.OpenSql(xSql);
    xBasePeriodIn := TPeriodSums.Create(FStartDate, FEndDate);
    xBasePeriodOut := TPeriodSums.Create(FStartDate, FEndDate);
    xBasePeriodIn.FromDataset(xQuery, 'incomes', 'regDate');
    xBasePeriodOut.FromDataset(xQuery, 'expenses', 'regDate');
    if not Odd(xRec) then begin
      Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
    end else begin
      Add('<tr class="base">');
    end;
    Add('<td class="text" width="40%">Razem</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodIn.sum) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodOut.sum) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString((xBasePeriodIn.sum - xBasePeriodOut.sum)) + '</td>');
    Add('</tr>');
    Inc(xRec);
    if not Odd(xRec) then begin
      Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
    end else begin
      Add('<tr class="base">');
    end;
    Add('<td class="text" width="40%">Dziennie</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodIn.dayAvg) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodOut.dayAvg) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString((xBasePeriodIn.dayAvg - xBasePeriodOut.dayAvg)) + '</td>');
    Add('</tr>');
    Inc(xRec);
    if WeekCount(FEndDate, FStartDate) > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">Tygodniowo</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodIn.weekAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodOut.weekAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xBasePeriodIn.weekAvg - xBasePeriodOut.weekAvg)) + '</td>');
      Add('</tr>');
      Inc(xRec);
    end;
    if MonthCount(FEndDate, FStartDate) > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">MiesiÍcznie</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodIn.monthAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xBasePeriodOut.monthAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xBasePeriodIn.monthAvg - xBasePeriodOut.monthAvg)) + '</td>');
      Add('</tr>');
    end;
    Add('</table>');
    Add('<hr>');
    Add('<p>');
    Add('<hr>');
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="40%">Prognoza dla wybranego okresu</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    xRec := 1;
    xFuturePeriodIn := xBasePeriodIn.GetRegLin(FStartFuture, FEndFuture);
    xFuturePeriodOut := xBasePeriodOut.GetRegLin(FStartFuture, FEndFuture);
    if not Odd(xRec) then begin
      Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
    end else begin
      Add('<tr class="base">');
    end;
    Add('<td class="text" width="40%">Razem</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodIn.sum) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodOut.sum) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString((xFuturePeriodIn.sum - xFuturePeriodOut.sum)) + '</td>');
    Add('</tr>');
    Inc(xRec);
    if not Odd(xRec) then begin
      Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
    end else begin
      Add('<tr class="base">');
    end;
    Add('<td class="text" width="40%">Dziennie</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodIn.dayAvg) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodOut.dayAvg) + '</td>');
    Add('<td class="cash" width="20%">' + CurrencyToString((xFuturePeriodIn.dayAvg - xFuturePeriodOut.dayAvg)) + '</td>');
    Add('</tr>');
    Inc(xRec);
    if WeekCount(FEndFuture, FStartFuture) > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">Tygodniowo</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodIn.weekAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodOut.weekAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xFuturePeriodIn.weekAvg - xFuturePeriodOut.weekAvg)) + '</td>');
      Add('</tr>');
      Inc(xRec);
    end;
    if MonthCount(FEndFuture, FStartFuture) > 0 then begin
      if not Odd(xRec) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="40%">MiesiÍcznie</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodIn.monthAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xFuturePeriodOut.monthAvg) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xFuturePeriodIn.monthAvg - xFuturePeriodOut.monthAvg)) + '</td>');
      Add('</tr>');
    end;
    Add('</table>');
    xQuery.Free;
    Add('</table>');
    xFuturePeriodIn.Free;
    xFuturePeriodOut.Free;
    xBasePeriodIn.Free;
    xBasePeriodOut.Free;
  end;
  Result := xBody.Text;
  xBody.Free;
end;

function TFuturesReport.GetReportTitle: String;
begin
  Result := 'Prognozy (' + GetFormattedDate(FStartFuture, CLongDateFormat) + ' - ' + GetFormattedDate(FEndFuture, CLongDateFormat) + ')';
end;

function TFuturesReport.PrepareReportConditions: Boolean;
begin
  Result := ChooseFutureFilterByForm(FStartDate, FEndDate, FStartFuture, FEndFuture, FIdFilter, True)
end;

constructor TSumForDayItem.Create(ADate: TDateTime; ASum: Currency);
begin
  inherited Create;
  Fsum := ASum;
  Fdate := ADate;
end;

constructor TPeriodSums.Create(AStartDate, AEndDate: TDateTime);
var xCurDate: TDateTime;
begin
  inherited Create(True);
  FstartDate := AStartDate;
  FendDate := AEndDate;
  xCurDate := FstartDate;
  repeat
    Add(TSumForDayItem.Create(xCurDate));
    xCurDate := IncDay(xCurDate);
  until (xCurDate > FendDate);
end;

procedure TPeriodSums.FromDataset(ADataset: TDataSet; ASumName, ADateName: String);
begin
  ADataset.First;
  while not ADataset.Eof do begin
    ByDate[ADataset.FieldByName(ADateName).AsDateTime] := ADataset.FieldByName(ASumName).AsCurrency;
    ADataset.Next;
  end;
end;

function TPeriodSums.GetDayAvg: Currency;
begin
  Result := sum / DayCount(FEndDate, FStartDate);
end;

function TPeriodSums.GetbyDateTime(ADateTime: TDateTime): Currency;
var xCount: Integer;
    xObj: TSumForDayItem;
begin
  xObj := Nil;
  xCount := 0;
  while (xCount <= Count - 1) do begin
    if Items[xCount].date = ADateTime then begin
      xObj := Items[xCount];
    end;
    Inc(xCount);
  end;
  if xObj = Nil then begin
    xObj := TSumForDayItem.Create(ADateTime);
    Add(xObj);
  end;
  Result := xObj.sum;
end;

function TPeriodSums.Getitems(AIndex: Integer): TSumForDayItem;
begin
  Result := TSumForDayItem(inherited Items[AIndex]);
end;

function TPeriodSums.GetRegLin(AStartDate, AEndDate: TDateTime): TPeriodSums;
var xCurDate: TDateTime;
    xRegression: TRegresionData;
begin
  Result := TPeriodSums.Create(AStartDate, AEndDate);
  xCurDate := AStartDate;
  xRegression := regresion;
  repeat
    Result.ByDate[xCurDate] := xRegression.a * xCurDate + xRegression.b;
    xCurDate := IncDay(xCurDate);
  until (xCurDate > AEndDate);
end;

function TPeriodSums.GetregresionData: TRegresionData;
var xArray: array of Double;
    yArray: array of Double;
    xCount: Integer;
begin
  SetLength(xArray, Count);
  SetLength(yArray, Count);
  for xCount := 0 to Count - 1 do begin
    xArray[xCount] := Items[xCount].date;
    yArray[xCount] := Items[xCount].sum;
  end;
  RegLin(xArray, yArray, Result.a, Result.b);
end;

function TPeriodSums.Getsum: Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    Result := Result + Items[xCount].sum;
  end;
end;

procedure TPeriodSums.SetbyDateTime(ADateTime: TDateTime; const Value: Currency);
var xCount: Integer;
    xObj: TSumForDayItem;
begin
  xObj := Nil;
  xCount := 0;
  while (xCount <= Count - 1) do begin
    if Items[xCount].date = ADateTime then begin
      xObj := Items[xCount];
    end;
    Inc(xCount);
  end;
  if xObj = Nil then begin
    xObj := TSumForDayItem.Create(ADateTime);
    Add(xObj);
  end;
  xObj.sum := Value;
end;

procedure TPeriodSums.Setitems(AIndex: Integer; const Value: TSumForDayItem);
begin
  inherited Items[AIndex] := Value;
end;

function TPeriodSums.GetMonthAvg: Currency;
begin
  Result := sum / MonthCount(FendDate, FstartDate);
end;

function TPeriodSums.GetWeekAvg: Currency;
begin
  Result := sum / WeekCount(FendDate, FstartDate);
end;

constructor TCVirtualStringTreeParams.Create(AList: TCList; ATitle: String);
begin
  inherited Create;
  Flist := AList;
  Ftitle := ATitle;
end;

constructor TVirtualStringReport.CreateReport(AParams: TCReportParams);
begin
  inherited CreateReport(AParams);
  FWidth := -1;
end;

function TVirtualStringReport.GetColumnPercentage(AColumn: TVirtualTreeColumn): Integer;
var xList: TVirtualStringTree;
    xScroll: TScrollInfo;
begin
  xList := TCVirtualStringTreeParams(FParams).list;
  if FWidth = -1 then begin
    xScroll.cbSize := SizeOf(xScroll);
    xScroll.fMask := SIF_RANGE;
    if GetScrollInfo(xList.Handle, SB_HORZ, xScroll) then begin
      FWidth := xScroll.nMax;
    end else begin
      FWidth := xList.Width;
    end;
    if FWidth = 0 then begin
      FWidth := xList.Width;
    end;
  end;
  Result := Trunc(AColumn.Width * 100 / FWidth);
end;

function TVirtualStringReport.GetReportBody: String;
var xBody: TStringList;
    xList: TCList;
    xColumns: TColumnsArray;
    xCount: Integer;
    xNode: PVirtualNode;
    xAl: String;
    xLevelPrefix: String;
    xLevel: Integer;
    xExpand: String;
begin
  xList := TCVirtualStringTreeParams(FParams).list;
  xBody := TStringList.Create;
  xColumns := xList.Header.Columns.GetVisibleColumns;
  with xBody do begin
    Add('<table class="base" colspan=' + IntToStr(Length(xColumns)) + '>');
    Add('<tr class="head">');
    for xCount := Low(xColumns) to High(xColumns) do begin
      if (xColumns[xCount].Alignment = taRightJustify) and (AnsiUpperCase(xColumns[xCount].Text) <> 'LP') then begin
        xAl := 'headcash';
      end else begin
        xAl := 'headtext';
      end;
      Add('<td class="' + xAl + '" width="' + IntToStr(GetColumnPercentage(xColumns[xCount])) + '%">' + xColumns[xCount].Text + '</td>');
    end;
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=' + IntToStr(Length(xColumns)) + '>');
    xNode := xList.GetFirstVisible;
    while xNode <> Nil do begin
      Add('<tr class="' + IsEvenToStr(xList.GetVisibleIndex(xNode) + 1) + 'base">');
      for xCount := Low(xColumns) to High(xColumns) do begin
        if (xColumns[xCount].Alignment = taRightJustify) and (AnsiUpperCase(xColumns[xCount].Text) <> 'LP') then begin
          xAl := 'cash';
        end else begin
          xAl := 'text';
        end;
        xLevel := 16 * xList.GetNodeLevel(xNode);
        xLevelPrefix := '';
        while Length(xLevelPrefix) < xLevel do begin
          xLevelPrefix := xLevelPrefix + '&nbsp';
        end;
        if xNode.ChildCount > 0 then begin
          if vsExpanded in xNode.States then begin
            xExpand := '&nbsp-&nbsp';
          end else begin
            xExpand := '&nbsp+&nbsp';
          end;
        end else begin
          xExpand := '&nbsp';
        end;
        Add(Format('<td class="%s" width="%s">' + xLevelPrefix + xExpand + xList.Text[xNode, xColumns[xCount].Index] + '</td>', [xAl, IntToStr(GetColumnPercentage(xColumns[xCount])) + '%']));
      end;
      Add('</tr>');
      xNode := xList.GetNextVisible(xNode);
    end;
    Add('</table>');
  end;
  Result := xBody.Text;
  xBody.Free;
end;

function TVirtualStringReport.GetReportTitle: String;
begin
  Result := TCVirtualStringTreeParams(FParams).title;
end;

function TTodayOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje wykonane (' + GetFormattedDate(FStartDate, CLongDateFormat) + ')';
end;

function TTodayOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := True;
  FStartDate := GWorkDate;
  FEndDate := GWorkDate;
  FFilterId := CEmptyDataGid;
end;

constructor TLoanReportParams.Create(ALoan: TLoan);
begin
  inherited Create;
  Floan := ALoan;
end;

function TLoanReport.GetReportBody: String;
var xL: TLoan;
    xPaymentType: String;
    xPaymentPeriod: String;
    xBody: TStringList;
    xCount: Integer;
begin
  xL := TLoanReportParams(FParams).loan;
  if xL.paymentType = lptTotal then begin
    xPaymentType := 'sta≥e';
  end else begin
    xPaymentType := 'malejπce';
  end;
  if xL.paymentPeriod = lppWeekly then begin
    xPaymentPeriod := 'tygodniowo';
  end else begin
    xPaymentPeriod := 'miesiÍcznie';
  end;
  xBody := TStringList.Create;
  with xBody do begin
    Add('<table class="base" colspan="6">');
    Add('<tr class="base">');
    Add('<td class="headcenter" width="20%">Kwota</td>');
    Add('<td class="headcenter" width="10%">Oprocentowanie</td>');
    Add('<td class="headcenter" width="15%">Prowizje i op≥aty</td>');
    Add('<td class="headcenter" width="15%">IloúÊ sp≥at</td>');
    Add('<td class="headcenter" width="15%">Rodzaj sp≥at</td>');
    Add('<td class="headcenter" width="15%">CzÍstotliwoúÊ</td>');
    Add('<td class="headcenter" width="10%">Rrso</td>');
    Add('</tr></table><hr>');
    Add('<table class="base" colspan="6">');
    Add('<tr class="base">');
    Add('<td class="center" width="20%">' + CurrencyToString(xL.totalCash) + '</td>');
    Add('<td class="center" width="10%">' + CurrencyToString(xL.taxAmount, '', False, 4) + '%</td>');
    Add('<td class="center" width="15%">' + CurrencyToString(xL.otherTaxes) + '</td>');
    Add('<td class="center" width="15%">' + IntToStr(xL.periods) + '</td>');
    Add('<td class="center" width="15%">' + xPaymentType + '</td>');
    Add('<td class="center" width="15%">' + xPaymentPeriod + '</td>');
    Add('<td class="center" width="10%">' + CurrencyToString(xL.yearRate, '', False, 4) + '%</td>');
    Add('</tr>');
    Add('</table>');
    Add('<hr>');
    Add('<p class="reptitle">Harmonogram sp≥at<hr>');
    Add('<table class="base" colspan="' + IntToStr(IfThen(xL.firstDay <> 0, 6, 5)) + '">');
    Add('<tr class="base">');
    Add('<td class="headtext" width="5%">Lp</td>');
    if xL.firstDay <> 0 then begin
      Add('<td class="headtext" width="20%">Data</td>');
    end;
    Add('<td class="headcash" width="25%">Kwota sp≥aty</td>');
    Add('<td class="headcash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">Kapita≥</td>');
    Add('<td class="headcash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">Odsetki</td>');
    Add('<td class="headcash" width="20%">Pozosta≥y kapita≥</td>');
    Add('</tr>');
    Add('</table>');
    Add('<hr>');
    Add('<table class="base" colspan="' + IntToStr(IfThen(xL.firstDay <> 0, 6, 5)) + '">');
    for xCount := 0 to xL.Count - 1 do begin
      if xL.IsSumObject(xCount) then begin
        if not Odd(xCount) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="5%">' + IntToStr(xCount + 1) + '</td>');
        if xL.firstDay <> 0 then begin
          Add('<td class="text" width="20%">' + DateToStr(xL.Items[xCount].date) + '</td>');
        end;
        Add('<td class="cash" width="25%">' + CurrencyToString(xL.Items[xCount].payment) + '</td>');
        Add('<td class="cash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.Items[xCount].principal) + '</td>');
        Add('<td class="cash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.Items[xCount].tax) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xL.Items[xCount].left) + '</td>');
        Add('</tr>');
      end;
    end;
    Add('</table><hr><table class="base" colspan="' + IntToStr(IfThen(xL.firstDay <> 0, 6, 5)) + '">');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="5%">Razem</td>');
    if xL.firstDay <> 0 then begin
      Add('<td class="sumtext" width="20%"></td>');
    end;
    Add('<td class="sumcash" width="25%">' + CurrencyToString(xL.sumPayments) + '</td>');
    Add('<td class="sumcash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.sumPrincipal) + '</td>');
    Add('<td class="sumcash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.sumTax) + '</td>');
    Add('<td class="sumcash" width="20%"></td>');
    Add('</tr>');
    Add('</table>');
  end;
  Result := xBody.Text;
  xBody.Free;
end;

function TLoanReport.GetReportTitle: String;
begin
  Result := 'Informacje o kredycie';
end;

function TCurrencyRatesHistoryReport.GetReportTitle: String;
var xCashpoint: String;
begin
  GDataProvider.BeginTransaction;
  FSourceIso := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, FSourceId, False)).iso;
  FTargetIso := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, FTargetId, False)).iso;
  if FCashpointId <> CEmptyDataGid then begin
    xCashpoint := 'w/g ' + TCashPoint(TCashPoint.LoadObject(CashPointProxy, FCashpointId, False)).name;
  end else begin
    xCashpoint := '';
  end;
  Result := Format('Kurs waluty %s wzglÍdem %s %s (%s - %s)', [FSourceIso, FTargetIso, xCashpoint, GetFormattedDate(FStartDate, CLongDateFormat), GetFormattedDate(FEndDate, CLongDateFormat)]);
  FAxisName := FSourceIso + '/' + FTargetIso;
end;

procedure TCurrencyRatesHistoryReport.PrepareReportChart;

  function FindCurrencyRate(AInlist: TDataObjectList; ABindingDate: TDateTime; ArateType: TBaseEnumeration): TCurrencyRate;
  var xCount: Integer;
  begin
    Result := Nil;
    xCount := 0;
    while (Result = Nil) and (xCount <= AInlist.Count - 1) do begin
      if (TCurrencyRate(AInlist.Items[xCount]).bindingDate = ABindingDate) and ((TCurrencyRate(AInlist.Items[xCount]).rateType = ArateType)) then begin
        Result := TCurrencyRate(AInlist.Items[xCount]);
      end;
      Inc(xCount);
    end;
  end;

var xChart: TChart;
    xRates: TDataObjectList;
    xMaxDate: TDateTime;
    xCurDate: TDateTime;
    xCurValue: Currency;
    xRate: TCurrencyRate;
    xSql: String;
    xMaxQuantity: Integer;
    xCount: Integer;
    xSerie: TChartSeries;
    xTypeCondition: String;
begin
  xChart := GetChart;
  if Length(FrateTypes) = 1 then begin
    xTypeCondition := 'rateType = ''' + FrateTypes + '''';
  end else if Length(FrateTypes) = 2 then begin
    xTypeCondition := 'rateType in (' + '''' + FrateTypes[1] + ''', ''' + FrateTypes[2] + ''')';
  end else begin
    xTypeCondition := 'rateType in (' + '''' + FrateTypes[1] + ''', ''' + FrateTypes[2]  + ''', ''' +  FrateTypes[3] + ''')';
  end;
  xSql := Format('select * from currencyRate where bindingDate between %s and %s and idSourceCurrencyDef = %s and idTargetCurrencyDef = %s and idCashpoint = %s and %s order by bindingDate',
                 [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                  DataGidToDatabase(FSourceId), DataGidToDatabase(FTargetId), DataGidToDatabase(FCashpointId),
                  xTypeCondition]);
  xRates := TDataObject.GetList(TCurrencyRate, CurrencyRateProxy, xSql);
  xMaxQuantity := 1;
  xMaxDate := FStartDate;
  for xCount := 0 to xRates.Count - 1 do begin
    if xMaxQuantity < TCurrencyRate(xRates.Items[xCount]).quantity then begin
      xMaxQuantity := TCurrencyRate(xRates.Items[xCount]).quantity;
    end;
    if xMaxDate < TCurrencyRate(xRates.Items[xCount]).bindingDate then begin
      xMaxDate := TCurrencyRate(xRates.Items[xCount]).bindingDate;
    end;
  end;
  for xCount := 1 to Length(FrateTypes) do begin
    xCurDate := FStartDate;
    xCurValue := -1;
    xSerie := TLineSeries.Create(xChart);
    TLineSeries(xSerie).Pointer.Visible := True;
    TLineSeries(xSerie).Pointer.InflateMargins := True;
    with xSerie do begin
      if FrateTypes[xCount] = CCurrencyRateTypeAverage then begin
        Title := CCurrencyRateTypeAverageDesc;
      end else if FrateTypes[xCount] = CCurrencyRateTypeSell then begin
        Title := CCurrencyRateTypeSellDesc;
      end else if FrateTypes[xCount] = CCurrencyRateTypeBuy then begin
        Title := CCurrencyRateTypeBuyDesc;
      end;
      HorizAxis := aBottomAxis;
      XValues.DateTime := True;
    end;
    while xCurDate <= FEndDate do begin
      xRate := FindCurrencyRate(xRates, xCurDate, FrateTypes[xCount]);
      if xRate <> Nil then begin
        xCurValue := xMaxQuantity * xRate.rate / xRate.quantity;
      end;
      if (xCurValue <> -1) and (xCurDate <= xMaxDate) then begin
        xSerie.AddXY(xCurDate, xCurValue, '');
      end else begin
        xSerie.AddNullXY(xCurDate, 0, '');
      end;
      xCurDate := IncDay(xCurDate);
    end;
    xChart.AddSeries(xSerie);
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
    Title.Caption := '[Data waønoúci]';
  end;
  with xChart.LeftAxis do begin
    MinorTickCount := 0;
    Title.Caption := '[' + IfThen(xMaxQuantity = 1, '', IntToStr(xMaxQuantity) + ' ') + FAxisName + ']';
    Title.Angle := 90;
  end;
  xRates.Free;
end;

function TCurrencyRatesHistoryReport.PrepareReportConditions: Boolean;
begin
  if Params <> Nil then begin
    FSourceId := TCWithGidParams(Params).id;
  end;
  Result := ChoosePeriodRatesHistory(FStartDate, FEndDate, FSourceId, FTargetId, FCashpointId, FrateTypes);
end;

constructor TCWithGidParams.Create(AId: TDataGid);
begin
  inherited Create;
  FId := AId;
end;

constructor TCPluginReportParams.Create(APlugin: TCPlugin);
begin
  inherited Create;
  Fplugin := APlugin;
end;

function TPluginHtmlReport.PrepareReportConditions: Boolean;
begin
  FBody := TCPluginReportParams(Params).plugin.Execute;
  Result := not VarIsEmpty(FBody);
  if Result then begin
    FreportText.Text := FBody;
  end;
end;

procedure TPluginHtmlReport.PrepareReportData;
begin
  TCHtmlReportForm(FForm).CBrowser.LoadFromString(FreportText.Text);
end;

procedure TCChartReport.SetChartProps;
var xPref: TChartPref;
    xChart: TChart;
begin
  xChart := GetChart;
  with xChart do begin
    xPref := TChartPref(GChartPreferences.ByPrefname[GetPrefname]);
    if xPref <> Nil then begin
      Chart3DPercent := xPref.depth;
      View3DOptions.Zoom := xPref.zoom;
      View3DOptions.Tilt := xPref.tilt;
      View3DOptions.Rotation := xPref.rotate;
      View3DOptions.Elevation := xPref.elevation;
      View3DOptions.Perspective := xPref.perspective;
      Legend.Visible := (xPref.legend <> 4);
      if Legend.Visible then begin
        Legend.Alignment := TLegendAlignment(xPref.legend);
      end;
      View3D := (xPref.view <> 0);
      View3DOptions.Orthogonal := (xPref.view = 1);
      marks := xPref.values;
      Legend.LegendStyle := lsSeries;
      Legend.ShadowSize := 0;
    end else begin
      Legend.LegendStyle := lsSeries;
      Legend.Visible := False;
      Legend.Alignment := laBottom;
      Legend.ShadowSize := 0;
      View3DOptions.Orthogonal := not FisPie;
      View3D := FisPie;
    end;
  end;
end;

function TPluginChartReport.GetPrefname: String;
begin
  Result := TCPluginReportParams(Params).plugin.fileName;
end;

procedure TCChartReport.Setmarks(const Value: Integer);
var xCount: Integer;
begin
  for xCount := 0 to GetChart.SeriesCount - 1 do begin
    GetChart.Series[xCount].Marks.Visible := Value <> 0;
    if Value = 1 then begin
      GetChart.Series[xCount].Marks.Style := smsValue;
    end else if Value = 2 then begin
      GetChart.Series[xCount].Marks.Style := smsLabel;
    end;
  end;
end;

function TPluginChartReport.GetReportFooter: String;
begin
  Result := GetXmlAttribute('footer', FXml.documentElement, '');
end;

function TPluginChartReport.GetReportTitle: String;
begin
  Result := GetXmlAttribute('title', FXml.documentElement, '');
end;

procedure TPluginChartReport.PrepareReportChart;
var xSeries, xItems: IXMLDOMNodeList;
    xCountS, xCountI: Integer;
    xSerieNode, xItemNode: IXMLDOMNode;
    xSerieObject: TChartSeries;
    xSerieType: Integer;
    xX, xY: Double;
    xLabel: String;
begin
  xSeries := FXml.documentElement.selectNodes('serie');
  for xCountS := 0 to xSeries.length - 1 do begin
    xSerieNode := xSeries.item[xCountS];
    xSerieType := StrToIntDef(GetXmlAttribute('type', xSerieNode, ''), 0);
    if xSerieType = CSERIESTYPE_PIE then begin
      xSerieObject := TPieSeries.Create(GetChart);
    end else if xSerieType = CSERIESTYPE_LINE then begin
      xSerieObject := TLineSeries.Create(GetChart);
    end else if xSerieType = CSERIESTYPE_BAR then begin
      xSerieObject := TBarSeries.Create(GetChart);
    end else begin
      xSerieObject := Nil;
    end;
    if xSerieObject <> Nil then begin
      xSerieObject.Title := GetXmlAttribute('title', xSerieNode, '');
      xSerieObject.HorizAxis := aBottomAxis;
      xSerieObject.XValues.DateTime := GetXmlAttribute('domain', xSerieNode, CSERIESDOMAIN_DATETIME);
      xItems := xSerieNode.selectNodes('item');
      for xCountI := 0 to xItems.length - 1 do begin
        xItemNode := xItems.item[xCountI];
        xLabel := GetXmlAttribute('label', xItemNode, '');
        if xSerieObject.XValues.DateTime then begin
          xX := DmyToDate(GetXmlAttribute('domain', xItemNode, ''), 0);
        end else begin
          xX := StrToCurrencyDecimalDot(GetXmlAttribute('domain', xItemNode, ''));
        end;
        xY := StrToCurrencyDecimalDot(GetXmlAttribute('value', xItemNode, ''));
        xSerieObject.AddXY(xX, xY, xLabel);
      end;
      if xSerieObject.ValuesLists.Count > 0 then begin
        GetChart.AddSeries(xSerieObject);
      end;
    end;
  end;
  with GetChart do begin
    LeftAxis.Title.Caption := GetXmlAttribute('axisy', FXml.documentElement, '');
    if GetXmlAttribute('angley', FXml.documentElement, '') <> '' then begin
      LeftAxis.Title.Angle := StrToIntDef(GetXmlAttribute('angley', FXml.documentElement, ''), 0);
    end;
    BottomAxis.Title.Caption := GetXmlAttribute('axisx', FXml.documentElement, '');
    if GetXmlAttribute('anglex', FXml.documentElement, '') <> '' then begin
      BottomAxis.Title.Angle := StrToIntDef(GetXmlAttribute('anglex', FXml.documentElement, ''), 0);
    end;
  end;
end;

function TPluginChartReport.PrepareReportConditions: Boolean;
var xOut: OleVariant;
begin
  xOut := TCPluginReportParams(Params).plugin.Execute;
  Result := False;
  if not VarIsEmpty(xOut) then begin
    FXml := GetDocumentFromString(xOut);
    Result := FXml.parseError.errorCode = 0;
    if not Result then begin
      ShowInfo(itError, 'Nie uda≥o siÍ wygenerowaÊ wykresu', FXml.parseError.reason);
    end;
  end;
end;

end.


