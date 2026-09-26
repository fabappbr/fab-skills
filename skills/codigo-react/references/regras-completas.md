# Catálogo completo de regras (complemento do SKILL.md)

As regras que bloqueiam a entrega estão no corpo da skill. Aqui estão o detalhe das regras de dados e composição e todas as regras MEDIUM e LOW, cada uma com o par Errado/Certo no código da Fabapp. Lembrete da pilha: React 19.0 (sem `<Activity>`, sem `useEffectEvent`, sem `<ViewTransition>`; nunca troque a versão do React), `BrowserRouter`, `createRoot` (sem hidratação de servidor), sem `StrictMode`.

## 1. dados- (complementos, CRITICAL)

**dados-dependencia-parcial.** Quando B depende de A mas C não, C não espera A.

```tsx
// Errado: o resumo espera o cliente sem precisar dele
const [cliente, config] = await Promise.all([collection<Cliente>("customer").get(id), carregarConfig()]);
const pedidos = await collection<Pedido>("order").list({ filter: { customer: cliente.id }, limit: 20 });

// Certo: cada promessa começa no primeiro momento possível
const clienteP = collection<Cliente>("customer").get(id);
const pedidosP = clienteP.then(c => collection<Pedido>("order").list({ filter: { customer: c.id }, limit: 20 }));
const [cliente, config, pedidos] = await Promise.all([clienteP, carregarConfig(), pedidosP]);
```

**dados-aninhado-por-item.** Se cada item precisa de uma segunda chamada que não dá para juntar num `in`, encadeie por item dentro do `Promise.all`; um item lento não segura os outros.

```tsx
// Errado: a segunda leva só começa quando a primeira inteira termina
const conversas = await Promise.all(ids.map(id => collection("conversation").get(id)));
const ultimas = await Promise.all(conversas.map(c => collection("message").list({ filter: { conversation: c.id }, sort: "-created_at", limit: 1 })));

// Certo
const ultimas = await Promise.all(ids.map(id =>
  collection("conversation").get(id).then(c =>
    collection("message").list({ filter: { conversation: c.id }, sort: "-created_at", limit: 1 }))));
```

**dados-secoes-independentes.** Seções irmãs buscam cada uma o seu dado. Um pai que espera o próprio dado antes de renderizar os filhos cria cascata: o filho só começa a buscar depois.

```tsx
// Errado: <Agenda/> só monta (e só busca) depois que o resumo chegou
function Painel() {
  const [resumo, setResumo] = useState<Resumo | null>(null);
  useEffect(() => { carregarResumo().then(setResumo); }, []);
  if (!resumo) return <Spinner />;
  return <><CardsResumo resumo={resumo} /><Agenda /></>;
}

// Certo: as duas seções montam juntas e carregam em paralelo
function Painel() {
  return <><CardsResumo /><Agenda /></>;   // cada uma com seu carregamento e Skeleton
}
```

Quando duas seções precisam do MESMO dado, carregue uma vez no pai e passe por prop (ou por contexto). Nunca a mesma `list` em três componentes da tela.

**dados-dedupe-entre-telas.** Dado que quase não muda (categorias, configurações, catálogo pequeno) pode ficar num cache de módulo em `src/lib`, com prazo de validade e limpo no `logout`:

```ts
// src/lib/cache.ts
const guardado = new Map<string, { em: number; valor: Promise<unknown> }>();
export function emCache<T>(chave: string, ms: number, buscar: () => Promise<T>): Promise<T> {
  const item = guardado.get(chave);
  if (item && Date.now() - item.em < ms) return item.valor as Promise<T>;
  const valor = buscar().catch(e => { guardado.delete(chave); throw e; });
  guardado.set(chave, { em: Date.now(), valor });
  return valor;
}
export function limparCache() { guardado.clear(); }   // chame no logout
```

Guardar a PROMESSA (e não o resultado) faz duas telas que pedem ao mesmo tempo compartilharem uma chamada só. Para listas que mudam, use `useLive` e não este cache.

**dados-sem-bloquear-a-resposta.** No cliente, o que não é essencial para o usuário (evento `trackEvent`, pré-carregamento) não segura o toast de sucesso: dispare sem `await` e com `.catch(() => {})`. Registro de auditoria NÃO entra aqui: ele é parte da ação e é aguardado. Numa função de backend, aguarde tudo antes de devolver a `Response`: o contêiner pode parar logo depois.

**dados-funcao-sem-cascata.** Dentro de `functions/<nome>.ts`, dispare as leituras independentes juntas logo no início e aguarde no ponto de uso, como no cliente. Orçamento: 30 segundos por chamada, então uma função faz uma coisa e nunca percorre a coleção inteira.

```ts
// Certo, dentro da função (`json(status, body)` é o helper que devolve uma Response JSON)
const pedidoP = ctx.collection("order").get(orderId);
const configP = ctx.collection("settings").list({ limit: 1 });
const pedido = await pedidoP;
if (pedido.customer !== ctx.user.id) return json(403, { detail: "Pedido de outra pessoa" });
const [config] = await configP;
```

## 2. pacote- (complementos)

**pacote-condicional (HIGH).** Recurso que a pessoa liga (exportar planilha, ler QR, confete na conclusão) carrega o módulo só quando ligado, sem `await import`:

```tsx
const [exportando, setExportando] = useState(false);
function exportar() {
  setExportando(true);
  import("@/lib/exportar-xlsx")
    .then(m => m.exportar(linhas))
    .catch(() => toast.error("Não foi possível gerar a planilha. Tente de novo."))
    .finally(() => setExportando(false));
}
```

**pacote-pre-carregar (MEDIUM).** Rota (o build já a divide em pedaço próprio) ou componente pesado pode começar a baixar quando a pessoa mostra intenção (passa o mouse ou foca o link), para abrir sem espera:

```tsx
const carregarRelatorios = () => { void import("./pages/Reports"); };
<Link to="/relatorios" onMouseEnter={carregarRelatorios} onFocus={carregarRelatorios}>Relatórios</Link>
```

**pacote-terceiros (MEDIUM).** Nunca escreva snippet de analytics, pixel ou chat: a plataforma injeta. Nunca `<script src>` externo (a plataforma proíbe): biblioteca entra com `npm install` dentro de `.fabapp/workspace` e sobe no `fabapp deploy`. Biblioteca pesada e não essencial carrega sob demanda.

**pacote-caminho-literal (HIGH).** O Vite só divide o pacote quando o caminho do `import()` é literal. `import(\`./pages/${nome}\`)` puxa a pasta inteira ou quebra; use um mapa de funções com caminhos literais.

## 3. rerender- (MEDIUM)

**rerender-leitura-no-uso.** Não assine um valor que só é lido dentro de um callback. `useSearchParams()` num botão que só lê o parâmetro no clique re-renderiza a cada mudança de URL; leia `new URLSearchParams(window.location.search)` dentro do handler.

**rerender-memo-componente.** Trabalho caro que não precisa rodar enquanto a tela carrega vai para um componente separado com `memo`, para permitir o retorno antecipado:

```tsx
// Errado: calcula o gráfico mesmo quando está carregando
function Painel({ pedidos, loading }: P) {
  const serie = useMemo(() => agruparPorDia(pedidos), [pedidos]);
  if (loading) return <Skeleton className="h-64" />;
  return <Chart type="line" data={serie} />;
}
// Certo
const GraficoVendas = memo(function GraficoVendas({ pedidos }: { pedidos: Pedido[] }) {
  const serie = useMemo(() => agruparPorDia(pedidos), [pedidos]);
  return <Chart type="line" data={serie} />;
});
function Painel({ pedidos, loading }: P) {
  if (loading) return <Skeleton className="h-64" />;
  return <GraficoVendas pedidos={pedidos} />;
}
```

**rerender-padrao-constante.** Componente com `memo` e prop opcional não primitiva com valor padrão (`onClick = () => {}`, `itens = []`) perde o `memo` a cada render. Tire o padrão para uma constante do módulo: `const NADA = () => {}`, `const VAZIO: Item[] = []`.

**rerender-dependencia-primitiva.** Efeito depende do campo, não do objeto: `[cliente.id]`, não `[cliente]`. Para condição derivada, calcule o booleano fora e dependa dele (`const pequeno = largura < 768` e `[pequeno]`).

**rerender-assinar-derivado.** Assine o booleano, não o valor contínuo: `matchMedia("(max-width: 767px)")` num hook muda 2 vezes; ler `window.innerWidth` no resize re-renderiza a cada pixel.

**rerender-separar-hooks.** Um `useMemo` com filtro e ordenação refaz o filtro quando só a ordem muda. Separe: um `useMemo` filtra por categoria, outro ordena o resultado. O mesmo vale para `useEffect` com duas tarefas de dependências diferentes: dois efeitos.

**rerender-inicializacao-preguicosa.** Valor inicial caro vai em função: `useState(() => lerPreferencias())`, `useState(() => montarIndice(itens))`. Sem a função, roda a cada render. Para `useState(0)` ou `useState(props.valor)`, não precisa.

**rerender-transicao.** Atualização frequente e não urgente (posição de rolagem, filtro pesado) vai em `startTransition(() => setX(v))`, para a digitação e o clique responderem primeiro.

**rerender-valor-adiado.** Busca local em lista grande: o campo atualiza na hora e a lista usa o valor adiado.

```tsx
const [texto, setTexto] = useState("");
const adiado = useDeferredValue(texto);
const visiveis = useMemo(() => itens.filter(i => i.name.toLowerCase().includes(adiado.toLowerCase())), [itens, adiado]);
<Input value={texto} onChange={e => setTexto(e.target.value)} aria-label="Buscar produto" />
<div className={texto !== adiado ? "opacity-70" : undefined}><Lista itens={visiveis} /></div>
```

Busca no servidor (o normal na Fabapp) usa debounce de ~300ms em vez disso.

**rerender-ref-para-transitorio.** Valor que muda muito e não aparece na tela (posição do mouse, id de timeout, "já avisei") vai em `useRef`, não em `useState`. Se precisa mover algo na tela a cada evento, escreva direto no `style.transform` do elemento pelo ref.

**rerender-memo-simples-nao.** `useMemo(() => a || b, [a, b])` custa mais que a própria expressão. Só memorize trabalho de verdade.

## 4. render- (MEDIUM e LOW)

**render-esconder-sem-desmontar (MEDIUM).** O React 19.0 não tem `<Activity>`. Para uma aba ou painel caro que a pessoa abre e fecha muito e que deve manter o estado (rolagem, formulário), mantenha montado e esconda com `hidden`: `<div hidden={!aberto}><PainelFiltros /></div>`. Para conteúdo leve, desmontar é melhor.

**render-carregamento-com-transicao (LOW).** `useTransition` dá o `isPending` sem estado de carregamento manual e não fica preso em `true` se der erro:

```tsx
const [pendente, iniciar] = useTransition();
function trocarPeriodo(p: Periodo) {
  setPeriodo(p);
  iniciar(async () => { const dados = await carregar(p); setDados(dados); });
}
{pendente ? <Spinner /> : null}
```

**render-sem-piscar (MEDIUM).** Preferência guardada no aparelho (aba escolhida, modo compacto) é lida na inicialização do estado, não num `useEffect` depois da primeira pintura, senão a tela pinta o padrão e troca:

```tsx
// Errado: pinta "lista" e depois pula para "grade"
const [modo, setModo] = useState("lista");
useEffect(() => { const m = localStorage.getItem("produtos:modo:v1"); if (m) setModo(m); }, []);
// Certo
const [modo, setModo] = useState(() => { try { return localStorage.getItem("produtos:modo:v1") ?? "lista"; } catch { return "lista"; } });
```

**render-jsx-estatico (LOW).** JSX grande e fixo (um SVG ilustrativo, um bloco de texto legal) pode ficar numa constante fora do componente.

**render-svg (LOW).** Anime o `div` em volta do SVG, não o `<svg>` (a aceleração por GPU vale no `div`). Caminhos de SVG escritos à mão com 1 casa decimal bastam.

**render-dicas-de-recurso (LOW).** Fontes, `index.html` e cabeçalho são da plataforma. Só use `preload`/`preconnect` do `react-dom` quando a tela vai buscar num domínio externo conhecido logo em seguida (ex.: imagem de um parceiro na primeira dobra).

## 5. client- e eventos (MEDIUM a LOW)

**cliente-ouvinte-passivo (MEDIUM).** `touchstart`, `touchmove` e `wheel` que não chamam `preventDefault` vão com `{ passive: true }`; senão a rolagem espera o ouvinte. Gesto próprio de arrastar ou dar zoom precisa do `preventDefault`, então fica sem `passive`.

**cliente-ouvinte-unico (LOW).** Atalho de teclado usado em vários componentes registra UM ouvinte global num hook de `src/lib` (um `Map` de tecla para callbacks), não um `addEventListener` por instância.

**cliente-armazenamento-versionado (MEDIUM).** Detalhe da regra `seg-armazenamento-local`:

```ts
const CHAVE = "pedidos:filtro:v2";
export function salvarFiltro(f: { status: string; periodo: string }) {
  try { localStorage.setItem(CHAVE, JSON.stringify(f)); } catch { /* anônimo, cota cheia ou bloqueado */ }
}
export function lerFiltro(): { status: string; periodo: string } | null {
  try { const v = localStorage.getItem(CHAVE); return v ? JSON.parse(v) : null; } catch { return null; }
}
// Ao trocar o formato: leia a chave v1, converta, grave a v2 e apague a v1, tudo em try/catch.
```

## 6. js- (LOW-MEDIUM, só em caminho quente)

| Regra | Errado | Certo |
|---|---|---|
| js-indice-map | `pedidos.map(p => ({...p, cliente: clientes.find(c => c.id === p.customer)}))` | `const porId = new Map(clientes.map(c => [c.id, c]))` e `porId.get(p.customer)`. 1.000 × 1.000 vira 2.000 operações. |
| js-set-para-busca | `permitidos.includes(i.id)` dentro de `filter` | `const permitidos = new Set([...])` e `permitidos.has(i.id)` |
| js-uma-passada | três `filter` sobre a mesma lista | um `for` que separa nas três listas |
| js-flatmap | `.map(x => cond ? x.nome : null).filter(Boolean)` | `.flatMap(x => cond ? [x.nome] : [])` |
| js-min-max | ordenar para achar o maior | um laço guardando o maior; `Math.max(...lista)` só para listas pequenas (estoura acima de ~100 mil itens) |
| js-tosorted | `props.itens.sort(...)` (muda a prop e o estado) | `itens.toSorted(...)`; também `toReversed`, `toSpliced`, `with` |
| js-tamanho-primeiro | ordenar e juntar duas listas para comparar | se `a.length !== b.length`, já são diferentes; só então ordene com `toSorted` e compare item a item |
| js-retorno-cedo | validar a lista inteira acumulando erro | `return` no primeiro erro |
| js-regex-fora | `new RegExp(...)` a cada render | constante no módulo, ou `useMemo` quando depende do texto digitado (escape o texto). Regex com `/g` guarda `lastIndex`: não reutilize em `test` seguidos |
| js-cache-de-funcao | `formatarSlug(nome)` 200 vezes por render | `Map` de módulo com o resultado por entrada |
| js-cache-de-propriedade | `obj.config.ajustes.valor` dentro do laço | leia uma vez antes do laço |
| js-cache-de-storage | `localStorage.getItem` a cada chamada | `Map` em memória sincronizado na escrita; limpe no evento `storage` e quando a aba volta a ficar visível |
| js-dom-em-lote | ler `offsetWidth` entre escritas de estilo | escreva tudo e leia uma vez, ou troque uma classe; nunca meça layout durante o render |
| js-tempo-ocioso | salvar histórico de busca e pré-carregar no clique | `(window.requestIdleCallback ?? (cb => setTimeout(cb, 1)))(() => salvarHistorico(q))`; nunca para o que a pessoa está esperando ver |

## 7. avancado- (LOW)

**avancado-handler-em-ref.** O React 19.0 não tem `useEffectEvent`. Para um efeito que assina um evento e deve sempre chamar a versão mais nova do callback sem reassinar a cada render, guarde o callback num ref:

```tsx
function useEventoJanela(evento: string, handler: (e: Event) => void) {
  const ultimo = useRef(handler);
  useLayoutEffect(() => { ultimo.current = handler; });
  useEffect(() => {
    const ouvir = (e: Event) => ultimo.current(e);
    window.addEventListener(evento, ouvir);
    return () => window.removeEventListener(evento, ouvir);
  }, [evento]);
}
```

O mesmo padrão resolve a busca com atraso que chama `onBuscar` sem colocar `onBuscar` nas dependências. Nunca ponha a função do ref na lista de dependências.

**avancado-iniciar-uma-vez.** Inicialização do app inteiro (ler preferências, migrar chave antiga do `localStorage`) não fica no `useEffect([])` de um componente, que roda de novo a cada montagem. Use uma trava de módulo (`let iniciado = false`) ou rode no topo de um módulo de `src/lib`.

## 8. comp- (detalhe, MEDIUM)

**comp-composto-com-contexto.** Componente complexo e reutilizado (um editor de pedido usado no balcão, no app do cliente e num diálogo) vira um conjunto de peças que leem um contexto com três partes: `state`, `actions` e `meta`. O provider é o único lugar que sabe de onde vem o estado (estado local, `collection`, `useLive`); as peças só conhecem a interface.

```tsx
type PedidoCtx = {
  state: { itens: Item[]; obs: string; salvando: boolean };
  actions: { atualizar: (f: (s: PedidoCtx["state"]) => PedidoCtx["state"]) => void; enviar: () => Promise<void> };
  meta: { obsRef: React.RefObject<HTMLTextAreaElement | null> };
};
const Ctx = createContext<PedidoCtx | null>(null);
function usePedido() { const v = use(Ctx); if (!v) throw new Error("Fora do PedidoEditor.Provider"); return v; }

function Obs() {
  const { state, actions, meta } = usePedido();
  return <Field label="Observações" htmlFor="obs"><Textarea id="obs" ref={meta.obsRef} value={state.obs}
    onChange={e => actions.atualizar(s => ({ ...s, obs: e.target.value }))} /></Field>;
}
function Enviar() { const { state, actions } = usePedido(); return <LoadingButton loading={state.salvando} onClick={actions.enviar}>Enviar pedido</LoadingButton>; }
export const PedidoEditor = { Provider: Ctx, Itens, Obs, Enviar };
```

Dois providers diferentes (um com estado local para o balcão, outro sincronizado com `collection("order")` para o cliente) servem as MESMAS peças. Qualquer componente dentro do provider (um resumo ao lado, o botão no rodapé do `Dialog`) lê e age, mesmo fora da moldura visual: o limite que importa é o provider, não o aninhamento.

**comp-estado-icado.** Errado: estado preso dentro do componente e copiado para cima com `useEffect(() => onChange(estado), [estado])`, ou lido por `ref` na hora de enviar. Certo: o estado sobe para o provider e todos que precisam leem dele.

**comp-variantes-explicitas.** `<PedidoRapido/>`, `<PedidoCompleto/>`, `<EditarPedido pedidoId/>` dizem o que desenham; `<Pedido modoRapido editando={false} mostrarObs/>` não. Cada variante monta as peças de que precisa.

**comp-children.** `children` para estrutura; `renderX` só quando o pai entrega dados ao filho (`renderItem={({ item }) => ...}`).

**comp-react-19.** Sem `forwardRef`: `function Campo({ ref, ...props }: Props & { ref?: React.Ref<HTMLInputElement> })`. Leitura de contexto com `use(Contexto)`, que pode ficar dentro de `if`. Provider como `<Contexto value={...}>`.
