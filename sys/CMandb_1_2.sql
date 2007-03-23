create table movementLimit (
  idmovementLimit uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40),
  description varchar(200),
  idmovementFilter uniqueidentifier,
  isActive bit not null,
  boundaryAmount money not null,
  boundaryType varchar(1) not null,
  boundarycondition varchar(2) not null,
  boundaryDays int,  
  sumType varchar(1) not null,
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),  
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),  
  constraint ck_sumTypelimit check (sumType in ('I', 'O', 'B')),  
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter)
);

create view filters as
  select m.idMovementFilter, a.idAccount, c.idCashpoint, p.idProduct from (((movementFilter m
    left outer join accountFilter a on a.idMovementFilter = m.idMovementFilter)
    left join cashpointFilter c on c.idMovementFilter = m.idMovementFilter)
    left join productFilter p on p.idMovementFilter = m.idMovementFilter);
