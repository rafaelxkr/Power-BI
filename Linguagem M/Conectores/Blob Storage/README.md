# Conectar no Blob Storage Gen1 ou Gen2

![image](https://github.com/user-attachments/assets/cef80540-6b6f-4488-9b3c-088f1fb546d3)

Neste artigo, vou explicar como podemos acessar os dados do Azure Blob Storage usando o Power BI. Para fazer isso, seguiremos os passos abaixo:

- **Passo 1: Preparação no Azure Blob Storage**

Antes de tudo, você precisa ter seus dados armazenados no Azure Blob Storage e garantir que as permissões adequadas estejam configuradas para permitir o acesso ao Power BI. Certifique-se de que os blobs estejam organizados em recipientes (containers) lógicos.

Para demonstrar o processo, criei uma conta Blob Storage no Azure chamada “ ****stomyokr**** ”:

![image](https://github.com/user-attachments/assets/d690de59-70b3-4ae8-90ac-7d8f72f10aa6)

Criei também um contêiner chamado “ ****okrfiles**** ” na conta do Azure Blob Storage e carreguei alguns arquivos CSV no contêiner Blob Storage.

![image](https://github.com/user-attachments/assets/e381027e-edc0-430a-8278-d76f7265daf2)

- **Passo 2: Conexão ao Azure Blob Storage**
1. No Power BI Desktop, clique na guia "Página Inicial".
2. No grupo "Obter Dados", clique em "Mais".
3. Na caixa de diálogo "Obter Dados", procure por "***Azure***" ou "***Azure Blob Storage***".
4. Selecione "***Azure Blob Storage***" e clique em "Conectar".

![image](https://github.com/user-attachments/assets/85addf0d-4254-4078-998d-662e12a8939c)

- **Passo 3: Configuração da conexão**
1. Na nova janela de configuração, você precisará fornecer detalhes de conexão:
    - **Storage Account Name**: O nome da sua conta de armazenamento no Azure.
    - **Container**: O nome do recipiente onde seus dados estão armazenados.
    
   ![image](https://github.com/user-attachments/assets/1880bd6a-084a-428c-af8c-b75ddb555910)

    - **Access Key**: A chave de acesso à conta de armazenamento (geralmente chamada de "Primary Key").
    
    ![image](https://github.com/user-attachments/assets/e0b8bcbc-1fb3-4eea-9825-2c8ceac543ba)
    
    >💡 Você pode encontrar essa chave na página “ **Chaves de acesso** ” da conta de armazenamento de blob do Azure. Para obter a chave de acesso, abra a página **inicial** do Portal do Azure Selecione a conta **de armazenamento do Azure Blob** ( ’****stomyokr’**** ) selecione “ **Chaves de acesso** ”:
   >
    
   ![image](https://github.com/user-attachments/assets/fe6fef75-3b20-4265-a790-29d228301671)
    
2. Após inserir essas informações, clique em "OK". O Power BI tentará se conectar à sua conta de armazenamento.
3. Uma vez conectado, você verá uma lista dos blobs (arquivos) disponíveis no recipiente selecionado. Portanto selecione o arquivo desejado e clique no botão **Transformar Dados.**

![image](https://github.com/user-attachments/assets/f0d92f20-e023-4058-8d68-3cd749f2239b)

Ao selecionar o botão "**Transformar Dados**", abrirá a janela do Power Query. Dentro do editor do Power Query, terá a capacidade de observar informações tabulares das propriedades dos arquivos, como ***nome, extensão, datas de acesso, modificação e criação***. No entanto, se o objetivo for preencher com os dados contidos em um arquivo CSV, você pode utilizar o botão "**Combinar Arquivos**". Essa opção se encontra na coluna de conteúdo e permite visualizar os dados do arquivo CSV em formato de grade na janela do editor de consultas.

![image](https://github.com/user-attachments/assets/c5f83d4d-da97-4601-9500-3f8567477ab9)

Será exibida uma caixa de diálogo denominada "**Combinar Arquivos**", onde é possível visualizar os dados contidos no arquivo CSV. Para prosseguir, basta clicar no botão **OK**.

![image](https://github.com/user-attachments/assets/774d2293-4a21-49d1-8050-eaa7a403119d)

Os dados serão então carregados, veja no exemplo a seguir:

![image](https://github.com/user-attachments/assets/6c24aeb1-b773-474f-a57a-393a0cf004a5)

Por fim, após configurar a conexão e realizar as transformações de dados, clique no botão "**Fechar e Aplicar**" para carregar os dados no Power BI.

## **Conectando com SAS (Assinatura de acesso compartilhado)**

Uma Assinatura de Acesso Compartilhado (SAS), em inglês, Shared Access Signature, é uma forma de conceder acesso limitado e temporário a recursos em um serviço do Microsoft Azure, como armazenamento de blobs, tabelas, filas, Data Lake Storage, entre outros, sem a necessidade de compartilhar chaves de autenticação privadas. A SAS é usada para fornecer um nível extra de segurança e controle sobre quem pode acessar e o que pode ser feito com esses recursos.

Aqui estão algumas características e usos comuns das SAS:

1. **Temporário e Limitado**: Uma SAS é válida apenas por um período de tempo definido e tem permissões específicas que você atribui a ela. Você decide por quanto tempo a SAS será válida e que ações podem ser executadas, como leitura, gravação ou exclusão de dados.
2. **Segurança Granular**: Com uma SAS, você pode conceder permissões granulares, permitindo que usuários ou aplicativos acessem apenas os recursos e operações que são necessários, minimizando assim o risco de abuso ou vazamento de dados.
3. **URL Assinada**: Uma SAS é normalmente incluída em uma URL como parâmetros, permitindo que o cliente acesse recursos específicos sem precisar compartilhar credenciais de acesso. Isso é especialmente útil para serviços da web, onde o cliente pode enviar a SAS como parte da solicitação.
4. **Auditoria e Monitoramento**: Você pode rastrear quem está acessando seus recursos usando uma SAS, já que todas as operações são registradas. Isso é útil para fins de auditoria e segurança.
5. **Revogação Fácil**: Se necessário, você pode revogar uma SAS antes do tempo de expiração para impedir que o acesso não autorizado continue.

As SAS são amplamente utilizadas para controlar o acesso a recursos de armazenamento no Azure, mas também podem ser aplicadas a outros serviços para conceder acesso temporário e controlado. Elas são uma maneira flexível e segura de permitir que aplicativos e usuários acessem dados e serviços na nuvem sem comprometer a segurança.

Para se conectar aos recursos de Armazenamento do Azure, incluindo Azure Data Lake Storage Gen1 e Gen2, usando assinaturas de acesso compartilhado (SAS) no Power BI, você pode seguir estas etapas:

- **Passo 1: Gerar uma SAS Token**

Primeiro, você precisará gerar uma SAS token no Azure para dar permissão ao Power BI para acessar os recursos de armazenamento. Aqui estão os passos gerais:

1. Acesse o portal do Azure (**[https://portal.azure.com/](https://portal.azure.com/)**).
2. Navegue até o recurso de armazenamento do Azure que contém os dados que deseja acessar (pode ser Azure Data Lake Gen1 ou Gen2).
3. No painel de configurações desse recurso, procure uma seção relacionada a "Chaves e SAS".
4. Clique em "Gerar Token SAS" ou algo similar, dependendo da interface.
5. Configure os detalhes da SAS token, como a data de início, data de expiração, permissões de acesso e outras configurações de acordo com suas necessidades.
6. Após configurar a SAS token, você poderá gerar a URL de acesso, que inclui a SAS token como um parâmetro na URL.
- **Passo 2: Conectar ao Azure Blob Storage no Power BI**

Agora, com a SAS token gerada, você pode se conectar ao Azure Blob Storage no Power BI Desktop:

1. Abra o Power BI Desktop.
2. Na guia "Página Inicial", clique em "Obter Dados".
3. Na caixa de diálogo "Obter Dados", procure por "Azure" ou "Azure Blob Storage".
4. Selecione "Azure Blob Storage" e clique em "Conectar".
5. Na janela de configuração que aparece, insira a URL de acesso completa (incluindo a SAS token) na caixa "URL".
6. Clique em "OK" para estabelecer a conexão.
7. Agora, você poderá acessar os dados do Azure Blob Storage usando a SAS token para autenticação.
- **Utilizar o conector “Armazenamento de Blobs do Azure”**

![image](https://github.com/user-attachments/assets/1a8aaf12-93cd-4047-97ad-1963c6e8d9b2)

- **Utilizar a URL informada**

![image](https://github.com/user-attachments/assets/3fae7f8d-05e9-4818-9c41-872bb90d7ee1)

- **Inserindo autenticação SAS:**

![image](https://github.com/user-attachments/assets/d86bbc22-b9a4-4c09-b6fa-ec78b9143dcc)

Dependendo de como você configurou a conexão (usando uma SAS token ou outra autenticação), o Power BI irá autenticar e estabelecer a conexão com os recursos de armazenamento. Você verá uma prévia dos dados disponíveis nesses recursos.

![image](https://github.com/user-attachments/assets/531a1257-dd05-4785-b2f5-62776fbcc920)

Antes de carregar os dados no Power BI, você pode configurar transformações de dados, se necessário. Isso envolve a limpeza, filtragem, remodelagem ou enriquecimento dos dados para atender às necessidades do seu relatório. 

Se houver várias tabelas ou fontes de dados disponíveis, você precisará escolher quais deseja importar para o Power BI. Você pode selecionar todas as tabelas ou apenas as específicas que deseja usar.

Os passos que mencionei são geralmente aplicáveis a ambas as versões do Azure Blob Storage, ou seja, Gen1 e Gen2. No entanto, existem algumas diferenças sutis nos recursos e na maneira como você pode interagir com essas duas versões. Vou esclarecer algumas considerações importantes para cada uma delas:

**Azure Data Lake Storage Gen1:**

1. **Autenticação**: Geralmente, ao conectar-se ao Azure Data Lake Storage Gen1 no Power BI, você precisa usar a autenticação de nome de conta e chave de acesso. Você fornece o nome da conta de armazenamento e a chave de acesso (ou seja, Primary Key ou Secondary Key) para estabelecer a conexão.
2. **URL**: Você precisa fornecer a URL de acesso direto ao contêiner ou aos recursos do Data Lake Gen1 no Power BI.

**Azure Data Lake Storage Gen2:**

1. **Autenticação**: O Azure Data Lake Storage Gen2 oferece maior flexibilidade de autenticação. Você pode usar SAS tokens (Shared Access Signatures) ou a autenticação baseada em Active Directory (Azure AD). A autenticação baseada em AD é mais segura e recomendada, pois permite que você use identidades gerenciadas pelo Azure, como contas de serviço ou identidades de usuário, para acessar os dados.
2. **Hierarquia de Diretórios**: No Gen2, você pode usar a hierarquia de diretórios para organizar seus dados em camadas de diretórios hierárquicos. Isso pode afetar como você configura a conexão, pois precisará especificar caminhos de diretórios ao se conectar a recursos específicos.
3. **URL**: A URL de acesso ao Gen2 incluirá o nome da conta de armazenamento e o nome do sistema de arquivos (que pode ser o nome do sistema de arquivos padrão ou um sistema de arquivos personalizado que você criou). Além disso, você pode incluir um caminho de diretório específico, se necessário.

> 💡 Lembre-se de que os detalhes e a interface do Power BI podem evoluir com o tempo, portanto, é sempre recomendável consultar a documentação mais recente do Power BI e do Azure Blob Storage para obter as instruções mais atualizadas.
>

> **Para maiores informações sobre conexão, você pode consultar o arquivo abaixo: 
[Conectar no Blob Storage Gen1 ou Gen2](https://datasidetecnologia.sharepoint.com/:b:/s/BusinessIntelligence/ES0nRtbHYJNFoHg9MesDDpAB4um2qR5hqin_VHxYUqkRPw?e=iARqhZ)**
> 

# Considerações Finais

Em resumo, ao se conectar ao Azure Data Lake Storage Gen1 no Power BI, você usará principalmente a autenticação com nome de conta e chave de acesso, enquanto no Gen2, você tem opções adicionais de autenticação, como SAS tokens ou autenticação baseada em Azure AD. Além disso, a hierarquia de diretórios no Gen2 pode afetar a forma como você especifica os caminhos dos recursos ao configurar a conexão. Certifique-se de ajustar suas configurações de acordo com a versão específica do Data Lake Storage que você está usando.

# Referências:

- [Armazenamento do Blobs do Azure - Power Query](https://learn.microsoft.com/pt-br/power-query/connectors/azure-blob-storage)

- [Azure Data Lake Storage Gen1 - Power Query](https://learn.microsoft.com/pt-br/power-query/connectors/azure-data-lake-storage-gen1)

- [Azure Data Lake Storage Gen2 - Power Query](https://learn.microsoft.com/pt-br/power-query/connectors/data-lake-storage)
