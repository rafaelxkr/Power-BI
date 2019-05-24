let
    fnGenerateCalendar = let 
    fn = (FirstDate as date, LastDate as date, optional CurrentDate as date) => let
        Today = if CurrentDate = null then DateTime.Date(DateTime.LocalNow()) else CurrentDate,
        #"Count of Days" = Duration.Days(LastDate-FirstDate) +1,
        #"Generate Dates" = List.Dates(FirstDate,#"Count of Days",#duration(1,0,0,0)),
        #"Converted to Table" = Table.FromList(#"Generate Dates", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Date"}}),
        YearColumn = Table.AddColumn(#"Renamed Columns", "Year", each Date.Year([Date])),
        MonthColumn = Table.AddColumn(YearColumn, "Month", each Date.MonthName([Date])),
        MonthNameColumn = Table.AddColumn(MonthColumn, "Month Number", each Date.Month([Date])),
        CurrentMonthOffset = Table.AddColumn(MonthNameColumn, "CurMonthOffset", each ( Date.Year([Date]) - Date.Year(Today) ) * 12 + Date.Month([Date]) - Date.Month(Today), Int64.Type),
        CurrentDateOffset = Table.AddColumn(CurrentMonthOffset, "CurrentDayOffset", each Duration.Days([Date] - Today)),
        #"Changed Type" = Table.TransformColumnTypes(CurrentDateOffset,{{"Date", type date}, {"Year", Int64.Type}, {"Month", type text}, {"Month Number", Int64.Type}, {"CurMonthOffset", Int64.Type}, {"CurrentDayOffset", Int64.Type}})
    in
        #"Changed Type",

    fnMeta = type function 
        (
            FirstDate as list,
            LastDate as list,
            optional CurrentDate as list
        ) as list meta 
            [
                Documentation.Name = "fnGenerateCalendar",
                Documentation.Author = "Christopher Hastings",
                Documentation.CreationDate = Date.FromText("5/20/2019"),
                Documentation.LongDescription = "This function returns a table with Date, Year, Month, Month Number, CurrentMonthOffset, and CurrentDateOffset for the dates between FirstDate and LastDate. Designed by, Christopher Hastings 5/20/2019",
                Documentation.Examples =
                {
                    [
                        Description = "This function returns a calendar table",
                        Code = "fnGenerateCalendar(1/12/1998, 1/16/1998, 1/14/1998)",
                        Result = "#table({""Date"", ""Year"", ""Month"", ""Month Number"", ""CurrentMonthOffset"", ""CurrentDateOffset""},#(cr)#(lf)    {{#date(1998,1,12),1998,""January"",1,0,-2},#(cr)#(lf)    {#date(1998,1,13),1998,""January"",1,0,-1},#(cr)#(lf)    {#date(1998,1,14),1998,""January"",1,0,0},#(cr)#(lf)    {#date(1998,1,15),1998,""January"",1,0,1},#(cr)#(lf)    {#date(1998,1,16),1998,""January"",1,0,2}})"
                    ]
                }
            ]
in 
    Value.ReplaceType(fn, fnMeta)
in
    fnGenerateCalendar
