create table movementList (
  idmovementList uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  description varchar(200),
  idAccount uniqueidentifier not null,
  idCashPoint uniqueidentifier not null,
  regDate datetime not null,
  weekDate datetime not null,
  monthDate datetime not null,
  yearDate datetime not null,
  movementType varchar(1) not null,  
  cash money not null,
  primary key (idmovementList),
  constraint ck_movementTypemovementList check (movementType in ('I', 'O')),  
  constraint fk_cashpointmovementList foreign key (idCashpoint) references cashpoint (idCashpoint),  
  constraint fk_accountmovementList foreign key (idAccount) references account (idAccount)
);

create table cmanagerParams (
  paramName varchar(40),
  paramValue text
);

alter table baseMovement add idmovementList uniqueidentifier null;
alter table baseMovement add constraint fk_movementList foreign key (idMovementList) references movementList (idMovementList);

alter table cashpoint add cashpointType varchar(1) not null;
update cashpoint set cashpointType = 'W';
alter table cashpoint add constraint ck_cashpointType check (cashpointType in ('I', 'O', 'W', 'X'));


create index ix_baseMovement_movementType on baseMovement (movementType);
create index ix_cmanagerParams_name on cmanagerParams (paramName);
create index ix_movementList_regDate on movementList (regDate);

create index ix_baseMovement_idAccount on baseMovement (idAccount);
create index ix_baseMovement_idSourceAccount on baseMovement (idSourceAccount);
create index ix_baseMovement_idProduct on baseMovement (idProduct);
create index ix_baseMovement_idCashpoint on baseMovement (idCashPoint);
create index ix_baseMovement_idMovementList on baseMovement (idMovementList);
