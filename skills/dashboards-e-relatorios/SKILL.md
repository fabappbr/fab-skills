---
name: dashboards-e-relatorios
description: "Painel e relatório que ajudam o dono a decidir: 3 a 5 números certos, cada um comparado com o mês passado ou com a meta, gráfico escolhido pela pergunta (nada de pizza), resumo em português simples no topo, definição de cada métrica à vista, proteção contra número enganoso (mês pela metade, fuso, poucos dados) e relatório semanal ou mensal que chega sozinho com link. Use quando o dono pedir painel, dashboard, relatório, indicadores, KPI, métricas, visão geral do negócio, números do mês, faturamento por período, gráfico de vendas, fechamento do mês, resumo semanal, metas, ranking de produtos ou vendedores, painel da recepção, 'quanto vendi', 'me manda os números toda segunda' (cobrança fica com financeiro-e-cobranca). Vale para loja, delivery, salão, clínica, academia, serviço, CRM e e-commerce. Use também ao editar um painel que ninguém entende ou com número que não bate. Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli)."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Dashboards e Relatórios
  edition: terminal
---

# Dashboards e Relatórios

Um painel é uma ferramenta de decisão, não uma tela bonita. Cada número existe para o dono agir: cobrar, comprar,
cortar, ligar, manter. Esta skill fecha as decisões de conteúdo, cálculo e leitura do painel; cor e fonte continuam
vindo da marca do app.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
`references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então
comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`https://api.fabapp.ai/llms-full.txt` discordarem sobre
a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Três regras valem sempre:

1. **Número sai do código do app, nunca do modelo.** O servidor só faz `count()`. Somas, médias e agrupamentos são
   calculados no código a partir de `list` paginado (ou numa função de backend, ou num modelo de resumo). A IA do app
   (`invokeLLM`) pode escrever o texto do resumo, mas recebe os números prontos e não cria nenhum.
2. **Nenhum KPI sem comparação.** Um número sozinho está inacabado. Todo cartão mostra valor, variação, o referencial
   da variação e tendência curta.
3. **Não desenhe o que uma frase ou uma tabela resolve.** Gráfico só entra quando revela forma, tendência ou ranking.

Leia as referências de `references/` antes da parte que as cita: `escolha-de-grafico.md` (pergunta para gráfico e as receitas de componente),
`kpis-por-negocio.md` (KPIs por nicho, árvore de e-commerce, faixas de saúde), `armadilhas-de-metrica.md` (números
enganosos e como o código se protege), `tufte-na-tela.md` (o que tirar, texto em volta) e `relatorio-recorrente.md`
(relatório que chega sozinho, narrativa, plano de ação).

## A conversa: a entrevista antes de desenhar

Painel desenhado sem saber quem olha vira mural de números. Antes do plano, descubra quem olha, com que frequência e
que decisão toma. Pule a pergunta que as palavras do dono já responderam; o resto você decide e registra como
suposição. Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code,
AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas.

**Perguntas principais (quem, quando, para quê):**

1. "Quem vai olhar esses números?"
   - Eu, o dono, para acompanhar o negócio (Recomendado)
   - A equipe no dia a dia (recepção, balcão, vendedores)
   - Os dois, cada um com a sua tela
   - Um sócio ou investidor
2. "Com que frequência você quer olhar?" (recomende conforme a resposta 1: dono = semana; equipe = dia)
   - Toda semana (Recomendado)
   - Todo dia, logo que abro o negócio
   - Uma vez por mês, no fechamento
3. "Que decisão você quer tomar olhando o painel?" (múltipla escolha, com "outro"; adapte as opções ao nicho usando
   `kpis-por-negocio.md`). Exemplo para loja:
   - Saber se vou bater a meta do mês (Recomendado)
   - Onde estou perdendo dinheiro
   - O que comprar de estoque
   - Quem cobrar ou quem chamar de volta

**Perguntas extras (só se a resposta anterior deixar dúvida que muda o número):**

4. "Quando uma venda conta no faturamento?"
   - Quando o cliente paga (Recomendado)
   - Quando o pedido é feito
   - Quando é entregue ou o serviço é feito
5. "Você tem uma meta por mês?"
   - Não, compare com o mês passado (Recomendado)
   - Sim, quero cadastrar a minha meta no app
6. "Quer receber um resumo sem precisar abrir o app?"
   - Sim, um aviso toda segunda de manhã com o link do relatório da semana (Recomendado)
   - Sim, no dia 1 de cada mês com o fechamento
   - Sim, todo dia de manhã
   - Não precisa

Se a resposta 1 for "equipe", o painel é operacional (lista do que fazer agora), não um painel de números do mês;
se for "os dois", são duas telas separadas. Nunca misture os papéis na mesma tela.

**Marca:** quando o painel é o centro do app, a cor `primary` do `theme` em `apps/<slug>/fab.config.json` (que
você grava com o dono e envia com `fabapp push`; chaves em `references/fabapp-cli.md`) não deve ser vermelho nem
verde puros, porque
essas cores ficam reservadas para "fora da meta" e "dentro da meta". Prefira azul, grafite, roxo ou a cor da marca
do dono quando não colidir.

**O que sai da conversa:** anote em `DECISOES.md` a especificação do painel em frases: quem olha, cadência, decisão, papel do painel
(estratégico, tático ou operacional), a definição de venda escolhida, se há meta, e a cadência do relatório. Nas
suposições do plano, o que você decidiu sozinho (período padrão, KPIs escolhidos). Não fale de tecnologia com o dono.

## O plano: especificação do painel

O plano é um texto que você escreve e mostra ao dono antes de codar; ele aprova antes da construção. Escreva nele
uma seção "Painel" com os itens abaixo, como decisões fechadas, mais as telas, o modelo de dados de
`fab.schema.json`, as suposições com alternativa e o que não entra.

**1. Papel e camadas.** Um painel tem um papel só:

| Nível | Quem | Cadência | KPIs | Pergunta |
|---|---|---|---|---|
| Estratégico | dono, sócio | mês, trimestre | 3 a 5 | O negócio está saudável e vai bater a meta? |
| Tático | dono, gerente | semana | 5 a 7 | O que mudou e onde agir esta semana? |
| Operacional | equipe | dia, ao vivo | até 8, em forma de lista | O que precisa ser feito agora, por quem? |

Hierarquia de telas: resumo (a home do painel), visões por área (vendas, agenda, financeiro) quando o app tiver mais
de uma área, e detalhamento (a lista filtrada que explica o número). O clique num KPI leva ao detalhamento.

**2. Escolha dos KPIs.** Liste as cerca de 20 métricas que o nicho oferece (`kpis-por-negocio.md`), corte as de vaidade
(que não mudam nenhuma decisão, como "total de cadastrados desde sempre"), agrupe o que sobrou em 3 a 5 temas
(ex.: salão = Faturamento, Agenda, Clientes, Equipe) e escolha 1 KPI por tema. Todo KPI tem de ser:
acionável (o dono muda algo por causa dele), no tempo certo (existe na cadência do painel), comparável (tem
referencial) e inequívoco (uma definição só).

**3. Tabela de métricas.** Uma linha por KPI no plano: nome visível, fórmula em português ("Ticket médio = faturamento
dos pedidos pagos no período dividido pelo número de pedidos pagos no período"), campos usados, comparação
(mesmo intervalo do período anterior, meta, ou média das últimas 4 semanas), sentido bom (subir ou cair é bom) e
limiar de alerta. Essa fórmula é a mesma que aparece no "Como calculamos" do app.

**4. Gráficos.** Para cada gráfico, a pergunta que ele responde e o tipo, pela tabela de `escolha-de-grafico.md`:
tempo = linha; ranking = barra horizontal ordenada; meta = barra de progresso ou bullet; composição = barra empilhada
de até 4 partes ou tabela; ponte ("por que o lucro caiu de A para B") = cascata. Pizza, rosca, velocímetro, 3D e eixo
duplo não entram. No máximo 6 gráficos na tela de resumo; o resto vai para as telas de área.

**5. Dados: fatos e dimensões.** Fato é o que acontece e se soma (venda, pedido, agendamento, lançamento de caixa,
pagamento). Dimensão é o que descreve e filtra (cliente, serviço, produto, profissional, unidade). Regras:
- Todo modelo de fato tem: a data do acontecimento como campo próprio, `datetime` (momento: `paid_at`, `starts_at`) ou
  `date` (dia: `sold_on`, `due_date`), nunca `created_at` (que não é filtrável e não é a data do negócio); o valor como
  `money`, o status como `enum` (ex.: `pending`, `paid`, `canceled`),
  e as dimensões como `ref` no próprio fato (a `ref` mora no filho).
- Dimensão pequena e fixa (forma de pagamento, canal) vira `enum` no fato; dimensão que o dono cadastra vira modelo.
- Dimensão tem chave única: duplicidade conferida com `count` na chave normalizada antes de criar, porque dimensão duplicada divide o total em dois na hora de agrupar.
- Meta, quando existir: modelo `goal` com `metric` (enum), `period_start` (`date`, dia 1 do mês) e `target` (`money`
  ou `number`), acesso `role:admin` em tudo.
- Modelos de fato do painel do dono: `read` restrito (`role:admin`, ou `owner` quando cada pessoa vê só o seu). Nunca
  `public`.
- Volume alto (mais de ~5.000 registros por período padrão): prever o modelo de resumo diário descrito em
  `armadilhas-de-metrica.md`.

**6. Relatório recorrente.** Se o dono pediu resumo, o plano descreve a página de relatório e o aviso, conforme
`relatorio-recorrente.md`, e fecha a cadência e o canal (a automação é escrita em `fab.automations.json` na construção e não muda em tempo de
execução: `schedule` só existe `daily` e `hourly`; semanal e mensal usam `relative` sobre registros de entrega).
Diga ao dono no plano o limite real: o aviso chega com o link, na hora da plataforma; os números são calculados
quando ele abre a página.

**7. O que NÃO vamos construir:** gráficos que o dono não vai usar para decidir, exportação para BI externo, previsão
estatística.

**Lista de conferência (entra inteira no plano, sem teto):** todos os itens abaixo que se aplicam a este painel.
- Código: Todo StatCard do painel tem `delta` com o referencial escrito, ex.: "+12% vs 1 a 12/08".
- Código: Nenhum `type="pie"` nem `type="donut"` no código do painel.
- Código: Ranking é barra horizontal ordenada do maior para o menor, com o valor escrito ao lado de cada barra.
- Código: Toda métrica vem de um único objeto em `src/lib/metrics.ts` com `formula` em texto, usado pelo cartão e pelo
  "Como calculamos".
- Código: Somas usam `list` paginado de 200 em 200 com `fields`, filtrado pelo período no servidor; contagens usam `count`.
- Código: Datas agrupadas por dia no fuso `America/Sao_Paulo` por padrão, ou no fuso do negócio quando o dono informar.
- Código: Mês corrente comparado com o mesmo intervalo de dias do mês anterior, com selo "parcial".
- Visual: Abaixo do título aparece "Atualizado às HH:mm" e o período em dd/mm.
- Visual: O painel tem estado vazio com uma ação, estado de erro com "Tentar de novo" e aviso de poucos dados.
- Visual: No topo, um resumo de uma a três frases: número, o que significa, próxima ação.
- Visual: Valores em reais no formato "R$ 12,4 mil" nos cartões e "R$ 12.431,90" nas tabelas.
- Código: Relatório recorrente: automação com `notify` e `link` para a página do relatório.

## A construção: como o painel é feito

Ordem: `fab.schema.json` (fatos, dimensões, `goal`, resumo) e `fab.automations.json` primeiro, com `fabapp pull`
antes e `fabapp push` depois; em seguida o código em `src/`, que sobe com `fabapp deploy`.

**Cálculo (a espinha).** Crie `src/lib/metrics.ts` com funções puras e um catálogo de métricas:

```ts
export type Metric = { id: string; label: string; formula: string; better: "up" | "down";
  compute: (rows: Sale[]) => number | null };
```

- Busca: um helper `fetchAll<T extends Row>(model, filter, fields)` (`Row` e `FilterValue` vêm de `@/lib/fab-client`;
  o `collection<T>` exige `T` com `id`) que chama `collection<T>(model).list({ filter, fields, limit: 200, offset })`
  em laço até vir página com menos de 200, com teto (ex.: 25 páginas). Código pronto em `armadilhas-de-metrica.md`. Se bater no teto, marque
  `truncated` e mostre o aviso "Números parciais: muitos registros no período", e use o modelo de resumo.
- Filtre sempre o período no servidor (`{ paid_at: { gte, lt } }`) e traga só os campos usados (`fields`).
- Contagem pura (quantos agendamentos, quantos clientes novos) usa `count(filter)`, que não traz linhas.
- Agregue sempre do dado bruto: ticket médio = soma dos valores dividida pela quantidade, nunca média de médias.
- Divisão por zero devolve `null` e o cartão mostra "sem base de comparação", nunca "Infinity" nem "NaN".
- Fuso: o dia de um `datetime` é calculado em `America/Sao_Paulo` por padrão, ou no fuso do negócio quando o dono
  informar (uma constante `TZ`; `Intl.DateTimeFormat('en-CA', { timeZone: TZ })` dá `aaaa-mm-dd`). Início de período:
  `new Date('2026-09-01T00:00:00-03:00')` (troque o deslocamento junto com o fuso). Campo `date`
  (sem hora) é texto `aaaa-mm-dd`; compare como texto, nunca passe por `toISOString()`.
- Volume alto ou cálculo pesado: função de backend (`functions/<nome>.ts` com entrada em `fab.functions.json`;
  recurso de plano pago, 30 s por chamada, uma coisa por chamada) ou o modelo
  de resumo diário de `armadilhas-de-metrica.md`. Nunca `setInterval` em lista; painel operacional ao vivo usa `useLive`.

**Período.** Seletor no topo com "Este mês" (padrão), "Últimos 7 dias", "Últimos 30 dias", "Últimos 90 dias", "Este ano".
Comparação padrão: o mesmo número de dias do período anterior (em 12/09, "este mês" é 01 a 12/09 contra 01 a 12/08).
Período em andamento leva o selo "parcial". Todos os gráficos e cartões obedecem ao mesmo seletor.

**Hierarquia fixa da tela de resumo** (de cima para baixo; no computador, KPIs em linha; no celular, grade de 2
colunas com o KPI principal ocupando as duas):
1. `PageHeader` com título que afirma o estado quando houver achado ("Vendas 12% acima de agosto"), senão o nome do
   painel; abaixo, período em dd/mm e "Atualizado às HH:mm"; à direita, o seletor de período.
2. Resumo automático (uma a três frases): o número, o que significa, a próxima ação.
3. 3 a 5 `StatCard`s.
4. O gráfico principal, largo.
5. No máximo dois gráficos secundários, lado a lado no computador, empilhados no celular.
6. A tabela ou lista de ação ("Pedidos atrasados", "Clientes sem voltar há 60 dias").

**Cartão de KPI (`StatCard` de `@/components/ui/stat-card`; props: `label`, `value`, `delta?`, `trend?`, `icon?`,
`spark?`, `tone?`, `className?`).**
- `value`: formato curto BR ("R$ 12,4 mil", "8,5%", "143"). `delta`: sinal, valor e referencial ("+12% vs 1 a 12/08",
  "-3 p.p. vs meta"). Porcentagem de porcentagem é "p.p.", nunca "%".
- `trend` diz se a variação é boa ou ruim, não a direção: cancelamentos caindo é `trend="up"` (verde), com o texto
  "▼ 8%". Variação menor que 2% é `trend="neutral"`.
- `spark`: os valores dos últimos 6 a 12 períodos, quando existirem.
- Cor por escassez: `tone="neutral"` em todos, `tone="primary"` só no KPI principal, `tone="danger"` só no KPI que
  estourou o limiar. Painel com tudo certo fica quieto. Esta decisão vale mesmo que o comentário do componente sugira
  um tom diferente por cartão.
- `label` com um botão de ícone de informação (`aria-label="Como calculamos"`) que abre um `Popover` de
  `@/components/ui/popover` (abre no toque e no foco; o `Tooltip` do kit só abre no mouse) com a `formula` da
  métrica, o período e "Atualizado às HH:mm". Esse é o "Como calculamos".
- O cartão é clicável e leva à lista que explica o número.

**Gráficos.** Implemente pela tabela e pelas receitas de `escolha-de-grafico.md`. Em resumo:
- Tempo: `Chart` de `@/lib/fab-client` `type="line"`, com `series` de duas linhas (atual e período anterior) quando
  a comparação é o ponto; `valueFormat` sempre com o formato BR.
- Ranking: o componente `RankBars` (barras horizontais em divs), ordenado do maior para o menor, até 10 itens e
  "Outros" agrupado, valor escrito ao lado, o primeiro item em `bg-primary` e os demais neutros.
- Meta: o componente `GoalBar` (bullet: barra do realizado, marcador da meta, marcador de "onde deveria estar hoje").
- Composição: barra empilhada 100% de até 4 partes, ou tabela.
- Ponte: `Waterfall` (cascata) com início, variações e fim, cada barra com o valor com sinal.
- Mesma medida em vários grupos: small multiples com a MESMA escala (receita em `escolha-de-grafico.md`).
- Título de gráfico afirma o achado ("Terça é o dia mais fraco da semana"); o subtítulo diz a unidade e o período.
- Barra começa em zero. Eixo de linha pode não começar em zero, e então o rótulo do menor valor aparece.
- Sem legenda quando dá para rotular direto; sem grade pesada; sem animação de entrada; ordenar pelo valor, nunca por
  ordem alfabética (exceto tempo).

**Quando não desenhar.** Um ou dois números viram frase com contexto ("Você recebeu R$ 4,2 mil, 23% a mais que na
semana passada"). Até ~15 itens em que o valor exato importa viram tabela (números alinhados à direita, sem zebra).
Menos de 3 pontos no tempo não viram gráfico de linha.

**Estados obrigatórios** (todos com texto, não só cor):
- Carregando, vazio e erro: `Skeleton` no formato dos cartões e gráficos, `EmptyState` com uma
  ação ("Registrar a primeira venda" ou "Ver o mês passado"), erro com `e.message` e "Tentar de novo".
- Poucos dados: com menos de 30 registros no período, a variação em % sai do cartão e aparece "Poucos dados para
  comparar"; nunca "+300%" em cima de 1 venda.
- Desatualizado: se o último registro do fato é mais velho que o esperado para a cadência (ex.: nenhuma venda há 3 dias
  num negócio que vende todo dia), aviso "Nenhum registro desde dd/mm. Os números podem estar incompletos."
- Tudo certo: sem alerta nenhum, só os números.

**Resumo automático.** Montado por código a partir dos números calculados, em modelo fixo: "[Métrica principal] foi
[valor], [variação] em relação a [referencial]. [O que puxou: o maior item do ranking ou o pior KPI]. [Próxima ação
ligada à decisão do dono]." Se o dono quiser um texto mais natural, um botão "Explicar com IA" chama
`invokeLLM({ prompt, system, schema, tier: "fast" })` de `@/lib/fab-client` (exige login; devolve `{ text, data }`):
`prompt` é SÓ o objeto de números já formatados em JSON; `schema` é `{ headline, positives[2], attention, action }`;
`system` diz "use apenas os números do objeto, nunca calcule nem invente valor, sem travessão, sem jargão"; o app
confere que cada número de `data` está no objeto e, se não estiver, mostra o resumo por modelo. Um `ApiError` 402
(sem crédito) ou de rede cai no resumo por modelo sem mensagem de erro. Nada de
travessão, jargão ou "insights acionáveis" no texto.

**Painel operacional** (quando o público é a equipe): lista de exceções no lugar de gráficos. Cada exceção mostra
estado (texto e ícone), há quanto tempo, responsável e próxima ação ("18 pedidos passaram do prazo, há 2 min, Expedição,
redistribuir"). Dados com `useLive`; a linha que a pessoa está olhando não muda de lugar enquanto ela lê (novos itens
entram com destaque no topo). Estados "normal", "atenção", "crítico", "sem dados" e "resolvido" explícitos.

**Formatos BR.** Crie em `src/lib/format.ts`: `moneyShort` (`Intl.NumberFormat('pt-BR', { style: 'currency',
currency: 'BRL', notation: 'compact', maximumFractionDigits: 1 })` dá "R$ 12,4 mil", "R$ 1,2 mi"), `formatMoney` do
fab-client para valor exato, `pct` ("8,5%"), `pp` ("3 p.p."), datas com `formatDate` (dd/mm/aaaa) e rótulos de eixo
em "dd/mm", "seg", "set". Precisão só a que a decisão pede: contagem sem casa decimal, % com uma casa.

**Relatório recorrente.** Implemente a página, o modelo de agenda e a automação de `relatorio-recorrente.md`.

## Mudanças depois: pedidos comuns sobre painel

- "Põe um gráfico de pizza": explique em uma frase que barras deixam comparar melhor e mostre a barra ordenada. Se o
  dono insistir, faça com no máximo 4 fatias, rótulo de % em cada uma e o resto em "Outros".
- "Esse número não bate com o meu caderno": abra a `formula` da métrica e as armadilhas de `armadilhas-de-metrica.md`
  (mês parcial, status contado, fuso, duplicidade, cancelados). Corrija a definição num lugar só e mostre a nova
  fórmula no "Como calculamos".
- "Quero mais números no painel": mantenha 3 a 5 no topo; o que sobrar vai para as telas de área ou para a tabela.
- "Quero receber isso toda semana": siga `relatorio-recorrente.md`.
- "Ninguém olha o painel": aplique o teste dos 5 segundos (abaixo) e corte até passar.
- Painel existente fraco: classifique cada cartão, gráfico e grupo como manter, corrigir, trocar ou tirar, com o motivo
  (engana a decisão, atrasa a leitura, ou acabamento). Não refaça o que funciona.

## Conferir antes de dizer pronto: o teste dos 5 segundos

Olhando só o topo da tela de resumo por 5 segundos, dá para dizer qual é a coisa mais importante? Se não, a hierarquia
está errada: aumente o KPI principal, corte cartões, tire cor de onde não há exceção. Confira também: todo KPI tem
comparação; nenhum número sem unidade; título afirma; nada de pizza, velocímetro, 3D ou eixo duplo; formato BR; estados
vazio, erro, parcial e poucos dados presentes; nada cortado a 360 px de largura.

Como conferir:
1. Por busca no código (`grep`) em `src/`: nenhum `type="pie"`, `type="donut"`, `setInterval`, `toISOString()` em
   campo `date`, hex de cor ou `window.confirm`; toda métrica importada de `src/lib/metrics.ts`.
2. Com `fabapp dev` rodando, percorra cada item da lista de conferência na tela de resumo, no computador e a 360 px:
   troque o período, abra o "Como calculamos" pelo toque e pelo teclado, clique num KPI até a lista que o explica.
   Veja os estados vazio, erro (sem internet), parcial e poucos dados. Os registros de teste você cria pela
   própria pré-visualização (o CLI não grava registros) e apaga depois; dados reais o dono cadastra ou importa no
   CMS do Studio.
3. Siga a conferência de `armadilhas-de-metrica.md` (dados, cálculo, razoabilidade, conferência cruzada).
4. `fabapp push` e `fabapp deploy`; trate `build_failed` (422) consertando e `account_builds_busy` (409) esperando e
   repetindo. Se houver relatório recorrente, confira no ar que `/relatorios/ultimo` abre.
5. Na mensagem final ao dono, relate só o que conferiu, o link, e o que ele faz no Studio (cadastrar ou importar os
   dados no CMS, e a meta se ela não tiver tela no app).
