create table currencyDef (
  idcurrencyDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  iso varchar(40),
  description varchar(200),
  primary key (idcurrencyDef)
);

create table currencyRate (
  idcurrencyRate uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idSourceCurrencyDef uniqueidentifier not null,
  sourceIso varchar(40),
  idTargetCurrencyDef uniqueidentifier not null,
  targetIso varchar(40),
  idCashpoint uniqueidentifier,
  quantity int not null,
  rate money not null,
  bindingDate datetime not null,
  primary key (idcurrencyRate),
  constraint fk_rateSourceCurrencyDef foreign key (idSourceCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateTargetCurrencyDef foreign key (idTargetCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_rateCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);
