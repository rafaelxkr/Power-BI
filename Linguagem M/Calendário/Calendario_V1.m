let
        DataFinal = List.Max(Vendas[Data]),
        QtdeDias = Duration.Days(DataFinal - List.Min(Vendas[Data])) + 1,
        Lista = List.Dates(List.Min(Vendas[Data]), QtdeDias, #duration(1,0,0,0)),
        Tabela = #table(type table[Data=date, Ano=Int32.Type, Nome do Mês=text, Mês=Int32.Type, Dia = Int8.Type, Semana = Int8.Type, Nome da Semana = text], List.Transform(Lista, each {
            _,
            Date.Year(_),
            Text.Proper(Text.Start(Date.MonthName(_), 3)),
            Date.Month(_),
            Date.Day(_),
            Date.DayOfWeek(_),
            Text.BeforeDelimiter(Date.DayOfWeekName(_),"-")
            }))
in
        Tabela
