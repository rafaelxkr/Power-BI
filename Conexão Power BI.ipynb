{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Como conectar dados pela web no Power BI"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### API metodo Get"
   ]
  },
  {
   "cell_type": "raw",
   "metadata": {},
   "source": [
    "Json.Document(Web.Contents(\"https://api.vipdireto.com/api/integracao/v2/veiculos?u={usuario}&s={senha}&init=01/02/2019&end=31/08/2019\"))"
   ]
  },
  {
   "cell_type": "raw",
   "metadata": {},
   "source": [
    "u=usuario\n",
    "s=senha\n",
    "init= data inicio\n",
    "end= data fim"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "* ### API metodo Post (com Header)"
   ]
  },
  {
   "cell_type": "raw",
   "metadata": {},
   "source": [
    "let\n",
    "url = \" http://api.vipdireto.com/api/integracao/getveiculolist\",\n",
    "body = \"{\"\"Usuario\"\": \"\"usuario\"\",\"\"Senha\"\":\"\"senha\"\",\"\"Chave\"\":\"\"\"\"}\",\n",
    "Source = Json.Document(Web.Contents(url,[ \n",
    "Headers = [#\"Content-Type\"=\"application/json\"],\n",
    "Content = Text.ToBinary(body) \n",
    "] \n",
    "))\n",
    "in\n",
    "Source\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "* ### API metodo Post (com Header)\n",
    " <span style=\"color:red\"> **!!!!!Ainda não foi validado**</span>"
   ]
  },
  {
   "cell_type": "raw",
   "metadata": {},
   "source": [
    "let\n",
    "url = \" https://api.vhsys.com/v2/contas-pagar\",\n",
    "body = \"{\"\"data_pagamento\"\": \"\"2019-03-01,2019-03-31\"\",\"\"lixeira\"\":\"\"Nao\"\",\"\"Liquidado\"\":\"\"Sim\"\",\"\"limit\"\":\"\"1000\"\"}\",\n",
    "Source = Json.Document(Web.Contents(url,[ \n",
    "Headers = [\n",
    "            #\"access-token\"=\"TOKEN\",\n",
    "            #\"secret-acess-token\"=\"SENHA\",\n",
    "            #\"cache-control\"=\"no-cache\",\n",
    "            #\"Content-Type\"=\"application/json\"\n",
    "            ],\n",
    "Content = Text.ToBinary(body) \n",
    "] \n",
    "))\n",
    "in\n",
    "Source\n"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "* ### API Dinamica metodo GET"
   ]
  },
  {
   "cell_type": "raw",
   "metadata": {},
   "source": [
    "\n",
    "    Moeda = (CodMoeda as text) =>\n",
    " \n",
    "let\n",
    "    Source = Json.Document(Web.Contents(\"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/\",\n",
    "    [\n",
    "        RelativePath= \"CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@moeda='\"&CodMoeda&\"'&@dataInicial='01-01-2000'&@dataFinalCotacao='12-31-9999'&$top=10000&$filter=not%20contains(tipoBoletim%2C'Inter')&$orderby=dataHoraCotacao%20desc&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim\"\n",
    "        ])),\n",
    "    #\"Convertido para Tabela\" = Record.ToTable(Source),\n",
    "    #\"Linhas Filtradas\" = Table.SelectRows(#\"Convertido para Tabela\", each ([Name] = \"value\")),\n",
    "    #\"Value Expandido\" = Table.ExpandListColumn(#\"Linhas Filtradas\", \"Value\")\n",
    "in\n",
    "    #\"Value Expandido\",\n",
    "\n",
    "    Fonte = Json.Document(Web.Contents(\"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas?$top=100&$format=json&$select=simbolo,nomeFormatado,tipoMoeda\")),\n",
    "    #\"Convertido para Tabela\" = Record.ToTable(Fonte),\n",
    "    #\"Linhas Filtradas\" = Table.SelectRows(#\"Convertido para Tabela\", each ([Name] = \"value\")),\n",
    "    #\"Outras Colunas Removidas\" = Table.SelectColumns(#\"Linhas Filtradas\",{\"Value\"}),\n",
    "    #\"Value Expandido\" = Table.ExpandListColumn(#\"Outras Colunas Removidas\", \"Value\"),\n",
    "    #\"Value Expandido1\" = Table.ExpandRecordColumn(#\"Value Expandido\", \"Value\", {\"nomeFormatado\", \"simbolo\"}, {\"nomeFormatado\", \"simbolo\"}),\n",
    "    #\"Função Personalizada Invocada\" = Table.AddColumn(#\"Value Expandido1\", \"Consulta1 (2)\", each Moeda([simbolo])),\n",
    "    #\"Consulta1 (2) Expandido\" = Table.ExpandTableColumn(#\"Função Personalizada Invocada\", \"Consulta1 (2)\", {\"Value\"}, {\"Value\"}),\n",
    "    #\"Value Expandido2\" = Table.ExpandRecordColumn(#\"Consulta1 (2) Expandido\", \"Value\", {\"cotacaoCompra\", \"cotacaoVenda\", \"dataHoraCotacao\", \"tipoBoletim\"}, {\"cotacaoCompra\", \"cotacaoVenda\", \"dataHoraCotacao\", \"tipoBoletim\"}),\n",
    "    #\"Tipo Alterado\" = Table.TransformColumnTypes(#\"Value Expandido2\",{{\"nomeFormatado\", type text}, {\"simbolo\", type text}, {\"cotacaoCompra\", type number}, {\"cotacaoVenda\", type number}, {\"dataHoraCotacao\", type datetime}, {\"tipoBoletim\", type text}}),\n",
    "    #\"Data Extraída\" = Table.TransformColumns(#\"Tipo Alterado\",{{\"dataHoraCotacao\", DateTime.Date, type date}})\n",
    "in\n",
    "    #\"Data Extraída\""
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
