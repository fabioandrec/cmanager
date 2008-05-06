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
{%File 'CMandb_7_8.sql'}
{%File 'CMandf.sql'}
{%File 'CMandb_9_10.sql'}
{%File 'CMandb_8_9.sql'}

uses
  MemCheck in 'MemCheck.pas',
  Forms,
  Windows,
  SysUtils,
  Classes,
  CDebug in 'CDebug.pas',
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
  CAboutFormUnit in 'CAboutFormUnit.pas' {CAboutForm},
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
  CMemoFormUnit in 'CMemoFormUnit.pas' {CMemoForm},
  CArchDatafileFormUnit in 'CArchDatafileFormUnit.pas' {CArchDatafileForm},
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
  CXmlTlb in 'Shared\CXmlTlb.pas',
  CXml in 'Shared\CXml.pas',
  CTools in 'Shared\CTools.pas',
  CHelp in 'CHelp.pas',
  CMovementListFormUnit in 'CMovementListFormUnit.pas' {CMovementListForm},
  CMovmentListElementFormUnit in 'CMovmentListElementFormUnit.pas' {CMovmentListElementForm},
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
  CReportDefFormUnit in 'CReportDefFormUnit.pas' {CReportDefForm},
  CBase64 in 'Shared\CBase64.pas',
  CParamsDefsFrameUnit in 'CParamsDefsFrameUnit.pas' {CParamsDefsFrame: TFrame},
  CParamDefFormUnit in 'CParamDefFormUnit.pas' {CParamDefForm},
  CChooseByParamsDefsFormUnit in 'CChooseByParamsDefsFormUnit.pas' {CChooseByParamsDefsForm},
  CValuelistFormUnit in 'CValuelistFormUnit.pas' {CValuelistForm},
  CInstrumentFrameUnit in 'CInstrumentFrameUnit.pas' {CInstrumentFrame: TFrame},
  CInstrumentFormUnit in 'CInstrumentFormUnit.pas' {CInstrumentForm},
  CInstrumentValueFrameUnit in 'CInstrumentValueFrameUnit.pas' {CInstrumentValueFrame: TFrame},
  CInstrumentValueFormUnit in 'CInstrumentValueFormUnit.pas' {CInstrumentValueForm},
  CUpdateExchangesFormUnit in 'CUpdateExchangesFormUnit.pas' {CUpdateExchangesForm},
  CBasics in 'Shared\CBasics.pas',
  CChoosePeriodInstrumentValueFormUnit in 'CChoosePeriodInstrumentValueFormUnit.pas' {CChoosePeriodInstrumentValueForm},
  CInvestmentMovementFrameUnit in 'CInvestmentMovementFrameUnit.pas' {CInvestmentMovementFrame: TFrame},
  CInvestmentMovementFormUnit in 'CInvestmentMovementFormUnit.pas' {CInvestmentMovementForm},
  CInvestmentPortfolioFrameUnit in 'CInvestmentPortfolioFrameUnit.pas' {CInvestmentPortfolioFrame: TFrame},
  CInitializeProviderFormUnit in 'CInitializeProviderFormUnit.pas' {CInitializeProviderForm},
  CCreateDatafileFormUnit in 'CCreateDatafileFormUnit.pas' {CCreateDatafileForm},
  CXmlFrameUnit in 'CXmlFrameUnit.pas' {CXmlFrame: TFrame},
  CUpdateDatafileFormUnit in 'CUpdateDatafileFormUnit.pas' {CUpdateDatafileForm},
  CImportExportDatafileFormUnit in 'CImportExportDatafileFormUnit.pas' {CImportExportDatafileForm},
  CChangePasswordFormUnit in 'CChangePasswordFormUnit.pas' {CChangePasswordForm},
  CHtmlMemoFormUnit in 'CHtmlMemoFormUnit.pas' {CHtmlMemoForm},
  CQuickpatternFrameUnit in 'CQuickpatternFrameUnit.pas' {CQuickpatternFrame: TFrame},
  CQuickpatternFormUnit in 'CQuickpatternFormUnit.pas' {CQuickpatternForm},
  CDepositInvestmentFrameUnit in 'CDepositInvestmentFrameUnit.pas' {CDepositInvestmentFrame: TFrame},
  CDepositInvestmentFormUnit in 'CDepositInvestmentFormUnit.pas' {CDepositInvestmentForm},
  CInvestmentPortfolioFormUnit in 'CInvestmentPortfolioFormUnit.pas' {CInvestmentPortfolioForm},
  CDeposits in 'CDeposits.pas',
  CDepositCalculatorFormUnit in 'CDepositCalculatorFormUnit.pas' {CDepositCalculatorForm},
  CDepositMovementFrameUnit in 'CDepositMovementFrameUnit.pas' {CDepositMovementFrame: TFrame};

{$R *.res}

var xFilename, xPassword: String;
    xProceed: Boolean;
begin
  GCmanagerState := CMANAGERSTATE_STARTING;
  GDebugMode := GetSwitch('/debug');
  {$IFOPT W+}
  if GDebugMode then begin
    MemChk;
  end;
  {$ENDIF}
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'SMALLICON');
  DebugStartTickCount('CManager');
  xFilename := GetParamValue('/savequery');
  if xFilename <> '' then begin
    DbSqllogfile := GetSystemPathname(xFilename);
  end;
  xFilename := GetParamValue('/saveplugin');
  if xFilename <> '' then begin
    GPluginlogfile := GetSystemPathname(xFilename);
  end;
  xFilename := GetParamValue('/savedebug');
  if xFilename <> '' then begin
    GDebugLog := GetSystemPathname(xFilename);
  end;
  InitializeFrameGlobals;
  if InitializeSettings(GetSystemPathname(CSettingsFilename)) then begin
    InitializeProxies(GDataProvider);
    if GBasePreferences.startupDatafileMode <> CStartupFilemodeNeveropen then begin
      if GBasePreferences.startupDatafileMode = CStartupFilemodeFirsttime then begin
        xFilename := GetSystemPathname(CDefaultFilename);
      end else if GBasePreferences.startupDatafileMode = CStartupFilemodeLastOpened then begin
        xFilename := GBasePreferences.lastOpenedDatafilename;
      end else if GBasePreferences.startupDatafileMode = CStartupFilemodeThisfile then begin
        xFilename := GBasePreferences.startupDatafileName;
      end;
      if ((GBasePreferences.startupDatafileMode = CStartupFilemodeFirsttime) and (not FileExists(xFilename))) or (GetSwitch('/newdatafile')) then begin
        xProceed := CreateDatafileWithWizard(xFilename, xPassword);
      end else begin
        xProceed := True;
        xPassword := '';
      end;
      if xProceed then begin
        if GetSwitch('/password') then begin
          xPassword := GetParamValue('/password');
        end;
        if GetSwitch('/datafile') then begin
          xFilename := GetParamValue('/datafile');
        end;
        xProceed := InitializeDataProvider(xFilename, xPassword, GDataProvider) = iprSuccess;
      end;
    end else begin
      xProceed := True;
    end;
    if xProceed then begin
      if GetSwitch('/checkonly') then begin
        xProceed := CheckPendingInformations;
      end;
      if xProceed then begin
        if GBasePreferences.startupCheckUpdates then begin
          CheckForUpdates(True);
        end;
        Application.CreateForm(TCMainForm, CMainForm);
        GPlugins.ScanForPlugins;
        CMainForm.UpdatePluginsMenu;
        CMainForm.ExecuteOnstartupPlugins;
        if (GBasePreferences.startupDatafileMode = CStartupFilemodeLastOpened) or (GBasePreferences.startupDatafileMode = CStartupFilemodeThisfile) then begin
          CheckForBackups(CMANAGERSTATE_STARTING);
        end;
        Application.ProcessMessages;
        GCmanagerState := CMANAGERSTATE_RUNNING;
        Application.Run;
        CMainForm.FinalizeMainForm;
      end;
      SaveSettings;
    end;
  end;
end.
