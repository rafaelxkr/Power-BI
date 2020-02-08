
let
    Date.StartOfYear(List.Min(Vendas[Data])),
    DataFinal = List.Max(Vendas[Data]),
    QtdeDias = Duration.Days(DataFinal - DataInicial) + 1,
    Lista = List.Dates(DataInicial, QtdeDias, #duration(1,0,0,0)),
    Tabela = #table(type table[Data=date, Ano=Int32.Type, Nome do Mês=text, Mês=Int32.Type], List.Transform(Lista, each {
        _,
        Date.Year(_),
        Text.Start(Date.MonthName(_), 3),
        Date.Month(_)
        }))
in
    Tabela
