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
- Nunca mais de 0,8 s com a tela inteira parada, a não ser na pausa planejada antes do clímax.

## Transições

| Tipo | Quando | Efeito sonoro padrão |
|---|---|---|
| `cut` | Na batida forte, entre cenas de energia alta | nenhum ou `pop` |
| `slide` | Troca de item numa lista, carrossel virando vídeo | `whoosh` |
| `zoom` | Do detalhe para o todo, ou para o preço | `whoosh` curto |
| `brand-mask` | Abertura e fechamento: a forma da marca cobre e revela | `shimmer` |
| `color-wipe` | Mudar de assunto (produto para ação) | `whoosh` |

Varie: nunca a mesma transição mais de 2 vezes seguidas. A transição dura de 8 a 14 quadros.

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
- Uma pausa curta (0,4 a 0,8 s, trilha mais baixa, movimento desacelerado) vem logo antes do pico.
- A ação final é calma e longa o bastante para ler e agir.
