program CManager;

{$R 'CMandbpat.res' 'CMandbpat.rc'}
{$R 'strings.res' 'strings.rc'}
{$R 'cmanagericons.res' 'cmanagericons.rc'}
{%File 'CMandb.sql'}
{%File 'CMandb_0_1.sql'}
{%File 'CMandb_1_2.sql'}
{%File 'CMandb_2_3.sql'}
{%File 'CMandb_3_4.sql'}
{%File 'CMandb_4_5.sql'}
{%File 'CMandb_5_6.sql'}
{%File 'CMandb_6_7.sql'}
{%File 'CMandf.sql'}

uses
  MemCheck in 'MemCheck.pas',
  Forms,
  Windows,
  CBaseFrameUnit in 'CBaseFrameUnit.pas' {CBaseFrame: TFrame},
  CDatabase in 'CDatabase.pas',
  CDataObjects in 'CDataObjects.pas',
  CMainFormUnit in 'CMainFormUnit.pas' {CMainForm},
  CBaseFormUnit in 'CBaseFormUnit.pas' {CBaseForm},
  CConfigFormUnit in 'CConfigFormUnit.pas' {CConfigForm},
  CInfoFormUnit in 'CInfoFormUnit.pas' {CInfoForm},
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
  CChoosePeriodAcpFormUnit in 'CChoosePeriodAcpFormUnit.pas' {CChoosePeriodAcpForm},
  CHtmlReportFormUnit in 'CHtmlReportFormUnit.pas' {CHtmlReportForm},
  CChartReportFormUnit in 'CChartReportFormUnit.pas' {CChartReportForm},
  CChoosePeriodAcpListFormUnit in 'CChoosePeriodAcpListFormUnit.pas' {CChoosePeriodAcpListForm},
  CChoosePeriodAcpListGroupFormUnit in 'CChoosePeriodAcpListGroupFormUnit.pas' {CChoosePeriodAcpListGroupForm},
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
  CChooseFutureFilterFormUnit in 'CChooseFutureFilterFormUnit.pas' {CChooseFutureFilterForm},
  CLoans in 'CLoans.pas',
  CLoanCalculatorFormUnit in 'CLoanCalculatorFormUnit.pas' {CLoanCalculatorForm},
  CStartupInfoFormUnit in 'CStartupInfoFormUnit.pas' {CStartupInfoForm},
  CStartupInfoFrameUnit in 'CStartupInfoFrameUnit.pas' {CStartupInfoFrame: TFrame},
  CRichtext in 'Shared\CRichtext.pas',
  CXml in 'Shared\CXml.pas',
  CTools in 'Shared\CTools.pas',
  CHelp in 'CHelp.pas',
  CMovementListFormUnit in 'CMovementListFormUnit.pas' {CMovementListForm},
  CMovmentListElementFormUnit in 'CMovmentListElementFormUnit.pas' {CMovmentListElementForm},
  CExportDatafileFormUnit in 'CExportDatafileFormUnit.pas' {CExportDatafileForm},
  CDescpatternFormUnit in 'CDescpatternFormUnit.pas' {CDescpatternForm},
  CTemplates in 'CTemplates.pas',
  CDescTemplatesFrameUnit in 'CDescTemplatesFrameUnit.pas' {CDescTemplatesFrame: TFrame},
  CRandomFormUnit in 'CRandomFormUnit.pas' {CRandomForm},
  CLimitsFrameUnit in 'CLimitsFrameUnit.pas' {CLimitsFrame: TFrame},
  CDataobjectFrameUnit in 'CDataobjectFrameUnit.pas' {CDataobjectFrame: TFrame},
  CLimitFormUnit in 'CLimitFormUnit.pas' {CLimitForm},
  CSurpassedFormUnit in 'CSurpassedFormUnit.pas' {CSurpassedForm},
  CBackups in 'CBackups.pas',
  CAdox in 'CAdox.pas',
  CCurrencydefFrameUnit in 'CCurrencydefFrameUnit.pas' {CCurrencydefFrame: TFrame},
  CCurrencydefFormUnit in 'CCurrencydefFormUnit.pas' {CCurrencydefForm},
  CCurrencyRateFrameUnit in 'CCurrencyRateFrameUnit.pas' {CCurrencyRateFrame: TFrame},
  CCurrencyRateFormUnit in 'CCurrencyRateFormUnit.pas' {CCurrencyRateForm},
  CPlugins in 'CPlugins.pas',
  CPluginConsts in 'Plugins\CPluginConsts.pas',
  CPluginTypes in 'Plugins\CPluginTypes.pas',
  CUpdateCurrencyRatesFormUnit in 'CUpdateCurrencyRatesFormUnit.pas' {CUpdateCurrencyRatesForm},
  CChoosePeriodRatesHistoryFormUnit in 'CChoosePeriodRatesHistoryFormUnit.pas' {CChoosePeriodRatesHistoryForm},
  CChartPropsFormUnit in 'CChartPropsFormUnit.pas' {CChartPropsForm},
  CCalculatorFormUnit in 'CCalculatorFormUnit.pas' {CCalculatorForm},
  CAccountCurrencyFormUnit in 'CAccountCurrencyFormUnit.pas' {CAccountCurrencyForm},
  CChoosePeriodFilterGroupFormUnit in 'CChoosePeriodFilterGroupFormUnit.pas' {CChoosePeriodFilterGroupForm},
  CFilterDetailFrameUnit in 'CFilterDetailFrameUnit.pas' {CFilterDetailFrame: TFrame},
  CExtractionsFrameUnit in 'CExtractionsFrameUnit.pas' {CExtractionsFrame: TFrame},
  CExtractionFormUnit in 'CExtractionFormUnit.pas' {CExtractionForm},
  CExtractionItemFormUnit in 'CExtractionItemFormUnit.pas' {CExtractionItemForm},
  CMovementStateFormUnit in 'CMovementStateFormUnit.pas' {CMovementStateForm},
  CExtractionItemFrameUnit in 'CExtractionItemFrameUnit.pas' {CExtractionItemFrame: TFrame},
  CAdotools in 'Shared\CAdotools.pas',
  CUnitDefFrameUnit in 'CUnitDefFrameUnit.pas' {CUnitDefFrame: TFrame},
  CUnitdefFormUnit in 'CUnitDefFormUnit.pas' {CUnitdefForm},
  CImportDatafileFormUnit in 'CImportDatafileFormUnit.pas' {CImportDatafileForm},
  CReportDefFormUnit in 'CReportDefFormUnit.pas' {CReportDefForm},
  CBase64 in 'Shared\CBase64.pas',
  CParamsDefsFrameUnit in 'CParamsDefsFrameUnit.pas' {CParamsDefsFrame: TFrame},
  CParamDefFormUnit in 'CParamDefFormUnit.pas' {CParamDefForm},
  CChooseByParamsDefsFormUnit in 'CChooseByParamsDefsFormUnit.pas' {CChooseByParamsDefsForm},
  CValuelistFormUnit in 'CValuelistFormUnit.pas' {CValuelistForm},
  CInstrumentFrameUnit in 'CInstrumentFrameUnit.pas' {CInstrumentFrame: TFrame},
  CInstrumentFormUnit in 'CInstrumentFormUnit.pas' {CInstrumentForm},
  CInstrumentValueFrameUnit in 'CInstrumentValueFrameUnit.pas' {CInstrumentValueFrame: TFrame};

{$R *.res}

var xError, xDesc, xFilename: String;
    xProceed: Boolean;

begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'SMALLICON');
  InitializeFrameGlobals;
  GCmanagerState := CMANAGERSTATE_STARTING;
  if InitializeSettings(GetSystemPathname(CSettingsFilename)) then begin
    InitializeProxies;
    if GBasePreferences.startupDatafileMode <> CStartupFilemodeNeveropen then begin
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
      if GetSwitch('/checkonly') then begin
        xProceed := CheckPendingInformations;
      end;
      if xProceed then begin
        xFilename := GetParamValue('/savequery');
        if xFilename <> '' then begin
          GSqllogfile := GetSystemPathname(xFilename);
        end;
        xFilename := GetParamValue('/saveplugin');
        if xFilename <> '' then begin
          GPluginlogfile := GetSystemPathname(xFilename);
        end;
        if GBasePreferences.startupCheckUpdates then begin
          CheckForUpdates(True);
        end;
        Application.CreateForm(TCMainForm, CMainForm);
  GPlugins.ScanForPlugins;
        CMainForm.UpdatePluginsMenu;
        CMainForm.ExecuteOnstartupPlugins;
        if (GBasePreferences.startupDatafileMode = CStartupFilemodeLastOpened) or (GBasePreferences.startupDatafileMode = CStartupFilemodeThisfile) then begin
          CheckForBackups;
        end;
        Application.ProcessMessages;
        GCmanagerState := CMANAGERSTATE_RUNNING;
        Application.Run;
        CMainForm.FinalizeMainForm;
      end;
      SaveSettings;
    end else begin
      if xError <> '' then begin
        ShowInfo(itError, xError, xDesc)
      end;
    end;
  end;
end.
