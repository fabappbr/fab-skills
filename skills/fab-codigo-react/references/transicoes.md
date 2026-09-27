# Transições entre telas e estados (View Transitions no app Fabapp)

Regra de entrada: **se você não sabe dizer em uma frase o que a animação comunica, não use.** Transição é opcional. Use quando o dono pedir ("animação entre telas", "mais fluido") ou quando o app tem um fluxo visual de lista para detalhe (catálogo, galeria, cardápio, imóveis). Painel administrativo e formulário não ganham transição de página.

## O que existe e o que não existe nesta pilha

- O React do app é o 19.0 estável: **não existe `<ViewTransition>` nem `addTransitionType`**. Não instale `react@canary` e nunca troque a versão do React.
- O app usa `BrowserRouter`: a prop `viewTransition` do `<Link>` e o `navigate(..., { viewTransition: true })` do react-router **são ignorados** aqui, e `useViewTransitionState` quebra a tela (exige roteador de dados). Não use nenhum dos três.
- O que funciona: a API do navegador `document.startViewTransition`, chamada por um helper do app, com `flushSync` do `react-dom` para o React aplicar a mudança dentro do instantâneo. Suporte: Chrome e Edge, Safari 18 ou mais novo e as versões recentes do Firefox. Sem suporte, a mudança acontece na hora, sem animação.
- Sem arquivo de CSS novo: as animações direcionais são feitas pela Web Animations API sobre os pseudo-elementos (`pseudoElement: "::view-transition-new(root)"`). O cross-fade padrão do navegador não precisa de nada.

## O que animar, em ordem de prioridade

Implemente, nesta ordem, cada padrão que tem uso no app. Pule o que o app não tem.

| Prioridade | Padrão | O que comunica | Como |
|---|---|---|---|
| 1 | Elemento compartilhado | "é a mesma coisa, agora em detalhe" | mesmo `viewTransitionName` na foto do card e na foto do detalhe |
| 2 | Conteúdo que chegou | "o dado carregou" | `animate-in fade-in` no conteúdo ao sair do esqueleto (sem View Transition) |
| 3 | Identidade na lista | "os mesmos itens, em outra ordem" | nome por item e `comTransicao` na troca de ordenação |
| 4 | Aparece e some | "algo abriu ou fechou" | `comTransicao` no alternar, ou `animate-in` só na entrada |
| 5 | Troca de rota | "fui para outro lugar" | `navegar(para, direcao)` |

| Contexto | Animação | Por quê |
|---|---|---|
| Lista para detalhe (hierárquico) | deslizar para a frente e para trás | comunica profundidade |
| Anterior e próximo (foto, página de resultado) | deslizar: próximo entra pela direita, anterior pela esquerda | a direção diz a posição |
| Aba para aba, item da barra inferior | cross-fade ou nada | não há profundidade |
| Atualização em segundo plano (`useLive`, recarregar) | nada | silencioso |

Deslizar direcional só para navegação hierárquica e sequência ordenada.

## O helper (escreva em `src/lib/transicao.ts`)

```ts
import { flushSync } from "react-dom";
import { useNavigate } from "react-router-dom";

export type Direcao = "frente" | "volta" | "lado";
type DocVT = Document & { startViewTransition?: (cb: () => void) => { ready: Promise<void>; finished: Promise<void> } };

const SAIDA = 150, ENTRADA = 210, MOVIMENTO = 400;   // ms

function podeAnimar(): boolean {
  if (typeof window === "undefined") return false;
  if (!(document as DocVT).startViewTransition) return false;
  return !window.matchMedia("(prefers-reduced-motion: reduce)").matches;
}

export function comTransicao(atualizar: () => void, direcao: Direcao = "lado") {
  if (!podeAnimar()) { atualizar(); return; }
  const t = (document as DocVT).startViewTransition!(() => { flushSync(atualizar); });
  if (direcao === "lado") return;                      // cross-fade padrão do navegador
  const s = direcao === "frente" ? 1 : -1;
  t.ready.then(() => {
    const raiz = document.documentElement;
    const velho = "::view-transition-old(root)", novo = "::view-transition-new(root)";
    raiz.animate({ opacity: [1, 0] }, { duration: SAIDA, easing: "ease-in", fill: "both", pseudoElement: velho });
    raiz.animate({ transform: ["translateX(0)", `translateX(${-60 * s}px)`] }, { duration: MOVIMENTO, easing: "ease-in-out", fill: "both", pseudoElement: velho });
    raiz.animate({ opacity: [0, 1] }, { duration: ENTRADA, delay: SAIDA, easing: "ease-out", fill: "both", pseudoElement: novo });
    raiz.animate({ transform: [`translateX(${60 * s}px)`, "translateX(0)"] }, { duration: MOVIMENTO, easing: "ease-in-out", fill: "both", pseudoElement: novo });
  }).catch(() => { /* transição pulada: a mudança já aconteceu */ });
}

export function useNavegar() {
  const navigate = useNavigate();
  return (para: string, direcao: Direcao = "frente") => comTransicao(() => navigate(para), direcao);
}
```

O helper já pula a animação quando a pessoa pediu menos movimento ou o navegador não suporta. Sempre entrada E saída: sem a saída, a tela velha some de uma vez enquanto a nova anima.

## Passo a passo

**1. Mapa das navegações.** Antes de escrever, liste cada navegação do app e decida o padrão:

| De | Para | Direção | Padrão |
|---|---|---|---|
| /produtos | /produtos/:id | frente | deslizar + foto compartilhada |
| /produtos/:id | /produtos | volta | deslizar + foto compartilhada |
| /produtos/:id | /produtos/:outro | sequência | deslizar pela ordem (anterior/próximo) |
| aba Início | aba Pedidos | lado | cross-fade ou nada |
| esqueleto | conteúdo | (carga) | `animate-in fade-in` |

Para cada elemento compartilhado, anote em quais navegações o par se forma e em quais não (sem par, a página inteira desliza e o elemento vai junto).

**2. Casca fixa fora da animação.** Cabeçalho e barra de abas não deslizam com a página: dê um nome próprio e ela sai do instantâneo da raiz.

```tsx
<nav style={{ viewTransitionName: "barra-abas" }} className="fixed inset-x-0 bottom-0 md:hidden">...</nav>
```

Evite `backdrop-blur` no elemento nomeado (pisca no fim). Menu, popover e toast abertos durante a transição piscam: feche o menu antes de navegar (o `DropdownMenu` do kit fecha ao clicar no item).

**3. Direção nas navegações hierárquicas.** O link da lista para o detalhe navega para a frente; o botão "voltar" do app navega para trás com o endereço explícito (não `navigate(-1)`: o voltar do navegador e o `-1` não passam pelo helper e trocam a tela sem animação, o que é aceitável).

```tsx
const navegar = useNavegar();
<Link to={`/produtos/${p.id}`} onClick={e => { e.preventDefault(); navegar(`/produtos/${p.id}`, "frente"); }}>...</Link>
<Button variant="ghost" onClick={() => navegar("/produtos", "volta")} aria-label="Voltar para produtos"><ArrowLeft aria-hidden /></Button>
```

O `<Link>` continua sendo link (Ctrl+clique abre em nova aba, porque o `preventDefault` só roda no clique simples; confira `e.ctrlKey || e.metaKey || e.button !== 0` e deixe passar nesses casos).

Rota carregada sob demanda (o build divide as rotas sozinho, e componente com `lazy` também): se o pedaço ainda não baixou, o instantâneo novo mostra o esqueleto. Baixe antes e navegue depois: `import("./pages/ProductDetail").then(() => navegar(url, "frente"))`.

**4. Conteúdo que chegou.** Carregamento de dados não usa View Transition (a tela ficaria congelada esperando a rede). O conteúdo entra com `className="animate-in fade-in duration-300"` (do `tw-animate-css`, já instalado) quando sai do esqueleto. Um título que existe no esqueleto e no conteúdo pisca: desenhe-o fora do trecho que troca.

**5. Elemento compartilhado.** A foto do card e a foto do detalhe recebem o MESMO nome, único por registro:

```tsx
// no card da lista
<img src={p.photo} alt={p.name} className="aspect-square w-full rounded-xl object-cover" style={{ viewTransitionName: `produto-foto-${p.id}` }} />
// no detalhe
<img src={produto.photo} alt={produto.name} className="aspect-square w-full rounded-2xl object-cover" style={{ viewTransitionName: `produto-foto-${produto.id}` }} />
```

- Um nome só pode estar montado uma vez. Se o mesmo card aparece num `Dialog` e na página ao mesmo tempo, a transição é descartada: passe o nome por prop só onde ele deve morfar.
- O destino tem de estar na tela no instante da navegação: se a foto do detalhe depende de um carregamento, não há par, e a página desliza inteira. Para morfar, passe a URL da foto no `state` da navegação e desenhe a foto antes do resto carregar.
- Não nomeie títulos que mudam muito de tamanho (o texto ampliado vira borrão). Nomeie a imagem.
- Página com elemento compartilhado não usa saída só em fade: use o deslizar.
- Cada elemento nomeado vira uma camada à parte e fica sem clique durante a animação. Nomeie só os itens da página visível (a lista já é paginada) e mantenha as durações curtas.
- O arredondamento (`rounded-*`) fica no próprio elemento nomeado, senão some durante a animação.

**6. Lista reordenada ou filtrada.** Cada linha com nome (`linha-${item.id}`) e a troca de ordem dentro do helper: `comTransicao(() => setOrdem(nova))`. A seção abaixo de uma lista que cresce ou encolhe salta de lugar; para ela deslizar, dê um nome a ela também. Às vezes a solução melhor é não animar: lista de tamanho fixo com posições vazias reservadas não empurra nada. O que deve mudar na hora, sem animar (o rótulo "Ordenar: mais recentes" do botão), muda ANTES da chamada, fora do helper; só a lista muda dentro. Filtro guardado na URL anima do mesmo jeito: `comTransicao(() => setParams(...))`. Sem `key` novo no contêiner, a troca é uma atualização (cross-fade das linhas); `key` novo desmonta e recarrega tudo.

**7. Abrir e fechar.** Painel que expande: `comTransicao(() => setAberto(a => !a))` com o painel nomeado. Card que abre em detalhe na mesma tela: guarde `window.scrollY` antes de abrir e role de volta ao fechar. Quando só a entrada importa, use `animate-in fade-in slide-in-from-top-2` sem View Transition.

**8. Indicador de aba que desliza.** Um `span` com o nome fixo `indicador-abas`, desenhado só embaixo da aba ativa, e a troca de aba dentro de `comTransicao`. Se a aba nova carrega dados, troque a aba na hora e carregue depois, para o clique não parecer morto.

**9. Confira cada linha do mapa.** Em cada navegação: anima ou não? O par compartilhado se forma? Se não, a página desliza inteira de forma aceitável? A casca fica parada? A animação respeita a preferência de menos movimento?

## Tempos

| Interação | Duração |
|---|---|
| Alternar (abrir e fechar) | 100 a 200ms |
| Troca de rota (deslizar) | 150 a 250ms de saída e entrada, até 400ms de movimento |
| Conteúdo que chegou | 200 a 400ms |
| Elemento compartilhado | 300 a 500ms |

## Quando algo não anima ou anima errado

- **Não anima:** navegador sem suporte, preferência de menos movimento ligada, ou a mudança aconteceu fora do `comTransicao` (ou sem `flushSync`, então o React aplicou depois do instantâneo).
- **Nada anima e aparece erro de nome duplicado no console:** dois elementos com o mesmo `viewTransitionName` montados. Use o id do registro no nome.
- **Tudo faz cross-fade junto:** elemento demais nomeado. Tire nomes que não comunicam nada.
- **A rolagem trava durante a animação:** limitação do navegador (os instantâneos não rolam). Mantenha a animação curta.
- **Clique no meio da animação não pega:** a camada da transição captura o toque. Mantenha abaixo de 400ms.
- **Várias mudanças seguidas pulam etapas:** o navegador junta atualizações durante a animação (A, B, C, D vira B, D). É esperado.
- **Link com `#âncora` pula a rolagem:** navegue sem o hash e role por código depois.
- **O arredondamento some:** ponha `rounded-*` no elemento nomeado.
- **A casca com desfoque pisca:** tire o `backdrop-blur` do elemento nomeado.

## Acessibilidade

O helper não anima quando `prefers-reduced-motion: reduce` está ligado. Não crie outro caminho de animação que ignore essa preferência.
