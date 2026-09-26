# Armadilhas de métrica e como o código do app se protege

Cada armadilha abaixo vira uma proteção no código de `src/lib/metrics.ts` ou um estado visível no painel.

## As armadilhas

**Mês pela metade contra mês cheio.** No dia 12, "setembro caiu 60% contra agosto" é falso: setembro ainda não acabou.
Proteção: comparar o mesmo número de dias (01 a 12/09 contra 01 a 12/08) e marcar o período atual com o selo "parcial".
Semana: comparar segunda a quarta com segunda a quarta. Mês com menos dias: se o mês anterior não tem o dia (31),
use o último dia dele. No relatório mensal, só mês fechado.

**Média de médias.** Grupo A: 100 clientes com média de R$ 50; grupo B: 10 clientes com média de R$ 200. Média das
médias = R$ 125; certo = (100 × 50 + 10 × 200) ÷ 110 = R$ 63,64. Proteção: toda média é soma ÷ contagem sobre as
linhas brutas; nunca guardar médias por dia e depois tirar a média delas (o modelo de resumo guarda somas e
contagens, não médias).

**Fuso horário.** Venda às 22h de 31/08 em São Paulo é 01h de 01/09 em UTC e cai no mês errado. Proteção: todo
agrupamento por dia, semana ou mês usa `America/Sao_Paulo` por padrão (ou o fuso do negócio quando o dono informar, na constante `TZ`); limites de período são montados com o deslocamento desse fuso, ex. `-03:00`
(`2026-09-01T00:00:00-03:00`). Campo `date` (sem hora) é texto `aaaa-mm-dd` e se compara como texto.

**Denominador errado ou que muda.** Taxa que "melhora" porque mudou quem entra na conta (ex.: "ativo" passou a ser
quem abriu o app em vez de quem comprou). Proteção: denominador escrito na fórmula; a mesma definição nos dois
períodos comparados; quando a definição mudar, avisar no "Como calculamos" a data da mudança. Denominador zero
devolve `null` e o cartão mostra "sem base de comparação".

**Contar o status errado.** Pedido cancelado somado no faturamento, orçamento recusado no funil. Proteção: o filtro de
status faz parte da definição da métrica e está escrito na fórmula ("só pedidos pagos").

**Duplicidade (a explosão do join).** Cliente cadastrado duas vezes divide o ranking; lista de itens somada junto com o
pedido conta o total duas vezes. Proteção: dimensão com chave única conferida por `count` antes de criar; somar o
valor no nível certo (total do pedido OU soma dos itens, nunca os dois); contar entidades por id distinto
(`new Set(ids).size`).

**Amostra pequena.** "+300%" em cima de 1 venda para 4. Proteção: com menos de 30 registros no período, a variação em
% não aparece; o cartão diz "Poucos dados para comparar" e mostra os números absolutos ("4 vendas, contra 1").

**Sem dados.** Proteção: estado vazio explícito com uma ação; nunca um gráfico vazio com eixo zerado, nunca "R$ 0,00"
quando o certo é "nenhuma venda registrada".

**Desatualizado.** Ninguém lançou as vendas de ontem e o painel mostra queda. Proteção: data do último registro do
fato comparada com a cadência esperada; aviso "Nenhum registro desde dd/mm" no topo.

**Sobrevivência.** Analisar só quem ainda é cliente esconde quem cancelou. Proteção: métricas de clientes contam
também os cancelados e inativos no período (a exclusão lógica do `remove` some da lista: para métricas históricas,
prefira status "cancelado" a apagar).

**Segmento definido pelo resultado.** "Quem completou o cadastro compra mais": óbvio, eles se escolheram. Proteção:
segmentar por algo que veio antes (canal de entrada, mês de entrada), não pelo resultado medido.

**Outras armadilhas para o texto do resumo:** tendência que inverte quando se separa por grupo (paradoxo de Simpson);
correlação escrita como causa; valor extremo puxando a média (use mediana para tempo e valores muito desiguais);
escolher o período que favorece a história; usar informação do futuro para explicar o passado.

## Receita do cálculo (`src/lib/metrics.ts`)

```ts
import { collection, type FilterValue, type Row } from "@/lib/fab-client";

const TZ = "America/Sao_Paulo"; // troque pelo fuso do negócio quando o dono informar
const dayKeyFmt = new Intl.DateTimeFormat("en-CA", { timeZone: TZ, year: "numeric", month: "2-digit", day: "2-digit" });
export const dayKey = (iso: string) => dayKeyFmt.format(new Date(iso));            // "2026-09-12" no fuso de SP
export const spStart = (ymd: string) => new Date(`${ymd}T00:00:00-03:00`).toISOString();

// Período atual e o comparável: mesmo número de dias, alinhado ao início do período anterior.
export function monthToDate(todayYmd: string) {
  const [y, m, d] = todayYmd.split("-").map(Number);
  const pad = (n: number) => String(n).padStart(2, "0");
  const prevY = m === 1 ? y - 1 : y, prevM = m === 1 ? 12 : m - 1;
  const lastPrev = new Date(Date.UTC(prevY, prevM, 0)).getUTCDate();
  const cur = { gte: spStart(`${y}-${pad(m)}-01`), lt: spStart(nextDay(todayYmd)) };
  const prevEnd = `${prevY}-${pad(prevM)}-${pad(Math.min(d, lastPrev))}`;
  const prev = { gte: spStart(`${prevY}-${pad(prevM)}-01`), lt: spStart(nextDay(prevEnd)) };
  return { cur, prev, partial: true, label: `1 a ${pad(d)}/${pad(prevM)}` };
}
function nextDay(ymd: string) {
  const t = new Date(`${ymd}T12:00:00Z`); t.setUTCDate(t.getUTCDate() + 1); return t.toISOString().slice(0, 10);
}

// `T extends Row`: o `collection<T>` do fab-client exige um tipo com `id`. `fields` traz só as colunas usadas (+ `id`).
export async function fetchAll<T extends Row = Row>(model: string, filter: Record<string, FilterValue>, fields: string[], maxPages = 25) {
  const rows: T[] = [];
  for (let page = 0; page < maxPages; page++) {
    const batch = await collection<T>(model).list({ filter, fields, limit: 200, offset: page * 200 });
    rows.push(...batch);
    if (batch.length < 200) return { rows, truncated: false };
  }
  return { rows, truncated: true };
}

export const variation = (cur: number | null, prev: number | null) =>
  cur == null || prev == null || prev === 0 ? null : (cur - prev) / prev;
```

O `label` alimenta o texto do `delta` ("+12% vs 1 a 12/08"). Os dois períodos usam exatamente o mesmo filtro de
status e a mesma função de cálculo.

## Modelo de resumo diário (volume alto)

Quando o período padrão passa de ~5.000 registros, somar tudo a cada abertura fica lento e gasta requisições do
projeto. Crie o modelo `daily_summary`:
- Campos: `day` (`date`), `metric_key` (`text`, ex.: `revenue_paid`), `sum` (`number`), `count` (`number`),
  `computed_at` (`datetime`). Guarde soma e contagem, nunca média.
- Acesso: `role:admin` em tudo.
- Quem preenche: o próprio painel. Ao abrir, ele busca os resumos do período; para cada dia FECHADO sem resumo,
  calcula a partir das linhas brutas daquele dia e grava com `bulkCreate` (até 200 por chamada). O dia de hoje é
  sempre calculado ao vivo e nunca gravado.
- Correção tardia: quando o app altera ou cancela um registro de um dia já fechado, o mesmo código apaga o resumo
  daquele dia (`deleteMany({ day, metric_key })`), que será recalculado na próxima abertura.
- Chave única por `day` + `metric_key`: conferir com `count` antes de gravar.
- Alternativa com funções de backend (recurso de plano pago; ver `references/fabapp-cli.md`): uma função de backend `recalc-summary` chamada por um botão "Atualizar números" do
  admin, que refaz um dia por chamada (limite de 30 s; nunca varrer a coleção inteira numa chamada só). A função usa
  `ctx.collection`, que ignora as regras de acesso: ela confere `ctx.user` como admin antes de tudo.

## Calendário

Não há tabela de calendário: ele é código (`src/lib/calendar.ts`) com dia da semana, semana, mês, trimestre, fim de
semana e os feriados nacionais fixos (01/01, 21/04, 01/05, 07/09, 12/10, 02/11, 15/11, 20/11, 25/12) mais os móveis
calculados a partir da Páscoa (Carnaval segunda e terça, Sexta-feira Santa, Corpus Christi). Serve para "dias úteis
do mês", para a projeção do `GoalBar` e para explicar quedas ("feriado de 07/09 na semana").

## Conferência antes de declarar pronto

Dados: a fonte é o modelo certo; período e filtros corretos; nada contado duas vezes; nulos tratados (campo vazio
não vira zero na média).
Cálculo: soma das partes igual ao total (ranking + "Outros" = faturamento); porcentagens de composição somam ~100%;
comparações usam a base certa; o mesmo filtro em todos os cartões.
Razoabilidade: nenhum faturamento negativo; porcentagens entre 0 e 100; variação acima de 50% sem causa aparente é
investigada; número redondo demais ou idêntico em dois períodos sugere filtro ignorado; taxa exatamente 0% ou 100%
sugere dado incompleto.
Conferência cruzada: calcule um KPI de dois jeitos (ticket × pedidos ≈ faturamento); confira 2 ou 3 registros à mão (abrindo
cada um na pré-visualização, ou pedindo ao dono que confira no CMS do Studio) quando houver dados; teste um período de um dia só e uma categoria só.
Apresentação: barra em zero; mesma escala entre gráficos comparados; título diz o que mostra; período escrito.

Na mensagem final ao dono, classifique o painel com uma das três frases e diga por quê: "pronto", "pronto com ressalvas (listar)"
ou "precisa de revisão (listar)". Ressalva típica: "os números de antes de dd/mm não têm status de pagamento".

## Definição documentada (o "Como calculamos")

Para cada métrica, o tooltip mostra: a pergunta que ela responde, a fórmula em português, o que entra e o que fica de
fora (status, cancelados), o período e o fuso, e "Atualizado às HH:mm". Uma definição, um lugar no código, usada por
todas as telas: nunca duas fórmulas rivais do mesmo nome.
