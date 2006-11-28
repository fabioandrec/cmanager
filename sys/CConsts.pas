unit CConsts;

interface

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
