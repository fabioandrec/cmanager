alter table account add column accountState varchar(1) not null;
alter table account add constraint ck_accountState check (accountState in ('A', 'C'));
update account set accountState = 'A';
alter table depositInvestment add column calcTax bit not null;
alter table depositInvestment add column taxRate money not null;
update depositInvestment set calcTax = 0;
update depositInvestment set taxRate = 0;
