```m
// usuario@dominio.onmicrosoft.com
//Extraindo todas as planilhas da pasta Produtos/2019
let
Fonte = SharePoint.Files("https://dominio-my.sharepoint.com/personal/usuario_dominio_onmicrosoft_com", [ApiVersion = 15]), //Local da pasta com os arquivos XLS
Navegacao = Fonte{0}[Content],
Amostra = Navegacao meta [IsParameterQuery=true, BinaryIdentifier=Navegacao, Type="Binary", IsParameterQueryRequired=true], //configurando a Extração

    Extracao = (Amostra) => let //Função da Extração dos dados
        Fonte1 = Excel.Workbook(Amostra, null, true), //Abrindo como Excel utilizando dados da configuração
        Planilha = Fonte1{[Item="Planilha1",Kind="Sheet"]}[Data], //selecionando somente a Planilha1 de cada arquivo
        Filtro = Table.SelectRows(Planilha, each ([Column1] <> null)),
        PromoverCabecalho = Table.PromoteHeaders(Filtro, [PromoteAllScalars=true])
    in
        PromoverCabecalho,
    ArquivosOcultosFiltrados = Table.SelectRows(Fonte, each [Attributes]?[Hidden]? <> true),
    #"Linhas Filtradas" = Table.SelectRows(ArquivosOcultosFiltrados, each Text.Contains([Folder Path], "Produtos/2019")), // Filtra arquivos ocultos
    InvocarFunçãoPersonalizada = Table.AddColumn(#"Linhas Filtradas", "Relatorio", each  Extracao([Content])), //Aplica a Função Extracao em cada arquivo
    OutrasColunasRemovidas = Table.SelectColumns(InvocarFunçãoPersonalizada,{"Relatorio"}), //Remove outras colunas deixando somente a coluna da tabela
in
    OutrasColunasRemovidas
```
