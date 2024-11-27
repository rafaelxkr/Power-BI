# Introdução

Uma das características essenciais do Power BI é sua capacidade de conectar-se a uma variedade de fontes de dados, incluindo arquivos Parquet. Os arquivos Parquet, conhecidos por sua eficiência de armazenamento e processamento em ambientes de Big Data, podem ser integrados ao Power BI para análise avançada e geração de relatórios impactantes.

Antes de mergulharmos na conexão do Parquet com o Power BI, vamos entender o que é:

> 💡 O **Parquet** tem uma organização interna dos dados bem semelhante a uma tabela do RDBMS (Relational Database Management System, ou Sistema de Gerenciamento de Banco de Dados Relacional, em português), com linhas e colunas. Ao contrário dessa tabela, os dados no **Parquet** são armazenados um ao lado do outro.
>

**Exemplo:**
path

    to
    │
    └── table
        ├── gender=male
        │   ├── ...
        │   │
        │   ├── country=US
        │   │   └── data.parquet
        │   ├── country=CN
        │   │   └── data.parquet
        │   └── ...
        └── gender=female
            ├── ...
            │
            ├── country=US
            │   └── data.parquet
            ├── country=CN
            │   └── data.parquet
            └── ...

Em resumo, um arquivo Parquet é um formato de armazenamento colunar projetado para otimizar o armazenamento e a recuperação eficiente de dados em sistemas de Big Data. Sua estrutura é baseada em metadados, grupos de linhas, e colunas fisicamente armazenadas com codificação e compressão eficientes. Isso o torna uma escolha popular para análise de dados em escala.

## Conexão de Arquivos Parquet no Power BI

**Passo 1: Adicionar uma Nova Fonte de Dados:**

1. No menu "Página Inicial", clique em "Obter Dados".
2. Na janela que se abre, selecione "Arquivo" e, em seguida, "Parquet".
3. Clique em "Conectar" para prosseguir.

**Passo 2: Selecionar o Arquivo Parquet (local):**

1. Navegue até o diretório onde seu arquivo Parquet está localizado.
2. Selecione o caminho e o nome do arquivo Parquet que você deseja importar.
3. Insira todo o caminho e cole no campo URL
4. Clique em "OK".
5. 
![image](https://github.com/user-attachments/assets/2ae38ec0-cff0-418e-a3af-5c0806204e37)

Passo 3: Importar Dados:
Agora você verá uma janela com uma prévia dos dados do arquivo Parquet.

![image](https://github.com/user-attachments/assets/35fdc176-342f-4075-ba86-3f69a1e711dc)

**Passo 4: Transformar Dados:**

Nunca se esqueça, de sempre clicar em “Transformar Dados” para realizar transformações dos dados no Editor do Power Query antes de importá-los para o Power BI. Isso inclui renomear colunas, filtrar registros, criar colunas calculadas, etc.

> 💡 Lembre-se de que esse é um guia básico sobre como conectar um arquivo Parquet **(local)** ao Power BI. Dependendo da complexidade dos seus dados e das transformações necessárias, os passos podem variar um pouco. 
Consulte a documentação oficial para outros tipos de conexão.
>

> **Limitações:** O conector parquet Power Query dá suporte apenas à leitura de arquivos do sistema de arquivos local, Armazenamento de Blobs do Azure e Azure Data Lake Storage Gen2.
> 

## Detalhando as etapas

```jsx
let
    Fonte = Folder.Files(CaminhoPasta & "\PARQUET\"),
    Tabela = Parquet.Document((Fonte{1}[Content]), [Compression=null, LegacyColumnNameEncoding=false, MaxDepth=null])
in
    Tabela
```

**1. Listar Arquivos na Pasta:** Nesta etapa, o código usa a função **`Folder.Files`** para listar todos os arquivos na pasta especificada (**`CaminhoPasta & "\PARQUET\"`**). Ele armazena as informações dos arquivos na variável **`Fonte`**.

**2. Parquet.Document:`Parquet.Document`** é uma função específica do Power Query (M) que permite interpretar o conteúdo binário de um arquivo Parquet. Ele cria uma representação de tabela a partir dos dados contidos no arquivo Parquet.

**3. Parâmetros de Parquet.Document:**
Dentro da função ***Parquet.Document***, temos três parâmetros entre colchetes:

- **Compression=null:** Este parâmetro controla a compressão dos dados dentro do arquivo Parquet. No contexto do código que você forneceu, **`null`** indica que nenhuma compressão específica está sendo aplicada. No entanto, você pode definir este parâmetro para um tipo específico de compressão, como **`"SNAPPY"`** ou **`"GZIP"`**, se o arquivo Parquet estiver comprimido usando um desses métodos. Usar a compressão apropriada pode ser útil para economizar espaço em disco, especialmente ao lidar com grandes volumes de dados.
- **LegacyColumnNameEncoding:** O Parquet permite que os nomes das colunas sejam codificados de maneiras diferentes para otimização. O parâmetro **`LegacyColumnNameEncoding=false`** indica que você está optando por não usar um método de codificação legado. A codificação de nomes de colunas pode afetar a eficiência do armazenamento e o desempenho das consultas. Ao configurá-lo como **`false`**, você está utilizando um método de codificação atualizado para os nomes das colunas.
        
    > 💡 **ATENÇÃO:** A opção **`'LegacyColumnNameEncoding'`** era usada para indicar que os nomes de colunas nos resultados da consulta seriam codificados de acordo com uma abordagem antiga. No entanto, essa opção foi descontinuada em versões mais recentes do Power Query e não é mais válida.
    
   > ![image.png](/.attachments/image-8cb603e5-361e-49c3-9f33-ef5090819179.png =500x)
    
   > Para resolver esse erro, você precisa remover ou comentar a linha que faz referência à opção **`'LegacyColumnNameEncoding'`** com o valor **`true`** em seu código. Certifique-se de usar somente opções suportadas e atualizadas para a versão do Power Query que você está utilizando. Se houver outras opções relacionadas à codificação de nomes de colunas, verifique a documentação oficial ou guias de referência do Power Query para usar as opções corretas.
    >
    
- **MaxDepth:** Este parâmetro controla a profundidade máxima para a análise do esquema do arquivo Parquet. O valor **`null`** significa que não há restrição de profundidade. Em outras palavras, o Power BI irá analisar todas as estruturas de dados no arquivo Parquet, independentemente da profundidade. Se você souber que seus dados têm uma estrutura complexa com aninhamentos profundos, você pode definir um valor numérico para limitar a profundidade da análise do esquema, o que pode melhorar o desempenho do processo de importação de dados.
![image](https://github.com/user-attachments/assets/107661e2-ec2e-481c-ad79-e86dee2fc63c)

 > Para resolver esse erro, você precisa remover ou comentar a linha que faz referência à opção **`'LegacyColumnNameEncoding'`** com o valor **`true`** em seu código. Certifique-se de usar somente opções suportadas e atualizadas para a versão do Power Query que você está utilizando. Se houver outras opções relacionadas à codificação de nomes de colunas, verifique a documentação oficial ou guias de referência do Power Query para usar as opções corretas.
    >
    
- **MaxDepth:** Este parâmetro controla a profundidade máxima para a análise do esquema do arquivo Parquet. O valor **`null`** significa que não há restrição de profundidade. Em outras palavras, o Power BI irá analisar todas as estruturas de dados no arquivo Parquet, independentemente da profundidade. Se você souber que seus dados têm uma estrutura complexa com aninhamentos profundos, você pode definir um valor numérico para limitar a profundidade da análise do esquema, o que pode melhorar o desempenho do processo de importação de dados.

![image](https://github.com/user-attachments/assets/4f4301fa-de29-45aa-82e5-71c91e6edf9c)

Certifique-se de verificar a documentação oficial do Power Query para obter informações detalhadas sobre os parâmetros e opções disponíveis ao usar o conector Parquet. 

## Vantagens de Usar Conector Parquet no Power BI:

1. **Eficiência de Armazenamento:** Arquivos Parquet são altamente compactos, permitindo armazenar grandes volumes de dados com economia de espaço.
2. **Desempenho de Consulta:** O formato colunar do Parquet possibilita consultas mais rápidas e eficientes, especialmente com grandes conjuntos de dados.
3. **Compatibilidade com Big Data:** O Parquet é amplamente usado em ambientes de Big Data, facilitando a integração de dados de fontes distribuídas.
4. **Integração entre Ferramentas:** Permite compartilhar dados entre o Power BI e outras ferramentas de análise distribuída.

## Desvantagens de Usar Conector Parquet no Power BI:

1. **Transformações no Power Query:** As manipulações de dados precisam ser principalmente feitas no Power Query, o que pode ser menos intuitivo.
2. **Dependência de Estrutura Externa:** Mudanças no esquema dos arquivos Parquet exigem ajustes nas consultas no Power Query.
3. **Atualizações Manuais:** Atualizações frequentes dos dados requerem carregamento manual ou criação de processos de atualização.
4. **Menos Flexibilidade:** Comparado a bancos de dados, a flexibilidade para operações complexas pode ser limitada.

Portanto, a escolha de usar um conector Parquet no Power BI depende das necessidades do projeto, aproveitando a eficiência de armazenamento e desempenho de consulta, mas requerendo considerações sobre transformações, atualizações e flexibilidade operacional.

# Considerações Finais

O uso do conector Parquet no Power BI oferece uma vantajosa abordagem para análise de dados em larga escala, aproveitando a eficiência de armazenamento e o desempenho otimizado de consultas. Essa integração viabiliza a exploração eficaz de insights, especialmente em ambientes de Big Data, embora exija adaptações no Power Query e considerações sobre atualizações. A decisão de adotar esse conector deve ser guiada pelas demandas do projeto e pela necessidade de equilibrar os benefícios do Parquet com as complexidades inerentes ao processo de análise de dados no Power BI.

# Referências
    
- [conector do Power Query Parquet - Power Query](https://learn.microsoft.com/pt-br/power-query/connectors/parquet)
    
- [Power BI Quick Tip: ​Using Parquet File as a Source](https://youtu.be/5hCznl9tOsk?si=cUdZylSoNraRs_q_)
  


