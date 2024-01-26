/* Formatted on 2024/01/26 09:50 (Formatter Plus v4.8.8) */

DROP TYPE t_stck_tab;

DROP TYPE t_stck_row;


 

CREATE TYPE t_stck_row AS OBJECT (
   ID              NUMBER,
   item_id         NUMBER(10),
   dept            NUMBER(4),
   unit_cost       NUMBER(20,4),
   stock_on_hand   NUMBER(12,4)
);

CREATE TYPE t_stck_tab IS TABLE OF t_stck_row;




     