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
