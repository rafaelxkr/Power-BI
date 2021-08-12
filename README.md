# Power-BI

+ Documentação de [Linguagem M](https://docs.microsoft.com/en-us/powerquery-m/power-query-m-function-reference) e [fórmulas DAX](https://dax.guide/)

**Dica:** Power BI em tela cheia adicione no final do link o código ``?chromeless=true``

# Link para gerecionar acesso do relatório
Útil para relatórios Usage Metric que tem essa opção oculta, com link abaixo é possivel compartilha acesso especifico
para o relatório

`https://app.powerbi.com/groups/{ID_do_Workspace}/permission/report/2/{ID_do_Relatório}/directAccess`

# [Filtrando relatórios pelo link](https://docs.microsoft.com/pt-br/power-bi/collaborate-share/service-url-filters "Documentação Power BI")

Filtrar relatório pelo link:
{link do relatório} ``?filter=Tabela/Coluna eq 'valor para filtrar'``

Filtrar varios valores:
{link do relatório} ``?filter=Tabela/Coluna in ('Valor1', 'Valor2')``

Filtro AND
{link do relatório} ``?filter=Tabela/Coluna eq 'Valor1' and Tabela/Coluna eq 'Valor2'``

* ### Operadores
| operador 	| definição      	| cadeia de caracteres 	| número 	| Data 	| Exemplo                               	|
|:--------:	|:--------------:	|:--------------------:	|:------:	|:----:	|:-------------------------------------:	|
| and      	| e              	| sim                  	| sim    	| sim  	| product/price le 200 and price gt 3.5 	|
| eq       	| igual a        	| sim                  	| sim    	| sim  	| Address/City eq 'Redmond'             	|
| ne       	| diferente de   	| sim                  	| sim    	| sim  	| Address/City ne 'London'              	|
| ge       	| maior ou igual 	| não                  	| sim    	| sim  	| product/price ge 10                   	|
| gt       	| maior que      	| não                  	| sim    	| sim  	| product/price gt 20                   	|
| le       	| menor ou igual 	| não                  	| sim    	| sim  	| product/price le 100                  	|
| lt       	| menor que      	| não                  	| sim    	| sim  	| product/price lt 20                   	|
| in**     	| incluindo      	| sim                  	| sim    	| sim  	| Student/Age in (27, 29)               	|

* ### Caracteres especiais em nomes de tabela e coluna
| Identificador  	| Unicode               	| Codificação para o Power BI 	|
|:--------------:	|:---------------------:	|:---------------------------:	|
| Table Name    	| O espaço é 0x20       	| Table_x0020_Name            	|
| Column@Number  	| @ é 0x40              	| Column_x0040_Number         	|
| [Column]       	| [ é 0x005B ] é 0x005D 	| x005B_Column_x005D          	|
| Column+Plus    	| + é 0x2B              	| Column_x002B_Plus           	|

## [Filtrar o link de URL do Power BI embedado](https://powerbi.microsoft.com/pt-br/blog/easily-embed-secure-power-bi-reports-in-your-internal-portals-or-websites/ "Documentação Power BI")

Abra o relatório do serviço Power BI em seu navegador da web e copie o URL da barra de endereço.
![Link_PowerBI_Service](https://user-images.githubusercontent.com/31570331/117540290-f43d6280-afe4-11eb-87ab-6821a2a55938.png)

Adicione o pageName no final da URL:
![Selecionar_Pagina](https://user-images.githubusercontent.com/31570331/117540324-28b11e80-afe5-11eb-8cdd-3a965b267575.png)

Adicionando filtros
![Filtrando_Pagina](https://user-images.githubusercontent.com/31570331/117540385-89d8f200-afe5-11eb-9810-a168c82211be.png)


# [Codigo de Barras](https://docs.microsoft.com/pt-br/power-bi/transform-model/desktop-mobile-barcodes)
  Para habilitar a opção de filtrar o relatório do Power BI no App do Android ou IOS,
  basta categorizar a coluna que terá a informação de código de barras, como na imagem abaixo.
![Passo1](https://docs.microsoft.com/pt-br/power-bi/transform-model/media/desktop-mobile-barcodes/power-bi-desktop-barcode.png)

  Apos isso, é só selecionar no aplicativo a [opção de scaner](https://docs.microsoft.com/pt-br/power-bi/consumer/mobile/mobile-apps-scan-barcode-iphone#scan-a-barcode-with-the-power-bi-scanner)
![Passo2](https://docs.microsoft.com/pt-br/power-bi/consumer/mobile/media/mobile-apps-scan-barcode-iphone/power-bi-scanner.png)

  Apontar para o produto e pronto, o aplicativo irá abrir o relatório correspondente já filtrado
![Passo3](https://user-images.githubusercontent.com/31570331/113535981-4edd3c00-95ab-11eb-930e-36f2ac92693c.png)

# Removendo Fonte de Dados Desativada do Fluxo de Dados

Fluxo de dados com duas conexões sendo que uma delas não é mais utilizada
![image](https://user-images.githubusercontent.com/31570331/125868467-67869b4b-f754-4492-9467-a97fa3617bfd.png)

Insira a conexão por gateway da conexão de deseja remover
![image](https://user-images.githubusercontent.com/31570331/125868599-0f459dab-1ded-44c5-90d9-ad50a0453826.png)

Abrindo as opções de projeto do Fluxo de Dados, é possivel ver que foi incluido um gateway
![image](https://user-images.githubusercontent.com/31570331/125868826-d73306c3-d833-4792-b677-ceb97b9c7400.png)

Agora remova o gateway e salve seu fluxo de dados <br>
![image](https://user-images.githubusercontent.com/31570331/125868880-1a745925-8d9f-47c1-b99d-c4e2b090bb1e.png)

COnferindo agora a fonte de dados, tem somente uma a outra foi removida
![image](https://user-images.githubusercontent.com/31570331/125868961-aba41d13-43a5-4a18-8fa6-963c2426bbe3.png)

# Dicas de Otimização

## Modelo

* [Remover colunas desnecessárias](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#remove-unnecessary-columns)
* [Remover linhas desnecessárias](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#remove-unnecessary-rows)
* [Agrupar por e resumir](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#group-by-and-summarize)
* [Otimizar tipos de dados de coluna](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#optimize-column-data-types)
* [Preferência por colunas personalizadas](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#preference-for-custom-columns)
* [Desabilitar a carga de consulta do Power Query](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#disable-power-query-query-load)
* [Desabilitar data/hora automática](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#disable-auto-datetime)
* [Mudar para o modo misto](https://docs.microsoft.com/pt-br/power-bi/guidance/import-modeling-data-reduction#switch-to-mixed-mode)
* [Dimensão com Dados Completos Ativa Otimização](https://dax.tips/2019/11/28/clean-data-faster-reports/)
* [Desabilitar MDX para valores e Utilizar Encode Hint](https://www.youtube.com/watch?v=b2b-z5Iv-cM)
* [Artigo de Otimização de Modelo](https://data-mozart.com/how-to-reduce-your-power-bi-model-size-by-90/)
* [Analisando Tamanho do Dicionario DAX STUDIO](https://www.sqlbi.com/articles/measuring-the-dictionary-size-of-a-column-correctly/)
* [Dicas de Otimização Microsoft](https://docs.microsoft.com/pt-br/power-bi/guidance/power-bi-optimization)
* [Dicas de Otimização Pragmatic](https://blog.pragmaticworks.com/power-bi-performance-tips-and-techniques)

## DAX

 * [DIVIDE ao inves de "/"](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-divide-function-operator)
 * [Funções de Erro](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-error-functions)
 * [SELECTEDVALUE ao inves de VALUES](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-error-functions)
 * [COUNTROWS em vez de COUNT](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-countrows)
 * [Utilizar Variáveis](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-variables)
 * [Evite converter BLANKs em valores](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-avoid-converting-blank)
 * [Evite Utilizar a FILTER](https://docs.microsoft.com/pt-br/power-bi/guidance/dax-avoid-avoid-filter-as-filter-argument)

## Dataset Refresh

 * [Performance tuning Power BI](https://www.youtube.com/watch?v=MxONhJJi4go&t=3s)
 * [Otimizando Conexão com Lista do Sharepoint](https://www.linkedin.com/pulse/power-bi-lista-do-sharepoint-rafael-barbosa/) 

## Visual

* [Reduza a Quantidade de Visuais](https://www.sqlbi.com/tv/optimizing-card-visuals-in-slow-power-bi-reports/)

