create table movementLimit (
  idmovementLimit uniqueidentifier not null,
  created datetime not null,
  modified datetime,
  name varchar(40),
  description varchar(200),
  idmovementFilter uniqueidentifier not null,
  isActive bit not null,
  boundaryAmount money not null,
  boundaryType varchar(1) not null,
  boundaryDays int,  
  primary key (idMovementLimit),
  constraint ck_boundaryTypelimit check (boundaryType in ('I', 'O')),  
  constraint fk_filterlimit foreign key (idmovementFilter) references movementFilter (idmovementFilter)
);
