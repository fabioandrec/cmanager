create table currencyDef (
  idcurrencyDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  iso varchar(40),
  description varchar(200),
  isBase bit not null,
  primary key (idcurrencyDef)
);

create table currencyRate (
  idcurrencyRate uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idSourceCurrencyDef uniqueidentifier not null,
  idTargetCurrencyDef uniqueidentifier not null,
  idCashpoint uniqueidentifier,
  quantity int not null,
  rate money not null,
  bindingDate datetime not null,
  description varchar(200),
  primary key (idcurrencyRate),
  constraint fk_rateSourceCurrencyDef foreign key (idSourceCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateTargetCurrencyDef foreign key (idTargetCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

insert into cmanagerParams (paramName, paramValue) values ('Currencyrate', '@isobazowej@/@isodocelowej@');
insert into currencyDef (idcurrencyDef, created, modified, name, symbol, iso, description, isBase) values ('{00000000-0000-0000-0000-000000000001}', #2007-04-18 10:33:02#, #2007-04-18 10:33:02#, 'z³oty polski', 'z³', 'PLN', 'z³oty polski', 1);
