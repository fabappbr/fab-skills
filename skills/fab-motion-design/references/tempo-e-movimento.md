# Tempo e movimento

A peça roda a 30 quadros por segundo. Escreva sempre em segundos com `sec()`; o kit converte.

## A curva por intenção

Cada tipo de movimento tem a sua curva. Curva igual em tudo é o que deixa a peça correta mas sem graça: tudo chega do mesmo jeito, nada acelera, nada pesa. O kit exporta esta tabela como `INTENT`, e os componentes já a usam quando você não escreve `ease` nem `dur`.

| Intenção | Curva | Duração | Onde |
|---|---|---|---|
| entrada (`INTENT.entrance`) | `outExpo` | 18 a 24 quadros | chega rápido e assenta devagar: palavra, cartão, selo, botão |
| saída (`INTENT.exit`) | `inExpo` | 10 a 14 quadros | sai mais depressa do que entrou, acelerando |
| herói (`INTENT.hero`) | mola com sobra de 1,04 a 1,08 (`SPRINGS.hero`) | assenta em 24 quadros | o único elemento de que a cena trata: o preço, a palavra principal, o ícone que pulsa |
| câmera (`INTENT.camera`) | `inOutCubic` | longa: 1,5 s ou mais, muitas vezes a cena inteira | empurrar, panorâmica, giro, as chaves de `<Camera>` |
| contador (`INTENT.counter`) | `outExpo` | termina até 60% da cena e segura | `<AnimatedNumber>`, a contagem do `<SocialPost>` |

**Nunca `linear` na entrada ou na saída de um elemento**: o validador aponta `ease: "linear"` numa janela de até 36 quadros (`interpolate`, `progress`, `keyframes`, `<Move>`, `<Kinetic>`, `<WordSwap>`) e `useSceneProgress(de, até, "linear")`. Linear só serve para deriva na cena inteira (`useSceneProgress()` sem janela, uma chave de `<Camera>` lenta). Nunca `ease-in-out` padrão numa entrada.

## A personalidade de movimento da marca

O `brand.tone` escolhe, dentro de cada faixa da tabela acima, quantos quadros a entrada e a saída duram e quanto o herói passa do ponto. Use a linha da marca em todas as cenas; os componentes do kit (`<Kinetic>`, `<Icon>`, `<Title>`) já leem o tom sozinhos. Movimento escrito à mão não conhece o tom: `spring(frame, at, "hero")` é a sobra média (cerca de 1,06) e `progress(frame, at, dur)` usa o `dur` que você escreve, então escolha-o nesta tabela.

| Tom | Sobra do herói | Entrada | Saída | Ritmo das cenas |
|---|---|---|---|---|
| alegre (`cheerful`) | cerca de 1,07 | 18 quadros | 10 quadros | rápido, 1,5 a 2,5 s |
| animado (`energetic`) | cerca de 1,08 | 18 quadros | 10 quadros | muito rápido, 1,2 a 2 s |
| aconchegante (`cozy`) | cerca de 1,05 | 24 quadros | 14 quadros | médio, 2 a 3 s |
| elegante (`elegant`) | cerca de 1,04 | 24 quadros | 14 quadros | lento, 2,5 a 3,5 s |
| sóbrio (`sober`: saúde, direito, contabilidade) | cerca de 1,04 | 20 quadros | 12 quadros | médio, 2 a 3 s |

## Entradas

- Duram de **18 a 24 quadros** em `outExpo` (a curva por intenção); o herói entra com mola de **4 a 8% de sobra**. A linha do tom acima escolhe dentro dessas faixas.
- Junte 2 ou 3 propriedades: subir 24 a 40 px + opacidade de 0 a 1 + escala de 0,96 a 1.
- Escalonamento: **2 a 3 quadros entre palavras**, **4 a 8 entre grupos** (o título, depois o apoio, depois o botão).
- O elemento mais importante da cena entra por último ou com mais força (mais distância, mola com mais sobra). Normalmente é o preço.
- **Antecipação:** antes de todo soco, toque ou salto, um contramovimento de 2 a 4 quadros (o botão afunda 4% antes de crescer, a palavra recua antes do soco). Sem ele, o soco parece um corte.
- Por letra só em títulos de até 3 palavras. Digitação (`mode="type"`) só em cena que demonstra um pedido, uma busca ou um chat; nunca no gancho.
- **Gancho:** todo `<Kinetic>` da primeira cena (menos o `type`) assenta até o quadro 15, sejam quais forem `at`, `step` e `dur`; não encurte nada para caber.

## Saídas

- **10 a 14 quadros** em `inExpo`: mais rápida que a entrada, acelerando para fora.
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
- **Nunca três cenas seguidas com a mesma duração** (com folga de 2 quadros, numa peça de 15 s ou mais): três iguais viram metrônomo. Varie pelo menos uma batida entre elas.
- **Um acento a cada 8 a 10 s:** a cena mais curta da peça, uma batida inteira abaixo da mediana e de no máximo 1,5 s (uma palavra que soca, nunca abaixo de uma batida) ou uma troca de família de transição (uma sequência de cortes secos quebrada por um `whip`, um corte casado depois de `push`).
- **Uma pausa antes da chamada:** numa peça de 15 s ou mais, a cena logo antes do fecho dura pelo menos **1,5 vez a duração mediana** das cenas. Uma ideia só, movimento lento (deriva de câmera, o elemento focal respirando), nenhuma palavra heroica nova: a chamada final chega depois de um respiro. Se o roteiro esquecer, a plataforma alonga essa cena tirando batidas da vizinha mais longa.
- Cena com mais de 3 s tem uma **batida interna pelo menos a cada 1 s**: a palavra troca, um segundo elemento assenta, um contador corre, a câmera dá um soco. Cena de 5 s com uma entrada só e um zoom lento é slide. A única exceção é a pausa antes da chamada, que segura de propósito (a plataforma não a cobra).
- **Os cortes caem na música.** Toda troca de cena cai na grade de batidas da trilha, com folga de 2 quadros: a 120 bpm uma batida dura 0,5 s (15 quadros), então as cenas duram 1,5, 2, 2,5 s; a 100 bpm, múltiplos de 0,6 s (18 quadros). As batidas internas também caem na grade (`useBeat(bpm)` ajuda), e o pico cai num tempo forte (múltiplo de 4 batidas desde o início). Sem bpm no clima da trilha, conte 120.

## O que atravessa o corte

Pelo menos **1 em cada 3 cortes** leva alguma coisa para a cena seguinte (o `carry` do roteiro):

- **corte casado:** o mesmo elemento no mesmo lugar e tamanho no fim de uma cena e no começo da outra (`transition="match"`);
- **o botão vira o quadro:** o botão apertado cresce até ser o fundo da próxima cena;
- **campo de cor:** uma cor que varre o quadro e já é o fundo da próxima (`color-wipe`, `shape-<forma>`);
- **câmera que continua:** a cena sai empurrando para a esquerda e a próxima entra andando para a esquerda (`push-left`, `whip-left`).

Os outros cortes são secos, na batida.

## Transições

| Tipo | Quando | Efeito sonoro no corte |
|---|---|---|
| `cut` | Entre cenas de energia alta | nenhum, ou o som do que entra (`pop`, `thud`) |
| `slide` | Troca de item numa lista, carrossel virando vídeo | `whoosh` |
| `zoom` | Do detalhe para o todo, ou para o preço | `whoosh` curto |
| `brand-mask` | Abertura e fechamento: a forma da marca cobre e revela | `whoosh`, e `resolve` quando a marca assenta |
| `color-wipe` | Mudar de assunto (produto para ação) | `whoosh` |

Na segunda camada do kit (`<Scene canvas>`), as transições de motion design:

| Tipo | Quando | Efeito sonoro no corte |
|---|---|---|
| `match` | O mesmo elemento continua entre as cenas (forma, produto, moldura) | nenhum, ou um `tick` quando algo troca no corte (nunca `whoosh`) |
| `push-*` | Avançar na história, de um assunto para o seguinte | `whoosh` |
| `whip-*` | Energia, troca rápida, perto do pico | `whoosh` |
| `zoom-through` | Entrar no detalhe, mergulhar na próxima ideia | `whoosh` ou `pop` |
| `stack` | O fecho sobe por cima, como um cartão | `whoosh`, e `resolve` quando a marca assenta |
| `shape-<forma>` | Revelar pela forma da marca (círculo, estrela, flor) | `whoosh` ou `pop` |
| `fade` | Editorial e luxo, com calma; no máximo duas vezes | nenhum, ou `resolve` quando a marca entra no fecho (nunca `whoosh`) |

Varie: nunca a mesma transição em duas trocas seguidas, e pelo menos 3 tipos numa peça de 5 cenas ou mais. A transição dura de 8 a 18 quadros; `transitionFrames` muda quando precisar.

## Movimento calculado pelo quadro

- `interpolate(frame, [a, b], [de, para], { ease: "outExpo" })` para entradas (`progress(frame, at, INTENT.entrance.frames)` já usa `outExpo`); `"inExpo"` para saídas; `"snap"` para segurar e chicotear.
- `spring(frame, at, "hero")` para o herói da cena (preço, palavra principal, ícone); `"bouncy"` só para o que quica de propósito (confete, forma solta); `"gentle"` para editorial; `"heavy"` para o que pesa.
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
- Uma cena curta e mais calma (1,2 a 1,5 s, movimento desacelerado, sem efeito) vem logo antes do pico: é o acento.
- Numa peça de 15 s ou mais, a cena antes do fecho é a pausa: pelo menos 1,5 vez a duração mediana, um respiro antes da chamada.
- A ação final assenta e fica **parada no último segundo**.
- A ação final é calma e longa o bastante para ler e agir.
