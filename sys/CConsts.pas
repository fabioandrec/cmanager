unit CConsts;

interface

uses Messages;

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

const
  CEmptyDataGid = '';
  CDefaultConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  CCreateDatabaseString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s';
  CCompactDatabaseString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s';
  CDefaultFilename = 'CManager.dat';


  CInMovement = 'I';
  COutMovement = 'O';
  CTransferMovement = 'T';

  CInProduct = 'I';
  COutProduct = 'O';

  CBankAccount = 'B';
  CCashAccount = 'C';

  CScheduleTypeOnce = 'O';
  CScheduleTypeCyclic = 'C';

  CEndConditionTimes = 'T';
  CEndConditionDate = 'D';
  CEndConditionNever = 'N';

  CTriggerTypeWeekly = 'W';
  CTriggerTypeMonthly = 'M';

  CDoneOperation = 'O';
  CDoneDeleted = 'D';
  CDoneAccepted = 'A';

  CGroupByDay = 'D';
  CGroupByWeek = 'W';
  CGroupByMonth = 'M';

  CLongDateFormat = 'ddd, yyyy-MM-dd';
  CBaseDateFormat = 'yyyy-MM-dd';
  CDayNameDateFormat = 'ddd';
  CMonthnameDateFormat = 'MMMM yyyy';

implementation

end.
