/*
INTERGRANTES:
- Jose Garcete
- Laura Troche

TAREAS
1. Crear Tablas... Primera pagina del PDF (Jose Garcete), segunda y tercera pagina (Lau Troche)
2. Insertar... (Jose Garcete)
3. Modificacion... (Jose Garcete)
4. Eliminacion... (Lau Troche)
*/

#------------------------------CREATE-------------------------------------

CREATE TABLE Menu(
MenuNro int,
LocalNro int not null,
FechaElaboracion datetime,
FechaInicio datetime,
FechaFin datetime,
EmpleadoNro int not null,
Estado char(1),
Primary key (MenuNro),
foreign key(LocalNro) references Local(LocalNro),
foreign key(EmpleadoNro) references Empleado(EmpleadoNro)
);

alter table Menu add constraint CK_menu_estado_valores
check (Estado ='A' or Estado ='C' or Estado ='N');


CREATE TABLE Comanda(
  ComandaNro int,
  LocalNro int not null,
  ClienteNro int not null,
  MesaNro int not null,
  CantidadComensales int not null,
  MozoNro int not null,
  RecepcionistaNro int not null,
  Estado char(1),
  Primary key(ComandaNro),
  foreign key(LocalNro) references Local(LocalNro),
  foreign key(ClienteNro) references Cliente(ClienteNro),
  foreign key(MesaNro) references Mesa(MesaNro),
  foreign key(MozoNro) references Mozo(MozoNro),
  foreign key(RecepcionistaNro) references Recepcionista(RecepcionistaNro)
);

alter table Comanda add constraint CK_comanda_estado_valores
check (Estado ='A' or Estado ='C' or Estado ='N');


CREATE TABLE Factura(
  FacturaNro bigint,
  ComandaNro int not null,
  ClienteNro int not null,
  LocalNro int not null,
  MozoNro int not null,
  FechaFactura datetime,
  MontoTotal money,
  MontoNetoIVA money,
  MontoIVA money,
  Estado char(1),
  Primary key(FacturaNro),
  foreign key(ComandaNro) references Comanda(ComandaNro),
  foreign key(ClienteNro) references Cliente(ClienteNro),
  foreign key(LocalNro) references Local(LocalNro),
  foreign key(MozoNro) references Mozo(MozoNro)
);

alter table Factura add constraint CK_factura_estado_valores
check (Estado ='A' or Estado ='C' or Estado ='N');


CREATE TABLE Compra(
  TransaccionNro bigint,
  ProveedorNro int not null,
  FacturaProveedorNro bigint not null,
  Primary key(TransaccionNro),
  foreign key(TransaccionNro) references Transaccion(TransaccionNro),
  foreign key(ProveedorNro) references Proveedor(ProveedorNro)
);

CREATE TABLE TipoAjuste(
TipoAjusteNro smallint,
Descripcion varchar(255) not null unique,
PositivoNegativo smallint not null,
Primary key(TipoAjusteNro)
#Foreign key(TipoAjusteNro) references TipoAjuste(TipoAjusteNro)
);

Alter table TipoAjuste add constraint CK_TipoAjuste_PositivoNegativo 
check ( PositivoNegativo = 1 or PositivoNegativo = -1);

CREATE TABLE DetalleTransaccion(
TransaccionNro bigint,
LocalNro int,
DepositoNro int,
ProductoNro int,
FechaVencimiento datetime,
Cantidad float not null,
CostoPromedio float not null,
TipoImpuestoNro smallint not null,
PorcentajeIVA float not null,
Primary key(TransaccionNro,LocalNro,DepositoNro,ProductoNro,FechaVencimiento),
Foreign key(TransaccionNro) references Transaccion(TransaccionNro),
Foreign key(LocalNro,DepositoNro,ProductoNro,FechaVencimiento) references StockProducto(LocalNro,DepositoNro,ProductoNro,FechaVencimiento),
Foreign key(TipoImpuestoNro) references TipoImpuesto(TipoImpuestoNro)
);

CREATE TABLE MenuReceta(
MenuNro int,
RecetaNro int,
PrecioVenta money not null,
TipoImpuestoNro smallint not null,
PorcentajeIVA float not null,
Primary key(MenuNro),
Primary key(RecetaNro),
Foreing key(MenuNro) references Menu(MenuNro),
Foreing key(RecetaNro) references Receta(RecetaNro),
Foreing key(TipoImpuestoNro) references TipoImpuesto(TipoImpuestoNro)
);

CREATE TABLE ComandaMenuReceta(
ComandaNro int,
MenuNro int,
RecetaNro int,
CantidadPorciones int not null,
PrecioVenta money not null,
TipoImpuestoNro smallint not null,
PorcentajeIVA float not null,
CostoPromedio float,
MontoCostoPromedio float,
MontoTotal money,
MontoNetoIVA money, 
MontoIVA money, 
ChefNro int not null,
FacturaNro bigint,
Primary key(ComandaNro,MenuNro,RecetaNro),  
foreign key(ComandaNro) references Comanda(ComandaNro),
Foreign key(MenuNro,RecetaNro) references MenuReceta(MenuNro,RecetaNro),
Foreign key(TipoImpuestoNro) references TipoImpuesto(TipoImpuestoNro),
Foreign key(ChefNro) references Chef(ChefNro),
Foreign key(FacturaNro) references Factura(FacturaNro)
);

CREATE TABLE FacturaEfectivo(
FacturaNro bigint,
ImporteCobrado money,
Primary key(FacturaNro),
Foreing key(FacturaNro) references Factura(FacturaNro)
);

CREATE TABLE Banco(
BancoNro int,
BancoDescripcion varchar(50) not null,
Primary key(BancoNro)
);

CREATE TABLE FacturaTarjetaCredito(
FacturaNro bigint,
BancoNro int not null,
CuponNro int not null,
FechaVencimiento datetime not null,
ImporteCobrado money,
Primary key(FacturaNro),
Foreign key(FacturaNro) references Factura(FacturaNro),
Foreign key(BancoNro) references Banco(BancoNro)
);

CREATE TABLE Devolucion(
TransaccionNro bigint,
CompraNro bigint not null,
Primary key(TransaccionNro),
Foreign key(TransaccionNro) references Transaccion(TransaccionNro)
#Foreign key(CompraNro) references Compra(TransaccionNro)
);

CREATE TABLE Transferencia(
TransaccionNro bigint,
LocalNro int,
DepositoNro int,
Primary key(TransaccionNro),
Foreign key(TransaccionNro) references Transaccion(TransaccionNro),
Foreign key(LocalNro,DepositoNro) references Deposito(LocalNro,DepositoNro) 
);

CREATE TABLE DetalleTransferencia(
TransaccionNro bigint,
LocalNro int,
DepositoNro int,
ProductoNro int,
FechaVencimiento datetime,
Primary key(TransaccionNro,LocalNro,DepositoNro,ProductoNro,FechaVencimiento),
Foreign key(TransaccionNro) references Transaccion(TransaccionNro),
Foreign key(LocalNro,DepositoNro,ProductoNro,FechaVencimiento) references StockProducto(LocalNro,DepositoNro,ProductoNro,FechaVencimiento)
);

CREATE TABLE ComandaMenuProducto(
ComandaNro int,
MenuNro int,
ProductoNro int,
CantidadPorciones int not null,
PrecioVenta money not null,
TipoImpuestoNro smallint not null,
PorcentajeIVA float not null,
CostoPromedio float,
MontoCostoPromedio float,
MontoTotal money,
MontoNetoIVA money,
MontoIVA money,
FacturaNro bigint,
Primary key(ComandaNro,MenuNro,ProductoNro),
foreign key(ComandaNro) references Comanda(ComandaNro),
Foreign key(MenuNro,ProductoNro) references MenuProducto(MenuNro,ProductoNro),
Foreign key(TipoImpuestoNro) references TipoImpuesto(TipoImpuestoNro),
Foreign key(FacturaNro) references Factura(FacturaNro)
);


CREATE TABLE FacturaCheque(
FacturaNro bigint,
BancoNro int not null,
Librador varchar(255) not null,
FechaEmision datetime not null,
ChequeNro int not null,
ImporteCheque money not null,
Primary key(FacturaNro),
Foreign key(FacturaNro) references Factura(FacturaNro),
Foreign key(BancoNro) references Banco(BancoNro)
);

CREATE TABLE Transaccion(
TransaccionNro bigint,
FechaTransaccion datetime not null,
ComprobanteNro varchar(20) not null unique,
LocalNro int,
DepositoNro int,
Estado char(1),
Primary key(TransaccionNro),
Foreign key(LocalNro,DepositoNro) references Deposito(LocalNro,DepositoNro)
);

alter table Transaccion add constraint CK_transaccion_estado_valores
check (Estado ='A' or Estado ='C' or Estado ='N');


CREATE TABLE Ajuste(
TransaccionNro bigint,
TipoAjusteNro smallint not null,
Primary key(TransaccionNro),
Foreign key(TransaccionNro) references Transaccion(TransaccionNro),
Foreign key(TipoAjusteNro) references TipoAjuste(TipoAjusteNro)
);

CREATE TABLE Consumo(
TransaccionNro bigint,
ComandaNro int,
MenuNro int,
RecetaNro int,
Chef int not null,
Primary key(TransaccionNro),
Foreign key(TransaccionNro) references Transaccion(TransaccionNro),
foreign key(ComandaNro,MenuNro,RecetaNro) references ComandaMenuReceta(ComandaNro,MenuNro,RecetaNro),
foreign key(Chef) references Chef(ChefNro)
);

CREATE TABLE Persona(
PersonaNro int,
Nombre varchar(50) not null,
Apellido varchar(50) not null,
Domicilio varchar(255) not null,
Telefono varchar(15),
CiudadNro int not null,
Email varchar(255),
Primary key(PersonaNro),
foreign key(CiudadNro) references Ciudad(CiudadNro)
);

CREATE TABLE Proveedor(
ProveedorNro int,
RazonSocial varchar(50) not null,
Ruc varchar(15) not null,
TipoPersona char(1),
Primary key(ProveedorNro)
#foreign key(ProveedorNro) references
);

CREATE TABLE Mozo(
MozoNro int,
JornalDiario money not null,
HoraEntrada datetime not null,
HoraSalida datetime not null,
Primary key(MozoNro)
#foreign key(MozoNro) references
);

CREATE TABLE Cliente(
ClienteNro int,
RazonSocial varchar(50) not null,
Ruc varchar(15) not null,
TipoPersona char(1),
Primary key(ClienteNro)
#foreign key(ClienteNro) references
);

CREATE TABLE Empleado(
EmpleadoNro int,
FechaNacimiento datetime not null,
CIP varchar(20) not null,
LocalNro int not null,
Primary key(EmpleadoNro),
#foreign key(EmpleadoNro) references
foreign key(LocalNro) references Local(LocalNro)
);

CREATE TABLE Recepcionista(
RecepcionistaNro int,
SalarioMensual money not null,
Primary key(RecepcionistaNro)
#foreign key(RecepcionistaNro) references
);

CREATE TABLE Chef(
ChefNro int,
Instituto varchar(50),
AñoCulminacion int,
AñoExperiencia int,
Especialidad varchar(50),
Primary key(ChefNro)
#foreign key(ChefNro) references ();
);


#------------------------------INSERT INTO-------------------------------------
#Inserción de datos en las tablas menores, maestras y de transacciones. (al menos 4 registros en cada tabla)

INSERT INTO Transaccion(TransaccionNro,FechaTransaccion,ComprobanteNro,LocalNro,DepositoNro,Estado) VALUES (12345675,2020-07-02,'ABCDE12341',1,10,'A'); 
INSERT INTO Transaccion(TransaccionNro,FechaTransaccion,ComprobanteNro,LocalNro,DepositoNro,Estado) VALUES (12345674,2020-07-03,'ABCDE12342',2,15,'C'); 
INSERT INTO Transaccion(TransaccionNro,FechaTransaccion,ComprobanteNro,LocalNro,DepositoNro,Estado) VALUES (12345673,2020-07-04,'ABCDE12343',6,12,'A'); 
INSERT INTO Transaccion(TransaccionNro,FechaTransaccion,ComprobanteNro,LocalNro,DepositoNro,Estado) VALUES (12345676,2020-07-05,'ABCDE12344',4,5,'A'); 
INSERT INTO Transaccion(TransaccionNro,FechaTransaccion,ComprobanteNro,LocalNro,DepositoNro,Estado) VALUES (12345677,2020-07-06,'ABCDE12345',3,8,'C'); 
INSERT INTO Transaccion(TransaccionNro,FechaTransaccion,ComprobanteNro,LocalNro,DepositoNro,Estado) VALUES (12345678,2020-07-07,'ABCDE12346',1,9,'N'); 


#------------------------------UPDATE------------------------------------------
#Modificación de datos almacenados en las tablas. (al menos 5 registros de distintas tablas)

UPDATE Transaccion SET Estado = 'C' WHERE TransaccionNro = 12345675;
UPDATE Transaccion SET DepositoNro = 10 WHERE TransaccionNro = 12345677;
UPDATE Transaccion SET Estado = 'N' WHERE TransaccionNro = 12345676;
UPDATE Transaccion SET LocalNro = 7 WHERE TransaccionNro = 12345678;


#------------------------------DELETE------------------------------------------
#Eliminación de datos almacenados en las tablas. (al menos 5 registros de distintas tablas)

DELETE FROM Transaccion WHERE TransaccionNro = 12345675;
DELETE FROM Transaccion WHERE TransaccionNro = 12345676;
DELETE FROM Transaccion WHERE TransaccionNro = 12345678;
DELETE FROM Transaccion WHERE TransaccionNro = 12345673;
DELETE FROM Transaccion WHERE TransaccionNro = 12345677;
