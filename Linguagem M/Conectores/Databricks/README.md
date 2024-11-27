# Conectando o Power BI com Databricks

![image](https://github.com/user-attachments/assets/b4e15e0a-aa0a-4939-805c-a15a14f2f89c)

Olá a todos!
Hoje, vou compartilhar uma dica sobre como extrair dados de tabelas no Databricks para o Power BI.

**O que é Databricks?**
Databricks é uma plataforma de análise e processamento de big data que combina Apache Spark com recursos de aprendizado de máquina, permitindo que equipes trabalhem juntas para processar dados em grande escala e construir modelos de aprendizado de máquina. É amplamente usado para análise de dados e inteligência artificial em empresas. O Databricks Community é uma versão gratuita da plataforma para exploração e aprendizado.

Antes de avançarmos para a integração dos dados do Databricks com o Power BI Desktop, é importante garantir que você tenha um cluster Databricks configurado e em funcionamento, além de um notebook em Python ou Scala instalado.

Para conectar seus dados do Databricks no Power BI Desktop, siga estas etapas:

1. Na guia ***"Página Inicial"***, clique em ***"Obter Dados"*** procure por ***“Mais…”***, selecione ***"Azure"*** e, em seguida, escolha ***"Azure Databricks"*** e então, clique no botão ***“Conectar”*** e uma nova janela de conexão será aberta.

      ![image](https://github.com/user-attachments/assets/a56a8b80-502e-4a60-877c-42aa45e75601)

2. Preencha os detalhes de conexão:
    - **Servidor:** Insira o nome do servidor do seu cluster Databricks.
        
        ![image](https://github.com/user-attachments/assets/f2787e08-c43a-4409-81e2-fb292b5ff760)
        
    
    Precisamos ter certeza de que o cluster Databricks está instalado e funcionando. A seguir estão as etapas para a integração do Azure Databricks com o Power BI Desktop.
    
    Na Página Inicial do Databricks vá em ***“Compute” > “Configuration” > “JDBC/ODBC”,***  conforme mostrado na imagem abaixo, você encontrará as informações que o Power BI precisa.
    
    ![image](https://github.com/user-attachments/assets/34660c48-bb6f-4f6b-86d4-ea9aa964673c)
    
    - **Autenticação:** Escolha o método de autenticação adequado. O mais recente conector agora inclui suporte para autenticação no Azure Active Directory. Isso possibilita a utilização do mesmo usuário utilizado para acessar a interface web do Databricks! 
    Além disso, a autenticação com tokens de acesso pessoal é igualmente compatível, bem como a autenticação básica, utilizando nome de usuário e senha.
    
   ![image](https://github.com/user-attachments/assets/7ca0e46e-04f2-4459-adaa-0eb3537a5638)
    
    Existem três tipos comuns de autenticação ao conectar o Power BI Desktop ao Databricks: ***Autenticação Básica (Nome de usuário/Senha)***, ***Autenticação do Azure Active Directory (Azure Active Directory Authentication)*** e ***Autenticação de Token (Token Authentication)***. Aqui está uma explicação da funcionalidade de cada um deles:
    
    1. **Autenticação Básica (Nome de usuário/Senha):**
    Essa autenticação é adequada para cenários em que você tem uma conta de usuário do Databricks e deseja acessar seus dados por meio do Power BI. É simples, mas menos seguro do que outras opções, pois envolve o envio de senhas em texto simples.
    2. **Autenticação do Azure Active Directory (Azure Active Directory Authentication):**
    Essa opção é mais segura do que a autenticação básica e é ideal para organizações que já utilizam o Azure Active Directory para gerenciar identidades. Ela oferece um nível mais alto de segurança e controle de acesso.
    3. **Autenticação de Token (Token Authentication):**
    Um token de autenticação é gerado no Databricks e fornecido ao Power BI Desktop. Essa abordagem é útil quando você deseja evitar o compartilhamento de senhas e oferece maior segurança. É especialmente útil em cenários de automação ou quando aplicativos precisam se conectar ao Databricks sem intervenção manual constante.
    
    A escolha entre esses métodos de autenticação depende das necessidades de segurança da sua organização, da infraestrutura existente e das preferências de implementação. A autenticação do Azure Active Directory tende a ser a mais segura e versátil, enquanto a autenticação de token é uma boa opção para minimizar o compartilhamento de senhas e garantir a segurança. A autenticação básica é a mais simples, mas deve ser usada com cautela devido à falta de segurança comparada às outras opções.
    
    - **Nome do Banco de Dados:** Especifique o nome do banco de dados ou esquema que você deseja acessar.

Se tudo estiver em ordem, você poderá ver todas as tabelas disponíveis em seu cluster do Databricks no painel do Navegador do Power BI. Você pode selecionar as tabelas de dados e escolher a opção ***Carregar*** para carregar os dados ou a opção ***Transformar Dados*** para modificar esses dados antes de carregá-los no Power BI Desktop.

![image](https://github.com/user-attachments/assets/e7f69116-e10d-4947-a2d0-654499c90e9e)

No Power Query, você poderá visualizar 5 tipos de parâmetros específicos que podem ser usados ao se conectar ao Databricks que são: ***Databricks.Catalogs, Databricks.Content, Databricks.Query, DatabricksMultiCloud.Catalogs e DatabricksMultiCloud.Query.***

Dentre os parâmetros mencionados, os mais comuns e relevantes para a conexão no Power Query ao Databricks, se considerarmos o cenário típico de consulta e extração de dados, são:

1. **Databricks.Catalogs:** Este parâmetro é comum quando você deseja listar e acessar tabelas e visualizações disponíveis no catálogo de metadados do Databricks. É útil para descobrir quais dados estão disponíveis antes de importá-los no Power Query. É frequentemente usado em ambientes onde a estrutura de dados é organizada em catálogos.
2. **Databricks.Content:** Este parâmetro é comum para selecionar o tipo de conteúdo específico que você deseja acessar no Databricks, como tabelas, visualizações ou arquivos. Você o usa para indicar qual tipo de objeto de dados deseja importar.

>💡 Por exemplo, você pode definir **`Databricks.Content`** como "Tables" para acessar tabelas ou como "Files" para acessar arquivos armazenados no Databricks.
>

O parâmetro **`Databricks.Query`** não é comum nesse contexto, pois geralmente as consultas personalizadas são escritas diretamente no ambiente Databricks usando Spark SQL ou outras linguagens de consulta e, em seguida, os resultados são importados para o Power Query. O Power Query não fornece uma maneira direta de inserir consultas personalizadas na etapa de conexão.

Os parâmetros **`DatabricksMultiCloud.Catalogs`** e **`DatabricksMultiCloud.Query`** são específicos para ambientes multicloud, o que é menos comum do que ambientes de Databricks em uma única nuvem, portanto, sua utilização depende das configurações específicas da infraestrutura da sua organização.

Em resumo, para a maioria dos casos de uso típicos de conexão do Power Query com o Databricks, os parâmetros mais comuns são **`Databricks.Catalogs`** e **`Databricks.Content`**. No entanto, a escolha exata dos parâmetros dependerá da estrutura e das necessidades específicas do seu ambiente de dados no Databricks.

# Considerações Finais

O conector Databricks no Power Query oferece uma maneira poderosa de acessar e importar dados de ambientes Databricks diretamente em ferramentas como o Power BI. Embora a sintaxe e os parâmetros possam variar com base nas configurações e na estrutura do seu ambiente Databricks, é essencial consultar a documentação específica da ferramenta que você está usando e garantir que os parâmetros sejam configurados corretamente.

Lembre-se de que consultas personalizadas são geralmente executadas no ambiente Databricks, e o Power Query é usado principalmente para importar os resultados dessas consultas. A compreensão adequada dos parâmetros e da estrutura do seu ambiente Databricks é fundamental para uma integração de dados eficiente e para aproveitar ao máximo os recursos oferecidos pela conexão Databricks no Power Query.

# Referências:

- [Connect Power BI to Databricks](https://docs.databricks.com/pt/partners/bi/power-bi.html)

- [Conectar o Power BI ao Azure Databricks – Azure Databricks](https://learn.microsoft.com/pt-br/azure/databricks/partners/bi/power-bi)

- [Conector de Power Query do Azure Databricks - Power Query](https://learn.microsoft.com/pt-pt/power-query/connectors/databricks-azure)

- [Como obter e publicar dados do Azure Databricks no Power BI](https://youtu.be/cbgtMb3IEqw?si=b8uaEoo-ip8TQS7z)

video no Youtube
https://www.youtube.com/embed/cbgtMb3IEqw?si=mafFTPoMoWy3453o
