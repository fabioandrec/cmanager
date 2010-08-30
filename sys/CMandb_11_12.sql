alter table account add column accountState varchar(1) not null;
alter table account add constraint ck_accountState check (accountState in ('A', 'C'));
update account set accountState = 'A';
