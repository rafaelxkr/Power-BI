# API do IBGE

link: https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-municipiosGet

## Lista de Municipios (Região Imediata)

```m
let
    Source = Json.Document(Web.Contents("https://servicodados.ibge.gov.br/api/v1/localidades/municipios")),
    Expandir = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Ignore),
    Expandir1 = Table.ExpandRecordColumn(Expandir, "Column1", {"regiao-imediata"}, {"regiao-imediata"}),
    Expandir2 = Table.ExpandRecordColumn(Table.Distinct(Expandir1), "regiao-imediata", {"id", "nome", "regiao-intermediaria"}, {"Municipio.id", "Municipio.nome", "regiao-intermediaria"}),
    Expandir3 = Table.ExpandRecordColumn(Expandir2, "regiao-intermediaria", {"id", "nome", "UF"}, {"regiao-intermediaria.id", "regiao-intermediaria.nome", "UF"}),
    Expandir4 = Table.ExpandRecordColumn(Expandir3, "UF", {"id", "sigla", "nome", "regiao"}, {"UF.id", "UF.sigla", "UF.nome", "UF.regiao"}),
    Expandir5 = Table.ExpandRecordColumn(Expandir4, "UF.regiao", {"id", "sigla", "nome"}, {"regiao.id", "regiao.sigla", "regiao.nome"}),
    Tipo = Table.TransformColumnTypes(Expandir5,{{"Municipio.id", Int32.Type}, {"Municipio.nome", type text}, {"regiao-intermediaria.id", Int16.Type}, {"regiao-intermediaria.nome", type text}, {"UF.id", Int8.Type}, {"UF.sigla", type text}, {"UF.nome", type text}, {"regiao.id", Int8.Type}, {"regiao.sigla", type text}, {"regiao.nome", type text}})
in
    Tipo
```
