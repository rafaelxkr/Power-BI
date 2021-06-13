let
    Fonte = Json.Document(Web.Contents("https://api.bcb.gov.br/dados/serie/bcdata.sgs.4189/dados?formato=json")),
    #"Convertido para Tabela" = Table.FromList(Fonte, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 Expandido" = Table.ExpandRecordColumn(#"Convertido para Tabela", "Column1", {"data", "valor"}, {"data", "valor"}),
    #"Tipo Alterado com Localidade" = Table.TransformColumnTypes(#"Column1 Expandido", {{"valor", type number}}, "en-US"),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Tipo Alterado com Localidade",{{"data", type date}}),
    #"Linhas Invertidas" = Table.ReverseRows(#"Tipo Alterado"),
    #"Coluna dividida" = Table.TransformColumns(#"Linhas Invertidas", {{"valor", each _ / 100, type number}})
in
    #"Coluna dividida"
