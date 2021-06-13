## Código de Extração de Arquivos XLS em Unica Query

##Todos arquivos xls na pasta selecionada serão todos unidos

let
Fonte = Folder.Files("C:\Users\Rafael\Desktop\Rafael\Freelancer\Projeto Educação\SIAFE"), //Local da pasta com os arquivos XLS
Navegacao = Fonte{0}[Content],
Amostra = Navegacao meta [IsParameterQuery=true, BinaryIdentifier=Navegacao, Type="Binary", IsParameterQueryRequired=true], //configurando a Extração

    Extracao = (Amostra) => let //Função da Extração dos dados
        Fonte1 = Excel.Workbook(Amostra, null, true), //Abrindo como Excel utilizando dados da configuração
        Planilha = Fonte1{[Name="Planilha 1"]}[Data] //selecionando somente a Planilha1 de cada arquivo
    in
        Planilha,
    ArquivosOcultosFiltrados = Table.SelectRows(Fonte, each [Attributes]?[Hidden]? <> true), // Filtra arquivos ocultos
    InvocarFunçãoPersonalizada = Table.AddColumn(ArquivosOcultosFiltrados, "Transformar Arquivo de SIAFE (2)", each  Extracao([Content])), //Aplica a Função Extracao em cada arquivo
    PersonalizaçãoAdicionada = Table.AddColumn(InvocarFunçãoPersonalizada, "Relatorio", each Table.Skip([#"Transformar Arquivo de SIAFE (2)"],4)),//Elimina as 4 primeiras linhas de cada tabela
    OutrasColunasRemovidas = Table.SelectColumns(PersonalizaçãoAdicionada,{"Relatorio"}), //Remove outras colunas deixando somente a coluna da tabela
    PromoverCabecalho = Table.TransformColumns(OutrasColunasRemovidas,{"Relatorio", Table.PromoteHeaders}) //Adiciona cabeçalho em cada tabela
in
     PromoverCabecalho
