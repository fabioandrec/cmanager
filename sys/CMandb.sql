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
  primary key (idAccount),
  constraint ck_accountType check (accountType in ('C', 'B')),
  constraint fk_accountCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint)
);

create table product (
  idProduct uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  idParentProduct uniqueidentifier,
  productType varchar(1) not null,
  primary key (idProduct),
  constraint fk_parentProduct foreign key (idParentProduct) references product (idProduct),
  constraint ck_productType check (productType in ('I', 'O'))
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
  primary key (idPlannedMovement),
  constraint ck_plannedType check (movementType in ('I', 'O')),
  constraint ck_freeDays check (freeDays in ('E', 'D', 'I')),
  constraint fk_plannedMovementAccount foreign key (idAccount) references account (idAccount),
  constraint fk_plannedMovementCashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_plannedMovementProduct foreign key (idProduct) references product (idProduct),
  constraint ck_scheduleType check (scheduleType in ('O', 'C')),
  constraint ck_endCondition check (endCondition in ('T', 'D', 'N')),
  constraint ck_endConditionCountDate check ((endCount is not null) or (endDate is not null)),
  constraint ck_triggerType check (triggerType in ('W', 'M'))
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
  primary key (idPlannedDone),
  constraint fk_plannedMovement foreign key (idPlannedMovement) references plannedMovement (idPlannedMovement),
  constraint ck_doneState check (doneState in ('O', 'D', 'A'))
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
  primary key (idmovementList),
  constraint ck_movementTypemovementList check (movementType in ('I', 'O')),  
  constraint fk_cashpointmovementList foreign key (idCashpoint) references cashpoint (idCashpoint),  
  constraint fk_accountmovementList foreign key (idAccount) references account (idAccount)
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
  primary key (idBaseMovement),
  constraint ck_movementType check (movementType in ('I', 'O', 'T')),
  constraint fk_account foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_product foreign key (idProduct) references product (idProduct),
  constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList)
);

create table movementFilter (
  idMovementFilter uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
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
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),  
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),  
  constraint ck_sumTypelimit check (sumType in ('I', 'O', 'B')),  
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter)
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
  idCashpoint uniqueidentifier,
  quantity int not null,
  rate money not null,
  bindingDate datetime not null,
  description varchar(200),
  primary key (idcurrencyRate),
  constraint fk_rateSourceCurrencyDef foreign key (idSourceCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateTargetCurrencyDef foreign key (idTargetCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
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

insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description, isBase) values ('{BC646D67-6074-49B1-B895-1579EE984182}', #2007-04-18 10:33:02#, #2007-04-18 10:33:02#, 'z³oty polski', 'z³', 'PLN', 'z³oty polski', 1);

create table cmanagerInfo (
  version varchar(20) not null,
  created datetime not null
);

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense from baseMovement where movementType = 'T') as v;
 
create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left join productFilter p on p.idMovementFilter = m.idMovementFilter);

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