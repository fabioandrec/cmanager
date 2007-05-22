alter table currencyRate add rateType varchar(1) not null;
update currencyRate set rateType = 'A';
alter table currencyRate add constraint ck_rateType check (rateType in ('B', 'S', 'A'));
alter table account drop constraint ck_accountType;
alter table account add constraint ck_accountType check (accountType in ('C', 'B', 'I'));
alter table account add idCurrencyDef uniqueidentifier not null;
update account set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table account add constraint fk_accountCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);
alter table baseMovement add idCurrencyDef uniqueidentifier not null;
update baseMovement set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table baseMovement add constraint fk_baseMovementCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);
alter table movementList add idCurrencyDef uniqueidentifier not null;
update movementList set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table movementList add constraint fk_movementListCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);
alter table plannedMovement add idCurrencyDef uniqueidentifier not null;
update plannedMovement set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table plannedMovement add constraint fk_plannedMovementCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);
drop view transactions;
create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, cash as cash from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, cash as cash from baseMovement where movementType = 'T') as v;
drop view balances;
create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, idCurrencyDef, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense from baseMovement where movementType = 'T') as v;