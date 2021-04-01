let
    Calendario = (data as list) =>
        let
            DataBuffer = List.Transform(List.Buffer(data),DateTime.Date),
            DataMin = List.Min(DataBuffer),
            Qtde_Dias = Duration.TotalDays(Date.EndOfMonth(List.Max(DataBuffer))-DataMin)+1,
            Fonte = List.Dates(DataMin,Qtde_Dias,#duration(1,0,0,0)),
            Tabela = #table(type table[Data=date, Mes txt = text, Mês=Int8.Type, AnoMes=Int16.Type, Dia=Int8.Type, Ano = Int16.Type, OrdemAno = Int8.Type],
            List.Transform(Fonte, each {
                _,
                Text.Proper(Date.ToText(_,"MMM")),
                13-Date.Month(_),
                Date.Year(_)*100+Date.Month(_),
                Date.Day(_),
                Date.Year(_),
                Date.Year(DateTime.LocalNow()) - Date.Year(_)

                }))
        in
            Tabela,
            DefineDocs = [
            Documentation.Name =  " Table.Calendario",
            Documentation.Description = " Cria uma tabela Calendário",
            Documentation.LongDescription = " Cria uma tabela Calendário",
            Documentation.Category = " Table.Transform",
            Documentation.Source = " ",
            Documentation.Author = " Rafael barbosa",
            Documentation.Examples = 
                {
                    [
                    Description =  "", 
                    Code = " CalendarioContents("")", 
                    Result = ""
                    ]
                }
            ]

in
    Calendario
