# Validador de  CPF

## Validação em Liguagem M


|FUNÇÃO CRIADA POR DAVI MARTINS     |
|:---------------------------------:|
|Do Excel para Contabilidade        |
|Data: 04/06/2021                   |
|E-mail: evdaviicm3@gmail.com       |
-------------------------------------
  
Aplicação:

Tipos de Inputs de CPFs aceitos:
056.613.200-19
05661320019
5661320019

Coloque o nome da função como fnValidacaoCpf (ou como desejar)

fnValidacaoCpf([SuaColuna])

Exemplo:
fnValidacaoCpf("056.613.200-19")
Resultado= Válido

Exemplo2 com o segundo parametro opcional informado:
fnValidacaoCpf("056.613.200-10", true)
Resultado= Inválido| Possível: Inválido| Possível: 05661320019

Sem o segundo parametro opcional informado:
fnValidacaoCpf("056.613.200-10")
Resultado= Inválido
![image](https://user-images.githubusercontent.com/31570331/120860689-783f2780-c55c-11eb-8580-a35b41139118.png)

```m
(
    sCpf as any, 
    optional sMostrar as logical
)=>

let
    
    NumeroCpf = Text.Select(Text.From(sCpf), {"0".."9"}),
    CpfTratado = Text.Select(Number.ToText(Number.From(NumeroCpf), "000\.000\.000-00"), {"0".."9"}),
    ListaCpf = List.Transform(Text.ToList(Text.Start(CpfTratado,9)), each Number.From(_)),
    ListaPesos = List.Numbers(10, 9, -1 ),
    PosicoesCpf = List.Positions(ListaCpf),
    
    Verificador1 = 
    Currency.From(11 -
    (Number.Mod(
        List.Accumulate(PosicoesCpf, 0,(state,current)=> state + ListaCpf{current}*ListaPesos{current}) / 11, 1
        ) * 11 
    )),
    
    Resultado1 = if Verificador1 <= 9 then Currency.From(Verificador1) else 0,
    
    ListaCpf2 = List.InsertRange(ListaCpf,9, {Resultado1}),
    ListaPesos2 = List.Numbers(11, 10, -1 ),
    PosicoesCpf2 = List.Positions(ListaCpf2),
        
    Verificador2 = 
    Currency.From(11 -
    (Number.Mod(
        List.Accumulate(PosicoesCpf2, 0,(state,current)=> state + ListaCpf2{current}*ListaPesos2{current}) / 11, 1
        ) * 11 
    )),
    
    Resultado2 = if Currency.From(Verificador2) <= 9 then Currency.From(Verificador2) else 0,
    CpfValido = Text.Start(CpfTratado, 9) & Text.From(Resultado1) & Text.From(Resultado2),
    
    ValidacaoFinal = if CpfValido = CpfTratado then "Válido" else "Inválido"

in

if ValidacaoFinal = "Inválido" and sMostrar = true then
    ValidacaoFinal & "| Possível: " & CpfValido
else
    ValidacaoFinal
```
