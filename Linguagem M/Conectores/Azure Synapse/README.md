## Power BI — Integração com Azure Synapse Analytics

![image](https://github.com/user-attachments/assets/822f255e-2048-4491-819a-8db0141791b0)

Neste post, exploraremos como o Power BI pode ser integrado ao Azure Synapse Analytics. Essa é uma ferramenta desenvolvida pela Microsoft que representa um avanço em relação ao Azure SQL DW. Ela oferece uma gama de recursos aprimorados para lidar com Data Warehousing e Big Data.

O enfoque deste artigo não está na exploração detalhada da criação da ferramenta, mas sim na  conexão de dados com o Power BI Desktop.

Para acessar os dados do Azure Synapse Analytics usando o Power BI Desktop, vamos seguir os seguintes passos:

- **Passo 1 - Preparação no Azure Synapse Analytics:**

Certifique-se de que você tenha configurado corretamente o seu ambiente do Azure Synapse Analytics e que os dados que deseja acessar estejam disponíveis.

![image](https://github.com/user-attachments/assets/557e723e-c13e-4c9e-8dde-2058521ae933)

- **Passo 2 - Conexão com o Power BI Desktop:**

Abra o Power BI Desktop e clique na guia ***"Pagina inicial"***. No grupo ***"Obter Dados"***, procure por ***“Mais…”***, selecione ***"Azure"*** e, em seguida, escolha ***"Azure Synapse Analytics"***. Isso abrirá a janela de configuração da conexão.

![image](https://github.com/user-attachments/assets/b372ecd2-caf0-42b4-8a94-d91f735efe55)

![image](https://github.com/user-attachments/assets/6a7a03e8-ac82-44bb-a73f-f3add99476d4)


- **Passo 3 - Configuração da Conexão:**

Na janela de configuração da conexão do Azure Synapse Analytics, você precisará fornecer as seguintes informações:

1. **Server**: O nome do servidor do Azure Synapse Analytics.
Para encontrar o nome do servidor, você precisa ter acesso ao ambiente do Azure Synapse na página ***“Overview”*** ao lado direito você encontrará as seguinte informações:
O Azure Synapse Analytics oferece duas opções principais de provisionamento de servidores: Serveless e Dedicated, você precisa saber em qual deles o banco de dados foi provisionado e então, copiar o link correto.

![image](https://github.com/user-attachments/assets/17a7fab0-2e8e-431f-9fc3-ad6353c0d7e1)

2. **Database**: O nome do banco de dados que contém os dados que você deseja acessar.
Ainda na página ***“Overview”***, descendo mais para baixo você irá encontrar os nomes dos bancos de dados criados em **SQL Pools**, o tipo e o tamanho deles.

![image](https://github.com/user-attachments/assets/b45c92e7-c874-4c0f-9731-567e3f53b327)

3. **Data Connectivity mode**: Selecione "Import" se desejar importar os dados para o Power BI, ou "DirectQuery" se quiser criar consultas diretamente no Azure Synapse Analytics.

![image](https://github.com/user-attachments/assets/8ad3ad65-1b4b-423e-bd60-c4348ce79174)


>💡 **Modo "Import":** No modo "Import", os dados são extraídos da fonte original (nesse caso, o Azure Synapse Analytics) e armazenados na memória do Power BI. Isso significa que os dados são copiados para um modelo interno do Power BI e, a partir desse ponto, todas as análises, transformações e cálculos são realizados nos dados importados no Power BI Desktop.
>

>💡 **Modo "DirectQuery":** No modo "DirectQuery", o Power BI não importa os dados para a memória. Em vez disso, ele consulta diretamente a fonte de dados (como o Azure Synapse Analytics) sempre que uma visualização ou análise é solicitada.
>

4. **Authentication type**: Escolha a opção de autenticação, como "Windows" ou "Database".
Dependendo do tipo de autenticação selecionado, você precisará fornecer informações adicionais, como credenciais de autenticação do Windows ou informações de autenticação do banco de dados.

**Autenticação de Banco de Dados (Database Authentication)**:
Com esse método, você fornece credenciais específicas do banco de dados para se autenticar no Azure Synapse Analytics.

Este nome de usuário e senha foi determinado na hora da criação do banco, caso não tenha sido você quem criou o ambiente, peça para o responsável lhe passar o nome de usuário e senha.

![image](https://github.com/user-attachments/assets/f6af1be3-78ff-4f5b-8cc8-dca65b2d8791)

**Autenticação de Janela (Windows Authentication)**:
Neste método, você usa a autenticação do Windows para se conectar ao Azure Synapse Analytics. Isso significa que você precisa ter uma conta do Windows com permissões adequadas no servidor do Azure Synapse Analytics.

![image](https://github.com/user-attachments/assets/f046828f-a90a-4a71-8d9b-59ca49c9716d)

O Power BI usará suas credenciais do Windows para se conectar ao servidor do Azure Synapse Analytics.

- **Passo 4 - Seleção de Dados:**
Após a autenticação, o Power BI Desktop exibirá uma lista de tabelas e exibições disponíveis no banco de dados. Selecione as tabelas ou visualizações que deseja importar ou consultar.
- **Passo 5 - Transformação e Modelagem (se aplicável):**
Você pode aplicar transformações e modelagem aos dados durante a etapa de importação ou DirectQuery, conforme necessário. Isso inclui filtragem, junção de tabelas, criação de cálculos, etc.
- **Passo 6 - Atualização dos Dados:**
Se você optou por importar dados, lembre-se de que precisará atualizar manualmente os dados no Power BI Desktop para refletir as alterações feitas nos dados subjacentes no Azure Synapse Analytics.

Lembre-se de que os detalhes específicos podem variar dependendo das versões do Power BI Desktop e do Azure Synapse Analytics em uso. Certifique-se de consultar a documentação oficial do Power BI e do Azure para obter informações atualizadas e detalhadas sobre como realizar essa integração.

## ****Conectar usando opções avançadas****

Para conectar ao Azure Synapse Analytics usando opções avançadas no Power BI, você pode configurar várias configurações personalizadas para atender às suas necessidades específicas. Aqui está um exemplo de como você pode fazer isso:

1. **Abra o Power BI Desktop**.
2. **Selecione a fonte de dados.**
3. **Configurar a conexão inicial**:
    - Na janela de configuração da conexão, insira o nome do servidor do Azure Synapse Analytics e o nome do banco de dados.
4. **Opções Avançadas**:
    - Clique na opção "Advanced options" na janela de configuração da conexão.
5. **Configurar opções avançadas**:

Aqui, você pode especificar opções personalizadas, como:

- **Instrução SQL:** Digite uma consulta SQL personalizada que você deseja executar no banco de dados.

![image](https://github.com/user-attachments/assets/8b0d5ba0-f833-4eb7-a22f-b0453ce1abfc)

6. **Conclua a configuração**:
    - Após configurar todas as opções desejadas, clique em "OK" para estabelecer a conexão com o Azure Synapse Analytics.

![image](https://github.com/user-attachments/assets/e8bb932a-4985-4162-8cc8-58037fef93bb)

7. **Transformação**:
    - Você será direcionado ao Power Query Editor, onde pode aplicar transformações aos dados, se necessário.

![image](https://github.com/user-attachments/assets/5ba1f477-99de-4b18-a4fa-f06781209ea0)

Lembre-se de que as opções avançadas podem variar dependendo da versão do Power BI e das configurações específicas do Azure Synapse Analytics em seu ambiente. Certifique-se de consultar a documentação do Power BI e do Azure para obter informações atualizadas sobre as opções disponíveis e as configurações avançadas que você pode ajustar para atender às suas necessidades.

# Consideração Final:

A conexão do Azure Synapse Analytics ao Power BI é uma etapa crucial para capacitar análises avançadas e tomada de decisões informadas. Ao configurar a conexão, considere fatores como autenticação, modo de conexão, elasticidade vs. recursos dedicados e opções avançadas para adaptar a conexão às necessidades de sua organização.

Escolha o modo "Import" para cargas de trabalho com necessidade de desempenho rápido e transformações complexas, ou o "DirectQuery" para acesso em tempo real. Utilize o provisionamento Serveless para cargas de trabalho intermitentes e o provisionamento dedicado para cargas de trabalho de produção com desempenho consistente.

Mantenha um processo de monitoramento e atualização para garantir que seus dados estejam sempre atualizados e otimize sua configuração conforme suas necessidades de análise evoluem. Consulte a documentação oficial para obter orientações detalhadas e melhores práticas atualizadas. Com essas diretrizes, você poderá aproveitar ao máximo sua conexão entre o Azure Synapse Analytics e o Power BI.

# Referências:

- [Conector Azure Synapse Analytics (SQL DW) para POWER QUERY - Power Query](https://learn.microsoft.com/pt-br/power-query/connectors/azure-sql-data-warehouse)

- [Tutorial: conectar o pool de SQL sem servidor ao Power BI Desktop e criar um relatório - Azure Synapse Analytics](https://learn.microsoft.com/pt-br/azure/synapse-analytics/sql/tutorial-connect-power-bi-desktop)
