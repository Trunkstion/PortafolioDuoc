-- Generado por Oracle SQL Developer Data Modeler 4.1.3.901
--   en:        2016-09-08 16:23:41 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g




CREATE TABLE aerodromos
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (80 CHAR) NOT NULL ,
    ciudad      VARCHAR2 (40 CHAR) NOT NULL
  ) ;
ALTER TABLE aerodromos ADD CONSTRAINT aerodromos_PK PRIMARY KEY ( id ) ;


CREATE TABLE aeronaves
  (
    id                      NUMBER NOT NULL ,
    matricula               VARCHAR2 (5 CHAR) NOT NULL ,
    tipo_aeronaves_id       NUMBER NOT NULL ,
    estado                  CHAR (1) NOT NULL ,
    fecha_aeronavegabilidad DATE NOT NULL ,
    fecha_inspeccion_anual  DATE NOT NULL ,
    horas_vuelo FLOAT NOT NULL ,
    dias_vuelo NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN aeronaves.estado
IS
  'BOOLEAN' ;
ALTER TABLE aeronaves ADD CONSTRAINT aeronaves_PK PRIMARY KEY ( id ) ;
ALTER TABLE aeronaves ADD CONSTRAINT aeronaves__UN UNIQUE ( matricula ) ;


CREATE TABLE componentes
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (40 CHAR) NOT NULL ,
    fabricante  VARCHAR2 (25 CHAR) NOT NULL ,
    horas_vuelo FLOAT NOT NULL ,
    dias_vuelo           NUMBER NOT NULL ,
    tipos_componentes_id NUMBER NOT NULL ,
    componentes_id       NUMBER ,
    aeronaves_id         NUMBER
  ) ;
ALTER TABLE componentes ADD CONSTRAINT componentes_PK PRIMARY KEY ( id ) ;


CREATE TABLE detalles_mantenimientos
  (
    mantenimientos_id             NUMBER NOT NULL ,
    componentes_id                NUMBER NOT NULL ,
    planes_m_planes_id            NUMBER NOT NULL ,
    planes_m_tipos_componentes_id NUMBER NOT NULL ,
    tareas_seleccionadas          VARCHAR2 (30 CHAR) ,
    estado                        VARCHAR2 (140 CHAR) NOT NULL
  ) ;
ALTER TABLE detalles_mantenimientos ADD CONSTRAINT detalles_mantenimientos_PK PRIMARY KEY ( mantenimientos_id, componentes_id ) ;


CREATE TABLE licencias
  (
    id                 NUMBER NOT NULL ,
    numero             NUMBER NOT NULL ,
    tipos_licencias_id NUMBER NOT NULL ,
    fecha_vencimiento  DATE NOT NULL ,
    horas_vuelo FLOAT NOT NULL ,
    dias_vuelo NUMBER NOT NULL ,
    pilotos_id NUMBER NOT NULL
  ) ;
CREATE UNIQUE INDEX licencias__IDX ON licencias
  (
    pilotos_id ASC
  )
  ;
ALTER TABLE licencias ADD CONSTRAINT licencias_PK PRIMARY KEY ( id ) ;
ALTER TABLE licencias ADD CONSTRAINT licencias__UN UNIQUE ( numero ) ;


CREATE TABLE mantenimientos
  (
    id            NUMBER NOT NULL ,
    fecha_inicio  DATE NOT NULL ,
    fecha_termino DATE
  ) ;
ALTER TABLE mantenimientos ADD CONSTRAINT mantenimiento_PK PRIMARY KEY ( id ) ;


CREATE TABLE perfiles_usuarios
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (25 CHAR) NOT NULL
  ) ;
ALTER TABLE perfiles_usuarios ADD CONSTRAINT perfiles_usuarios_PK PRIMARY KEY ( id ) ;


CREATE TABLE personas
  (
    id               NUMBER NOT NULL ,
    rut              VARCHAR2 (12 CHAR) NOT NULL ,
    nombre           VARCHAR2 (20 CHAR) NOT NULL ,
    apellidos        VARCHAR2 (25 CHAR) NOT NULL ,
    sexo             CHAR (1) NOT NULL ,
    fecha_nacimiento DATE NOT NULL ,
    telefono         VARCHAR2 (25 CHAR) ,
    correo           VARCHAR2 (25 CHAR) ,
    nacionalidad     VARCHAR2 (25 CHAR) ,
    usuarios_id      NUMBER NOT NULL
  ) ;
CREATE UNIQUE INDEX personas__IDX ON personas
  (
    usuarios_id ASC
  )
  ;
ALTER TABLE personas ADD CONSTRAINT personas_PK PRIMARY KEY ( id ) ;
ALTER TABLE personas ADD CONSTRAINT personas__UN UNIQUE ( rut , usuarios_id ) ;


CREATE TABLE pilotos
  (
    id NUMBER NOT NULL ,
    horas_vuelo FLOAT NOT NULL ,
    dias_vuelo             NUMBER NOT NULL ,
    vencimiento_medicina   DATE ,
    ultimo_vuelo_realizado DATE ,
    personas_id            NUMBER NOT NULL
  ) ;
CREATE UNIQUE INDEX pilotos__IDX ON pilotos
  (
    personas_id ASC
  )
  ;
ALTER TABLE pilotos ADD CONSTRAINT pilotos_PK PRIMARY KEY ( id ) ;
ALTER TABLE pilotos ADD CONSTRAINT pilotos__UN UNIQUE ( personas_id ) ;


CREATE TABLE planes
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (25 CHAR) NOT NULL
  ) ;
ALTER TABLE planes ADD CONSTRAINT planes_PK PRIMARY KEY ( id ) ;


CREATE TABLE planes_mantenimientos
  (
    planes_id            NUMBER NOT NULL ,
    tipos_componentes_id NUMBER NOT NULL ,
    tareas CLOB NOT NULL
  ) ;
ALTER TABLE planes_mantenimientos ADD CONSTRAINT planes_mantenimientos_PK PRIMARY KEY ( planes_id, tipos_componentes_id ) ;


CREATE TABLE tipos_aeronaves
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (25 CHAR) NOT NULL
  ) ;
ALTER TABLE tipos_aeronaves ADD CONSTRAINT tipo_aeronaves_PK PRIMARY KEY ( id ) ;


CREATE TABLE tipos_componentes
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (25 CHAR) NOT NULL
  ) ;
ALTER TABLE tipos_componentes ADD CONSTRAINT tipos_componentes_PK PRIMARY KEY ( id ) ;


CREATE TABLE tipos_licencias
  (
    id          NUMBER NOT NULL ,
    descripcion VARCHAR2 (25 CHAR) NOT NULL
  ) ;
ALTER TABLE tipos_licencias ADD CONSTRAINT tipos_licencias_PK PRIMARY KEY ( id ) ;


CREATE TABLE tripulacion
  (
    vuelos_id  NUMBER NOT NULL ,
    pilotos_id NUMBER NOT NULL
  ) ;
ALTER TABLE tripulacion ADD CONSTRAINT tripulacion_PK PRIMARY KEY ( vuelos_id, pilotos_id ) ;


CREATE TABLE usuarios
  (
    id                   NUMBER NOT NULL ,
    "user"               VARCHAR2 (20 CHAR) NOT NULL ,
    pass                 VARCHAR2 (20 CHAR) NOT NULL ,
    perfiles_usuarios_id NUMBER NOT NULL
  ) ;
ALTER TABLE usuarios ADD CONSTRAINT usuarios_PK PRIMARY KEY ( id ) ;
ALTER TABLE usuarios ADD CONSTRAINT usuarios__UN UNIQUE ( "user" ) ;


CREATE TABLE vuelos
  (
    id                    NUMBER NOT NULL ,
    aerodromos_id_origen  NUMBER NOT NULL ,
    aerodromos_id_destino NUMBER NOT NULL ,
    horas_vuelo FLOAT NOT NULL ,
    condicion_vuelo CHAR (1) NOT NULL ,
    mision_vuelo    VARCHAR2 (140 CHAR) NOT NULL ,
    fecha_vuelo     DATE NOT NULL ,
    aeronaves_id    NUMBER NOT NULL
  ) ;
CREATE UNIQUE INDEX vuelos_origen__IDX ON vuelos
  (
    aerodromos_id_origen ASC
  )
  ;
CREATE UNIQUE INDEX vuelos_destino__IDX ON vuelos
  (
    aerodromos_id_destino ASC
  )
  ;
ALTER TABLE vuelos ADD CONSTRAINT vuelos_PK PRIMARY KEY ( id ) ;


ALTER TABLE aeronaves ADD CONSTRAINT aeronaves_tipo_aeronaves_FK FOREIGN KEY ( tipo_aeronaves_id ) REFERENCES tipos_aeronaves ( id ) ;

ALTER TABLE componentes ADD CONSTRAINT componentes_aeronaves_FK FOREIGN KEY ( aeronaves_id ) REFERENCES aeronaves ( id ) ;

ALTER TABLE componentes ADD CONSTRAINT componentes_componentes_FK FOREIGN KEY ( componentes_id ) REFERENCES componentes ( id ) ;

ALTER TABLE componentes ADD CONSTRAINT componentes_t_componentes_FK FOREIGN KEY ( tipos_componentes_id ) REFERENCES tipos_componentes ( id ) ;

ALTER TABLE detalles_mantenimientos ADD CONSTRAINT detalles_m_componentes_FK FOREIGN KEY ( componentes_id ) REFERENCES componentes ( id ) ;

ALTER TABLE detalles_mantenimientos ADD CONSTRAINT detalles_m_mantenimientos_FK FOREIGN KEY ( mantenimientos_id ) REFERENCES mantenimientos ( id ) ;

ALTER TABLE detalles_mantenimientos ADD CONSTRAINT detalles_m_p_mantenimientos_FK FOREIGN KEY ( planes_m_planes_id, planes_m_tipos_componentes_id ) REFERENCES planes_mantenimientos ( planes_id, tipos_componentes_id ) ;

ALTER TABLE licencias ADD CONSTRAINT licencias_pilotos_FK FOREIGN KEY ( pilotos_id ) REFERENCES pilotos ( id ) ;

ALTER TABLE licencias ADD CONSTRAINT licencias_tipos_licencias_FK FOREIGN KEY ( tipos_licencias_id ) REFERENCES tipos_licencias ( id ) ;

ALTER TABLE personas ADD CONSTRAINT personas_usuarios_FK FOREIGN KEY ( usuarios_id ) REFERENCES usuarios ( id ) ;

ALTER TABLE pilotos ADD CONSTRAINT pilotos_personas_FK FOREIGN KEY ( personas_id ) REFERENCES personas ( id ) ;

ALTER TABLE planes_mantenimientos ADD CONSTRAINT planes_m_planes_FK FOREIGN KEY ( planes_id ) REFERENCES planes ( id ) ;

ALTER TABLE planes_mantenimientos ADD CONSTRAINT planes_m_t_componentes_FK FOREIGN KEY ( tipos_componentes_id ) REFERENCES tipos_componentes ( id ) ;

ALTER TABLE tripulacion ADD CONSTRAINT tripulacion_pilotos_FK FOREIGN KEY ( pilotos_id ) REFERENCES pilotos ( id ) ;

ALTER TABLE tripulacion ADD CONSTRAINT tripulacion_vuelos_FK FOREIGN KEY ( vuelos_id ) REFERENCES vuelos ( id ) ;

ALTER TABLE usuarios ADD CONSTRAINT usuarios_perfiles_usuarios_FK FOREIGN KEY ( perfiles_usuarios_id ) REFERENCES perfiles_usuarios ( id ) ;

ALTER TABLE vuelos ADD CONSTRAINT vuelos_aerodromos_destino_FK FOREIGN KEY ( aerodromos_id_destino ) REFERENCES aerodromos ( id ) ;

ALTER TABLE vuelos ADD CONSTRAINT vuelos_aerodromos_origen_FK FOREIGN KEY ( aerodromos_id_origen ) REFERENCES aerodromos ( id ) ;

ALTER TABLE vuelos ADD CONSTRAINT vuelos_aeronaves_FK FOREIGN KEY ( aeronaves_id ) REFERENCES aeronaves ( id ) ;

CREATE SEQUENCE tipos_aeronaves_id_SEQ START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER tipos_aeronaves_id_TRG BEFORE
  INSERT ON tipos_aeronaves FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := tipos_aeronaves_id_SEQ.NEXTVAL;
END;
/


-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            17
-- CREATE INDEX                             5
-- ALTER TABLE                             41
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           1
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          1
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
