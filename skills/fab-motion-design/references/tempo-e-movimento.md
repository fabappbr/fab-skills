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

- Junte 2 ou 3 propriedades: subir 24 a 40 px + opacidade de 0 a 1 + escala de 0,96 a 1.
- Elementos da mesma cena entram em ordem de leitura com 3 a 6 quadros entre eles (`delay={4}`).
- O elemento mais importante da cena entra por último ou com mais força (mais distância, mola com mais sobra). Normalmente é o preço.
- Título por palavra: 2 a 3 quadros por palavra. Por letra só em títulos de até 3 palavras.

## Saídas

- Cerca de 60% do tempo da entrada.
- Tudo sai junto ou em ordem inversa à entrada, nunca escalonado igual à entrada.
- Se a transição já leva a cena embora (`slide`, `color-wipe`), não anime a saída dos elementos.

## Nada parado

- Elemento estático depois de entrar: respiração de escala 1 a 1,02 num ciclo de 2 a 3 s.
- Foto e vídeo: zoom lento de 1 a 1,06 durante a cena inteira (Ken Burns), direção alternada entre cenas.
- Nunca mais de 0,8 s com a tela inteira parada.

## Transições

| Tipo | Quando | Efeito sonoro padrão |
|---|---|---|
| `cut` | Entre cenas de energia alta | nenhum ou `pop` |
| `slide` | Troca de item numa lista, carrossel virando vídeo | `whoosh` |
| `zoom` | Do detalhe para o todo, ou para o preço | `whoosh` curto |
| `brand-mask` | Abertura e fechamento: a forma da marca cobre e revela | `shimmer` |
| `color-wipe` | Mudar de assunto (produto para ação) | `whoosh` |

Na segunda camada do kit (`<Scene canvas>`), as transições de motion design:

| Tipo | Quando | Efeito sonoro padrão |
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
- Uma cena curta e mais calma (0,8 a 1,2 s, movimento desacelerado, sem efeito) vem logo antes do pico.
- A ação final é calma e longa o bastante para ler e agir.
