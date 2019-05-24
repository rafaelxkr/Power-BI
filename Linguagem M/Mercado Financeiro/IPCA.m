let
    Fonte = Json.Document(Web.Contents("http://api.sidra.ibge.gov.br/values/t/1419/n1/all/v/all/p/all/c315/7169,7170,7445,7486,7558,7625,7660,7712,7766,7786/d/v63%202,v66%204,v69%202,v2265%202?formato=json")),
    #"Convertido para Tabela" = Table.FromList(Fonte, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 Expandido" = Table.ExpandRecordColumn(#"Convertido para Tabela", "Column1", {"NC", "NN", "D1C", "D1N", "D2C", "D2N", "D3C", "D3N", "D4C", "D4N", "D5C", "D5N", "D6C", "D6N", "D7C", "D7N", "D8C", "D8N", "D9C", "D9N", "MC", "MN", "V"}, {"NC", "NN", "D1C", "D1N", "D2C", "D2N", "D3C", "D3N", "D4C", "D4N", "D5C", "D5N", "D6C", "D6N", "D7C", "D7N", "D8C", "D8N", "D9C", "D9N", "MC", "MN", "V"}),
    #"Outras Colunas Removidas" = Table.SelectColumns(#"Column1 Expandido",{"D1N", "D2N", "D3N", "D4N", "V"}),
    #"Cabeçalhos Promovidos" = Table.PromoteHeaders(#"Outras Colunas Removidas", [PromoteAllScalars=true]),
    #"Tipo Alterado com Localidade" = Table.TransformColumnTypes(#"Cabeçalhos Promovidos", {{"Valor", type number}}, "en-US"),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Tipo Alterado com Localidade",{{"Brasil", type text}, {"Variável", type text}, {"Mês", type date}, {"Geral, grupo, subgrupo, item e subitem", type text}}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Tipo Alterado",{{"Mês", "Data"}}),
    #"Erros Removidos" = Table.RemoveRowsWithErrors(#"Colunas Renomeadas", {"Valor"}),
    #"Coluna dividida" = Table.TransformColumns(#"Erros Removidos", {{"Valor", each _ / 100, type number}})
in
    #"Coluna dividida"
