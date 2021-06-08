let
    Fonte = SharePoint.Files("https://{Dominio}.sharepoint.com/sites/GestoPneu", [ApiVersion = 15]),
    Filtro = Table.SelectRows(Fonte, each Text.Contains([Folder Path], "/OM/KSB1/")), //filtrar a pasta
    Remover = Table.SelectColumns(Filtro,{"Content"}), // Manter somente a coluna "Content" 
    Excel = Table.TransformColumns(Remover,{"Content", each Excel.Workbook(_, true, true){[Kind = "Sheet"]}[Data]}),//Abre arquivo XLSX
    //Cabecalho = Table.TransformColumns(Excel,{"Content", Table.PromoteHeaders}),//1° Linha como Cabeçalho
    Expandir = Table.ExpandTableColumn(Excel,"Content", Table.ColumnNames(Cabecalho{0}[Content])),//expandir as colunas
    Tipo = Table.TransformColumnTypes(Expandir, List.Zip({Table.ColumnNames(Expandir),List.Repeat({type text},Table.ColumnCount(Expandir))}))//alterar tipo para texto 
in
    Tipo
