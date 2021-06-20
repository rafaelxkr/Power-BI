# Vacinação

Conexão na base csv de vacinação

```m
let
    Source = Table.PromoteHeaders(Csv.Document(Web.Contents("https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/PNI/vacina/completo/2021-06-17/part-00000-52da4f46-7e01-42fe-988b-059d4ebf1e5a-c000.csv"),[Delimiter=";", Columns=32, Encoding=65001, QuoteStyle=QuoteStyle.None])),
    Remover = Table.SelectColumns(Source,{"paciente_idade", "paciente_datanascimento", "paciente_enumsexobiologico", "paciente_racacor_codigo", "paciente_endereco_coibgemunicipio", "estabelecimento_valor", "estabelecimento_razaosocial", "estalecimento_nofantasia", "estabelecimento_municipio_codigo", "vacina_grupoatendimento_codigo", "vacina_grupoatendimento_nome", "vacina_categoria_codigo", "vacina_categoria_nome", "vacina_fabricante_nome", "vacina_dataaplicacao", "vacina_descricao_dose", "vacina_codigo", "vacina_nome", "sistema_origem"}),
    Tipo = Table.TransformColumnTypes(Remover,{{"paciente_datanascimento", type date}, {"paciente_racacor_codigo", Int8.Type}, {"paciente_endereco_coibgemunicipio", Int32.Type}, {"estabelecimento_valor", Int32.Type}, {"estabelecimento_municipio_codigo", Int32.Type}, {"vacina_grupoatendimento_codigo", Int32.Type}, {"vacina_categoria_codigo", Int8.Type}, {"vacina_dataaplicacao", type date}, {"vacina_codigo", Int16.Type}, {"paciente_idade", Int8.Type}})
in
    Tipo
```
