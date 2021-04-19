-- Procedures y Funciones para las Funciones Básicas



-- CREAR_COOPERATIVA
insert into cooperativa values (1, 'Cooperativa', 0.0, 0.0, 0.0);
commit;

-- MOSTRAR_COOPERATIVA
select * from cooperativa;

-- Procedure UPDATE_COOPERATIVA
create or replace procedure update_cooperativa as
  cuentaTotal float;
  prestamoTotal float;
  cdpTotal float;
begin
  select sum(saldoCuentaDetalles) into cuentaTotal from cuentaAhorro;
  select sum(monto) into prestamoTotal from prestamo;
  select sum(monto) into cdpTotal from cdp;
  update cooperativa set totalCuenta = cuentaTotal, totalPrestamos = prestamoTotal, totalCdp = cdpTotal;
end update_cooperativa;

-- Execute Procedure UPDATE_COOPERATIVA
begin
  update_cooperativa();
end;



-- Procedure MOSTRAR_BALANCE
create or replace procedure mostrar_balance(
  idInput in integer
)is 
  cursor cooperativa_cursor is select * from cooperativa where idCooperativa = idInput;
begin
  for cooperativa_row in cooperativa_cursor loop
    dbms_output.put_line('ID de Cooperativa : '|| cooperativa_row.idCooperativa);
    dbms_output.put_line('Nombre : '|| cooperativa_row.nombre);
    dbms_output.put_line('Total Cuentas de Ahorro : '|| cooperativa_row.totalCuenta);
    dbms_output.put_line('Total Prestamos : '|| cooperativa_row.totalPrestamos);
    dbms_output.put_line('Total CDPs : '|| cooperativa_row.totalCDP);
  end loop;
end mostrar_balance;

-- Execute Procedure MOSTRAR_BALANCE
set serveroutput on
begin
  mostrar_balance(1);
end;



-- Procedure CREAR_CLIENTE
create or replace procedure crear_cliente(
  idCliente in integer,
  usuario in varchar2,
  contraseña in varchar2,
  nombre in varchar2,
  apellido in varchar2,
  correo in varchar2,
  nacionalidad in varchar2,
  idCooperativa in integer
)as
begin
  insert into cliente values (idCliente, usuario, contraseña, nombre, apellido, correo, nacionalidad, 'n', idCooperativa);
  commit;
  dbms_output.put_line('Cliente ' || nombre || ' fue creado exitosamente');
end crear_cliente;

-- Execute Procedure CREAR_CLIENTE
set serveroutput on
declare
  foreignk integer;
begin
  select idCooperativa into foreignk from cooperativa;
  crear_cliente(1, 'Usuario', 'Contrasena', 'Nombre', 'Apellido', 'Correo', 'Nacionalidad', foreignk);
end;

-- MOSTRAR_CLIENTE_Tabla
select * from cliente;

-- Procedure MOSTRAR_CLIENTE
create or replace procedure mostrar_cliente(
  idInput in integer
)is 
  cursor cliente_cursor is select * from cliente where idCliente = idInput;
begin
  for cliente_row in cliente_cursor loop
    dbms_output.put_line('ID de Cliente : '|| cliente_row.idCliente);
    dbms_output.put_line('Usuario : '|| cliente_row.usuario);
    dbms_output.put_line('Contraseña : '|| cliente_row.contraseña);
    dbms_output.put_line('Nombre : '|| cliente_row.nombre);
    dbms_output.put_line('Apellido : '|| cliente_row.apellido);
    dbms_output.put_line('Correo : '|| cliente_row.correo);
    dbms_output.put_line('Nacionalidad : '|| cliente_row.nacionalidad);
    dbms_output.put_line('¿Tiene Cuenta? : '|| cliente_row.tieneCuenta);
    dbms_output.put_line('ID de Cooperativa : '|| cliente_row.idCooperativa);
  end loop;
end mostrar_cliente;

-- Execute Procedure MOSTRAR_CLIENTE
set serveroutput on
begin
  mostrar_cliente(1);
end;



-- Procedure CREAR_CUENTA
create or replace procedure crear_cuenta(
  idCuenta in integer,
  idCliente in integer
)as
begin
  insert into cuentaAhorro values (idCuenta, 0.0, 0.0, idCliente);
  update cliente set tieneCuenta = 'y' where idCliente = idCliente;
  commit;
  dbms_output.put_line('Cuenta ' || idCuenta || ' fue creada exitosamente');
end crear_cuenta;

-- Execute Procedure CREAR_CUENTA
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  crear_cuenta(1, 1);
end;

-- MOSTRAR_CUENTA_Tabla
select * from cuentaAhorro;

-- Procedure MOSTRAR_CUENTA
create or replace procedure mostrar_cuenta(
  idInput in integer
)is 
  cursor cuenta_cursor is select * from cuentaAhorro where idCuenta = idInput;
begin
  for cuenta_row in cuenta_cursor loop
    dbms_output.put_line('ID de Cuenta : '|| cuenta_row.idCuenta);
    dbms_output.put_line('Saldo Total : '|| cuenta_row.saldoCuentaTotal);
    dbms_output.put_line('Saldo Cuenta Detalles : '|| cuenta_row.saldoCuentaDetalles);
    dbms_output.put_line('ID de Cliente : '|| cuenta_row.idCliente);
  end loop;
end mostrar_cuenta;

-- Execute Procedure MOSTRAR_CUENTA
set serveroutput on
begin
  mostrar_cuenta(1);
end;



-- Procedure CREAR_PRESTAMO
create or replace procedure crear_prestamo(
  idPrestamo integer,
  fechaInicio date,
  monto float,
  pagos float,
  plazo integer,
  idCliente integer
)as
  reglaCDP char;
  prestamosTotal float;
  cdpMitad float;
  reglaCuenta char;
  finalDate date := ADD_MONTHS(fechaInicio, plazo);
begin
  update_cooperativa();
  select totalPrestamos into prestamosTotal from cooperativa;
  select (totalCdp * 0.5) into cdpMitad from cooperativa;
  if ((prestamosTotal + monto) <= cdpMitad) then reglaCDP := 'y';
  else reglaCDP := 'n'; end if;
  select tieneCuenta into reglaCuenta from cliente where idCliente = idCliente and rownum = 1;
  if reglaCuenta = 'y' and reglaCDP = 'y' then
    insert into prestamo values (idPrestamo, fechaInicio, finalDate, monto, pagos, plazo, idCliente);
    commit;
    dbms_output.put_line('Prestamo ' || idPrestamo || ' fue creado exitosamente');
  else
    dbms_output.put_line('Se requiere una cuenta de ahorro para crear un préstamo, o total de prestamos supera el 50% de CDP');
  end if;
end crear_prestamo;

-- Execute Procedure CREAR_PRESTAMO
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  crear_prestamo(4, date '2000-01-01', 50.0, 6.0, 3, 1);
end;

-- MOSTRAR_PRESTAMO_Tabla
select * from prestamo;

-- Procedure MOSTRAR_PRESTAMO
create or replace procedure mostrar_prestamo(
  idInput in integer
)is 
  cursor prestamo_cursor is select * from prestamo where idPrestamo = idInput;
begin
  for prestamo_row in prestamo_cursor loop
    dbms_output.put_line('ID de Prestamo : '|| prestamo_row.idPrestamo);
    dbms_output.put_line('Fecha de Inicio : '|| prestamo_row.fechaInicio);
    dbms_output.put_line('Fecha Final : '|| prestamo_row.fechaFinal);
    dbms_output.put_line('Monto : '|| prestamo_row.monto);
    dbms_output.put_line('Pagos : '|| prestamo_row.pagos);
    dbms_output.put_line('Plazo : '|| prestamo_row.plazo);
    dbms_output.put_line('ID de Cliente : '|| prestamo_row.idCliente);
  end loop;
end mostrar_prestamo;

-- Execute Procedure MOSTRAR_PRESTAMO
set serveroutput on
begin
  mostrar_prestamo(1);
end;



-- Procedure CREAR_CDP
create or replace procedure crear_cdp(
  idCdp integer,
  fechaInicio date,
  monto float,
  plazo integer,
  idCliente integer
)as 
  interesVal float;
  finalDate date := ADD_MONTHS( fechaInicio, plazo);
begin
  if plazo = 6 then interesVal := 0.05;
  elsif plazo = 12 then interesVal := 0.06;
  else interesVal := 0.07;
  end if;
  insert into cdp values (idCdp, fechaInicio, finalDate, monto, plazo, interesVal, idCliente);
  commit;
  dbms_output.put_line('CDP ' || idCdp || ' fue creado exitosamente');
end crear_cdp;

-- Execute Procedure CREAR_CDP
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  crear_cdp(4, date '2000-01-01', 200.0, 6, 1);
end;

-- MOSTRAR_CDP_Tabla
select * from cdp;

-- Procedure MOSTRAR_CDP
create or replace procedure mostrar_cdp(
  idInput in integer
)is 
  cursor cdp_cursor is select * from cdp where idCdp = idInput;
begin
  for cdp_row in cdp_cursor loop
    dbms_output.put_line('ID de CDP : '|| cdp_row.idCdp);
    dbms_output.put_line('Fecha Inicial : '|| cdp_row.fechaInicio);
    dbms_output.put_line('Fecha Final : '|| cdp_row.fechaFinal);
    dbms_output.put_line('Monto : '|| cdp_row.monto);
    dbms_output.put_line('Plazo : '|| cdp_row.plazo);
    dbms_output.put_line('Interes (decimal) : '|| cdp_row.interes);
    dbms_output.put_line('ID de Cliente : '|| cdp_row.idCliente);
  end loop;
end mostrar_cdp;

-- Execute Procedure MOSTRAR_CDP
set serveroutput on
begin
  mostrar_cdp(1);
end;



-- Procedure HACER_DEPOSITO_CUENTA
create or replace procedure hacer_deposito_cuenta(
  idCuentaDetalles integer,
  monto float,
  idCuenta integer
)as montoVal float := monto;
begin
  insert into cuentaAhorroDetalles values (idCuentaDetalles, 'DEPOSITO', monto, idCuenta);
  update cuentaAhorro set saldoCuentaTotal = saldoCuentaTotal + montoVal where idCuenta = idCuenta;
  update cuentaAhorro set saldoCuentaDetalles = saldoCuentaDetalles + montoVal where idCuenta = idCuenta;
  commit;
  dbms_output.put_line('ID de Cuenta Detalles ' || idCuentaDetalles || ' fue creado exitosamente');
end hacer_deposito_cuenta;

-- Execute Procedure HACER_DEPOSITO_CUENTA
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  hacer_deposito_cuenta(4, 1000.0, 1);
end;

-- MOSTRAR_cuentaAhorroDetalles_Tabla
select * from cuentaAhorroDetalles;



-- Procedure HACER_RETIRO_CUENTA
create or replace procedure hacer_retiro_cuenta(
  idCuentaDetalles integer,
  monto float,
  idCuenta integer
)as montoVal float := monto * -1;
begin
  insert into cuentaAhorroDetalles values (idCuentaDetalles, 'RETIRO', monto, idCuenta);
  update cuentaAhorro set saldoCuentaTotal = saldoCuentaTotal + montoVal where idCuenta = idCuenta;
  update cuentaAhorro set saldoCuentaDetalles = saldoCuentaDetalles + montoVal where idCuenta = idCuenta;
  commit;
  dbms_output.put_line('ID de Cuenta Detalles ' || idCuentaDetalles || ' fue creado exitosamente');
end hacer_retiro_cuenta;

-- Execute Procedure HACER_RETIRO_CUENTA
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  hacer_retiro_cuenta(3, 100.0, 1);
end;

-- MOSTRAR_cuentaAhorroDetalles_Tabla
select * from cuentaAhorroDetalles;



-- Procedure CREAR_PRESTAMO_DETALLES
create or replace procedure crear_prestamo_detalles(
  idPrestamoDetalles in integer,
  idPrestamo in integer
)as
  idPD integer := idPrestamoDetalles;
  cantPagos float;
  montoPagoVal float;
  fechaPagoVal float;
  fechaInicialVal date;
begin
  select (monto / pagos) into montoPagoVal from prestamo where idPrestamo = idPrestamo and rownum = 1;
  select ((fechaFinal - fechaInicio) / pagos) into fechaPagoVal from prestamo where idPrestamo = idPrestamo and rownum = 1;
  select pagos into cantPagos from prestamo where idPrestamo = idPrestamo and rownum = 1;
  select fechaInicio into fechaInicialVal from prestamo where idPrestamo = idPrestamo and rownum = 1;
  
  for rowVal in 1 .. cantPagos loop
    fechaInicialVal := fechaInicialVal + fechaPagoVal;
    insert into prestamoDetalles values (idPD, montoPagoVal, fechaInicialVal, 'PENDIENTE', idPrestamo);
    idPD := idPD + 1;
  end loop;
  commit;
end crear_prestamo_detalles;

-- Execute Procedure CREAR_PRESTAMO_DETALLES
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  crear_prestamo_detalles(1, 1);
end;

-- MOSTRAR_PRESTAMODETALLES_Tabla
select * from prestamoDetalles;

--delete from prestamoDetalles;



-- Procedure CREAR_CDP_DETALLES
create or replace procedure crear_cdp_detalles(
  idCdpDetalles in integer,
  idCdp in integer
)as
  idCdpD integer := idCdpDetalles;
  cantPagos float;
  interesVal float;
  fechaPagoVal float;
  fechaInicialVal date;
begin
  select ((monto * interes) / plazo) into interesVal from cdp where idCdp = idCdp and rownum = 1;
  select ((fechaFinal - fechaInicio) / plazo) into fechaPagoVal from cdp where idCdp = idCdp and rownum = 1;
  select plazo into cantPagos from cdp where idCdp = idCdp and rownum = 1;
  select fechaInicio into fechaInicialVal from cdp where idCdp = idCdp and rownum = 1;
  
  for rowVal in 1 .. cantPagos loop
    fechaInicialVal := fechaInicialVal + fechaPagoVal;
    insert into cdpDetalles values (idCdpD, interesVal, fechaInicialVal, 'PENDIENTE', idCdp);
    idCdpD := idCdpD + 1;
  end loop;
  commit;
end crear_cdp_detalles;

-- Execute Procedure CREAR_CDP_DETALLES
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  crear_cdp_detalles(1, 1);
end;

-- MOSTRAR_CDPDETALLES_Tabla
select * from cdpDetalles;

--delete from cdpDetalles;



-- Procedure HACER_PAGO_CDP
create or replace procedure hacer_pago_cdp(
  idOperaciones in integer,
  fecha in date,
  tipo in varchar2,
  idDestino in integer,
  idCdpDet in integer
)as
  montoVal float;
begin
  select interesDev into montoVal from cdpDetalles where idCdpDetalles = idCdpDet;
  update cuentaAhorro set saldoCuentaTotal = (saldoCuentaTotal + montoVal) where idCuenta = idDestino;
  update cdpDetalles set status = 'PAGADO' where idCdpDetalles = idCdpDet;
  insert into operaciones values (idOperaciones, fecha, tipo, null, idDestino, montoVal, null, idCdpDet);
  commit;
  dbms_output.put_line('Operacion ' || idOperaciones || ' fue creado exitosamente');
end hacer_pago_cdp;

-- Execute Procedure HACER_PAGO_CDP
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  hacer_pago_cdp(1, date '2021-04-01', 'DEPOSITO', 1, 1);
end;

-- MOSTRAR_OPERACIONES_Tabla
select * from operaciones;



-- Procedure HACER_PAGO_PRESTAMO
create or replace procedure hacer_pago_prestamo(
  idOperaciones in integer,
  fecha in date,
  tipo in varchar2,
  idDestino in integer,
  idPrestamoDet in integer
)as
  montoVal float;
begin
  select montoPago into montoVal from prestamoDetalles where idPrestamoDetalles = idPrestamoDet; 
  update cuentaAhorro set saldoCuentaTotal = (saldoCuentaTotal - montoVal) where idCuenta = idDestino;
  update prestamoDetalles set status = 'PAGADO' where idPrestamoDetalles = idPrestamoDet;
  insert into operaciones values (idOperaciones, fecha, tipo, null, idDestino, montoVal, idPrestamoDet, null);
  commit;
  dbms_output.put_line('Operacion ' || idOperaciones || ' fue creado exitosamente');
end hacer_pago_prestamo;

-- Execute Procedure HACER_PAGO_PRESTAMO
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  hacer_pago_prestamo(1, date '2021-04-01', 'PRESTAMO', 1, 1);
end;

-- MOSTRAR_OPERACIONES_Tabla
select * from operaciones;



-- Procedure HACER_TRANSFERENCIA_ENTRE_CUENTAS
create or replace procedure hacer_transferencia_entre_cuentas(
  idOperaciones in integer,
  fecha in date,
  tipo in varchar2,
  idOrigen in integer,
  idDestino in integer,
  monto in float
)as
begin
  update cuentaAhorro set saldoCuentaTotal = (saldoCuentaTotal - monto) where idCuenta = idOrigen;
  update cuentaAhorro set saldoCuentaTotal = (saldoCuentaTotal + monto) where idCuenta = idDestino;
  insert into operaciones values (idOperaciones, fecha, tipo, idOrigen, idDestino, monto, null, null);
  commit;
  dbms_output.put_line('Operacion ' || idOperaciones || ' fue creado exitosamente');
end hacer_transferencia_entre_cuentas;

-- Execute Procedure HACER_PAGO_PRESTAMO
set serveroutput on
--declare
--  foreignk integer;
begin
--  select idCliente into foreignk from cliente;
  hacer_transferencia_entre_cuentas(8, date '2021-04-01', 'TRANSFERENCIA', 1, 2, 100.0);
end;

-- MOSTRAR_OPERACIONES_Tabla
select * from operaciones;



-- Procedure UPDATE_BALANCE_DIARIO
create or replace procedure update_balance_diario (idCooperativa in integer) as
  cuentaVal float;
  prestamoVal float;
  cdpVal float;
begin
  update_cooperativa();
  select totalCuenta into cuentaVal from cooperativa where idCooperativa = idCooperativa;
  select totalPrestamos into prestamoVal from cooperativa where idCooperativa = idCooperativa;
  select totalCDP into cdpVal from cooperativa where idCooperativa = idCooperativa;
  insert into balanceDiario values (null, sysdate, cuentaVal, prestamoVal, cdpVal, 1);
end update_balance_diario;

-- Execute Procedure UPDATE_BALANCE_DIARIO
begin
  dbms_scheduler.create_job (
    job_name       => 'Balance_Diario_Cooperativa',
    job_type       => 'PLSQL_BLOCK',
    job_action     => 'begin update_balance_diario(1); end;',
    start_date     => systimestamp,
    repeat_interval=> 'freq=daily; byhour=0; byminute=0; bysecond=0;',
    enabled        => true);
end;

-- Execute Procedure UPDATE_BALANCE_DIARIO
begin
  update_balance_diario(1);
end;

-- MOSTRAR_BALANCE_DIARIO_Tabla
select * from balanceDiario;


--SELECT JOB_NAME, STATE FROM DBA_SCHEDULER_JOBS
--WHERE JOB_NAME = 'Balance_Diario_Cooperativa';


--select * from cuentaAhorro;
--
--select * from cdpDetalles;
--
--select * from prestamoDetalles;
--
--
--update cuentaAhorro set saldoCuentaTotal = -100 where idCuenta = 1;
--
--update prestamoDetalles set status = 'PENDIENTE';
--
--delete from operaciones;






















----Drop all rows in all tables
--BEGIN
--  FOR c IN (SELECT table_name, constraint_name FROM user_constraints WHERE constraint_type = 'R')
--  LOOP
--    EXECUTE IMMEDIATE ('alter table ' || c.table_name || ' disable constraint ' || c.constraint_name);
--  END LOOP;
--  FOR c IN (SELECT table_name FROM user_tables)
--  LOOP
--    EXECUTE IMMEDIATE ('truncate table ' || c.table_name);
--  END LOOP;
--  FOR c IN (SELECT table_name, constraint_name FROM user_constraints WHERE constraint_type = 'R')
--  LOOP
--    EXECUTE IMMEDIATE ('alter table ' || c.table_name || ' enable constraint ' || c.constraint_name);
--  END LOOP;
--END;


----Drop all tables
--BEGIN
--
--FOR c IN (SELECT table_name FROM user_tables) LOOP
--EXECUTE IMMEDIATE ('DROP TABLE "' || c.table_name || '" CASCADE CONSTRAINTS');
--END LOOP;
--
--END;