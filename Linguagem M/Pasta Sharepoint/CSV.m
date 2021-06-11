
let
    Fonte = SharePoint.Files("https://{Dominio}.sharepoint.com/sites/GestoPneu", [ApiVersion = 15]),
    Filtro = Table.SelectRows(Fonte, each Text.Contains([Folder Path], "/OM/KSB1/")), //filtrar a pasta
    CSV = Table.TransformColumns(Filtro[[Content]],{"Content", each Csv.Document(_,[Delimiter=";", Encoding=1252, QuoteStyle=QuoteStyle.None])}), //Abre arquivo CSV
    Expandir = Table.ExpandTableColumn(Excel,"Content", Table.ColumnNames(Cabecalho{0}[Content])),//expandir as colunas
    Tipo =  Table.TransformColumnTypes(Expandir, List.Zip({Table.ColumnNames(Expandir),List.Repeat({type text},Table.ColumnCount(Expandir))}))//alterar tipo para texto 
in
    Tipo
