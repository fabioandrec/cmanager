create table quickPattern (
  idQuickPattern uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),
  movementType varchar(1) not null,
  idAccount uniqueidentifier null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  primary key (idQuickPattern),
  constraint ck_movementTypeQuickPattern check (movementType in ('I', 'O', 'T')),
  constraint fk_accountQuickPattern foreign key (idAccount) references account (idAccount),
  constraint fk_sourceAccountQuickPattern foreign key (idSourceAccount) references account (idAccount),
  constraint fk_cashPointQuickPattern foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_productQuickPattern foreign key (idProduct) references product (idProduct)
);

create table movementStatistics (
  movementCount int not null,
  cash money not null,
  movementType varchar(1) not null,
  idAccount uniqueidentifier not null,
  idSourceAccount uniqueidentifier null,
  idCashPoint uniqueidentifier null,
  idProduct uniqueidentifier null,
  idAccountCurrencyDef uniqueidentifier not null,
  idMovementCurrencyDef uniqueidentifier not null,
  movementCash money not null,
  constraint ck_statisticsmovementType check (movementType in ('I', 'O', 'T')),
  constraint fk_statisticsaccount foreign key (idAccount) references account (idAccount),
  constraint fk_statisticssourceAccount foreign key (idSourceAccount) references account (idAccount),
  constraint fk_statisticscashPoint foreign key (idCashPoint) references cashPoint (idCashPoint),
  constraint fk_statisticsproduct foreign key (idProduct) references product (idProduct),
  constraint fk_statisticsmovementAccountCurrencyDef foreign key (idAccountCurrencyDef) references currencyDef (idCurrencyDef),
  constraint fk_statisticsmovementMovementCurrencyDef foreign key (idMovementCurrencyDef) references currencyDef (idCurrencyDef)
);

insert into movementStatistics
select count(*) as movementCount, sum(cash) as cash, movementType, idAccount, idSourceAccount, idCashPoint, idProduct,
       idAccountCurrencyDef, idMovementCurrencyDef, sum(movementCash) as movementCash
from baseMovement group by movementType, idAccount, idSourceAccount, idCashPoint, idProduct, idAccountCurrencyDef, idMovementCurrencyDef;