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

create table investmentMovement (
  idInvestmentMovement uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  movementType varchar(1) not null,
  regDateTime datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  idInstrument uniqueidentifier not null,
  idInstrumentCurrencyDef uniqueidentifier not null,
  quantity integer not null,
  idInstrumentValue uniqueidentifier,
  valueOf money not null,
  summaryOf money not null,
  idAccount uniqueidentifier not null,  
  idAccountCurrencyDef uniqueidentifier not null,
  valueOfAccount money not null,
  summaryOfAccount money not null,
  idProduct uniqueidentifier,
  idCurrencyRate uniqueidentifier,
  currencyQuantity int,
  currencyRate money null,
  rateDescription varchar(200),  
  idInvestmentItem uniqueidentifier not null,
  idBaseMovement uniqueidentifier,  
  primary key (idInvestmentMovement),
  constraint ck_investmentMovementmovementType check (movementType in ('B', 'S')),
  constraint fk_investmentMovementInstrument foreign key (idInstrument) references instrument (idInstrument),
  constraint fk_investmentMovementInstrumentCurrency foreign key (idInstrumentCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementInstrumentValue foreign key (idInstrumentValue) references instrumentValue (idInstrumentValue),
  constraint fk_investmentMovementaccount foreign key (idAccount) references account (idAccount),
  constraint fk_investmentMovementAccountCurrency foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_investmentMovementProduct foreign key (idProduct) references product (idProduct),
  constraint fk_investmentMovementRate foreign key (idCurrencyRate) references currencyRate (idCurrencyRate),  
  constraint fk_investmentMovementInvestmentItem foreign key (idInvestmentItem) references investmentItem (idInvestmentItem),
  constraint fk_investmentMovementBaseMovement foreign key (idBaseMovement) references baseMovement (idBaseMovement)
);

create index ix_investmentMovement_regDatetime on investmentMovement (regDateTime);
create index ix_currencyRate_regDate on currencyRate (bindingDate);
create index ix_instrumentValue_regDatetime on instrumentValue (regDateTime);
create index ix_investmentItemInstrument on investmentItem (idInstrument, idAccount);

insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementOut', '@rodzaj@ - @instrument@');
insert into cmanagerParams (paramName, paramValue) values ('InvestmentMovementIn', '@rodzaj@ - @instrument@');

alter table baseMovement add isInvestmentMovement bit not null;
update baseMovement set isInvestmentMovement = 0;