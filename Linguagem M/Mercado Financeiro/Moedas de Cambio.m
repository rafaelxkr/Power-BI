let

    Moeda = (CodMoeda as text) =>
 
let
    Source = Json.Document(Web.Contents("https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/",//olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@moeda='"&CodMoeda&"'&@dataInicial='01-01-2000'&@dataFinalCotacao='12-31-9999'&$top=10000&$filter=tipoBoletim%20eq%20'Fechamento'&$orderby=dataHoraCotacao%20desc&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim")),
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
