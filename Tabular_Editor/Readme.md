# Tabular Editor

## Automatizando Ações no Power BI
Fonte: https://docs.tabulareditor.com/Useful-script-snippets.html#generating-documentation

### Identar todas medidas do modelo

```c#
Model.AllMeasures.FormatDax();
```

### Configurar o Encoding dos números Inteiros, Decimais e Data e Hora como "Value"

```c#
// for all Int64, Decimal and DateTime columns set EncodingHint
foreach(var column in Model.Tables.SelectMany(t => t.Columns)) 
{
    if(column.DataType == DataType.Int64 || column.DataType == DataType.Decimal || column.DataType == DataType.DateTime)         
        column.EncodingHint = EncodingHintType.Value;
}
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

1. Rode o Script
2. Feche e abra Tabular Editor conectado no modelo.
4. Selecione 'Tools' do File menu e select 'Best Practice Analyzer'.
5. Clique no icone "Refresh"(em azul) no canto direito superior.
```c#
// https://powerbi.microsoft.com/pt-br/blog/best-practice-rules-to-improve-your-models-performance/
// https://github.com/microsoft/Analysis-Services/tree/master/BestPracticeRules

System.Net.WebClient w = new System.Net.WebClient(); 

string path = System.Environment.GetFolderPath(System.Environment.SpecialFolder.LocalApplicationData);
string url = "https://raw.githubusercontent.com/microsoft/Analysis-Services/master/BestPracticeRules/BPARules.json";
string version = System.Windows.Forms.Application.ProductVersion.Substring(0,1);
string downloadLoc = path+@"\TabularEditor\BPARules.json";

if (version == "3")
{
    downloadLoc = path+@"\TabularEditor3\BPARules.json";
}

w.DownloadFile(url, downloadLoc);
```

# Exportar Alertas de melhores praticas

```c#
//https://www.elegantbi.com/post/exportbparesults
using TabularEditor.BestPracticeAnalyzer;
//using TabularEditor.Shared.BPA;

var bpa = new Analyzer();
bpa.SetModel(Model);

var sb = new System.Text.StringBuilder();
string newline = Environment.NewLine;

sb.Append("RuleCategory" + '\t' + "RuleName" + '\t' + "ObjectName" + '\t' + "ObjectType" + '\t' + "RuleSeverity" + '\t' + "HasFixExpression" + newline);

foreach (var a in bpa.AnalyzeAll().ToList())
{
    sb.Append(a.Rule.Category + '\t' + a.RuleName + '\t' + a.ObjectName + '\t' + a.ObjectType + '\t' + a.Rule.Severity + '\t' + a.CanFix + newline);
}

sb.Output();


```
***Nota: Se você estiver usando o Tabular Editor 3 , altere a primeira linha do script com o código abaixo. Esse script funciona no Tabular Editor 3.0.6 ou posterior.
```c#
using TabularEditor.Shared.BPA;
```

# Encontrar Relacionamentos que Retornam Linha em Branco no Filtro

```c#
// https://www.elegantbi.com/post/findblankrows

var sb = new System.Text.StringBuilder();
string newline = Environment.NewLine;

sb.Append("FromTable" + '\t' + "ToTable" + '\t' + "BlankRowCount" + newline);

foreach (var r in Model.Relationships.ToList())
{
    bool   act = r.IsActive;
    string fromTable = r.FromTable.Name;
    string toTable = r.ToTable.Name;
    string fromTableFull = r.FromTable.DaxObjectFullName;    
    string fromObject = r.FromColumn.DaxObjectFullName;
    string toObject = r.ToColumn.DaxObjectFullName;
    string dax;
    
    if (act)
    {
        dax = "SUMMARIZECOLUMNS(\"test\",CALCULATE(COUNTROWS("+fromTableFull+"),ISBLANK("+toObject+")))";
    }
    else
    {
        dax = "SUMMARIZECOLUMNS(\"test\",CALCULATE(COUNTROWS("+fromTableFull+"),USERELATIONSHIP("+fromObject+","+toObject+"),ISBLANK("+toObject+")))";
    }
    
    var daxResult = EvaluateDax(dax);
    string blankRowCount = daxResult.ToString();
    
    if (blankRowCount != "Table")
    {
        sb.Append(fromTable + '\t' + toTable + '\t' + blankRowCount + newline);        
    }
}

sb.Output();
```

# Medir Redução do Modelo se Desativar IsAvailableInMDX

1° precisa rodar o script VertipaqAnnotations.cs para adicionar o Vertipaq nas anotações de cada coluna [instruções](https://www.elegantbi.com/post/vertipaqintabulareditor)

2° Rodar script abaixo [instruções](https://www.elegantbi.com/post/bestpracticerulesavings)
```c#
var sb = new System.Text.StringBuilder(); 
string newline = Environment.NewLine;
string ann = "Vertipaq_ColumnHierarchySize";
long tot = 0;

// Header
sb.Append("TableName" + '\t' + "ColumnName" + '\t' + "HierarchySize" + newline);

foreach (var c in Model.AllColumns.Where(a => a.IsAvailableInMDX /*&& (a.IsHidden || a.Table.IsHidden)*/ && (a.DataType == DataType.Int64 || a.DataType == DataType.Decimal || a.DataType == DataType.Double)&&! a.UsedInSortBy.Any() && ! a.UsedInHierarchies.Any() ).OrderBy(a => a.Table.Name).ThenBy(a => a.Name))
{
    string tableName = c.Table.Name;
    string colName = c.Name;
    string annValue = c.GetAnnotation(ann);
    sb.Append(tableName + '\t' + colName + '\t' + annValue + newline);
    tot = tot + Convert.ToInt64(annValue);
}

tot.Output(); // Value shown in bytes
sb.ToString().Output();
```

https://github.com/TabularEditor/BestPracticeRules
