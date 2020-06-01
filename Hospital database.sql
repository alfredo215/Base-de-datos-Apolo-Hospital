create database Apolo;

use Apolo;



 create table Vacunas(
 Codigo int primary key not null,
 Nombre_Vac varchar (50),
 Tipo Varchar(50),
 Estado varchar(5)
 );
 
  create table Medicamentos(
 CodigoM int primary key not null,
 Nombre varchar(75),
 Tipo varchar(75),
 Cantidad double
 );

  create table Enfermedades(
 Enfermedad int primary key not null,
 Nombre_E varchar(75),
 Tipo varchar (50)
 );
 
create table Pacientes(
Codigo int primary key not null,
CodigoExpediente int,
Nombre_P varchar(50),
Apellido varchar(50),
Sexo varchar(2),
Fecha_De_Nacimiento Date,
Edad tinyint,
Departamento_Nacimiento varchar(50),
Municipo_Nacimiento varchar(50),
Peso smallint,
Altura smallint,
Vacunas int,
EnfermedadesP int,
Alerguias varchar(200),
MedicamentoPrescrito int,
Antecedentes_Medicos int,
Antecedentes_Odontologicos int,
Cita int,
foreign key (MedicamentoPrescrito) references Medicamentos(CodigoM),
foreign key (EnfermedadesP) references  Enfermedades(Enfermedad)
 );
 
create table Doctores(
Cedula int primary key not null,
Nombre_Doc varchar(50),
Apellido varchar(50),
Epecialidad varchar(50),
Telefono int
);

  create table Vacunas_Usuario(
IdUsuarioVacuna int  primary key not null,
IdUsuario int,
IdVacuna int,
foreign key (IdVacuna) references Vacunas(Codigo),
foreign key (IdUsuario) references Pacientes(Codigo)
);
 
 create table Enfermeras (
Cedula int primary key not null,
Nombre_Enfer varchar(50),
Apellido varchar(50),
Epecialidad varchar(50)
 );

create table UsuariosHospital(
N_Usuario int primary key not null,
CedulaD int,
CedulaE int,
Usuario varchar(50),
Contrasena varchar(50),
foreign key (CedulaE) references Enfermeras(Cedula),
foreign key (CedulaD) references Doctores(Cedula)
);
 
  create table Mujeres(
 IdMujer int primary key,
 Nombre int,
 Embarazada varchar(3),
 foreign key (Nombre) references Pacientes(Codigo)
 );
 
 create table Embarazadas(
 IdEmbarazada int primary key,
 NombreE int,
 Cita Date,
 foreign key (NombreE) references Mujeres(IdMujer)
 );

 create table Reserva_Cita(
Codigo_Cita int primary key not null,
CodigoPas int not null,
Fecha_Cita date,
Hora_Cita varchar(50)/*reparar al considerar el tipo de dato para horas*/,
foreign key (CodigoPas) references Pacientes(Codigo)
 );
 
 create table Consulta(
 Codigo_Consulta int primary key not null,
 Doctor int,
 Paciente int,
  Sintomas varchar(50),
 Enfermedad int,
 foreign key (Doctor) references Doctores(Cedula),
 foreign key (Paciente) references Pacientes(Codigo),
 foreign key (Enfermedad) references Enfermedades(Enfermedad)
 );
 
  create table Consulta_Odontologica(
 Codigo_ConsultaO int primary key not null,
 Odontologo int,
 Paciente int,
 Sintomas varchar(50),
 Enfermedad_Odontologica int,
 foreign key (Odontologo) references Doctores(Cedula),
 foreign key (Paciente) references Pacientes(Codigo),
 foreign key (Enfermedad_Odontologica) references Enfermedades(Enfermedad)
 );
 
 #reparar en conjuto con medicamento
 create table Receta_Medica(
 Codigo_Res int primary key not null,
 Enfermedad int,
 Enfermedad_Odontologica int,
 Medicamento int,
 Cantidad int,
 Docis varchar(200),
 foreign key (Medicamento) references  Medicamentos(CodigoM),
 foreign key (Enfermedad_Odontologica) references Consulta_Odontologica(Codigo_ConsultaO),
 foreign key (Enfermedad) references Consulta(Codigo_Consulta)
 );
 
ALTER TABLE Pacientes
ADD FOREIGN KEY (Antecedentes_Medicos) REFERENCES Consulta(Codigo_Consulta);
ALTER TABLE Pacientes
ADD foreign key (Antecedentes_Odontologicos) references  Consulta_Odontologica(Codigo_ConsultaO);
ALTER TABLE Pacientes
ADD foreign key (Cita) references  Reserva_Cita(Codigo_Cita);
ALTER TABLE Pacientes
ADD foreign key (Vacunas) references Vacunas_Usuario(IdUsuarioVacuna);


select Codigo, CodigoExpediente, Nombre_P, Apellido,Sexo, Fecha_De_Nacimiento, Edad, Departamento_Nacimiento, Municipo_Nacimiento, Peso, Altura, Vacunas_Usuario.IdVacuna Vacunas, Enfermedades.Nombre_E Enfermedad, Alerguias, Medicamentos.Nombre MedicamentoPrescrito, Consulta_Odontologica.Codigo_ConsultaO Antecedentes_Odontologicos, Consulta.Codigo_Consulta Antecedentes_Medicos, Reserva_Cita.Codigo_Cita Cita from Pacientes
inner join Vacunas_Usuario
on Pacientes.Vacunas = Vacunas_Usuario.IdUsuarioVacuna
inner join Reserva_Cita
on Pacientes.Cita = Reserva_Cita.Codigo_Cita
inner join Consulta_Odontologica
on Pacientes.Antecedentes_Odontologicos = Consulta_Odontologica.Codigo_ConsultaO
inner join Consulta
on Pacientes.Antecedentes_Medicos = Consulta.Codigo_Consulta
inner join Medicamentos
on Pacientes.MedicamentoPrescrito = Medicamentos.CodigoM
inner join Enfermedades
on Pacientes.EnfermedadesP = Enfermedades.Enfermedad;

select IdUsuarioVacuna,Pacientes.Nombre_P IdUsuario,Vacunas.Nombre_Vac IdVacuna from Vacunas_Usuario
inner join Vacunas
on Vacunas_Usuario.IdVacuna = Vacunas.Codigo
inner join Pacientes
on Vacunas_Usuario.IdUsuario=Pacientes.Codigo;

select N_Usuario,Doctores.Cedula CedulaDoctor, Enfermeras.Cedula CedulaEnfremera, Usuario, Contrasena from UsuariosHospital
inner join Doctores
on UsuariosHospital.CedulaD=Doctores.Cedula
inner join Enfermeras
on UsuariosHospital.CedulaE=Enfermeras.Cedula;

select IdMujer,Pacientes.Nombre_P Nombre,Pacientes.Apellido Apellido , Embarazada from Mujeres
inner join Pacientes
on Mujeres.Nombre=Pacientes.Codigo;

select IdEmbarazada, Mujeres.Nombre NombreE, Cita from Embarazadas
inner join Mujeres
on Embarazadas.IdEmbarazada=Mujeres.IdMujer;

select Codigo_Consulta, Doctores.Nombre_Doc NombreDoctor, Doctores.Apellido ApellidoDoctor,Pacientes.Nombre_P NombrePasiente,Pacientes.Apellido ApellidoPasiente, Sintomas, Enfermedades.Enfermedad from Consulta
inner join Doctores
on Consulta.Doctor=Doctores.Cedula
inner join Pacientes
on Consulta.Paciente=Pacientes.Codigo
inner join Enfermedades
on Consulta.Enfermedad = Enfermedades.Enfermedad;

select Codigo_ConsultaO, Doctores.Nombre_Doc NombreOdontologo, Doctores.Apellido ApellidoOdontologo,Pacientes.Nombre_P NombrePasiente,Pacientes.Apellido ApellidoPasiente, Sintomas, Enfermedades.Enfermedad from Consulta_Odontologica
inner join Doctores
on Consulta_Odontologica.Odontologo=Doctores.Cedula
inner join Pacientes
on Consulta_Odontologica.Paciente=Pacientes.Codigo
inner join Enfermedades
on Consulta_Odontologica.Enfermedad_Odontologica = Enfermedades.Enfermedad;

select Codigo_Res, Consulta_Odontologica.Enfermedad_Odontologica EnfermedadOdontologica, Consulta.Enfermedad Enfermedad , Medicamentos.Nombre Medicamento, Receta_Medica.Cantidad, Docis from Receta_Medica
inner join Consulta_Odontologica
on Receta_Medica.Enfermedad_Odontologica=Consulta_Odontologica.Codigo_ConsultaO
inner join Consulta
on Receta_Medica.Enfermedad=Consulta.Codigo_Consulta
inner join Medicamentos
on Receta_Medica.Medicamento=Medicamentos.CodigoM