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
    #"Relatorio Expandido" = Table.ExpandTableColumn(OutrasColunasRemovidas, "Relatorio", {"Data de Inclusão", "% ", "Leilao", "Lote", "Id", "Categoria", "Subcategoria", "Marca", "Modelo", "Valor Mínimo", "Valor Condicional/Venda", "Valor a pagar", "Canal", "Cliente Email", "Nome Comprador", "CPF  Comprador", "Endereço  Comprador", "Telefone  Comprador", "Status", "Nome Vendedor", "CPF  Vendedor", "Endereço  Vendedor", "Email  Vendedor"}, {"Data de Inclusão", "% ", "Leilao", "Lote", "Id", "Categoria", "Subcategoria", "Marca", "Modelo", "Valor Mínimo", "Valor Condicional/Venda", "Valor a pagar", "Canal", "Cliente Email", "Nome Comprador", "CPF  Comprador", "Endereço  Comprador", "Telefone  Comprador", "Status", "Nome Vendedor", "CPF  Vendedor", "Endereço  Vendedor", "Email  Vendedor"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Relatorio Expandido",{{"Data de Inclusão", type date}, {"% ", type number}, {"Leilao", type text}, {"Lote", type text}, {"Id", type text}, {"Categoria", type text}, {"Subcategoria", type text}, {"Marca", type text}, {"Modelo", type text}, {"Valor Mínimo", Int64.Type}, {"Valor Condicional/Venda", Int64.Type}, {"Valor a pagar", type number}, {"Canal", type text}, {"Cliente Email", type text}, {"Nome Comprador", type text}, {"CPF  Comprador", type text}, {"Endereço  Comprador", type text}, {"Telefone  Comprador", type text}, {"Status", type text}, {"Nome Vendedor", type text}, {"CPF  Vendedor", type text}, {"Endereço  Vendedor", type any}, {"Email  Vendedor", type text}}),
    #"Personalização Adicionada" = Table.AddColumn(#"Tipo Alterado", "Chave", each [Leilao]&"_"&[Lote], type text)
in
    #"Personalização Adicionada"
```
