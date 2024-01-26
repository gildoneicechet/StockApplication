/* Formatted on 2024/01/26 08:40 (Formatter Plus v4.8.8) */
DROP VIEW vitem_dep_stck;

CREATE OR REPLACE FORCE VIEW vitem_dep_stck
AS
   SELECT   *
   FROM     item_loc_soh 
   ORDER BY ID ASC;