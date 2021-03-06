alter table currencyRate add rateType varchar(1) not null;
update currencyRate set rateType = 'A';
alter table currencyRate add constraint ck_rateType check (rateType in ('B', 'S', 'A'));

alter table account drop constraint ck_accountType;
alter table account add constraint ck_accountType check (accountType in ('C', 'B', 'I'));
alter table account add idCurrencyDef uniqueidentifier not null;
update account set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table account add constraint fk_accountCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);

alter table baseMovement add idAccountCurrencyDef uniqueidentifier not null;
alter table baseMovement add idMovementCurrencyDef uniqueidentifier not null;
alter table baseMovement add idCurrencyRate uniqueidentifier;
alter table baseMovement add currencyQuantity int;
alter table baseMovement add currencyRate money null;
alter table baseMovement add rateDescription varchar(200);
alter table baseMovement add movementCash money not null;
update baseMovement set idAccountCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
update baseMovement set idMovementCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
update baseMovement set currencyQuantity = 1;
update baseMovement set currencyRate = 1;
update baseMovement set rateDescription = '';
update baseMovement set movementCash = cash;
alter table baseMovement add constraint fk_movementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef);
alter table baseMovement add constraint fk_movementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef);
alter table baseMovement add constraint fk_movementCurrencyRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate);

alter table plannedMovement add idMovementCurrencyDef uniqueidentifier not null;
update plannedMovement set idMovementCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table plannedMovement add constraint fk_planndedMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef);

alter table plannedDone add idDoneCurrencyDef uniqueidentifier not null;
update plannedDone set idDoneCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table plannedDone add constraint fk_plannedDoneCurrencyDef foreign key (idDoneCurrencyDef) references currencyDef (idCurrencyDef);

alter table movementList add idAccountCurrencyDef uniqueidentifier not null;
update movementList set idAccountCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table movementList add constraint fk_movementListAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef);
alter table movementLimit add idCurrencyDef uniqueidentifier not null;
update movementLimit set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table movementLimit add constraint fk_limitCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);

create table accountCurrencyRule (
  idaccountCurrencyRule uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  movementType varchar(1) not null,
  rateType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier,
  primary key (idaccountCurrencyRule),
  constraint ck_accountCurrencymovementType check (movementType in ('I', 'O', 'T')),
  constraint ck_accountCurrencyrateType check (rateType in ('B', 'S', 'A')),
  constraint fk_accountCurrencyaccount foreign key (idAccount) references account (idAccount) on delete cascade,
  constraint fk_accountCurrencycashPoint foreign key (idCashPoint) references cashPoint (idCashPoint) on delete cascade
);

drop  view transactions;
create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T') as v;

drop view balances;
create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef from baseMovement where movementType = 'T') as v;