/* Formatted on 2024/01/26 16:21 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY pkg_stock_application
IS
   PROCEDURE gera_dados (pi_store IN NUMBER DEFAULT NULL)
   IS
      v_sql                      VARCHAR2 (30000);
      v_sql2                     VARCHAR2 (30000);
      v_sit                      VARCHAR2 (10);
      PRAGMA AUTONOMOUS_TRANSACTION;
      v_count_sinal              NUMBER;
      v_count_qtde_sinal         NUMBER;
      v_count_qtde               NUMBER;
      v_sinaleira_pdv            VARCHAR2 (10);
      v_count_qtde_sinal_igual   NUMBER;
      v_tem_pdv_vde_e_vrm        NUMBER; 
   BEGIN
      EXECUTE IMMEDIATE ('TRUNCATE TABLE  ITEM_LOC_SOH_HIST ');

      v_sql :=
         ' SELECT SEQ_ID_ITEM_LOC_SOH_VAL.NEXTVAL,
                   id,
                   item_id,
                   loc_id,
                   dept,
                   unit_cost,
                   stock_on_hand,
                   round((unit_cost*stock_on_hand),2) stock_value
            FROM   item_loc_soh ';

      IF pi_store IS NOT NULL
      THEN
         v_sql := v_sql || ' WHERE  DEPT =  ' || pi_store;
      END IF;

      EXECUTE IMMEDIATE ('INSERT INTO ITEM_LOC_SOH_HIST (' || v_sql || ')');

      COMMIT;
   END;
END pkg_stock_application;