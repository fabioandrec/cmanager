create table instrument (
  idInstrument uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  symbol varchar(40) not null,
  name varchar(40) not null,
  description varchar(200),
  instrumentType varchar(1) not null,
  idCurrencyDef uniqueidentifier,
  idCashpoint uniqueidentifier,
  primary key (idInstrument),
  constraint ck_instrumentType check (instrumentType in ('I', 'S', 'B', 'F', 'R', 'U')),
  constraint uq_instrumentSymbol unique (symbol),
  constraint uq_instrumentName unique (name),
  constraint fk_instrumentCurrencyDef foreign key (idCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_instrumentCashpoint foreign key (idCashpoint) references cashpoint (idCashpoint)
);

create table instrumentValue (
  idInstrumentValue uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idInstrument uniqueidentifier not null,
  regDateTime datetime not null,
  valueOf money not null,
  primary key (idInstrumentValue),
  constraint fk_instrumentValueInstrument foreign key (idInstrument) references instrument (idInstrument)
);

create view StnInstrumentValue as
  select v.*, i.idCurrencyDef, i.instrumentType from instrumentValue v
  left join instrument i on i.idInstrument = v.idInstrument;
  
insert into cmanagerParams (paramName, paramValue) values ('InstrumentValue', '@instrument@');
update extractionItem set cash = abs(cash);

create index ix_instrumentValue_regDatetimeinstrument on instrumentValue (idInstrument, regDateTime);
create index ix_currencyRate_regDatecurrency on currencyRate (idSourceCurrencyDef, idTargetCurrencyDef, bindingDate);

alter table accountCurrencyRule add useOldRates bit not null;
update accountCurrencyRule set useOldRates = 0;

create table investmentItem (
  idInvestmentItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  idInstrument uniqueidentifier not null,
  quantity int not null,
  buyPrice money not null,
  regDateTime datetime not null,
  primary key (idInvestmentItem),
  constraint fk_investmentItem_Instrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentItem_Account foreign key (idAccount) references account (idAccount)
);