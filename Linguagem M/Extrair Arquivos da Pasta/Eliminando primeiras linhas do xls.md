## Código de Extração de Arquivos XLS em Unica Query

```m
let
Fonte = Folder.Files("C:\Users\Rafael\Desktop\Rafael\Freelancer\Projeto Educação\SIAFE"), //Local da pasta com os arquivos XLS
Navegacao = Fonte{0}[Content],
Amostra = Navegacao meta [IsParameterQuery=true, BinaryIdentifier=Navegacao, Type="Binary", IsParameterQueryRequired=true], //configurando a Extração

    Extracao = (Amostra) => let //Função da Extração dos dados
        Fonte1 = Excel.Workbook(Amostra, null, true), //Abrindo como Excel utilizando dados da configuração
        Planilha = Fonte1{[Name="Planilha 1"]}[Data] //selecionando somente a Planilha1 de cada arquivo
    in
        Planilha,
         Fonte2 = Folder.Files("C:\Users\Rafael\Desktop\Rafael\Freelancer\Projeto Educação\SIAFE"), //Local da pasta com os arquivos XLS
    #"Arquivos Ocultos Filtrados1" = Table.SelectRows(Fonte2, each [Attributes]?[Hidden]? <> true), // Filtra arquivos ocultos
    #"Invocar Função Personalizada1" = Table.AddColumn(#"Arquivos Ocultos Filtrados1", "Transformar Arquivo de SIAFE (2)", each  Extracao([Content])), //Aplica a Função Extracao em cada arquivo
    #"Personalização Adicionada" = Table.AddColumn(#"Invocar Função Personalizada1", "Relatorio", each Table.Skip([#"Transformar Arquivo de SIAFE (2)"],4)),//Elimina as 4 primeiras linhas de cada tabela
    #"Outras Colunas Removidas1" = Table.SelectColumns(#"Personalização Adicionada",{"Relatorio"}), //Remove outras colunas deixando somente a coluna da tabela
    PromoverCabecalho = Table.TransformColumns(#"Outras Colunas Removidas1",{"Relatorio", Table.PromoteHeaders}) //Adiciona cabeçalho em cada tabela
in
     PromoverCabecalho
```
