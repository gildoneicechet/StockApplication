/* Formatted on 2024/01/26 16:23 (Formatter Plus v4.8.8) */
DECLARE
   CURSOR c_cursor
   IS
      SELECT it.ID item_id,
             lc.ID loc_id,
             dept,
             (DBMS_RANDOM.VALUE (5000, 50000)) unit_cost,
             ROUND (DBMS_RANDOM.VALUE (1000, 100000)) stock_on_hand
      FROM   item it,
             loc lc;

   TYPE type_cursor IS TABLE OF c_cursor%ROWTYPE
      INDEX BY BINARY_INTEGER;

   r_cursor   type_cursor;
BEGIN
   INSERT INTO item
               (ID, item, dept, item_desc)
      SELECT     seq_id_item.NEXTVAL,
                 LEVEL,
                 ROUND (DBMS_RANDOM.VALUE (1, 100)),
                 TRANSLATE (DBMS_RANDOM.STRING ('a', 20), 'abcXYZ', LEVEL)
      FROM       DUAL
      CONNECT BY LEVEL <= 10000;

   INSERT INTO loc
               (ID, loc_desc)
      SELECT     seq_id_item.NEXTVAL,
                 TRANSLATE (DBMS_RANDOM.STRING ('a', 20), 'abcXYZ', LEVEL)
      FROM       DUAL
      CONNECT BY LEVEL <= 1000;

   COMMIT;

   OPEN c_cursor;

   LOOP
      FETCH c_cursor
      BULK COLLECT INTO r_cursor LIMIT 1000;

      EXIT WHEN r_cursor.COUNT = 0;

      FOR i IN 1 .. r_cursor.COUNT
      LOOP
         INSERT INTO item_loc_soh
                     (ID, item_id,
                      loc_id, dept,
                      unit_cost, stock_on_hand
                     )
              VALUES (seq_id_item_loc_soh.NEXTVAL, r_cursor (i).item_id,
                      r_cursor (i).loc_id, r_cursor (i).dept,
                      r_cursor (i).unit_cost, r_cursor (i).stock_on_hand
                     );
      END LOOP;

      COMMIT;
   END LOOP c_cursor;

   CLOSE c_cursor;

   -- CRIACAO DOS USER
   BEGIN
      INSERT INTO usuarios
                  (ID, login, senha, nome, cpf, dt_nascimento, dt_cadastro,
                   dt_validade_ini, dt_validade_fin, e_mail)
         SELECT     seq_id_usuarios.NEXTVAL,
                    SUBSTR (TRANSLATE (DBMS_RANDOM.STRING ('q', 5),
                                       'test',
                                       LEVEL
                                      ),
                            1,
                            5
                           ),
                    RAWTOHEX
                       (DBMS_OBFUSCATION_TOOLKIT.md5
                           (input      => UTL_RAW.cast_to_raw
                                             ((TRANSLATE
                                                    (DBMS_RANDOM.STRING ('1',
                                                                         20
                                                                        ),
                                                     'w',
                                                     LEVEL
                                                    )
                                              )
                                             )
                           )
                       ),
                    SUBSTR (TRANSLATE (DBMS_RANDOM.STRING ('q', 5),
                                       'test',
                                       LEVEL
                                      ),
                            1,
                            5
                           ),
                    LPAD (LEVEL, 14, 0),
                    TRUNC (SYSDATE - (LEVEL * 990.3)),
                    TRUNC (SYSDATE),
                    TRUNC (SYSDATE),
                    TRUNC (SYSDATE) + 100,
                       LPAD (LEVEL, 14, 0)
                    || REPLACE (TRUNC (SYSDATE - (LEVEL * 990.3)), '/', '')
                    || '@'
                    || 'gmail.com'
         FROM       DUAL
         CONNECT BY LEVEL <= 30;

      COMMIT;
   END;

   -- CRIACAO DOS DEARTAMENTOS POR USUARIO
   DECLARE
      v_id   NUMBER;
   BEGIN
      FOR r_user IN (SELECT ID id_user
                     FROM   usuarios)
      LOOP
         FOR r_dept IN (SELECT DISTINCT dept id_dept
                        FROM            item)
         LOOP
            v_id := seq_id_dept_user.NEXTVAL;

            INSERT INTO user_dept
                        (ID, dept_id, user_id
                        )
                 VALUES (v_id, r_dept.id_dept, r_user.id_user
                        );
         END LOOP;
      END LOOP;

      COMMIT;
   END;

   -- CRIACAO DOS DEARTAMENTOS POR USUARIO
   DECLARE
      v_id   NUMBER;
   BEGIN
      FOR r_store IN (SELECT ID id_user
                      FROM   usuarios)
      LOOP
         FOR r_dept IN (SELECT DISTINCT dept id_dept
                        FROM            item)
         LOOP
            v_id := seq_id_dept_user.NEXTVAL;

            INSERT INTO user_dept
                        (ID, dept_id, user_id
                        )
                 VALUES (v_id, r_dept.id_dept, r_user.id_user
                        );
         END LOOP;
      END LOOP;

      COMMIT; 
   END;

   BEGIN
      pkg_stock_application.gera_dados (NULL);
   END;
END;