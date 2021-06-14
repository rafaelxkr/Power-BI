# Formulas em Linguagem M

## Table.FromList

Lista de Records (utilizado em API's em Json)
O 3º argumento da função Table.FromList seleciona as colunas e determina o tipo delas

Um arquivo:
```m
let
  Source = Json.Document(File.Contents("C:\Users\rafae\Downloads\generated.json")),
  Expandir = Table.FromList(Source, 
    Record.FieldValues, type table [_id  = text,index = Int32.Type,guid = text, isActive = logical,balance = text], 
    null, ExtraValues.Ignore
  )
in
  Expandir
```

Vários arquivos:
```m
let
    Source = Folder.Files("C:\Users\rafae\OneDrive\Documentos\Power BI\Performance\Conexão Json\Base Json"),
    Json = List.Transform(Source[Content], each Json.Document(_)),
    Expandir = Table.FromList(List.Combine(Json), Record.FieldValues, type table[_id = text, index = Int32.Type, isActive = logical, balance = text], null, ExtraValues.Ignore)
in
    Expandir
```

Vários não otimizado:
```m
let
    Source = Folder.Files("C:\Users\rafae\OneDrive\Documentos\Power BI\Performance\Conexão Json\Base Json"),
    Json = List.Transform(Source[Content], each Json.Document(_)),
    Tabela = Table.FromList(Json, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Expandir1 = Table.ExpandListColumn(Tabela, "Column1"),
    Expandir2 = Table.ExpandRecordColumn(Expandir1, "Column1", {"_id", "index", "isActive", "balance"}, {"_id", "index", "isActive", "balance"}),
    Tipo = Table.TransformColumnTypes(Expandir2,{{"_id", type text}, {"index", Int64.Type}, {"isActive", type logical}, {"balance", type text}})
in
    Tipo
```

## Selecionando Colunas

```m
Lista  = Tabela[Coluna] //Formato de lista
Tabela = Tabela[[Coluna]] //Formato de tabela
```

## Converter DataStamp (ms)em Data

```m
#"Data Analisada Inserida" = Table.AddColumn(#"Column1.Avaliacoes Expandido1", 
"MDataNotificacaoMASP", each Date.AddDays(Date.FromText("1970-01-01"), 
Number.RoundDown(Number.FromText(Text.Middle([Column1.DataNotificacaoMASP],6,13))/1000/86400)))
```

## Substituir Valores da Coluna com uma Função

```m
//faça uma consulta nula com lista de todos os itens
let
  Query = (input) =>
let
values = {
{"8", "venda"},
{"5", "Compra"},
{input, "Indefinido"}
},
Result = List.First(List.Select(values, each _{0}=input)){1}
in
Result
in
  Query
  
// use o codigo abaixo para substituir os valores conforme os listados na função
// Status é o nome da coluna que será feita a substituição dos valores e Fuction
// é a função feita acima

= Table.ReplaceValue(#"Changed Type",each [Status],
each Funtion([Status]),Replacer.ReplaceText,{"Status"})
```

## Substituir Valores da Coluna com Condicional

```m
= Table.ReplaceValue(#"Changed Type",each [Status],
each if [Status] = 5 then "compra" else "venda",Replacer.ReplaceText,{"Status"})
```

## Ultima data de Atualização

```m
= DateTime.From(DateTimeZone.SwitchZone(DateTimeZone.LocalNow(),-3))
// O -3 se refere ao Fuso Horário
```

## Manter Somente Caracteres Selecionados

```m
= Table.TransformColumns(Etapa_Anterior,{ "Nome_da_Coluna",each Text.Select(_,{"a".."f"}),type text})
```

## Validador de  CPF

|FUNÇÃO CRIADA POR DAVI MARTINS     |
|:---------------------------------:|
|Do Excel para Contabilidade        |
|Data: 04/06/2021                   |
|E-mail: evdaviicm3@gmail.com       |
-------------------------------------
  
Aplicação:

Tipos de Inputs de CPFs aceitos:
056.613.200-19
05661320019
5661320019

Coloque o nome da função como fnValidacaoCpf (ou como desejar)

fnValidacaoCpf([SuaColuna])

Exemplo:
fnValidacaoCpf("056.613.200-19")
Resultado= Válido

Exemplo2 com o segundo parametro opcional informado:
fnValidacaoCpf("056.613.200-10", true)
Resultado= Inválido| Possível: Inválido| Possível: 05661320019

Sem o segundo parametro opcional informado:
fnValidacaoCpf("056.613.200-10")
Resultado= Inválido
![image](https://user-images.githubusercontent.com/31570331/120860689-783f2780-c55c-11eb-8580-a35b41139118.png)

```m
(
    sCpf as any, 
    optional sMostrar as logical
)=>

let
    
    NumeroCpf = Text.Select(Text.From(sCpf), {"0".."9"}),
    CpfTratado = Text.Select(Number.ToText(Number.From(NumeroCpf), "000\.000\.000-00"), {"0".."9"}),
    ListaCpf = List.Transform(Text.ToList(Text.Start(CpfTratado,9)), each Number.From(_)),
    ListaPesos = List.Numbers(10, 9, -1 ),
    PosicoesCpf = List.Positions(ListaCpf),
    
    Verificador1 = 
    Currency.From(11 -
    (Number.Mod(
        List.Accumulate(PosicoesCpf, 0,(state,current)=> state + ListaCpf{current}*ListaPesos{current}) / 11, 1
        ) * 11 
    )),
    
    Resultado1 = if Verificador1 <= 9 then Currency.From(Verificador1) else 0,
    
    ListaCpf2 = List.InsertRange(ListaCpf,9, {Resultado1}),
    ListaPesos2 = List.Numbers(11, 10, -1 ),
    PosicoesCpf2 = List.Positions(ListaCpf2),
        
    Verificador2 = 
    Currency.From(11 -
    (Number.Mod(
        List.Accumulate(PosicoesCpf2, 0,(state,current)=> state + ListaCpf2{current}*ListaPesos2{current}) / 11, 1
        ) * 11 
    )),
    
    Resultado2 = if Currency.From(Verificador2) <= 9 then Currency.From(Verificador2) else 0,
    CpfValido = Text.Start(CpfTratado, 9) & Text.From(Resultado1) & Text.From(Resultado2),
    
    ValidacaoFinal = if CpfValido = CpfTratado then "Válido" else "Inválido"

in

if ValidacaoFinal = "Inválido" and sMostrar = true then
    ValidacaoFinal & "| Possível: " & CpfValido
else
    ValidacaoFinal
```
