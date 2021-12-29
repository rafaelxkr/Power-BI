let
    Trajeto = (Origins as text, Destinations as text)=>
let
    Fonte = Json.Document(Web.Contents("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins="&Origins&"&destinations="&Destinations&"&mode=driving&key="&{Chave da API})),
    #"Convertido para Tabela" = Record.ToTable(Fonte),
    #"Tabela Transposta" = Table.Transpose(#"Convertido para Tabela"),
    #"Cabeçalhos Promovidos" = Table.PromoteHeaders(#"Tabela Transposta", [PromoteAllScalars=true]),
    #"destination_addresses Expandido" = Table.ExpandListColumn(#"Cabeçalhos Promovidos", "destination_addresses"),
    #"origin_addresses Expandido" = Table.ExpandListColumn(#"destination_addresses Expandido", "origin_addresses"),
    #"rows Expandido" = Table.ExpandListColumn(#"origin_addresses Expandido", "rows"),
    #"rows Expandido1" = Table.ExpandRecordColumn(#"rows Expandido", "rows", {"elements"}, {"elements"}),
    #"elements Expandido" = Table.ExpandListColumn(#"rows Expandido1", "elements"),
    #"elements Expandido1" = Table.ExpandRecordColumn(#"elements Expandido", "elements", {"distance", "duration", "status"}, {"elements.distance", "elements.duration", "elements.status"}),
    #"elements.distance Expandido" = Table.ExpandRecordColumn(#"elements Expandido1", "elements.distance", {"text", "value"}, {"Distancia.text", "Distancia(metros)"}),
    #"elements.duration Expandido" = Table.ExpandRecordColumn(#"elements.distance Expandido", "elements.duration", {"text", "value"}, {"Tempo.text", "Tempo(segundos)"}),
    #"Colunas Removidas" = Table.RemoveColumns(#"elements.duration Expandido",{"elements.status", "status"})
in
    #"Colunas Removidas",
    Fonte = Excel.Workbook(Web.Contents("https://docs.google.com/spreadsheets/d/e/2PACX-1vRqOXwutrWujll5icAp0cjps1t-vShQrY4Bxf788Xclz8JrK8lCwM9NF4wCcylaMOtLQ05KFlk5mYgg/pub?output=xlsx"), null, true),
    Página1_Sheet = Fonte{[Item="Página1",Kind="Sheet"]}[Data],
    #"Cabeçalhos Promovidos" = Table.PromoteHeaders(Página1_Sheet, [PromoteAllScalars=true]),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Cabeçalhos Promovidos",{{"Origem", type text}, {"Destino", type text}}),
    #"Personalização Adicionada" = Table.AddColumn(#"Tipo Alterado", "Personalizado", each Trajeto([Origem],[Destino])),
    #"Personalizado Expandido" = Table.ExpandTableColumn(#"Personalização Adicionada", "Personalizado", {"destination_addresses", "origin_addresses", "Distancia.text", "Distancia(metros)", "Tempo.text", "Tempo(segundos)"}, {"destination_addresses", "origin_addresses", "Distancia.text", "Distancia(metros)", "Tempo.text", "Tempo(segundos)"})
in
    #"Personalizado Expandido"
