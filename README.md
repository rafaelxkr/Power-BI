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

# [Codigo de Barras](https://docs.microsoft.com/pt-br/power-bi/transform-model/desktop-mobile-barcodes)
  Para habilitar a opção de filtrar o relatório do Power BI no App do Android ou IOS,
  basta categorizar a coluna que terá a informação de código de barras, como na imagem abaixo.
![Passo1](https://docs.microsoft.com/pt-br/power-bi/transform-model/media/desktop-mobile-barcodes/power-bi-desktop-barcode.png)

  Apos isso, é só selecionar no aplicativo a [opção de scaner](https://docs.microsoft.com/pt-br/power-bi/consumer/mobile/mobile-apps-scan-barcode-iphone#scan-a-barcode-with-the-power-bi-scanner)
![Passo2](https://docs.microsoft.com/pt-br/power-bi/consumer/mobile/media/mobile-apps-scan-barcode-iphone/power-bi-scanner.png)

  Apontar para o produto

![Passo3](https://user-images.githubusercontent.com/31570331/113535981-4edd3c00-95ab-11eb-930e-36f2ac92693c.png)
