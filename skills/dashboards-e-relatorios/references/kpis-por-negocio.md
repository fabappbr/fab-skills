# KPIs por tipo de negócio

Use para montar a lista de ~20 métricas do nicho, cortar as de vaidade e escolher 3 a 5 (1 por tema). A fórmula de
cada KPI escolhido vai para `src/lib/metrics.ts` e para o "Como calculamos". "Período" é sempre o período do seletor.

## Temas e KPIs por nicho

**Loja física, e-commerce, delivery**
- Faturamento: soma de `total` dos pedidos com status pago no período.
- Pedidos: `count` de pedidos pagos.
- Ticket médio: faturamento ÷ pedidos pagos (do dado bruto, nunca média de médias).
- Clientes novos: clientes cujo primeiro pedido pago cai no período.
- Taxa de recompra: clientes com 2 ou mais pedidos pagos ÷ clientes com pedido pago (janela de 365 dias).
- Produtos mais vendidos (ranking por valor e por quantidade); itens por pedido.
- Desconto médio: soma dos descontos ÷ soma do valor antes do desconto; % de pedidos com desconto.
- Cancelamentos e devoluções: `count` com status cancelado ÷ pedidos do período.
- Delivery: tempo médio de preparo e de entrega; pedidos atrasados (operacional).

**Salão, barbearia, clínica, estúdio (agenda)**
- Faturamento por atendimento realizado.
- Ocupação da agenda: horas agendadas ÷ horas disponíveis (da `availability`).
- Faltas: agendamentos com status "não compareceu" ÷ agendamentos do período.
- Clientes que voltaram: clientes com novo agendamento até 60 dias depois do anterior.
- Clientes sumidos: último atendimento há mais de 60 dias (lista de ação para chamar de volta).
- Ranking de serviços e de profissionais por faturamento.
- Ticket médio por atendimento.

**Academia, curso, assinatura, clube**
- Receita recorrente mensal (MRR): soma das assinaturas ativas normalizada para o mês (mensal = valor; trimestral =
  valor ÷ 3; anual = valor ÷ 12). Escreva essa normalização no "Como calculamos": é a causa mais comum de "o número
  do painel não bate com o do financeiro".
- Assinantes ativos, novos e cancelados no período.
- Cancelamento (churn): cancelados no mês ÷ ativos no início do mês.
- Frequência: check-ins ou aulas concluídas por aluno ativo; alunos sem frequência há 14 dias (lista de ação).
- Coortes por MÊS de entrada (agrupar por dia gera coortes pequenas demais para mostrar tendência).

**Prestador de serviço, orçamento, CRM de vendas**
- Orçamentos enviados, aprovados e taxa de aprovação (aprovados ÷ decididos no período).
- Valor em aberto no funil por etapa (ranking na ordem das etapas, com contagem e valor).
- Negócios que fecham nos próximos 7 dias; negócios mexidos nas últimas 24 h (briefing diário).
- Ganhos e perdidos no período; taxa de ganho por vendedor (ganhos ÷ fechados, por vendedor, ordenado pelo valor ganho).
- Receita ganha por mês de fechamento.
- Ciclo de venda: dias entre a criação e o fechamento, em mediana.
- Negócios em risco: data prevista de fechamento já passou e ainda estão abertos.

**Financeiro e caixa (qualquer nicho)**
- Entradas, saídas e saldo do período; saldo projetado com contas a pagar e a receber dos próximos 30 dias.
- Margem bruta: (receita - custo da mercadoria) ÷ receita.
- Contas a receber vencidas, por faixa (1 a 30, 31 a 60, mais de 60 dias).
- Despesas por categoria (ranking); despesa sobre receita.
- Prazo médio de recebimento.

**App ou produto digital do dono**
- Usuários ativos por dia e por mês; ativação (fez a ação principal na 1ª semana); retenção por coorte mensal;
  satisfação (nota de 0 a 10 guardada como `number`, NPS = % de notas 9 e 10 menos % de notas 0 a 6).

**Marketing do próprio negócio**
- Contatos (leads) recebidos, por canal; conversão de contato em cliente; custo por cliente quando o dono lança o
  gasto de anúncio num modelo próprio.

Métricas de vaidade para cortar: total de cadastrados desde sempre, visitas sem conversão, seguidores, curtidas,
"acessos ao app".

## Quando o painel está verde e o cliente reclama

O painel mede o sistema e não o que o cliente sente. Coloque ao lado da métrica interna uma métrica percebida pelo
cliente: pedidos entregues no prazo, tempo de espera, reclamações abertas, avaliações baixas (`review`).

## Árvore de KPI de e-commerce (o detalhamento natural do faturamento)

```
Faturamento R$ X (vs período anterior: +X%)
├── Clientes novos: R$ X (X% do total)
│   ├── Quantidade de clientes novos (+X%)
│   └── Ticket médio de cliente novo (+X%)
└── Clientes que voltaram: R$ X (X% do total)
    ├── Quantidade de clientes que voltaram (+X%)
    ├── Ticket médio de quem voltou (+X%)
    └── Taxa de recompra (janela de 365 dias)
```

No app, a árvore é uma tela de detalhamento: cada nó é uma linha com valor, variação e o selo de saúde (texto +
ícone: "Saudável", "Atenção", "Problema"). O selo de um nó é o pior resultado entre as checagens ligadas a ele.

Decomposição da variação do faturamento (frase de uma linha abaixo da árvore): efeito volume (pedidos a mais ou a
menos × ticket anterior), efeito ticket (diferença de ticket × pedidos atuais) e efeito mistura (mudança na
proporção novos e recorrentes). "Cresceu por volume" ou "cresceu por preço" é a primeira pergunta do dono.

Horizontes padrão: pulso de 30 dias (só alarmes), momento de 90 dias (a análise principal), estrutura de 365 dias
(o quadro geral). Mês de calendário ("como foi agosto") usa o mês fechado, não os últimos 30 dias.

## Faixas de saúde (saudável, atenção, problema)

Referenciais iniciais de lojas online; o dono pode ajustar cada limite na tela de metas. Sem nota numérica, sem letra,
sem "saúde 78%": só os três estados.

| Checagem | Saudável | Atenção | Problema |
|---|---|---|---|
| Faturamento mês contra mês (mesmo intervalo) | subindo 3 meses seguidos | entre -5% e 0% | queda maior que 5%, ou 3 meses de queda |
| Pedidos mês contra mês | acima de -5% | -10% a -5% | abaixo de -10% |
| Ticket médio | queda menor que 5% | queda de 5% a 10% | queda maior que 10% |
| Receita de clientes que voltaram | acima de 30% | 20% a 30% | abaixo de 20% |
| Taxa de recompra (1ª para 2ª compra) | acima de 25% | 15% a 25% | abaixo de 15% |
| Dias até a 2ª compra (mediana) | menos de 60 | 60 a 90 | mais de 90 |
| Desconto médio | abaixo de 15% e estável | 15% a 25%, ou subindo 1 a 2 p.p. por mês | acima de 25%, ou subindo mais de 2 p.p. por mês |
| Pedidos com desconto | abaixo de 40% | 40% a 60% | acima de 60% |
| 10% dos clientes com mais compras | menos de 60% da receita | 60% a 80% | mais de 80% |
| Maior pedido do período | menos de 5% da receita | 5% a 10% | mais de 10% |
| Pedidos com 2 ou mais itens | acima de 25% | 15% a 25% | abaixo de 15% |
| Produtos com pelo menos 1 venda | acima de 70% do catálogo ativo | 50% a 70% | abaixo de 50% |
| Variação diária do faturamento (desvio ÷ média) | abaixo de 0,5 | 0,5 a 0,8 | acima de 0,8 |

Referências por setor (taxa de recompra saudável): alimentos e bebidas 40% ou mais; beleza e bem-estar 30%; moda 25%;
casa 15%; eletrônicos 12%. Negócio de consumo recorrente naturalmente tem recompra alta; bem durável, baixa.

Segmentos de clientes para listas de ação (recência, frequência, valor): campeões (compraram há pouco, muitas vezes,
muito valor), fiéis (compram com regularidade), novos (compraram há pouco pela 1ª vez), em risco (compravam muito e
sumiram), perdidos (sumiram há muito e compravam pouco). A lista "em risco" é a mais útil para o dono: é quem ligar
esta semana.

Temas que aparecem juntos (sinal de problema estrutural, não ruído): descontos subindo + faturamento parado = venda
comprada com desconto; recompra baixa + clientes em risco + 2ª compra demorada = motor de clientes fraco; poucos
clientes ou poucos produtos com a maior parte da receita = negócio frágil. Mencione o tema quando 2 ou 3 checagens do
grupo estiverem em atenção ou problema ao mesmo tempo; um sinal isolado é só um sinal.

## Achado bem escrito (para o resumo e o relatório)

Três partes, uma frase cada:
- **O que é:** o fato com número. "O faturamento do ano cresceu 25,7%."
- **Por que importa:** a tensão, com dado, usando "mas", "apesar de". "Mas a fatia dos clientes novos continua em
  42%: o crescimento veio só do ticket de quem já compra."
- **O que fazer:** a direção em uma frase, com verbo concreto. "Direcione parte da verba de fidelidade para trazer
  clientes novos."

Proibido no "o que fazer": "considerar", "melhorar", "otimizar", "explorar", "avaliar". Proibido no "por que importa":
preocupação abstrata sem número ("o crescimento precisa ser validado").

Proporção: cerca de 80% confirma o que o dono já sente (gera confiança) e 20% surpreende (gera ação). No máximo 5 a 7
achados num relatório; o mesmo achado não se repete em dois horizontes.

## Limites contra efeito colateral (guardrails)

Toda ação proposta vem com 2 ou 3 métricas que não podem piorar enquanto ela é feita:

| Se o foco é | Vigie |
|---|---|
| Aumentar faturamento | desconto médio, margem |
| Trazer clientes novos | custo por cliente |
| Aumentar ticket | número de pedidos |
| Reduzir desconto | faturamento, pedidos |
| Reduzir faltas | ocupação da agenda |

## Alertas que ninguém lê

Limiar fixo definido uma vez dispara sempre e o dono passa a ignorar. Prefira limiar relativo à própria história do
negócio: alerta quando o valor se afasta mais de 2 desvios da média das últimas 8 semanas (calculado no código do
app), e só quando há dados suficientes para ter média.
