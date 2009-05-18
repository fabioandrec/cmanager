alter table investmentMovement add column quantity_temp int null;
update investmentMovement set quantity_temp = quantity;
alter table investmentMovement drop column quantity;
alter table investmentMovement add column quantity float null;
update investmentMovement set quantity = quantity_temp;
alter table investmentMovement drop column quantity_temp;

alter table investmentItem add column quantity_temp int null;
update investmentItem set quantity_temp = quantity;
alter table investmentItem drop column quantity;
alter table investmentItem add column quantity float null;
update investmentItem set quantity = quantity_temp;
alter table investmentItem drop column quantity_temp;

create view StnBaseMovement as
  select v.*, i.name as accountName, q.name as sourceAccountName from ((baseMovement v
  left outer join account i on i.idAccount = v.idAccount)
  left outer join account q on q.idAccount = v.idSourceAccount);

create view StnMovementList as
  select v.*, i.name as accountName from movementList v
  left outer join account i on i.idAccount = v.idAccount;
