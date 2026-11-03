# Tipografia e layout

## Zonas seguras

A interface do Reels, dos Stories e do TikTok cobre o topo (perfil), a base (legenda, botões) e as laterais (curtir, comentar). Texto, preço, logo e chamada ficam fora dessas faixas.

| Formato | Livre no topo | Livre na base | Livre nas laterais |
|---|---|---|---|
| 9:16 (1080 × 1920) | 14% (270 px) | 35% (670 px) | 6% (65 px) |
| 4:5 (1080 × 1350) | 6% | 6% | 6% |
| 1:1 (1080 × 1080) | 6% | 6% | 6% |
| Carrossel | 6% | 10% (indicador de slides) | 6% |

As laterais de 6% são o mínimo para a interface da rede não cobrir nada, não a margem do desenho. **Respiro (vale para PALAVRAS):** palavras e as caixas em volta delas (cartão, painel, botão) ficam a pelo menos 8% da largura de cada borda (cerca de 86 px em 1080), em todos os quadros. Um cartão ou painel tem no máximo cerca de 84% da largura do quadro, e o zoom da `<Camera>` cresce a caixa a partir do centro: dimensione para o pico do zoom. A plataforma mede isso na peça desenhada e devolve o que encostar na borda. Foto, produto e tipografia decorativa podem vazar pela borda: isso é escolha, não erro. A interface demonstrada (`<PromptBox>`, `<Checklist>`) é a exceção: caixa de 92% da largura segura ou vazando pelas duas bordas (`width="bleed"`).

O `<Safe>` posiciona as palavras dentro da área livre. Fundo, foto, cartão, produto e forma da marca podem ocupar o quadro inteiro: o visual principal é grande e desce pela faixa de baixo; a faixa nunca recebe uma forma solta só para "preencher". Numa cena cujo herói é um visual (foto, `<Picture>`, `<SocialPost>`, celular, produto, painel), ele fica FORA do `<Safe>`, grande, descendo pela faixa de baixo, e as palavras ficam acima dele dentro do `<Safe>`. Nunca a cena inteira encolhida na metade de cima sobre um vazio.

## Nada parece vazio

- Conteúdo de verdade (palavras, foto, produto, cartão, ícone) cobre pelo menos **35% do quadro**. `<Grid>`, `<Dots>`, `<Glow>` e `<Grain>` são decoração e não contam.
- A faixa de baixo (35% do 9:16) tem um visual em toda cena que não é pausa: a foto ou o produto descendo, o cartão, tipografia gigante cortada, corações subindo.
- **Use as bordas:** em pelo menos 2 cenas da peça um visual vaza pelo menos 10% para fora do quadro, de propósito (a foto cortada, a palavra gigante que sai pela lateral). O respiro de 8% é das palavras, não do visual.

## Caixa ou sem caixa

- As palavras ficam direto sobre o fundo, **ou** o cartão É o herói: pelo menos 84% da largura (ou vazando por uma borda), pelo menos 30% da altura do quadro, texto dentro de 64 px ou mais. Interface demonstrada (pedido digitado, busca, chat, lista de etapas) é `<PromptBox>` ou `<Checklist>` do kit, com texto de 80 px ou mais.
- Nada de cartão médio (um balão de 790 px com texto de 62 px no meio do quadro): ou ele cresce até ser o herói, ou some.
- Folga interna em em, para crescer com o texto: pelo menos `0.6em` nas laterais e `0.4em` em cima e embaixo.

## Tamanho do texto (em 1080 de largura): mire no alvo

**O mínimo é piso, nunca o tamanho que se mira.** Um título de 104 px quando o piso era 96, um apoio de 52 quando o piso era 48: é isso que deixa a peça com cara de modelo pronto. Mire na coluna "alvo".

| Papel | Alvo no 9:16 | Piso no 9:16 | 4:5 | 1:1 |
|---|---|---|---|---|
| Título herói | `<Kinetic fit>` puro: cerca de 72% da largura do quadro (até 340 px), 75% da largura segura ou mais | 150 px | 10% menor | 15% menor |
| Preço (`<PriceTag>`) | 230 a 430 px | 150 px | 10% menor | 15% menor |
| Apoio (frase sob o título, lista) | 64 a 80 px | 60 px | 56 px | 52 px |
| Sobretítulo e rótulo (sob um número, num cartão) | 48 a 56 px, caixa alta | 48 px | 44 px | 40 px |
| Texto da chamada (`<CallToAction size>`) | 72 px | 64 px | 60 px | 56 px |

- **No máximo 4 palavras heroicas** na tela ao mesmo tempo. Frase maior vira `<WordSwap>` ou uma segunda batida dentro da cena.
- **Proporção:** o herói tem de 2,5 a 4 vezes o tamanho do apoio. Herói de 104 com apoio de 62 não tem hierarquia.
- `<Kinetic fit>` sem faixa é o padrão da linha heroica: faz a linha mais larga ocupar cerca de 72% do quadro (de 150 a 340 px) e quebra uma linha longa no ponto mais equilibrado. `fit={[min, max]}` só define um teto, e o kit o sobe (até 340 px) quando ele deixaria a linha abaixo desse preenchimento: use faixa só para segurar uma palavra abaixo de outra, nunca para encher.
- Se o texto não cabe no tamanho do alvo, corte o texto, não diminua a fonte.

## Cortar o texto

- Palavra heroica numa cena só: "Pronto." e depois "PRONTO EM MINUTOS" repete o herói; a segunda cena diz a próxima coisa.
- Título: até 7 palavras. Sobretítulo: até 4. Legenda: até 8.
- Troque frase por substantivo concreto: "Feito com muito carinho todos os dias" vira "Feito toda manhã".
- Nada de ponto final em título. Exclamação no máximo uma por peça.
- Números como algarismo ("3 toques", não "três toques").
- Sem palavras que não dizem nada: "incrível", "maravilhoso", "o melhor", "venha conferir".

## Hierarquia

- Um ponto focal por cena.
- **Uma ênfase por palavra:** troca de cor, OU salto de escala de 1,15 para 1, OU marca-texto, OU círculo. Nunca duas ou três empilhadas ("horas" com cor + círculo + tremida é ruído). Círculo só em palavra de até 8 letras, com espaço livre em volta ou sozinha na linha.
- **Contador:** algarismos tabulares (`fontVariantNumeric: "tabular-nums"`), terminando até 60% da cena e parado no valor final. `<AnimatedNumber>` e `<SocialPost>` já fazem isso sozinhos.
- **Chamada:** é herói. O kit já desenha texto de 72 px, botão com 150 px de altura e 56% da largura (`variant="bar"`: 84%); nunca diminua. Se tem produto e preço, o preço é o foco na cena do preço; o produto, na cena do produto.
- No máximo 2 tamanhos de título e 1 de apoio por cena.
- Título na fonte de título da marca; o resto na fonte de texto. Nunca uma terceira fonte.

## Alinhamento

- Um eixo por cena: tudo centrado, ou tudo alinhado à esquerda numa mesma margem. Nunca metade de cada.
- Texto digitado: `<Kinetic mode="type">`. Ele monta a linha inteira desde o primeiro quadro (as letras ainda não digitadas ficam invisíveis) e o cursor não ocupa largura, então a linha centrada não anda. Fatiar a string a cada quadro ou desenhar o cursor com `<span>` recentra a linha a cada letra.
- Palavras em `<span>` com `display: inline-block` e `marginRight` deixam uma sobra no fim da linha e tiram o texto do centro: use `<Kinetic>` (que já separa as palavras) em vez de montar à mão.
- Número com rótulo: o número grande e o rótulo logo abaixo ou ao lado, os dois no mesmo eixo, o rótulo com pelo menos 48 px.

## Contraste

- Texto sobre cor: 4,5 para 1 no mínimo (o kit confere e recusa).
- Texto sobre foto ou vídeo: o `<Background>` escurece ou clareia sozinho até passar. Não desligue `dim`.
- Preço sobre o destaque da marca: se o destaque for claro, o texto do preço é a cor `text`.

## Cor

- Só as 4 cores da marca (ou da paleta que o pedido pediu: quando o pedido dá cores ou um visual, a direção grava a paleta da peça e o kit a usa no lugar das cores da marca; logo, nome e fontes continuam da marca). Cor de alerta (vermelho de promoção) só se for a cor da marca.
- Um esquema por peça, claro ou escuro (`scheme` e `tones` da marca). O ritmo vem de trocar entre `background`, `primary` e foto, nunca de alternar cena clara e cena escura. `bg="text"` inverte o esquema: só se o pedido pedir. Mantenha o mesmo fundo em cenas que mostram itens da mesma lista.
