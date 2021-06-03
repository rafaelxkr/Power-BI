# Conectando nas Fotos dos usuários

Para se conectar nas fotos dos usuários acesse a pasta

``https://[sharepointsitename]-my.sharepoint.com/User%20Photos``

É possivel se conectar utilizando "Pasta do Sharepoint" ou "Feed Odata",
Vamos seguir com o conector "Feed Odata", pois reduz etapas de filtro de seleção de colunas

```m
let 
    Link = "https://votorantimindustrial-my.sharepoint.com/_vti_bin/listdata.svc/ListaDeInformaçõesSobreOUsuário?"
    Select = "$select=Nome,EmailDeTrabalho,Imagem,Cargo,Escritório&" // Seleciona as colunas selecionadas
    Filter = "$filter=Imagem ne null" // Remove as linhas em branco da coluna Imagem
    Source = OData.Feed( Link&Select&Filter ,null, [Implementation="2.0"]),
    #"Extrair&Substituir" = Table.TransformColumns(Source, {{"Imagem", each Text.Replace(Text.BeforeDelimiter(_, ","),"MThumb.jpg","LThumb.jpg"), type text}})
in
    #"Extrair&Substituir"
```

A ultima etapa pegamos o primeiro link da coluna Imagem e trocamos o texto do link "MThumb.jpg" (Tamanho Médio de Imagem) por "LThumb.jpg" (Tamanho Grande da Imagem)
