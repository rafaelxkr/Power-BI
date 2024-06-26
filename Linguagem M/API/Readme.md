
# Como conectar dados pela web no Power BI

* ## API metodo GET 

link: `https://api.mercadolibre.com/sites/MLB/categories`
```m
let
    url = "https://api.mercadolibre.com/sites/MLB/categories",
    Source = Json.Document(Web.Contents(url), 65001),
    Expandir = Table.FromList(Source,Record.FieldValues, type table [id=text,  name=text], null, ExtraValues.Ignore)
in
    Expandir
```

* ## API metodo Get 1° Metodo com parametros

```txt
link = "https://api.exemplo.com/api/integracao/v2/test?u=usuario&s=senha&init=01/02/2019&end=31/08/2019"
url = "https://api.exemplo.com/api/integracao/v2/test"

u=usuario
s=senha
init= data inicio
end= data fim
```

```m
let
  url = "http://api.exemplo.com/api/integracao/v2/produtos",
  Parametros = 
  [
	u = "xxxxxxx",
	s = "xxxxxxxx",
	init = "12/07/2019",
	end = "31/12/2019"
  ],
  Instrucoes = [ Query = Parametro ],
  Fonte = Json.Document(Web.Contents(url,Instrucoes))
in
  Fonte
```

* ## API metodo GET (com Header)

```m
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

Exemplo 2:

EndPoint: `"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/"`

GET: `"CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)"`
```
Parametros:
@moeda = 'USD'
@dataInicial" = '01-01-2000',
@dataFinalCotacao= '12-31-9999',
$top= 10000,
$filter= not contains(tipoBoletim,'Inter'),
$orderby= dataHoraCotacao desc,
$format = json,
$select= cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"
```

```m
let
    url = "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/",
    Relative = "CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)",
    Parametros = 
    [
        #"@moeda" = "'USD'",
        #"@dataInicial" ="'01-01-2000'",
        #"@dataFinalCotacao"="'12-31-9999'",
        #"$top"= "10000",
        #"$filter"= "not contains(tipoBoletim,'Inter')",
        #"$orderby"= "dataHoraCotacao desc",
        #"$format" = "json",
        #"$select"= "cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"
    ],
    Instrucoes = [RelativePath = Relative, Query = Parametros],
    Source = Json.Document(Web.Contents(url,Instrucoes), 1252),
    value = Source[value],
    Expandir = Table.FromList(value, Record.FieldValues,type table [Compra = Currency.Type, Venda = Currency.Type, Data = datetime, Tipo = text ], null, ExtraValues.Error),
    Tipo = Table.TransformColumnTypes(Expandir,{{"Data", type datetime}})
in
    Tipo
```

* ## API metodo GET (com Header)
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
* ## API Dinamica metodo GET

```m
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

* ## API metodo GET com Header Atualiazado na Web

```m
let
url = "https://www.test.com",
Metodo = "/api/cpf/68958685621",
Token = "xxxxxxxxxxxxxxxxxx",
Content = "application/json",

Source = Json.Document(Web.Contents(url,[Headers=[#"Content-Type" = Content, Authorization = Token], RelativePath = Metodo] ))
```

* ## Curl -u **usuario:senha http://api.somesite.com**

```m
let
url = "http://api.somesite.com/test",
Relative_Path = "?something=123",
Usuario_Senha = "username:password"
Senha_Encode = "Basic "& Binary.ToText(Text.ToBinary(Usuario_Senha,BinaryEncoding.Base64))
Source = Json.Document(Web.Contents(url,[Headers=[#"Authorization" = Senha_Encode], RelativePath = Relative_Path] ))
in
Source
```

* ## Paginando com List Generate

1° Parte - Função para extrair as informações do site colocar o nome como Paginas
```m
(Pagina as number) =>
let
    Source = Web.BrowserContents("https://www.teste.com/discussions/test/"&Text.From(Pagina)&"/"),
    Html = Html.Table(Source, {{"Topico", ".discussion-link"}, {"Link", ".discussion-link", each [Attributes][href]?}}, [RowSelector=".discussion-row"]),
    Separar = Table.SplitColumn(Html, "Topico", Splitter.SplitTextByAnyDelimiter({"topic","question","discussion"}, QuoteStyle.Csv), {"Exame", "Topico", "Questao"}),
    Link = Table.TransformColumns(Separar, {{"Link", each "https://www.examtopics.com" & _, type text}})
in
    try Link otherwise null
```

2° Parte - Query para paginar o site e trazer todas as paginas cada pagina tem um numero
onde deve iniciar do numero 1 e vai acumulando quando a função "Paginas" não retornar uma tabela o List.Genarate
irá parar, para essa aplicação não precisa saber a quantidade maxima de paginas que o site tem

```m
let
    Lista = List.Generate(
        ()=> [retorno = Paginas(1), i = 1],
        each [retorno] is table,
        each [retorno = Paginas ([i]+1), i = [i]+1],
        each [retorno]
    ),
    Resultado  = Table.Combine(Lista)

 in
    Resultado
```

* ## API com limitação de chamadas por minuto

Fonte: https://gist.github.com/CurtHagenlocher/68ac18caa0a17667c805
```m
let
    Value.WaitFor = (producer as function, interval as function, optional count as number) as any =>
        let
            list = List.Generate(
                () => {0, null},
                (state) => state{0} <> null and (count = null or state{0} < count),
                (state) => if state{1} <> null
                    then {null, state{1}}
                    else {1 + state{0}, Function.InvokeAfter(() => producer(state{0}), interval(state{0}))},
                (state) => state{1})
        in
            List.Last(list),
    Web.ContentsCustomRetry = (url as text, optional options as record) => Value.WaitFor(
        (i) =>
            let
                options2 = if options = null then [] else options,
                options3 = if i=0 then options2 else options2 & [IsRetry=true],
                result = Web.Contents(url, options3 & [ManualStatusHandling={429}]),
                buffered = Binary.Buffer(result), /* avoid risk of double request */
                status = if buffered = null then 0 else Value.Metadata(result)[Response.Status],
                actualResult = if status = 429 then null else buffered
            in
                actualResult,
        (i) => #duration(0, 0, 0, i*0.1))
in
    Web.ContentsCustomRetry("http://www.bing.com")
```

## Lista de Contents (Tipos de Conteúdo do Body da API)
```
Json: Content = "application/json"
Xml : Content = "application/xml"
Html: Content = "text/html"
TXT : Content = "Text/plain"
```
