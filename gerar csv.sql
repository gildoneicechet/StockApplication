
--metodo traciional 
DECLARE
   arquivo_saida   UTL_FILE.file_type;

   CURSOR cur_loc
   IS
      SELECT ID,
             loc_desc  
      FROM   loc;

   CURSOR cur_linha (pi_loc IN NUMBER)
   IS
      SELECT    item_id
             || ';'
             || dept
             || ';'
             || unit_cost
             || ';'
             || stock_on_hand
             || ';'
             || unit_cost * stock_on_hand linha
      FROM   item_loc_soh
      WHERE  loc_id = pi_loc;
      

BEGIN
   FOR reg_loc IN cur_loc
   LOOP
      arquivo_saida :=
         UTL_FILE.fopen ('UTL_FILE_DIR',
                         'LOC -' || reg_loc.loc_desc || '.csv',
                         'W'
                        );

      FOR reg_linha IN cur_linha (reg_loc.ID)
      LOOP
         UTL_FILE.put_line (arquivo_saida, reg_linha.linha);
      END LOOP;
   END LOOP;

   UTL_FILE.fclose (arquivo_saida);
   DBMS_OUTPUT.put_line ('Arquivo gerado com sucesso.');
EXCEPTION
   WHEN UTL_FILE.invalid_operation
   THEN
      DBMS_OUTPUT.put_line ('Operação inválida no arquivo.');
      UTL_FILE.fclose (arquivo_saida);
   WHEN UTL_FILE.write_error
   THEN
      DBMS_OUTPUT.put_line ('Erro de gravação no arquivo.');
      UTL_FILE.fclose (arquivo_saida);
   WHEN UTL_FILE.invalid_path
   THEN
      DBMS_OUTPUT.put_line ('Diretório inválido.');
      UTL_FILE.fclose (arquivo_saida);
   WHEN UTL_FILE.invalid_mode
   THEN
      DBMS_OUTPUT.put_line ('Modo de acesso inválido.');
      UTL_FILE.fclose (arquivo_saida);
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Problemas na geração do arquivo.');
      UTL_FILE.fclose (arquivo_saida);
END;


-- usando type e bulk collect 
DECLARE
   l_file       UTL_FILE.file_type;

   CURSOR c_get_loc
   IS
      SELECT ID,
             loc_desc
      FROM   loc;
      

   TYPE l_loc_rec_type IS RECORD (
      ID         NUMBER,
      loc_desc   VARCHAR2 (30)
   );

   TYPE l_loc_tab_type IS TABLE OF l_loc_rec_type;

   l_loc_tab   l_loc_tab_type;
   
BEGIN
   OPEN c_get_loc;

   FETCH c_get_loc
   BULK COLLECT INTO l_loc_tab;

   CLOSE c_get_loc;

   IF l_loc_tab.COUNT > 0
   THEN
      FOR l_cnt_1 IN l_loc_tab.FIRST .. l_loc_tab.LAST
      LOOP
         l_file :=
            UTL_FILE.fopen ('UTL_FILE_DIR',
                            l_loc_tab (l_cnt_1).ID || '.csv',
                            'W'
                           );

         FOR l_cnt IN (SELECT    item_id
                              || ';'
                              || dept
                              || ';'
                              || unit_cost
                              || ';'
                              || stock_on_hand
                              || ';'
                              || unit_cost * stock_on_hand linha
                       FROM   item_loc_soh
                       WHERE  loc_id = l_loc_tab (l_cnt_1).ID)
         LOOP
            UTL_FILE.put_line (l_file, l_cnt.linha);
         END LOOP;

         UTL_FILE.fclose (l_file);
      END LOOP;
   END IF;
END;

 