# DAX

Sumario
[Performance](#Performance)
* [Performance](#FirstNonBlank-ou-LastNonBlank)
* [Filter vs KeepFilters](#Filter-Vs-KeepFilters)
[Formulas](#Formulas)
* [Procv no Power BI](#Procv-no-Power-BI)
* [Identificar Duplicata](#Identificar-Duplicata)
* [Mostrar Somente os Ultimos Meses Selecionados](#Mostrar-Somente-os-Ultimos-Meses-Selecionados)
* [Preencher para baixo com condicional](#Preencher-para-baixo-com-condicional)

## Performance

### FirstNonBlank ou LastNonBlank

FirstNonBlank ou LastNonBlank:
```dax
VAR primeiro =
CALCULATE(
    MAX('Delta KM'[Data Anterior]),
    FIRSTNONBLANK(
        'Delta KM'[Data Anterior],
         CALCULATE(min('Delta KM'[Km Anterior]))
    )
)
VAR ultimo =
CALCULATE(
    MAX('Delta KM'[Data Anterior]),
    LASTNONBLANK(
        'Delta KM'[Data da Transação],
         CALCULATE(min('Delta KM'[Km Anterior]))
    )
)
     
```
MAX e <> BLANK() :
```dax
VAR primeiro =
CALCULATE(
    MIN('Delta KM'[Data Anterior]),
    'Delta KM'[Data Anterior] <> BLANK()
)
VAR ultimo =
CALCULATE(
    MAX('Delta KM'[Data Anterior]),
    'Delta KM'[Data Anterior] <> BLANK()
)
     
```

![image](https://user-images.githubusercontent.com/31570331/120122335-91bc2a00-c17e-11eb-9435-3b8026c9c395.png)

### Filter Vs KeepFilters

FILTER:
```dax
CALCULATE(
    [Qtd de Reclamacoes],
    FILTER(
        VALUES(reclamacoes_contexto[CanalEntrada]),
        reclamacoes_contexto[CanalEntrada] in {"CALL CENTER","SIC","SEI","SOA"}
    )
)
```
KEEPFILTERS:
```dax
CALCULATE(
    [Qtd de Reclamacoes],
    KEEPFILTERS(reclamacoes_contexto[CanalEntrada] in {"CALL CENTER","SIC","SEI","SOA"})
)   
```

![Filter vs KeepFilter](https://user-images.githubusercontent.com/31570331/120124305-31cb8080-c18a-11eb-95c9-bcdb4fed032c.png)


## Formulas

### Procv no Power BI

```DAX
VAR Primeiro =
Procv = LOOKUPVALUE(OutraTabela[Coluna que eu quero];OutraTabela[Coluna Chave];TabelaAtual[Coluna Chave])
```

### Identificar Duplicata

```DAX
Duplicate =
IF (
    COUNTROWS ( FILTER ( Table1; Table1[GUEST] = EARLIER ( Table1[GUEST] ) ) )> 1;"YES";"NO")
```

### Mostrar Somente os Ultimos Meses Selecionados

```DAX
Sales (last n months) =
CALCULATE (
    SUM ( Sales[Sales] );
    DATESINPERIOD ( Date[Date]; MAX ( Date[Date] ); – [N Value]; MONTH )//N Value = Quantos meses será retornado
)
```

### Preencher para baixo com condicional

```Dax
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

### Testando a performance do distinct query
https://www.sqlbi.com/articles/analyzing-distinctcount-performance-in-dax/
https://youtu.be/7SwD6953G6s
