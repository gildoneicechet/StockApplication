---------------------------------------------
-- INICIO TABELA DE USUARIOS
----------------------------------------------



DROP SEQUENCE SEQ_ID_USUARIOS;


CREATE SEQUENCE SEQ_ID_USUARIOS
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;


-- DROP TABELA DE USUARIOS 
DROP TABLE USUARIOS;

-- CRIA A TABELA DE USUARIOS  
CREATE TABLE USUARIOS(  ID                  NUMBER(10)   NOT NULL,
                         LOGIN              VARCHAR2(70) NOT NULL,
                         SENHA              VARCHAR2(100) NOT NULL,
                         NOME               VARCHAR2(70) NOT NULL,
                         CPF                NUMBER(10)   NOT NULL,
                         DT_NASCIMENTO      DATE NOT NULL,
                         DT_CADASTRO        DATE NOT NULL,
                         DT_VALIDADE_INI    DATE NOT NULL,
                         DT_VALIDADE_FIN    DATE NOT NULL,
                         E_MAIL             VARCHAR2(70) NOT NULL
);

-- CRIA UM IDICE PARA O ID DA TABELA USUARIOS 
CREATE UNIQUE INDEX USUARIOS_PK ON USUARIOS
(ID)
LOGGING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- CRIA UMA PRIMARY KEY PARA O ID DA TABELA ID 
ALTER TABLE USUARIOS ADD (
  CONSTRAINT USUARIOS_PK
 PRIMARY KEY
 (ID)
    USING INDEX 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

---------------------------------------------
-- FINAL TABELA DE USUARIOS
----------------------------------------------


---------------------------------------------
-- INICIO TABELA DE DEPARTAMENTO / USUARIOS
----------------------------------------------

DROP SEQUENCE DEPT_USER;


CREATE SEQUENCE SEQ_ID_DEPT_USER
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;



DROP TABLE DEPT_USER;

-- CRIA A TABELA DE ITEM AONDE FOI ADICIONADO UM CAMPO CHAMADO ID PARA PERFOMATICAMENTE FALANDO ELE SER UNICO E TER O SEU INDICE 
CREATE TABLE USER_DEPT(  ID           NUMBER(10)   NOT NULL,
                         DEPT_ID      NUMBER(10)   NOT NULL,
                         USER_ID      NUMBER(10)   NOT NULL
);



CREATE UNIQUE INDEX USER_DEPT_PK ON USER_DEPT
(ID,DEPT_ID,USER_ID )
LOGGING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX  USER_DEPT_UK ON  USER_DEPT
(ID,DEPT_ID,USER_ID )
LOGGING
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE USER_DEPT ADD (
  CONSTRAINT USER_DEPT_PK
 PRIMARY KEY
 (ID,DEPT_ID,USER_ID)
    USING INDEX 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE USER_DEPT ADD (
  CONSTRAINT USER_DEPT_USER_FK  
 FOREIGN KEY (USER_ID) 
 REFERENCES USUARIOS (ID)
    ON DELETE CASCADE);
 

---------------------------------------------
-- FINAL  TABELA DE DEPARTAMENTO / USUARIOS
----------------------------------------------
