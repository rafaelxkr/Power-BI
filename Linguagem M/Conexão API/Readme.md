
# Como conectar dados pela web no Power BI

* ## API metodo Get 1° Metodo

```txt
link = "https://api.exemplo.com/api/integracao/v2/test?u=usuario&s=senha&init=01/02/2019&end=31/08/2019"
url = "https://api.exemplo.com/api/integracao/v2/test"
u=usuario
s=senha
init= data inicio
end= data fim
```

```pq
let
  Fonte = Json.Document(Web.Contents(
        "http://api.exemplo.com/api/integracao/v2/produtos",
         [ 
              Query =
              [
                    u = "xxxxxxx",
                    s = "xxxxxxxx",
                    init = "12/07/2019",
                    end = "31/12/2019"
              ]
        ]
))
in
  Fonte
```

* ## API metodo GET (com Header)

```pq
let
url = " http://api.exemplo.com/api/integracao/list",
body = "{""Usuario"": ""usuario"",""Senha"":""senha"",""Chave"":""""}",
Source = Json.Document(Web.Contents(url,[ 
Headers = [#"Content-Type"="application/json"],
Content = Text.ToBinary(body) 
] 
))
in
Source
```

* ## API metodo GET (com Header)
**!!!!!Ainda não foi validado**
```pq
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

```pq
let
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

* ### API metodo GET com Header Atualiazado na Web

```pq
let
url = "https://www.test.com",
Metodo = "/api/cpf/68958685621",
Token = "xxxxxxxxxxxxxxxxxx",
Content = "application/json",

Source = Json.Document(Web.Contents(url,[Headers=[#"Content-Type" = Content, Authorization = Token], RelativePath = Metodo] ))
```

* ### Curl -u **usuario:senha http://api.somesite.com**

```pq
let
url = "http://api.somesite.com/test",
Relative_Path = "?something=123",
Usuario_Senha = "username:password"
Senha_Encode = "Basic "& Binary.ToText(Text.ToBinary(Usuario_Senha,BinaryEncoding.Base64))
Source = Json.Document(Web.Contents(url,[Headers=[#"Authorization" = Senha_Encode], RelativePath = Relative_Path] ))
in
Source
```

## Lista de Contents (Tipos de Conteúdo do Body da API)
```
Json: Content = "application/json"
Xml : Content = "application/xml"
Html: Content = "text/html"
TXT : Content = "Text/plain"
```
