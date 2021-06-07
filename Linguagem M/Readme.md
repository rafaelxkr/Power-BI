# Formulas em Linguagem M

## Table.FromList

Lista de Records
```m
Table.FromList(
    Source, //Tabela
    Record.FieldValues, //Separar lista pelos valores dos records
    {"_id", "index", "guid", "isActive", "balance"}, //Seleciona as colunas desejadas
    null, 
    ExtraValues.Ignore //Ignora as colunas não desejadas
  )
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
