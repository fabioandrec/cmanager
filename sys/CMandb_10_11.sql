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