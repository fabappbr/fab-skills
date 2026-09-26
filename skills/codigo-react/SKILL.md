---
name: codigo-react
description: "Faz o código React de um app da Fabapp AI construído ou editado pelo terminal (CLI @fabappai/cli) sair rápido, estável e acessível: telas que carregam os dados em paralelo, sem tela piscando, sem campo que perde o foco a cada letra, sem '0' solto na tela, sem biblioteca inteira no pacote, listas longas que rolam leves, componentes pesados carregados sob demanda, componentes compostos em vez de dezenas de opções, formulários com rótulo, foco visível e teclado funcionando, números alinhados, filtros no endereço da página e transições de tela só quando comunicam algo. Use em TODO app construído ou editado, e com prioridade quando o dono disser: 'o app está lento', 'demora para abrir', 'trava quando digito', 'o campo perde o foco', 'aparece um zero na tela', 'a tela pisca', 'a lista é enorme', 'não funciona no teclado', 'acessibilidade', 'leitor de tela', 'revisa o código', 'melhora a performance', 'otimiza', 'deixa mais fluido', 'animação entre telas'."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Código React de Qualidade
  edition: terminal
---

# Código React de Qualidade

Regras de código para o app da Fabapp que você escreve pelo terminal (React 19.0 + Vite + react-router-dom v7 em `BrowserRouter`, tudo no navegador).

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

O código vive em `.fabapp/workspace/src/` e sobe com `fabapp deploy`; as funções de backend em `functions/<nome>.ts` na raiz do workspace. Não existe servidor React aqui: onde uma regra clássica fala de Server Components ou rotas de API, ela vira regra sobre as chamadas ao SDK (`collection`, `useLive`, `callFunction`) e sobre as funções de backend (`functions/<nome>.ts`).

Cada regra tem um prefixo de área e um nível de impacto. O nível decide o que fazer com ela:

| Nível | O que significa | O que você faz |
|---|---|---|
| CRITICAL | trava a tela, multiplica a espera ou incha o pacote | **Bloqueia a entrega.** Corrija antes de dizer pronto ao dono. |
| HIGH | bug visível ao usuário, perda de estado, falha de acesso, tela inacessível | **Bloqueia a entrega.** Corrija antes de dizer pronto ao dono. |
| MEDIUM | re-render desnecessário, detalhe de interface | Melhoria: aplique ao escrever código novo. |
| LOW | micro-otimização | Melhoria: só em caminho quente (lista grande, digitação, rolagem). |

| Área | Prefixo | Impacto |
|---|---|---|
| Chamadas ao SDK sem cascata | `dados-` | CRITICAL |
| Tamanho do pacote | `pacote-` | CRITICAL |
| Estado e efeitos | `estado-` | HIGH |
| Segurança no cliente e nas funções | `seg-` | HIGH |
| Acessibilidade e formulários | `a11y-` | HIGH |
| Renderização e listas | `render-` | HIGH a MEDIUM |
| Composição de componentes | `comp-` | MEDIUM |
| Re-render | `rerender-` | MEDIUM |
| JavaScript em caminho quente | `js-` | LOW-MEDIUM |
| Padrões avançados | `avancado-` | LOW |
| Transições de tela | `transicao-` | LOW (opcional) |

As regras MEDIUM e LOW com exemplo completo estão em `references/regras-completas.md`; a lista de interface web está em `references/interface-web.md`; as transições de tela em `references/transicoes.md`. Leia as três antes de escrever a primeira tela e aplique direto.

## A construção e as mudanças depois: regras que bloqueiam a entrega

### dados- (CRITICAL): nenhuma espera em fila

**dados-paralelo.** Chamadas independentes saem juntas. Cada `await` em sequência soma uma ida e volta inteira à rede; num painel com 4 consultas isso é 4 vezes a espera.

```tsx
// Errado: 3 idas e voltas em fila
const clientes = await collection<Cliente>("customer").list({ limit: 20 });
const total = await collection("order").count({ status: "pending" });
const hoje = await collection<Agendamento>("booking").list({ filter: { starts_at: { gte: inicioDoDia } } });

// Certo: 1 ida e volta
const [clientes, total, hoje] = await Promise.all([
  collection<Cliente>("customer").list({ limit: 20, sort: "-created_at" }),
  collection("order").count({ status: "pending" }),
  collection<Agendamento>("booking").list({ filter: { starts_at: { gte: inicioDoDia } }, sort: "starts_at" }),
]);
```

Quando uma chamada depende de outra só em parte, dispare a independente primeiro e encadeie a dependente com `.then`, juntando tudo num `Promise.all` no fim.

**dados-sem-n-mais-1.** Nunca uma chamada por item dentro de um `map`. Para mostrar o nome de um registro ligado, use o `<campo>__label` que já vem no registro. Para os filhos de um pai, filtre pelo `ref` (`filter: { order: pedidoId }`). O filtro não aceita `id` (dá 422): quando precisa de mais campos dos registros ligados, carregue a lista deles uma vez e indexe num `Map`.

```tsx
// Errado: 50 pedidos = 50 chamadas
const comCliente = await Promise.all(pedidos.map(p => collection("customer").get(p.customer)));

// Certo: o nome já vem expandido
<span>{pedido.customer__label}</span>
// Certo: precisa do telefone também? a lista de clientes uma vez, só as colunas usadas, indexada
const clientes = await collection<Cliente>("customer").list({ fields: ["name", "phone"], limit: 200 });
const porId = new Map(clientes.map(c => [c.id, c]));
// Poucos ids e lista grande demais para carregar? ids sem repetição, em paralelo, nunca em fila
const ids = [...new Set(pedidos.map(p => p.customer))];
const alguns = await Promise.all(ids.map(id => collection<Cliente>("customer").get(id, { fields: ["phone"] })));
```

**dados-no-servidor.** Filtro, ordem e paginação vão no `list({filter, sort, limit, offset})`; o total vem de `count(filter)`, nunca de `list().length`. Lista grande pede só as colunas usadas (`fields`). Busca digitada espera ~300ms (debounce) antes de chamar. Lista que muda sozinha usa `useLive(model, {filter, sort, limit})`; nunca `setInterval`.

**dados-casca-primeiro.** A tela não espera todos os dados para aparecer. `PageHeader`, abas e botões desenham na hora; cada seção tem seu próprio carregamento (`Skeleton` do mesmo tamanho do conteúdo, para não pular). Um spinner de página inteira antes do título é erro. Exceções, com um carregamento só para a tela: dado que decide o layout inteiro (o registro de uma rota `:id`), consulta pequena e rápida em que o esqueleto por seção só criaria pulos, e o texto principal de página pública.

**dados-await-no-ramo.** Espere só no caminho que usa o dado, e confira a condição barata antes da chamada cara.

```tsx
// Errado: busca o plano mesmo quando o usuário nem está logado
const { plan } = await carregarPlano();
if (!user || plan !== "premium") return;

// Certo: condição local primeiro, chamada depois
if (!user) return;
const { plan } = await carregarPlano();
```

### pacote- (CRITICAL): só entra no pacote o que a tela usa

**pacote-import-nomeado.** Importe peças pelo nome. Proibido: `import * as Icons from "lucide-react"`, mapa próprio de ícones por nome, `import _ from "lodash"` ou `moment`. Ícone que vem de um campo `icon` do registro usa o `<Icon name={...}/>` do kit, e só nesse caso (ele carrega o catálogo inteiro de ícones).

```tsx
// Errado
import * as Icons from "lucide-react";
import _ from "lodash";
const I = (Icons as any)[categoria.icon];
const buscar = _.debounce(fn, 300);

// Certo
import { Search, Plus } from "lucide-react";
import { Icon } from "@/components/ui/icon";
<Icon name={categoria.icon} className="size-5" />
// debounce: um setTimeout num useEffect, ou `lodash-es/debounce` se precisar mesmo
```

**pacote-sob-demanda.** Componente pesado que não aparece na primeira pintura (editor rico, gráfico grande, leitor de PDF, leitor de QR, mapa, planilha) entra com `React.lazy` + `Suspense` dentro da página. As rotas, em `src/routes.tsx`, ficam com import simples: o build da plataforma divide as rotas sozinho (ver `references/fabapp-cli.md`), então rota pesada de uso ocasional (relatórios, configurações, admin) já baixa só quando é aberta.

```tsx
// src/pages/Reports.tsx
import { lazy, Suspense } from "react";
const GraficoAnual = lazy(() => import("@/components/reports/GraficoAnual"));

<Suspense fallback={<Skeleton className="h-80" />}><GraficoAnual dados={dados} /></Suspense>
```

Nunca `await import(...)`: a plataforma proíbe, e o `fabapp deploy` não confere por você (busque no código antes de publicar). Módulo carregado quando o usuário liga um recurso usa `import("./x").then(m => ...)`. O caminho do `import()` é sempre literal; para escolher entre vários, um mapa `{ a: () => import("./a"), b: () => import("./b") }`, nunca `import(variavel)`.

### estado- (HIGH): estado mínimo, sem efeito copiando dado

**estado-derivado-no-render.** O que dá para calcular a partir de props, estado ou dados carregados é calculado no render. `useEffect` que só faz `setX(algo de Y)` é erro: renderiza duas vezes e fica fora de sincronia.

```tsx
// Errado
const [total, setTotal] = useState(0);
useEffect(() => { setTotal(itens.reduce((s, i) => s + i.price * i.qty, 0)); }, [itens]);

// Certo
const total = itens.reduce((s, i) => s + i.price * i.qty, 0);
<span className="tabular-nums">{formatMoney(total)}</span>
```

Cálculo caro sobre lista grande: `useMemo`. Expressão simples com resultado primitivo (`a || b`, `x > 0`): sem `useMemo`.

**estado-prop-copiada.** Não copie prop para estado e sincronize com efeito. Se o formulário edita um registro, inicialize uma vez e troque o registro com `key`.

```tsx
// Errado: o formulário não acompanha a troca de cliente, ou sobrescreve o que foi digitado
function FormCliente({ cliente }: { cliente: Cliente }) {
  const [nome, setNome] = useState(cliente.name);
  useEffect(() => { setNome(cliente.name); }, [cliente]);
}

// Certo: estado inicial uma vez; outro cliente = componente novo
<FormCliente key={cliente.id} cliente={cliente} />
```

**estado-componente-dentro.** Nunca declare um componente dentro de outro. A cada render ele vira um tipo novo: o React desmonta e monta de novo, o campo perde o foco a cada letra, a animação reinicia e o efeito roda outra vez. Passe props.

```tsx
// Errado
function ListaPedidos({ pedidos }: Props) {
  const Linha = ({ p }: { p: Pedido }) => <li>{p.code}</li>;
  return <ul>{pedidos.map(p => <Linha key={p.id} p={p} />)}</ul>;
}

// Certo: no nível do módulo
function LinhaPedido({ pedido }: { pedido: Pedido }) { return <li>{pedido.code}</li>; }
```

**estado-acao-no-handler.** O que acontece por causa de um clique ou envio roda no handler, não num `useEffect` vigiando um estado `enviado`. **estado-set-funcional.** Atualização que depende do valor anterior usa a forma funcional (`setItens(atual => [...atual, novo])`); evita valor velho preso no callback.

### seg- (HIGH): o cliente não é a barreira

**seg-funcao-autoriza.** O manifesto `fab.functions.json` decide quem chama a função; `ctx.collection` ignora as regras de acesso. Toda função que toca dado confere `ctx.user`, valida o corpo com `zod` e só age no registro que aquela pessoa pode mexer. Nunca confie em `userId`, `amount` ou `price` vindos do corpo: o autor é `ctx.user`, o preço vem do registro. Erro volta como `{ detail }` com status 4xx, dentro de `try/catch`.

**seg-armazenamento-local.** `localStorage` só guarda preferência de tela (tema, aba, filtro), com chave versionada (`"pedidos:filtro:v1"`), só os campos necessários e leitura/escrita dentro de `try/catch` (falha em aba anônima e cota cheia). Nunca token, senha, CPF, dado de saúde, nem decisão de permissão (`isAdmin`).

**seg-cache-por-usuario.** Cache em variável de módulo em `src/lib` (catálogo, configurações) não guarda dado de uma pessoa, ou é limpo no `logout`: na mesma aba outra pessoa pode entrar depois.

### a11y- (HIGH): toda pessoa consegue usar

- Botão de ação é `<Button>`/`<button>`; navegação é `<Link>` ou `<a>`. `div` ou `span` com `onClick` é erro (não recebe foco nem Enter).
- Botão só com ícone tem `aria-label` ("Excluir pedido"); o ícone decorativo tem `aria-hidden`.
- Todo campo tem rótulo: `<Field label htmlFor>` com `id` no controle, ou `aria-label` quando não há rótulo visível. Placeholder não é rótulo.
- Imagem de dado tem `alt` descritivo; imagem decorativa tem `alt=""`.
- Foco visível em todo elemento interativo (`focus-visible:ring-*`, o kit já traz). `outline-none` só com substituto.
- Títulos em ordem (um `h1` por tela, depois `h2`, `h3`).
- Aviso assíncrono (salvo, erro) vai por toast do `sonner` (já anuncia ao leitor de tela) ou por região com `aria-live="polite"`.
- Erro de formulário aparece ao lado do campo, e o envio leva o foco ao primeiro campo com erro.

### render- (HIGH nos dois primeiros)

**render-sem-zero.** `&&` com número desenha `0` na tela. Use comparação explícita ou ternário.

```tsx
// Errado: com 0 pendentes aparece "0" solto
{pendentes && <Badge>{pendentes}</Badge>}
{pedidos.length && <Lista pedidos={pedidos} />}

// Certo
{pendentes > 0 ? <Badge>{pendentes}</Badge> : null}
{pedidos.length > 0 ? <Lista pedidos={pedidos} /> : <EmptyState title="Nenhum pedido ainda" action={<Button>Novo pedido</Button>} />}
```

**render-lista-longa.** Lista que pode passar de 50 itens é paginada no servidor (`Pagination` + `limit/offset`, ou "Carregar mais"). Quando a tela precisa mesmo mostrar centenas de uma vez (chat, histórico), cada item leva `[content-visibility:auto] [contain-intrinsic-size:auto_72px]` (a altura aproximada do item) ou a lista é virtualizada com um pacote como `@tanstack/react-virtual`. Nunca `.map()` de milhares de linhas sem isso.

**render-transicao-nao-urgente** (MEDIUM). Filtro que re-renderiza lista grande enquanto a pessoa digita: `useDeferredValue` no texto e `useMemo` no filtro; troca de aba pesada dentro de `startTransition`.

### comp- (MEDIUM, aplique sempre que criar componente reutilizável)

Não crie componente com várias props booleanas (`isEdit`, `isCompact`, `showActions`, `isAdmin`): cada booleano dobra os estados possíveis. Crie variantes explícitas que compõem partes em comum, ou um componente composto com contexto.

```tsx
// Errado
<CardPedido pedido={p} isCompact showActions={isAdmin} isEditing={false} />

// Certo: variantes explícitas montadas com as mesmas partes
<PedidoCard.Root pedido={p}>
  <PedidoCard.Resumo />
  {isAdmin ? <PedidoCard.Acoes /> : null}
</PedidoCard.Root>
```

Prefira `children` a props `renderX`; `renderItem` só quando o pai entrega dados ao filho. No React 19 `ref` é prop comum (sem `forwardRef`) e contexto se lê com `use(Contexto)`. O detalhe (provider com `state/actions/meta`, estado içado) está em `references/regras-completas.md`.

## A construção: melhorias (MEDIUM e LOW)

Aplique as regras `rerender-`, `render-`, `js-` e `avancado-` de `references/regras-completas.md` ao escrever código novo, com prioridade em tela de digitação, lista longa e rolagem. Não reescreva código que funciona só para aplicar uma regra LOW.

Toda tela segue `references/interface-web.md`. Os itens marcados **[bloqueia]** lá são HIGH e entram na autorrevisão; o resto é melhoria.

Transição animada entre telas é opcional e segue `references/transicoes.md`. Critério único: se você não sabe dizer em uma frase o que a animação comunica ("é o mesmo produto, agora em detalhe"), não use.

## Mudanças depois

- Antes de mexer, leia o arquivo inteiro com a ferramenta de leitura de arquivos da sua ferramenta. Não suponha nome de campo, prop ou hook: confira no schema e no código.
- Corrija as regras CRITICAL e HIGH que encontrar **nos arquivos que você tocou**. Não saia refatorando o app inteiro sem pedido.
- Pedido de "está lento" ou "trava": procure primeiro cascata de `await`, chamada dentro de `map`, `list()` sem `limit`, `setInterval`, componente declarado dentro de outro, filtro no cliente sobre lista enorme e componente pesado sem `lazy`, nesta ordem.
- Pedido de "revisa a acessibilidade" ou "revisa o código": varra as regras que bloqueiam e `references/interface-web.md`, corrija, e conte ao dono o que mudou em linguagem simples ("os botões de ícone agora dizem o que fazem para quem usa leitor de tela").

## Conferir antes de dizer pronto: autorrevisão

Percorra cada arquivo que você escreveu e anote para si, no formato `src/pages/Pedidos.tsx:42 botão de ícone sem aria-label`, cada violação das regras que bloqueiam:

1. `await` independentes em sequência; chamada ao SDK dentro de `map`; `list()` sem `limit`; `setInterval` em lista.
2. `import * as` de biblioteca, `lodash`/`moment` inteiros, `await import(`, componente pesado fora da primeira pintura sem `lazy`.
3. `useEffect` que só copia ou calcula estado; componente declarado dentro de componente.
4. Função sem checagem de `ctx.user`; token ou dado pessoal em `localStorage`.
5. `div onClick`, botão de ícone sem `aria-label`, campo sem rótulo, imagem sem `alt`, `outline-none` sem substituto.
6. `&&` com número ou `.length`; lista sem paginação que pode passar de 50.
7. Itens **[bloqueia]** de `references/interface-web.md`.

Busque também por texto o que a plataforma proíbe e o `fabapp deploy` não confere, por exemplo:

```bash
cd .fabapp/workspace
grep -rnE "await import\(|import \* as|from \"lodash\"|moment|setInterval|window\.confirm|alert\(|outline-none|transition-all|animation-timeline" src functions
grep -rnE "&& <|\.length &&" src
```

Depois rode `npx tsc -b` e `npx vite build` dentro de `.fabapp/workspace` quando puder, abra a pré-visualização do `fabapp dev` e percorra cada tela tocada no celular e no desktop, com o console aberto e só o teclado (Tab, Enter, Espaço, Esc). Publique com `fabapp deploy` e leia a saída inteira: `build_failed` (422) traz arquivo, linha e coluna, conserte antes de repetir; `account_builds_busy` (409) é espera, não erro.

Corrija tudo o que anotou. A lista não vai para o dono. Na mensagem final, relate só o que você conferiu, em frases de dono ("a tela de pedidos abre carregando as três seções ao mesmo tempo").
