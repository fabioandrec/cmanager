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
alter table plannedDone add idAccountCurrencyDef uniqueidentifier not null;
update plannedDone set idAccountCurrencyDef = '{00000000-0000-0000-0000-000000000001}';
alter table plannedDone add constraint fk_plannedAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef);
