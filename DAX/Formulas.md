## Procv no Power BI

``
Procv = LOOKUPVALUE(OutraTabela[Coluna que eu quero];OutraTabela[Coluna Chave];TabelaAtual[Coluna Chave])
``
## Identificar Duplicata`
``
Duplicate =
IF (
    COUNTROWS ( FILTER ( Table1; Table1[GUEST] = EARLIER ( Table1[GUEST] ) ) )> 1;"YES";"NO")
``
