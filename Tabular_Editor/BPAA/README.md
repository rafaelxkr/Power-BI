# Análise de Melhores Práticas no Power BI Service

Esse script tem o objetivo de identificar problemas de desenvolvimento de relatórios publicados no Power BI Service utilizando o Tabular Editor para exportar os dados em arquivos .trx e serem analisados posteriormente no Power BI.
<br></br>
Utilizado o projeto do [Dave Ruijter](https://github.com/DaveRuijter/BestPracticeAnalyzerAutomation)

## 1° Instale o Power BI CLI
abra seu terminal rode esse código para instalar
`npm i -g @powerbi-cli/powerbi-cli`

## 2° Configure UTF-8 para o Powershell
[Utilizado a solução do Stackoverflow](https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096)


Windows + R cole `intl.cpl` e clique em OK

![image](https://github.com/rafaelxkr/Power-BI/assets/31570331/843877dd-0d62-4434-9498-a071a2ed7360)

Em seguida faça a configuração abaixo:

![image](https://github.com/rafaelxkr/Power-BI/assets/31570331/52ab8509-ef5f-4766-94d9-989a0a4d044b)

## 3° Rode o script BPA_Automation_VLI.ps1 no seu Windows PowerShell ISE

Mas antes é necessário fazer algumas configurações no código, edite essas informações antes de rodar o script.

![image](https://github.com/rafaelxkr/Power-BI/assets/31570331/fd934ff9-ac23-40dc-8d15-74a30566242d)


