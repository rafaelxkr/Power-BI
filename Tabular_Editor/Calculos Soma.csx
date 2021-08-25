// Criar Medida de Soma das Colunas Selecionadas
foreach(var c in Selected.Columns)
{
    c.Table.AddMeasure(
    "Vl." + c.Name,                    // Nome da Medida
        "SUM(" + c.DaxObjectFullName + ")",     // Expressão DAX
        c.DisplayFolder                         // Exibir Pasta
    )                                                                                                       //Exibir Pasta
    .FormatString = "#,0;(#,0)";
    c.IsHidden = true;
}
