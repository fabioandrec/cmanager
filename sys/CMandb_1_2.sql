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
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('T', 'W', 'M', 'Q', 'H', 'Y', 'D')),  
  constraint ck_boundaryConditionlimit check (boundarycondition in ('=', '<', '>', '<=', '>=')),  
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter)
);
