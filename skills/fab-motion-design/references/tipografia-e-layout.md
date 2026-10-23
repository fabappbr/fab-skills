# Tipografia e layout

## Zonas seguras

A interface do Reels, dos Stories e do TikTok cobre o topo (perfil), a base (legenda, botões) e as laterais (curtir, comentar). Texto, preço, logo e chamada ficam fora dessas faixas.

| Formato | Livre no topo | Livre na base | Livre nas laterais |
|---|---|---|---|
| 9:16 (1080 × 1920) | 14% (270 px) | 35% (670 px) | 6% (65 px) |
| 4:5 (1080 × 1350) | 6% | 6% | 6% |
| 1:1 (1080 × 1080) | 6% | 6% | 6% |
| Carrossel | 6% | 10% (indicador de slides) | 6% |

O `<Scene>` já posiciona o conteúdo dentro da área livre. Fundo, foto e forma da marca podem ocupar o quadro inteiro.

## Tamanho do texto (em 1080 de largura)

| Papel | 9:16 | 4:5 | 1:1 |
|---|---|---|---|
| Título | 96 a 140 px | 84 a 120 px | 76 a 110 px |
| Preço (`xl`) | 140 a 180 px | 120 a 160 px | 110 a 140 px |
| Sobretítulo | 36 a 44 px, caixa alta | 34 a 40 px | 32 a 38 px |
| Legenda e lista | 48 a 60 px | 44 a 54 px | 40 a 50 px |
| Mínimo absoluto | 40 px | 36 px | 34 px |

Use os tamanhos do kit (`size="m" | "l" | "xl"`). Se o texto não cabe no tamanho mínimo, corte o texto, não diminua a fonte.

## Cortar o texto

- Título: até 7 palavras. Sobretítulo: até 4. Legenda: até 8.
- Troque frase por substantivo concreto: "Feito com muito carinho todos os dias" vira "Feito toda manhã".
- Nada de ponto final em título. Exclamação no máximo uma por peça.
- Números como algarismo ("3 toques", não "três toques").
- Sem palavras que não dizem nada: "incrível", "maravilhoso", "o melhor", "venha conferir".

## Hierarquia

- Um ponto focal por cena. Se tem produto e preço, o preço é o foco na cena do preço; o produto, na cena do produto.
- No máximo 2 tamanhos de título e 1 de apoio por cena.
- Título na fonte de título da marca; o resto na fonte de texto. Nunca uma terceira fonte.

## Contraste

- Texto sobre cor: 4,5 para 1 no mínimo (o kit confere e recusa).
- Texto sobre foto ou vídeo: o `<Background>` escurece ou clareia sozinho até passar. Não desligue `dim`.
- Preço sobre o destaque da marca: se o destaque for claro, o texto do preço é a cor `text`.

## Cor

- Só as 4 cores da marca. Cor de alerta (vermelho de promoção) só se for a cor da marca.
- Alterne o fundo entre cenas (principal, fundo, texto) para dar ritmo, mas mantenha o mesmo fundo em cenas que mostram itens da mesma lista.
