# Tempo e movimento

A peça roda a 30 quadros por segundo. Escreva sempre em segundos com `sec()`; o kit converte.

## A personalidade de movimento da marca

O `brand.tone` decide a mola e a duração das entradas. Use a linha da marca em todas as cenas.

| Tom | Mola (`stiffness`, `damping`) | Entrada típica | Saída | Ritmo das cenas |
|---|---|---|---|---|
| alegre (`cheerful`) | 180, 12 (um pouco de sobra) | 0,45 s | 0,25 s | rápido, 1,5 a 2,5 s |
| animado (`energetic`) | 220, 14 | 0,35 s | 0,2 s | muito rápido, 1,2 a 2 s |
| aconchegante (`cozy`) | 120, 18 (sem sobra) | 0,6 s | 0,35 s | médio, 2 a 3 s |
| elegante (`elegant`) | 90, 22 (lenta e assentada) | 0,8 s | 0,45 s | lento, 2,5 a 3,5 s |
| sóbrio (`sober`: saúde, direito, contabilidade) | 140, 26 (sem sobra nenhuma) | 0,5 s | 0,3 s | médio, 2 a 3 s |

Easing quando não é mola: entrada `ease-out-expo` (`cubic-bezier(0.16, 1, 0.3, 1)`), saída `ease-in-quad` (`cubic-bezier(0.5, 0, 0.75, 0)`). Nunca `linear`, nunca `ease-in-out` padrão.

## Entradas

- Duram de **10 a 18 quadros**, com saída suave (`outExpo`, `outQuint`) ou mola com **3 a 8% de sobra**. A coluna do tom acima escolhe dentro dessa faixa.
- Junte 2 ou 3 propriedades: subir 24 a 40 px + opacidade de 0 a 1 + escala de 0,96 a 1.
- Escalonamento: **2 a 3 quadros entre palavras**, **4 a 8 entre grupos** (o título, depois o apoio, depois o botão).
- O elemento mais importante da cena entra por último ou com mais força (mais distância, mola com mais sobra). Normalmente é o preço.
- **Antecipação:** antes de todo soco, toque ou salto, um contramovimento de 2 a 4 quadros (o botão afunda 4% antes de crescer, a palavra recua antes do soco). Sem ele, o soco parece um corte.
- Por letra só em títulos de até 3 palavras. Digitação (`mode="type"`) só em cena que demonstra um pedido, uma busca ou um chat; nunca no gancho.
- **Gancho:** todo `<Kinetic>` da primeira cena (menos o `type`) assenta até o quadro 15, sejam quais forem `at`, `step` e `dur`; não encurte nada para caber.

## Saídas

- Cerca de 60% do tempo da entrada, com curva que acelera (`inQuad`, `inCubic`).
- Tudo sai junto ou em ordem inversa à entrada, nunca escalonado igual à entrada.
- Se a transição já leva a cena embora (`slide`, `color-wipe`), não anime a saída dos elementos.

## Nada parado (e nada sobrando)

- Movimento secundário (respiração, flutuação, pulso) só no elemento focal. Tudo respirando ao mesmo tempo vira tremor.
- Elemento focal depois de entrar: respiração de escala 1 a 1,02 num ciclo de 2 a 3 s.
- No máximo **uma camada de decoração de ambiente** por cena (`<Grid>`, `<Dots>`, `<Lines>`, `<Rings>` ou `<Glow>`), e pelo menos **30% das cenas sem nenhuma**: a textura delas é o assunto (a foto, o produto, a tipografia). `<Grain>` é o filme por cima de tudo, não conta como camada.
- Foto e vídeo: zoom lento de 1 a 1,06 durante a cena inteira (Ken Burns), direção alternada entre cenas.
- Nunca mais de 0,8 s com a tela inteira parada.

## Cadência e batida

- Até 30 s, um corte a cada **1,5 a 3 s**. A quantidade de cenas pela duração está em `references/direcao.md`.
- Cena com mais de 3 s tem uma **batida interna pelo menos a cada 1 s**: a palavra troca, um segundo elemento assenta, um contador corre, a câmera dá um soco. Cena de 5 s com uma entrada só e um zoom lento é slide.
- **Os cortes caem na música.** Toda troca de cena cai na grade de batidas da trilha, com folga de 2 quadros: a 120 bpm uma batida dura 0,5 s (15 quadros), então as cenas duram 1,5, 2, 2,5 s; a 100 bpm, múltiplos de 0,6 s (18 quadros). As batidas internas também caem na grade (`useBeat(bpm)` ajuda), e o pico cai num tempo forte (múltiplo de 4 batidas desde o início). Sem bpm no clima da trilha, conte 120.

## O que atravessa o corte

Pelo menos **1 em cada 3 cortes** leva alguma coisa para a cena seguinte (o `carry` do roteiro):

- **corte casado:** o mesmo elemento no mesmo lugar e tamanho no fim de uma cena e no começo da outra (`transition="match"`);
- **o botão vira o quadro:** o botão apertado cresce até ser o fundo da próxima cena;
- **campo de cor:** uma cor que varre o quadro e já é o fundo da próxima (`color-wipe`, `shape-<forma>`);
- **câmera que continua:** a cena sai empurrando para a esquerda e a próxima entra andando para a esquerda (`push-left`, `whip-left`).

Os outros cortes são secos, na batida.

## Transições

| Tipo | Quando | Efeito sonoro padrão (só em peça sem trilha) |
|---|---|---|
| `cut` | Entre cenas de energia alta | nenhum ou `pop` |
| `slide` | Troca de item numa lista, carrossel virando vídeo | `whoosh` |
| `zoom` | Do detalhe para o todo, ou para o preço | `whoosh` curto |
| `brand-mask` | Abertura e fechamento: a forma da marca cobre e revela | `shimmer` |
| `color-wipe` | Mudar de assunto (produto para ação) | `whoosh` |

Na segunda camada do kit (`<Scene canvas>`), as transições de motion design:

| Tipo | Quando | Efeito sonoro padrão (só em peça sem trilha) |
|---|---|---|
| `match` | O mesmo elemento continua entre as cenas (forma, produto, moldura) | nenhum ou `click` |
| `push-*` | Avançar na história, de um assunto para o seguinte | `whoosh` |
| `whip-*` | Energia, troca rápida, perto do pico | `whoosh` |
| `zoom-through` | Entrar no detalhe, mergulhar na próxima ideia | `whoosh` ou `pop` |
| `stack` | O fecho sobe por cima, como um cartão | `shimmer` |
| `shape-<forma>` | Revelar pela forma da marca (círculo, estrela, flor) | `pop` ou `shimmer` |
| `fade` | Editorial e luxo, com calma; no máximo duas vezes | nenhum |

Varie: nunca a mesma transição em duas trocas seguidas, e pelo menos 3 tipos numa peça de 5 cenas ou mais. A transição dura de 8 a 18 quadros; `transitionFrames` muda quando precisar.

## Movimento calculado pelo quadro

- `interpolate(frame, [a, b], [de, para], { ease: "outExpo" })` para entradas; `"snap"` para segurar e chicotear; `"inExpo"` para um mergulho de câmera que sai da cena.
- `spring(frame, at, "bouncy")` para o que chega e quica (selo, preço, forma); `"gentle"` para editorial; `"heavy"` para o que pesa.
- `stagger(i, 4)` escalona um grupo; `keyframes` move várias propriedades juntas.
- O que se repete (equalizador, respiração, brilho) usa `Math.sin(frame / k)` ou `useBeat(bpm)`; o que varia usa `hash01(seed, i)`. Nunca `Math.random`.

## A curva de energia

```
energia
  ▲            ┌──┐ pico (preço/oferta)
  │   ┌──┐     │  │
  │ ┌─┘  └─┐ ┌─┘  └──┐
  │─┘      └─┘ pausa  └── ação (constante, legível)
  └──────────────────────────▶ tempo
   gancho  miolo        fecho
```

- O gancho começa alto.
- O miolo oscila.
- Uma cena curta e mais calma (1,2 a 1,5 s, movimento desacelerado, sem efeito) vem logo antes do pico.
- A ação final assenta e fica **parada no último segundo**.
- A ação final é calma e longa o bastante para ler e agir.
