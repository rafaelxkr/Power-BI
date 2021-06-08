(StartDate as date, EndDate as date, optional Today as date, optional FiscalYearEndingMonth as number) =>
let
        /*
        ****This Calendar was created and provided by Avi Singh****
        ****This can be freely shared as long as this text comment is retained.****
        http://www.youtube.com/PowerBIPro
        www.LearnPowerBI.com by Avi Singh
        *///Edited to create a function by Christopher Hastings on 5/21/2019
        CurrentDate = if Today = null then DateTime.Date(DateTime.FixedLocalNow()) else Today,
        FiscalYearEndMonth = if FiscalYearEndingMonth = null then 6 else FiscalYearEndingMonth,
        ListDates = List.Dates(StartDate, Number.From(EndDate - StartDate)+1, #duration(1,0,0,0)),
        #"Converted to Table" = Table.FromList(ListDates, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Renamed Columns as Date" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Date"}}),
        // As far as Power BI is concerned, the 'Date' column is all that is needed :-) But we will continue and add a few Human-Friendly Columns
        #"Changed Type to Date" = Table.TransformColumnTypes(#"Renamed Columns as Date",{{"Date", type date}}),
        #"Added Calendar MonthNum" = Table.AddColumn(#"Changed Type to Date", "MonthNum", each Date.Month([Date]), Int64.Type),
        #"Added Month Name" = Table.AddColumn(#"Added Calendar MonthNum", "Month", each Text.Start(Date.MonthName([Date]),3), type text),
        #"Added Month Name Long" = Table.AddColumn(#"Added Month Name", "MonthLong", each Date.MonthName([Date]), type text),
        #"Added Calendar Quarter" = Table.AddColumn(#"Added Month Name Long", "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date]))),
        #"Added Calendar Year" = Table.AddColumn(#"Added Calendar Quarter", "Year", each Date.Year([Date]), Int64.Type),
        #"Added FiscalMonthNum" = Table.AddColumn(#"Added Calendar Year", "FiscalMonthNum", each if [MonthNum] > FiscalYearEndMonth then [MonthNum] - FiscalYearEndMonth else [MonthNum] + (12 - FiscalYearEndMonth), type number),
        #"Added FiscalMonth Name" = Table.AddColumn(#"Added FiscalMonthNum", "FiscalMonth", each [Month]),
        #"Added FiscalMonth Name Long" = Table.AddColumn(#"Added FiscalMonth Name", "FiscalMonthLong", each [MonthLong]),
        #"Added FiscalQuarter" = Table.AddColumn(#"Added FiscalMonth Name Long", "FiscalQuarter", each "FQ" & Text.From(Number.RoundUp([FiscalMonthNum] / 3,0))),
        #"Added FiscalYear" = Table.AddColumn(#"Added FiscalQuarter", "FiscalYear", each "FY" & Text.End( Text.From( if [MonthNum] > FiscalYearEndMonth then [Year] + 1 else [Year]), 2)),
        // Can be used to for example to show the past 3 months(CurMonthOffset = 0, -1, -2)
        #"Added CurMonthOffset" = Table.AddColumn(#"Added FiscalYear", "CurMonthOffset", each ( Date.Year([Date]) - Date.Year(CurrentDate) ) * 12 + Date.Month([Date]) - Date.Month(CurrentDate), Int64.Type),
        // Can be used to for example to show the past 3 quarters (CurQuarterOffset = 0, -1, -2)
        #"Added CurQuarterOffset" = Table.AddColumn(#"Added CurMonthOffset", "CurQuarterOffset", each /*Year Difference*/( Date.Year([Date]) - Date.Year(CurrentDate) )*4 /*Quarter Difference*/+ Number.RoundUp(Date.Month([Date]) / 3) - Number.RoundUp(Date.Month(CurrentDate) / 3), Int64.Type),
        // Can be used to for example to show the past 3 years (CurYearOffset = 0, -1, -2)
        #"Added CurYearOffset" = Table.AddColumn(#"Added CurQuarterOffset", "CurYearOffset", each Date.Year([Date]) - Date.Year(CurrentDate), Int64.Type),
        // Can be used to for example filter out all future dates
        #"Added FutureDate Flag" = Table.AddColumn(#"Added CurYearOffset", "FutureDate", each if [Date] > CurrentDate then "Future" else "Past" ),
        // FiscalYearOffset is the only Offset that is different.
        // FiscalQuarterOffset = is same as CurQuarterOffset
        // FiscalMonthOffset = is same as CurMonthOffset
        #"Filtered Rows to CurrentDate" = Table.SelectRows(#"Added FutureDate Flag", each ([Date] = CurrentDate)),
        CurrentFiscalYear = #"Filtered Rows to CurrentDate"{0}[FiscalYear],
        #"Added CurFiscalYearOffset" = Table.AddColumn(#"Added FutureDate Flag", "CurFiscalYearOffset", each Number.From(Text.Range([FiscalYear],2,2)) - Number.From(Text.Range(CurrentFiscalYear,2,2))  /*Extract the numerical portion, e.g. FY18 = 18*/),
        // Used as 'Sort by Column' for MonthYear columns
        #"Added MonthYearNum" = Table.AddColumn(#"Added CurFiscalYearOffset", "MonthYearNum", each [Year]*100 + [MonthNum] /*e.g. Sep-2016 would become 201609*/, Int64.Type),
        #"Added MonthYear" = Table.AddColumn(#"Added MonthYearNum", "MonthYear", each [Month] & "-" & Text.End(Text.From([Year]),2)),
        #"Added MonthYearLong" = Table.AddColumn(#"Added MonthYear", "MonthYearLong", each [Month] & "-" & Text.From([Year])),
        #"Added WeekdayNum" = Table.AddColumn(#"Added MonthYearLong", "WeekdayNum", each Date.DayOfWeek([Date]), Int64.Type),
        #"Added Weekday Name" = Table.AddColumn(#"Added WeekdayNum", "Weekday", each Text.Start(Date.DayOfWeekName([Date]),3), type text),
        #"Added WeekdayWeekend" = Table.AddColumn(#"Added Weekday Name", "WeekdayWeekend", each if [WeekdayNum] = 0 or [WeekdayNum] = 6 then "Weekend" else "Weekday"),
        #"Filtered Rows Sundays Only (Start of Week)" = Table.SelectRows(#"Added WeekdayWeekend", each ([WeekdayNum] = 0)),
        #"Added Index WeekSequenceNum" = Table.AddIndexColumn(#"Filtered Rows Sundays Only (Start of Week)", "WeekSequenceNum", 2, 1),
        #"Merged Queries Ultimate Table to WeekSequenceNum" = Table.NestedJoin(#"Added WeekdayWeekend",{"Date"},#"Added Index WeekSequenceNum",{"Date"},"Added Index WeekNum",JoinKind.LeftOuter),
        #"Expanded Added Index WeekNum" = Table.ExpandTableColumn(#"Merged Queries Ultimate Table to WeekSequenceNum", "Added Index WeekNum", {"WeekSequenceNum"}, {"WeekSequenceNum"}),
        // somehow it ends up being unsorted after Expand Column, should not matter for the end table, but makes it harder to debug and check everything is correct. Thus sorting it.
        #"ReSorted Rows by Date" = Table.Sort(#"Expanded Added Index WeekNum",{{"Date", Order.Ascending}}),
        #"Filled Down WeekSequenceNum" = Table.FillDown(#"ReSorted Rows by Date",{"WeekSequenceNum"}),
        #"Replaced Value WeekSequenceNum null with 1" = Table.ReplaceValue(#"Filled Down WeekSequenceNum",null,1,Replacer.ReplaceValue,{"WeekSequenceNum"}),
        #"Inserted Start of Week (WeekDate)" = Table.AddColumn(#"Replaced Value WeekSequenceNum null with 1", "WeekDate", each Date.StartOfWeek([Date]), type date),
        Current_WeekSequenceNum = #"Inserted Start of Week (WeekDate)"{[Date = CurrentDate]}?[WeekSequenceNum],
        #"Inserted Day of Year" = Table.AddColumn(#"Inserted Start of Week (WeekDate)", "Day of Year", each Date.DayOfYear([Date]), Int64.Type),
        #"Added Flag_YTD" = Table.AddColumn(#"Inserted Day of Year", "Flag_YTD", each if Date.DayOfYear([Date]) <= Date.DayOfYear(CurrentDate) then "YTD" else null),
        #"Added Flag_MTD" = Table.AddColumn(#"Added Flag_YTD", "Flag_MTD", each if Date.Day([Date]) <= Date.Day(CurrentDate) then "MTD" else null),
        #"Added Flag_QTD" = Table.AddColumn(#"Added Flag_MTD", "Flag_QTD", each /*Compare Month Number in Quarter (1,2,3) for [Date] and CurrentDate*/ if Number.Mod(Date.Month([Date])-1, 3) + 1 <= Number.Mod(Date.Month(CurrentDate)-1, 3) + 1 then "QTD" else null),
        #"Added CurrentDayOffset" = Table.AddColumn(#"Added Flag_QTD", "CurrentDayOffset", each [Date] - CurrentDate),
        #"Changed Type" = Table.TransformColumnTypes(#"Added CurrentDayOffset",{{"CurrentDayOffset", Int64.Type}})
    in
        #"Changed Type"
