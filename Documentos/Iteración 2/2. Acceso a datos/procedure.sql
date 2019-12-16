create or replace procedure sp_distribuir_horas_vuelo (id_vuelos in VUELOS.ID%TYPE)
	 as 
	 horas_sumadas VUELOS.HORAS_VUELO%TYPE;	 
	 id_aeronave AERONAVES.ID%TYPE;
	 begin
	SELECT HORAS_VUELO
	  into horas_sumadas
	  from VUELOS
	  where ID = id_vuelos;
    
	 SELECT aeronaves_id
	  into id_aeronave
	  from VUELOS
	  where ID = id_vuelos; 
	
	update pilotos set horas_vuelo = (horas_vuelo+(horas_sumadas/2)), dias_vuelo = (dias_vuelo+1) where pilotos.id in (select pilotos_id from TRIPULACION where VUELOS_ID = id_vuelos);
	
	update aeronaves set horas_vuelo = (horas_vuelo+horas_sumadas), dias_vuelo = (dias_vuelo+1), estado ='M'  where ID = id_aeronave;
  
  	update componentes set horas_vuelo = (horas_vuelo+horas_sumadas), dias_vuelo = (dias_vuelo+1) where AERONAVES_ID = id_aeronave;
	update vuelos set estado_vuelo = 'terminado' where ID =id_vuelos;

	   commit;
	 end sp_distribuir_horas_vuelo;
   
   	-- EXECUTE sp_distribuir_horas_vuelo(11);
     
     
    -- select * from vuelos;
    -- select * from aeronaves where id = 16;
    -- select * from pilotos where ID = 1;
    -- select * from componentes where AERONAVES_ID = 16;
    
create or replace trigger actualiza_estados_pilotos--probar y ver varioables
after insert or update 
on tripulacion
for EACH ROW
BEGIN
  IF INSERTING THEN
  UPDATE pilotos set ESTADO_PILOTO ='no disponible' where id = :new.pilotos_id;   -- deben terminar el vuelo el mismo dia para que no quede deshabilitado por varios dias
 end if;
end;



create or replace trigger verificar_medicina_pilotos --verificar variables
after insert or update 
on pilotos, vuelos
for EACH ROW
BEGIN
  IF INSERTING THEN
  		IF :old.fecha_medicina < sysdate THEN 
      		UPDATE pilotos set ESTADO_PILOTO ='no disponible' where id = :new.pilotos_id;
      	ELSIF UPDATING THEN
      		UPDATE pilotos set ESTADO_PILOTO ='disponible' where id = :new.pilotos_id;
  		END IF; 
 end if;
end;  




-Agregar campo Estado a piloto (pendiente)

-Crear trigger si la fecha de medicina aeroespacial es menor a la actual cambiar estado de piloto a desabilitado(hecho)

-En modificar piloto agregar el campo ESTADO_PILOTO(pendiente)

-En ingresar vuelo se filtra solo pilotos que no esten desabilitados(pendiente)

-Agregar campo Estado a Licencia

-Crear trigger si la fecha de vencimiento de la licencia es menor a la actual cambiar estado de licencia a vencida

-Al ingresar vuelo no permite que un piloto sin la licencia helicoptero o avion realice un vuelo que tenga la aeronave con la licencia vencida

-Al terminar un vuelo el estado de la aeronave cambie a M de mantencion para una revision antes de otro vuelo

- Al terminar un vuelo se liberan los recursos(Como tripulacion aeronave etc) 



