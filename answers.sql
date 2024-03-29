----------------------
-- SOLUCOES
----------------------
--Please consider that your reply for each point should include an explanation and corresponding sql code

1. Primary key definition and any other constraint or index suggestion
----------------------
/* Analisando as informa��es nos arquivos eu mudaria muitas coisas:
A primeira delas � que todas as tabelas n�o possuem uma ID e n�o possui uma primary key e tamb�m n�o possui um �ndice sobre algum campo.
Por isso criei um arquivo (table.SQL) onde tem uma sugest�o de como eu faria essas tabelas.
Outro detalhe � que no meu ponto de vista estaria faltando mais tabelas como por exemplo a de departamentos com o seu �ndice e primary key.
Foi criado tamb�m uma tabela nova de usu�rios com o seu �ndice e com a sua primary key
Tamb�m foi criado uma tabela que liga usu�rios e departamentos contendo a FOREIGN KEY para a tabela de usu�rios e para a tabela de departamentos (que n�o existe)
*/

2. Your suggestion for table data management and data access considering the application usage, 
   for example, partition...
-- Analisando o que poderia e como poderia ser a utiliza��o da aplica��o, a contsru��o das tabelas deveria ou poderia ter as TABLESPACE separadas 
-- o simples fato de serem armazenadas em diferentes tablespaces,j� se poder� observar significativos ganhos de performance em diversos pontos.  
-- e sim, o particionamento das tabelas poderia ter como  benef�cio � a disponibilidade 
--dos dados nas tabelas: podem ser feitas tarefas administrativas nas parti��es ativas e acess�veis, enquanto uma ou outra parti��o esteja offline por algum motivo.
-- Adicionaria na tabela ITEM_LOC_SOH  um campo data que seria a data da ultima atualiza��o, e na particao (criacao da da tabela) assim sendo, criaria a parti�ao dessa tabela
-- sendo particionada por m�s, baseado na coluna nova que acima se criaria.Assim o acesso a I/O e a sele�ao dos dados na clausula WHERE, ser� muito mais eficiente 
-- aqui tamb�m poderia ser particionado os INDEX
-- Outra forma tamb�m seria de aplicar o ILM  para poder Gerenciar o ciclo de vida do dado
--para reduzir muito o custo de armazenamento  onde a camada de armazenamento de alto desempenho �
--onde os dados acessados frequentemente ser�o armazenados, ent�o as parti��es mais usadas ser�o e dever�o ser armazanadas nessa parti�ao.
--A camada de armazenamento de baixo custo (pouco acesso) � onde ser�o armazenados os dados acessados com menor 
--frequ�ncia.   


3. Your suggestion to avoid row contention at table level parameter because of high level of concurrency
--Neste ponto a sugest�o � fazer com que a query que for exposta para as loja que necessitar de utlizar o registro, utilizar o comando com for 'update skip locked'

4. Create a view that can be used at screen level to show only the required fields
-- Foi criada a view para mostrar algumas informacoes 
-- vitem_dep_stck.sql 


5. Create a new table that associates user to existing dept(s)
-- Foi criada uma tabela nova com indeices e PKS, para ter as informacoes de dep por user.
-- Alem disso foi criado uma tabela que armazena o cadastro de usuarios, aonde foi parametrizado que os x usuarios que foram criados, tem acesso a todos os departamentos que existem.
-- Todoas as tabelas foram criadas com Indeces, PK e FK e suas devidas SEQUENCES 
-- O correto no meu ponto de vista era tem uma tabela especifica para o cadastro dos departamentos 
-- user_dept.sql 


### PLSQL Development
6. Create a package with procedure or function that can be invoked by store or all stores to save the item_loc_soh to a new table 
that will contain the same information plus the stock value per item/loc (unit_cost*stock_on_hand)
-- foi ciiada a packge e a mesma pode ser chamada atrav�s do metodo  GERA_DADOS passando ou nao o pi_store que seria o departamento para gerar o hist�rico  
--pkg_stock_application.pks
--pkg_stock_application.pkb

7. Create a data filter mechanism that can be used at screen level to filter out the data that 
user can see accordingly to dept association (created previously)
-- foi feito um slect utilizando as 2 tabelas novas que foram criadas e que est�o indexadas.
-- aqui nesse select � poss�vel atraves do usuario buscar quais departamentos ele tem acesso .
-- poderia ser feito um view tambem

/*
SELECT usu.nome,
       it.dept,
       it.item,
       it.item_desc,
       stck.unit_cost,
       stck.stock_on_hand
FROM   user_dept us,
       usuarios usu,
       item it,
       item_loc_soh stck
WHERE  usu.ID = us.user_id
AND    it.dept = us.dept_id
AND    stck.dept = us.dept_id
AND    stck.item_id = it.ID
*/


8. Create a pipeline function to be used in the location list of values (drop down)
-- foram criados alguns obejtos, como type, uma tabela formada de um type row, alem disse um function que retorna as informa�oes baseado na tabela formada pelo type 
--get_tab_stck.fnc
-- pipeline.sql
/*
SELECT  ID,              
        item_id,                       
        dept    ,      
        unit_cost,     
        stock_on_hand 
      FROM     TABLE (get_tab_stck (??????))
*/


## Should Have
### Performance
9. Looking into the following explain plan what should be your recommendation and implementation to improve 
the existing data model. 
Please share your solution in sql and the corresponding explain plan of that solution. 
Please take in consideration the way that user will use the app.
-- Minha sugest�a� comeca em ter que criar Indeces e primary key nas tabelas.
-- Alem disso criar um ID indexado dentro de cada tabela, e tamb�m tabela de cadastros especificos para cada divisao (Localiza�cao , Usuarios, departamentos..)
-- O Arquivo tables.sql tem uma cria��o de como eu faria 


10. Run the previous method that was created on 6. for all the stores from item_loc_soh to the history table. 
The entire migration should not take more than 10s to run (dont use parallel hint to solve it :)) 
 -- foi criado um procedimento dentro da pkg para que foi de uma maneira dinamica exectado   
/*
BEGIN
   pkg_stock_application.gera_dados (NULL);
END;
*/ 
 
11. Please have a look into the AWR report (AWR.html) in attachment 
and let us know what is the problem that the AWR is highlighting and potential solution.
-- como as tabelas n�o possuem NENHUM indice criado e nenhuma Primary Key, e eventual que o Acesso em I/O ser� alto,
--por isso minha sugestao de ter indices e primary kry conforme o arquivo que cirei.
-- tamb�m nao existem tablespace para as tabelas, isso infliencia


## Nice to have
### Performance
11. Create a program (plsql and/or java, or any other language) that can extract to a flat file (csv), 
1 file per location: the item, department unit cost, stock on hand quantity and stock value.
Creating the 1000 files should take less than 30s.
-- Foi criado o arquivo ( gerar csv.sql )que faz isso  , 
-- e dentro tem 2 vers�es de como poderia ser feito 