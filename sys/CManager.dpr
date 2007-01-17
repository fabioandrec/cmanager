program CManager;

{$R 'CMandbpat.res' 'CMandbpat.rc'}
{%File 'CMandb.sql'}
{$R 'strings.res' 'strings.rc'}
{$R 'icons.res' 'icons.rc'}

uses
  MemCheck in 'MemCheck.pas',
  Forms,
  Windows,
  CDatabase in 'CDatabase.pas',
  CDataObjects in 'CDataObjects.pas',
  CMainFormUnit in 'CMainFormUnit.pas' {CMainForm},
  CBaseFormUnit in 'CBaseFormUnit.pas' {CBaseForm},
  CConfigFormUnit in 'CConfigFormUnit.pas' {CConfigForm},
  CInfoFormUnit in 'CInfoFormUnit.pas' {CInfoForm},
  CBaseFrameUnit in 'CBaseFrameUnit.pas' {CBaseFrame: TFrame},
  CCashpointsFrameUnit in 'CCashpointsFrameUnit.pas' {CCashpointsFrame: TFrame},
  CComponents in 'CComponents.pas',
  CFrameFormUnit in 'CFrameFormUnit.pas' {CFrameForm},
  CDataobjectFormUnit in 'CDataobjectFormUnit.pas' {CDataobjectForm},
  CCashpointFormUnit in 'CCashpointFormUnit.pas' {CCashpointForm},
  CAccountsFrameUnit in 'CAccountsFrameUnit.pas' {CAccountsFrame: TFrame},
  CAccountFormUnit in 'CAccountFormUnit.pas' {CAccountForm},
  CProductsFrameUnit in 'CProductsFrameUnit.pas' {CProductsFrame: TFrame},
  CProductFormUnit in 'CProductFormUnit.pas' {CProductForm},
  CMovementFrameUnit in 'CMovementFrameUnit.pas' {CMovementFrame: TFrame},
  CListFrameUnit in 'CListFrameUnit.pas' {CListFrame: TFrame},
  CCalendarFormUnit in 'CCalendarFormUnit.pas' {CCalendarForm},
  CReportsFrameUnit in 'CReportsFrameUnit.pas' {CReportsFrame: TFrame},
  CMovementFormUnit in 'CMovementFormUnit.pas' {CMovementForm},
  CReports in 'CReports.pas',
  CPlannedFrameUnit in 'CPlannedFrameUnit.pas' {CPlannedFrame: TFrame},
  CPlannedFormUnit in 'CPlannedFormUnit.pas' {CPlannedForm},
  CScheduleFormUnit in 'CScheduleFormUnit.pas' {CScheduleForm},
  CDoneFrameUnit in 'CDoneFrameUnit.pas' {CDoneFrame: TFrame},
  CAboutFormUnit in 'CAboutFormUnit.pas',
  CReportFormUnit in 'CReportFormUnit.pas' {CReportForm},
  CSettings in 'CSettings.pas',
  CDoneFormUnit in 'CDoneFormUnit.pas' {CDoneForm},
  CChooseDateFormUnit in 'CChooseDateFormUnit.pas' {CChooseDateForm},
  CChoosePeriodFormUnit in 'CChoosePeriodFormUnit.pas' {CChoosePeriodForm},
  CConsts in 'CConsts.pas',
  CSchedules in 'CSchedules.pas',
  CChoosePeriodAccountFormUnit in 'CChoosePeriodAccountFormUnit.pas' {CChoosePeriodAccountForm},
  CHtmlReportFormUnit in 'CHtmlReportFormUnit.pas' {CHtmlReportForm},
  CChartReportFormUnit in 'CChartReportFormUnit.pas' {CChartReportForm},
  CChoosePeriodAccountListFormUnit in 'CChoosePeriodAccountListFormUnit.pas' {CChoosePeriodAccountListForm},
  CChoosePeriodAccountListGroupFormUnit in 'CChoosePeriodAccountListGroupFormUnit.pas' {CChoosePeriodAccountListGroupForm},
  CFilterFrameUnit in 'CFilterFrameUnit.pas' {CFilterFrame: TFrame},
  CFilterFormUnit in 'CFilterFormUnit.pas' {CFilterForm},
  CChooseDateAccountListFormUnit in 'CChooseDateAccountListFormUnit.pas' {CChooseDateAccountListForm},
  CChoosePeriodFilterFormUnit in 'CChoosePeriodFilterFormUnit.pas' {CChoosePeriodFilterForm},
  CHomeFrameUnit in 'CHomeFrameUnit.pas' {CHomeFrame: TFrame},
  CWaitFormUnit in 'CWaitFormUnit.pas' {CWaitForm},
  CDatatools in 'CDatatools.pas',
  CProgressFormUnit in 'CProgressFormUnit.pas' {CProgressForm},
  CCompactDatafileFormUnit in 'CCompactDatafileFormUnit.pas' {CCompactDatafileForm},
  CMemoFormUnit in 'CMemoFormUnit.pas',
  CArchFormUnit in 'CArchFormUnit.pas' {CArchForm},
  CImageListsUnit in 'CImageListsUnit.pas' {CImageLists: TDataModule},
  CCheckDatafileFormUnit in 'CCheckDatafileFormUnit.pas' {CCheckDatafileFormUnit},
  CPreferencesFormUnit in 'CPreferencesFormUnit.pas' {CPreferencesForm},
  CListPreferencesFormUnit in 'CListPreferencesFormUnit.pas' {CListPreferencesForm},
  CPreferences in 'CPreferences.pas',
  CProfileFrameUnit in 'CProfileFrameUnit.pas' {CProfileFrame: TFrame},
  CProfileFormUnit in 'CProfileFormUnit.pas' {CProfileForm},
  CChooseFutureFilterFormUnit in 'CChooseFutureFilterFormUnit.pas' {CChooseFutureFilterForm};

{$R *.res}

var xError, xDesc, xFilename: String;
    xProceed: Boolean;

begin
  //MemChk;
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'SMALLICON');
  if InitializeSettings(GetSystemPathname(CSettingsFilename)) then begin
    if GBasePreferences.startupDatafileMode <> CStartupFilemodeNeveropern then begin
      if GBasePreferences.startupDatafileMode = CStartupFilemodeFirsttime then begin
        xFilename := GetSystemPathname(CDefaultFilename);
      end else if GBasePreferences.startupDatafileMode = CStartupFilemodeLastOpened then begin
        xFilename := GBasePreferences.lastOpenedDatafilename;
      end else if GBasePreferences.startupDatafileMode = CStartupFilemodeThisfile then begin
        xFilename := GBasePreferences.startupDatafileName;
      end;
      xProceed := InitializeDataProvider(xFilename, xError, xDesc, GBasePreferences.startupDatafileMode = CStartupFilemodeFirsttime);
    end else begin
      xProceed := True;
    end;
    if xProceed then begin
      InitializeProxies;
      Application.CreateForm(TCMainForm, CMainForm);
      Application.Run;
    end else begin
      ShowInfo(itError, xError, xDesc)
    end;
  end;
end.
