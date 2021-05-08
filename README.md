# Power-BI

+ Documentação de [Linguagem M](https://docs.microsoft.com/en-us/powerquery-m/power-query-m-function-reference) e [fórmulas DAX](https://dax.guide/)

**Dica:** Power BI em tela cheia adicione no final do link o código ``?chromeless=true``

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

## Filtrar o link de URL do Power BI embedado.

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
