# Converter DataStamp (ms)em Data

```m
#"Data Analisada Inserida" = Table.AddColumn(#"Column1.Avaliacoes Expandido1", 
"MDataNotificacaoMASP", each Date.AddDays(Date.FromText("1970-01-01"), 
Number.RoundDown(Number.FromText(Text.Middle([Column1.DataNotificacaoMASP],6,13))/1000/86400)))
```

# Substituir Valores da Coluna com uma Função

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
= Table.ReplaceValue(#"Changed Type",each [Status],
each Função([Status]),Replacer.ReplaceText,{"Status"})
```

# Substituir Valores da Coluna com Condicional

```m
= Table.ReplaceValue(#"Changed Type",each [Status],
each if [Status] = 5 then "compra" else "venda",Replacer.ReplaceText,{"Status"})
```
