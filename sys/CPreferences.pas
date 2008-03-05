unit CPreferences;

interface

uses Classes, Graphics, Contnrs, Math, Windows, CTemplates, GraphUtil, CXml, CComponents;

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
    procedure Progress(AStepBy: Integer);
    procedure AddToReport(AText: String);
  protected
    function PrepareFile: Boolean;
    procedure Execute; override;
  public
    constructor Create(AFilein: String);
    procedure WaitFor;
    property Report: TStringList read FReport;
    property IsRunning: Boolean read FIsRunning;
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
    FstartupInfoAlways: Boolean;
    FstartupCheckUpdates: Boolean;
    FstartupInfoSurpassedLimit: Boolean;
    FstartupInfoValidLimits: Boolean;
    FworkDays: String;
    FbackupAction: Integer;
    FbackupDaysOld: Integer;
    FbakupDirectory: String;
    FbackupFileName: String;
    FbackupOverwrite: Boolean;
    FstartupUncheckedExtractions: Boolean;
    FevenListColor: TColor;
    FoddListColor: TColor;
  public
    function GetBackupfilename: String;
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    function GetNodeName: String; override;
    procedure Clone(APrefItem: TPrefItem); override;
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
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
    property startupInfoOldIn: Boolean read FstartupInfoOldIn write FstartupInfoOldIn;
    property startupInfoOldOut: Boolean read FstartupInfoOldOut write FstartupInfoOldOut;
    property startupInfoAlways: Boolean read FstartupInfoAlways write FstartupInfoAlways;
    property startupCheckUpdates: Boolean read FstartupCheckUpdates write FstartupCheckUpdates;
    property startupInfoSurpassedLimit: Boolean read FstartupInfoSurpassedLimit write FstartupInfoSurpassedLimit;
    property startupInfoValidLimits: Boolean read FstartupInfoValidLimits write FstartupInfoValidLimits;
    property startupUncheckedExtractions: Boolean read FstartupUncheckedExtractions write FstartupUncheckedExtractions;
    property workDays: String read FworkDays write FworkDays;
    property backupAction: Integer read FbackupAction write FbackupAction;
    property backupDaysOld: Integer read FbackupDaysOld write FbackupDaysOld;
    property backupDirectory: String read FbakupDirectory write FbakupDirectory;
    property backupFileName: String read FbackupFileName write FbackupFileName;
    property backupOverwrite: Boolean read FbackupOverwrite write FbackupOverwrite;
    property evenListColor: TColor read FevenListColor write FevenListColor;
    property oddListColor: TColor read FoddListColor write FoddListColor;
  end;

  TDescPatterns = class(TStringList)
  private
    FSaveToDatabase: Boolean;
  public
    constructor Create(ASaveToDatabase: Boolean);
    function GetPattern(AName, ADefault: String): String;
    procedure SetPattern(AName, APattern: String);
    function GetPatternOperation(AName: String): Integer;
    function GetPattetnType(AName: String): Integer;
  end;

var GViewsPreferences: TPrefList;
    GChartPreferences: TPrefList;
    GColumnsPreferences: TPrefList;
    GBackupsPreferences: TPrefList;
    GPluginsPreferences: TPrefList;
    GBasePreferences: TBasePref;
    GDescPatterns: TDescPatterns;
    GBackupThread: TBackupThread;

function GetWorkDay(ADate: TDateTime; AForward: Boolean): TDateTime;

implementation

uses CSettings, CMovementFrameUnit, CConsts, CDatabase, SysUtils,
     DateUtils, CBackups, CTools, Forms, CPlannedFrameUnit, CDoneFrameUnit,
  CStartupInfoFrameUnit, CExtractionsFrameUnit, CBaseFormUnit,
  CBaseFrameUnit, CReportsFrameUnit, CDescTemplatesFrameUnit;

procedure SendMessageToMainForm(AMsg: Integer; AWParam: Integer; ALParam: Integer);
begin
  if Application.MainForm <> Nil then begin
    SendMessage(Application.MainForm.Handle, AMsg, AWParam, ALParam);
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
  FstartupInfoAlways := TBasePref(APrefItem).startupInfoAlways;
  FstartupInfoOldIn := TBasePref(APrefItem).startupInfoOldIn;
  FstartupInfoOldOut := TBasePref(APrefItem).startupInfoOldOut;
  FstartupCheckUpdates := TBasePref(APrefItem).startupCheckUpdates;
  FstartupInfoSurpassedLimit := TBasePref(APrefItem).startupInfoSurpassedLimit;
  FstartupInfoValidLimits := TBasePref(APrefItem).startupInfoValidLimits;
  FworkDays := TBasePref(APrefItem).workDays;
  FbackupAction := TBasePref(APrefItem).backupAction;
  FbackupDaysOld := TBasePref(APrefItem).backupDaysOld;
  FbakupDirectory := TBasePref(APrefItem).backupDirectory;
  FbackupFileName := TBasePref(APrefItem).backupFileName;
  FbackupOverwrite := TBasePref(APrefItem).backupOverwrite;
  FstartupUncheckedExtractions := TBasePref(APrefItem).startupUncheckedExtractions;
  FevenListColor := TBasePref(APrefItem).evenListColor;
  FoddListColor := TBasePref(APrefItem).oddListColor;
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
  end;
end;

function TBasePref.GetBackupfilename: String;
begin
  Result := IncludeTrailingPathDelimiter(backupDirectory) + GBaseTemlatesList.ExpandTemplates(FbackupFileName, Self);
end;

function TBasePref.GetNodeName: String;
begin
  Result := 'basepref';
end;

procedure TBasePref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  FstartupDatafileMode := GetXmlAttribute('startupfilemode', ANode, CStartupFilemodeThisfile);
  FstartupDatafileName := GetXmlAttribute('startupfilename', ANode, GetSystemPathname(CDefaultFilename));
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
  FstartupInfoOldIn := GetXmlAttribute('startupInfoOldIn', ANode, True);
  FstartupInfoOldOut := GetXmlAttribute('startupInfoOldOut', ANode, True);
  FstartupInfoAlways := GetXmlAttribute('startupInfoAlways', ANode, True);
  FstartupCheckUpdates := GetXmlAttribute('startupCheckUpdates', ANode, False);
  FstartupInfoSurpassedLimit := GetXmlAttribute('startupInfoSurpassedLimit', ANode, False);
  FstartupInfoValidLimits := GetXmlAttribute('startupInfoValidLimits', ANode, False);
  FworkDays := GetXmlAttribute('workDays', ANode, '+++++--');
  if Length(FworkDays) <> 7 then begin
    FworkDays := '+++++--';
  end;
  FbackupAction := GetXmlAttribute('backupAction', ANode, CBackupActionAsk);
  FbackupDaysOld := GetXmlAttribute('backupDaysOld', ANode, 7);
  FbakupDirectory := GetXmlAttribute('backupDirectory', ANode, ExpandFileName(ExtractFilePath(ParamStr(0))));
  FbackupFileName := GetXmlAttribute('backupFilename', ANode, '@data@.cmb');
  FbackupOverwrite := GetXmlAttribute('backupOverwrite', ANode, False);
  FstartupUncheckedExtractions := GetXmlAttribute('startupUncheckedExtractions', ANode, False);
  FevenListColor := StringToColor(GetXmlAttribute('evenListColor', ANode, ColorToString(clWindow)));
  FoddListColor := StringToColor(GetXmlAttribute('oddListColor', ANode, ColorToString(GetDarkerColor(FevenListColor))));
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
  SetXmlAttribute('startupInfoOut', ANode, FstartupInfoOut);
  SetXmlAttribute('startupInfoOldIn', ANode, FstartupInfoOldIn);
  SetXmlAttribute('startupInfoOldOut', ANode, FstartupInfoOldOut);
  SetXmlAttribute('startupInfoAlways', ANode, FstartupInfoAlways);
  SetXmlAttribute('startupCheckUpdates', ANode, FstartupCheckUpdates);
  SetXmlAttribute('startupInfoSurpassedLimit', ANode, FstartupInfoSurpassedLimit);
  SetXmlAttribute('startupInfoValidLimits', ANode, FstartupInfoValidLimits);
  SetXmlAttribute('workDays', ANode, FworkDays);
  SetXmlAttribute('backupAction', ANode, FbackupAction);
  SetXmlAttribute('backupDaysOld', ANode, FbackupDaysOld);
  SetXmlAttribute('backupDirectory', ANode, FbakupDirectory);
  SetXmlAttribute('backupFilename', ANode, FbackupFileName);
  SetXmlAttribute('backupOverwrite', ANode, FbackupOverwrite);
  SetXmlAttribute('startupUncheckedExtractions', ANode, FstartupUncheckedExtractions);
  SetXmlAttribute('evenListColor', ANode, ColorToString(FevenListColor));
  SetXmlAttribute('oddListColor', ANode, ColorToString(FoddListColor));
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

function TDescPatterns.GetPattetnType(AName: String): Integer;
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

constructor TBackupThread.Create(AFilein: String);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FFilein := AFilein;
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
    AddToReport('Rozpocz�to tworzenie kopii pliku danych ' +  FFilein);
    if CmbBackup(FTempfile, xBackupname, GBasePreferences.backupOverwrite, xText, Progress) then begin
      xBackupPref := TBackupPref(GBackupsPreferences.ByPrefname[FFilein]);
      if xBackupPref = Nil then begin
        xBackupPref := TBackupPref.CreateBackupPref(FFilein, Now);
        GBackupsPreferences.Add(xBackupPref);
      end else begin
        xBackupPref.lastBackup := Now;
      end;
      xOk := True;
      AddToReport('Wykonano poprawnie kopi� pliku danych ' +  FFilein);
      AddToReport('Kopia znajduje si� w pliku ' +  xBackupname);
    end else begin
      AddToReport('Podczas tworzenia kopii pliku danych ' + FFilein + ' wyst�pi� b��d');
      AddToReport(xText);
      AddToReport('Kopia nie zosta�a utworzona');
    end;
    if DeleteFile(FTempfile) then begin
      AddToReport('Usuni�to utworzony plik tymczasowy');
    end else begin
      AddToReport('Nie uda�o si� usun�� utworzonego pliku tymczasowego');
    end;
  end;
  if not xOk then begin
    SendMessageToMainForm(WM_STATBACKUPFINISHEDERR, 0, 0);
  end else begin
    SendMessageToMainForm(WM_STATBACKUPFINISHEDSUCC, 0, 0);
    WaitForSingleObject(Handle, 3000);
    SendMessageToMainForm(WM_STATCLEAR, 0, 0);
  end;
  FIsRunning := False;
end;

function TBackupThread.PrepareFile: Boolean;
begin
  FTempfile := FormatDateTime('yyyymmddhhnnss', Now) + ExtractFileExt(FFilein);
  AddToReport('Rozpocz�to tworzenie pliku tymczasowego');
  Result := CopyFile(PChar(FFilein), PChar(FTempfile), False);
  if not Result then begin
    AddToReport('Podczas tworzenia pliku tymczasowego wyst�pi� b��d');
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

procedure TBackupThread.WaitFor;
begin
  while FIsRunning do begin
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
end;

initialization
  GDescPatterns := TDescPatterns.Create(True);
  GViewsPreferences := TPrefList.Create(TViewPref);
  GColumnsPreferences := TPrefList.Create(TViewColumnPref);
  GBackupsPreferences := TPrefList.Create(TBackupPref);
  GPluginsPreferences := TPrefList.Create(TPluginPref);
  GChartPreferences := TPrefList.Create(TChartPref);
  GViewsPreferences.Add(TViewPref.Create(TCMovementFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przych�d jednorazowy'));
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Rozch�d jednorazowy'));
    Fontprefs.Add(TFontPref.CreateFontPref('T', 'Transfer �rodk�w'));
    Fontprefs.Add(TFontPref.CreateFontPref('CI', 'Planowany przych�d'));
    Fontprefs.Add(TFontPref.CreateFontPref('CO', 'Planowany rozch�d'));
    Fontprefs.Add(TFontPref.CreateFontPref('SI', 'Lista przychod�w'));
    Fontprefs.Add(TFontPref.CreateFontPref('SO', 'Lista rozchod�w'));
  end;
  GViewsPreferences.Add(TViewPref.Create(TCDoneFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Gotowe do realizacji'));
    Fontprefs.Add(TFontPref.CreateFontPref('W', 'Operacje zaleg�e'));
    Fontprefs.Add(TFontPref.CreateFontPref('DO', 'Wykonane'));
    Fontprefs.Add(TFontPref.CreateFontPref('DA', 'Uznane za wykonane'));
    Fontprefs.Add(TFontPref.CreateFontPref('DD', 'Odrzucone jako niezasadne'));
  end;
  GViewsPreferences.Add(TViewPref.Create(TCPlannedFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Przych�d'));
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Rozch�d'));
  end;
  GViewsPreferences.Add(TViewPref.Create(TCStartupInfoFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('II', 'Zaplanowane operacje przychodowe'));
    Fontprefs.Add(TFontPref.CreateFontPref('IO', 'Zaplanowane operacje rozchodowe'));
    Fontprefs.Add(TFontPref.CreateFontPref('OI', 'Zaleg�e operacje przychodowe'));
    Fontprefs.Add(TFontPref.CreateFontPref('OO', 'Zaleg�e operacje rozchodowe'));
    Fontprefs.Add(TFontPref.CreateFontPref('DD', 'Elementy grupuj�ce w/g dat'));
    Fontprefs.Add(TFontPref.CreateFontPref('TT', 'Elementy grupuj�ce w/g stanu i rodzaju'));
    Fontprefs.Add(TFontPref.CreateFontPref('SL', 'Przekroczone limity'));
    Fontprefs.Add(TFontPref.CreateFontPref('VL', 'Poprawne limity'));
    Fontprefs.Add(TFontPref.CreateFontPref('UE', 'Nieuzgodnione wyci�gi'));
  end;
  GViewsPreferences.Add(TViewPref.Create(TCExtractionsFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Otwarte'));
    Fontprefs.Add(TFontPref.CreateFontPref('C', 'Zamkni�te'));
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Uzgodniona'));
  end;
  GViewsPreferences.Add(TViewPref.Create(TCReportsFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Raporty'));
    Fontprefs.Add(TFontPref.CreateFontPref('G', 'Elementy grupuj�ce'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesMovementListSum));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesDoneListSum));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesRatesList));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesExchangesList));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(TCDescTemplatesFrame.GetPrefname));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('R', 'Mnemoniki'));
    Fontprefs.Add(TFontPref.CreateFontPref('G', 'Elementy grupuj�ce'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesExtraction));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('O', 'Obci��enie'));
    Fontprefs.Add(TFontPref.CreateFontPref('I', 'Uznanie'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesListFrame));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesMovementList));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesParamsDefs));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesShortcuts));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Du�e ikony'));
    TFontPref(Fontprefs.Last).RowHeight := 48;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Ma�e ikony'));
    TFontPref(Fontprefs.Last).RowHeight := 24;
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesFilterdetails));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Du�e ikony'));
    TFontPref(Fontprefs.Last).RowHeight := 48;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Ma�e ikony'));
    TFontPref(Fontprefs.Last).RowHeight := 24;
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesChartList));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('B', 'Du�e ikony'));
    TFontPref(Fontprefs.Last).RowHeight := 48;
    Fontprefs.Add(TFontPref.CreateFontPref('S', 'Ma�e ikony'));
    TFontPref(Fontprefs.Last).RowHeight := 24;
  end;
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesHomelist));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('BA', 'Akcje - du�e ikony'));
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 48;
      Background := clWindow;
      BackgroundEven := clWindow;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('SA', 'Akcje - ma�e ikony'));
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 24;
      Background := clWindow;
      BackgroundEven := clWindow;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('BG', 'Elementy grupuj�ce - du�e ikony'));
    with TFontPref(Fontprefs.Last) do begin
      RowHeight := 48;
      Background := clWindow;
      BackgroundEven := clWindow;
      Font.Style := Font.Style + [fsUnderline, fsBold];
      Font.Size := 10;
    end;
    FocusedBackgroundColor := clWindow;
    FocusedFontColor := clWindowText;
    Fontprefs.Add(TFontPref.CreateFontPref('SG', 'Elementy grupuj�ce - ma�e ikony'));
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
  GViewsPreferences.Add(TViewPref.Create(CFontPreferencesLoancalc));
  with TViewPref(GViewsPreferences.Last) do begin
    Fontprefs.Add(TFontPref.CreateFontPref('*', 'Wszystkie elementy'));
  end;
  GBasePreferences := TBasePref.Create('basepreferences');
  with GBasePreferences do begin
    startupDatafileMode := CStartupFilemodeFirsttime;
    startupDatafileName := GetSystemPathname(CDefaultFilename);
    showShortcutBar := True;
    showStatusBar := True;
    lastOpenedDatafilename := '';
    startupInfo := False;
    startupInfoType := CStartupInfoToday;
    startupInfoDays := 1;
    startupInfoIn := True;
    startupInfoOut := True;
    startupInfoOldIn := True;
    startupInfoOldOut := True;
    startupInfoAlways := True;
    startupInfoSurpassedLimit := False;
    startupUncheckedExtractions := False;
    startupInfoValidLimits := False;
    startupCheckUpdates := False;
    workDays := '+++++--';
    backupAction := CBackupActionAsk;
    backupDaysOld := 7;
    backupDirectory := ExpandFileName(ExtractFilePath(ParamStr(0)));
    backupFileName := '@data@ @godz@ @min@.cmb';
    backupOverwrite := False;
    evenListColor := clWindow;
    oddListColor := GetDarkerColor(evenListColor);
  end;
finalization
  if GBackupThread <> Nil then begin
    if GBackupThread.IsRunning then begin
      GBackupThread.WaitFor;
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
end.
