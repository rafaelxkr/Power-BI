## Procv no Power BI

``
Procv = LOOKUPVALUE(OutraTabela[Coluna que eu quero];OutraTabela[Coluna Chave];TabelaAtual[Coluna Chave])
``
## Identificar Duplicata
``
Duplicate =
IF (
    COUNTROWS ( FILTER ( Table1; Table1[GUEST] = EARLIER ( Table1[GUEST] ) ) )> 1;"YES";"NO")
``
## Mostrar Somente os Ultimos Meses Selecionados
``
Sales (last n months) =
CALCULATE (
    SUM ( Sales[Sales] );
    DATESINPERIOD ( Date[Date]; MAX ( Date[Date] ); – [N Value]; MONTH )//N Value = Quantos meses será retornado
)
``
