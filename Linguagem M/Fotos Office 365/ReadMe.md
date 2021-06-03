# Conectando nas Fotos dos usuários

Para se conectar nas fotos dos usuários acesse a pasta

``https://[sharepointSiteName]-my.sharepoint.com/User%20Photos``

Para saber o seu "Sharepoint site name" acesse o sharepoint ``https://Empresa.sharepoint.com/``<br>
Neste exemplo o link seria ``https://Empresa-my.sharepoint.com/User%20Photos``

![image](https://user-images.githubusercontent.com/31570331/120718993-3b155f80-c4a0-11eb-8536-2f38fcc4da1b.png)

É possivel se conectar utilizando "Pasta do Sharepoint" ou "Feed Odata",
Vamos seguir com o conector "Feed Odata", pois reduz etapas de filtro de seleção de colunas

```m
let 
    Link = "https://[sharepointsitename]-my.sharepoint.com/_vti_bin/listdata.svc/ListaDeInformaçõesSobreOUsuário?"
    Select = "$select=Nome,EmailDeTrabalho,Imagem,Cargo,Escritório&" // Seleciona as colunas selecionadas
    Filter = "$filter=Imagem ne null" // Remove as linhas em branco da coluna Imagem
    Source = OData.Feed( Link&Select&Filter ,null, [Implementation="2.0"]),
    ExtrairESubstituir = Table.TransformColumns(Source, {{"Imagem", each Text.Replace(Text.BeforeDelimiter(_, ","),"MThumb.jpg","LThumb.jpg"), type text}})
in
    ExtrairESubstituir
```

A ultima etapa pegamos o primeiro link da coluna Imagem e trocamos o texto do link "MThumb.jpg" (Tamanho Médio de Imagem) por "LThumb.jpg" (Tamanho Grande da Imagem)

Documentação Feed OData = https://docs.microsoft.com/en-us/previous-versions/dynamicscrm-2015/developers-guide/gg309461(v=crm.7)
