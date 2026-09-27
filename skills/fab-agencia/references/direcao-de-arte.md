# Direção de Arte: o que separa um site de agência de um site feito por IA

O piso de engenharia impede o site de quebrar. Esta barra impede ele de parecer genérico. Leia antes de propor conceitos (Fase 3) e antes de escrever prompts de imagem (Fase 6).

## Como um júri olha um site

Júris de premiação (Awwwards, CSS Design Awards, FWA) avaliam quatro eixos. O Awwwards pondera assim, e é um bom mapa para distribuir o esforço:

| Eixo | Peso | O que o júri procura |
|---|---|---|
| **Design** | 40% | Direção visual própria, tipografia com intenção, composição, ritmo, cor, detalhe |
| **Usabilidade** | 30% | Navegação clara, desempenho, acessibilidade, funciona no celular, nada trava |
| **Criatividade** | 20% | Uma ideia que ninguém fez daquele jeito, interação que surpreende e faz sentido |
| **Conteúdo** | 10% | Texto que vale ler, imagens que contam a história, informação que serve |

Duas lições saem da tabela. A usabilidade pesa quase tanto quanto o design: um site lindo que engasga ou quebra no celular perde. E criatividade não é quantidade de efeito: é uma ideia forte executada até o fim.

## A ideia antes do visual

Todo site premiado tem uma ideia que cabe numa frase. "A página é uma folha de papel que vai sendo dobrada." "Cada seção é uma hora do dia na cozinha." "O cursor é uma lanterna num arquivo escuro." Sem essa frase, o resultado é uma sequência de seções bonitas que não somam.

Método para achar a ideia: pegue UMA palavra ou gesto real do mundo do assunto (o ofício, o material, o ritual, o lugar) e pergunte como a página inteira poderia encenar aquilo. A premissa da marca no pacote de design sai daqui.

## A barra (tudo isto, sempre)

- **Comprometa-se com UMA direção tirada do mundo do assunto** e deixe ela comandar paleta, tipografia, grid, movimento e imagem juntos. Meia direção é pior que nenhuma.
- **Invente um elemento assinatura** único deste site e gaste nele o orçamento de ousadia. Todo o resto fica quieto para a assinatura ler. Teste de volume: se a assinatura fosse removida, a página mudaria de verdade? Se mal mudaria, não é assinatura.
- **Duas seções vizinhas nunca dividem o mesmo esqueleto.** Se duas vizinhas abrem com rótulo, título e parágrafo sobre a mesma grade, remodele uma. O visitante nunca deve sentir o mesmo molde carimbado duas vezes.
- **O acento aparece em doses raras:** a chamada para ação, estados de foco, um ou dois momentos de ênfase. Acento em tudo não é acento.
- **A tela nunca é `#000` ou `#fff` puros.** Tinja o fundo na direção da marca.
- **A página é um ambiente:** uma camada de fundo sutil atrás de tudo (grão, gradiente que respira, textura do material da marca), para rolar parecer atravessar um lugar.
- **Detalhe é o que um júri vê de perto:** alinhamento óptico, pontuação pendurada em citações, números tabulares em preços, aspas tipográficas (“ ”), estados de hover desenhados, foco visível e bonito, favicon da marca, página 404 desenhada.

## Proibido como reflexo (a cara de IA)

Estes visuais são proibidos como padrão, a menos que o usuário peça um deles explicitamente:

- Tela creme com serifa e acento terracota.
- Quase preto com verde ácido ou neon.
- Quase preto com acento âmbar e serifa de alto contraste (o reflexo seguinte da fila sempre que alguém diz "escuro, sofisticado, cinematográfico").
- Brutalismo de borda fininha com mono em tudo.
- Gradiente roxo para azul, glassmorphism genérico, blobs 3D flutuando, cards com sombra suave em grade de três.
- Hero com título centralizado, subtítulo cinza e dois botões lado a lado, seguido de três cards de "benefícios" com ícone.
- Emojis como ícones, ícones de linha genéricos em círculos coloridos.

A exceção: quando um desses é genuinamente o mundo material do assunto (um ateliê de cerâmica vive mesmo em creme e terracota), o assunto vence. Mereça: amostre os tons do material real, invente a assinatura, fuja do layout de molde, e diga o desvio em voz alta.

## Tipografia: onde mora metade do design

- **Um sistema, não duas fontes.** Display com personalidade real, texto quieto e legível, mono para rótulos pequenos e dados. Nunca Inter, Roboto, Open Sans ou Poppins como display.
- **Escolha faces do mundo da marca.** Uma marcenaria pede uma serifa com entalhe; um estúdio de som pede uma grotesca condensada; uma clínica pede uma humanista calma. No catálogo do Google Fonts há escolhas fortes e pouco gastas: Fraunces, Instrument Serif, Newsreader, Young Serif, Bricolage Grotesque, Familjen Grotesk, Unbounded, Syne, Space Grotesk, Hanken Grotesk, Schibsted Grotesk, Onest, Geist, Figtree, Manrope, Big Shoulders Display, Anton, Archivo (com eixo de largura), Playfair Display SC, DM Serif Display, Gloock. Isto é ponto de partida, não cardápio fechado.
- **Escala fluida e dramática.** Títulos de hero de 12 a 20vw em conceitos editoriais não são exagero; são o design. Use `clamp()` para cada passo da escala (ver `construcao-react.md`). Contraste de tamanho entre título e texto é o que dá hierarquia de agência.
- **Tracking e entrelinha por tamanho.** Display grande com tracking negativo (−0,02 a −0,05em) e entrelinha apertada (0,9 a 1,05); texto com entrelinha 1,5 a 1,7 e medida de 60 a 75 caracteres; rótulos pequenos em caixa alta com tracking positivo (0,08 a 0,14em).
- **Fontes variáveis são ferramenta de movimento:** peso, largura e inclinação podem responder ao scroll ou ao cursor (`font-variation-settings` animado por variável CSS). Um dos gestos mais premiados e baratos. Atenção: as fontes do tema chegam em pesos FIXOS (400 a 800), sem eixos variáveis, então esse gesto só funciona com a face auto-hospedada por um pacote `@fontsource-variable/<familia>`. Sem ele, troque o gesto por movimento (transform) e diga o desvio.
- `text-wrap: balance` em títulos, `text-wrap: pretty` em parágrafos. Nada de viúvas no hero.

## Grid e composição

- **Grid de 12 colunas com margens generosas** e liberdade de quebrá-lo com intenção: um título que sangra para fora, uma imagem que atravessa duas colunas de texto, um número gigante encostado na borda.
- **Assimetria deliberada** vence centralização segura. Espaço vazio é material de design, não sobra.
- **Ritmo vertical:** alterne seções densas e seções que respiram; alterne largura cheia e coluna estreita; alterne claro e escuro quando a marca permitir.
- **Escala de espaçamento** baseada numa unidade (4 ou 8px) com passos fluidos para as margens de seção (de 96 a 200px no desktop).
- **Composição para o celular é desenho próprio,** não o desktop empilhado. Decida o que cada seção vira em 375px.

## Cor

- **Paleta de três a cinco cores tiradas do mundo da marca**, escrita em tokens (o tema da plataforma) e, no CSS do site, trabalhada em `oklch()` para derivar variações perceptualmente iguais (`oklch(from var(--color-primary) calc(l + 0.1) c h)`).
- `color-mix(in oklab, ...)` para superfícies, bordas e estados, em vez de hex solto.
- **Contraste medido, não chutado:** 4,5:1 para texto de corpo, 3:1 para texto grande e bordas de controles. A plataforma deriva o texto da marca para passar AA; o CSS do site não pode desfazer isso.
- Modo escuro, quando existir, é desenhado, não invertido.

## O elemento assinatura: exemplos de território

Para destravar a imaginação, não para copiar:

- Um título que muda de peso ou largura conforme o scroll, como se respirasse.
- Uma linha SVG contínua que atravessa a página inteira e se desenha enquanto o visitante desce, ligando as seções.
- Um cursor que vira uma lupa, uma lanterna, um pincel ou uma amostra de cor do material da marca.
- Imagens que se revelam por máscara com a forma do logotipo ou de um objeto do ofício.
- Uma seção horizontal fixada onde o processo da marca passa como uma esteira.
- Números de prova que contam enquanto um gráfico desenhado à mão se traça.
- Uma textura do material real (madeira, papel, tecido, azulejo) como fundo que reage ao cursor.

## Direção de arte das imagens (`<AppImage prompt>`)

Os prompts são escritos em inglês, porque os modelos de imagem rendem melhor assim. A conversa com o usuário continua em português.

### As leis da imagem

1. **Um mundo só.** Toda imagem do site compartilha paleta, luz, lente e tratamento, descritos explicitamente em cada prompt. Imagens de mundos diferentes leem como banco de imagens.
2. **Componha para o layout.** Decida antes onde o texto vai sentar e descreva a região calma como parte da cena ("soft shadowed wall on the left third"), nunca como "empty space" ou "dark area": o modelo pinta painéis vazios literais.
3. **Assuntos tolerantes.** Luz, materiais, texturas, arquitetura, objetos, mãos à distância e silhuetas renderizam bem. Rostos em close, mãos em detalhe, texto, telas de interface e logotipos mostram os erros.
4. **Nada de texto nem marca.** Todo prompt termina com "no text, no logos, no lettering, no watermarks".
5. **Pessoa real só com foto real.** Rosto do dono ou da equipe vem de foto enviada por ele. Nunca gere um rosto passando por uma pessoa real do negócio, e nunca use foto de alguém que não consentiu.
6. **Tratamento igual para elementos paralelos.** Se uma seção tem três passos, os três ganham imagem com o mesmo enquadramento. Assimetria lê como buraco.
7. **Coerência de marca.** Liste os detalhes assinatura da marca (a cor dela, o material, o que ela faz) e inspecione cada imagem contra a lista, não só contra anatomia e marcas registradas.

### O modelo de prompt

```
[SUBJECT] at [POSITION IN FRAME], [SHOT: close-up / medium / wide, lens feel, e.g. 50mm, shallow depth of field].
[LIGHTING: source, direction, time of day, mood]. [PALETTE: the brand colors described as materials and light,
not hex codes]. [MATERIAL AND TEXTURE DETAIL]. [ATMOSPHERE]. The [LEFT THIRD / TOP HALF] is a calm continuous
[surface/wall/sky/shadow] where a headline will sit. Editorial photography, [ASPECT: 16:9 / 4:5 / 1:1],
cohesive with the rest of the set: [SHARED TREATMENT SENTENCE]. No text, no logos, no lettering, no watermarks.
```

A frase de tratamento compartilhado (por exemplo "warm late-afternoon light, muted forest green and linen tones, fine film grain, 35mm editorial look") se repete idêntica em todos os prompts do site. É ela que faz o conjunto ler como uma sessão de fotos.

### Proporções por papel

| Papel | Proporção | Observação |
|---|---|---|
| Hero de largura cheia | 16:9 ou 21:9 | a região do título descrita como parte da cena |
| Hero em coluna, editorial | 4:5 ou 3:4 | composição vertical, assunto no terço superior |
| Cards de serviço ou passos | 4:3 ou 1:1 | mesmo enquadramento em todos |
| Fundo de seção com texto por cima | 16:9 | cena calma e contínua, sem ponto focal forte |
| Imagem de compartilhamento (og) | 1200x630 | legível em miniatura, sem texto gerado |

### Depois que as imagens existem

Olhe cada imagem escolhida ou gerada antes de dar o site por pronto: marcas registradas contrabandeadas, anatomia quebrada, texto fantasma, cor errada da marca, composição que briga com o layout. Uma troca de imagem é barata agora; uma imagem errada no ar mina a marca. E a inspeção corre nos dois sentidos: quando a imagem sai melhor que o plano (uma composição mais forte, um detalhe mais sutil), ajuste o layout para honrar o presente.
