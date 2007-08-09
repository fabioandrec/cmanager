create table unitDef (
  idUnitDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  description varchar(200),
  primary key (idUnitDef)
);
alter table product add column idUnitDef uniqueidentifier;
alter table product add constraint fk_productunitDef foreign key (idUnitDef) references unitDef (idUnitDef);

alter table baseMovement add column quantity money not null;
alter table plannedMovement add column quantity money not null;

update baseMovement set quantity = 1;
update plannedMovement set quantity = 1;

drop view transactions;
drop view balances;

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity from baseMovement where movementType = 'T') as v;
