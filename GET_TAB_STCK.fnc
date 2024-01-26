/* Formatted on 2024/01/26 09:55 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FUNCTION get_tab_stck (pi_loc IN NUMBER)
   RETURN t_stck_tab
AS
   l_tab       t_stck_tab := t_stck_tab ();
   v_item_id   NUMBER;
   v_dept_id   NUMBER;
   v_count     NUMBER     := 0;
BEGIN
   FOR i IN (SELECT item_id, 
                    dept,
                    unit_cost,
                    stock_on_hand
             FROM   item_loc_soh
             WHERE  loc_id = pi_loc)
   LOOP
      v_count := v_count + 1;
      l_tab.EXTEND;
      l_tab (l_tab.LAST) :=
         t_stck_row (v_count, i.item_id, i.dept, i.unit_cost,
                     i.stock_on_hand);
   END LOOP;

   RETURN l_tab;
END;
/