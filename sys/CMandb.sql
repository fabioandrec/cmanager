create table cashPoint (
  idCashPoint uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  primary key (idCashPoint)
);

create table account (
  idAccount uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  accountType varchar(1) not null,
  cash money not null,
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
  primary key (idPlannedMovement),
  constraint ck_plannedType check (movementType in ('I', 'O')),
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
  primary key (idBaseMovement),
  constraint ck_movementType check (movementType in ('I', 'O', 'T')),
  constraint fk_account foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_product foreign key (idProduct) references product (idProduct)
);

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

create index ix_baseMovement_regDate on baseMovement (regDate);
create index ix_plannedDone_triggerDate on plannedDone (triggerDate);
