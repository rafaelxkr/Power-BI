### Token

``` m 
let
    url= "http://api.ideris.com.br/Login",
    Header = [#"Content-Type"  = "application/json"],
    Body =  Json.FromValue([login_token =  "263e13cd8a5c0afc9aa9dcb08cd6e4ce5ae70f869db80f3886e0b002d0675f5dc72b6da3d98c33f0dfbb29d47c52039b"]),
    Payload = [Headers = Header, Content = Body],
    Source = Json.Document(Web.Contents(url, Payload))
in
    Source
```

### fxLista_Pedidos

``` m
let

    Relative = (Offset as any)=>
    let
        url= "http://api.ideris.com.br/ListaPedido",
        Header = [#"Content-Type"  = "application/json", Authorization = Token],
        Parametros = [offset = Text.From(Offset), dataInicial = "2021-08-15T00:00:00-03:00", datafinal = "2021-08-20T23:59:59-03:00"] ,
        Payload = [Headers = Header, Query = Parametros],

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
                    actualResult = if status = 429 or status = 522 then null else buffered
                in
                    actualResult,
            (i) => #duration(0, 0, 0, i*10))
            
    in
        Json.Document(Web.ContentsCustomRetry(url, Payload),65001)
in
    Relative
```

### Lista_Pedidos (Retorna as primeiras 200 linhas)

``` m
let
    Limite = fxLista_Pedidos(0)[paging][total],
    Fonte = 
    List.Generate(
        () => [Request = fxLista_Pedidos(f)[result] , f = 0],
        each  [f] < 200, //100, 
        each  [Request =  fxLista_Pedidos([f])[result],  f = [f] +50],
        each  [Request]
  ),
    Tabela = Table.FromList(Fonte, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Lista_para_Record = Table.ExpandListColumn(Tabela, "Column1"),
    Expandir = Table.ExpandRecordColumn(Lista_para_Record, "Column1", {"id", "codigo", "marketplace", "idAutenticacaoIderis", "idContaMarketplace", "nomeContaMarketplace", "documentoRemetente", "status", "data", "codigoCarrinhoCompras", "imagemPedidoItem", "intermediadorNome", "intermediadorCnpj"}, {"id", "codigo", "marketplace", "idAutenticacaoIderis", "idContaMarketplace", "nomeContaMarketplace", "documentoRemetente", "status", "data", "codigoCarrinhoCompras", "imagemPedidoItem", "intermediadorNome", "intermediadorCnpj"}),
    Tipo = Table.TransformColumnTypes(Expandir,{{"id", Int64.Type}, {"codigo", type text}, {"marketplace", type text}, {"idAutenticacaoIderis", Int64.Type}, {"idContaMarketplace", type text}, {"nomeContaMarketplace", type text}, {"documentoRemetente", type any}, {"status", type text}, {"data", type datetimezone}, {"codigoCarrinhoCompras", Int64.Type}, {"imagemPedidoItem", type text}, {"intermediadorNome", type text}, {"intermediadorCnpj", Int64.Type}})
in
    Tipo
```

### Lista_Pedidos_V2 (Retorna todas linhas)
``` m
let
    Limite = fxLista_Pedidos(0)[paging][total],
    Fonte = 
    List.Generate(
        () => [Request = fxLista_Pedidos(f)[result] , f = 0],
        each  [f] <= Limite, 
        each  [Request =  fxLista_Pedidos([f])[result],  f = [f] +50],
        each  [Request]
  ),
    Tabela = Table.FromList(Fonte, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Lista_para_Record = Table.ExpandListColumn(Tabela, "Column1"),
    Expandir = Table.ExpandRecordColumn(Lista_para_Record, "Column1", {"id", "codigo", "marketplace", "idAutenticacaoIderis", "idContaMarketplace", "nomeContaMarketplace", "documentoRemetente", "status", "data", "codigoCarrinhoCompras", "imagemPedidoItem", "intermediadorNome", "intermediadorCnpj"}, {"id", "codigo", "marketplace", "idAutenticacaoIderis", "idContaMarketplace", "nomeContaMarketplace", "documentoRemetente", "status", "data", "codigoCarrinhoCompras", "imagemPedidoItem", "intermediadorNome", "intermediadorCnpj"}),
    Tipo = Table.TransformColumnTypes(Expandir,{{"id", Int64.Type}, {"codigo", type text}, {"marketplace", type text}, {"idAutenticacaoIderis", Int64.Type}, {"idContaMarketplace", type text}, {"nomeContaMarketplace", type text}, {"documentoRemetente", type any}, {"status", type text}, {"data", type datetimezone}, {"codigoCarrinhoCompras", Int64.Type}, {"imagemPedidoItem", type text}, {"intermediadorNome", type text}, {"intermediadorCnpj", Int64.Type}})
in
    Tipo
```
