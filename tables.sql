


--------------------------
--INICIO TABELA DE ITEM  
--------------------------

-- DROPA A SEQUWNCE PARA A TABELA DO ITEM
DROP SEQUENCE SEQ_ID_ITEM;

-- CRIA A SEQUWNCE PARA A TABELA DO ITEM
CREATE SEQUENCE SEQ_ID_ITEM
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;

--- FAZ A EXCLUSÃO DAS CONSTRAINT ANTES DE DROPAR A TABELA DE ITEM 
ALTER TABLE ITEM_LOC_SOH 
DROP  CONSTRAINT ITEM_LOC_SOH_ITEM_FK;

--- FAZ A EXCLUSÃO DAS CONSTRAINT ANTES DE DROPAR A TABELA DE LOCALIZACAO 
ALTER TABLE ITEM_LOC_SOH 
  DROP   CONSTRAINT ITEM_LOC_SOH_LOC_FK;
------------------------------------------------------

-- DROP TABELA DO ITEM 
DROP TABLE ITEM;

-- CRIA A TABELA DE ITEM AONDE FOI ADICIONADO UM CAMPO CHAMADO ID PARA PERFOMATICAMENTE FALANDO ELE SER UNICO E TER O SEU INDICE 
CREATE TABLE ITEM( ID        NUMBER(10)   NOT NULL,
                   ITEM      VARCHAR2(25) NOT NULL,
                   DEPT      NUMBER(4)    NOT NULL,
                   ITEM_DESC VARCHAR2(25) NOT NULL
);

-- CRIA UMA UK PARA TER APENAS UM ID POR ITEM VISTO QUE O CAMPO ITEM É UM VARCHAR2 
CREATE UNIQUE INDEX TITEM_UK ON ITEM
(ID, ITEM)
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

-- CRIA UM IDICE PARA O ID DA TABELA ITEM 
CREATE UNIQUE INDEX TITEM_PK ON ITEM
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
ALTER TABLE ITEM ADD (
  CONSTRAINT TITEM_PK
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

--------------------------
--FINAL  TABELA DE ITEM  
--------------------------



---------------------------------
-- INICIO TABELA DA LOCALIZACAO 
---------------------------------

-- DROP A SEUQENCE DA TABELA DE LOCALIZACAO 
DROP SEQUENCE SEQ_ID_LOC;

-- CRIA A SEQUENCE DA TABELA DE LOCALIZAÇAO 
CREATE SEQUENCE SEQ_ID_LOC
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;

-- DROPA A TABELA DE LOCALIZACAO 
DROP TABLE LOC;

-- CRIA A TABELA DE LOCALIZACAO ONDE FOI MUDADO O NOME DO CAMPO PARA FICAR PADRÃO 
CREATE TABLE LOC(
                    ID       NUMBER(10) NOT NULL,
                    LOC_DESC VARCHAR2(25) NOT NULL
);

-- CRIA UM INDICE PARA O ID, PORÉM ELE SERIA CRIADO SE EXECUTADO O COMANDO ABAIXO ANTES 
CREATE UNIQUE INDEX  TLOC_PK ON LOC
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

-- CRIA UM PK PARA A TABELA DE LOCALIZACAO 
ALTER TABLE LOC ADD (
  CONSTRAINT TLOC_PK
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

---------------------------------
-- FINAL TABELA DA LOCALIZACAO 
---------------------------------


------------------------------------------------------------------
-- INICIO TABELA QUE LIGA ITEM,LOCALIZACAO E DEPARTAMENTO 
------------------------------------------------------------------


DROP SEQUENCE SEQ_ID_ITEM_LOC_SOH;

CREATE SEQUENCE SEQ_ID_ITEM_LOC_SOH
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;


DROP TABLE ITEM_LOC_SOH;

CREATE TABLE ITEM_LOC_SOH(
                            ID              NUMBER(10)      NOT NULL,
                            ITEM_ID         NUMBER(10)      NOT NULL,
                            LOC_ID          NUMBER(10)      NOT NULL,
                            DEPT            NUMBER(4)       NOT NULL,
                            UNIT_COST       NUMBER(20,4)    NOT NULL,
                            STOCK_ON_HAND   NUMBER(12,4)    NOT NULL
);


ALTER TABLE ITEM_LOC_SOH ADD (
  CONSTRAINT TITEM_LOC_SOH_PK
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

 

ALTER TABLE ITEM_LOC_SOH ADD (  
  CONSTRAINT TITEM_LOC_SOH_UK
 UNIQUE (ITEM_ID,  LOC_ID,  DEPT)
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

ALTER TABLE ITEM_LOC_SOH ADD (
  CONSTRAINT ITEM_LOC_SOH_ITEM_FK 
 FOREIGN KEY (ITEM_ID) 
 REFERENCES ITEM (ID)
    ON DELETE CASCADE);


ALTER TABLE ITEM_LOC_SOH ADD (
  CONSTRAINT ITEM_LOC_SOH_LOC_FK 
 FOREIGN KEY (LOC_ID) 
 REFERENCES LOC (ID)
    ON DELETE CASCADE);


------------------------------------------------------------------
-- FINAL TABELA QUE LIGA ITEM,LOCALIZACAO E DEPARTAMENTO 
------------------------------------------------------------------


------------------------------------------------------------------
-- INICIO TABELA STORES 
------------------------------------------------------------------


DROP SEQUENCE SEQ_ID_STORES;

CREATE SEQUENCE SEQ_ID_STORES
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;
  

DROP TABLE STORES;

CREATE TABLE STORES(
                            ID              NUMBER(10)      NOT NULL,
                            DESCRICAO       VARCHAR2(100)   NOT NULL 
);  


ALTER TABLE STORES ADD (
  CONSTRAINT STORES_PK
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

------------------------------------------------------------------
--  FINA TABELA STORES 
------------------------------------------------------------------



------------------------------------------------------------------
-- INICIO TABELA QUE LIGA ITEM,LOCALIZACAO E DEPARTAMENTO 
------------------------------------------------------------------

 


DROP SEQUENCE SEQ_ID_ITEM_LOC_SOH_VAL;

CREATE SEQUENCE SEQ_ID_ITEM_LOC_SOH_VAL
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 0
  CYCLE
  CACHE 20
  NOORDER;


DROP TABLE ITEM_LOC_SOH_VAL;


CREATE TABLE ITEM_LOC_SOH_HIST(
                            ID              NUMBER(10)      NOT NULL,
                            ITEM_LOC_SOH_ID NUMBER(10)      NOT NULL,
                            ITEM_ID         NUMBER(10)      NOT NULL,
                            LOC_ID          NUMBER(10)      NOT NULL,
                            DEPT            NUMBER(4)       NOT NULL,
                            UNIT_COST       NUMBER(20,4)    NOT NULL,
                            STOCK_ON_HAND   NUMBER(12,4)    NOT NULL,
                            STOCK_VALUE     NUMBER(19,7)    NOT NULL  
);


ALTER TABLE ITEM_LOC_SOH_HIST ADD (
  CONSTRAINT ITEM_LOC_SOH_HIST_PK
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

 

ALTER TABLE ITEM_LOC_SOH_HIST ADD (  
  CONSTRAINT ITEM_LOC_SOH_HIST_UK
 UNIQUE (ITEM_LOC_SOH_ID,ITEM_ID,LOC_ID,DEPT)
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

ALTER TABLE ITEM_LOC_SOH_HIST ADD (
  CONSTRAINT ITEM_LOC_SOH_VAL_IT_FK 
 FOREIGN KEY (ITEM_ID) 
 REFERENCES ITEM (ID)
    ON DELETE CASCADE);


ALTER TABLE ITEM_LOC_SOH_HIST ADD (
  CONSTRAINT ITEM_LOC_SOH_HIST_LOC_FK 
 FOREIGN KEY (LOC_ID) 
 REFERENCES LOC (ID)
    ON DELETE CASCADE);


------------------------------------------------------------------
-- FINAL TABELA QUE LIGA ITEM,LOCALIZACAO E DEPARTAMENTO 
------------------------------------------------------------------
               