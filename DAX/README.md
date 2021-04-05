## Procv no Power BI

```
Procv = LOOKUPVALUE(OutraTabela[Coluna que eu quero];OutraTabela[Coluna Chave];TabelaAtual[Coluna Chave])
```
## Identificar Duplicata
```
Duplicate =
IF (
    COUNTROWS ( FILTER ( Table1; Table1[GUEST] = EARLIER ( Table1[GUEST] ) ) )> 1;"YES";"NO")
```
## Mostrar Somente os Ultimos Meses Selecionados
```
Sales (last n months) =
CALCULATE (
    SUM ( Sales[Sales] );
    DATESINPERIOD ( Date[Date]; MAX ( Date[Date] ); – [N Value]; MONTH )//N Value = Quantos meses será retornado
)
```

## Preencher para baixo com condicional
```PowerBI
IF (
    'Telemetria com Integracao'[Status] = BLANK ();
    CALCULATE (
        LASTNONBLANK ( 
            'Telemetria com Integracao'[Status];
            'Telemetria com Integracao'[Status]
        );
        FILTER (
            ALLEXCEPT ('Telemetria com Integracao');
            'Telemetria com Integracao'[VIATURA] );
            'Telemetria com Integracao'[Data Leitura].[Date] = EARLIER ( 'Telemetria com Integracao'[Data Leitura].[Date] ) 
        );
   'Telemetria com Integracao'[Status]
)
```
