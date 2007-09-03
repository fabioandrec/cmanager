create table unitDef (
  idUnitDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  symbol varchar(40) not null,
  description varchar(200),
  primary key (idUnitDef)
);

alter table product add column idUnitDef uniqueidentifier;
alter table product add constraint fk_productunitDef foreign key (idUnitDef) references unitDef (idUnitDef);
alter table baseMovement add column quantity money not null;
alter table plannedMovement add column quantity money not null;
update baseMovement set quantity = 1;
update plannedMovement set quantity = 1;

alter table baseMovement add column idUnitDef uniqueidentifier;
alter table plannedMovement add column idUnitDef uniqueidentifier;
alter table baseMovement add constraint fk_baseMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef);
alter table plannedMovement add constraint fk_plannedMovementunitDef foreign key (idUnitDef) references unitDef (idUnitDef);

drop view transactions;
drop view balances;

create view transactions as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * cash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, (-1) * movementCash as cash, (-1) * movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as cash, movementCash as movementCash, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create view balances as select * from (
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'I'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, quantity, idUnitDef from baseMovement where movementType = 'O'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idSourceAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, 0 as income, cash as expense, 0 as movementIncome, movementCash as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T'
 union all
 select idBaseMovement, movementType, description, idProduct, idCashpoint, idAccount as idAccount, regDate, created, weekDate, monthDate, yearDate, cash as income, 0 as expense, movementCash as movementIncome, 0 as movementExpense, idAccountCurrencyDef, idMovementCurrencyDef, 0 as quantity, null as idUnitDef from baseMovement where movementType = 'T') as v;

create table reportDef (
  idreportDef uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40) not null,
  description varchar(200),  
  queryText memo not null,
  paramsDefs memo,
  xsltText memo,
  xsltType varchar(1) not null,
  primary key (idreportDef),
  constraint ck_xsltType check (xsltType in ('D', 'S', 'P'))
);

insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000001}', #2007-09-02 12:13:53#, #2007-09-03 21:10:41#, 'Lista kont - raport w³asny', 'Jest to przyk³ad definiowalnego raportu z wykorzystaniem prezentacji wyników raportu w postaci dokumentu XML', 'eNorTs1JTS5R0FJIK8rPVUhMTs4vzSsBAFJRB6w=', 'eNqzsa/IzVEoSy0qzszPs1Uy1DNQUkjNS85PycxLt1UKz8xLyS8v1jU0MjVQsrfj5bIpSCxKzC12SU0r1gdyAXd2EyU=', '', 'S');
insert into reportDef (idreportDef, created, modified, name, description, queryText, paramsDefs, xsltText, xsltType) values ('{00000000-0000-0000-0000-000000000002}', #2007-09-03 20:31:23#, #2007-09-03 21:10:55#, 'Operacje w/g kategorii - raport w³asny', 'Jest to przyk³adowy raport definiowalny korzystaj¹cy z domyœlnego arkusza styli, czyli podstawowej transformacji XSLT, znajduj¹cej siê w pliku transform.xml w katalogu instalacyjnym CManager-a.', 'eNptkEsOgkAQRPcm3qEWLNAQ4gXcsXHh5woN0yBmmCbzEfQsns9zyMfIxl5VJV31Ou1Yc+HRpoYaBjmc6NlRgrou49qZoHV80PJ6bxLsEsxyXJsUSisNWisqjB3rFaC59JDg2eImtUHsZkAhwfh4u2QHhLp8k1NNTo6PcueGjcdY9X+6K1uG5Sojz8jZd8wGkSJPZxWBjJpNJhEqK6FF/lhQE78f28WgT5cT9sMLfu4D9JxbcQ==', 'eNqlj7sKwkAQRXsh/zBMH/MAu2zSpBdsBLslMwmLZifuJD7+3sU0CnZ298DlHm7VPMYL3DioE2+w2OYI7Dsh5weDR+dJ7poW5S7Hpk421WSDHbXlXus1xwjejmyQ7Gz3hECsncE2EkjEIcgyGTzZc2CFWEKYn9PaZwSnB74uLjAZTAuEPrzHSsx+Clr5EpD8Jcg+7iSbF/yRVtM=', '', 'D');