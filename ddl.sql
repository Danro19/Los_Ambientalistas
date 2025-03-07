create database if not exists Ambientalistas;
use Ambientalistas;



create table if not exists parque(
id int primary key auto_increment,
nombre varchar(50) not null,
fechaDeclaracion date not null,
superficieTotal float
);

create table if not exists entidad(
id int primary key auto_increment,
nombre varchar(50) not null
);
create table if not exists departamento( 
id int primary key auto_increment,
nombre varchar(50) not null,
idEntidad int not null,
foreign key (idEntidad) references entidad(id)
);

create table if not exists departamentoParque( 
idDepartamento int not null,
idParque int not null,
foreign key (idDepartamento) references departamento(id),
foreign key (idParque) references parque(id)
);

create table if not exists area (
id int primary key auto_increment,
nombre varchar(50) not null,
extencionArea float not null,
idParque int not null,
foreign key (idParque) references parque(id)
);


create table if not exists especie (
id int primary key auto_increment,
tipoEspecie enum ("vegetales", "animales", "minerales") not null,
nombreCientifico varchar(50) not null,
nombreVulgar varchar(50) not null,
cantidad int not null,
idArea int not null,
foreign key (idArea) references area(id)
);

create table if not exists proyecto(
id int primary key auto_increment,
nombre varchar(100) not null,
presupuesto float not null,
fechaInicio date not null,
fechaFin date not null
);

create table if not exists proyectoEspecie (
idProyecto int not null,
idEspecie int not null,
foreign key (idProyecto) references proyecto(id),
foreign key (idEspecie) references especie(id)
);

create table if not exists  personal(
id int primary key auto_increment,
cedula varchar(20) not null,
nombre varchar(50) not null,
direccion varchar(100) not null,
telefonoFijo varchar(15),
telofonoMovil varchar(15),
sueldo float not null,
tipoPersonal enum("001", "002", "003", "004") not null
);

create table if not exists gestion(
id int primary key auto_increment,
idPersonal int not null,
foreign key (idPersonal) references personal(id)
);

create table if not exists vehiculo(
id int primary key auto_increment,
tipo varchar(50) not null,
marca varchar(50) not null
);

create table if not exists vigilancia(
id int primary key auto_increment,
idPersonal int not null,
idVehiculo int not null,
foreign key (idPersonal) references personal(id),
foreign key (idVehiculo) references vehiculo(id)
);
create table if not exists vigilanciaArea( 
idVigilancia int not null,
idArea int not null,
foreign key (idVigilancia) references vigilancia(id),
foreign key (idArea) references area(id)
);
create table if not exists visitante(
id int primary key auto_increment,
cedula varchar(20),
direccion varchar(100),
profesion varchar(100),
idGestion int not null,
foreign key (idGestion) references gestion (id)
);
create table if not exists alojamiento(
id int primary key auto_increment,
nombre varchar(50),
capacidad int ,
estadoAlojamiento boolean not null
);

create table if not exists visitanteAlojamiento (
idVisitante int not null,
idAlojamiento int not null,
foreign key (idVisitante) references visitante(id),
foreign key (idAlojamiento) references alojamiento(id)
);
create table if not exists conservacion(
id int primary key auto_increment,
idPersonal int not null,
foreign key (idPersonal) references personal(id)
);
create table if not exists conservacionArea(
idConservacion int not null,
idArea int not null,
foreign key (idConservacion) references conservacion(id),
foreign key (idArea) references area(id)
);
create table if not exists investigador(
id int primary key auto_increment,
idPersonal int not null,
foreign key (idPersonal) references personal(id)
);
create table if not exists investigadorProyecto(
idInvestigador int not null,
idProyecto int not null,
foreign key (idInvestigador) references investigador(id),
foreign key (idProyecto) references proyecto(id)
);




