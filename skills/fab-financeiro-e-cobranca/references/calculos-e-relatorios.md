# Cálculos e relatórios (código em `src/lib/finance/`)

Tudo em centavos inteiros: `c(v) = Math.round(v * 100)`; volta para reais só ao gravar `money` (`cents / 100`) e ao exibir com `formatMoney`. "Hoje" = data local em `aaaa-mm-dd` (`format(new Date(), 'yyyy-MM-dd')` do `date-fns`). Somas vêm de `list` paginado até a última página, com `fields` só do necessário.

## Orçamento

- Linha: `bruto = qtd × preço_unit`; `linha = bruto − round(bruto × desconto_item / 100)`.
- Subtotal = soma das linhas; `desconto_geral = round(subtotal × discount_pct / 100)`; `total = subtotal − desconto_geral`.
- O desconto em reais é sempre calculado a partir do percentual; nunca digitado ao lado do percentual.
- `total` é gravado no `quote` a cada salvar (cache para listas); a tela sempre mostra o cálculo das linhas.
- Expirado: `status ∈ {draft, sent}` e `valid_until < hoje`.
- Aceitar: grava `status accepted`, `accepted_on = hoje` e cria as faturas com `bulkCreate` (atômico).

## Parcelas

`n` parcelas de `total`: `base = floor(total / n)`, `sobra = total − base × n`; a primeira parcela leva a sobra. Vencimentos: `first_due_date` e depois `addMonths` a cada parcela (mesmo dia; dia 29 a 31 cai no último dia do mês, comportamento do `date-fns`). `installment = "k/n"`. Cada parcela nasce com `amount = price = valor`, `status open`.

## Fatura

```
pago        = soma(payment.amount da fatura)            // estornos são negativos
saldo       = max(0, amount − pago)
invoiceView = canceled  se status == canceled
            = paid      se status == paid ou saldo == 0
            = overdue   se due_date < hoje
            = open
dias_atraso = differenceInCalendarDays(hoje, due_date) quando overdue
```
Faixas: "A vencer" (open), "1 a 30", "31 a 60", "61 a 90", "Mais de 90" dias.

Baixa manual: grava `payment`; recalcula o saldo; atualiza `price = saldo`; se saldo = 0, `status = paid` e `paid_at = agora`. Valor maior que o saldo pede confirmação ("Recebeu R$ 50,00 a mais. Registrar mesmo assim?"). Estorno reabre (`status open`, `price = saldo`).

Cancelar: só com saldo igual ao valor original ou com motivo; `status canceled`, `cancel_reason`. Nunca remover.

## Multa e juros (só com `charge_late_fees`)

`multa = round(saldo × late_fee_pct / 100)` (padrão 2%); `juros = round(saldo × interest_month_pct / 100 × dias_atraso / 30)` (padrão 1% ao mês, proporcional ao dia, sem juros sobre juros). `valor_atualizado = saldo + multa + juros`. Mostrado no rascunho firme e na ficha; a fatura original não muda. Para cobrar o atualizado pelo link, o código atualiza `price` antes de abrir o pagamento e explica isso na tela.

## Recebido no mês

Soma de `payment.amount` com `paid_on` no mês corrente (estornos entram negativos). Quebre por forma de pagamento (`Chart` de barras) e compare com o mesmo mês do ano anterior quando houver dado.

## A receber por faixa

Para cada fatura não paga e não cancelada: soma do saldo por faixa, contagem e maiores devedores (top 5 clientes por saldo vencido). `Chart` de barras por faixa; nunca pizza.

## Faturado

Faturado nos últimos 30 dias e no mês: soma de `amount` das faturas não canceladas por `issued_on`. Vendas do mês: orçamentos aceitos por `accepted_on`, com contagem, total e taxa de aceite (aceitos ÷ enviados).

## Inadimplência

- **Taxa atual** = saldo vencido há mais de 30 dias ÷ saldo total a receber (vencido + a vencer). Mostre em %.
- **Por mês de vencimento** (últimos 6 meses): das faturas que venceram no mês, % do valor que não foi pago até o vencimento, e % que segue em aberto hoje.
- **Clientes reincidentes**: quantos estão em "Atrasa sempre" e quanto devem.

## Previsão de entrada (30, 60, 90 dias)

- Faturas a vencer: saldo por janela de vencimento.
- Vencidas: entram na janela de 30 dias só com promessa em dia (pela data prometida); as demais ficam numa linha separada "Vencido sem data", nunca somadas como certas.
- Mensalidades ativas ainda sem fatura: `monthly_amount` para cada mês da janela.
- Linha "Em risco": saldo de clientes "Atrasa sempre" dentro das janelas, mostrado à parte.
- Cada número diz de onde veio (faturas, promessas, mensalidades).

## Mensalidades e receita recorrente

- MRR = soma de `monthly_amount` dos contratos `active`; ARR = MRR × 12.
- Novos no mês, cancelados no mês (churn em quantidade e em R$), pausados.
- "Gerar faturas do mês": para cada contrato ativo sem fatura com `contract` e `competence = aaaa-mm` (conferir com `count`), prévia com contagem e total; ao confirmar, `bulkCreate` em blocos de até 200 com `due_date` no `due_day` do mês. Rodar duas vezes nunca duplica.
- Assinatura paga pelo cliente dentro do app (`useSubscribe`, só para vender acesso ao próprio app): o registro `subscription` vem da plataforma com `status` (ativa, em atraso, cancelada, teste); o app só lê. "Assinaturas em atraso" = `past_due`.

## Notas fiscais

- Pendentes: faturas `paid` (ou orçamentos aceitos, conforme o dono emite) sem `fiscal_note` `issued`. Lista com botão "Registrar nota".
- Emitidas no mês: contagem e soma por tipo.

## Tela Hoje

`StatCard`: A receber (saldo total), Vencido (saldo vencido, com contagem), Recebido no mês. Listas: "Cobrar hoje" (contagem da fila), "Vencem em 3 dias", "Promessas de hoje", "Mensalidades a gerar" (contratos ativos sem fatura do mês a partir do dia 1).
