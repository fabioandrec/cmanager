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

alter table plannedMovement add column quantity_temp money null;
update plannedMovement set quantity_temp = quantity;
alter table plannedMovement drop column quantity;
alter table plannedMovement add column quantity float null;
update plannedMovement set quantity = quantity_temp;
alter table plannedMovement drop column quantity_temp;

alter table baseMovement add column quantity_temp money null;
update baseMovement set quantity_temp = quantity;
alter table baseMovement drop column quantity;
alter table baseMovement add column quantity float null;
update baseMovement set quantity = quantity_temp;
alter table baseMovement drop column quantity_temp;


drop view transactions;
drop view balances;
drop view investments;
drop view filters;
drop view StnInstrumentValue;
drop view StnInvestmentPortfolio;
drop view StnDepositMovement;
drop view StnBaseMovement;
drop view StnMovementList;

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

create view investments as select * from (
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, quantity, idAccountCurrencyDef from investmentMovement where movementType = 'B'
 union all
 select idinvestmentMovement, movementType, description, idAccount, idInstrument, idProduct, regDateTime, created, weekDate, monthDate, yearDate, (-1) * quantity, idAccountCurrencyDef from investmentMovement where movementType = 'S') as v;

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left outer join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left outer join productFilter p on p.idMovementFilter = m.idMovementFilter);

create view StnInstrumentValue as
  select v.*, i.idCurrencyDef, i.instrumentType from instrumentValue v
  left join instrument i on i.idInstrument = v.idInstrument;

create view StnInvestmentPortfolio as
  select v.idInstrument, i.idCurrencyDef, i.name as instrumentName, i.instrumentType, v.idAccount,
         a.name as accountName, idInvestmentItem, v.created, v.modified, v.quantity,
         (select top 1 valueOf from instrumentValue where idInstrument = v.idInstrument order by regDateTime desc) as valueOf
    from ((investmentItem v
      left outer join instrument i on i.idInstrument = v.idInstrument)
      left outer join account a on a.idAccount = v.idAccount);
	  
create view StnDepositMovement as
  select v.*, d.idCurrencyDef from depositMovement v
  left join depositInvestment d on d.idDepositInvestment = v.idDepositInvestment;
  
create view StnBaseMovement as
  select v.*, i.name as accountName, q.name as sourceAccountName from ((baseMovement v
  left outer join account i on i.idAccount = v.idAccount)
  left outer join account q on q.idAccount = v.idSourceAccount);

create view StnMovementList as
  select v.*, i.name as accountName from movementList v
  left outer join account i on i.idAccount = v.idAccount;
