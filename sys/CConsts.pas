unit CConsts;

interface

uses Windows, Messages;

const
  WM_DATAOBJECTADDED = WM_USER + 1;
  WM_DATAOBJECTEDITED = WM_USER + 2;
  WM_DATAOBJECTDELETED = WM_USER + 3;
  WM_DATAREFRESH = WM_USER + 4;
  WM_FORMMAXIMIZE = WM_USER + 5;
  WM_FORMMINIMIZE = WM_USER + 6;
  WM_OPENCONNECTION = WM_USER + 7;
  WM_CLOSECONNECTION = WM_USER + 8;
  WM_MUSTREPAINT = WM_USER + 9;
  WM_PREFERENCESCHANGED = WM_USER + 10;
  WM_STATBACKUPSTARTED = WM_USER + 11;
  WM_STATPROGRESS = WM_USER + 12;
  WM_STATBACKUPFINISHEDSUCC = WM_USER + 13;
  WM_STATBACKUPFINISHEDERR = WM_USER + 14;
  WM_STATCLEAR = WM_USER + 15;
  WM_GETSELECTEDID = WM_USER + 16;
  WM_GETSELECTEDTYPE = WM_USER + 17;

  WMOPT_NONE = 0;
  WMOPT_BASEMOVEMENT = 1;
  WMOPT_MOVEMENTLIST = 2;

const
  CCSSReportFile = 'report.css';
  CXSLReportFile = 'transform.xml';
  CHTMReportFile = 'report.htm';
  CXSLDefaultTransformResname = 'DEFAULTSS.XSL';
  CXSLDefaultTransforRestype = MAKEINTRESOURCE(23);
  CMSXmlLibraryName = 'msxml.dll';

const
  CDefaultConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  CDefaultFilename = 'CManager.dat';

  CFilterAllElements = '@';

  CInMovement = 'I';
  COutMovement = 'O';
  CTransferMovement = 'T';

  CInProduct = 'I';
  COutProduct = 'O';

  CBankAccount = 'B';
  CCashAccount = 'C';
  CInvestmentAccount = 'I';

  CScheduleTypeOnce = 'O';
  CScheduleTypeCyclic = 'C';

  CEndConditionTimes = 'T';
  CEndConditionDate = 'D';
  CEndConditionNever = 'N';

  CFreeDayExedcutes = 'E';
  CFreeDayIncrements = 'I';
  CFreeDayDecrements = 'D';

  CTriggerTypeWeekly = 'W';
  CTriggerTypeMonthly = 'M';

  CDoneOperation = 'O';
  CDoneDeleted = 'D';
  CDoneAccepted = 'A';

  CGroupByDay = 'D';
  CGroupByWeek = 'W';
  CGroupByMonth = 'M';

  CGroupByAccount = 'A';
  CGroupByCashpoint = 'C';
  CGroupByProduct = 'P';
  CGroupByNone = 'N';

  CLongDateFormat = 'ddd, yyyy-MM-dd';
  CBaseDateFormat = 'yyyy-MM-dd';
  CDayNameDateFormat = 'ddd';
  CMonthnameDateFormat = 'MMMM yyyy';

  CStartupFilemodeLastOpened = 0;
  CStartupFilemodeThisfile = 1;
  CStartupFilemodeNeveropen = 2;
  CStartupFilemodeFirsttime = 3;

  CStartupInfoToday = 0;
  CStartupInfoNextday = 1;
  CStartupInfoThisweek = 2;
  CStartupInfoNextweek = 3;
  CStartupInfoThismonth = 4;
  CStartupInfoNextmonth = 5;
  CStartupInfoDays = 6;

  CCashpointTypeAll = 'W';
  CCashpointTypeIn = 'I';
  CCashpointTypeOut = 'O';
  CCashpointTypeOther = 'X';

  CLimitActive = '1';
  CLimitDisabled = '0';


  CLimitBoundaryTypeToday = 'T';
  CLimitBoundaryTypeWeek = 'W';
  CLimitBoundaryTypeMonth = 'M';
  CLimitBoundaryTypeQuarter = 'Q';
  CLimitBoundaryTypeHalfyear = 'H';
  CLimitBoundaryTypeYear = 'Y';
  CLimitBoundaryTypeDays = 'D';

  CLimitBoundaryCondEqual = '=';
  CLimitBoundaryCondLess = '<';
  CLimitBoundaryCondGreater = '>';
  CLimitBoundaryCondLessEqual = '<=';
  CLimitBoundaryCondGreaterEqual = '>=';

  CLimitSumtypeOut = 'O';
  CLimitSumtypeIn = 'I';
  CLimitSumtypeBalance = 'B';

  CLimitSumtypeOutDescription = 'Rozchody';
  CLimitSumtypeInDescription = 'Przychody';
  CLimitSumtypeBalanceDescription = 'Saldo';

  CCurrencyRateFilterToday = 'T';
  CCurrencyRateFilterYesterday = 'Y';
  CCurrencyRateFilterWeek = 'W';
  CCurrencyRateFilterMonth = 'M';
  CCurrencyRateFilterOther = 'O';

  CCurrencyRateTypeAverage = 'A';
  CCurrencyRateTypeSell = 'S';
  CCurrencyRateTypeBuy = 'B';

  CCurrencyRateTypeAverageDesc = 'kurs œredni';
  CCurrencyRateTypeSellDesc = 'kurs sprzeda¿y';
  CCurrencyRateTypeBuyDesc = 'kurs kupna';

  CCurrencyViewMovements = 'M';
  CCurrencyViewAccounts = 'A';

  CExtractionStateOpen = 'O';
  CExtractionStateClose = 'C';
  CExtractionStateStated = 'S';

  CExtractionStateOpenDescription = 'Otwarty';
  CExtractionStateCloseDescription = 'Zamkniêty';
  CExtractionStateStatedDescription = 'Uzgodniony';

  CXsltTypeDefault = 'D';
  CXsltTypeSystem = 'S';
  CXsltTypePrivate = 'P';

const
  CInMovementDescription = 'Przychód';
  COutMovementDescription = 'Rozchód';
  CTransferMovementDescription = 'Transfer';

  CLimitSupressedDesc = 'Przekroczony';
  CLimitValidDesc = 'Poprawny';

  CPlannedDoneDescription = 'Wykonana';
  CPlannedRejectedDescription = 'Odrzucona';
  CPlannedAcceptedDescription = 'Uznana';
  CPlannedScheduledTodayDescription = 'Na dziœ';
  CPlannedScheduledReady = 'Zaplanowana';
  CPlannedScheduledOvertime = 'Zaleg³a';

const
  CBaseMovementTypes: array[0..4] of String = ('Rozchód jednorazowy', 'Przychód jednorazowy', 'Transfer', 'Planowany rozchód', 'Planowany przychód');

  CSimpleMovementTypes: array[0..2] of String = ('Rozchód jednorazowy', 'Przychód jednorazowy', 'Transfer');
  CSimpleMovementSymbols: array[0..2] of String = ('O', 'I', 'T');

  CDescPatternsKeys: array[0..6, 0..4] of string =
    (('BaseMovementOut', 'BaseMovementIn', 'BaseMovementTr', 'BaseMovementPlannedOut', 'BaseMovementPlannedIn'),
     ('MovementListOut', 'MovementListIn', '', '', ''),
     ('PlannedMovementOut', 'PlannedMovementIn', '', '', ''),
     ('MovementListElement', '', '', '', ''),
     ('Currencyrate', '', '', '', ''),
     ('AccountExctraction', '', '', '', ''),
     ('ExctractionItem', 'ExtractionItemIn', 'ExtractionItemOut', '', ''));

  CDescPatternsNames: array[0..6, 0..4] of string =
    (('Rozchód jednorazowy', 'Przychód jednorazowy', 'Transfer', 'Planowany rozchód', 'Planowany przychód'),
     ('Rozchód', 'Przychód', '', '', ''),
     ('Rozchód', 'Przychód', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Wszystkie elementy', '', '', '', ''),
     ('Uznanie', 'Obci¹¿enie', '', '', ''));


  CBackupActionOnce = 0;
  CBackupActionAlways = 1;
  CBackupActionAsk = 2;
  CBackupActionNever = 3;

  CParamTypeText = 'text';
  CParamTypeDecimal = 'decimal';
  CParamTypeDate = 'date';
  CParamTypePeriod = 'period';
  CParamTypeDataobject = 'dataobject';

  CReportParamTypes: array[0..4, 0..1] of String =
    (
     ('tekst', CParamTypeText),
     ('liczba', CParamTypeDecimal),
     ('data', CParamTypeDate),
     ('zakres dat', CParamTypePeriod),
     ('obiekt', CParamTypeDataobject)
    );

implementation

end.
