let
    DataMin = #date(2020,12,1), // 01/12/2020
    Datamax = Date.EndOfMonth(Date.From(DateTime.LocalNow())), //Data de hoje
    Qtde_Dias = Duration.TotalDays(Datamax-DataMin)+1, //Quantidade de Dias
    Fonte = List.Dates(DataMin,Qtde_Dias,#duration(1,0,0,0)), //Lista de Datas
    Tabela = #table(type table[Data=date, Mes txt = text, Mês=Int8.Type, AnoMes=text, Dia=Int8.Type, Ano = Int16.Type, OrdemAno = Int8.Type],
    List.Transform(Fonte, each {
        _,//data
        Text.Proper(Date.ToText(_,"MMM")),//Mês Texto
        13 - Date.Month(_),//Ordem do Mês Invertido
        Date.ToText(_,"MMyyyy"),//AnoMes
        Date.Day(_),//Dia
        Date.Year(_),//Ano
        Date.Year(DateTime.LocalNow()) - Date.Year(_)// Ordem do Ano Invertido
        }))
in
    Tabela
