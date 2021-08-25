// Fonte: https://docs.tabulareditor.com/Useful-script-snippets.html

// Definir qual o Nome da Tabela e coluna data da Tabela Calendário
var colunadata = "dCalendario[Data]";
//Criar Medidas de Inteligência de Tempo para cada medida selecionada.
foreach(var m in Selected.Measures) {
//Valor do Mesmo Período do Ano Anterior
    m.Table.AddMeasure(                                                                     
        m.Name + " Ano Anterior",                                                                                               //Nome
        "CALCULATE(" + m.DaxObjectName + ",SAMEPERIODLASTYEAR(" + colunadata + "))",                                            //Medida
        m.DisplayFolder                                                                                                         //Exibir Pasta
    )
    .FormatString = "#,0;(#,0)";
//Variação R$ do Ano Atual com Ano Anterior    
    m.Table.AddMeasure(                                                                     
    "YoY R$ " + m.Name,                                                                                                         //Nome
    "("+ m.DaxObjectName + " - [" + m.Name + " Ano Anterior])",                                                                 //Medida
        m.DisplayFolder                                                                                                         //Exibir Pasta
    )
    .FormatString = "#,0;(#,0)";  
    //Formato em R$
//Variação % do Ano Atual com Ano Anterior    
    m.Table.AddMeasure(                                                                     
    "YoY % " + m.Name,                                                                                                        //Nome
        "IF(ISBLANK(" + "["+ m.Name + " Ano Anterior]),0,DIVIDE(" + m.DaxObjectName + ",[" + m.Name + " Ano Anterior])-1)",     //Medida
        m.DisplayFolder                                                                                                         //Exibir Pasta
    )
    .FormatString = "0.0%";                                                                                                    //Formato em %
    
// Acumulado Ano
    m.Table.AddMeasure(                                                                     
    m.Name + " Acumulado Ano",                                                                                                  //Nome
    "TOTALYTD(" + m.DaxObjectName +"," + colunadata + ")",                                                                      //Medida
    m.DisplayFolder                                                                                                             //Exibir Pasta
    )
    .FormatString = "#,0;(#,0)";
// Acumulado Mês
    m.Table.AddMeasure(                                                                     
    m.Name + " Acumulado Mês",                                                                                                  //Nome
        "TOTALMTD(" + m.DaxObjectName +"," + colunadata + ")",                                                                  //Medida
        m.DisplayFolder                                                                                                         //Exibir Pasta
    )
    .FormatString = "#,0;(#,0)";
//Valor do Mesmo Período do Mês Anterior
    m.Table.AddMeasure(                                                                     
    m.Name + " Mês Anterior",                                                                                               //Nome
        "CALCULATE(" + m.DaxObjectName + ",DATEADD(" + colunadata + ",-1,MONTH))",                                              //Medida
        m.DisplayFolder                                                                                                         //Exibir Pasta
    )
    .FormatString = "#,0;(#,0)";
//Variação R$ do Mês Atual com Mês Anterior    
    m.Table.AddMeasure(                                                                     
    "MoM R$ " + m.Name,                                                                                                         //Nome
    "("+ m.DaxObjectName + " - [" + m.Name + " Mês Anterior])",                                                                 //Medida
        m.DisplayFolder                                                                                                         //Exibir Pasta
    )
    .FormatString = "#,0;(#,0)";                                                                                                    //Formato em R$
//Variação % do Mês Atual com Mês Anterior    
    m.Table.AddMeasure(                                                                     
    "MoM % " + m.Name,                                                                                                        //Nome
    "IF(ISBLANK(" + "["+ m.Name + " Mês Anterior]),0,DIVIDE(" + m.DaxObjectName + ",[" + m.Name + " Mês Anterior])-1)",       //Medida
        m.DisplayFolder                                                                                                       //Exibir Pasta
    )
    .FormatString = "0.0%";                                                                                                    //Formato em %
    
}