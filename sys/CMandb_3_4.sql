alter table currencyRate add rateType varchar(1) not null;
update currencyRate set rateType = 'A';
alter table currencyRate add constraint ck_rateType check (rateType in ('B', 'S', 'A'));
alter table account drop constraint ck_accountType;
alter table account add constraint ck_accountType check (accountType in ('C', 'B', 'I'));
alter table account add idCurrencyDef uniqueidentifier not null;
alter table account add constraint fk_accountCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef);
update account set idCurrencyDef = '{00000000-0000-0000-0000-000000000001}';