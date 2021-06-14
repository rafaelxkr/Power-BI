
let
    Fonte = SharePoint.Files("https://{Nome_do_Dominio}.sharepoint.com/sites/GestoPneu", [ApiVersion = 15]),
    Filtro = Table.SelectRows(Fonte, each Text.Contains([Folder Path], "/Exemplos/Abrir arquivo ZIP/")), //filtrar a pasta
    CSV = Table.TransformColumns(Filtro[[Content]],{"Content", each Table.PromoteHeaders(Csv.Document(_,[Delimiter=",", Encoding=1252, QuoteStyle=QuoteStyle.None]))), //Abre arquivo CSV
    Expandir = Table.ExpandTableColumn(CSV,"Content", Table.ColumnNames(Cabecalho{0}[Content])),//expandir as colunas
    Tipo =  Table.TransformColumnTypes(Expandir, List.Zip({Table.ColumnNames(Expandir),List.Repeat({type text},Table.ColumnCount(Expandir))}))//alterar tipo para texto 
in
    Tipo
