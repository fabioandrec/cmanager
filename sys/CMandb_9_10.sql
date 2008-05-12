create table depositInvestment (
  idDepositInvestment uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  depositState varchar(1) not null,
  name varchar(40) not null,
  description varchar(200),
  idCashPoint uniqueidentifier not null,
  idCurrencyDef uniqueidentifier not null,
  cash money not null,
  interestRate money not null,
  noncapitalizedInterest money not null,
  periodCount int not null,
  periodType varchar(1) not null,
  periodStartDate datetime not null,
  periodEndDate datetime not null,
  periodAction varchar(1) not null,
  dueCount int not null,
  dueType varchar(1) not null,
  dueStartDate datetime not null,
  dueEndDate datetime not null,
  dueAction varchar(1) not null,
  primary key (idDepositInvestment),
  constraint fk_cashPointdepositInvestment foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_currencyDefdepositInvestment foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint ck_depositState check (depositState in ('A', 'I', 'C')),
  constraint ck_depositPeriodType check (periodType in ('D', 'W', 'M', 'Y')),
  constraint ck_duePeriodType check (dueType in ('E', 'D', 'W', 'M', 'Y')),
  constraint ck_depositperiodAction check (dueAction in ('A', 'L')),
  constraint ck_depositdueAction check (dueAction in ('A', 'L'))
);

create table depositMovement (
  idDepositMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  regDateTime datetime not null,
  regOrder int not null,
  description varchar(200),
  cash money not null,
  idDepositInvestment uniqueidentifier not null,
  idAccount uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier null,
  accountCash money null,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),
  idProduct uniqueidentifier null,
  idBaseMovement uniqueidentifier null,
  primary key (idDepositMovement),
  constraint ck_movementDepositMovementType check (movementType in ('C', 'S', 'I', 'R', 'D')),  
  constraint fk_movementDepositInvestment foreign key (idDepositInvestment) references depositInvestment (idDepositInvestment),
  constraint fk_movementDepositAccount foreign key (idAccount) references account (idAccount),
  constraint fk_movementDepositProduct foreign key (idProduct) references product (idProduct),
  constraint fk_movementDepositAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_movementDepositRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),
  constraint fk_movementDepositBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement)
);

insert into cmanagerParams (paramName, paramValue) values ('DepositInvestment', '@nazwa@');
update baseMovement set isInvestmentMovement = 0 where idBaseMovement not in (select idBaseMovement from investmentMovement where idBaseMovement is not null);
alter table baseMovement add isDepositMovement bit not null;
update baseMovement set isDepositMovement = 0;

create view StnDepositMovement as
  select v.*, d.idCurrencyDef from depositMovement v
  left join depositInvestment d on d.idDepositInvestment = v.idDepositInvestment;
  
 insert into cmanagerParams (paramName, paramValue) values ('PlannedMovementTransfer', 'Planowany transfer z @kontozrodlowe@ do @kontodocelowe@');

alter table plannedMovement drop constraint ck_plannedType;
alter table plannedMovement add constraint ck_plannedType check (movementType in ('I', 'O', 'T'));

alter table plannedMovement add idDestAccount uniqueidentifier;
alter table plannedMovement add constraint fk_plannedMovementDestAccount foreign key (idDestAccount) references account (idAccount);

alter table plannedMovement drop constraint fk_plannedMovementProduct;
alter table plannedMovement add column idProduct_temp uniqueidentifier null;
update plannedMovement set idProduct_temp = idProduct;
alter table plannedMovement drop column idProduct;
alter table plannedMovement add column idProduct uniqueidentifier null;
update plannedMovement set idProduct = idProduct_temp;
alter table plannedMovement drop column idProduct_temp;
alter table plannedMovement add constraint fk_plannedMovementProduct foreign key (idProduct) references product (idProduct);

insert into cmanagerParams (paramName, paramValue) values ('BaseMovementPlannedTr', 'Transfer z @kontozrodlowe@ do @kontodocelowe@');
