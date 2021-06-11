# Tabular Editor

## Automatizando Ações no Power BI
Fonte: https://docs.tabulareditor.com/Useful-script-snippets.html#generating-documentation

### Identar todas medidas do modelo

```c#
Model.AllMeasures.FormatDax();
```

### Ocultar colunas em relacionamento

```c#
foreach (var r in Model.Relationships) {
r.FromColumn.IsHidden = true;
}
```

### Criando uma medida de soma da coluna selecionada

```c#
foreach (var c in Selected.Columns)
{
    var NovaMedida = Model.Tables["_Medidas"].AddMeasure(  //criar na tabela "_Medidas"
    c.Name.SplitCamelCase(),  //Nome da Medida 
    "SUM(" + c.DaxObjectFullName + ")", //DAX
    "Tabular_Editor" //Nome da Pasta
    );
    
    NovaMedida.FormatString = "0"; //Formatação do calculo
    NovaMedida.Description = NovaMedida.Expression; //Colocar o DAX na descrição
}
````

### Contar a quantidade de linhas da tabela da coluna selecionada

```c#
foreach (var c in Selected.Columns)
{
    var NovaMedida = Model.Tables["_Medidas"].AddMeasure(
    "COUNTROWS " + c.Table.Name.SplitCamelCase(),
    "COUNTROWS(" + c.Table.DaxObjectFullName + ")",
    "Tabular_Editor"
    );
    
    NovaMedida.FormatString = "0";
    NovaMedida.Description = NovaMedida.Expression;
}
```

### Acumulado do Ano da medida selecionada

```c#
foreach (var m in Selected.Measures)
{
    m.Table.AddMeasure(
    m.Name + " YTD",
    "TOTALYTD(" + m.DaxObjectName + ", 'Date'[Date])",
    "Tabular_Editor"
    );
    
    m.FormatString = "0";
    m.Description = m.Expression;
}
```

# Melhores Praticas

No link abaixo segue o passo a passo de como adicionar as regras de melhores praticas do Power BI,
para serem adicionadas ao Tabular Editor e facilitar na identificação para correção desses itens

https://github.com/TabularEditor/BestPracticeRules
