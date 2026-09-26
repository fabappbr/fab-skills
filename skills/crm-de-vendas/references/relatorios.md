# Relatórios e KPIs

## Como somar sem errar

- O servidor só conta (`count`). Toda soma, média, mediana e agrupamento é feita no cliente em `src/lib/crm/metrics.ts`, depois de **paginar tudo** o que o filtro devolve (laço com `limit` 200 e `offset` até vir menos que o limite). Uma página cheia quase sempre está cortada: nunca some uma página só.
- Filtro de período e escopo vai no servidor (`closed_at` com `gte`/`lt`, `seller`, `status`); o agrupamento vem depois.
- Dinheiro somado em centavos inteiros (`Math.round(v * 100)`) e mostrado com `formatMoney`. Percentual com uma casa (`12,5%`).
- Nomes de vendedor pelo `seller__label` que o `ref` já traz; sem dono aparece como "Sem dono".
- Base grande (mais de 5.000 negócios): o relatório carrega por período e avisa quando o período é longo; se ainda pesar, numa mudança depois o agente cria um modelo de resumo mensal gravado por função de backend (exige o mesmo plano pago que libera o CLI).
- Cada número tem o filtro que o gerou visível ("Negócios ganhos de 01/09/2026 a 30/09/2026, equipe toda"). Vazio aparece como "sem dados no período", nunca 0 inventado.

## Gráficos

`StatCard` para números únicos; barras (`Chart` de `@/components/ui/chart`) para comparação entre etapas, vendedores, meses, origens e motivos; linha para tendência mensal. Sem pizza nem rosca (comparar fatias é difícil). Cores só do tema. Toda barra tem o valor escrito.

## Painel de vendas (tela Relatórios, abas)

**Funil agora**
- Por etapa: quantidade, soma de `amount`, soma ponderada (`amount × probabilidade`), dias médios na etapa.
- Por vendedor: quantidade e valor aberto, ordenado pelo valor.
- Previsão do mês e do trimestre por categoria (Ganho, Compromisso, Melhor cenário, Funil), com a regra de compromisso de `pipeline-e-etapas.md`.

**Ganhos e perdas (período escolhido, padrão mês atual)**
- Ganhos: quantidade, soma de `final_amount`. Perdidos: quantidade, soma de `amount`.
- Taxa de ganho = ganhos ÷ (ganhos + perdidos) fechados no período, geral e por vendedor, ordenada pelo valor ganho: "Carla: 8 de 20, 40%, R$ 96.000,00".
- Receita por mês de fechamento (últimos 12 meses, pelo `closed_at`), sem misturar expansão e renovação com cliente novo (filtro por `deal_type`).
- Motivos de perda em ranking, com a etapa em que morreu (última etapa aberta no `stage_history`) e concorrentes citados.
- Receita e taxa de ganho por origem: de onde vêm os melhores clientes.
- Ticket médio (ganhos ÷ quantidade) e ciclo médio (dias de `created_at` a `closed_at` dos ganhos).

**Velocidade e conversão**
- Conversão entre etapas no mês, comparada à média dos 3 meses anteriores; queda de mais de 10 pontos ganha aviso.
- Dias por etapa (mediana), para achar onde o negócio empaca.
- Tempo até a primeira resposta a lead (mediana) e lead mais antigo esperando; leads por grupo (quente, qualificado, incerto, fora).
- Resultado das ligações (distribuição dos 6 resultados), exibida só com 50 ou mais conversas no período; abaixo disso, "ainda poucas conversas para tirar conclusão".

**Carteira e qualidade dos dados**
- Por vendedor: contatos, negócios abertos, valor aberto, tarefas vencidas, negócios sem próximo passo.
- Registros sem dono (contatos, empresas, negócios).
- Completude: % de negócios abertos com valor, com data de fechamento futura, com próximo passo em dia, com mais de uma pessoa; % de contatos com telefone válido e origem.
- Cobertura do ciclo de vida: contatos por `lifecycle` e conversão Lead → Oportunidade → Cliente no período.

**Pós-venda (com o módulo)**
- Clientes em risco por cor; renovações nos próximos 90 dias com valor; expansões abertas.

## Resumo diário (números do Hoje)

- Negócios que fecham nos próximos 7 e 14 dias (`expected_close` entre hoje e hoje + N, abertos).
- Negócios alterados nas últimas 24 h (pelo `stage_history` e atividades), para o gestor.
- Funil aberto: "Funil aberto: 23 negócios, R$ 412.300,00".

## Revisão semanal

Aba "Revisão da semana" com as cinco listas de `pipeline-e-etapas.md` (novos sem critério, parados, compromisso em risco, sem próximo passo, fechamento adiado mais de uma vez pelo `audit_log` de mudança de data), cada item abrindo a ficha.

## Exportar

Toda tabela de relatório tem "Baixar CSV" com as mesmas colunas da tela e o filtro no nome do arquivo (`ganhos-2026-09.csv`), gravando `audit_log` exportar.
