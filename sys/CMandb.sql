create table cashPoint (
  idCashPoint uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  cashpointType varchar(1) not null,
  primary key (idCashPoint),
  constraint ck_cashpointType check (cashpointType in ('I', 'O', 'W', 'X'))
);

create table unitDef (
  idUnitDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  description varchar(200),
  primary key (idUnitDef)
);

create table currencyDef (
  idcurrencyDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  iso varchar(40),
  description varchar(200),
  isBase bit not null,
  primary key (idcurrencyDef)
);

create table currencyRate (
  idcurrencyRate uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idSourceCurrencyDef uniqueidentifier not null,
  idTargetCurrencyDef uniqueidentifier not null,
  idCashpoint uniqueidentifier not null,
  quantity int not null,
  rate money not null,
  bindingDate datetime not null,
  description varchar(200),
  rateType varchar(1) not null,
  primary key (idcurrencyRate),
  constraint fk_rateSourceCurrencyDef foreign key (idSourceCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateTargetCurrencyDef foreign key (idTargetCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint),
  constraint ck_rateType check (rateType in ('B', 'S', 'A'))
);

create table account (
  idAccount uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  accountType varchar(1) not null,
  cash money not null,
  initialBalance money not null,
  accountNumber varchar(50),
  idCashPoint uniqueidentifier,
  idCurrencyDef uniqueidentifier not null,
  primary key (idAccount),
  constraint ck_accountType check (accountType in ('C', 'B', 'I')),
  constraint fk_accountCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_accountCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

create table product (
  idProduct uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  idParentProduct uniqueidentifier,
  productType varchar(1) not null,
  idUnitDef uniqueidentifier,
  primary key (idProduct),
  constraint fk_parentProduct foreign key (idParentProduct) references product (idProduct),
  constraint ck_productType check (productType in ('I', 'O')),
  constraint fk_productunitDef foreign key (idUnitDef) references unitDef (idUnitDef)
);

create table accountExtraction (
  idAccountExtraction uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  state varchar(1) not null,
  startDate datetime not null,
  endDate datetime not null,
  regDate datetime not null,
  description varchar(200),
  primary key (idAccountExtraction),
  constraint ck_accountExtractionState check (state in ('O', 'C', 'S')),
  constraint fk_accountExtractionaccount foreign key (idAccount) references account (idAccount)
);

create table extractionItem (
  idExtractionItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  regDate datetime not null,
  accountingDate datetime not null,
  movementType varchar(1) not null,
  idCurrencyDef uniqueidentifier not null,
  idAccountExtraction uniqueidentifier not null,
  cash money not null,
  primary key (idExtractionItem),
  constraint ck_extractionItemmovementType check (movementType in ('I', 'O')),
  constraint fk_extractionItemaccountExtraction foreign key (idAccountExtraction) references accountExtraction (idAccountExtraction) on delete cascade,
  constraint fk_extractionItemCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

create table plannedMovement (
  idPlannedMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  cash money not null,
  movementType varchar(1) not null,
  isActive bit not null,
  idAccount uniqueidentifier,
  idCashPoint uniqueidentifier,
  idProduct uniqueidentifier not null,
  scheduleType varchar(1) not null,
  scheduleDate datetime not null,
  endCondition varchar(1) not null,
  endCount int,
  endDate datetime,
  triggerType varchar(1) not null,
  triggerDay int not null,
  freeDays varchar(1) not null,
  idMovementCurrencyDef uniqueidentifier not null,
  quantity money not null,
  idUnitdef uniqueidentifier,
  primary key (idPlannedMovement),
  constraint ck_plannedType check (movementType in ('I', 'O')),
  constraint ck_freeDays check (freeDays in ('E', 'D', 'I')),
  constraint fk_plannedMovementAccount foreign key (idAccount) references account (idAccount),
  constraint fk_plannedMovementCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_plannedMovementProduct foreign key (idProduct) references product (idProduct),
  constraint ck_scheduleType check (scheduleType in ('O', 'C')),
  constraint ck_endCondition check (endCondition in ('T', 'D', 'N')),
  constraint ck_endConditionCountDate check ((endCount is not null) or (endDate is not null)),
  constraint ck_triggerType check (triggerType in ('W', 'M')),
  constraint fk_planndedMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_plannedMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef)
);

create table plannedDone (
  idPlannedDone uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  triggerDate datetime not null,
  doneDate datetime not null,
  doneState varchar(1) not null,
  idPlannedMovement uniqueidentifier not null,
  description varchar(200),
  cash money not null,
  idDoneCurrencyDef uniqueidentifier not null,
  primary key (idPlannedDone),
  constraint fk_plannedMovement foreign key (idPlannedMovement) references plannedMovement (idPlannedMovement),
  constraint ck_doneState check (doneState in ('O', 'D', 'A')),
  constraint fk_plannedDoneCurrencyDef foreign key (idDoneCurrencyDef) references currencyDef (idCurrencyDef)
);

create table movementList (
  idmovementList uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier not null,
  regDate datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  movementType varchar(1) not null,
  cash money not null,
  idAccountCurrencyDef uniqueidentifier not null,
  idExtractionItem uniqueidentifier null,
  isStated bit not null,
  primary key (idmovementList),
  constraint ck_movementTypemovementList check (movementType in ('I', 'O')),
  constraint fk_cashpointmovementList foreign key (idCashpoint) references cashpoint (idCashpoint),
  constraint fk_accountmovementList foreign key (idAccount) references account (idAccount),
  constraint fk_movementListAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementListExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem)
);

create table quickPattern (
  idQuickPattern uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  movementType varchar(1) not null,
  idAccount uniqueidentifier null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  primary key (idQuickPattern),
  constraint ck_movementTypeQuickPattern check (movementType in ('I', 'O', 'T')),
  constraint fk_accountQuickPattern foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccountQuickPattern foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPointQuickPattern foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_productQuickPattern foreign key (idProduct) references product (idProduct)
);

create table baseMovement (
  idBaseMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  cash money not null,
  movementType varchar(1) not null,
  idAccount uniqueidentifier not null,
  regDate datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  idPlannedDone uniqueidentifier null,
  idMovementList uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier not null,
  idMovementCurrencyDef uniqueidentifier not null,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  movementCash money not null,
  idExtractionItem uniqueidentifier null,
  isStated bit not null,
  idSourceExtractionItem uniqueidentifier null,
  isSourceStated bit not null,
  quantity money not null,
  idUnitdef uniqueidentifier,
  isInvestmentMovement bit not null,
  primary key (idBaseMovement),
  constraint ck_movementType check (movementType in ('I', 'O', 'T')),
  constraint fk_account foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_product foreign key (idProduct) references product (idProduct),
  constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList),
  constraint fk_movementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementCurrencyRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),
  constraint fk_movementExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem),
  constraint fk_movementSourceExtractionItem foreign key (idSourceExtractionItem) references extractionItem (idExtractionItem),
  constraint fk_baseMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef)
);

create table movementFilter (
  idMovementFilter uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  isTemp bit not null,
  primary key (idMovementFilter)
);

create table accountFilter (
  idMovementFilter uniqueidentifier not null,
  idAccount uniqueidentifier not null,
  constraint fk_accountMovementFilter foreign key (idMovementFilter) references movementFilter (idMovementFilter),
  constraint fk_accountMovementAccount foreign key (idAccount) references account (idAccount)
);

create table cashpointFilter (
  idMovementFilter uniqueidentifier not null,
  idCashpoint uniqueidentifier not null,
  constraint fk_cashpointMovementFilter foreign key (idMovementFilter) references movementFilter (idMovementFilter),
  constraint fk_cashpointMovementCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

create table productFilter (
  idMovementFilter uniqueidentifier not null,
  idProduct uniqueidentifier not null,
  constraint fk_productMovementFilter foreign key (idMovementFilter) references movementFilter (idMovementFilter),
  constraint fk_productMovementproduct foreign key (idProduct) references product (idProduct)
);

create table profile (
  idProfile uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  idAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  primary key (idProfile),
  constraint fk_productprofile foreign key (idProduct) references product (idProduct),
  constraint fk_cashpointprofile foreign key (idCashpoint) references cashpoint (idCashpoint),
  constraint fk_accountprofile foreign key (idAccount) references account (idAccount)
);

create table cmanagerParams (
  paramName varchar(40),
  paramValue text
);

create table movementLimit (
  idmovementLimit uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40),
  description varchar(200),
  idmovementFilter uniqueidentifier,
  isActive bit not null,
  boundaryAmount money not null,
  boundaryType varchar(1) not null,
  boundarycondition varchar(2) not null,
  boundaryDays int,
  sumType varchar(1) not null,
  idCurrencyDef uniqueidentifier not null,
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),
  constraint ck_sumTypelimit check (sumType in ('I', 'O', 'B')),
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter),
  constraint fk_limitCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef)
);

create table accountCurrencyRule (
  idaccountCurrencyRule uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  rateType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier,
  useOldRates bit not null,
  primary key (idaccountCurrencyRule),
  constraint ck_accountCurrencymovementType check (movementType in ('I', 'O', 'T')),
  constraint ck_accountCurrencyrateType check (rateType in ('B', 'S', 'A')),
  constraint fk_accountCurrencyaccount foreign key (idAccount) references account (idAccount) on delete cascade,
  constraint fk_accountCurrencycashPoint foreign key (idCashPoint) references cashPoint (idCashPoint) on delete cascade
);

create table reportDef (
  idreportDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  queryText memo not null,
  paramsDefs memo,
  xsltText memo,
  xsltType varchar(1) not null,
  primary key (idreportDef),
  constraint ck_xsltType check (xsltType in ('D', 'S', 'P'))
);

create table instrument (
  idInstrument uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  symbol varchar(40) not null,
  name varchar(40) not null,
  description varchar(200),
  instrumentType varchar(1) not null,
  idCurrencyDef uniqueidentifier,
  idCashpoint uniqueidentifier,
  primary key (idInstrument),
  constraint ck_instrumentType check (instrumentType in ('I', 'S', 'B', 'F', 'R', 'U')),
  constraint uq_instrumentSymbol unique (symbol),
  constraint uq_instrumentName unique (name),
  constraint fk_instrumentCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_instrumentCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

create table instrumentValue (
  idInstrumentValue uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idInstrument uniqueidentifier not null,
  regDateTime datetime not null,
  valueOf money not null,
  primary key (idInstrumentValue),
  constraint fk_instrumentValueInstrument foreign key (idInstrument) references instrument (idInstrument)
);

create table investmentItem (
  idInvestmentItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  idInstrument uniqueidentifier not null,
  quantity int not null,
  primary key (idInvestmentItem),
  constraint fk_investmentItem_Instrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentItem_Account foreign key (idAccount) references account (idAccount)
);

create table investmentMovement (
  idInvestmentMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  movementType varchar(1) not null,
  regDateTime datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  idInstrument uniqueidentifier not null,
  idInstrumentCurrencyDef uniqueidentifier not null,
  quantity integer not null,
  idInstrumentValue uniqueidentifier,
  valueOf money not null,
  summaryOf money not null,
  idAccount uniqueidentifier not null,  
  idAccountCurrencyDef uniqueidentifier not null,
  valueOfAccount money not null,
  summaryOfAccount money not null,
  idProduct uniqueidentifier,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  idBaseMovement uniqueidentifier ,
  primary key (idInvestmentMovement),
  constraint ck_investmentMovementmovementType check (movementType in ('B', 'S')),
  constraint fk_investmentMovementInstrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentMovementInstrumentCurrency foreign key (idInstrumentCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementInstrumentValue foreign key (idInstrumentValue) references instrumentValue (idInstrumentValue),
  constraint fk_investmentMovementaccount foreign key (idAccount) references account (idAccount),
  constraint fk_investmentMovementAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementProduct foreign key (idProduct) references product (idProduct),
  constraint fk_investmentMovementRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),  
  constraint fk_investmentMovementBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement)
);

insert into cmanagerParams (paramName, paramValue) values ('BaseMovementOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementTr', 'Transfer z @kontozrodlowe@ do @kontodocelowe@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListOut', '@kontrahent@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListIn', '@kontrahent@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementOut', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementIn', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('MovementListElement', '@kategoria@');
insert into cmanagerParams (paramName, paramValue) values ('Currencyrate', '@isobazowej@/@isodocelowej@');
insert into cmanagerParams (paramName, paramValue) values ('AccountExctraction', '@konto@ - wyci¹g z dnia @datawyciagu@');
insert into cmanagerParams (paramName, paramValue) values ('InstrumentValue', '@instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementBuy', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementSell', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementBuyFree', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementSellFree', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('DepositInvestment', '@nazwa@ - @stan@');

insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description, isBase) values ('{00000000-0000-0000-0000-000000000001}', #2007-04-18 10:33:02#, #2007-04-18 10:33:02#, 'z³oty polski', 'z³', 'PLN', 'z³oty polski', 1);
insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000001}', #2007-09-02 12:13:53#, #2007-09-03 21:10:41#, 'Lista kont - raport w³asny', 'Jest to przyk³ad definiowalnego raportu z wykorzystaniem prezentacji wyników raportu w postaci dokumentu XML', 'eNorTs1JTS5R0FJIK8rPVUhMTs4vzSsBAFJRB6w=', 'eNqzsa/IzVEoSy0qzszPs1Uy1DNQUkjNS85PycxLt1UKz8xLyS8v1jU0MjVQsrfj5bIpSCxKzC12SU0r1gdyAXd2EyU=', '', 'S');
insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000002}', #2007-09-03 20:31:23#, #2007-09-03 21:10:55#, 'Operacje w/g kategorii - raport w³asny', 'Jest to przyk³adowy raport definiowalny korzystaj¹cy z domyœlnego arkusza styli, czyli podstawowej transformacji XSLT, znajduj¹cej siê w pliku transform.xml w katalogu instalacyjnym CManager-a.', 'eNptkEsOgkAQRPcm3qEWLNAQ4gXcsXHh5woN0yBmmCbzEfQsns9zyMfIxl5VJV31Ou1Yc+HRpoYaBjmc6NlRgrou49qZoHV80PJ6bxLsEsxyXJsUSisNWisqjB3rFaC59JDg2eImtUHsZkAhwfh4u2QHhLp8k1NNTo6PcueGjcdY9X+6K1uG5Sojz8jZd8wGkSJPZxWBjJpNJhEqK6FF/lhQE78f28WgT5cT9sMLfu4D9JxbcQ==', 'eNqlj7sKwkAQRXsh/zBMH/MAu2zSpBdsBLslMwmLZifuJD7+3sU0CnZ298DlHm7VPMYL3DioE2+w2OYI7Dsh5weDR+dJ7poW5S7Hpk421WSDHbXlXus1xwjejmyQ7Gz3hECsncE2EkjEIcgyGTzZc2CFWEKYn9PaZwSnB74uLjAZTAuEPrzHSsx+Clr5EpD8Jcg+7iSbF/yRVtM=', '', 'D');

create table cmanagerInfo (
  version varchar(20) not null,
  created datetime not null
);

create table movementStatistics (
  movementCount int not null,
  cash money not null,
  movementType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier not null,
  idMovementCurrencyDef uniqueidentifier not null,
  movementCash money not null,
  constraint ck_statisticsmovementType check (movementType in ('I', 'O', 'T')),
  constraint fk_statisticsaccount foreign key (idAccount) references account (idAccount),
  constraint fk_statisticssourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_statisticscashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_statisticsproduct foreign key (idProduct) references product (idProduct),
  constraint fk_statisticsmovementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_statisticsmovementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef)
);

create table depositInvestment (
  idDepositInvestment uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  depositState varchar(1) not null,
  name varchar(40) not null,
  openDate datetime not null,
  description varchar(200),
  idAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idCurrencyDef uniqueidentifier not null,
  initialCash money not null,
  currentCash money not null,
  interestRate money not null,
  noncapitalizedInterest money not null,
  periodCount int not null,
  periodType varchar(1) not null,
  periodLastDate datetime null,
  periodNextDate datetime not null,
  periodAction varchar(1) not null,
  dueCount int not null,
  dueType varchar(1) not null,
  dueLastDate datetime null,
  dueNextDate datetime not null,
  dueAction varchar(1) not null,
  primary key (idDepositInvestment),
  constraint fk_accountdepositInvestment foreign key (idAccount) references account (idAccount),
  constraint fk_cashPointdepositInvestment foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_currencyDefdepositInvestment foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),  
  constraint ck_depositState check (depositState in ('A', 'I', 'C')),
  constraint ck_depositPeriodType check (periodType in ('D', 'W', 'M', 'Y')),
  constraint ck_duePeriodType check (dueType in ('E', 'D', 'W', 'M', 'Y')),
  constraint ck_depositperiodAction check (dueAction in ('A', 'L')),
  constraint ck_depositdueAction check (dueAction in ('A', 'L'))
);

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view investments as select * from (
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, quantity, idAccountCurrencyDef from investmentMovement where movementType = 'B'
 union all
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, (-1) * quantity, idAccountCurrencyDef from investmentMovement where movementType = 'S') as v;

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left outer join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left outer join productFilter p on p.idMovementFilter = m.idMovementFilter);

create view StnInstrumentValue as
  select v.*, i.idCurrencyDef, i.instrumentType from instrumentValue v
  left join instrument i on i.idInstrument = v.idInstrument;

create view StnInvestmentPortfolio as
  select v.idInstrument, i.idCurrencyDef, i.name as instrumentName, i.instrumentType, v.idAccount,
         a.name as accountName, idInvestmentItem, v.created, v.modified, v.quantity,
         (select top 1 valueOf from instrumentValue where idInstrument = v.idInstrument order by regDateTime desc) as valueOf
    from ((investmentItem v
      left outer join instrument i on i.idInstrument = v.idInstrument)
      left outer join account a on a.idAccount = v.idAccount);

create index ix_baseMovement_regDate on baseMovement (regDate);
create index ix_movementList_regDate on movementList (regDate);
create index ix_baseMovement_movementType on baseMovement (movementType);
create index ix_plannedDone_triggerDate on plannedDone (triggerDate);
create index ix_cmanagerParams_name on cmanagerParams (paramName);
create index ix_baseMovement_idAccount on baseMovement (idAccount);
create index ix_baseMovement_idSourceAccount on baseMovement (idSourceAccount);
create index ix_baseMovement_idProduct on baseMovement (idProduct);
create index ix_baseMovement_idCashpoint on baseMovement (idCashPoint);
create index ix_baseMovement_idMovementList on baseMovement (idMovementList);
create index ix_instrumentValue_regDatetimeinstrument on instrumentValue (idInstrument, regDateTime);
create index ix_currencyRate_regDatecurrency on currencyRate (idSourceCurrencyDef, idTargetCurrencyDef, bindingDate);
create index ix_investmentMovement_regDatetime on investmentMovement (regDateTime);
create index ix_currencyRate_regDate on currencyRate (bindingDate);
create index ix_instrumentValue_regDatetime on instrumentValue (regDateTime);
create index ix_investmentItemInstrument on investmentItem (idInstrument, idAccount);