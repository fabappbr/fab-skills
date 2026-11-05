# Tipografia e layout

## Composição: um bloco na grade (`<Layout>`)

O conteúdo de cada cena é **um bloco só**, posto pelo `<Layout>` numa grade de margens. É assim que a peça deixa de parecer amadora: nada de título grudado no topo e foto grudada embaixo com o meio vazio, nada de lista no alto com 60% do quadro vazio, nada de forma estacionada na borda cobrindo a última letra.

Os lugares (`place`): `optical` (padrão: o meio do bloco em 42% da altura do 9:16; gancho, afirmação), `upper` (palavras sobre um objeto, produto ou numeral embaixo), `lower` (para variar depois de uma `upper`), `center` (uma frase só, o cartão final) e `split` com `media` (palavras em cima e a imagem no resto do quadro; no 16:9, ao lado): toda cena com foto, `<Picture>`, post ou celular.

- **Margens da grade:** 10% da largura no 9:16 (108 px em 1080), 9% no 4:5 e no 1:1, 7% no 16:9. Palavras, rótulo, interface e chamada alinham nessa margem; `align="start"` (padrão) ou `"center"`, um eixo por cena.
- **O bloco:** um rótulo (`<Eyebrow variant="rule">`), no máximo **dois níveis de texto** (a linha de display e uma linha de apoio), ou uma interface (`<PromptBox>`, `<Checklist>`), ou a chamada. Ocupa de 25% a 60% da altura do quadro.
- **Split:** a imagem fica inteira dentro das margens e termina a 12% da base do 9:16 (pode ficar sob a legenda da rede, nunca cortada pela borda por acidente). `bleed` faz a imagem sangrar até as bordas, de propósito. Nunca posicione palavras ou imagem à mão contra uma borda (`justify="flex-start"`, `top`/`left` absolutos).
- **Decoração nunca encosta nas palavras.** Forma decorativa é `<Ornament>`; numeral ou letra gigante de fundo é `<Numeral>` ("01", um ano, a inicial). Escritos como filhos do `<Layout>`, vão para a zona livre acima ou abaixo do bloco, atrás dele, com uma folga (3,5% da altura no 9:16), no tamanho da zona, vazando pela borda de fora de propósito. No máximo 2 por cena, preenchimento com opacidade de 0,1 a 0,25 (o kit limita a 0,06 a 0,4), numa cor que não é a das palavras. Nunca `<Shape>`, `<Morph>` ou bolha com `x`/`y` como decoração perto de texto. Um selo posto à mão (a estrela da promoção) fica com folga do bloco: a ponta dele nunca encosta numa palavra, e as palavras dele cabem inteiras dentro dele.
- **Superfície:** estilos claros, editoriais e premium abrem a cena com `<Surface />` (luz suave nas cores da marca, curvas de nível tênues e grão fino). Estilos chapados deixam de fora.

## O sistema de tipos

O kit põe cada família no peso, espaçamento e entrelinha que ela pede, nos três papéis: **display** (a fonte de título da marca), **texto** (a fonte de texto) e **rótulo** (a fonte de texto em caixa alta espaçada). Não escreva `weight`, `tracking` nem `leading` em texto de título: uma serifa de display nunca vai a 800 (Playfair Display fica em 600, Fraunces em 500, DM Serif e Instrument Serif em 400); grotescas seguem em 800 com -0,035em. Esses pesos valem dentro do `<Layout>` (e sempre no `<Headline>`); fora dele, um `<Kinetic>` sem peso escrito fica no 800 do primeiro kit, para que as peças antigas saiam iguais em cada exportação. A plataforma mede os tamanhos em px na tela, com o mesmo piso em todo formato: por isso a escala quase não muda de um formato para outro.

| Papel | Componente | 9:16 | 4:5 | 1:1 e 16:9 |
|---|---|---|---|---|
| Display grande (até 2 palavras curtas) | `<Headline size="xl">` | 184 px | 172 | 164 |
| Display (padrão) | `<Headline>` | 150 px | 150 | 150 |
| Display menor (linha mais longa) | `<Headline size="m">` | 140 px | 140 | 140 |
| Texto de apoio | `<Kinetic font="body" size={60}>` | 60 px | 60 | 60 |
| Rótulo | `<Eyebrow variant="rule">` | 48 px | 48 | 48 |

- `<Headline>` quebra o texto no menor número de linhas que cabem na coluna, equilibradas (sem palavra órfã), no máximo cerca de 18 caracteres por linha.
- **Duas cores:** `lead="a preparação"` vem numa tinta mais quieta, a ideia (o `children`) na tinta cheia; `underline` desenha a régua de destaque sob ela. Use em pelo menos uma cena de peças editoriais.
- **Rótulo:** `<Eyebrow variant="rule">Passo 01 de 03</Eyebrow>`: 48 px, caixa alta, espaçamento 0,16em, algarismos tabulares, com uma régua curta na cor de destaque antes.
- Uma linha de soco de 1 a 3 palavras ainda pode ser `<Kinetic fit>` puro.

## Zonas seguras

A interface do Reels, dos Stories e do TikTok cobre o topo (perfil), a base (legenda, botões) e as laterais (curtir, comentar). Texto, preço, logo e chamada ficam fora dessas faixas.

| Formato | Livre no topo | Livre na base | Livre nas laterais |
|---|---|---|---|
| 9:16 (1080 × 1920) | 14% (270 px) | 35% (670 px) | 6% (65 px) |
| 4:5 (1080 × 1350) | 6% | 6% | 6% |
| 1:1 (1080 × 1080) | 6% | 6% | 6% |
| Carrossel | 6% | 10% (indicador de slides) | 6% |

As laterais de 6% são o mínimo para a interface da rede não cobrir nada, não a margem do desenho. **Respiro (vale para PALAVRAS):** palavras e as caixas em volta delas (cartão, painel, botão) ficam na margem da grade (10% da largura no 9:16, 108 px em 1080), em todos os quadros. Um cartão ou painel tem no máximo cerca de 84% da largura do quadro, e o zoom da `<Camera>` cresce a caixa a partir do centro: dimensione para o pico do zoom. A plataforma mede isso na peça desenhada e devolve o que encostar na borda. Foto, produto e tipografia decorativa podem vazar pela borda: isso é escolha, não erro. A interface demonstrada (`<PromptBox>`, `<Checklist>`) é a exceção: caixa de 92% da largura segura ou vazando pelas duas bordas (`width="bleed"`).

O `<Layout>` posiciona as palavras dentro da área livre (o `<Safe>` segue valendo nas peças antigas e no cartão final). Numa cena cujo herói é uma imagem, use `place="split"`: a imagem desce pela faixa de baixo, inteira dentro das margens, e as palavras ficam acima dela. A faixa nunca recebe uma forma solta só para "preencher", e a cena nunca fica encolhida na metade de cima sobre um vazio.

## Nada parece vazio

- Conteúdo de verdade (palavras, foto, produto, cartão, ícone) cobre pelo menos **35% do quadro**. `<Grid>`, `<Dots>`, `<Glow>` e `<Grain>` são decoração e não contam.
- Cena com imagem é `split` (a imagem enche a faixa de baixo); cena só de palavras fica no centro óptico, com a decoração nas zonas livres.
- **Use as bordas:** em pelo menos 2 cenas da peça um visual sangra de propósito: o `split` com `bleed`, a foto por duas bordas ou mais (a largura inteira, um canto), ou de canto reto (`radius={0}`) com 20% ou mais para fora de uma borda; a palavra gigante que sai pela lateral. Cartão de canto arredondado cortado por uma borda só, ou foto cortada de 1% a 19% por uma borda, parece erro e volta para correção. O respiro da margem é das palavras, não do visual.

## Caixa ou sem caixa

- As palavras ficam direto sobre o fundo, **ou** o cartão É o herói: pelo menos 84% da largura (ou vazando por uma borda), pelo menos 30% da altura do quadro, texto dentro de 64 px ou mais. Interface demonstrada (pedido digitado, busca, chat, lista de etapas) é `<PromptBox>` ou `<Checklist>` do kit, com texto de 80 px ou mais.
- Nada de cartão médio (um balão de 790 px com texto de 62 px no meio do quadro): ou ele cresce até ser o herói, ou some.
- Folga interna em em, para crescer com o texto: pelo menos `0.6em` nas laterais e `0.4em` em cima e embaixo.

## Tamanho do texto (em 1080 de largura): mire no alvo

**O mínimo é piso, nunca o tamanho que se mira.** Um título de 104 px quando o piso era 96, um apoio de 52 quando o piso era 48: é isso que deixa a peça com cara de modelo pronto. Mire na coluna "alvo".

| Papel | Alvo no 9:16 | Piso no 9:16 | 4:5 | 1:1 |
|---|---|---|---|---|
| Título herói | `<Headline>` (150 px) ou `<Headline size="xl">` (184 px); soco de 1 a 3 palavras: `<Kinetic fit>` puro | 140 px | 140 px | 140 px |
| Preço (`<PriceTag>`) | 230 a 430 px | 150 px | 10% menor | 15% menor |
| Apoio (frase sob o título, lista) | 64 a 80 px | 60 px | 60 px | 60 px |
| Sobretítulo e rótulo (sob um número, num cartão) | 48 a 56 px, caixa alta espaçada (0,06em ou mais, até 6 palavras: só assim vale o piso de 48; uma frase em caixa alta espaçada é apoio, 60 px) | 48 px | 48 px | 48 px |
| Texto da chamada (`<CallToAction size>`) | 72 px | 64 px | 60 px | 56 px |

- **No máximo 7 palavras de display** na tela ao mesmo tempo (contando o `lead`). Frase maior vira `<WordSwap>` ou uma segunda batida dentro da cena.
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
