# Vacinação
link: https://opendatasus.saude.gov.br/dataset/covid-19-vacinacao/resource/ef3bd0b8-b605-474b-9ae5-c97390c197a8

### Conexão na base csv de vacinação

``` m
let
    Source = Table.PromoteHeaders(Csv.Document(Web.Contents("https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/PNI/vacina/completo/2021-06-17/part-00000-52da4f46-7e01-42fe-988b-059d4ebf1e5a-c000.csv"),[Delimiter=";", Columns=32, Encoding=65001, QuoteStyle=QuoteStyle.None])),
    Remover = Table.SelectColumns(Source,{"paciente_idade", "paciente_datanascimento", "paciente_enumsexobiologico", "paciente_racacor_codigo", "paciente_endereco_coibgemunicipio", "estabelecimento_valor", "estabelecimento_razaosocial", "estalecimento_nofantasia", "estabelecimento_municipio_codigo", "vacina_grupoatendimento_codigo", "vacina_grupoatendimento_nome", "vacina_categoria_codigo", "vacina_categoria_nome", "vacina_fabricante_nome", "vacina_dataaplicacao", "vacina_descricao_dose", "vacina_codigo", "vacina_nome", "sistema_origem"}),
    Tipo = Table.TransformColumnTypes(Remover,{{"paciente_datanascimento", type date}, {"paciente_racacor_codigo", Int8.Type}, {"paciente_endereco_coibgemunicipio", Int32.Type}, {"estabelecimento_valor", Int32.Type}, {"estabelecimento_municipio_codigo", Int32.Type}, {"vacina_grupoatendimento_codigo", Int32.Type}, {"vacina_categoria_codigo", Int8.Type}, {"vacina_dataaplicacao", type date}, {"vacina_codigo", Int16.Type}, {"paciente_idade", Int8.Type}})
in
    Tipo
```
Conexão pela API

```m
let
//--------------Função para paginar a API ------------------------------------------------------
    Fuction = (Proxima_Pag as text)  =>
    let
        url = "https://imunizacao-es.saude.gov.br",
        Relative = "_search/scroll",
        Acesso = "Basic "&Text.From(Text.ToBinary("imunizacao_public:qlto5t&7r_@+#Tlstigi",BinaryEncoding.Base64)),
        Body = Json.FromValue( 
        [
        scroll_id = Proxima_Pag,
        scroll = "1m"
        ]),
        Header = 
        [
            #"Content-type"="application/json",
            Authorization= Acesso
        ],
        Instrucoes = [RelativePath = Relative, Headers=Header, Content = Body, IsRetry = true],
        Fonte = Json.Document(Web.Contents(url, Instrucoes))
        
    in
        Record.ToList(Fonte),

//--------------Pagina1 da API (FIXA)  ------------------------------------------------------
    url = "https://imunizacao-es.saude.gov.br",
    Relative = "_search",
    Parametros = [scroll= "1m"],
    Body = Json.FromValue ([size = "10000"]),
    Header = 
    [
        #"Content-type"="application/json",
        Authorization="Basic aW11bml6YWNhb19wdWJsaWM6cWx0bzV0JjdyX0ArI1Rsc3RpZ2k="
    ],
    Instrucoes = [RelativePath = Relative, Query = Parametros, Headers=Header, Content = Body],
    Pagina1 = Record.ToList(Json.Document(Web.Contents(url, Instrucoes))),

//-------------- Paginador de API (10.000 linhas por página) ------------------------------------------------------
    Lista = List.Generate(
        ()=> [retorno = List.InsertRange(Pagina1,4,{""}), i = Pagina1{0}, f = 1],
        each [f] <= 5 ,  //Quantidade de páginas para ser retornado
        each [retorno = Fuction([i]), i = ([retorno]{0}), f = [f]+1 ],
        each [retorno]{5}[hits]
    ),
    Tabela = Table.FromList(Lista, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Expandir1 = Table.ExpandListColumn(Tabela, "Column1"),
    Expandir2 = Table.ExpandRecordColumn(Expandir1, "Column1", {"_index", "_type", "_id", "_score", "_source"}, {"_index", "_type", "_id", "_score", "_source"}),
    Expandir3 = Table.ExpandRecordColumn(Expandir2, "_source", {"sistema_origem", "estabelecimento_valor", "vacina_categoria_codigo", "vacina_codigo", "paciente_dataNascimento", "paciente_endereco_nmPais", "estabelecimento_municipio_codigo", "vacina_categoria_nome", "paciente_endereco_nmMunicipio", "vacina_lote", "paciente_endereco_coPais", "vacina_nome", "paciente_endereco_uf", "paciente_idade", "paciente_id", "vacina_grupoAtendimento_nome", "vacina_fabricante_nome", "paciente_endereco_cep", "vacina_dataAplicacao", "estabelecimento_uf", "vacina_grupoAtendimento_codigo", "paciente_endereco_coIbgeMunicipio", "estabelecimento_razaoSocial", "@timestamp", "paciente_racaCor_valor", "estalecimento_noFantasia", "paciente_nacionalidade_enumNacionalidade", "paciente_enumSexoBiologico", "vacina_descricao_dose", "data_importacao_rnds", "estabelecimento_municipio_nome", "@version", "id_sistema_origem", "paciente_racaCor_codigo", "document_id"}, {"sistema_origem", "estabelecimento_valor", "vacina_categoria_codigo", "vacina_codigo", "paciente_dataNascimento", "paciente_endereco_nmPais", "estabelecimento_municipio_codigo", "vacina_categoria_nome", "paciente_endereco_nmMunicipio", "vacina_lote", "paciente_endereco_coPais", "vacina_nome", "paciente_endereco_uf", "paciente_idade", "paciente_id", "vacina_grupoAtendimento_nome", "vacina_fabricante_nome", "paciente_endereco_cep", "vacina_dataAplicacao", "estabelecimento_uf", "vacina_grupoAtendimento_codigo", "paciente_endereco_coIbgeMunicipio", "estabelecimento_razaoSocial", "@timestamp", "paciente_racaCor_valor", "estalecimento_noFantasia", "paciente_nacionalidade_enumNacionalidade", "paciente_enumSexoBiologico", "vacina_descricao_dose", "data_importacao_rnds", "estabelecimento_municipio_nome", "@version", "id_sistema_origem", "paciente_racaCor_codigo", "document_id"})
in
    Expandir3
```
