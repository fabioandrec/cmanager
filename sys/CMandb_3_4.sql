alter table currencyRate add rateType varchar(1) not null;
update currencyRate set rateType = 'A';
alter table currencyRate add constraint ck_rateType check (rateType in ('B', 'S', 'A'));
