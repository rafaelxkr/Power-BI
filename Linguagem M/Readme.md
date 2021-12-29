# Formulas em Linguagem M

## Conector SQL (correção de Erro)

Caso ocorra o erro abaixo, basta iniciar o Power BI com Admnistrador e se conecte novamente que resolve:<br>
Fonte: https://natechamberlain.com/2019/02/12/power-bi-refresh-error-could-not-load-file-or-assembly-provided-impersonation-level-is-invalid/

![image](https://user-images.githubusercontent.com/31570331/131003571-c7c878d7-8191-43d0-b02d-0131e8141dac.png)

## Transformando uma coluna com base em outra
Tem o mesmo objetivo que Table.TransformColumns, mas nesse caso
pode utilizar outras colunas para criar sua regra

```m
let
    Tabela = Table.FromRecords(
      {[Column A = "X",Column B = "1"],[Column A = "Y",Column B = "2"]},//Linhas da Tabela
      type table [Column A = text,Column B = text] // Tipagem das colunas
),
    Custom1 = 
      Table.FromRecords(Table.TransformRows(Tabela,
        (r) => Record.TransformFields(r,
              {"Column A", each if r[Column B]="1" then "Z" else _})),
      type table [Column A = text,Column B = text,Column C = text]
      )
in
    Custom1
```

## Table.FromList vs Table.FromRecords

Lista de Records (utilizado em API's em Json)
O 3º argumento da função Table.FromList seleciona as colunas e determina o tipo delas
* É necessário utilizar as colunas na mesma ordem, mas é possivel ignorar as ultimas colunas

### Um arquivo: (Table.FromList)
Na etapa "Expandir" precisamos identificar as colunas na mesma ordem que esta no Json da esquerda para direita 
```m
let
  Source = Json.Document(File.Contents("C:\Users\rafae\OneDrive - Dataside\Documentos\Power BI\Performance\Conexão Json\Base Json\generated.json")),
  Expandir = Table.FromList(Source, 
    Record.FieldValues, type table [_id  = text,index = Int32.Type,guid = text, isActive = logical,balance = text], 
    null, ExtraValues.Ignore
  )
in
  Expandir
```

### Vários arquivos: (Table.FromList)
Na etapa "Expandir" precisamos identificar as colunas na mesma ordem que esta no Json da esquerda para direita 
```m
let
    Source = Folder.Files("C:\Users\rafae\OneDrive\Documentos\Power BI\Performance\Conexão Json\Base Json"),
    Json = List.Transform(Source[Content], each Json.Document(_)),
    Expandir = Table.FromList(List.Combine(Json), Record.FieldValues, type table[_id = text, index = Int32.Type, isActive = logical, balance = text], null, ExtraValues.Ignore)
in
    Expandir
```

### Um arquivo: (Table.FromRecords)
Na etapa "Expandir" expadimos somente as colunas que desejamos e já tipamos cada coluna na mesma etapa
```m
let
  Source = Json.Document(File.Contents("C:\Users\rafae\OneDrive - Dataside\Documentos\Power BI\Performance\Conexão Json\Base Json\generated.json")),
  Expandir = Table.FromRecords(Json,type table [_id = text, index= Int64.Type, guid = text, balance = Currency.Type])
in
  Expandir
```

### Vários arquivos: (Table.FromRecords)
Na etapa "Expandir" expadimos somente as colunas que desejamos e já tipamos cada coluna na mesma etapa
```m
let
    Source = Folder.Files("C:\Users\rafae\OneDrive - Dataside\Documentos\Power BI\Performance\Conexão Json\Base Json"),
    Json = List.Combine(List.Transform(Source[Content], each Json.Document(_))),
    Expandir = Table.FromRecords(Json,type table [_id = text, index= Int64.Type, guid = text, balance = Currency.Type])
in
    Expandir
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

## Substituir Valores com Tabela "DE PARA"
```m
let
    Table = Table.FromRecords(
        {
        [FROM = "Rafael", TO = "Rafa"], //Linha 1
        [FROM = "Ana", TO = "Carolina"] //Linha 2
        },
        type table [FROM = text, TO = text]
    ),
    List = List.Zip({Table[FROM],Table[TO]}), //Lista da tabela "DE PARA"
    Replace = List.ReplaceMatchingItems({"Rafael", "Ana", "Eduardo", "Mauricio", "Carlos"},List)
    // Substituir com base na lista
in
    Replace
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

## Substituir Valores da Coluna com base em uma coluna de ID

```m
//faça uma consulta nula com lista de todos os itens
let
  Query = (ID , Replace_Column) =>
let
values = {
  // { ID , Replace_Column }
{"4538400X","334"},
{"4550200X","A33"},
{ID, Replace_Column}
},
Result = List.First(List.Select(values, each _{0}=ID)){1}
in
Result
in
  Query
  
// ID é a coluna que contém a chave para identificar qual linha deve ser substituido o valor
// Replace_Column é o nome da coluna que será feita a substituição dos valores

// -- Abaixo é a etapa que ser inserida na sua consulta onde é chamado  função acima com o nome de Funtion, 
//= Table.ReplaceValue(#"Changed Type",each [Nome_Replace_Column], each Funtion([Nome_Coluna_ID],[Nome_Replace_Column]),Replacer.ReplaceText,{"Nome_Replace_Column"})
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

## Função para remover ascentos

```m
(Texto as text) =>
let
    ListaAcentos = 
		{
		{"à","a"},
		{"á","a"},
		{"â","a"},
		{"ã","a"},
		{"ä","a"},
		{"è","e"},
		{"é","e"},
		{"ê","e"},
		{"ë","e"},
		{"ì","i"},
		{"í","i"},
		{"î","i"},
		{"ï","i"},
		{"ò","o"},
		{"ó","o"},
		{"ô","o"},
		{"õ","o"},
		{"ö","o"},
		{"ù","u"},
		{"ú","u"},
		{"û","u"},
		{"ü","u"},
		{"À","A"},
		{"Á","A"},
		{"Â","A"},
		{"Ã","A"},
		{"Ä","A"},
		{"È","E"},
		{"É","E"},
		{"Ê","E"},
		{"Ë","E"},
		{"Ì","I"},
		{"Í","I"},
		{"Î","I"},
		{"Ò","O"},
		{"Ó","O"},
		{"Ô","O"},
		{"Õ","O"},
		{"Ö","O"},
		{"Ù","U"},
		{"Ú","U"},
		{"Û","U"},
		{"Ü","U"},
		{"ç","c"},
		{"Ç","C"},
		{"ñ","n"},
		{"Ñ","N"}
		}
in
    Text.Combine(List.ReplaceMatchingItems(Text.ToList(Texto), ListaAcentos))
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
