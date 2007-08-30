unit CReports;

interface

uses Classes, CReportFormUnit, Graphics, Controls, Chart, Series, Contnrs, Windows,
     GraphUtil, CDatabase, Db, VirtualTrees, SysUtils, CLoans, CPlugins, MsXml,
     CComponents, CChartReportFormUnit, CTemplates, ShDocVW, CTools, CDataObjects;

type
  TReportDialogParamsDefs = class;

  TReportDialgoParamDef = class(TCDataListElementObject)
  private
    Fname: String;
    Fdesc: String;
    Fgroup: String;
    FparamType: string;
    FparentParamsDefs: TReportDialogParamsDefs;
    FparamValues: TVariantDynArray;
    FisRequired: Boolean;
    FframeType: Integer;
    procedure SetparamValues(const Value: TVariantDynArray);
    function GetParamValuesLength: Integer;
  public
    constructor Create(AParentParamsDefs: TReportDialogParamsDefs);
    procedure LoadFromXml(ANode: IXMLDOMNode);
    procedure SaveToXml(ANode: IXMLDOMNode);
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementId: String; override;
    function GetElementType: String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    property paramValues: TVariantDynArray read FparamValues write SetparamValues;
    property paramValuesLength: Integer read GetParamValuesLength;
  published
    property name: String read Fname write Fname;
    property desc: String read Fdesc write Fdesc;
    property group: String read Fgroup write Fgroup;
    property paramType: String read FparamType write FparamType;
    property parentParamsDefs: TReportDialogParamsDefs read FparentParamsDefs;
    property isRequired: Boolean read FisRequired write FisRequired;
    property frameType: Integer read FframeType write FframeType;
  end;

  TReportDialogParamsDefs = class(TObjectList)
  private
    FasString: String;
    Fgroups: TStringList;
    function GetAsString: String;
    procedure SetAsString(const Value: String);
    function GetItems(AIndex: Integer): TReportDialgoParamDef;
    procedure SetItems(AIndex: Integer; const Value: TReportDialgoParamDef);
    function GetByName(AName: String): TReportDialgoParamDef;
  public
    constructor Create;
    function ShowParamsDefsList(AChoice: Boolean): String;
    function AddParam(AParam: TReportDialgoParamDef): Integer;
    procedure RemoveParam(AParam: TReportDialgoParamDef);
    property Items[AIndex: Integer]: TReportDialgoParamDef read GetItems write SetItems;
    property ByName[AName: String]: TReportDialgoParamDef read GetByName;
    destructor Destroy; override;
    function RebuildStringWithParams(var AString: String): Boolean;
  published
    property AsString: String read GetAsString write SetAsString;
    property groups: TStringList read Fgroups;
  end;

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
    FidCurrencyDef: TDataGid;
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
    constructor Create(AStartDate, AEndDate: TDateTime; AIdCurrency: TDataGid);
    procedure FromDataset(ADataset: TDataSet; ASumName: String = 'fieldsum'; ADateName: String = 'fielddate'; ACurrencyName: String = 'idMovementCurrencyDef');
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
  TCReportParams = class(TObject)
  private
    Facp: String;
  public
    constructor CreateAco(AAcp: String);
  published
    property acp: String read Facp write Facp;
  end;

  TCSelectedMovementTypeParams = class(TCReportParams)
  private
    FmovementType: String;
  public
    constructor Create(AType: String);
    constructor CreateAcpType(AAcp: String; AType: String);
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

  TCBaseReport = class(TObject, IDescTemplateExpander)
  private
    FForm: TCReportForm;
    FParams: TCReportParams;
    FIdFilter: TDataGid;
    FAcps: TStringList;
  protected
    CurrencyView: Char;
    function PrepareReportConditions: Boolean; virtual;
    function GetFormClass: TCReportFormClass; virtual; abstract;
    procedure PrepareReportData; virtual; abstract;
    function CanShowReport: Boolean; virtual;
  public
    function GetReportTitle: String; virtual; abstract;
    function GetReportFooter: String; virtual; abstract;
    function GetFormTitle: String; virtual;
    constructor CreateReport(AParams: TCReportParams); virtual;
    procedure ShowReport;
    destructor Destroy; override;
    property Params: TCReportParams read FParams;
    property IdFilter: TDataGid read FIdFilter write FIdFilter;
    function ExpandTemplate(ATemplate: String): String;
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  TCHtmlReport = class(TCBaseReport)
  private
    FreportText: TStringList;
    FreportStyle: TStringList;
  protected
    procedure PrepareReportPath; virtual;
    procedure PrepareReportContent; virtual;
    procedure PrepareReportData; override;
    function GetReportBody: String; virtual; abstract;
  public
    function GetReportFooter: String; override;
    function GetFormClass: TCReportFormClass; override;
    constructor CreateReport(AParams: TCReportParams); override;
    function PrepareContent: String;
    destructor Destroy; override;
    property reportText: TStringList read FreportText;
  end;

  TCChartReport = class(TCBaseReport)
  private
    procedure Setmarks(const Value: Integer);
    procedure UpdateChartsThumbnails;
  protected
    function GetFormClass: TCReportFormClass; override;
    procedure PrepareReportChart; virtual; abstract;
    procedure PrepareReportData; override;
    function GetChart(ASymbol: String = ''): TCChart;
    function CanShowReport: Boolean; override;
  public
    procedure SetChartProps; virtual;
    function GetReportFooter: String; override;
    function GetPrefname: String; virtual;
    property marks: Integer write Setmarks;
  end;

  TAccountBalanceOnDayReport = class(TCHtmlReport)
  private
    FDate: TDateTime;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TDoneOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TTodayOperationsListReport = class(TDoneOperationsListReport)
  protected
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TOperationsBySomethingChart = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetCurrencyField: String;
    function GetCashField: String;
    function GetSql: String; virtual; abstract;
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportChart; override;
  end;

  TSumBySomethingChart = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FGroupBy: String;
    FAcp: String;
  protected
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportChart; override;
  public
    function GetReportTitle: String; override;
  end;

  TSumBySomethingList = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FGroupBy: String;
    FAcp: String;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TOperationsBySomethingList = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetCurrencyField: String;
    function GetCashField: String;
    function GetSql: String; virtual; abstract;
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  end;

  TOperationsByCategoryChart = class(TOperationsBySomethingChart)
  protected
    function GetSql: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TOperationsByCashpointChart = class(TOperationsBySomethingChart)
  protected
    function GetSql: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TOperationsByCategoryList = class(TOperationsBySomethingList)
  protected
    function GetSql: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TOperationsByCashpointList = class(TOperationsBySomethingList)
  protected
    function GetSql: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TPlannedOperationsListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TCashFlowListReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TAccountHistoryReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIdAccount: TDataGid;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TCPHistoryReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIdCp: TDataGid;
    FIdUnitDef: TDataGid;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TAccountBalanceChartReport = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FIds: TStringList;
  protected
    procedure PrepareReportChart; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
    constructor CreateReport(AParams: TCReportParams); override;
    destructor Destroy; override;
  end;

  TCashSumReportList = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FGroupBy: String;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TQuantitySumReportList = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FGroupBy: String;
  protected
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
  end;

  TCashSumReportChart = class(TCChartReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FGroupBy: String;
  protected
    function PrepareReportConditions: Boolean; override;
    procedure PrepareReportChart; override;
  public
    function GetReportTitle: String; override;
  end;

  TAveragesReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TPeriodSumsReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TFuturesReport = class(TCHtmlReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    FStartFuture: TDateTime;
    FEndFuture: TDateTime;
  protected
    function PrepareReportConditions: Boolean; override;
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TVirtualStringReport = class(TCHtmlReport)
  private
    FWidth: Integer;
    function GetColumnPercentage(AColumn: TVirtualTreeColumn): Integer;
  protected
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
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
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
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
    function PrepareReportConditions: Boolean; override;
  public
    function GetReportTitle: String; override;
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
    procedure PrepareReportChart; override;
    function CanShowReport: Boolean; override;
  public
    function GetReportFooter: String; override;
    function GetReportTitle: String; override;
    function GetPrefname: String; override;
  end;

  TAccountExtractionReport = class(TCHtmlReport)
  protected
    function GetReportBody: String; override;
  public
    function GetReportTitle: String; override;
  end;

  TSimpleReportParams = class(TCReportParams)
  private
    FFormTitle: String;
    FReportText: String;
  public
    property formTitle: String read FFormTitle write FFormTitle;
    property reportText: String read FReportText write FReportText;
  end;

  TSimpleReportDialog = class(TCHtmlReport)
  protected
    procedure PrepareReportContent; override;
    function GetReportBody: String; override;
  public
    function GetFormTitle: String; override;
    function GetReportFooter: String; override;
    function GetReportTitle: String; override;
  end;

  TPrivateReport = class(TCHtmlReport)
  private
    FErrorText: String;
    FAddText: String;
    FxsltDoc: IXMLDOMDocument;
    FreportDef: TReportDef;
    Fparams: TReportDialogParamsDefs;
  protected
    function PrepareReportConditions: Boolean; override;
    function CanShowReport: Boolean; override;
    procedure PrepareReportContent; override;
  end;

procedure ShowSimpleReport(AFormTitle, AReportText: string);
procedure ShowXsltReport(AFormTitle: string; AXmlText: String; AXsltText: String);

implementation

uses Forms, Adodb, CConfigFormUnit, Math,
     CChooseDateFormUnit, CChoosePeriodFormUnit, CConsts,
     DateUtils, CSchedules, CChoosePeriodAcpFormUnit, CHtmlReportFormUnit,
     TeeProcs, TeCanvas, TeEngine,
     CChoosePeriodAcpListFormUnit, CChoosePeriodAcpListGroupFormUnit,
     CChooseDateAccountListFormUnit, CChoosePeriodFilterFormUnit, CDatatools,
     CChooseFutureFilterFormUnit, CChoosePeriodRatesHistoryFormUnit,
     StrUtils, Variants, CPreferences, CXml, CInfoFormUnit, CPluginConsts,
     CChoosePeriodFilterGroupFormUnit, CAdotools, CBase64,
  CParamsDefsFrameUnit, CFrameFormUnit, CChooseByParamsDefsFormUnit;

var LDefaultXsl: IXMLDOMDocument;

function GetDefaultXsl: IXMLDOMDocument;
var xLibHandle: THandle;
    xResInfo: HRSRC;
    xResStream: TResourceStream;
    xStrStream: TStringStream;
begin
  if LDefaultXsl = Nil then begin
    Result := Nil;
    xLibHandle := LoadLibrary(CMSXmlLibraryName);
    if xLibHandle > HINSTANCE_ERROR then begin
      try
        xResinfo := FindResource(xLibHandle, CXSLDefaultTransformResname, CXSLDefaultTransforRestype);
        if xResInfo <> 0 then begin
          try
            xResStream := TResourceStream.Create(xLibHandle, CXSLDefaultTransformResname, CXSLDefaultTransforRestype);
            xStrStream := TStringStream.Create('');
            xResStream.SaveToStream(xStrStream);
            xResStream.Free;
            LDefaultXsl := GetDocumentFromString(xStrStream.DataString);
            xStrStream.Free;
            if LDefaultXsl.parseError.errorCode <> 0 then begin
              LDefaultXsl := Nil;
            end else begin
              Result := LDefaultXsl;
            end;
          except
          end;
        end;
      finally
        FreeLibrary(xLibHandle);
      end;
    end;
  end else begin
    Result := LDefaultXsl;
  end;
end;

function GetDescription(AGroupType: String; ADate: TDateTime): String;
begin
  Result := GetFormattedDate(ADate, CBaseDateFormat);
  if AGroupType = CGroupByDay then begin
    Result := GetFormattedDate(ADate, CBaseDateFormat);
  end else if AGroupType = CGroupByWeek then begin
    Result := GetFormattedDate(ADate, CBaseDateFormat) + ' - ' + GetFormattedDate(EndOfTheWeek(ADate), CBaseDateFormat);
  end else if AGroupType = CGroupByMonth then begin
    Result := GetFormattedDate(ADate, CMonthnameDateFormat);
  end;
end;

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

function IsValidGid(AId: TDataGid; AIds: TStringList): Boolean;
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
      if IsValidGid(FieldByName('idAccount').AsString, FAcps) then begin
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
        xSums.AddSum(FieldByName('idCurrencyDef').AsString, FieldByName('cash').AsCurrency - xDelta, CEmptyDataGid);
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
  Result := 'Stan kont (' + GetFormattedDate(FDate, CLongDateFormat);
end;

function TAccountBalanceOnDayReport.PrepareReportConditions: Boolean;
begin
  Result := ChooseDateAccountListByForm(FDate, FAcps);
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
    xFieldI, xFieldO, xFieldC: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldI := 'movementIncome';
    xFieldO := 'movementExpense';
    xFieldC := 'idMovementCurrencyDef';
  end else begin
    xFieldI := 'income';
    xFieldO := 'expense';
    xFieldC := 'idAccountCurrencyDef';
  end;
  xOperations := GDataProvider.OpenSql(
            Format('select b.*, a.name from balances b' +
                   ' left outer join account a on a.idAccount = b.idAccount ' +
                   '  where movementType <> ''%s'' and b.regDate between %s and %s order by b.regDate, b.created',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  if FIdFilter <> CEmptyDataGid then begin
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, FIdFilter, False));
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
        xCash := FieldByName(xFieldI).AsCurrency;
        if xCash > 0 then begin
          xIn := CurrencyToString(xCash, '', False);
          xInSum.AddSum(FieldByName(xFieldC).AsString, xCash, CEmptyDataGid);
        end else begin
          xIn := '';
        end;
        xCash := FieldByName(xFieldO).AsCurrency;
        if xCash > 0 then begin
          xOut := CurrencyToString(xCash, '', False);
          xOutSum.AddSum(FieldByName(xFieldC).AsString, xCash, CEmptyDataGid);
        end else begin
          xOut := '';
        end;
        Add('<td class="text" width="5%">' + IntToStr(xRec) + '</td>');
        Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
        Add('<td class="text" width="30%">' + ReplaceLinebreaksBR(FieldByName('description').AsString) + '</td>');
        Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
        Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName(xFieldC).AsString) + '</td>');
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
          xIC := xInSum.GetSum(xIdCur, CEmptyDataGid);
          xOC := xOutSum.GetSum(xIdCur, CEmptyDataGid);
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
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FIdFilter, @CurrencyView, True);
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
  if FIdFilter <> CEmptyDataGid then begin
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, FIdFilter, False));
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
            xOverallInSum.AddSum(xIdCurrency, xElement.done.cash, CEmptyDataGid);
            xRelizedInSum.AddSum(xIdCurrency, xElement.done.cash, CEmptyDataGid);
          end else begin
            xOut := CurrencyToString(xElement.done.cash, '', False);
            xIn := '';
            xOverallOutSum.AddSum(xIdCurrency, xElement.done.cash, CEmptyDataGid);
            xRealizedOutSum.AddSum(xIdCurrency, xElement.done.cash, CEmptyDataGid);
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
            xOverallInSum.AddSum(xIdCurrency, xElement.planned.cash, CEmptyDataGid);
            xNotrealInSum.AddSum(xIdCurrency, xElement.planned.cash, CEmptyDataGid);
          end else begin
            xOut := CurrencyToString(xElement.planned.cash, '', False);
            xIn := '';
            xOverallOutSum.AddSum(xIdCurrency, xElement.planned.cash, CEmptyDataGid);
            xNotrealOutSum.AddSum(xIdCurrency, xElement.planned.cash, CEmptyDataGid);
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
          xIC := xRelizedInSum.GetSum(xIdCurrency, CEmptyDataGid);
          xOC := xRealizedOutSum.GetSum(xIdCurrency, CEmptyDataGid);
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
          xIC := xNotrealInSum.GetSum(xIdCurrency, CEmptyDataGid);
          xOC := xNotrealOutSum.GetSum(xIdCurrency, CEmptyDataGid);
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
          xIC := xOverallInSum.GetSum(xIdCurrency, CEmptyDataGid);
          xOC := xOverallOutSum.GetSum(xIdCurrency, CEmptyDataGid);
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
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FIdFilter, Nil, True);
end;

function TCashFlowListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xBody: TStringList;
    xSums: TSumList;
    xCount: Integer;
    xFieldC, xFieldR: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldC := 'idMovementCurrencyDef';
    xFieldR := 'movementCash';
  end else begin
    xFieldC := 'idAccountCurrencyDef';
    xFieldR := 'cash';
  end;
  xSums := TSumList.Create(True);
  xOperations := GDataProvider.OpenSql(
             Format('select ' +
                    '  b.created, b.description, b.%s as cash, b.%s as idCurrencyDef, b.movementType, b.regDate, ' +
                    '  b.idCashpoint as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in ('''+ CInMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.%s as cash, b.%s as idCurrencyDef, b.movementType, b.regDate, ' +
                    '  a.idAccount as sourceid, a.name as sourcename, ' +
                    '  b.idCashpoint as destid, c.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in (''' + COutMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.%s as cash, b.%s as idCurrencyDef, b.movementType, b.regDate, ' +
                    '  b.idSourceAccount as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, account c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idAccount = b.idSourceAccount and b.movementType in (''' + CTransferMovement + ''') ' +
                    'order by b.regDate, b.created ',
                   [xFieldR, xFieldC, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    xFieldR, xFieldC, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    xFieldR, xFieldC, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
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
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idCurrencyDef').AsString) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(FieldByName('cash').AsCurrency, '', False) + '</td>');
      Add('</tr>');
      xSums.AddSum(FieldByName('idCurrencyDef').AsString, FieldByName('cash').AsCurrency, CEmptyDataGid);
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
  Result := ChoosePeriodByForm(FStartDate, FEndDate, @CurrencyView);
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
    Add('<td class="headcash" width="15%">W walucie konta</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    Add('<tr class="sum">');
    Add('<td class="sumtext" width="5%"></td>');
    Add('<td class="sumtext" width="15%">' + DateToStr(FStartDate) + '</td>');
    Add('<td class="sumtext" width="40%">Stan poczπtkowy</td>');
    Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xAccountCurrencyDef) + '</td>');
    Add('<td class="sumtext" width="15%"></td>');
    Add('<td class="sumcash" width="15%">' + CurrencyToString(xSum, '', False) + '</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    while not Eof do begin
      Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="40%">' + ReplaceLinebreaksBR(FieldByName('description').AsString) + '</td>');
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
    Add('<td class="sumtext" width="40%">Stan koÒcowy</td>');
    Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xAccountCurrencyDef) + '</td>');
    Add('<td class="sumtext" width="15%"></td>');
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
  Result := ChoosePeriodAcpByForm(CGroupByAccount, FStartDate, FEndDate, FIdAccount, Nil);
end;

function TCBaseReport.CanShowReport: Boolean;
begin
  Result := True;
end;

constructor TCBaseReport.CreateReport(AParams: TCReportParams);
begin
  inherited Create;
  FParams := AParams;
  FIdFilter := CEmptyDataGid;
  CurrencyView := CCurrencyViewMovements;
  FAcps := TStringList.Create;
end;

destructor TCBaseReport.Destroy;
begin
  FAcps.Free;
  inherited Destroy;
end;

function TCBaseReport.ExpandTemplate(ATemplate: String): String;
begin
  Result := GBasePreferences.ExpandTemplate(ATemplate);
end;

function TCBaseReport.GetFormTitle: String;
begin
  Result := 'Raport';
end;

function TCBaseReport.PrepareReportConditions: Boolean;
begin
  Result := True;
end;

function TCBaseReport.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  if GetInterface(IID, Obj) then begin
    Result := 0
  end else begin
    Result := E_NOINTERFACE;
  end;
end;

procedure TCBaseReport.ShowReport;
begin
  Fform := GetFormClass.CreateForm(Self);
  FIdFilter := CEmptyDataGid;
  if PrepareReportConditions then begin
    GDataProvider.BeginTransaction;
    PrepareReportData;
    GDataProvider.RollbackTransaction;
    if CanShowReport then begin
      Fform.Caption := GetFormTitle;
      Fform.ShowConfig(coNone);
    end;
  end;
  if FIdFilter <> CEmptyDataGid then begin
    TMovementFilter.DeleteIfTemporary(FIdFilter);
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
  TCHtmlReportForm(FForm).CBrowser.LoadFromString(GBaseTemlatesList.ExpandTemplates(FreportText.Text, Self));
end;

procedure TCHtmlReport.PrepareReportPath;
var xRes: TResourceStream;
begin
  if not FileExists(GetSystemPathname(CCSSReportFile)) then begin
    xRes := TResourceStream.Create(HInstance, 'REPCSS', RT_RCDATA);
    xRes.SaveToFile(GetSystemPathname(CCSSReportFile));
    xRes.Free;
  end;
  if not FileExists(GetSystemPathname('report.htm')) then begin
    xRes := TResourceStream.Create(HInstance, 'REPBASE', RT_RCDATA);
    xRes.SaveToFile(GetSystemPathname('report.htm'));
    xRes.Free;
  end;
  FreportText.LoadFromFile(GetSystemPathname('report.htm'));
  FreportStyle.LoadFromFile(GetSystemPathname(CCSSReportFile));
end;

function TCChartReport.CanShowReport: Boolean;
begin
  Result := inherited CanShowReport;
  TCChartReportForm(FForm).PanelNoData.Visible := TCChartReportForm(FForm).charts.Count = 0;
end;

function TCChartReport.GetChart(ASymbol: String = ''): TCChart;
begin
  Result := TCChartReportForm(FForm).GetChart(ASymbol, True);
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
begin
  PrepareReportChart;
  UpdateChartsThumbnails;
  if TCChartReportForm(FForm).charts.Count > 0 then begin
    TCChartReportForm(FForm).ActiveChartIndex := 0;
    SetChartProps;
  end;
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
    if IsValidGid(xAccount.id, FIds) then begin
      xBalance := xAccount.cash;
      xSerie := TLineSeries.Create(xChart);
      TLineSeries(xSerie).Pointer.Visible := True;
      TLineSeries(xSerie).Pointer.InflateMargins := True;
      with xSerie do begin
        Title := xAccount.name + ' [' + GCurrencyCache.GetIso(xAccount.idCurrencyDef) + ']';
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
    Title.Caption := '[dostÍpne úrodki]';
    Title.Angle := 90;
  end;
  xAccounts.Free;
end;

function TAccountBalanceChartReport.PrepareReportConditions: Boolean;
begin
  if Params = Nil then begin
    Result := ChoosePeriodAcpListByForm(CGroupByAccount, FStartDate, FEndDate, FIds, Nil);
  end else begin
    Result := ChoosePeriodByForm(FStartDate, FEndDate, Nil);
    FIds.Add(TCWithGidParams(Params).id);
  end;
end;

function TOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xSums: TSumList;
    xBody: TStringList;
    xCash: Currency;
    xCount: Integer;
    xFieldC, xFieldR: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldC := 'idMovementCurrencyDef';
    xFieldR := 'movementCash';
  end else begin
    xFieldC := 'idAccountCurrencyDef';
    xFieldR := 'cash';
  end;
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
      Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
      xCash := Abs(FieldByName(xFieldR).AsCurrency);
      xSums.AddSum(FieldByName(xFieldC).AsString, xCash, CEmptyDataGid);
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="40%">' + ReplaceLinebreaksBR(FieldByName('description').AsString) + '</td>');
      Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName(xFieldC).AsString) + '</td>');
      Add('<td class="cash" width="10%">' + CurrencyToString(xCash, '', False) + '</td>');
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
  Result := ChoosePeriodByForm(FStartDate, FEndDate, @CurrencyView);
end;

function TOperationsBySomethingChart.GetCashField: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    Result := 'movementCash';
  end else begin
    Result := 'cash';
  end;
end;

function TOperationsBySomethingChart.GetCurrencyField: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    Result := 'idMovementCurrencyDef';
  end else begin
    Result := 'idAccountCurrencyDef';
  end;
end;

procedure TOperationsBySomethingChart.PrepareReportChart;
var xSums: TADOQuery;
    xSerie: TPieSeries;
    xChart: TCChart;
    xCash: Currency;
    xLabel: String;
    xSum: Currency;
    xPercent: Double;
    xCurDefs: TDataGids;
    xCount: Integer;
begin
  xSums := GDataProvider.OpenSql(GetSql);
  xCurDefs := GetDefsFromDataset(xSums, 'idCurrencyDef');
  for xCount := 0 to xCurDefs.Count - 1 do begin
    xChart := GetChart(xCurDefs.Strings[xCount]);
    xChart.thumbTitle := '[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCount]) + ']';
    xSerie := TPieSeries.Create(xChart);
    xSerie.Title := 'Wszystkie dane';
    xSum := 0;
    xSums.Filter := 'idCurrencyDef = ' + DataGidToDatabase(xCurDefs.Strings[xCount]);
    xSums.Filtered := True;
    xSums.First;
    while not xSums.Eof do begin
      xSum := xSum + Abs(xSums.FieldByName('cash').AsCurrency);
      xSums.Next;
    end;
    xSums.First;
    while not xSums.Eof do begin
      xCash := Abs(xSums.FieldByName('cash').AsCurrency);
      xPercent := (xCash * 100) / xSum;
      xLabel := Format('%3.2f', [xPercent]) + '% - ' + xSums.FieldByName('name').AsString + ' (' + CurrencyToString(xCash, xCurDefs.Strings[xCount], True) + ')';
      xSerie.Add(xCash, xLabel, clTeeColor);
      xSums.Next;
    end;
    xSerie.Marks.Style := smsLabel;
    with xChart do begin
      AddSeries(xSerie);
    end;
  end;
  xCurDefs.Free;
  xSums.Free;
end;

function TOperationsBySomethingChart.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate, @CurrencyView);
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
  Result := Format('select v.%s as idCurrencyDef, v.cash, p.name from ( ' +
                '  select sum(%s) as cash, idProduct, %s from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by %s, idProduct) as v ' +
                '  left outer join product p on p.idProduct = v.idProduct',
                [GetCurrencyField, GetCashField, GetCurrencyField,
                 TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                 GetCurrencyField]);
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
  Result := Format('select v.%s as idCurrencyDef, v.cash, p.name from ( ' +
                '  select sum(%s) as cash, idCashpoint, %s from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by %s, idCashpoint) as v ' +
                '  left outer join cashpoint p on p.idCashpoint = v.idCashpoint',
                [GetCurrencyField, GetCashField, GetCurrencyField,
                 TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                 GetCurrencyField]);
end;

function TOperationsBySomethingList.GetCashField: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    Result := 'movementCash';
  end else begin
    Result := 'cash';
  end;
end;

function TOperationsBySomethingList.GetCurrencyField: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    Result := 'idMovementCurrencyDef';
  end else begin
    Result := 'idAccountCurrencyDef';
  end;
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
  xCurrs := GetDefsFromDataset(xSums, 'idCurrencyDef');
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
    xSums.Filter := 'idCurrencyDef = ' + DataGidToDatabase(xCurrs.Strings[xCount]);
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
        Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
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
  Result := ChoosePeriodByForm(FStartDate, FEndDate, @CurrencyView);
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
  Result := Format('select v.cash, p.name, v.idCurrencyDef from ( ' +
                '  select sum(%s) as cash, idProduct, %s as idCurrencyDef from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by idProduct, %s) as v ' +
                '  left outer join product p on p.idProduct = v.idProduct',
                [GetCashField, GetCurrencyField,
                 TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                 GetCurrencyField]);
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
  Result := Format('select v.cash, p.name, v.idCurrencyDef from ( ' +
                '  select sum(%s) as cash, idCashpoint, %s as idCurrencyDef from transactions ' +
                '  where movementType = ''%s'' and regDate between %s and %s group by idCashpoint, %s) as v ' +
                '  left outer join cashpoint p on p.idCashpoint = v.idCashpoint',
                [GetCashField, GetCurrencyField,
                 TCSelectedMovementTypeParams(FParams).movementType, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                 GetCurrencyField]);
end;

constructor TCSelectedMovementTypeParams.Create(AType: String);
begin
  inherited Create;
  FmovementType := AType;
end;

function TCashSumReportList.GetReportBody: String;
var xOperations: TADOQuery;
    xGb: String;
    xGbSum, xSums: TSumList;
    xBody: TStringList;
    xName: String;
    xCurDate: TDateTime;
    xRec, xCount: Integer;
    xFieldC, xFieldR, xFilter: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldC := 'idMovementCurrencyDef';
    xFieldR := 'movementCash';
  end else begin
    xFieldC := 'idAccountCurrencyDef';
    xFieldR := 'cash';
  end;
  xGb := 'regDate';
  xName := 'DzieÒ';
  if FGroupBy = CGroupByWeek then begin
    xGb := 'weekDate';
    xName := 'TydzieÒ';
  end else if FGroupBy = CGroupByMonth then begin
    xGb := 'monthDate';
    xName := 'Miesiπc';
  end;
  xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'transactions.idAccount', 'transactions.idCashpoint', 'transactions.idProduct');
  xOperations := GDataProvider.OpenSql(Format('select sum(%s) as cash, %s, idAccount, %s as idCurrencyDef from transactions where movementType = ''%s'' and regDate between %s and %s %s group by %s, %s, idAccount order by %s',
                             [xFieldR, xGb, xFieldC,
                              TCSelectedMovementTypeParams(FParams).movementType,
                              DatetimeToDatabase(FStartDate, False),
                              DatetimeToDatabase(FEndDate, False), xFilter,
                              xFieldC, xGb, xGb]));
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
        if IsValidGid(FieldByName('idAccount').AsString, FAcps) then begin
          xGbSum.AddSum(FieldByName('idCurrencyDef').AsString, Abs(FieldByName('cash').AsCurrency), CEmptyDataGid);
        end;
        Next;
      end;
      if xGbSum.Count > 0 then begin
        for xCount := 0 to xGbSum.Count - 1 do begin
          Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
          Add('<td class="text" width="70%">' + IfThen(xCount = 0, GetDescription(FGroupBy, xCurDate), '') + '</td>');
          Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(xGbSum.Items[xCount].name) + '</td>');
          Add('<td class="cash" width="20%">' + CurrencyToString(xGbSum.Items[xCount].value, '', False) + '</td>');
          Add('</tr>');
          Inc(xRec);
          xSums.AddSum(xGbSum.Items[xCount].name, xGbSum.Items[xCount].value, CEmptyDataGid);
        end;
      end else begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="70%">' + GetDescription(FGroupBy, xCurDate) + '</td>');
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

function TCashSumReportList.GetReportTitle: String;
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

function TCashSumReportList.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAcpListGroupByForm(FParams.acp, FStartDate, FEndDate, FAcps, FIdFilter, FGroupBy, @CurrencyView);
end;

function TCashSumReportChart.GetReportTitle: String;
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

procedure TCashSumReportChart.PrepareReportChart;
var xInOperations, xOutOperations: TADOQuery;
    xGb: String;
    xGbSum: Currency;
    xName: String;
    xCurDate: TDateTime;
    xInSerie, xOutSerie: TBarSeries;
    xInMovements: Boolean;
    xOutMovements: Boolean;
    xInCurDefs, xOutCurDefs, xOverallCurDefs: TDataGids;
    xCount: Integer;
    xChart: TCChart;
    xFieldR, xFieldC: String;
    xFilter: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldR := 'movementCash';
    xFieldC := 'idMovementCurrencyDef';
  end else begin
    xFieldR := 'cash';
    xFieldC := 'idAccountCurrencyDef';
  end;
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
  xOverallCurDefs := TDataGids.Create;
  xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'transactions.idAccount', 'transactions.idCashpoint', 'transactions.idProduct');
  if xInMovements then begin
    xInOperations := GDataProvider.OpenSql(Format('select %s as idCurrencyDef, sum(%s) as cash, %s, idAccount from transactions where movementType = ''%s'' and regDate between %s and %s %s group by %s, idAccount, %s order by %s',
                               [xFieldC, xFieldR, xGb, CInMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), xFilter, xGb, xFieldC, xGb]));
    xInCurDefs := GetDefsFromDataset(xInOperations, 'idCurrencyDef');
    xOverallCurDefs.MergeWithDataGids(xInCurDefs);
    xInCurDefs.Free;
  end else begin
    xInOperations := Nil;
  end;
  if xOutMovements then begin
    xOutOperations := GDataProvider.OpenSql(Format('select %s as idCurrencyDef, sum(%s) as cash, %s, idAccount from transactions where movementType = ''%s'' and regDate between %s and %s %s group by %s, idAccount, %s order by %s',
                               [xFieldC, xFieldR, xGb, COutMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), xFilter, xGb, xFieldC, xGb]));
    xOutCurDefs := GetDefsFromDataset(xOutOperations, 'idCurrencyDef');
    xOverallCurDefs.MergeWithDataGids(xOutCurDefs);
    xOutCurDefs.Free;
  end else begin
    xOutOperations := Nil;
  end;
  for xCount := 0 to xOverallCurDefs.Count - 1 do begin
    xChart := GetChart(xOverallCurDefs.Strings[xCount]);
    xChart.thumbTitle := '[' + GCurrencyCache.GetIso(xOverallCurDefs.Strings[xCount]) + ']';
    if xInMovements then begin
      if FGroupBy = CGroupByWeek then begin
        xCurDate := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := StartOfTheMonth(FStartDate);
      end else begin
        xCurDate := FStartDate;
      end;
      xInSerie := TBarSeries.Create(xChart);
      with TBarSeries(xInSerie) do begin
        Title := xName;
        Marks.ArrowLength := 0;
        Marks.Style := smsValue;
        HorizAxis := aBottomAxis;
        XValues.DateTime := True;
      end;
      while (xCurDate <= FEndDate) do begin
        xInOperations.Filter := xGb + ' = ' + DatetimeToDatabase(xCurDate, False) +
                                      ' and idCurrencyDef = ' + DataGidToDatabase(xOverallCurDefs.Strings[xCount]);
        xInOperations.Filtered := True;
        xInOperations.First;
        xGbSum := 0;
        while not xInOperations.Eof do begin
          if IsValidGid(xInOperations.FieldByName('idAccount').AsString, FAcps) then begin
            xGbSum := xGbSum + Abs(xInOperations.FieldByName('cash').AsCurrency);
          end;
          xInOperations.Next;
        end;
        xInSerie.AddXY(xCurDate, xGbSum, GetDescription(FGroupBy, xCurDate));
        if FGroupBy = CGroupByWeek then begin
          xCurDate := IncWeek(xCurDate, 1);
        end else if FGroupBy = CGroupByMonth then begin
          xCurDate := IncMonth(xCurDate, 1);
        end else begin
          xCurDate := IncDay(xCurDate, 1);
        end;
      end;
    end;
    if xOutMovements then begin
      if FGroupBy = CGroupByWeek then begin
        xCurDate := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := StartOfTheMonth(FStartDate);
      end else begin
        xCurDate := FStartDate;
      end;
      xOutSerie := TBarSeries.Create(xChart);
      with TBarSeries(xOutSerie) do begin
        Title := xName;
        Marks.ArrowLength := 0;
        Marks.Style := smsValue;
        HorizAxis := aBottomAxis;
        XValues.DateTime := True;
      end;
      while (xCurDate <= FEndDate) do begin
        xOutOperations.Filter := xGb + ' = ' + DatetimeToDatabase(xCurDate, False) +
                                       ' and idCurrencyDef = ' + DataGidToDatabase(xOverallCurDefs.Strings[xCount]);
        xOutOperations.Filtered := True;
        xOutOperations.First;
        xGbSum := 0;
        while not xOutOperations.Eof do begin
          if IsValidGid(xOutOperations.FieldByName('idAccount').AsString, FAcps) then begin
            xGbSum := xGbSum + Abs(xOutOperations.FieldByName('cash').AsCurrency);
          end;
          xOutOperations.Next;
        end;
        xOutSerie.AddXY(xCurDate, xGbSum, GetDescription(FGroupBy, xCurDate));
        if FGroupBy = CGroupByWeek then begin
          xCurDate := IncWeek(xCurDate, 1);
        end else if FGroupBy = CGroupByMonth then begin
          xCurDate := IncMonth(xCurDate, 1);
        end else begin
          xCurDate := IncDay(xCurDate, 1);
        end;
      end;
    end;
    with xChart do begin
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
        Title.Caption := '[' + GCurrencyCache.GetIso(xOverallCurDefs.Strings[xCount]) + ']';
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
  if xInMovements then begin
    xInOperations.Free;
  end;
  if xOutMovements then begin
    xOutOperations.Free;
  end;
  xOverallCurDefs.Free;
end;

function TCashSumReportChart.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAcpListGroupByForm(CGroupByAccount, FStartDate, FEndDate, FAcps, FIdFilter, FGroupBy, @CurrencyView);
end;

function TAveragesReport.GetReportBody: String;

  procedure AppendGroup(AIsMultiCurrency: Boolean; APeriodsCount: Integer; AQuery: TADOQuery; ATitle: String; AIdGroupName: String; var ARecNo: Integer; var ABody: TStringList);
  var xIdCurDef, xIdGroupBy, xOneCurrency: TDataGid;
      xTitle: String;
  begin
    with ABody do begin
      if AQuery.IsEmpty then begin
        xOneCurrency := CEmptyDataGid;
        xTitle := '';
      end else begin
        xOneCurrency := AQuery.FieldByName('idCurrencyDef').AsString;
        xTitle := IfThen(AIsMultiCurrency, '', '[' + GCurrencyCache.GetIso(xOneCurrency) + ']')
      end;
      if APeriodsCount > 0 then begin
        Add('<hr><p><hr>');
        Add('<table class="base" colspan=1>');
        Add('<tr class="head">');
        Add('<td class="headtext" width="100%">' + ATitle + '</td>');
        Add('</tr></table>');
        if not AIsMultiCurrency then begin
          if xTitle <> '' then begin
            Add('<hr>');
            Add('<table class="base" colspan=1>');
            Add('<tr class="subhead">');
            Add('<td class="subheadtext" width="100%">' + xTitle + '</td>');
            Add('</tr></table>');
          end;
          Add('<hr>');
        end;
        xIdCurDef := CEmptyDataGid;
        xIdGroupBy := CEmptyDataGid;
        AQuery.First;
        while not AQuery.Eof do begin
          if xIdGroupBy <> AQuery.FieldByName(AIdGroupName).AsString then begin
            xIdGroupBy := AQuery.FieldByName(AIdGroupName).AsString;
            xIdCurDef := CEmptyDataGid;
            if AIsMultiCurrency then begin
              Add('<hr><table class="base" colspan=1>');
              Add('<tr class="subhead">');
              Add('<td class="subheadtext" width="100%">' + AQuery.FieldByName('name').AsString + '</td>');
              Add('</tr></table><hr>');
            end else begin
              Add('<table class="base" colspan=4>');
              Add('<tr class="' + IsEvenToStr(ARecNo) + 'base">');
              Add('<td class="text" width="40%">' + AQuery.FieldByName('name').AsString + '</td>');
              Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('incomes').AsCurrency / APeriodsCount, '', False) + '</td>');
              Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('expenses').AsCurrency / APeriodsCount, '', False) + '</td>');
              Add('<td class="cash" width="20%">' + CurrencyToString((AQuery.FieldByName('incomes').AsCurrency - AQuery.FieldByName('expenses').AsCurrency) / APeriodsCount, '', False) + '</td>');
              Add('</tr></table>');
              Inc(ARecNo);
            end;
          end;
          if AIsMultiCurrency then begin
            if xIdCurDef <> AQuery.FieldByName('idCurrencyDef').AsString then begin
              xIdCurDef := AQuery.FieldByName('idCurrencyDef').AsString;
              Add('<table class="base" colspan=4>');
              Add('<tr class="' + IsEvenToStr(ARecNo) + 'base">');
              Add('<td class="text" width="40%">[' + GCurrencyCache.GetIso(xIdCurDef) + ']</td>');
              Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('incomes').AsCurrency / APeriodsCount, '', False) + '</td>');
              Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('expenses').AsCurrency / APeriodsCount, '', False) + '</td>');
              Add('<td class="cash" width="20%">' + CurrencyToString((AQuery.FieldByName('incomes').AsCurrency - AQuery.FieldByName('expenses').AsCurrency) / APeriodsCount, '', False) + '</td>');
              Add('</tr></table>');
              Inc(ARecNo);
            end;
          end;
          AQuery.Next;
        end;
        Add('</table>');
      end;
    end;
  end;

var xBody: TStringList;
    xRec: Integer;
    xSql: String;
    xDaysBetween: Integer;
    xWeeksBetween: Integer;
    xMonthsBetween: Integer;
    xQuery: TADOQuery;
    xFilter: String;
    xCurDefs: TDataGids;
    xCount: Integer;
    xIsMultiCurrency: Boolean;
    xFieldI, xFieldO, xFieldC: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldI := 'movementIncome';
    xFieldO := 'movementExpense';
    xFieldC := 'idMovementCurrencyDef';
  end else begin
    xFieldI := 'income';
    xFieldO := 'expense';
    xFieldC := 'idAccountCurrencyDef';
  end;
  xBody := TStringList.Create;
  xDaysBetween := DayCount(FEndDate, FStartDate);
  xWeeksBetween := WeekCount(FEndDate, FStartDate);
  xMonthsBetween := MonthCount(FEndDate, FStartDate);
  with xBody do begin
    xRec := 1;
    xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'balances.idAccount', 'balances.idCashpoint', 'balances.idProduct');
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses from balances where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO,
                    CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xQuery := GDataProvider.OpenSql(xSql + ' group by ' + xFieldC);
    xCurDefs := GetDefsFromDataset(xQuery, 'idCurrencyDef');
    xIsMultiCurrency := xCurDefs.Count > 1;
    Add('<table class="base" colspan=5>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="40%">årednie ogÛ≥em dla wszystkich kont</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr>');
    for xCount := 0 to xCurDefs.Count - 1 do begin
      xQuery.Filter := 'idCurrencyDef = ' + DataGidToDatabase(xCurDefs.Strings[xCount]);
      xQuery.Filtered := True;
      Add('<table class="base" colspan=1>');
      Add('<tr class="subhead">');
      Add('<td class="subheadtext" width="100%">[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCount]) + ']' + '</td>');
      Add('</tr>');
      Add('</table><hr>');
      Add('<table class="base" colspan=5>');
      if xDaysBetween > 0 then begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="40%">Dzienne</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xDaysBetween, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xDaysBetween, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xDaysBetween, '', False) + '</td>');
        Add('</tr>');
        Inc(xRec);
      end;
      if xWeeksBetween > 0 then begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="40%">Tygodniowe</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xWeeksBetween, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xWeeksBetween, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xWeeksBetween, '', False) + '</td>');
        Add('</tr>');
        Inc(xRec);
      end;
      if xMonthsBetween > 0 then begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="40%">MiesiÍcznie</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency / xMonthsBetween, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency / xMonthsBetween, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency) / xMonthsBetween, '', False) + '</td>');
        Add('</tr>');
        Inc(xRec);
      end;
      Add('</table>');
      if xCount <> xCurDefs.Count - 1 then begin
        Add('<hr>');
      end;
    end;
    xQuery.Free;
    xCurDefs.Free;
    //konta
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, balances.idAccount, account.name from balances ' +
                   ' left join account on account.idAccount = balances.idAccount ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by ' + xFieldC + ', balances.idAccount, account.name order by account.name, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    AppendGroup(xIsMultiCurrency, xDaysBetween, xQuery, 'årednie dzienne dla konta', 'idAccount', xRec, xBody);
    AppendGroup(xIsMultiCurrency, xWeeksBetween, xQuery, 'årednie tygodniowe dla konta', 'idAccount', xRec, xBody);
    AppendGroup(xIsMultiCurrency, xMonthsBetween, xQuery, 'årednie miesiÍczne dla konta', 'idAccount', xRec, xBody);
    xQuery.Free;
    //kontahenci
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, balances.idCashpoint, cashpoint.name from balances ' +
                   ' left join cashpoint on cashpoint.idCashpoint = balances.idCashpoint ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by ' + xFieldC + ', balances.idCashpoint, cashpoint.name order by cashpoint.name, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    AppendGroup(xIsMultiCurrency, xDaysBetween, xQuery, 'årednie dzienne dla kontrahenta', 'idCashpoint', xRec, xBody);
    AppendGroup(xIsMultiCurrency, xWeeksBetween, xQuery, 'årednie tygodniowe dla kontrahenta', 'idCashpoint', xRec, xBody);
    AppendGroup(xIsMultiCurrency, xMonthsBetween, xQuery, 'årednie miesiÍczne dla kontrahenta', 'idCashpoint', xRec, xBody);
    xQuery.Free;
    //kategorie
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, balances.idProduct, product.name from balances ' +
                   ' left join product on product.idProduct = balances.idProduct ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by ' + xFieldC + ', balances.idProduct, product.name order by product.name, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    AppendGroup(xIsMultiCurrency, xDaysBetween, xQuery, 'årednie dzienne dla kategorii', 'idProduct', xRec, xBody);
    AppendGroup(xIsMultiCurrency, xWeeksBetween, xQuery, 'årednie tygodniowe dla kategorii', 'idProduct', xRec, xBody);
    AppendGroup(xIsMultiCurrency, xMonthsBetween, xQuery, 'årednie miesiÍczne dla kategorii', 'idProduct', xRec, xBody);
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
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FIdFilter, @CurrencyView, True);
end;

function TPeriodSumsReport.GetReportBody: String;

  procedure AppendGroup(AIsMultiCurrency: Boolean; AQuery: TADOQuery; ATitle: String; AIdGroupName: String; var ARecNo: Integer; var ABody: TStringList);
  var xIdCurDef, xIdGroupBy, xOneCurrency: TDataGid;
      xTitle: String;
  begin
    with ABody do begin
      if AQuery.IsEmpty then begin
        xOneCurrency := CEmptyDataGid;
        xTitle := '';
      end else begin
        xOneCurrency := AQuery.FieldByName('idCurrencyDef').AsString;
        xTitle := IfThen(AIsMultiCurrency, '', '[' + GCurrencyCache.GetIso(xOneCurrency) + ']')
      end;
      Add('<hr><p><hr>');
      Add('<table class="base" colspan=1>');
      Add('<tr class="head">');
      Add('<td class="headtext" width="100%">' + ATitle + '</td>');
      Add('</tr></table>');
      if not AIsMultiCurrency then begin
        if xTitle <> '' then begin
          Add('<hr>');
          Add('<table class="base" colspan=1>');
          Add('<tr class="subhead">');
          Add('<td class="subheadtext" width="100%">' + xTitle + '</td>');
          Add('</tr></table>');
        end;
        Add('<hr>');
      end;
      xIdCurDef := CEmptyDataGid;
      xIdGroupBy := CEmptyDataGid;
      AQuery.First;
      while not AQuery.Eof do begin
        if xIdGroupBy <> AQuery.FieldByName(AIdGroupName).AsString then begin
          xIdGroupBy := AQuery.FieldByName(AIdGroupName).AsString;
          xIdCurDef := CEmptyDataGid;
          if AIsMultiCurrency then begin
            Add('<hr><table class="base" colspan=1>');
            Add('<tr class="subhead">');
            Add('<td class="subheadtext" width="100%">' + AQuery.FieldByName('name').AsString + '</td>');
            Add('</tr></table><hr>');
          end else begin
            Add('<table class="base" colspan=4>');
            Add('<tr class="' + IsEvenToStr(ARecNo) + 'base">');
            Add('<td class="text" width="40%">' + AQuery.FieldByName('name').AsString + '</td>');
            Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('incomes').AsCurrency, '', False) + '</td>');
            Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('expenses').AsCurrency, '', False) + '</td>');
            Add('<td class="cash" width="20%">' + CurrencyToString((AQuery.FieldByName('incomes').AsCurrency - AQuery.FieldByName('expenses').AsCurrency), '', False) + '</td>');
            Add('</tr></table>');
            Inc(ARecNo);
          end;
        end;
        if AIsMultiCurrency then begin
          if xIdCurDef <> AQuery.FieldByName('idCurrencyDef').AsString then begin
            xIdCurDef := AQuery.FieldByName('idCurrencyDef').AsString;
            Add('<table class="base" colspan=4>');
            Add('<tr class="' + IsEvenToStr(ARecNo) + 'base">');
            Add('<td class="text" width="40%">[' + GCurrencyCache.GetIso(xIdCurDef) + ']</td>');
            Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('incomes').AsCurrency, '', False) + '</td>');
            Add('<td class="cash" width="20%">' + CurrencyToString(AQuery.FieldByName('expenses').AsCurrency, '', False) + '</td>');
            Add('<td class="cash" width="20%">' + CurrencyToString((AQuery.FieldByName('incomes').AsCurrency - AQuery.FieldByName('expenses').AsCurrency), '', False) + '</td>');
            Add('</tr></table>');
            Inc(ARecNo);
          end;
        end;
        AQuery.Next;
      end;
      Add('</table>');
    end;
  end;

var xBody: TStringList;
    xRec: Integer;
    xSql: String;
    xQuery: TADOQuery;
    xFilter: String;
    xCurDefs: TDataGids;
    xCount: Integer;
    xIsMultiCurrency: Boolean;
    xFieldI, xFieldO, xFieldC: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldI := 'movementIncome';
    xFieldO := 'movementExpense';
    xFieldC := 'idMovementCurrencyDef';
  end else begin
    xFieldI := 'income';
    xFieldO := 'expense';
    xFieldC := 'idAccountCurrencyDef';
  end;
  xBody := TStringList.Create;
  with xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="40%">Sumy ogÛ≥em dla wszystkich kont</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr>');
    xRec := 1;
    xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'balances.idAccount', 'balances.idCashpoint', 'balances.idProduct');
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses from balances where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xQuery := GDataProvider.OpenSql(xSql + ' group by ' + xFieldC);
    xCurDefs := GetDefsFromDataset(xQuery, 'idCurrencyDef');
    xIsMultiCurrency := xCurDefs.Count > 1;
    Add('<table class="base" colspan=5>');
    for xCount := 0 to xCurDefs.Count - 1 do begin
      xQuery.Filter := 'idCurrencyDef = ' + DataGidToDatabase(xCurDefs.Strings[xCount]);
      xQuery.Filtered := True;
      Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
      Add('<td class="text" width="40%">[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCount]) + ']</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('incomes').AsCurrency, '', False) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(xQuery.FieldByName('expenses').AsCurrency, '', False) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((xQuery.FieldByName('incomes').AsCurrency - xQuery.FieldByName('expenses').AsCurrency), '', False) + '</td>');
      Add('</tr>');
      Inc(xRec);
    end;
    Add('</table>');
    xQuery.Free;
    xCurDefs.Free;
    //konta
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, balances.idAccount, account.name from balances ' +
                   ' left join account on account.idAccount = balances.idAccount ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by ' + xFieldC + ', balances.idAccount, account.name order by account.name, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    AppendGroup(xIsMultiCurrency, xQuery, 'Sumy ogÛ≥em dla konta', 'idAccount', xRec, xBody);
    xQuery.Free;
    //kontahenci
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, balances.idCashpoint, cashpoint.name from balances ' +
                   ' left join cashpoint on cashpoint.idCashpoint = balances.idCashpoint ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by ' + xFieldC + ', balances.idCashpoint, cashpoint.name order by cashpoint.name, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    AppendGroup(xIsMultiCurrency, xQuery, 'Sumy ogÛ≥em dla kontrahenta', 'idCashpoint', xRec, xBody);
    xQuery.Free;
    //kategorie
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, balances.idProduct, product.name from balances ' +
                   ' left join product on product.idProduct = balances.idProduct ' +
                   '    where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by ' + xFieldC + ', balances.idProduct, product.name order by product.name, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    AppendGroup(xIsMultiCurrency, xQuery, 'Sumy ogÛ≥em dla kategorii', 'idProduct', xRec, xBody);
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
  Result := ChoosePeriodFilterByForm(FStartDate, FEndDate, FIdFilter, @CurrencyView, True);
end;

function TFuturesReport.GetReportBody: String;

  procedure AppendPeriod(ACurDefs: TDataGids; APeriodsCount, AType: Integer; var ABody: TStringList; ATitle: String; AIn, AOut: TObjectList);
  var xCount: Integer;
      xIn, xOut: Currency;
  begin
    if APeriodsCount > 0 then begin
      with ABody do begin
        Add('<hr><table class="base">');
        Add('<tr class="subhead"><td class="subheadtext" width="100%">' + ATitle + '</td></tr>');
        Add('</table><hr><table class="base" colspan=4>');
        for xCount := 0 to ACurDefs.Count - 1 do begin
          Add('<tr class="' + IsEvenToStr(xCount) + 'base">');
          Add('<td class="text" width="40%">[' + GCurrencyCache.GetIso(ACurDefs.Strings[xCount]) + ']</td>');
          if AType = 0 then begin
            xIn := TPeriodSums(AIn.Items[xCount]).dayAvg;
            xOut := TPeriodSums(AOut.Items[xCount]).dayAvg;
          end else if AType = 1 then begin
            xIn := TPeriodSums(AIn.Items[xCount]).weekAvg;
            xOut := TPeriodSums(AOut.Items[xCount]).weekAvg;
          end else if AType = 2 then begin
            xIn := TPeriodSums(AIn.Items[xCount]).monthAvg;
            xOut := TPeriodSums(AOut.Items[xCount]).monthAvg;
          end else begin
            xIn := 0;
            xOut := 0;
          end;
          Add('<td class="cash" width="20%">' + CurrencyToString(xIn, '', False) + '</td>');
          Add('<td class="cash" width="20%">' + CurrencyToString(xOut, '', False) + '</td>');
          Add('<td class="cash" width="20%">' + CurrencyToString((xIn - xOut), '', False) + '</td>');
          Add('</tr>');
        end;
        Add('</table>');
      end;
    end;
  end;

var xBody: TStringList;
    xSql: String;
    xCount: Integer;
    xQuery: TADOQuery;
    xCurDefs: TDataGids;
    xFilter: String;
    xBasePeriodsIn, xBasePeriodsOut: TObjectList;
    xFuturePeriodsIn, xFuturePeriodsOut: TObjectList;
    xFieldI, xFieldO, xFieldC: String;
begin
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldI := 'movementIncome';
    xFieldO := 'movementExpense';
    xFieldC := 'idMovementCurrencyDef';
  end else begin
    xFieldI := 'income';
    xFieldO := 'expense';
    xFieldC := 'idAccountCurrencyDef';
  end;
  xBody := TStringList.Create;
  with xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="40%">Podsumowanie okresu bazowego</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr>');
    xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True);
    xSql := Format('select %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses, regdate from balances where movementType <> ''%s'' and regDate between %s and %s',
                   [xFieldC, xFieldI, xFieldO, CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
    if xFilter <> '' then begin
      xSql := xSql + ' ' + xFilter;
    end;
    xSql := xSql + ' group by regDate, ' + xFieldC;
    xQuery := GDataProvider.OpenSql(xSql);
    xCurDefs := GetDefsFromDataset(xQuery, 'idCurrencyDef');
    xBasePeriodsIn := TObjectList.Create(True);
    xBasePeriodsOut := TObjectList.Create(True);
    for xCount := 0 to xCurDefs.Count - 1 do begin
      xBasePeriodsIn.Add(TPeriodSums.Create(FStartDate, FEndDate, xCurDefs.Strings[xCount]));
      xBasePeriodsOut.Add(TPeriodSums.Create(FStartDate, FEndDate, xCurDefs.Strings[xCount]));
      TPeriodSums(xBasePeriodsIn.Last).FromDataset(xQuery, 'incomes', 'regDate', 'idCurrencyDef');
      TPeriodSums(xBasePeriodsOut.Last).FromDataset(xQuery, 'expenses', 'regDate', 'idCurrencyDef');
    end;
    Add('<table class="base">');
    Add('<tr class="subhead"><td class="subheadtext" width="100%">Razem</td></tr>');
    Add('</table><hr><table class="base" colspan=4>');
    for xCount := 0 to xCurDefs.Count - 1 do begin
      Add('<tr class="' + IsEvenToStr(xCount) + 'base">');
      Add('<td class="text" width="40%">[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCount]) + ']</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(TPeriodSums(xBasePeriodsIn.Items[xCount]).sum, '', False) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(TPeriodSums(xBasePeriodsOut.Items[xCount]).sum, '', False) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((TPeriodSums(xBasePeriodsIn.Items[xCount]).sum - TPeriodSums(xBasePeriodsOut.Items[xCount]).sum), '', False) + '</td>');
      Add('</tr>');
    end;
    Add('</table>');
    AppendPeriod(xCurDefs, DayCount(FEndDate, FStartDate), 0, xBody, 'Dziennie', xBasePeriodsIn, xBasePeriodsOut);
    AppendPeriod(xCurDefs, WeekCount(FEndDate, FStartDate), 1, xBody, 'Tygodniowo', xBasePeriodsIn, xBasePeriodsOut);
    AppendPeriod(xCurDefs, MonthCount(FEndDate, FStartDate), 2, xBody, 'MiesiÍcznie', xBasePeriodsIn, xBasePeriodsOut);
    xFuturePeriodsIn := TObjectList.Create(True);
    xFuturePeriodsOut := TObjectList.Create(True);
    for xCount := 0 to xCurDefs.Count - 1 do begin
      xFuturePeriodsIn.Add(TPeriodSums(xBasePeriodsIn.Items[xCount]).GetRegLin(FStartDate, FEndDate));
      xFuturePeriodsOut.Add(TPeriodSums(xBasePeriodsOut.Items[xCount]).GetRegLin(FStartDate, FEndDate));
    end;
    Add('<hr>');
    Add('<p>');
    Add('<hr>');
    Add('<table class="base" colspan=4>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="40%">Prognoza dla wybranego okresu</td>');
    Add('<td class="headcash" width="20%">Przychody</td>');
    Add('<td class="headcash" width="20%">Rozchody</td>');
    Add('<td class="headcash" width="20%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr>');
    Add('<table class="base">');
    Add('<tr class="subhead"><td class="subheadtext" width="100%">Razem</td></tr>');
    Add('</table><hr><table class="base" colspan=4>');
    for xCount := 0 to xCurDefs.Count - 1 do begin
      Add('<tr class="' + IsEvenToStr(xCount) + 'base">');
      Add('<td class="text" width="40%">[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCount]) + ']</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(TPeriodSums(xFuturePeriodsIn.Items[xCount]).sum, '', False) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(TPeriodSums(xFuturePeriodsOut.Items[xCount]).sum, '', False) + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString((TPeriodSums(xFuturePeriodsIn.Items[xCount]).sum - TPeriodSums(xFuturePeriodsOut.Items[xCount]).sum), '', False) + '</td>');
      Add('</tr>');
    end;
    Add('</table>');
    AppendPeriod(xCurDefs, DayCount(FEndDate, FStartDate), 0, xBody, 'Dziennie', xFuturePeriodsIn, xFuturePeriodsOut);
    AppendPeriod(xCurDefs, WeekCount(FEndDate, FStartDate), 1, xBody, 'Tygodniowo', xFuturePeriodsIn, xFuturePeriodsOut);
    AppendPeriod(xCurDefs, MonthCount(FEndDate, FStartDate), 2, xBody, 'MiesiÍcznie', xFuturePeriodsIn, xFuturePeriodsOut);
  end;
  Result := xBody.Text;
  xQuery.Free;
  xFuturePeriodsIn.Free;
  xFuturePeriodsOut.Free;
  xBasePeriodsIn.Free;
  xBasePeriodsOut.Free;
  xCurDefs.Free;
  xBody.Free;
end;

function TFuturesReport.GetReportTitle: String;
begin
  Result := 'Prognozy (' + GetFormattedDate(FStartFuture, CLongDateFormat) + ' - ' + GetFormattedDate(FEndFuture, CLongDateFormat) + ')';
end;

function TFuturesReport.PrepareReportConditions: Boolean;
begin
  Result := ChooseFutureFilterByForm(FStartDate, FEndDate, FStartFuture, FEndFuture, FIdFilter, @CurrencyView, True)
end;

constructor TSumForDayItem.Create(ADate: TDateTime; ASum: Currency);
begin
  inherited Create;
  Fsum := ASum;
  Fdate := ADate;
end;

constructor TPeriodSums.Create(AStartDate, AEndDate: TDateTime; AIdCurrency: TDataGid);
var xCurDate: TDateTime;
begin
  inherited Create(True);
  FstartDate := AStartDate;
  FendDate := AEndDate;
  xCurDate := FstartDate;
  FidCurrencyDef := AIdCurrency;
  repeat
    Add(TSumForDayItem.Create(xCurDate));
    xCurDate := IncDay(xCurDate);
  until (xCurDate > FendDate);
end;

procedure TPeriodSums.FromDataset(ADataset: TDataSet; ASumName, ADateName, ACurrencyName: String);
begin
  ADataset.First;
  if ACurrencyName <> '' then begin
    ADataset.Filter := ACurrencyName + ' = ' + DataGidToDatabase(FidCurrencyDef);
    ADataset.Filtered := True;
  end;
  while not ADataset.Eof do begin
    ByDate[ADataset.FieldByName(ADateName).AsDateTime] := ADataset.FieldByName(ASumName).AsCurrency;
    ADataset.Next;
  end;
  ADataset.First;
  ADataset.Filtered := False;
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
  Result := TPeriodSums.Create(AStartDate, AEndDate, FidCurrencyDef);
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
  FStartDate := GWorkDate;
  FEndDate := GWorkDate;
  Result := inherited PrepareReportConditions;
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
    Add('<tr class="head">');
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
    Add('<td class="center" width="20%">' + CurrencyToString(xL.totalCash, '', False) + '</td>');
    Add('<td class="center" width="10%">' + CurrencyToString(xL.taxAmount, '', False, 4) + '%</td>');
    Add('<td class="center" width="15%">' + CurrencyToString(xL.otherTaxes, '', False) + '</td>');
    Add('<td class="center" width="15%">' + IntToStr(xL.periods) + '</td>');
    Add('<td class="center" width="15%">' + xPaymentType + '</td>');
    Add('<td class="center" width="15%">' + xPaymentPeriod + '</td>');
    Add('<td class="center" width="10%">' + CurrencyToString(xL.yearRate, '', False, 4) + '%</td>');
    Add('</tr>');
    Add('</table>');
    Add('<hr>');
    Add('<p class="reptitle">Harmonogram sp≥at<hr>');
    Add('<table class="base" colspan="' + IntToStr(IfThen(xL.firstDay <> 0, 6, 5)) + '">');
    Add('<tr class="head">');
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
        Add('<tr class="' + IsEvenToStr(xCount) + 'base">');
        Add('<td class="text" width="5%">' + IntToStr(xCount + 1) + '</td>');
        if xL.firstDay <> 0 then begin
          Add('<td class="text" width="20%">' + DateToStr(xL.Items[xCount].date) + '</td>');
        end;
        Add('<td class="cash" width="25%">' + CurrencyToString(xL.Items[xCount].payment, '', False) + '</td>');
        Add('<td class="cash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.Items[xCount].principal, '', False) + '</td>');
        Add('<td class="cash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.Items[xCount].tax, '', False) + '</td>');
        Add('<td class="cash" width="20%">' + CurrencyToString(xL.Items[xCount].left, '', False) + '</td>');
        Add('</tr>');
      end;
    end;
    Add('</table><hr><table class="base" colspan="' + IntToStr(IfThen(xL.firstDay <> 0, 6, 5)) + '">');
    Add('<tr class="sum">');
    Add('<td class="sumtext" width="5%">Razem</td>');
    if xL.firstDay <> 0 then begin
      Add('<td class="sumtext" width="20%"></td>');
    end;
    Add('<td class="sumcash" width="25%">' + CurrencyToString(xL.sumPayments, '', False) + '</td>');
    Add('<td class="sumcash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.sumPrincipal, '', False) + '</td>');
    Add('<td class="sumcash" width="' + IntToStr(IfThen(xL.firstDay <> 0, 15, 20)) + '%">' + CurrencyToString(xL.sumTax, '', False) + '</td>');
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
    xPrevValue: Currency;
    xPercentage: String;
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
    xPrevValue := -1;
    while xCurDate <= FEndDate do begin
      xRate := FindCurrencyRate(xRates, xCurDate, FrateTypes[xCount]);
      if xRate <> Nil then begin
        xCurValue := xMaxQuantity * xRate.rate / xRate.quantity;
      end;
      if (xCurValue <> -1) and (xCurDate <= xMaxDate) then begin
        if xPrevValue <> -1 then begin
          xPercentage := CurrencyToString(xCurValue, '', False, 4) + ' (' + CurrencyToString((xCurValue/xPrevValue - 1) * 100, '', False, 4) + '%)';
        end;
        xSerie.AddXY(xCurDate, xCurValue, xPercentage);
        xPrevValue := xCurValue;
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
  TCHtmlReportForm(FForm).CBrowser.LoadFromString(GBaseTemlatesList.ExpandTemplates(FreportText.Text, Self));
end;

procedure TCChartReport.SetChartProps;
var xPref: TChartPref;
    xChart: TCChart;
begin
  xChart := TCChartReportForm(FForm).ActiveChart;
  if xChart <> Nil then begin
    with xChart do begin
      xPref := TChartPref(GChartPreferences.ByPrefname[GetPrefname + xChart.symbol]);
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
        View3DOptions.Orthogonal := not xChart.isPie;
        View3D := xChart.isPie;
      end;
    end;
  end;
end;

function TPluginChartReport.CanShowReport: Boolean;
begin
  Result := inherited CanShowReport;
  TCChartReportForm(FForm).PanelNoData.Caption := 'Wtyczka nie zwrÛci≥a øadnego wykresu do wyúwietlenie';
end;

function TPluginChartReport.GetPrefname: String;
begin
  Result := TCPluginReportParams(Params).plugin.fileName;
end;

procedure TCChartReport.Setmarks(const Value: Integer);
var xCount: Integer;
    xChart: TChart;
begin
  xChart := TCChartReportForm(FForm).ActiveChart;
  if xChart <> Nil then begin
    for xCount := 0 to xChart.SeriesCount - 1 do begin
      xChart.Series[xCount].Marks.Visible := Value <> 0;
      if Value = 1 then begin
        xChart.Series[xCount].Marks.Style := smsValue;
      end else if Value = 2 then begin
        xChart.Series[xCount].Marks.Style := smsLabel;
      end;
    end;
  end;
end;

function TPluginChartReport.GetReportFooter: String;
begin
  Result := '';
end;

function TPluginChartReport.GetReportTitle: String;
begin
  Result := '';
end;

procedure TPluginChartReport.PrepareReportChart;
var xSeries, xItems, xCharts: IXMLDOMNodeList;
    xCountS, xCountC, xCountI: Integer;
    xChartNode, xSerieNode, xItemNode: IXMLDOMNode;
    xSerieObject: TChartSeries;
    xSerieType: Integer;
    xX, xY: Double;
    xLabel: String;
    xChart: TCChart;
begin
  xCharts := FXml.documentElement.selectNodes('chart');
  for xCountC := 0 to xCharts.length - 1 do begin
    xChartNode := xCharts.item[xCountC];
    xChart := GetChart(GetXmlAttribute('symbol', xChartNode, ''));
    xChart.thumbTitle := GetXmlAttribute('thumbTitle', xChartNode, '');
    xChart.Title.Text.Text := GetXmlAttribute('chartTitle', xChartNode, '');
    xChart.Foot.Text.Text := GetXmlAttribute('chartFooter', xChartNode, '');
    xSeries := xCharts.item[xCountC].selectNodes('serie');
    for xCountS := 0 to xSeries.length - 1 do begin
      xSerieNode := xSeries.item[xCountS];
      xSerieType := StrToIntDef(GetXmlAttribute('type', xSerieNode, ''), 0);
      if xSerieType = CSERIESTYPE_PIE then begin
        xSerieObject := TPieSeries.Create(xChart);
      end else if xSerieType = CSERIESTYPE_LINE then begin
        xSerieObject := TLineSeries.Create(xChart);
      end else if xSerieType = CSERIESTYPE_BAR then begin
        xSerieObject := TBarSeries.Create(xChart);
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
            xX := YmdToDate(GetXmlAttribute('domain', xItemNode, ''), 0);
          end else begin
            xX := StrToCurrencyDecimalDot(GetXmlAttribute('domain', xItemNode, ''));
          end;
          xY := StrToCurrencyDecimalDot(GetXmlAttribute('value', xItemNode, ''));
          xSerieObject.AddXY(xX, xY, xLabel);
        end;
        if xSerieObject.ValuesLists.Count > 0 then begin
          xChart.AddSeries(xSerieObject);
        end;
      end;
    end;
    with xChart do begin
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
end;

function TPluginChartReport.PrepareReportConditions: Boolean;
var xOut: OleVariant;
begin
  xOut := TCPluginReportParams(Params).plugin.Execute;
  Result := False;
  if not VarIsEmpty(xOut) then begin
    FXml := GetDocumentFromString(GBaseTemlatesList.ExpandTemplates(xOut, Self));
    Result := FXml.parseError.errorCode = 0;
    if not Result then begin
      ShowInfo(itError, 'Nie uda≥o siÍ wygenerowaÊ wykresu', FXml.parseError.reason);
    end;
  end;
end;

procedure TCChartReport.UpdateChartsThumbnails;
begin
  TCChartReportForm(FForm).UpdateThumbnails;
end;

function TCPHistoryReport.GetReportBody: String;
var xOperations: TADOQuery;
    xBody: TStringList;
    xFieldR, xFieldC, xFieldT, xDescSec, xJoin: String;
    xSums: TSumList;
    xCount: Integer;
    xQuantitySum: Currency;
begin
  xSums := TSumList.Create(True);
  if CurrencyView = CCurrencyViewMovements then begin
    xFieldC := 'idMovementCurrencyDef';
    xFieldR := 'movementCash';
  end else begin
    xFieldC := 'idAccountCurrencyDef';
    xFieldR := 'cash';
  end;
  if TCReportParams(FParams).acp = CGroupByCashpoint then begin
    xFieldT := 'idCashpoint';
    xDescSec := 'Kategoria';
    xJoin := ' left outer join product x on x.idProduct = t.idProduct ';
  end else if TCReportParams(FParams).acp = CGroupByProduct then begin
    xFieldT := 'idProduct';
    xDescSec := 'Kontrahent';
    xJoin := ' left outer join cashpoint x on x.idCashpoint = t.idCashpoint ';
  end;
  xQuantitySum := 0;
  xOperations := GDataProvider.OpenSql(
      Format('select t.movementType, t.idAccount, t.description, t.regDate, ' +
                     't.%s as cash, t.%s as idCurrencyDef, x.name as descriptionSecond, t.idUnitDef, t.quantity from transactions t ' +
                     xJoin + ' ' +
                     'where t.regDate between %s and %s and t.%s = %s order by t.regDate',
             [xFieldR, xFieldC, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), xFieldT, DataGidToDatabase(FIdCp)]));
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=6>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data</td>');
    Add('<td class="headtext" width="' + IfThen(FIdUnitDef = CEmptyDataGid, '30', '25') + '%">Opis</td>');
    Add('<td class="headtext" width="' + IfThen(FIdUnitDef = CEmptyDataGid, '25', '20') + '%">' + xDescSec +  '</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="15%">Kwota operacji</td>');
    if FIdUnitDef <> CEmptyDataGid then begin
      Add('<td class="headcash" width="10%">' + GUnitdefCache.GetSymbol(FIdUnitDef) + '</td>');
    end;
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=6>');
    while not Eof do begin
      Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="' + IfThen(FIdUnitDef = CEmptyDataGid, '30', '25') + '%">' + ReplaceLinebreaksBR(FieldByName('description').AsString) + '</td>');
      Add('<td class="text" width="' + IfThen(FIdUnitDef = CEmptyDataGid, '25', '20') + '%">' + ReplaceLinebreaksBR(FieldByName('descriptionSecond').AsString) + '</td>');
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idCurrencyDef').AsString) + '</td>');
      Add('<td class="cash" width="15%">' + CurrencyToString(FieldByName('cash').AsCurrency, '', False) + '</td>');
      if FIdUnitDef <> CEmptyDataGid then begin
        Add('<td class="cash" width="10%">' + CurrencyToString(FieldByName('quantity').AsCurrency, '', False) + '</td>');
      end;
      Add('</tr>');
      xSums.AddSum(FieldByName('idCurrencyDef').AsString, FieldByName('cash').AsCurrency, '');
      xQuantitySum := xQuantitySum + FieldByName('quantity').AsCurrency;
      Next;
    end;
    Add('</table><hr>');
    if xSums.Count > 0 then begin
      Add('<table class="base" colspan=3>');
      for xCount := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        Add('<td class="sumtext" width="' + IfThen(FIdUnitDef = CEmptyDataGid, '75', '65') + '%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSums.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="15%">' + CurrencyToString(xSums.Items[xCount].value, '', False) + '</td>');
        if FIdUnitDef <> CEmptyDataGid then begin
          Add('<td class="sumcash" width="10%">' + CurrencyToString(xQuantitySum, '', False) + '</td>');
        end;
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xOperations.Free;
  xSums.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TCPHistoryReport.GetReportTitle: String;
var xP: TDataObject;
begin
  if TCReportParams(FParams).acp = CGroupByCashpoint then begin
    xP := TCashPoint.LoadObject(CashPointProxy, FIdCp, False);
    Result := 'Historia kontrahenta ' + TCashPoint(xP).name + ' (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end else if TCReportParams(FParams).acp = CGroupByProduct then begin
    xP := TProduct.LoadObject(ProductProxy, FIdCp, False);
    Result := 'Historia kategorii ' + TProduct(xP).name + ' (' + GetFormattedDate(FStartDate, CLongDateFormat) + ' - ' + GetFormattedDate(FEndDate, CLongDateFormat) + ')';
  end;
end;

function TCPHistoryReport.PrepareReportConditions: Boolean;
begin
  if FParams.InheritsFrom(TCWithGidParams) then begin
    Result := ChoosePeriodByForm(FStartDate, FEndDate, @CurrencyView);
    FIdCp := TCWithGidParams(FParams).id;
  end else begin
    Result := ChoosePeriodAcpByForm(TCReportParams(FParams).acp, FStartDate, FEndDate, FIdCp, @CurrencyView);
  end;
  if TCReportParams(FParams).acp = CGroupByProduct then begin
    FIdUnitDef := TProduct.HasQuantity(FIdCp);
  end else begin
    FIdUnitDef := CEmptyDataGid;
  end;
end;

constructor TCReportParams.CreateAco(AAcp: String);
begin
  inherited Create;
  Facp := AAcp;
end;

function TSumBySomethingChart.GetReportTitle: String;
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

procedure TSumBySomethingChart.PrepareReportChart;
var xGbDate, xNameDate, xCashField, xCurrencyField: String;
    xGbAcp, xGbAcpJoin: String;
    xFilter, xSql: String;
    xOperations: TADOQuery;
    xCurDefs: TStringList;
    xAcpDefs: TStringList;
    xCountCur, xCountAcp: Integer;
    xChart: TCChart;
    xCurDate: TDateTime;
    xSerie: TBarSeries;
    xBalance: Currency;
begin
  xGbDate := 'regDate';
  xNameDate := 'DzieÒ';
  if FGroupBy = CGroupByWeek then begin
    xGbDate := 'weekDate';
    xNameDate := 'TydzieÒ';
  end else if FGroupBy = CGroupByMonth then begin
    xGbDate := 'monthDate';
    xNameDate := 'Miesiπc';
  end;
  if CurrencyView = CCurrencyViewMovements then begin
    xCashField := 'movementCash';
    xCurrencyField := 'idMovementCurrencyDef';
  end else begin
    xCashField := 'cash';
    xCurrencyField := 'idAccountCurrencyDef';
  end;
  if FAcp = CGroupByProduct then begin
    xGbAcp := 'idProduct';
    xGbAcpJoin := ' left outer join product p on p.idProduct = v.idAcp';
  end else if FAcp = CGroupByCashpoint then begin
    xGbAcp := 'idCashpoint';
    xGbAcpJoin := ' left outer join cashpoint p on p.idCashpoint = v.idAcp';
  end else if FAcp = CGroupByAccount then begin
    xGbAcp := 'idAccount';
    xGbAcpJoin := ' left outer join account p on p.idAccount = v.idAcp';
  end else begin
    xGbAcp := '';
    xGbAcpJoin := '';
  end;
  xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'v.idAccount', 'v.idCashpoint', 'v.idProduct');
  xSql := Format('select ' + IfThen(xGbAcp = '', '%s', 'p.name, p.%s, ') + 'v.* from ' +
            '(select %s as idCurrencyDef, sum(%s) as cash, %s as gbDate' + IfThen(xGbAcp = '', '%s', ', %s as idAcp') + ' from transactions ' +
              'where movementType = ''%s'' and regDate between %s and %s %s group by %s, %s%s) as v %s',
          [xGbAcp, xCurrencyField, xCashField, xGbDate, xGbAcp, TCSelectedMovementTypeParams(Params).movementType,
           DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
           xFilter, xCurrencyField, xGbDate, IfThen(xGbAcp = '', '', ', ' + xGbAcp), xGbAcpJoin]);
  xOperations := GDataProvider.OpenSql(xSql);
  xCurDefs := GetDefsFromDataset(xOperations, 'idCurrencyDef');
  if xGbAcp <> '' then begin
    xAcpDefs := GetNamesFromDataset(xOperations, xGbAcp, 'name');
  end else begin
    xAcpDefs := TStringList.Create;
    xAcpDefs.Values['*'] := 'Wszystkie dane';
  end;
  for xCountCur := 0 to xCurDefs.Count - 1 do begin
    xChart := GetChart(xCurDefs.Strings[xCountCur]);
    xChart.thumbTitle := '[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCountCur]) + ']';
    for xCountAcp := 0 to xAcpDefs.Count - 1 do begin
      xSerie := TBarSeries.Create(xChart);
      with TBarSeries(xSerie) do begin
        Title := xAcpDefs.Values[xAcpDefs.Names[xCountAcp]];
        Marks.ArrowLength := 0;
        Marks.Style := smsValue;
        HorizAxis := aBottomAxis;
        XValues.DateTime := True;
      end;
      if FGroupBy = CGroupByWeek then begin
        xCurDate := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := StartOfTheMonth(FStartDate);
      end else begin
        xCurDate := FStartDate;
      end;
      while (xCurDate <= FEndDate) do begin
        xOperations.Filter := 'gbDate = ' + DatetimeToDatabase(xCurDate, False) +
                              ' and idCurrencyDef = ' + DataGidToDatabase(xCurDefs.Strings[xCountCur]) +
                              IfThen(xGbAcp = '', '', ' and idAcp = ' + DataGidToDatabase(xAcpDefs.Names[xCountAcp]));
        xOperations.Filtered := True;
        xOperations.First;
        if not xOperations.IsEmpty then begin
          xBalance := Abs(xOperations.FieldByName('cash').AsCurrency);
        end else begin
          xBalance := 0;
        end;
        xSerie.AddXY(xCurDate, xBalance, GetDescription(FGroupBy, xCurDate));
        if FGroupBy = CGroupByWeek then begin
          xCurDate := IncWeek(xCurDate, 1);
        end else if FGroupBy = CGroupByMonth then begin
          xCurDate := IncMonth(xCurDate, 1);
        end else begin
          xCurDate := IncDay(xCurDate, 1);
        end;
      end;
      xChart.AddSeries(xSerie);
    end;
    with xChart do begin
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
      end;
      with LeftAxis do begin
        MinorTickCount := 0;
        Title.Caption := '[' + GCurrencyCache.GetIso(xCurDefs.Strings[xCountCur]) + ']';
        Title.Angle := 90;
      end;
    end;
  end;
  xCurDefs.Free;
  xAcpDefs.Free;
  xOperations.Free;
end;

function TSumBySomethingChart.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodFilterGroupByForm(FStartDate, FEndDate, FIdFilter, FGroupBy, FAcp, @CurrencyView, True);
end;

function TSumBySomethingList.GetReportBody: String;
var xBody: TStringList;
    xGbDate, xNameDate, xCashField, xCurrencyField: String;
    xGbAcp, xGbAcpJoin: String;
    xFilter, xSql: String;
    xOperations: TADOQuery;
    xAcpDefs: TStringList;
    xCountAcp: Integer;
    xCurDate: TDateTime;
    xRec: Integer;
    xSums: TSumList;
begin
  xSums := TSumList.Create(True);
  xGbDate := 'regDate';
  xNameDate := 'DzieÒ';
  if FGroupBy = CGroupByWeek then begin
    xGbDate := 'weekDate';
    xNameDate := 'TydzieÒ';
  end else if FGroupBy = CGroupByMonth then begin
    xGbDate := 'monthDate';
    xNameDate := 'Miesiπc';
  end;
  if CurrencyView = CCurrencyViewMovements then begin
    xCashField := 'movementCash';
    xCurrencyField := 'idMovementCurrencyDef';
  end else begin
    xCashField := 'cash';
    xCurrencyField := 'idAccountCurrencyDef';
  end;
  if FAcp = CGroupByProduct then begin
    xGbAcp := 'idProduct';
    xGbAcpJoin := ' left outer join product p on p.idProduct = v.idAcp';
  end else if FAcp = CGroupByCashpoint then begin
    xGbAcp := 'idCashpoint';
    xGbAcpJoin := ' left outer join cashpoint p on p.idCashpoint = v.idAcp';
  end else if FAcp = CGroupByAccount then begin
    xGbAcp := 'idAccount';
    xGbAcpJoin := ' left outer join account p on p.idAccount = v.idAcp';
  end else begin
    xGbAcp := '';
    xGbAcpJoin := '';
  end;
  xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'v.idAccount', 'v.idCashpoint', 'v.idProduct');
  xSql := Format('select ' + IfThen(xGbAcp = '', '%s', 'p.name, p.%s, ') + 'v.* from ' +
            '(select %s as idCurrencyDef, sum(%s) as cash, %s as gbDate' + IfThen(xGbAcp = '', '%s', ', %s as idAcp') + ' from transactions ' +
              'where movementType = ''%s'' and regDate between %s and %s %s group by %s, %s%s) as v %s',
          [xGbAcp, xCurrencyField, xCashField, xGbDate, xGbAcp, TCSelectedMovementTypeParams(Params).movementType,
           DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
           xFilter, xCurrencyField, xGbDate, IfThen(xGbAcp = '', '', ', ' + xGbAcp), xGbAcpJoin]);
  xOperations := GDataProvider.OpenSql(xSql);
  if xGbAcp <> '' then begin
    xAcpDefs := GetNamesFromDataset(xOperations, xGbAcp, 'name');
  end else begin
    xAcpDefs := TStringList.Create;
    xAcpDefs.Values['*'] := 'Wszystkie dane';
  end;
  xBody := TStringList.Create;
  with xBody do begin
    Add('<table class="base" colspan=3>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="75%">Data</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="15%">Suma</td>');
    Add('</tr>');
    Add('</table>');
    for xCountAcp := 0 to xAcpDefs.Count - 1 do begin
      Add('<hr>');
      if xGbAcp <> '' then begin
        Add('<table class="base">');
        Add('<tr class="subhead">');
        Add('<td class="subheadtext" width="100%">' + xAcpDefs.Values[xAcpDefs.Names[xCountAcp]] + '</td>');
        Add('</tr>');
        Add('</table><hr>');
      end;
      if FGroupBy = CGroupByWeek then begin
        xCurDate := StartOfTheWeek(FStartDate);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := StartOfTheMonth(FStartDate);
      end else begin
        xCurDate := FStartDate;
      end;
      while (xCurDate <= FEndDate) do begin
        xOperations.Filter := 'gbDate = ' + DatetimeToDatabase(xCurDate, False) +
                              IfThen(xGbAcp = '', '', ' and idAcp = ' + DataGidToDatabase(xAcpDefs.Names[xCountAcp]));
        xOperations.Filtered := True;
        xOperations.First;
        xRec := 0;
        while not xOperations.Eof do begin
          Add('<table class="base">');
          Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
          Add('<td class="text" width="75%">' + IfThen(xRec = 0, GetDescription(FGroupBy, xCurDate)) + '</td>');
          Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(xOperations.FieldByName('idCurrencyDef').AsString) + '</td>');
          Add('<td class="cash" width="15%">' + CurrencyToString(Abs(xOperations.FieldByName('cash').AsCurrency), '', False) + '</td>');
          Add('</tr>');
          xSums.AddSum(xOperations.FieldByName('idCurrencyDef').AsString, Abs(xOperations.FieldByName('cash').AsCurrency), CEmptyDataGid);
          xOperations.Next;
          Inc(xRec);
        end;
        Add('</table>');
        if FGroupBy = CGroupByWeek then begin
          xCurDate := IncWeek(xCurDate, 1);
        end else if FGroupBy = CGroupByMonth then begin
          xCurDate := IncMonth(xCurDate, 1);
        end else begin
          xCurDate := IncDay(xCurDate, 1);
        end;
      end;
    end;
    if xSums.Count > 0 then begin
      Add('<hr><table class="base" colspan=3>');
      for xCountAcp := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCountAcp) + 'sum">');
        Add('<td class="sumtext" width="75%">' + IfThen(xCountAcp = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSums.Items[xCountAcp].name) + '</td>');
        Add('<td class="sumcash" width="15%">' + CurrencyToString(xSums.Items[xCountAcp].value, '', False) + '</td>');
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<hr><table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  Result := xBody.Text;
  xSums.Free;
  xBody.Free;
  xAcpDefs.Free;
  xOperations.Free;
end;

function TSumBySomethingList.GetReportTitle: String;
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

function TSumBySomethingList.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodFilterGroupByForm(FStartDate, FEndDate, FIdFilter, FGroupBy, FAcp, @CurrencyView, True);
end;

constructor TCSelectedMovementTypeParams.CreateAcpType(AAcp, AType: String);
begin
  CreateAco(AAcp);
  FmovementType := AType;
end;

function TAccountExtractionReport.GetReportBody: String;
var xOperations: TADOQuery;
    xSum: TSumList;
    xBody: TStringList;
    xCash: Currency;
    xCashStr: String;
    xMovement: String;
    xCount: Integer;
begin
  xOperations := GDataProvider.OpenSql('select * from extractionItem where idAccountExtraction = ' + DataGidToDatabase(TCWithGidParams(Params).id));
  xSum := TSumList.Create(True);
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=7>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="5%">Lp</td>');
    Add('<td class="headtext" width="15%">Data operacji</td>');
    Add('<td class="headtext" width="15%">Data ksiÍgowania</td>');
    Add('<td class="headtext" width="30%">Opis</td>');
    Add('<td class="headcash" width="10%">Waluta</td>');
    Add('<td class="headcash" width="10%">Kwota</td>');
    Add('<td class="headtext" width="15%">Rodzaj</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=7>');
    while not Eof do begin
      Add('<tr class="' + IsEvenToStr(RecNo) + 'base">');
      if FieldByName('movementType').AsString = CInMovement then begin
        xCash := FieldByName('cash').AsCurrency;
        xMovement := 'Uznanie';
      end else begin
        xCash := (-1) * FieldByName('cash').AsCurrency;
        xMovement := 'Obciπøenie';
      end;
      xCashStr := CurrencyToString(xCash, '', False);
      xSum.AddSum(FieldByName('idCurrencyDef').AsString, xCash, CEmptyDataGid);
      Add('<td class="text" width="5%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('regDate').AsDateTime) + '</td>');
      Add('<td class="text" width="15%">' + DateToStr(FieldByName('accountingDate').AsDateTime) + '</td>');
      Add('<td class="text" width="30%">' + ReplaceLinebreaksBR(FieldByName('description').AsString) + '</td>');
      Add('<td class="cash" width="10%">' + GCurrencyCache.GetSymbol(FieldByName('idCurrencyDef').AsString) + '</td>');
      Add('<td class="cash" width="10%">' + xCashStr + '</td>');
      Add('<td class="text" width="15%">' + xMovement + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr>');
    if xSum.Count > 0 then begin
      Add('<table class="base" colspan=4>');
      for xCount := 0 to xSum.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        Add('<td class="sumtext" width="65%">' + IfThen(xCount = 0, 'Razem', '') + '</td>');
        Add('<td class="sumcash" width="10%">' + GCurrencyCache.GetSymbol(xSum.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="10%">' + CurrencyToString(xSum.Items[xCount].value, '', False) + '</td>');
        Add('<td class="sumtext" width="15%"></td>');
        Add('</tr>');
      end;
      Add('</table>');
    end else begin
      Add('<table class="base"><tr class="sum"><td class="sumtext" width="100%">Razem</td></tr></table>');
    end;
  end;
  xOperations.Free;
  Result := xBody.Text;
  xSum.Free;
  xBody.Free;
end;

function TAccountExtractionReport.GetReportTitle: String;
var xExt: TAccountExtraction;
begin
  GDataProvider.BeginTransaction;
  xExt := TAccountExtraction(TAccountExtraction.LoadObject(AccountExtractionProxy, TCWithGidParams(Params).id, False));
  Result := xExt.description + ', za okres od ' + DateTimeToStr(xExt.startDate) + ' do ' + DateTimeToStr(xExt.endDate);
  GDataProvider.RollbackTransaction;
end;

function TSimpleReportDialog.GetFormTitle: String;
begin
  Result := TSimpleReportParams(FParams).formTitle;
end;

function TSimpleReportDialog.GetReportBody: String;
begin
end;

function TSimpleReportDialog.GetReportFooter: String;
begin
  Result := '';
end;

function TSimpleReportDialog.GetReportTitle: String;
begin
  Result := '';
end;

procedure ShowSimpleReport(AFormTitle, AReportText: string);
var xParams: TSimpleReportParams;
    xReport: TSimpleReportDialog;
begin
  xParams := TSimpleReportParams.Create;
  xParams.formTitle := AFormTitle;
  xParams.reportText := AReportText;
  xReport := TSimpleReportDialog.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

function TQuantitySumReportList.GetReportBody: String;
var xOperations: TADOQuery;
    xGb: String;
    xQuantsSum, xOccursSum: TSumList;
    xBody: TStringList;
    xName: String;
    xCurDate: TDateTime;
    xRec, xCount: Integer;
    xFilter: String;
    xProducts: TDataObjectList;
    xUnitid: String;
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
  xFilter := TMovementFilter.GetFilterCondition(FIdFilter, True, 'transactions.idAccount', 'transactions.idCashpoint', 'transactions.idProduct');
  xOperations := GDataProvider.OpenSql(Format('select count(*) as occurs, sum(quantity) as quants, idProduct, idUnitDef, %s from transactions where movementType = ''%s'' and regDate between %s and %s %s group by %s, idProduct, idUnitDef order by %s',
                             [xGb, TCSelectedMovementTypeParams(FParams).movementType,
                              DatetimeToDatabase(FStartDate, False),
                              DatetimeToDatabase(FEndDate, False), xFilter,
                              xGb, xGb]));
  xProducts := TProduct.GetAllObjects(ProductProxy);
  xRec := 1;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="head">');
    Add('<td class="headtext" width="30%">' + xName + '</td>');
    Add('<td class="headtext" width="30%">Kategoria</td>');
    Add('<td class="headcash" width="10%">WykonaÒ</td>');
    Add('<td class="headcash" width="20%">Jednostka</td>');
    Add('<td class="headcash" width="10%">IloúÊ</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
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
      xQuantsSum := TSumList.Create(True);
      xOccursSum := TSumList.Create(True);
      while not Eof do begin
        if IsValidGid(FieldByName('idProduct').AsString, FAcps) then begin
          xQuantsSum.AddSum(FieldByName('idProduct').AsString, Abs(FieldByName('quants').AsCurrency), CEmptyDataGid);
          xOccursSum.AddSum(FieldByName('idProduct').AsString, Abs(FieldByName('occurs').AsCurrency), CEmptyDataGid);
        end;
        Next;
      end;
      if xQuantsSum.Count > 0 then begin
        for xCount := 0 to xQuantsSum.Count - 1 do begin
          Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
          Add('<td class="text" width="30%">' + IfThen(xCount = 0, GetDescription(FGroupBy, xCurDate), '') + '</td>');
          Add('<td class="text" width="30%">' + TProduct(xProducts.ObjectById[xQuantsSum.Items[xCount].name]).name + '</td>');
          Add('<td class="cash" width="10%">' + CurrencyToString(xOccursSum.ByNameCurrency[xQuantsSum.Items[xCount].name, CEmptyDataGid].value, '', False, 0) + '</td>');
          xUnitid := TProduct(xProducts.ObjectById[xQuantsSum.Items[xCount].name]).idUnitDef;
          if xUnitid <> CEmptyDataGid then begin
            Add('<td class="cash" width="20%">' + GUnitdefCache.GetSymbol(xUnitid) + '</td>');
            Add('<td class="cash" width="10%">' + CurrencyToString(xQuantsSum.Items[xCount].value, '', False) + '</td>');
          end else begin
            Add('<td class="cash" width="20%">-</td>');
            Add('<td class="cash" width="10%">-</td>');
          end;
          Add('</tr>');
          Inc(xRec);
        end;
      end else begin
        Add('<tr class="' + IsEvenToStr(xRec) + 'base">');
        Add('<td class="text" width="30%">' + GetDescription(FGroupBy, xCurDate) + '</td>');
        Add('<td class="text" width="30%">-</td>');
        Add('<td class="cash" width="10%">-</td>');
        Add('<td class="text" width="20%">-</td>');
        Add('<td class="cash" width="10%">-</td>');
        Add('</tr>');
        Inc(xRec);
      end;
      xQuantsSum.Free;
      xOccursSum.Free;
      if FGroupBy = CGroupByWeek then begin
        xCurDate := IncWeek(xCurDate, 1);
      end else if FGroupBy = CGroupByMonth then begin
        xCurDate := IncMonth(xCurDate, 1);
      end else begin
        xCurDate := IncDay(xCurDate, 1);
      end;
    end;
    Add('</table>');
  end;
  xOperations.Free;
  xProducts.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TQuantitySumReportList.GetReportTitle: String;
begin
  Result := 'Sumy iloúciowe';
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

function TQuantitySumReportList.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodAcpListGroupByForm(FParams.acp, FStartDate, FEndDate, FAcps, FIdFilter, FGroupBy, Nil);
end;

procedure ShowXsltReport(AFormTitle: string; AXmlText: String; AXsltText: String);
var xXml, xXslt: IXMLDOMDocument;
    xBody: String;
begin
  xXml := GetDocumentFromString(AXmlText);
  if xXml <> Nil then begin
    xXslt := GetDocumentFromString(AXsltText);
    if xXslt <> Nil then begin
      try
        xBody := xXml.transformNode(xXslt.documentElement);
        ShowSimpleReport(AFormTitle, xBody);
      except
        on E: Exception do begin
          ShowInfo(itError, E.Message, '');
        end;
      end;
    end;
  end;
end;

function TCBaseReport._AddRef: Integer;
begin
  Result := 0;
end;

function TCBaseReport._Release: Integer;
begin
  Result := 0;
end;

function TPrivateReport.CanShowReport: Boolean;
begin
  Result := FErrorText = '';
  if not Result then begin
    ShowInfo(itError, FErrorText, FAddText);
  end;
end;

function TPrivateReport.PrepareReportConditions: Boolean;
var xBufferOut: String;
begin
  FreportDef := TReportDef(TReportDef.LoadObject(ReportDefProxy, TCWithGidParams(Params).id, False));
  Result := DecodeBase64Buffer(FreportDef.xsltText, xBufferOut);
  if Result then begin
    if xBufferOut = '' then begin
      FxsltDoc := GetDefaultXsl;
    end else begin
      FxsltDoc := GetXmlDocument(xBufferOut);
    end;
    if FxsltDoc.parseError.errorCode = 0 then begin
      Result := DecodeBase64Buffer(FreportDef.paramsDefs, xBufferOut);
      if Result then begin
        Fparams := TReportDialogParamsDefs.Create;
        Fparams.AsString := xBufferOut;
        Result := ChooseByParamsDefs(Fparams);
      end else begin
        ShowInfo(itError, 'Dane parametrÛw raportu sπ uszkodzone i raport nie moøe zostaÊ wykonany. Prawdopodobnie plik danych jest uszkodzony. ' +
                          'Moøesz kontynuowaÊ pracÍ, ale zalecane jest abyú uruchomi≥ CManager-a ponownie, wykona≥ kopiÍ pliku danych ' +
                          'i nastÍpnie kompaktowanie pliku danych.', '');

      end;
    end else begin
      Result := False;
      ShowInfo(itError, 'Zdefiniowany dla raportu arkusz styli jest niepoprawny', FxsltDoc.parseError.reason);
    end;
  end else begin
    ShowInfo(itError, 'Dane arkusza styli sπ uszkodzone i raport nie moøe zostaÊ wykonany. Prawdopodobnie plik danych jest uszkodzony. ' +
                      'Moøesz kontynuowaÊ pracÍ, ale zalecane jest abyú uruchomi≥ CManager-a ponownie, wykona≥ kopiÍ pliku danych ' +
                      'i nastÍpnie kompaktowanie pliku danych.', '');
  end;
  if not Result then begin
    Fparams.Free;
  end;
end;

procedure TPrivateReport.PrepareReportContent;
var xQuery: TADOQuery;
    xXml: IXMLDOMDocument;
    xSql: String;
begin
  xSql := GBaseTemlatesList.ExpandTemplates(FreportDef.queryText, Self);
  if Fparams.RebuildStringWithParams(xSql) then begin
    xQuery := GDataProvider.OpenSql(xSql, False);
    if xQuery <> Nil then begin
      FreportText.Text := GetRowsAsXml(xQuery.Recordset);
      xXml := GetDocumentFromString(FreportText.Text);
      try
        FreportText.Text := xXml.transformNode(FxsltDoc);
      except
        on E: Exception do begin
          FErrorText := 'Podczas transformacji za pomocπ arkusza styli wystπpi≥ b≥πd. Sprawdz definicjÍ raportu pod kπtem poprawnoúci sk≥adniowej arkusza stylÛw.';
          FAddText := E.Message;
        end;
      end;
      xQuery.Free;
      if FErrorText = '' then begin
        FreportText.Text := GBaseTemlatesList.ExpandTemplates(FreportText.Text, Self);
        TCHtmlReportForm(FForm).CBrowser.LoadFromString(FreportText.Text);
      end;
    end else begin
      FErrorText := 'Podczas wykonywania zapytania tworzπcego raport wystπpi≥ b≥πd. Sprawdz definicjÍ raportu\n' +
                    'pod kπtem poprawnoúci sk≥adniowej zapytania oraz definicjÍ parametrÛw i mnemonikÛw.';
      FAddText := GDataProvider.LastError;
    end;
  end;
  Fparams.Free;
end;

procedure TSimpleReportDialog.PrepareReportContent;
begin
  FreportText.Text := GBaseTemlatesList.ExpandTemplates(TSimpleReportParams(FParams).reportText, Self);
end;

function TReportDialogParamsDefs.AddParam(AParam: TReportDialgoParamDef): Integer;
begin
  Result :=Add(AParam);
  if Fgroups.IndexOf(AParam.group) = -1 then begin
    Fgroups.Add(AParam.group);
  end;
end;

constructor TReportDialogParamsDefs.Create;
begin
  inherited Create(True);
  Fgroups := TStringList.Create;
end;

destructor TReportDialogParamsDefs.Destroy;
begin
  Fgroups.Free;
  inherited Destroy;
end;

function TReportDialogParamsDefs.GetAsString: String;
var xXml: IXMLDOMDocument;
    xRoot: IXMLDOMNode;
    xNode: IXMLDOMNode;
    xCount: Integer;
begin
  xXml := GetXmlDocument;
  xRoot := xXml.createElement('paramsDefs');
  xXml.appendChild(xRoot);
  for xCount := 0 to Count - 1 do begin
    xNode := xXml.createElement('paramDef');
    xRoot.appendChild(xNode);
    TReportDialgoParamDef(Items[xCount]).SaveToXml(xNode);
  end;
  FasString := GetStringFromDocument(xXml);
  Result := FasString;
end;

function TReportDialogParamsDefs.GetByName(AName: String): TReportDialgoParamDef;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if (Items[xCount].name = AName) then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TReportDialogParamsDefs.GetItems(AIndex: Integer): TReportDialgoParamDef;
begin
  Result := TReportDialgoParamDef(inherited Items[AIndex]);
end;

function TReportDialogParamsDefs.RebuildStringWithParams(var AString: String): Boolean;
begin
  Result := True;
end;

procedure TReportDialogParamsDefs.RemoveParam(AParam: TReportDialgoParamDef);
var xGroup: String;
    xCount: Integer;
    xFound: Boolean;
begin
  xGroup := AParam.group;
  Remove(AParam);
  xCount := 0;
  xFound := False;
  while (not xFound) and (xCount <= Count - 1) do begin
    xFound := xGroup = Items[xCount].group;
    Inc(xCount);
  end;
  if not xFound then begin
    Fgroups.Delete(Fgroups.IndexOf(xGroup));
  end;
end;

procedure TReportDialogParamsDefs.SetAsString(const Value: String);
var xXml: IXMLDOMDocument;
    xCount: Integer;
    xParam: TReportDialgoParamDef;
begin
  Clear;
  FasString := Value;
  if FasString <> '' then begin
    xXml := GetDocumentFromString(FasString);
    if xXml.parseError.errorCode = 0 then begin
      if xXml.documentElement <> Nil then begin
        for xCount := 0 to xXml.documentElement.childNodes.length - 1 do begin
          xParam := TReportDialgoParamDef.Create(Self);
          xParam.LoadFromXml(xXml.documentElement.childNodes.item[xCount]);
          AddParam(xParam);
        end;
      end;
    end;
  end;
end;

constructor TReportDialgoParamDef.Create(AParentParamsDefs: TReportDialogParamsDefs);
begin
  inherited Create;
  FparentParamsDefs := AParentParamsDefs;
  SetLength(FparamValues, 0);
  FisRequired := True;
  FframeType := CFRAMETYPE_UNKNOWN;
end;

function TReportDialgoParamDef.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 0 then begin
    Result := Fgroup;
  end else begin
    Result := Fname;
  end;
end;

function TReportDialgoParamDef.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdesc;
end;

function TReportDialgoParamDef.GetElementId: String;
begin
  Result := name;
end;

function TReportDialgoParamDef.GetElementType: String;
begin
  Result := '';
end;

function TReportDialgoParamDef.GetParamValuesLength: Integer;
begin
  Result := Length(FparamValues);
end;

procedure TReportDialgoParamDef.LoadFromXml(ANode: IXMLDOMNode);
begin
  Fname := GetXmlAttribute('name', ANode, '');
  Fdesc := GetXmlAttribute('desc', ANode, '');
  Fgroup := GetXmlAttribute('group', ANode, '');
  FisRequired := GetXmlAttribute('isRequired', ANode, True);
  FparamType := GetXmlAttribute('type', ANode, '');
  FframeType := GetXmlAttribute('frame', ANode, CFRAMETYPE_UNKNOWN);
end;

procedure TReportDialgoParamDef.SaveToXml(ANode: IXMLDOMNode);
begin
  SetXmlAttribute('name', ANode, Fname);
  SetXmlAttribute('desc', ANode, Fdesc);
  SetXmlAttribute('group', ANode, Fgroup);
  SetXmlAttribute('type', ANode, FparamType);
  SetXmlAttribute('isRequired', ANode, FisRequired);
  SetXmlAttribute('frame', ANode, FframeType);
end;

procedure TReportDialogParamsDefs.SetItems(AIndex: Integer; const Value: TReportDialgoParamDef);
begin
  inherited Items[AIndex] := Value;
end;

function TReportDialogParamsDefs.ShowParamsDefsList(AChoice: Boolean): String;
var xText: String;
begin
  if not TCFrameForm.ShowFrame(TCParamsDefsFrame, Result, xText, Self, Nil, Nil, Nil, AChoice) then begin
    Result := '';
  end;
end;

procedure TReportDialgoParamDef.SetparamValues(const Value: TVariantDynArray);
var xCount: Integer;
begin
  SetLength(FparamValues, Length(Value));
  for xCount := Low(Value) to High(Value) do begin
    FparamValues[xCount] := Value[xCount];
  end;
end;

initialization
  LDefaultXsl := Nil;
finalization
  LDefaultXsl := Nil;
end.


