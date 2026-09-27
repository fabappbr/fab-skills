# Cálculo de reposição (código em `src/lib/stock/`)

Tudo calculado no navegador com os dados do app. Quantidades em número; dinheiro em centavos inteiros e exibido com `formatMoney`. "Hoje" é a data local.

## Conferências antes de qualquer conta (tela "Qualidade dos dados", link no topo de Repor agora)

| Conferência | O que a tela faz |
|---|---|
| Saldo negativo | Marca o item "Saldo negativo, conte de novo"; fica fora da sugestão até corrigir |
| Item com venda e sem cadastro de estoque, ou com estoque e sem nenhuma movimentação | Lista pelo nome |
| Códigos iguais com nomes diferentes | Lista para o dono juntar |
| Menos de 28 dias de histórico no app | Aviso geral: a velocidade de 28 dias ainda não é confiável |
| Contagem antiga: `counted_at` com mais de 14 dias em item que vende mais de 1 por dia | "Contagem de dd/mm; conte de novo os que mais saem" |
| Item com `tracks_stock` falso | Fora de todo cálculo |
| Item com `legacy_min` | Mostra "seu mínimo antigo é 24; o calculado é 9" como contexto, nunca como verdade: mínimo cadastrado há anos costuma estar errado |
| Item sem custo | Mostra só unidades e diz "sem custo cadastrado" |
| Item sem fornecedor | Agrupa em "Fornecedor não definido" e pede para escolher |
| Fornecedor sem prazo | Pergunta uma vez ("Quantos dias o fornecedor X leva para entregar?") e grava |

## Dias com estoque

`history.ts` reconstrói o saldo de fim de cada dia andando para trás: saldo de hoje = `on_hand`; saldo de fim do dia anterior = saldo de fim do dia − entradas do dia + saídas e perdas do dia − devoluções do dia − ajustes do dia (com o sinal do ajuste). Dia disponível = saldo positivo em algum momento do dia (use o saldo de início ou de fim maior que zero). Dias sem estoque não entram no divisor.

## As duas velocidades

```
vendido_7  = soma das saídas (type out, is_bulk falso) nos últimos 7 dias, menos as devoluções (type return) cujo sold_on cai nesse período
vendido_28 = o mesmo em 28 dias
v7  = vendido_7  ÷ dias disponíveis nos últimos 7
v28 = vendido_28 ÷ dias disponíveis nos últimos 28
```
Perda (`loss`) e ajuste não são venda. Item com menos de 28 dias desde a primeira movimentação: "Pouco histórico", sem data de ruptura. Menos de 7 dias disponíveis em 28: "Pouco histórico (ficou sem estoque)".

| Padrão | Leitura | O que a linha diz |
|---|---|---|
| v7 perto de v28 | Estável | Planejado na de 28 dias |
| v7 bem maior | Subindo, ou uma venda grande | Se diferem mais de 50%, abrir as vendas da semana e mostrar a maior; venda muito acima do normal vira sugestão "Marcar como atacado pontual" |
| v7 bem menor | Esfriando, ou faltou no meio da semana | Conferir dias sem estoque |
| v7 zero, v28 positiva | Parou ou acabou | Conferir saldo antes de chamar de parado |

```
v_ruptura = max(v7, v28)     // quando acaba: pessimista
v_compra  = v28              // quanto comprar: sóbrio
```
Nunca chamar as duas pelo mesmo nome. Na linha: "Acaba no ritmo de 5,8 por dia; compra no ritmo de 4,1 por dia".

## Cobertura, margem e situação

```
a_caminho = soma de (quantity − quantity_received) das linhas de pedidos sent ou partial
cobertura = (on_hand + a_caminho) ÷ v_ruptura          // em dias
ruptura   = hoje + floor(on_hand ÷ v_ruptura) dias      // data estimada, só com histórico confiável
prazo     = product.lead_time_days ou supplier.lead_time_days
margem    = min(30, max(7, prazo ÷ 2))                   // estoque de segurança em dias
seguranca = margem × v_ruptura                           // estoque de segurança em unidades
ponto_de_pedido = (prazo + margem) × v_ruptura           // em unidades: pedir quando saldo + a caminho chegar aqui
```
A margem tem teto de 30 dias: prazo de 120 dias daria 60 de margem e transformaria o pedido de 60 dias num de 150. Depois de 30, a saída é pedir mais vezes, não pedir mais.

| Condição | Situação | Texto na linha |
|---|---|---|
| cobertura < prazo | Já vai faltar | "Acaba antes de um pedido chegar. Pedir agora diminui a falta, não evita" |
| cobertura < prazo + margem | Pedir agora | "X dias de estoque, entrega em Y dias. É esta semana" |
| cobertura < 45 | Pedir em breve | "Tranquilo por agora; entra no próximo pedido" |
| 45 a 120 | Tudo certo | Sem ação |
| mais de 120 (`overstock_days`) | Estoque demais | Vai para Parados, não para compra |

Velocidade zero não tem cobertura (divisão por zero): pula a escada inteira e vai para Parados, salvo item em temporada informada (vai para "Em observação").

## Quantidade a comprar

```
meta_dias = cover_target_days (60) + prazo
alvo      = meta_dias × v_compra
comprar   = alvo − on_hand − a_caminho
```
Depois:
- Menor ou igual a zero: nada a comprar; item fica em "Tudo certo".
- Arredondar para cima no múltiplo de `pack_size`, salvo quando isso passar de 90 dias de cobertura na `v_compra` (`max_cover_days_on_round`); aí arredondar para baixo e dizer.
- Sem informação do que está a caminho, dizer "considerei que nada está a caminho".
- Custo = `comprar × unit_cost`, com a data do custo ("custo de 12/03").
- Com temporada: aplicar o fator e o limite de fim de temporada de `sazonalidade-e-armadilhas.md`.

## Mínimo do fornecedor

O mínimo vale para o pedido inteiro do fornecedor, não por linha: some as linhas primeiro. Se ainda faltar, mostre as três contas e deixe o dono escolher, nunca complete sozinho:
> "O mínimo da Distribuidora Sul é R$ 1.000,00. O pedido deu R$ 888,00. Para chegar lá: mais 1 caixa de filtro (40 un, R$ 148,00, cerca de 10 dias a mais de estoque). Incluir a caixa, esperar o próximo item vencer ou dividir entre fornecedores?"

## Parados (dinheiro empatado)

- **Sem venda em 28 dias**: `vendido_28 = 0` com saldo > 0. Valor empatado = `on_hand × unit_cost`. Nunca calcular cobertura.
- **Estoque demais**: cobertura > 120 dias; excesso = `on_hand − 120 × v_compra` unidades e em R$.
- **Parado de vez**: nenhuma movimentação de saída em 90 dias (`dead_days`). Sugestão: liquidar, montar kit ou dar desconto.
- Topo da tela: total em R$ parado. Costuma ser o número mais surpreendente do relatório.
- Exceção: item dentro de temporada informada pelo dono vai para "Em observação" com a data de decisão.

## Cada linha mostra a conta

```
Filtro 20x25                         FLT-2025
  Velocidade   4,1/dia (28 dias), 5,8/dia (7 dias), subindo
  Saldo        38 un, nada a caminho
  Acaba em     6 dias no ritmo de 5,8 (38 ÷ 5,8), dd/mm
  Entrega      3 dias (Distribuidora Sul) + 7 de margem
  Situação     PEDIR AGORA
  Compra no    ritmo de 4,1/dia (28 dias); o pico da semana tem só uma semana
  Alvo         258 un = 63 dias (60 + 3) × 4,1
  Comprar      240 un (258 − 38 = 220, arredondado para 6 caixas de 40)
  Custo        R$ 888,00 a R$ 3,70 a unidade (custo de 12/03)
```
Conferência do arredondamento: 38 + 240 = 278 un, cerca de 68 dias a 4,1/dia; abaixo de 90, então arredondar para cima está certo. Com a linha aberta, o dono aprova em segundos ou muda a quantidade ali mesmo.

## Ordem da tela Repor agora

Topo: total em R$ das sugestões e quantos itens acabam antes de o pedido chegar. Depois: Já vai faltar, Pedir agora (ordenados pela data de ruptura), Pedir em breve, Em observação, Pouco histórico, e o link para Parados com o total empatado.
