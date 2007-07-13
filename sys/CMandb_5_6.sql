create table accountExtraction (
  idAccountExtraction uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  idAccount uniqueidentifier not null,
  state varchar(1) not null,
  startDate datetime not null,
  endDate datetime not null,
  regDate datetime not null,
  description varchar(200),
  primary key (idAccountExtraction),
  constraint ck_accountExtractionState check (state in ('O', 'C', 'S')),
  constraint fk_accountExtractionaccount foreign key (idAccount) references account (idAccount)
);

create table extractionItem (
  idExtractionItem uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  regDate datetime not null,
  movementType varchar(1) not null,
  idCurrencyDef uniqueidentifier not null,
  idAccountExtraction uniqueidentifier not null,
  cash money not null,
  primary key (idExtractionItem),
  constraint ck_extractionItemmovementType check (movementType in ('I', 'O')),
  constraint fk_extractionItemaccountExtraction foreign key (idAccountExtraction) references accountExtraction (idAccountExtraction)
);


alter table baseMovement add idExtractionItem uniqueidentifier null;
alter table baseMovement add constraint fk_movementExtractionItem foreign key (idExtractionItem) references extractionItem (idExtractionItem);