unit CPreferences;

interface

uses Classes, Graphics, Contnrs, Math, Windows, CTemplates, GraphUtil, CXml, CComponents, SysUtils, Types, SHDocVw,
     Variants, StrUtils, MsHtml;

type
  TBackupPref = class(TPrefItem)
  private
    FlastBackup: TDateTime;
  public
    function GetNodeName: String; override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    constructor CreateBackupPref(AFilename: String; ALastBackup: TDateTime);
    property lastBackup: TDateTime read FlastBackup write FlastBackup;
  end;

  TPluginPref = class(TPrefItem)
  private
    Fconfiguration: String;
    FpermitGetConnection: Integer;
    FisEnabled: Boolean;
  public
    function GetNodeName: String; override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    constructor CreatePluginPref(AFilename: String; AConfiguration: String);
    procedure Clone(APrefItem: TPrefItem); override;
    property configuration: String read Fconfiguration write Fconfiguration;
    property permitGetConnection: Integer read FpermitGetConnection write FpermitGetConnection;
    property isEnabled: Boolean read FisEnabled write FisEnabled;
  end;

  TBackupThread = class(TThread)
  private
    FFilein: String;
    FTempfile: String;
    FReport: TStringList;
    FIsRunning: Boolean;
    FIsError: Boolean;
    FInfoTimeout: Integer;
    procedure Progress(AStepBy: Integer);
    procedure AddToReport(AText: String);
  protected
    function PrepareFile: Boolean;
    procedure Execute; override;
  public
    constructor Create(AFilein: String; AInfoTimeout: Integer = 3000);
    procedure WaitFor(AWaitForStart: Boolean);
    property Report: TStringList read FReport;
    property IsRunning: Boolean read FIsRunning;
    property IsError: Boolean read FIsError;
    destructor Destroy; override;
  end;

  TChartPref = class(TPrefItem)
  private
    Fview: Integer;
    Flegend: Integer;
    Fvalues: Integer;
    Fdepth: Integer;
    Fzoom: Integer;
    Frotate: Integer;
    Felevation: Integer;
    Fperspective: Integer;
    Ftilt: Integer;
    FisAvg: Boolean;
    FisReg: Boolean;
    FisGeo: Boolean;
    FisWeight: Boolean;
    FisMed: Boolean;
    FisRes: Boolean;
    FisSup: Boolean;
  public
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    function GetNodeName: String; override;
  published
    property view: Integer read Fview write Fview;
    property legend: Integer read Flegend write Flegend;
    property values: Integer read Fvalues write Fvalues;
    property depth: Integer read Fdepth write Fdepth;
    property zoom: Integer read Fzoom write Fzoom;
    property rotate: Integer read Frotate write Frotate;
    property elevation: Integer read Felevation write Felevation;
    property perspective: Integer read Fperspective write Fperspective;
    property tilt: Integer read Ftilt write Ftilt;
    property isAvg: Boolean read FisAvg write FisAvg;
    property isReg: Boolean read FisReg write FisReg;
    property isGeo: Boolean read FisGeo write FisGeo;
    property isWeight: Boolean read FisWeight write FisWeight;
    property isMed: Boolean read FisMed write FisMed;
    property isRes: Boolean read FisRes write FisRes;
    property isSup: Boolean read FisSup write FisSup;
  end;

  TFramePref = class(TPrefItem)
  public
    function GetNodeName: String; override;
  end;

  TFrameWithSumlistPref = class(TFramePref)
  private
    FsumListVisible: Boolean;
    FsumListHeight: Integer;
  public
    property sumListVisible: Boolean read FsumListVisible write FsumListVisible;
    property sumListHeight: Integer read FsumListHeight write FsumListHeight;
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    constructor Create(APrefname: String); override;
  end;

  TBaseMovementFramePref = class(TFrameWithSumlistPref)
  private
    FpatternsListVisible: Boolean;
    FpatternListWidth: Integer;
    FuserPatternsVisible: Boolean;
    FstatisticPatternsVisible: Boolean;
  public
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    constructor Create(APrefname: String); override;
    property patternsListVisible: Boolean read FpatternsListVisible write FpatternsListVisible;
    property patternListWidth: Integer read FpatternListWidth write FpatternListWidth;
    property userPatternsVisible: Boolean read FuserPatternsVisible write FuserPatternsVisible;
    property statisticPatternsVisible: Boolean read FstatisticPatternsVisible write FstatisticPatternsVisible;
  end;

  TBasePref = class(TPrefItem, IDescTemplateExpander)
  private
    FstartupDatafileMode: Integer;
    FstartupDatafileName: String;
    FlastOpenedDatafilename: String;
    FshowShortcutBar: Boolean;
    FshortcutBarSmall: Boolean;
    FhomeListSmall: Boolean;
    FfilterDetailSmall: Boolean;
    FchartListSmall: Boolean;
    FshowStatusBar: Boolean;
    FstartupInfo: Boolean;
    FstartupInfoType: Integer;
    FstartupInfoDays: Integer;
    FstartupInfoIn: Boolean;
    FstartupInfoOldIn: Boolean;
    FstartupInfoOut: Boolean;
    FstartupInfoOldOut: Boolean;
    FstartupInfoTran: Boolean;
    FstartupInfoOldTran: Boolean;
    FstartupInfoAlways: Boolean;
    FstartupInfoOldDays: Integer;
    FstartupCheckUpdates: Boolean;
    FstartupInfoSurpassedLimit: Boolean;
    FstartupInfoValidLimits: Boolean;
    FworkDays: String;
    FbackupAction: Integer;
    FbackupOnStart: Boolean;
    FbackupDaysOld: Integer;
    FbackupDirectory: String;
    FbackupFileName: String;
    FbackupOverwrite: Boolean;
    FstartupUncheckedExtractions: Boolean;
    FevenListColor: TColor;
    FoddListColor: TColor;
    FconfigFileVersion: String;
    FlistAsReportUseColors: Boolean;
    FlistAsReportUseFonts: Boolean;
  public
    function GetBackupfilename: String;
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    function GetNodeName: String; override;
    procedure Clone(APrefItem: TPrefItem); override;
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function GetFramePrefitemClass(APrefname: String): TPrefItemClass;
  public
    function ExpandTemplate(ATemplate: String): String; virtual;
  published
    property startupDatafileMode: Integer read FstartupDatafileMode write FstartupDatafileMode;
    property startupDatafileName: String read FstartupDatafileName write FstartupDatafileName;
    property lastOpenedDatafilename: String read FlastOpenedDatafilename write FlastOpenedDatafilename;
    property showShortcutBar: Boolean read FshowShortcutBar write FshowShortcutBar;
    property shortcutBarSmall: Boolean read FshortcutBarSmall write FshortcutBarSmall;
    property homeListSmall: Boolean read FhomeListSmall write FhomeListSmall;
    property chartListSmall: Boolean read FchartListSmall write FchartListSmall;
    property filterDetailSmall: Boolean read FfilterDetailSmall write FfilterDetailSmall;
    property showStatusBar: Boolean read FshowStatusBar write FshowStatusBar;
    property startupInfo: Boolean read FstartupInfo write FstartupInfo;
    property startupInfoType: Integer read FstartupInfoType write FstartupInfoType;
    property startupInfoDays: Integer read FstartupInfoDays write FstartupInfoDays;
    property startupInfoIn: Boolean read FstartupInfoIn write FstartupInfoIn;
    property startupInfoOut: Boolean read FstartupInfoOut write FstartupInfoOut;
    property startupInfoTran: Boolean read FstartupInfoTran write FstartupInfoTran;
    property startupInfoOldIn: Boolean read FstartupInfoOldIn write FstartupInfoOldIn;
    property startupInfoOldOut: Boolean read FstartupInfoOldOut write FstartupInfoOldOut;
    property startupInfoOldTran: Boolean read FstartupInfoOldTran write FstartupInfoOldTran;
    property startupInfoAlways: Boolean read FstartupInfoAlways write FstartupInfoAlways;
    property startupCheckUpdates: Boolean read FstartupCheckUpdates write FstartupCheckUpdates;
    property startupInfoSurpassedLimit: Boolean read FstartupInfoSurpassedLimit write FstartupInfoSurpassedLimit;
    property startupInfoValidLimits: Boolean read FstartupInfoValidLimits write FstartupInfoValidLimits;
    property startupUncheckedExtractions: Boolean read FstartupUncheckedExtractions write FstartupUncheckedExtractions;
    property startupInfoOldDays: Integer read FstartupInfoOldDays write FstartupInfoOldDays;
    property workDays: String read FworkDays write FworkDays;
    property backupOnStart: Boolean read FbackupOnStart write FbackupOnStart;
    property backupAction: Integer read FbackupAction write FbackupAction;
    property backupDaysOld: Integer read FbackupDaysOld write FbackupDaysOld;
    property backupDirectory: String read FbackupDirectory write FbackupDirectory;
    property backupFileName: String read FbackupFileName write FbackupFileName;
    property backupOverwrite: Boolean read FbackupOverwrite write FbackupOverwrite;
    property evenListColor: TColor read FevenListColor write FevenListColor;
    property oddListColor: TColor read FoddListColor write FoddListColor;
    property configFileVersion: String read FconfigFileVersion write FconfigFileVersion;
    property listAsReportUseColors: Boolean read FlistAsReportUseColors write FlistAsReportUseColors;
    property listAsReportUseFonts: Boolean read FlistAsReportUseFonts write FlistAsReportUseFonts;
  end;

  TDescPatterns = class(TStringList)
  private
    FSaveToDatabase: Boolean;
  public
    constructor Create(ASaveToDatabase: Boolean);
    function GetPattern(AName, ADefault: String): String;
    procedure SetPattern(AName, APattern: String);
    function GetPatternOperation(AName: String): Integer;
    function GetPatternType(AName: String): Integer;
  end;

var GViewsPreferences: TPrefList;
    GChartPreferences: TPrefList;
    GFramePreferences: TPrefList;
    GColumnsPreferences: TPrefList;
    GBackupsPreferences: TPrefList;
    GPluginsPreferences: TPrefList;
    GBasePreferences: TBasePref;
    GDescPatterns: TDescPatterns;
    GBackupThread: TBackupThread;

function GetWorkDay(ADate: TDateTime; AForward: Boolean): TDateTime;
function GetDefaultViewPreferences: TPrefList;
function UpdateConfiguration(AFromConfigVersion: String): Boolean;
procedure SetInterfaceIcons(ASmall: Boolean);
function GetDatafileDefaultFilename: String;

implementation

uses CSettings, CMovementFrameUnit, CConsts, CDatabase, DateUtils, CBackups, CTools, Forms, CPlannedFrameUnit,
     CDoneFrameUnit, CStartupInfoFrameUnit, CExtractionsFrameUnit, CBaseFormUnit, CBaseFrameUnit, CReportsFrameUnit,
     CDescTemplatesFrameUnit, CInfoFormUnit, CHtmlMemoFormUnit, CReports, ShlObj,
  CPlugins;

const CPrivateDefaultFilename = 'CManager.dat';

procedure SetInterfaceIcons(ASmall: Boolean);
var xCount: Integer;
begin
  GBasePreferences.shortcutBarSmall := ASmall;
  GBasePreferences.homeListSmall := ASmall;
  GBasePreferences.filterDetailSmall := ASmall;
  GBasePreferences.chartListSmall := ASmall;
  for xCount := 0 to GViewsPreferences.Count - 1 do begin
    TViewPref(GViewsPreferences.Items[xCount]).ButtonSmall := ASmall;
  end;
end;

procedure MoveFilesToProfile(ADelete: Boolean);
begin
  if CopyFile(PChar(GetSettingsFilename(False)), PChar(GetSettingsFilename(True)), False) and ADelete then begin
    DeleteFile(PChar(GetSettingsFilename(False)));
  end;
  if CopyFile(PChar(GetCSSReportFile(False)), PChar(GetCSSReportFile(True)), False) and ADelete then begin
    DeleteFile(PChar(GetCSSReportFile(False)));
  end;
  if CopyFile(PChar(GetXSLReportFile(False)), PChar(GetXSLReportFile(True)), False) and ADelete then begin
    DeleteFile(PChar(GetXSLReportFile(False)));
  end;
  if CopyFile(PChar(GetHTMReportFile(False)), PChar(GetHTMReportFile(True)), False) and ADelete then begin
    DeleteFile(PChar(GetHTMReportFile(False)));
  end;
end;

procedure SendMessageToMainForm(AMsg: Integer; AWParam: Integer; ALParam: Integer);
begin
  if Application.MainForm <> Nil then begin
    PostMessage(Application.MainForm.Handle, AMsg, AWParam, ALParam);
  end;
end;

procedure TBasePref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FstartupDatafileMode := TBasePref(APrefItem).startupDatafileMode;
  FstartupDatafileName := TBasePref(APrefItem).startupDatafileName;
  FlastOpenedDatafilename := TBasePref(APrefItem).lastOpenedDatafilename;
  FshowShortcutBar := TBasePref(APrefItem).showShortcutBar;
  FshortcutBarSmall := TBasePref(APrefItem).shortcutBarSmall;
  FhomeListSmall := TBasePref(APrefItem).homeListSmall;
  FfilterDetailSmall := TBasePref(APrefItem).filterDetailSmall;
  FchartListSmall := TBasePref(APrefItem).chartListSmall;
  FshowStatusBar := TBasePref(APrefItem).showStatusBar;
  FstartupInfo := TBasePref(APrefItem).startupInfo;
  FstartupInfoType := TBasePref(APrefItem).startupInfoType;
  FstartupInfoDays := TBasePref(APrefItem).startupInfoDays;
  FstartupInfoIn := TBasePref(APrefItem).startupInfoIn;
  FstartupInfoOut := TBasePref(APrefItem).startupInfoOut;
  FstartupInfoTran := TBasePref(APrefItem).startupInfoTran;
  FstartupInfoOldTran := TBasePref(APrefItem).startupInfoOldTran;
  FstartupInfoAlways := TBasePref(APrefItem).startupInfoAlways;
  FstartupInfoOldIn := TBasePref(APrefItem).startupInfoOldIn;
  FstartupInfoOldOut := TBasePref(APrefItem).startupInfoOldOut;
  FstartupCheckUpdates := TBasePref(APrefItem).startupCheckUpdates;
  FstartupInfoSurpassedLimit := TBasePref(APrefItem).startupInfoSurpassedLimit;
  FstartupInfoValidLimits := TBasePref(APrefItem).startupInfoValidLimits;
  FworkDays := TBasePref(APrefItem).workDays;
  FbackupAction := TBasePref(APrefItem).backupAction;
  FbackupOnStart := TBasePref(APrefItem).backupOnStart;
  FbackupDaysOld := TBasePref(APrefItem).backupDaysOld;
  FbackupDirectory := TBasePref(APrefItem).backupDirectory;
  FbackupFileName := TBasePref(APrefItem).backupFileName;
  FbackupOverwrite := TBasePref(APrefItem).backupOverwrite;
  FstartupUncheckedExtractions := TBasePref(APrefItem).startupUncheckedExtractions;
  FevenListColor := TBasePref(APrefItem).evenListColor;
  FoddListColor := TBasePref(APrefItem).oddListColor;
  FstartupInfoOldDays := TBasePref(APrefItem).startupInfoOldDays;
  FlistAsReportUseColors := TBasePref(APrefItem).listAsReportUseColors;
  FlistAsReportUseFonts := TBasePref(APrefItem).listAsReportUseFonts;
end;

function TBasePref.ExpandTemplate(ATemplate: String): String;
begin
  Result := '<nieznana>';
  if ATemplate = '@godz@' then begin
    Result := LPad(IntToStr(HourOf(Now)), '0', 2);
  end else if ATemplate = '@min@' then begin
    Result := LPad(IntToStr(MinuteOf(Now)), '0', 2);
  end else if ATemplate = '@czas@' then begin
    Result := GetFormattedTime(Now, 'HH:mm');
  end else if ATemplate = '@dzien@' then begin
    Result := LPad(IntToStr(DayOf(Now)), '0', 2);
  end else if ATemplate = '@miesiac@' then begin
    Result := LPad(IntToStr(MonthOf(Now)), '0', 2);
  end else if ATemplate = '@rok@' then begin
    Result := IntToStr(YearOf(Now));
  end else if ATemplate = '@rokkrotki@' then begin
    Result := Copy(IntToStr(YearOf(Now)), 3, 2);
  end else if ATemplate = '@dzientygodnia@' then begin
    Result := IntToStr(DayOfTheWeek(Now));
  end else if ATemplate = '@nazwadnia@' then begin
    Result := GetFormattedDate(Now, 'dddd');
  end else if ATemplate = '@nazwamiesiaca@' then begin
    Result := GetFormattedDate(Now, 'MMMM');
  end else if ATemplate = '@data@' then begin
    Result := GetFormattedDate(Now, 'yyyy-MM-dd');
  end else if ATemplate = '@dataczas@' then begin
    Result := GetFormattedDate(Now, 'yyyy-MM-dd') + ' ' + GetFormattedTime(Now, 'HH:mm');
  end else if ATemplate = '@wersja@' then begin
    Result := FileVersion(ParamStr(0));
  end else if ATemplate = '@kataloginstalacji@' then begin
    Result := GetSystemPathname('');
  end else if ATemplate = '@kataloguzytkownika@' then begin
    Result := GetUserProfilePathname('');
  end;
end;

function TBasePref.GetBackupfilename: String;
begin
  Result := IncludeTrailingPathDelimiter(backupDirectory) + GBaseTemlatesList.ExpandTemplates(FbackupFileName, Self);
end;

function TBasePref.GetFramePrefitemClass(APrefname: String): TPrefItemClass;
begin
  if APrefname = 'baseMovement' then begin
    Result := TBaseMovementFramePref;
  end else if APrefname = 'plannedDone' then begin
    Result := TFrameWithSumlistPref;
  end else begin
    Result := TFramePref;
  end;
end;

function TBasePref.GetNodeName: String;
begin
  Result := 'basepref';
end;

procedure TBasePref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  FstartupDatafileMode := GetXmlAttribute('startupfilemode', ANode, CStartupFilemodeThisfile);
  FstartupDatafileName := GetXmlAttribute('startupfilename', ANode, GetDatafileDefaultFilename);
  FlastOpenedDatafilename := GetXmlAttribute('lastopenedfilename', ANode, '');
  FshowShortcutBar := GetXmlAttribute('showShortcutBar', ANode, True);
  FshortcutBarSmall := GetXmlAttribute('shortcutBarSmall', ANode, False);
  FhomeListSmall := GetXmlAttribute('homeListSmall', ANode, False);
  FfilterDetailSmall := GetXmlAttribute('filterDetailSmall', ANode, False);
  FchartListSmall := GetXmlAttribute('chartListSmall', ANode, False);
  FshowStatusBar := GetXmlAttribute('showStatusBar', ANode, True);
  FstartupInfo := GetXmlAttribute('startupInfo', ANode, False);
  FstartupInfoType := GetXmlAttribute('startupInfoType', ANode, CStartupInfoToday);
  FstartupInfoDays := GetXmlAttribute('startupInfoDays', ANode, 1);
  FstartupInfoIn := GetXmlAttribute('startupInfoIn', ANode, True);
  FstartupInfoOut := GetXmlAttribute('startupInfoOut', ANode, True);
  FstartupInfoTran := GetXmlAttribute('startupInfoTran', ANode, True);
  FstartupInfoOldIn := GetXmlAttribute('startupInfoOldIn', ANode, True);
  FstartupInfoOldOut := GetXmlAttribute('startupInfoOldOut', ANode, True);
  FstartupInfoOldTran := GetXmlAttribute('startupInfoOldTran', ANode, True);
  FstartupInfoAlways := GetXmlAttribute('startupInfoAlways', ANode, True);
  FstartupCheckUpdates := GetXmlAttribute('startupCheckUpdates', ANode, False);
  FstartupInfoSurpassedLimit := GetXmlAttribute('startupInfoSurpassedLimit', ANode, False);
  FstartupInfoValidLimits := GetXmlAttribute('startupInfoValidLimits', ANode, False);
  FstartupInfoOldDays := GetXmlAttribute('startupInfoOldDays', ANode, 90);
  FworkDays := GetXmlAttribute('workDays', ANode, '+++++--');
  if Length(FworkDays) <> 7 then begin
    FworkDays := '+++++--';
  end;
  FbackupAction := GetXmlAttribute('backupAction', ANode, CBackupActionAsk);
  FbackupOnStart := GetXmlAttribute('backupOnStart', ANode, True);
  FbackupDaysOld := GetXmlAttribute('backupDaysOld', ANode, 7);
  FbackupDirectory := GetXmlAttribute('backupDirectory', ANode, ExpandFileName(ExtractFilePath(GetUserProfilePathname(''))));
  FbackupFileName := GetXmlAttribute('backupFilename', ANode, '@data@.cmb');
  FbackupOverwrite := GetXmlAttribute('backupOverwrite', ANode, False);
  FstartupUncheckedExtractions := GetXmlAttribute('startupUncheckedExtractions', ANode, False);
  FevenListColor := StringToColor(GetXmlAttribute('evenListColor', ANode, ColorToString(clWindow)));
  FoddListColor := StringToColor(GetXmlAttribute('oddListColor', ANode, ColorToString(GetDarkerColor(FevenListColor))));
  FlistAsReportUseColors := GetXmlAttribute('listAsReportUseColors', ANode, False);
  FlistAsReportUseFonts := GetXmlAttribute('listAsReportUseFonts', ANode, False);
end;

function TBasePref.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  if GetInterface(IID, Obj) then begin
    Result := 0
  end else begin
    Result := E_NOINTERFACE;
  end;
end;

procedure TBasePref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('startupfilemode', ANode, FstartupDatafileMode);
  SetXmlAttribute('startupfilename', ANode, FstartupDatafileName);
  SetXmlAttribute('lastopenedfilename', ANode, FlastOpenedDatafilename);
  SetXmlAttribute('showShortcutBar', ANode, FshowShortcutBar);
  SetXmlAttribute('homeListSmall', ANode, FhomeListSmall);
  SetXmlAttribute('filterDetailSmall', ANode, FfilterDetailSmall);
  SetXmlAttribute('chartListSmall', ANode, FchartListSmall);
  SetXmlAttribute('shortcutBarSmall', ANode, FshortcutBarSmall);
  SetXmlAttribute('showStatusBar', ANode, FshowStatusBar);
  SetXmlAttribute('startupInfo', ANode, FstartupInfo);
  SetXmlAttribute('startupInfoType', ANode, FstartupInfoType);
  SetXmlAttribute('startupInfoDays', ANode, FstartupInfoDays);
  SetXmlAttribute('startupInfoIn', ANode, FstartupInfoIn);
  SetXmlAttribute('startupInfoTran', ANode, FstartupInfoTran);
  SetXmlAttribute('startupInfoOut', ANode, FstartupInfoOut);
  SetXmlAttribute('startupInfoOldIn', ANode, FstartupInfoOldIn);
  SetXmlAttribute('startupInfoOldOut', ANode, FstartupInfoOldOut);
  SetXmlAttribute('startupInfoOldTran', ANode, FstartupInfoOldTran);
  SetXmlAttribute('startupInfoAlways', ANode, FstartupInfoAlways);
  SetXmlAttribute('startupCheckUpdates', ANode, FstartupCheckUpdates);
  SetXmlAttribute('startupInfoSurpassedLimit', ANode, FstartupInfoSurpassedLimit);
  SetXmlAttribute('startupInfoValidLimits', ANode, FstartupInfoValidLimits);
  SetXmlAttribute('workDays', ANode, FworkDays);
  SetXmlAttribute('backupAction', ANode, FbackupAction);
  SetXmlAttribute('backupOnStart', ANode, FbackupOnStart);
  SetXmlAttribute('backupDaysOld', ANode, FbackupDaysOld);
  SetXmlAttribute('backupDirectory', ANode, FbackupDirectory);
  SetXmlAttribute('backupFilename', ANode, FbackupFileName);
  SetXmlAttribute('backupOverwrite', ANode, FbackupOverwrite);
  SetXmlAttribute('startupUncheckedExtractions', ANode, FstartupUncheckedExtractions);
  SetXmlAttribute('evenListColor', ANode, ColorToString(FevenListColor));
  SetXmlAttribute('oddListColor', ANode, ColorToString(FoddListColor));
  SetXmlAttribute('startupInfoOldDays', ANode, FstartupInfoOldDays);
  SetXmlAttribute('listAsReportUseColors', ANode, FlistAsReportUseColors);
  SetXmlAttribute('listAsReportUseFonts', ANode, FlistAsReportUseFonts);
end;

constructor TDescPatterns.Create(ASaveToDatabase: Boolean);
begin
  inherited Create;
  FSaveToDatabase := ASaveToDatabase;
end;

function TDescPatterns.GetPattern(AName, ADefault: String): String;
begin
  if IndexOfName(AName) > -1 then begin
    Result := Values[AName];
  end else begin
    Result := GDataProvider.GetCmanagerParam(AName, ADefault);
    Values[AName] := Result;
  end;
end;

function TDescPatterns.GetPatternOperation(AName: String): Integer;
var xO, xT: Integer;
begin
  xO := Low(CDescPatternsKeys);
  Result := -1;
  while (xO <= High(CDescPatternsKeys)) and (Result = -1) do begin
    xT := Low(CDescPatternsKeys[xO]);
    while (xT <= High(CDescPatternsKeys[xO])) and (Result = -1) do begin
      if CDescPatternsKeys[xO][xT] = AName then begin
        Result := xO;
      end;
      Inc(xT);
    end;
    Inc(xO);
  end;
end;

function TDescPatterns.GetPatternType(AName: String): Integer;
var xO, xT: Integer;
begin
  xO := Low(CDescPatternsKeys);
  Result := -1;
  while (xO <= High(CDescPatternsKeys)) and (Result = -1) do begin
    xT := Low(CDescPatternsKeys[xO]);
    while (xT <= High(CDescPatternsKeys[xO])) and (Result = -1) do begin
      if CDescPatternsKeys[xO][xT] = AName then begin
        Result := xT;
      end;
      Inc(xT);
    end;
    Inc(xO);
  end;
end;

procedure TDescPatterns.SetPattern(AName, APattern: String);
begin
  Values[AName] := APattern;
  if FSaveToDatabase then begin
    GDataProvider.SetCmanagerParam(AName, APattern);
  end;
end;

constructor TBackupPref.CreateBackupPref(AFilename: String; ALastBackup: TDateTime);
begin
  inherited Create(AFilename);
  FlastBackup := ALastBackup;
end;

function TBackupPref.GetNodeName: String;
begin
  Result := 'backuppref';
end;

procedure TBackupPref.LoadFromXml(ANode: ICXMLDOMNode);
var xDateStr: String;
    xY, xM, xD, xH, xN, xS: Word;
    xTime: TDateTime;
begin
  inherited LoadFromXml(ANode);
  xDateStr := GetXmlAttribute('lastBackup', ANode, '');
  FlastBackup := 0;
  if xDateStr <> '' then begin
    xD := StrToIntDef(Copy(xDateStr, 1, 2), 0);
    xM := StrToIntDef(Copy(xDateStr, 3, 2), 0);
    xY := StrToIntDef(Copy(xDateStr, 5, 4), 0);
    xH := StrToIntDef(Copy(xDateStr, 9, 2), 0);
    xN := StrToIntDef(Copy(xDateStr, 11, 2), 0);
    xS := StrToIntDef(Copy(xDateStr, 13, 2), 0);
    TryEncodeDate(xY, xM, xD, FlastBackup);
    TryEncodeTime(xH, xN, xS, 0, xTime);
    FlastBackup := FlastBackup + xTime;
  end;
end;

procedure TBackupPref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('lastBackup', ANode, FormatDateTime('ddmmyyyyhhnnss', FlastBackup));
end;

function GetWorkDay(ADate: TDateTime; AForward: Boolean): TDateTime;
var xDay: Integer;
begin
  xDay := DayOfTheWeek(ADate);
  if GBasePreferences.workDays[xDay] = '+' then begin
    Result := ADate;
  end else begin
    Result := GetWorkDay(IncDay(ADate, IfThen(AForward, 1, -1)), AForward);
  end;
end;

procedure TBackupThread.AddToReport(AText: String);
begin
  FReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AText);
end;

constructor TBackupThread.Create(AFilein: String; AInfoTimeout: Integer = 3000);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FFilein := AFilein;
  FInfoTimeout := AInfoTimeout;
  FTempfile := '';
  SetThreadPriority(Handle, THREAD_PRIORITY_BELOW_NORMAL);
  FReport := TStringList.Create;
  Resume;
end;

destructor TBackupThread.Destroy;
begin
  FReport.Free;
  inherited Destroy;
end;

procedure TBackupThread.Execute;
var xBackupname: String;
    xBackupPref: TBackupPref;
    xOk: Boolean;
    xText: String;
begin
  FIsRunning := True;
  SendMessageToMainForm(WM_STATBACKUPSTARTED, 0, 0);
  xOk := False;
  if PrepareFile then begin
    xBackupname := GBasePreferences.GetBackupfilename;
    AddToReport('Rozpoczêto tworzenie kopii pliku danych ' +  FFilein);
    if CmbBackup(FTempfile, xBackupname, GBasePreferences.backupOverwrite, xText, Progress) then begin
      xBackupPref := TBackupPref(GBackupsPreferences.ByPrefname[FFilein]);
      if xBackupPref = Nil then begin
        xBackupPref := TBackupPref.CreateBackupPref(FFilein, Now);
        GBackupsPreferences.Add(xBackupPref, True);
      end else begin
        xBackupPref.lastBackup := Now;
      end;
      xOk := True;
      AddToReport('Wykonano poprawnie kopiê pliku danych ' +  FFilein);
      AddToReport('Kopia znajduje siê w pliku ' +  xBackupname);
    end else begin
      AddToReport('Podczas tworzenia kopii pliku danych ' + FFilein + ' wyst¹pi³ b³¹d');
      AddToReport(xText);
      AddToReport('Kopia nie zosta³a utworzona');
    end;
    if DeleteFile(FTempfile) then begin
      AddToReport('Usuniêto utworzony plik tymczasowy');
    end else begin
      AddToReport('Nie uda³o siê usun¹æ utworzonego pliku tymczasowego');
    end;
  end;
  if not xOk then begin
    SendMessageToMainForm(WM_STATBACKUPFINISHEDERR, 0, 0);
    FIsError := True;
  end else begin
    SendMessageToMainForm(WM_STATBACKUPFINISHEDSUCC, 0, 0);
    if FInfoTimeout > 0 then begin
      WaitForSingleObject(Handle, FInfoTimeout);
    end;
    SendMessageToMainForm(WM_STATCLEAR, 0, 0);
    FIsError := False;
  end;
  FIsRunning := False;
end;

function TBackupThread.PrepareFile: Boolean;
begin
  FTempfile := FormatDateTime('yyyymmddhhnnss', Now) + ExtractFileExt(FFilein);
  AddToReport('Rozpoczêto tworzenie pliku tymczasowego');
  Result := CopyFile(PChar(FFilein), PChar(FTempfile), False);
  if not Result then begin
    AddToReport('Podczas tworzenia pliku tymczasowego wyst¹pi³ b³¹d');
    AddToReport(SysErrorMessage(GetLastError));
  end else begin
    AddToReport('Utworzono plik tymczasowy ' + FTempfile);
  end;
end;

function TBasePref._AddRef: Integer;
begin
  Result := 0;
end;

function TBasePref._Release: Integer;
begin
  Result := 0;
end;

procedure TBackupThread.Progress(AStepBy: Integer);
begin
  SendMessageToMainForm(WM_STATPROGRESS, 0, AStepBy);
end;

procedure TBackupThread.WaitFor(AWaitForStart: Boolean);
begin
  while not FIsRunning do begin
    Application.ProcessMessages;
    Sleep(10);
  end;
  while FIsRunning do begin
    Application.ProcessMessages;
    Sleep(10);
  end;
end;

procedure TPluginPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  Fconfiguration := TPluginPref(APrefItem).configuration;
  FpermitGetConnection := TPluginPref(APrefItem).permitGetConnection;
  FisEnabled := TPluginPref(APrefItem).isEnabled;
end;

constructor TPluginPref.CreatePluginPref(AFilename, AConfiguration: String);
begin
  inherited Create(AFilename);
  Fconfiguration := AConfiguration;
  FpermitGetConnection := 0;
  FisEnabled := True;
end;

function TPluginPref.GetNodeName: String;
begin
  Result := 'pluginpref';
end;

procedure TPluginPref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  Fconfiguration := GetXmlAttribute('configuration', ANode, '');
  FpermitGetConnection := GetXmlAttribute('permitGetConnection', ANode, 0);
  FisEnabled := GetXmlAttribute('isEnabeld', ANode, True);
end;

procedure TPluginPref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('configuration', ANode, Fconfiguration);
  SetXmlAttribute('permitGetConnection', ANode, FpermitGetConnection);
  SetXmlAttribute('isEnabeld', ANode, FisEnabled);
end;

procedure TChartPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  Fview := TChartPref(APrefItem).view;
  Flegend := TChartPref(APrefItem).legend;
  Fvalues := TChartPref(APrefItem).values;
  Fdepth := TChartPref(APrefItem).depth;
  Fzoom := TChartPref(APrefItem).zoom;
  Frotate := TChartPref(APrefItem).rotate;
  Felevation := TChartPref(APrefItem).elevation;
  Fperspective := TChartPref(APrefItem).perspective;
  Ftilt := TChartPref(APrefItem).tilt;
  FisAvg := TChartPref(APrefItem).isAvg;
  FisReg := TChartPref(APrefItem).isReg;
end;

function TChartPref.GetNodeName: String;
begin
  Result := 'chartpref';
end;

procedure TChartPref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  Fview := GetXmlAttribute('view', ANode, 0);
  Flegend := GetXmlAttribute('legend', ANode, 0);
  Fvalues := GetXmlAttribute('values', ANode, 0);
  Fdepth := GetXmlAttribute('depth', ANode, 0);
  Fzoom := GetXmlAttribute('zoom', ANode, 0);
  Frotate := GetXmlAttribute('rotate', ANode, 0);
  Felevation := GetXmlAttribute('elevation', ANode, 0);
  Fperspective := GetXmlAttribute('perspective', ANode, 0);
  Ftilt := GetXmlAttribute('tilt', ANode, 0);
  FisAvg := GetXmlAttribute('isAvg', ANode, False);
  FisReg := GetXmlAttribute('isReg', ANode, False);
  FisGeo := GetXmlAttribute('isGeo', ANode, False);
  FisWeight := GetXmlAttribute('isWeight', ANode, False);
  FisMed := GetXmlAttribute('isMed', ANode, False);
  FisRes := GetXmlAttribute('isRes', ANode, False);
  FisSup := GetXmlAttribute('isSup', ANode, False);
end;

procedure TChartPref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('view', ANode, Fview);
  SetXmlAttribute('legend', ANode, Flegend);
  SetXmlAttribute('values', ANode, Fvalues);
  SetXmlAttribute('depth', ANode, Fdepth);
  SetXmlAttribute('zoom', ANode, Fzoom);
  SetXmlAttribute('rotate', ANode, Frotate);
  SetXmlAttribute('elevation', ANode, Felevation);
  SetXmlAttribute('perspective', ANode, Fperspective);
  SetXmlAttribute('tilt', ANode, Ftilt);
  SetXmlAttribute('isAvg', ANode, FisAvg);
  SetXmlAttribute('isReg', ANode, FisReg);
  SetXmlAttribute('isGeo', ANode, FisGeo);
  SetXmlAttribute('isWeight', ANode, FisWeight);
  SetXmlAttribute('isMed', ANode, FisMed);
  SetXmlAttribute('isRes', ANode, FisRes);
  SetXmlAttribute('isSup', ANode, FisSup);
end;

function GetDefaultViewPreferences: TPrefList;
var xCount: Integer;
begin
  Result := TPrefList.Create(TViewPref);
  Result.Add(TViewPref.Create(TCMovementFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przychód jednorazowy'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Rozchód jednorazowy'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('T', 'Transfer œrodków'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('CI', 'Planowany przychód'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('CO', 'Planowany rozchód'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('SI', 'Lista przychodów'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('SO', 'Lista rozchodów'), True);
  end;
  Result.Add(TViewPref.Create(TCDoneFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Gotowe do realizacji'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('W', 'Operacje zaleg³e'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('DO', 'Wykonane'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('DA', 'Uznane za wykonane'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('DD', 'Odrzucone jako niezasadne'), True);
  end;
  Result.Add(TViewPref.Create(TCPlannedFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przychód'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Rozchód'), True);
  end;
  Result.Add(TViewPref.Create(TCStartupInfoFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('II', 'Zaplanowane operacje przychodowe'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('IO', 'Zaplanowane operacje rozchodowe'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('IT', 'Zaplanowane transfery'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('OI', 'Zaleg³e operacje przychodowe'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('OO', 'Zaleg³e operacje rozchodowe'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('OT', 'Zaleg³e transfery'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('DD', 'Elementy grupuj¹ce w/g dat'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('TT', 'Elementy grupuj¹ce w/g stanu i rodzaju'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('SL', 'Przekroczone limity'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('VL', 'Poprawne limity'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('UE', 'Nieuzgodnione wyci¹gi'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesSurpassesLimits), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przekroczone limity przychodu'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Przekroczone limity rozchodu'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Przekroczone limity salda'), True);
  end;
  Result.Add(TViewPref.Create(TCExtractionsFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Otwarte'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('C', 'Zamkniête'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Uzgodniona'), True);
  end;
  Result.Add(TViewPref.Create(TCReportsFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Raporty'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('G', 'Elementy grupuj¹ce'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesMovementListSum), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesDoneListSum), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesRatesList), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesExchangesList), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(TCDescTemplatesFrame.GetPrefname), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Mnemoniki'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('G', 'Elementy grupuj¹ce'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesExtraction), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Obci¹¿enie'), True);
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Uznanie'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesListFrame), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesMovementList), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesParamsDefs), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesShortcuts), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Du¿e ikony'), True);
    TFontPref(Fontprefs.Last).RowHeight := 48;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Ma³e ikony'), True);
    TFontPref(Fontprefs.Last).RowHeight := 24;
  end;
  Result.Add(TViewPref.Create(CFontPreferencesFilterdetails), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Du¿e ikony'), True);
    TFontPref(Fontprefs.Last).RowHeight := 48;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Ma³e ikony'), True);
    TFontPref(Fontprefs.Last).RowHeight := 24;
  end;
  Result.Add(TViewPref.Create(CFontPreferencesChartList), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Du¿e ikony'), True);
    TFontPref(Fontprefs.Last).RowHeight := 48;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Ma³e ikony'), True);
    TFontPref(Fontprefs.Last).RowHeight := 24;
  end;
  Result.Add(TViewPref.Create(CFontPreferencesHomelist), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('BA', 'Akcje - du¿e ikony'), True);
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 48;
      Background := clWindow;
      BackgroundEven := clWindow;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('SA', 'Akcje - ma³e ikony'), True);
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 24;
      Background := clWindow;
      BackgroundEven := clWindow;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('BG', 'Elementy grupuj¹ce - du¿e ikony'), True);
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 48;
      Background := clWindow;
      BackgroundEven := clWindow;
      Font.Style := Font.Style + [fsUnderline, fsBold];
      Font.Size := 10;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('SG', 'Elementy grupuj¹ce - ma³e ikony'), True);
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 24;
      Background := clWindow;
      BackgroundEven := clWindow;
      Font.Style := Font.Style + [fsUnderline, fsBold];
      Font.Size := 10;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
  end;
  Result.Add(TViewPref.Create(CFontPreferencesQuickpatternsRun), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('D', 'W³asne szybkie akcje'), True);
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 24;
      Background := clWindow;
      BackgroundEven := clWindow;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Statystyczne szybkie akcje'), True);
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 24;
      Background := clWindow;
      BackgroundEven := clWindow;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
  end;
  Result.Add(TViewPref.Create(CFontPreferencesLoancalc), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesDepositcalc), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
  end;
  Result.Add(TViewPref.Create(CFontPreferencesPreferencesShortcut), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
    TFontPref(Fontprefs.Last).RowHeight := 48;
  end;
  Result.Add(TViewPref.Create(CFontPreferencesDefaultdataElements), True);
  with TViewPref(Result.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('T', 'Rodzaj danych'), True);
    with TFontPref(Fontprefs.Last) do begin
      Font.Style := Font.Style + [fsUnderline, fsBold];
      Font.Size := 10;
    end;
    Fontprefs.Add(TFontPref.CreateFontPref('E', 'Dane domyœlne'), True);
  end;
  for xCount := 0 to GRegisteredClasses.Count - 1 do begin
    if Result.ByPrefname[TRegisteredFrameClass(GRegisteredClasses.Items[xCount]).frameClass.GetPrefname] = Nil then begin
      Result.Add(TViewPref.Create(TRegisteredFrameClass(GRegisteredClasses.Items[xCount]).frameClass.GetPrefname), True);
      with TViewPref(Result.Last) do begin
        Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'), True);
      end;
    end;
  end;
end;

type
  T001008002000Answer = class(THtmlAnswer)
  private
    FsmallIcons: Boolean;
  public
    procedure UpdateAnswer(AWebBrowser: IWebBrowser2); override;
  published
    property smallIcons: Boolean read FsmallIcons;
  end;

  T001010002000Answer = class(THtmlAnswer)
  private
    FdeleteUnused: Boolean;
  public
    procedure UpdateAnswer(AWebBrowser: IWebBrowser2); override;
  published
    property deleteUnused: Boolean read FdeleteUnused;
  end;

  T001012001000Answer = class(THtmlAnswer)
  private
    FsetDefault: Boolean;
  public
    procedure UpdateAnswer(AWebBrowser: IWebBrowser2); override;
  published
    property SetDefault: Boolean read FsetDefault;
  end;

procedure T001008002000Answer.UpdateAnswer(AWebBrowser: IWebBrowser2);
var xRadioList: IDispatch;
    xRadio: IHTMLOptionButtonElement;
begin
  FsmallIcons := False;
  xRadioList := IHTMLDocument2(AWebBrowser.Document).all.item('icon', EmptyParam);
  if xRadioList <> Nil then begin
    if IHTMLElementCollection(xRadioList).length > 0 then begin
      xRadio := IHTMLElementCollection(xRadioList).item(0, EmptyParam) as IHTMLOptionButtonElement;
      FsmallIcons := not xRadio.checked;
    end;
  end;
end;

function UpdateConfiguration(AFromConfigVersion: String): Boolean;
var xFromDynArray, xToDynArray: TStringDynArray;
    xFromVersion, xToVersion, xTitle: String;
    x001008002000Answer: T001008002000Answer;
    x001010002000Answer: T001010002000Answer;
    x001012001000Answer: T001012001000Answer;
    xCount: Integer;
begin
  Result := True;
  xTitle := 'CManager - wersja ' + FileVersion(ParamStr(0));
  if AFromConfigVersion = '' then begin
    xFromDynArray := StringToStringArray('1.8.1.40', '.');
  end else begin
    xFromDynArray := StringToStringArray(AFromConfigVersion, '.');
  end;
  xToDynArray := StringToStringArray(FileVersion(ParamStr(0)), '.');
  if (Length(xFromDynArray) <> 4) and (Length(xToDynArray) <> 4) then begin
    Result := False;
  end else begin
    xFromVersion := LPad(xFromDynArray[0], '0', 3) +
                    LPad(xFromDynArray[1], '0', 3) +
                    LPad(xFromDynArray[2], '0', 3) +
                    LPad(xFromDynArray[3], '0', 3);
    xToVersion := LPad(xToDynArray[0], '0', 3) +
                  LPad(xToDynArray[1], '0', 3) +
                  LPad(xToDynArray[2], '0', 3) +
                  LPad(xToDynArray[3], '0', 3);
    if xFromVersion < '001004000000' then begin
      ShowHtmlReport(xTitle, GetStringFromResources('PL_001004000000', RT_RCDATA), 500, 170, '', Nil);
      GColumnsPreferences.Clear;
      GChartPreferences.Clear;
    end;
    if (xFromVersion < '001008002000') then begin
      x001008002000Answer := T001008002000Answer.Create;
      ShowHtmlReport(xTitle, GetStringFromResources('PL_001008002000', RT_RCDATA), 500, 300, '', x001008002000Answer);
      if x001008002000Answer.smallIcons then begin
        SetInterfaceIcons(True);
      end;
      x001008002000Answer.Free;
    end;
    if xFromVersion < '001010002000' then begin
      x001010002000Answer := T001010002000Answer.Create;
      ShowHtmlReport(xTitle, GetStringFromResources('PL_001010002000', RT_RCDATA), 600, 380, '', x001010002000Answer);
      MoveFilesToProfile(x001010002000Answer.deleteUnused);
      x001010002000Answer.Free;
    end;
    if (xFromVersion < '001012001000') and
       (FileExists(ExpandFileName(IncludeTrailingPathDelimiter(GPlugins.PluginPath) + 'metastock.dll'))) then begin
      x001012001000Answer := T001012001000Answer.Create;
      ShowHtmlReport(xTitle, GetStringFromResources('PL_001012001000', RT_RCDATA), 500, 300, '', x001012001000Answer);
      if x001012001000Answer.SetDefault then begin
        for xCount := GPluginsPreferences.Count - 1 downto 0 do begin
          if AnsiCompareText(ExtractFileName(GPluginsPreferences.Items[xCount].Prefname), 'metastock.dll') = 0 then begin
            GPluginsPreferences.Delete(xCount);
          end;
        end;
      end;
      x001012001000Answer.Free;
    end
  end;
  if Result then begin
    GBasePreferences.configFileVersion := FileVersion(ParamStr(0));
    SaveSettings;
  end;
end;

function TFramePref.GetNodeName: String;
begin
  Result := 'framepref';
end;

procedure TFrameWithSumlistPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FsumListVisible := TFrameWithSumlistPref(APrefItem).sumListVisible;
  FsumListHeight := TFrameWithSumlistPref(APrefItem).sumListHeight;
end;

constructor TFrameWithSumlistPref.Create(APrefname: String);
begin
  inherited Create(APrefname);
  FsumListVisible := True;
  FsumListHeight := -1;
end;

procedure TFrameWithSumlistPref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  FsumListVisible := GetXmlAttribute('sumListVisible', ANode, True);
  FsumListHeight := GetXmlAttribute('sumListHeight', ANode, -1);
end;

procedure TFrameWithSumlistPref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('sumListVisible', ANode, FsumListVisible);
  SetXmlAttribute('sumListHeight', ANode, FsumListHeight);
end;

procedure TBaseMovementFramePref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FpatternsListVisible := TBaseMovementFramePref(APrefItem).patternsListVisible;
  FpatternListWidth := TBaseMovementFramePref(APrefItem).patternListWidth;
  FuserPatternsVisible := TBaseMovementFramePref(APrefItem).userPatternsVisible;
  FstatisticPatternsVisible := TBaseMovementFramePref(APrefItem).statisticPatternsVisible;
end;

constructor TBaseMovementFramePref.Create(APrefname: String);
begin
  inherited Create(APrefname);
  FpatternsListVisible := True;
  FpatternListWidth := -1;
  FuserPatternsVisible := True;
  FstatisticPatternsVisible := True;
end;

procedure TBaseMovementFramePref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  FpatternsListVisible := GetXmlAttribute('patternsListVisible', ANode, True);
  FpatternListWidth := GetXmlAttribute('patternListWidth', ANode, -1);
  FuserPatternsVisible := GetXmlAttribute('userPatternsVisible', ANode, True);
  FstatisticPatternsVisible := GetXmlAttribute('statisticPatternsVisible', ANode, True);
end;

procedure TBaseMovementFramePref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('patternsListVisible', ANode, FpatternsListVisible);
  SetXmlAttribute('patternListWidth', ANode, FpatternListWidth);
  SetXmlAttribute('userPatternsVisible', ANode, FuserPatternsVisible);
  SetXmlAttribute('statisticPatternsVisible', ANode, FstatisticPatternsVisible);
end;

procedure T001010002000Answer.UpdateAnswer(AWebBrowser: IWebBrowser2);
var xRadioList: IDispatch;
    xRadio: IHTMLOptionButtonElement;
begin
  FdeleteUnused := False;
  xRadioList := IHTMLDocument2(AWebBrowser.Document).all.item('kill', EmptyParam);
  if xRadioList <> Nil then begin
    if IHTMLElementCollection(xRadioList).length > 0 then begin
      xRadio := IHTMLElementCollection(xRadioList).item(0, EmptyParam) as IHTMLOptionButtonElement;
      FdeleteUnused := xRadio.checked;
    end;
  end;
end;

function GetDatafileDefaultFilename: String;
var xCat: String;
begin
  {$IFDEF DEBUG}
  xCat := IncludeTrailingPathDelimiter(GetSystemPathname(''));
  {$ELSE}
  xCat := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA)) + 'CManager';
  {$ENDIF}
  if ForceDirectories(xCat) then begin
    Result := IncludeTrailingPathDelimiter(xCat) + CPrivateDefaultFilename;
  end;
end;

procedure T001012001000Answer.UpdateAnswer(AWebBrowser: IWebBrowser2);
var xRadioList: IDispatch;
    xRadio: IHTMLOptionButtonElement;
begin
  FsetDefault := True;
  xRadioList := IHTMLDocument2(AWebBrowser.Document).all.item('config', EmptyParam);
  if xRadioList <> Nil then begin
    if IHTMLElementCollection(xRadioList).length > 0 then begin
      xRadio := IHTMLElementCollection(xRadioList).item(0, EmptyParam) as IHTMLOptionButtonElement;
      FsetDefault := not xRadio.checked;
    end;
  end;
end;

initialization
  GBasePreferences := TBasePref.Create('basepreferences');
  with GBasePreferences do begin
    startupDatafileMode := CStartupFilemodeFirsttime;
    startupDatafileName := GetDatafileDefaultFilename;
    showShortcutBar := True;
    showStatusBar := True;
    lastOpenedDatafilename := '';
    startupInfo := False;
    startupInfoType := CStartupInfoToday;
    startupInfoDays := 1;
    startupInfoIn := True;
    startupInfoTran := True;
    startupInfoOut := True;
    startupInfoOldIn := True;
    startupInfoOldOut := True;
    startupInfoOldTran := True;
    startupInfoAlways := True;
    startupInfoSurpassedLimit := True;
    startupUncheckedExtractions := False;
    listAsReportUseColors := False;
    listAsReportUseFonts := False;
    startupInfoValidLimits := False;
    startupCheckUpdates := False;
    workDays := '+++++--';
    backupAction := CBackupActionAsk;
    backupOnStart := False;
    backupDaysOld := 7;
    backupDirectory := ExpandFileName(ExtractFilePath(GetUserProfilePathname('')));
    backupFileName := '@data@ @godz@ @min@.cmb';
    backupOverwrite := False;
    evenListColor := clWindow;
    oddListColor := GetDarkerColor(evenListColor);
    startupInfoOldDays := 90;
  end;
  GDescPatterns := TDescPatterns.Create(True);
  GViewsPreferences := TPrefList.Create(TViewPref);
  GFramePreferences := TPrefList.Create(GBasePreferences.GetFramePrefitemClass);
  GColumnsPreferences := TPrefList.Create(TViewColumnPref);
  GBackupsPreferences := TPrefList.Create(TBackupPref);
  GPluginsPreferences := TPrefList.Create(TPluginPref);
  GChartPreferences := TPrefList.Create(TChartPref);
finalization
  if GBackupThread <> Nil then begin
    if GBackupThread.IsRunning then begin
      GBackupThread.WaitFor(False);
    end;
    GBackupThread.Free;
  end;
  GViewsPreferences.Free;
  GBasePreferences.Free;
  GColumnsPreferences.Free;
  GBackupsPreferences.Free;
  GChartPreferences.Free;
  GPluginsPreferences.Free;
  GDescPatterns.Free;
  GFramePreferences.Free;
end.
