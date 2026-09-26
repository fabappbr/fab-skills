# Escolha de gráfico: da pergunta ao componente

## Passo 0: nomeie a comparação antes do gráfico

Todo gráfico de número faz uma de cinco comparações. Nomeie qual é antes de escolher a forma.

| Comparação | O dono está dizendo | Forma |
|---|---|---|
| Parte do todo | "X é n% do total" | barra empilhada 100% de até 4 partes, ou tabela |
| Item (ranking) | "A vende mais que B" | barra horizontal ordenada |
| Série no tempo | "está subindo, caindo, parado" | linha; cascata para ponte; small multiples por grupo |
| Distribuição | "a maioria fica nesta faixa" | histograma de barras finas ou faixas em tabela |
| Correlação | "X anda junto com Y" | dispersão, só se o dono sabe ler; senão, frase |

Perguntas de estrutura (etapas de um processo, regras de decisão) não são gráfico de número: viram lista numerada ou
linha do tempo (`Timeline` de `@/components/ui/timeline`).

## Passo 1 e 2: nomeie o dado e o objetivo

| Dado | Objetivo | Use | Não use |
|---|---|---|---|
| Um número com contexto | comparar | `StatCard` com `delta` e `spark` | número gigante sozinho |
| Um valor por item | ranquear | `RankBars` ordenado | pizza, rosca, treemap |
| Um valor no tempo | acompanhar | `Chart` line | barra para tempo contínuo longo, eixo duplo |
| Dois momentos, vários itens | ver mudança | tabela "antes, depois, variação" ordenada pela variação (ou slopegraph) | pares de barras lado a lado |
| Realizado contra meta | ver se chega | `GoalBar` (bullet) ou `Progress` | velocímetro, gauge |
| Parte do todo, até 4 partes | comparar fatias | barra empilhada 100% com rótulo em cada parte, ou tabela | pizza |
| Parte do todo, muitas partes | comparar fatias | `RankBars` com "Outros" | rosca, sunburst |
| Etapas de um funil | ver onde perde | `RankBars` na ordem das etapas, com a conversão entre etapas escrita | funil 3D |
| Ponte de um valor a outro | explicar a diferença | `Waterfall` | duas barras "antes e depois" |
| Mesma medida em vários grupos | comparar forma | small multiples com a mesma escala | 6 linhas num gráfico só |
| Muitos itens com vários números | consultar | tabela com números à direita e `spark` por linha | mapa de calor para tabela pequena |
| Lugar | localizar | ranking por bairro ou cidade | mapa (não há componente de mapa pronto) |

## Checagens rápidas antes de desenhar

1. Uma frase resolve? ("Você vendeu R$ 4,2 mil, 22% a mais que na semana passada.") Então é frase.
2. Até ~15 itens e o valor exato importa? Tabela.
3. Vai pôr um segundo eixo? Não. Dois gráficos pequenos um sobre o outro, mesmo eixo de tempo.
4. Vai codificar três coisas (posição, cor e tamanho)? Uma quantidade por canal.
5. Ordem alfabética ou ordem de cadastro? Quase sempre errado: ordene pelo valor que o dono quer ver.
6. Menos de 3 pontos ou valores que não dá para conferir? Cartão ou frase, não gráfico.

Ordem padrão: barras do maior para o menor (maior em cima); tempo da esquerda para a direita; funil na ordem das
etapas.

## Catálogo de padrões e a pergunta de cada um

| Padrão | Pergunta do dono | Regra |
|---|---|---|
| Linha no tempo | O ritmo está acelerando ou parando? | uma anotação no ponto de virada ("Promoção de 15/08") |
| Lacuna (gap) | Quanto falta para a meta, e isso importa? | barra horizontal; a diferença escrita em reais |
| Antes e depois | O que mudou, e basta? | mostrar a base, a variação absoluta e a relativa |
| Ranking | Quem vende mais, quem fica para trás? | ordenado, valor ao lado, destaque só no item do achado |
| Cascata | O que explica a diferença? | positivos e negativos distintos por cor E por sinal no rótulo |
| Funil | Onde perco mais, etapa por etapa? | largura proporcional ao valor real; anotar a maior queda |
| Scorecard | O que está saudável e o que pede atenção? | agrupar por tema; valor, tendência e meta por linha; cor só no status |
| Small multiples | O padrão vale para todos os grupos? | mesma escala em todos os painéis; destacar no máximo 1 |
| Distribuição | O que é normal e o que é extremo? | mostrar a mediana ou o limite; escrever o tamanho da amostra |

## Componentes da plataforma e quando usar cada um

- `Chart` de `@/lib/fab-client`: `type` line | bar | area | donut; `data=[{label, value}]` ou `series=[{name, points}]`
  (várias linhas na MESMA escala, com legenda); `valueFormat`; `title`; estados de carregando, erro e sem dados já
  embutidos (`loading`, `error`, `onRetry`). Barras são verticais e destacam o maior valor: use `bar` só para
  poucas colunas no tempo (dias da semana, 6 a 12 meses). `donut` não entra no painel.
- `Chart` de `@/components/ui/chart` (recharts): `type` line | bar | area | pie, `data` (lista de objetos), `xKey`
  (campo do eixo X) e `series` (lista de NOMES de campo numérico, ex.: `series={["total"]}`), `height`, `className`.
  Só a primeira série segue a cor da marca; da segunda em diante o componente usa cores fixas próprias. Por isso, com
  duas ou mais séries, prefira o `Chart` do fab-client com `series`. `pie` não entra.
- `StatCard` de `@/components/ui/stat-card`: `label`, `value`, `delta`, `trend` ("up" | "down" | "neutral"), `spark`
  (lista de números), `tone` ("neutral" | "primary" | "danger" | "success" | "info" | "violet" | "amber"), `icon`
  (elemento ou componente do `lucide-react`), `className`.
- `Progress` do kit para meta simples; `Table` e `DataTable` para tabelas; `Popover` para o "Como calculamos"
  (abre no toque e no foco); `Timeline` do kit para etapas.
- `recharts` 3 já está instalado: para cascata e small multiples, importe direto e use cores por token nas props
  `fill` e `stroke` (`"var(--primary)"`, `"var(--muted-foreground)"`, `"var(--success)"`, `"var(--destructive)"`,
  `"var(--border)"`), nunca hex nem nome de cor do Tailwind em `style`. Exemplo: `<Bar dataKey="value" fill="var(--primary)" />`,
  `<CartesianGrid stroke="var(--border)" vertical={false} />`, `<XAxis tick={{ fill: "var(--muted-foreground)", fontSize: 11 }} />`.

## Receitas

### RankBars (ranking em barras horizontais)

```tsx
// src/components/rank-bars.tsx
type Item = { label: string; value: number };
export function RankBars({ items, format, max = 10, highlight }: {
  items: Item[]; format: (n: number) => string; max?: number; highlight?: string }) {
  const sorted = [...items].sort((a, b) => b.value - a.value);
  const top = sorted.slice(0, max);
  const rest = sorted.slice(max).reduce((s, i) => s + i.value, 0);
  const rows = rest > 0 ? [...top, { label: "Outros", value: rest }] : top;
  const peak = Math.max(...rows.map((r) => r.value), 1);
  return (
    <ul className="space-y-2">
      {rows.map((r, i) => (
        <li key={r.label} className="grid grid-cols-[minmax(0,7rem)_1fr_auto] items-center gap-3 text-sm">
          <span className="truncate text-foreground" title={r.label}>{r.label}</span>
          <span className="h-3 rounded-full bg-muted">
            <span className={`block h-3 rounded-full ${(highlight ? r.label === highlight : i === 0) ? "bg-primary" : "bg-muted-foreground/40"}`}
              style={{ width: `${Math.max(2, (r.value / peak) * 100)}%` }} />
          </span>
          <span className="tabular-nums text-muted-foreground">{format(r.value)}</span>
        </li>
      ))}
    </ul>
  );
}
```
Escala começa em zero. Nome longo é cortado com reticências e o nome inteiro fica no `title`.

### GoalBar (bullet: realizado, meta e ritmo)

Barra do realizado; marcador vertical da meta; marcador tracejado de "onde deveria estar hoje"
(meta × dias passados ÷ dias do mês). Abaixo, uma linha: "R$ 31,2 mil de R$ 45 mil (69%). No ritmo de hoje, fecha o
mês em R$ 41,6 mil." A cor do realizado é `bg-primary` quando está no ritmo e `bg-destructive` quando está abaixo,
sempre com o texto "abaixo do ritmo" junto. Projeção = realizado ÷ dias passados × dias do mês, e só aparece a partir
do dia 7 (antes disso, "cedo para projetar").

### Waterfall (cascata)

Barras empilhadas do recharts: uma série invisível de base (`fill="transparent"`) e uma série visível com o tamanho
do passo. Primeira e última barras (início e fim) em `var(--primary)`; aumentos em `var(--success)`; quedas em
`var(--destructive)`; cada barra com `LabelList` do valor com sinal ("+R$ 3,1 mil", "-R$ 8,4 mil"), para ler sem cor.
Os passos precisam somar exatamente a diferença entre início e fim; o código confere e, se não fechar, mostra a
diferença como "Outros". Ex.: "Por que o lucro caiu de R$ 40 mil para R$ 31 mil?": Lucro de julho, Receita, Custo da
mercadoria, Despesas fixas, Lucro de agosto.

### Small multiples

Grade `grid grid-cols-2 gap-4` (2 colunas no celular também, no máximo 6 painéis), um `LineChart` do recharts por
grupo, todos com `YAxis domain={[0, maxGlobal]}` calculado de TODOS os grupos, título do painel em cima, eixo Y só na
coluna da esquerda e eixo X só na última linha, sem borda entre painéis. O `Chart` do fab-client calcula a escala de
cada gráfico sozinho, por isso não serve para small multiples.

### Sparkline

`StatCard spark={[...]}` já desenha. Em tabela, uma `polyline` SVG de ~64×20 com `stroke="currentColor"` e a classe
`text-muted-foreground`, sem eixo, com um ponto no último valor.

### Tabela de dados

Números alinhados à direita com `tabular-nums`; sem zebra; linha fina a cada 3 a 5 linhas ou só no cabeçalho; coluna
de variação com sinal; ordenada pelo valor que responde à pergunta; no celular, as colunas menos importantes somem
(`hidden sm:table-cell`), nunca rolagem lateral solta.

## Celular não é encolher

- KPIs em grade de 2 colunas; KPI principal com `col-span-2`.
- Categorias sempre em barra horizontal (rótulo lê na horizontal).
- Menos marcas no eixo (primeiro, meio e último), rótulos abreviados ("set", "R$ 1,2 mi").
- Toque de 44 px no mínimo nos elementos clicáveis; nada de informação só no passar do mouse.
- Nada cortado nem vazando a 360 px; gráfico em largura 100%.
