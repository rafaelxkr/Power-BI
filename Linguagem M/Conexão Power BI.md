
# Como conectar dados pela web no Power BI

* ### API metodo Get
```m
Json.Document(Web.Contents("https://api.exemplo.com/api/integracao/v2/veiculos?u={usuario}&s={senha}&init=01/02/2019&end=31/08/2019"))u=usuario
s=senha
init= data inicio
end= data fim
* ### API metodo Post (com Header)
let
url = " http://api.exemplo.com/api/integracao/getveiculolist",
body = "{""Usuario"": ""usuario"",""Senha"":""senha"",""Chave"":""""}",
Source = Json.Document(Web.Contents(url,[ 
Headers = [#"Content-Type"="application/json"],
Content = Text.ToBinary(body) 
] 
))
in
Source
```

* ### API metodo Post (com Header)
 **!!!!!Ainda não foi validado**
```m
let
url = " https://api.vhsys.com/v2/contas-pagar",
body = "{""data_pagamento"": ""2019-03-01,2019-03-31"",""lixeira"":""Nao"",""Liquidado"":""Sim"",""limit"":""1000""}",
Source = Json.Document(Web.Contents(url,[ 
Headers = [
            #"access-token"="TOKEN",
            #"secret-acess-token"="SENHA",
            #"cache-control"="no-cache",
            #"Content-Type"="application/json"
            ],
Content = Text.ToBinary(body) 
] 
))
in
Source
```
* ### API Dinamica metodo GET

```m
    Moeda = (CodMoeda as text) =>
 
let
    Source = Json.Document(Web.Contents("https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/",
    [
        RelativePath= "CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@moeda='"&CodMoeda&"'&@dataInicial='01-01-2000'&@dataFinalCotacao='12-31-9999'&$top=10000&$filter=not%20contains(tipoBoletim%2C'Inter')&$orderby=dataHoraCotacao%20desc&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"
        ])),
    #"Convertido para Tabela" = Record.ToTable(Source),
    #"Linhas Filtradas" = Table.SelectRows(#"Convertido para Tabela", each ([Name] = "value")),
    #"Value Expandido" = Table.ExpandListColumn(#"Linhas Filtradas", "Value")
in
    #"Value Expandido",

    Fonte = Json.Document(Web.Contents("https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas?$top=100&$format=json&$select=simbolo,nomeFormatado,tipoMoeda")),
    #"Convertido para Tabela" = Record.ToTable(Fonte),
    #"Linhas Filtradas" = Table.SelectRows(#"Convertido para Tabela", each ([Name] = "value")),
    #"Outras Colunas Removidas" = Table.SelectColumns(#"Linhas Filtradas",{"Value"}),
    #"Value Expandido" = Table.ExpandListColumn(#"Outras Colunas Removidas", "Value"),
    #"Value Expandido1" = Table.ExpandRecordColumn(#"Value Expandido", "Value", {"nomeFormatado", "simbolo"}, {"nomeFormatado", "simbolo"}),
    #"Função Personalizada Invocada" = Table.AddColumn(#"Value Expandido1", "Consulta1 (2)", each Moeda([simbolo])),
    #"Consulta1 (2) Expandido" = Table.ExpandTableColumn(#"Função Personalizada Invocada", "Consulta1 (2)", {"Value"}, {"Value"}),
    #"Value Expandido2" = Table.ExpandRecordColumn(#"Consulta1 (2) Expandido", "Value", {"cotacaoCompra", "cotacaoVenda", "dataHoraCotacao", "tipoBoletim"}, {"cotacaoCompra", "cotacaoVenda", "dataHoraCotacao", "tipoBoletim"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Value Expandido2",{{"nomeFormatado", type text}, {"simbolo", type text}, {"cotacaoCompra", type number}, {"cotacaoVenda", type number}, {"dataHoraCotacao", type datetime}, {"tipoBoletim", type text}}),
    #"Data Extraída" = Table.TransformColumns(#"Tipo Alterado",{{"dataHoraCotacao", DateTime.Date, type date}})
in
    #"Data Extraída"
```

* ### API metodo GET com Header Atualiazando na Web

```m
let
url = "http://webapi5.provedor.space/api/viplote",
Parametro =  "/300419V/10",
body = "{""""}",
Source = Json.Document(Web.Contents(url&Parametro, [Headers=[#"Content-Type"="application/json", Authorization="bearer N-qMLj5QOmwKbQtuLl2nKssQPTD7030TxdgUCempZIlX7sPwLl0SHbesUX6M-6CdNWZQp96VZSP78Q9WGbYENsOoiX2uBURC-wRlCBfqxbcKEIU_F91S6JMdPbblvUME0PnhS056MylOMZ8qd-sycm0xnqKPCRu_1JHSpuvT4eMF3fyr8ydSG8zwjY5LbMFft7gbmAjogvflDcg6zqkB5aANBT0U6IUYxV-SizcJT4c"]])),
    #"Convertido para Tabela" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 Expandido" = Table.ExpandRecordColumn(#"Convertido para Tabela", "Column1", {"Leilao", "NumeroLote", "Modalidade", "DataLeilao", "TipoLeilao", "Exposto", "Filial", "StatusEstoque", "Comitente", "StatusFinanceiro", "StatusLote", "LanceMinimo", "CustasDeposito", "ValorMinimo"}, {"Column1.Leilao", "Column1.NumeroLote", "Column1.Modalidade", "Column1.DataLeilao", "Column1.TipoLeilao", "Column1.Exposto", "Column1.Filial", "Column1.StatusEstoque", "Column1.Comitente", "Column1.StatusFinanceiro", "Column1.StatusLote", "Column1.LanceMinimo", "Column1.CustasDeposito", "Column1.ValorMinimo"})
in
#"Column1 Expandido"
```
