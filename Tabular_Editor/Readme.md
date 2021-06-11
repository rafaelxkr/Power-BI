# Tabular Editor

## Automatizando Ações no Power BI

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

### 
