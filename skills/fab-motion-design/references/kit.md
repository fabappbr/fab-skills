# O kit @fab/motion

Os componentes que a composição pode usar. Todos leem o tema da marca (cores, fontes, raio), respeitam a zona segura do formato e entram com a mola do tom da marca.

Nomes de componentes, propriedades e valores são em inglês, como todo o código da plataforma. O texto que aparece na peça continua no idioma da marca.

> Conferido contra o código do kit em 29/10/2026 (`studio/src/motion/kit/index.ts`). O kit é a fonte da verdade; uma propriedade que não está aqui não existe. Um teste no repositório da plataforma (`studio/src/motion/kit/skillDocs.test.ts`) falha quando uma exportação do kit falta aqui ou quando este arquivo cita um componente que o kit não tem.

O kit tem duas camadas. A **primeira** (cenas em coluna, `<Title>`, `<Price>`, `<EndCard>`) continua valendo e desenha igual. A **segunda**, de motion design, é a que dá acabamento de estúdio: cena em tela livre (`<Scene canvas>`), tempo calculado pelo quadro, câmera, revelações, formas, tipografia cinética e textura. Toda peça nova usa a segunda camada; a primeira serve para ajustes em peças antigas. As duas se misturam: `<CallToAction>` e `<Soundtrack>` são as mesmas.

## Utilitários e dados

| Nome | O que é |
|---|---|
| `sec(seconds)` | Converte segundos em quadros (30 por segundo). Use sempre; nunca escreva quadros à mão. |
| `brand` | `{ name, logo_url, colors: { primary, accent, background, text }, fonts: { heading, body }, radius, tone, locale }`. Não traz `scheme` nem `tones`: esses vêm na nota BRAND do pedido, para você ler, nunca para o código ler. |
| `items` | `[{ name, price_minor, was_price_minor, currency, unit, installments, photo_url, description, link }]`, já conferidos pelo dono. |
| `reviews` | `[{ author, text, rating }]`, só reais. Pode vir vazio. |
| Cores | Onde se pede cor, use o nome do papel: `"primary" | "accent" | "background" | "text"`, mais `"ink"` para texto que você estiliza (e `"white"`, `"black"` para formas). Hex não é aceito. |

Passe o item inteiro para o componente (`item={items[0]}`). A composição nunca lê `price_minor`, `was_price_minor` nem `installments` para escrever na tela: quem formata preço é o `<Price>`, e o desconto é o `<Badge>`. O nome (`items[0].name`) pode ir num `<Title>`.

Quase todo componente aceita `delay` (em quadros, desde o início da cena). É assim que se escalona: `delay={0}`, `delay={5}`, `delay={10}`.

## Estrutura

| Componente | Propriedades | Notas |
|---|---|---|
| `<Sequence>` | `soundtrack?` | Raiz do vídeo. Toca as cenas em ordem. `soundtrack="track"` pede a trilha gerada da peça. |
| `<Scene>` | `duration`, `background?`, `transition?`, `sfx?`, `align?: "center" | "top" | "bottom"`, `editedByOwner?` | Um momento. O conteúdo fica dentro da zona segura. `sfx` toca no começo da cena. |
| `<Slide>` | `role: "cover" | "item" | "end"`, `background?`, `continues?` | Quadro do carrossel (o carrossel não usa `<Sequence>`). |
| `<Soundtrack>` | `mood?` (a música a gerar, em inglês curto), `volume?` (0 a 1, padrão 0,6), `sfx?` (com trilha, os efeitos só tocam com `sfx` escrito, quando o pedido pede efeitos), `take?` e `src?` (a escolha do dono no editor) | Opcional, dentro da `<Sequence>`. `mood` só quando o pedido fala da música. `take` e `src` são escritos pelo editor: mantenha-os ao ajustar e nunca os invente (veja `som.md`). |

A transição vai na cena que entra: `transition: "cut" | "slide" | "zoom" | "brand-mask" | "color-wipe"`. Sem `transition`, é corte seco.

## Texto

| Componente | Propriedades | Notas |
|---|---|---|
| `<Title>` | `entrance?: "word" | "letter" | "line" | "rise"`, `highlight?` (palavra a colorir), `size?: "m" | "l" | "xl"` | Quebra de linha calculada pelo tamanho. Até 7 palavras. |
| `<Eyebrow>` | `variant?: "uppercase" | "pill"` | A linha pequena acima do título: urgência, data, categoria. Até 4 palavras. |
| `<Caption>` | `position?: "center" | "safe-bottom"` | Para quem assiste sem som. Até 8 palavras. |
| `<List>` | `items` (textos), `marker?: "number" | "dot" | "check"`, `interval?` (quadros entre linhas) | Até 5 linhas. Cada linha entra separada. |
| `<AnimatedNumber>` | `value`, `suffix?`, `duration?` | Conta até o valor em algarismos tabulares. O valor vem de dado, nunca digitado. Por padrão termina até 60% da cena e fica parado no valor final (um `duration` escrito vence). |

## Comércio

| Componente | Propriedades | Notas |
|---|---|---|
| `<Price>` | `item`, `showWasPrice?`, `showInstallments?`, `size?: "m" | "l" | "xl"` | Formata na moeda do item e no idioma da marca. Sem preço no item, não renderiza. |
| `<Badge>` | `item?` ou `text?`, `shape?: "circle" | "star" | "ribbon"`, `color?: "primary" | "accent"` | Com `item`, mostra o desconto calculado (só se houver preço antigo maior). Com `text`, um selo curto ("Novo"). |
| `<Product>` | `item`, `cutout?`, `shadow?`, `motion?: "spring" | "float" | "gentle-spin"`, `height?` (px, ou `"s" | "m" | "l" | "xl"`) | Foto real do item. `cutout` usa o recorte sem fundo (a plataforma gera). Sem foto, não renderiza. |
| `<ProductGrid>` | `items`, `columns?`, `showPrice?` | 2 a 4 itens. |
| `<Compare>` | `a`, `b` (imagens), `labels: [string, string]`, `variant?: "wipe" | "side-by-side"` | Antes e depois, plano A e B. |

## Marca

| Componente | Propriedades | Notas |
|---|---|---|
| `<LogoIntro>` | `variant?: "stamp" | "draw" | "reveal"` | Só quando o pedido pede marca. Nunca como primeira cena de anúncio. |
| `<EndCard>` | `cta`, `contact?` (`@`, telefone, site) | Última cena: logo, nome e a chamada. |
| `<BrandShape>` | `shape?: "circle" | "blob" | "band" | "grid"`, `position?` | Elemento gráfico que se repete nas peças da marca. |

## Prova e informação

| Componente | Propriedades | Notas |
|---|---|---|
| `<Testimonial>` | `review` (um de `reviews` ou o índice), `showStars?` | Só de `reviews`. Corta em até 12 palavras. |
| `<Rating>` | `average`, `total` | De dado. |
| `<Hours>` | `days`, `ranges` | Horário de funcionamento. |
| `<Address>` | `address`, `neighborhood?`, `landmark?` | Alfinete animado, sem mapa. |
| `<Countdown>` | `until` (data), `units?: ["days", "hours", "minutes"]` | Mostra o tempo restante no dia da exportação. |

## Chamada

| Componente | Propriedades | Notas |
|---|---|---|
| `<CallToAction>` | `action: "whatsapp" | "link" | "link-in-bio" | "call" | "visit" | "open-app" | "order" | "book"`, `text`, `variant?: "pill" | "outline" | "text" | "bar"`, `color?` (papel, padrão `accent`), `size?` (px do texto, padrão 72), `arrow?`, `align?: "start" | "center" | "end"` | Um verbo. É herói: o kit já desenha o botão com texto de 72 px, pelo menos 150 px de altura e 56% da largura do quadro; `variant="bar"` ocupa 84% da largura. Não diminua: texto de 64 a 80 px. Com `pill`, `outline` e `bar`, um texto que não cabe numa linha (4 palavras ditadas, por exemplo) vai para duas linhas equilibradas no tamanho pedido em vez de encolher: não encurte as palavras do dono. Longo demais é só o que nem em duas linhas fica com 64 px. Fica parado no último segundo. Ocupa a largura das próprias palavras e segue o alinhamento da coluna em que está (num `<Safe>` centrado, fica centrado). Escolha o `variant` que combina com a peça: `pill` cheio é o padrão, `outline` num fechamento elegante, `text` (palavras com seta, sublinhadas) num estilo editorial, `bar` (bloco largo com seta) num fechamento de impacto. Não feche toda peça com o mesmo botão. `action="whatsapp"` pinta o botão de verde WhatsApp quando não há `color`: use só quando o pedido manda para o WhatsApp; para site ou endereço, `action="link"`. |
| `<QrCode>` | `target`, `caption?` | Para vitrine, TV da loja, impresso. |

`<AppScreen>` e `<Tap>` existem no kit, mas a gravação das telas do app ainda não. Não use: sem a tela, aparece um celular vazio.

## Fundo

O fundo vai em `background` da `<Scene>` (ou do `<Slide>`):

| `type` | Campos | Notas |
|---|---|---|
| `"color"` | `color` (papel) | O mais comum. |
| `"gradient"` | `color?` | Do papel para o texto. |
| `"photo"` | `source` (de dado: `items[0].photo_url`) | Com zoom lento. |
| `"owner-video"` | `source`, `from`, `focus`, `dim` | O vídeo do próprio dono. Só ele escolhe, pelo editor; você nunca escreve um. Num ajuste, mantenha-o como está. |
| `"ai-image"` | `prompt`, `slot` | Imagem gerada. Barata; sai junto com a peça. |
| `"ai-video"` | `prompt`, `slot` | Vídeo gerado de 5 a 10 s, sem som. Caro: o dono confirma o preço de cada um antes. Use onde o movimento ajuda a cena. |

Campos comuns: `dim?` (0 a 1; escurece para o texto passar; com foto ou mídia o padrão já é 0,45) e `blur?`.

## Vagas de mídia

Pedir mídia gerada é declarar uma vaga (`slot`) com um nome curto e um `prompt`. A plataforma gera depois da composição, cobra só quando o arquivo fica pronto e preenche a vaga; até lá, a cena mostra um degradê da marca no lugar.

```tsx
<Scene duration={sec(2)} background={{ type: "ai-video", prompt: "bancada de doceria com luz da manhã, açúcar caindo devagar", slot: "opening" }}>
<Scene duration={sec(3)} background={{ type: "ai-image", prompt: "textura de papel creme com manchas suaves de cacau", slot: "price-bg" }}>
```

- Uma vaga por fundo. Repetir o mesmo `slot` reaproveita a mesma mídia.
- O `prompt` descreve assunto, cenário, luz e movimento. A plataforma já acrescenta "sem texto e sem logo"; não peça letra nem pessoa realista, e nunca imite um produto, uma fachada ou um ambiente que tem foto (a foto real vai na cena). Sem foto, o produto e o lugar podem ser gerados.
- Ao ajustar uma peça, mantenha `slot` e `prompt` de um fundo que não mudou: a mídia pronta é reaproveitada sem custo.
- `prompt` e `slot` são **texto literal** no próprio elemento (`prompt="…"`, `slot="…"`) ou uma `const NOME = "…"` no topo do arquivo. Prop, template com `${}`, `.map` sobre uma lista ou chamada de função a plataforma não lê: a mídia nunca seria gerada, e o validador recusa (`media_prompt`).

## Imagem como elemento: `<Picture>`

A imagem gerada serve primeiro ao **assunto**: a vitrine, o prato, o lugar, a foto dentro do post ou da tela do celular, o produto sem foto. Ela entra na composição como elemento, não só como fundo atrás de tudo. Fundo abstrato e textura vêm depois.

| Componente | Props | Notas |
|---|---|---|
| `<Picture>` | `slot`, `prompt`, `type?: "ai-image" \| "ai-video" \| "photo"` (padrão `"ai-image"`), `src?`, `fit?: "cover" \| "contain"`, `focus?: "top" \| "center" \| "bottom"`, `width?`, `height?`, `aspect?` (`1`, `"4/5"`, `"16/9"`), `radius?` (px ou `"brand"`, o padrão), `shape?: "rect" \| "circle"`, `frame?: "none" \| "polaroid" \| "phone"`, `zoom?` (Ken Burns lento, ligado), `shadow?`, `dim?`, `from?`, `alt?`, `style?` | Ocupa a caixa onde está (100% × 100%) ou o tamanho dado. Até o arquivo ficar pronto, mostra um degradê da marca com um brilho lento, nunca uma caixa vazia. Declara a vaga como o fundo: a plataforma gera e cobra igual. `type="photo"` com a vaga `owner-photo-N` põe a foto do dono; `src={items[0].photo_url}` põe a foto do item. |

```tsx
const P2_SHOP = "vitrine de padaria com pães dourados, luz quente da manhã, close-up, sem texto";

function P2Post() {
  return (
    <div style={{ width: 640, height: 640, borderRadius: 48, overflow: "hidden" }}>
      <Picture slot="post-photo" prompt={P2_SHOP} />
    </div>
  );
}

<Picture slot="chef" prompt="padeira sorrindo com avental de linho, ilustração editorial" shape="circle" width={360} />
<Picture slot="loaf" prompt="pão de fermentação natural sobre tábua, luz lateral" frame="polaroid" width={520} aspect="4/5" />
<Picture type="photo" slot="owner-photo-1" frame="phone" />
```

- Cada imagem de coisa que o pedido manda mostrar é uma `<Picture>` com vaga própria, na cena que a mostra.
- Anime a caixa em volta (ou envolva com `<Reveal>`, `<Move>`): a `<Picture>` não tem entrada própria.
- Cada imagem gerada (fundo ou `<Picture>`) conta no limite de imagens que a peça inclui; passando dele, cada uma espera o clique do dono.

---

# Motion design (a segunda camada)

## Regras do validador (quebrar recusa a peça)

- **O quadro é uma função do número dele.** Nada de `useState`, `useEffect`, `useLayoutEffect`, `useReducer`, `useRef`, `useTransition`, `useId` nem outro hook do React com memória ou efeito. Os hooks do kit (`useShot`, `usePalette`, ...) e funções suas que chamam só eles podem ser usados, inclusive na raiz `Piece`.
- **Nada de acaso nem relógio.** `Math.random`, `Date.now`, `new Date` e `performance.now` são recusados. Para variar, use `rng(seed)` ou `hash01(seed, i)`.
- **Nada de CSS que anima sozinho.** `@keyframes`, `animation` e `transition:` em estilo são recusados. Todo movimento sai de `interpolate`, `spring`, `keyframes` ou de um componente do kit.
- **Teto de custo do render** (cada quadro é uma captura de tela):
  - `blur` de no máximo **24 px** (em `filter`, em `<Move keys>` e onde mais aparecer);
  - **um** `<Grain>` por cena, com `amount` de no máximo **0,12**;
  - `<Burst>` com `count` de no máximo **60**, e no máximo **dois** `<Burst>` por cena.
- **Cor e fonte vêm da marca.** Nunca escreva hex, `rgb()` nem nome de fonte. Use o papel (`color="accent"`) ou `usePalette()`: `c("primary")`, `alpha("text", 0.2)`, `mix("accent", "primary", 0.5)` e as fontes `heading`/`body`. Os papéis são `primary`, `accent`, `background`, `text`, mais `white` e `black`, e `ink`.
- **Texto que você mesmo estiliza usa `c("ink")`** (ou `color="ink"` num componente do kit): é a cor que lê sobre a cena em que o texto está (clara na cena escura, escura na clara, branca sobre foto escurecida). Nunca `c("white")`, `c("black")` nem `c("background")` fixos para palavras: esses são para formas e preenchimentos; um rótulo dentro de uma caixa que você pintou usa um papel que contrasta com a caixa. A plataforma mede cada palavra contra os pixels atrás dela e devolve para correção o que ficar abaixo de 3:1 (4,5:1 no texto pequeno).
- **Preço só do item.** `<PriceTag item={...}>` ou `<Price item={...}>`. Nunca escreva valor, moeda ou porcentagem.
- **Texto da tela só em componente do kit.** `<Kinetic>`, `<WordSwap>`, `<Marquee>`, `<Title>`, `<Eyebrow>`, `<Caption>`, `<CallToAction>`, ou num componente seu que recebe o texto como `children` ou como `label`/`text`. É assim que o editor do dono acha e edita cada texto. Texto solto dentro de `<div>` não aparece para o dono.

## Tempo

Tudo recebe o quadro (`frame`) e devolve um valor. O quadro da cena começa em 0 na primeira imagem dela.

| Nome | Assinatura | Para quê |
|---|---|---|
| `useShot()` | `{ frame, duration, progress, fps, width, height, format, index }` | O relógio da cena: quadro local, duração, progresso de 0 a 1, tamanho e formato. |
| `useSceneFrame()` | `number` | Só o quadro local. |
| `useSceneProgress(from?, to?, ease?)` | `number` 0 a 1 | Progresso na cena inteira ou entre dois quadros dela. |
| `useBeat(bpm, offset?, decay?)` | `number` 1 a 0 | Pulso na batida: 1 no tempo, caindo até o próximo. |
| `interpolate(frame, [0, 20, 40], [0, 1, 0], { ease })` | `number` | Mapeia por várias paradas, com curva em cada trecho. Limitado por padrão. O quarto argumento pode ser só a curva: `interpolate(f, [0, 20], [0, 1], "outExpo")`. |
| `progress(frame, at, dur, ease?)` | `number` 0 a 1 | Atalho: de `at` até `at + dur`. |
| `spring(frame, at?, config?)` | `number` 0 a ~1 | Mola amortecida que começa em `at`. `config` é um de `SPRINGS` ou `{ stiffness, damping, mass? }`. |
| `SPRINGS` | `gentle`, `snappy`, `bouncy`, `heavy` | Molas prontas. `bouncy` tem sobra; `heavy` é lenta e pesada. |
| `Easing` | `linear`, `inQuad`, `outQuad`, `inOutQuad`, `inCubic`, `outCubic`, `inOutCubic`, `inExpo`, `outExpo`, `inOutExpo`, `outBack`, `inBack`, `outElastic`, `outQuint`, `inOutQuint`, `snap`, `smooth`, `drawer` | Curvas com nome. Onde se pede `ease`, escreva o nome (`ease: "outExpo"`). `snap` segura e chicoteia; `smooth` é a saída suave. |
| `bezier(x1, y1, x2, y2)` | curva | Uma cúbica própria, quando nenhuma com nome serve. |
| `stagger(i, step?, at?)` | `number` | O quadro de início do i-ésimo elemento de um grupo escalonado. |
| `keyframes(frame, keys, base)` | objeto | Várias propriedades por quadros-chave: `[{ at: 0, x: 0 }, { at: 20, x: 300, ease: "snap" }]`. A curva da chave molda o trecho que chega nela. |
| `rng(seed)` | `() => number` | Sequência pseudoaleatória fixa pela semente. |
| `hash01(seed, i)` | `number` 0 a 1 | Um número estável para (semente, índice). |
| `FPS`, `sec(seconds)` | 30, quadros | `sec(1.2)` = 36 quadros. Durações de cena sempre com `sec()`; dentro da cena, `at`, `dur` e chaves podem ser quadros (de 0 até a duração). |

## Cena em tela livre

| Componente | Propriedades | Notas |
|---|---|---|
| `<Scene canvas>` | `duration`, `bg?: papel ou [papel, papel]`, `background?`, `transition?`, `transitionFrames?`, `sfx?`, `hits?: [{ at, kind }]`, `editedByOwner?` | Com `canvas`, os filhos ocupam o quadro inteiro (nada de coluna automática). `bg="text"` é fundo liso; `bg={["primary", "text"]}` é degradê. `hits` toca efeitos em quadros da cena (veja `som.md`). |
| `<Safe>` | `align?`, `justify?`, `gap?`, `style?` | A área segura do formato, em coluna flex. Texto, preço, logo e chamada vão aqui dentro. Em 1:1 e 16:9 ela encolhe o conteúdo para caber (nunca aumenta). |
| `<At>` | `x`, `y` (frações do quadro, 0 a 1), `style?` | Caixa centrada num ponto do quadro. Para elementos gráficos fora do texto. |
| `useSafeBox()` | `{ left, top, width, height, frameWidth, frameHeight, scale }` | A área segura em px, para desenhar alinhado a ela. |
| `SIZES`, `SAFE` | por formato | Tamanho do quadro e margens livres de cada formato (`9:16`, `4:5`, `1:1`, `16:9`). |

## Câmera e profundidade

| Componente | Propriedades | Notas |
|---|---|---|
| `<Camera>` | `keys: [{ at, x?, y?, zoom?, rotate?, tiltX?, tiltY?, ease? }]`, `perspective?` (padrão 1800), `shake?` (px) | Uma câmera sobre a cena: empurrar, puxar, girar e inclinar em 3D. Movimento lento (zoom de 1,04 a 1,1) já dá vida; um mergulho (`zoom: 3`, `ease: "inExpo"`) no fim leva para a próxima cena. |
| `<Layer>` | `depth?` | Plano em profundidade: 0 anda com a câmera, positivo fica longe (anda menos), negativo fica perto (anda mais). Fundo gráfico em `depth={1.5}` dá paralaxe. |
| `<Move>` | `keys: [{ at, x?, y?, scale?, rotate?, opacity?, blur?, ease? }]`, `origin?` | Movimento por quadros-chave de um elemento que não é a câmera. |
| `useCamera()` | `{ x, y, zoom, rotate, tiltX, tiltY }` | O estado da câmera no quadro, para um elemento que reage a ela. |

## Revelações, formas e linhas

Formas com nome (`shape`): `circle`, `squircle`, `square`, `diamond`, `triangle`, `hexagon`, `star`, `burst`, `flower`, `blob`, `pill`.
Linhas com nome (`path`): `swoosh`, `underline`, `scribble`, `arrow`, `check`, `wave`, `spark`, `frame`.
Tempo comum (`Timed`): `at` (quadro de início), `dur` (quadros), `ease`, ou `progress` (0 a 1) para controlar à mão.

| Componente | Propriedades | Notas |
|---|---|---|
| `<Reveal>` | `shape?: forma ou "rect"`, `from?: "left" | "right" | "top" | "bottom" | "center"`, `origin?: [x, y]`, `rotate?`, mais o tempo | Recorte que abre e mostra o que está dentro. A revelação por forma da marca é um dos momentos mais fortes. |
| `<Morph>` | `keys: [{ at, shape, ease?, seed? }]`, `size?` (raio em px), `color?`, `rotate?`, `spin?` (graus por segundo), `scale?`, `stroke?`, `strokeWidth?`, `x?`, `y?` | Uma forma que vira outra (círculo → estrela → flor). `blob` com `seed` diferente dá formas orgânicas. |
| `<Shape>` | `shape`, e as mesmas de `<Morph>` sem `keys` | Uma forma parada (pode girar com `spin`). É forma abstrata da marca, nunca um objeto: coração, botão ou estrela de avaliação são `<Icon>`. |
| `<PathDraw>` | `path?` ou `d?` (caixa 0 a 100), `width?`, `height?`, `color?`, `stroke?`, `tail?`, mais o tempo | Linha que se desenha. `tail` faz a linha sumir atrás, como um traço que passa. |

## Objetos: ícones e post de rede social

Quando o pedido nomeia um objeto, ele aparece como ele mesmo. Uma `<Shape>` no lugar dele (estrela por coração, círculo por botão) é o erro que mais denuncia peça amadora.

| Componente | Propriedades | Notas |
|---|---|---|
| `<Icon>` | `name`, `size?` (px, padrão 96), `color?`, `solid?`, `weight?` (traço na grade de 24), `at?`, `entrance?: "pop" | "draw" | "none"`, `pulse?` (quadros por batida), `x?`, `y?`, `style?` | Ícone de verdade, uma família só (traço redondo). `name`: `heart`, `like`, `comment`, `share`, `send`, `bookmark`, `check`, `check-circle`, `cursor`, `play`, `sparkle`, `star`, `bolt`, `bell`, `cart`, `bag`, `gift`, `clock`, `calendar`, `pin`, `phone`, `music`, `camera`, `image`, `video`, `user`, `search`, `plus`, `arrow-right`, `trend-up`, `wand`, `eye`. `solid` preenche os que fazem sentido cheios (coração, estrela, play, raio, comentário, marcador, cursor, brilho). `pulse={15}` faz o coração bater. Com `x`/`y` fica solto no quadro, centrado no ponto. |
| `<SocialPost>` | `label?` (nome da conta; padrão, o da marca), `likes?`, `from?`, `at?`, `countAt?`, `count?` (quadros da contagem), `pulse?`, `heart?` (papel), `width?` (px, padrão 760), `caption?`, `children` (a imagem), `style?` | A contagem termina até 60% da cena por padrão e fica no valor final (um `count` escrito vence). O cartão nunca passa de 60% da altura do quadro (no 9:16, `width` acima de cerca de 790 não muda nada). Fica sozinho: posicione com `<At x={0.5} y={0.6}>`, nunca numa coluna com título acima; decoração flutuante (corações, confete) não cruza a linha da legenda (as curtidas). Um post de verdade: avatar com o logo, nome, a imagem quadrada, a fileira de ações com ícones e o contador de curtidas que corre de `from` até `likes` enquanto o coração bate. A superfície segue o esquema da peça. A imagem vai como filho: `<SocialPost likes={12480}><Picture slot="post-demo" prompt="..." radius={0} /></SocialPost>`. `caption` troca a palavra "curtidas" quando a peça fala outra língua que a marca. |

## Interface demonstrada

Cena que demonstra uma interface (pedido digitado, busca, chat, lista de etapas, botão apertado) usa estas peças, nunca div à mão. A interface É o herói da cena: nenhum título herói concorrendo com ela. Caixa com 92% da largura segura ou mais, ou vazando pelas bordas; texto de 80 px ou mais. A plataforma não cobra 150 px das palavras de dentro (a regra `ui_text` cobra 72 px ou mais; mire 80+).

| Componente | Propriedades | Notas |
|---|---|---|
| `<PromptBox>` | `children` (o pedido digitado, uma string), `at?` (quadro em que a digitação começa, padrão 6), `step?` (quadros por letra, padrão 1), `button?` (a palavra de ação), `size?` (px do texto, padrão 88), `width?: "safe" \| "bleed"` (padrão `"safe"`), `color?` (papel do preenchimento), `caret?` | A caixa do pedido, digitando por dentro (o mesmo `type` do `<Kinetic>`, linha montada desde o primeiro quadro). `"safe"` ocupa 92% da coluna segura; `"bleed"` ocupa 108% do quadro e vaza pelas duas bordas. Altura mínima de 30% do quadro. O kit não deixa `size` descer de 72; não diminua o padrão. `button` desenha a ação como barra dentro da caixa, com a geometria do `<CallToAction variant="bar">` (150 px de altura, texto de 72 px); para o botão crescer até virar a cena seguinte, envolva a caixa num `<Move>` e passe o `carry` no roteiro. |
| `<Checklist>` | `items` (`{ label, at }[]`, `at` = quadro em que a linha assenta), `size?` (px do texto da linha, padrão 80), `check?` (px do ícone, padrão 112), `progress?` (barra sob cada linha, padrão ligada), `align?` | Lista de etapas que se completam: cada linha assenta no seu `at` com o check e a barra que enche. Ocupa a largura segura inteira. O kit não deixa `size` descer de 72; mantenha 80 ou mais. Uma linha por batida (15 quadros); até 5 linhas. |

```tsx
<PromptBox button="Gerar" at={6}>Quero um vídeo da minha padaria</PromptBox>
<Checklist items={[{ label: "Roteiro", at: 0 }, { label: "Imagens", at: 15 }, { label: "Trilha", at: 30 }]} />
```

## Padrões e partículas

| Componente | Propriedades | Notas |
|---|---|---|
| `<Grid>`, `<Dots>` | `color?`, `alpha?`, `size?`, `line?`, `drift?: [px, px]` (por segundo) | Grade e pontos que andam devagar. Fundo gráfico leve (`alpha` 0,05 a 0,15). |
| `<Lines>` | as mesmas e `angle?` | Listras inclinadas. |
| `<Rings>` | as mesmas e `x?`, `y?` | Anéis concêntricos que irradiam. |
| `<Marquee>` | `children` (o texto), `speed?` (px por segundo, negativo inverte), `size?`, `color?`, `alpha?`, `font?`, `y?` (fração), `outline?` | Letreiro contínuo de lado a lado. É decoração: o mesmo texto repetido, nunca a mensagem principal. |
| `<Burst>` | `at?`, `seed?`, `count?` (até 60), `colors?`, `kind?: "dots" | "confetti" | "sparks" | "rays"`, `x?`, `y?`, `power?`, `spread?`, `angle?`, `gravity?`, `life?`, `size?` | Explosão de partículas determinística. Só num momento que merece (o preço, o fecho), no máximo dois por cena. |

## Tipografia cinética

| Componente | Propriedades | Notas |
|---|---|---|
| `<Kinetic>` | `children` (o texto), `mode?`, `by?: "word" | "letter" | "line"`, `at?`, `step?`, `dur?`, `out?`, `size?` (px), `fit?` (`true` ou `[min, max]`), `color?`, `font?: "heading" | "body"`, `weight?`, `italic?`, `upper?`, `tracking?`, `leading?`, `align?`, `accent?`, `marks?`, `markColor?`, `markAt?`, `ease?`, `caret?`, `style?` | O texto herói. Cada unidade (palavra, letra ou linha) entra pelo quadro. `fit` (sem faixa) é o padrão da linha heroica: mede a linha mais larga uma vez e faz ela ocupar cerca de 72% do quadro, de 150 a 340 px, o mesmo tamanho em todos os quadros; uma linha longa demais quebra no ponto mais equilibrado. `fit={[min, max]}` só define um teto, que o kit sobe (até 340 px) quando fica abaixo desse preenchimento. |
| `<WordSwap>` | `words: string[]`, `at?`, `every?` (quadros por palavra), `mode?: "mask" | "slot" | "flip"`, `size?`, `color?`, `font?`, `weight?`, `italic?`, `loop?`, `align?` (padrão `center`) | Uma palavra que troca no lugar, na batida: "Sem **tempo / designer / câmera**". Uma frase que quebra em duas linhas fica alinhada por `align`. |

Modos de `<Kinetic>` (`mode`): `mask-up` (sobe por trás de uma máscara, o padrão), `mask-down`, `scale-punch` (chega grande e assenta com mola), `scramble` (letras embaralham e travam), `slot` (cada letra rola como caça-níquel), `outline-fill` (contorno que se preenche), `stretch` (estica de baixo para cima), `blur-in` (sai do desfoque), `fade`, `type` (máquina de escrever: letra por letra, `step` quadros por letra, padrão 1,6, com um cursor que pisca no fim; `caret` é o papel da cor do cursor, ou `false`). O `type` monta a linha inteira desde o primeiro quadro e o cursor não tem largura, então o texto centrado não anda enquanto é digitado: é a única forma de digitar texto na tela (o `<PromptBox>` digita com ele por dentro). Digitação é para uma cena que demonstra um pedido, uma busca ou um chat; nunca no gancho, que precisa ser lido inteiro até o quadro 15. Qualquer outro modo, na primeira cena, assenta até o quadro 15 sozinho, sejam quais forem `at`, `step` e `dur`.

Marcas (`marks`): `marker` (marca-texto atrás), `underline` (sublinhado que se desenha), `circle` (círculo à mão em volta), `strike` (risco).

Como escrever o texto:
- Texto simples entre as tags: `<Kinetic mode="mask-up" size={190}>tempo.</Kinetic>`.
- Com quebra de linha, uma string com `\n`: `<Kinetic by="line">{"Sua pele\nmerece"}</Kinetic>`.
- Do dado, uma expressão: `{brand.name}`, `{bread?.name ?? ""}`. O dono não edita esse texto; ele vem da marca ou do item.
- `accent={{ pele: "primary" }}` pinta uma palavra; `marks={{ você: "circle" }}` marca uma palavra depois que ela entra. A palavra marcada reserva o próprio espaço (0,42 em em volta do círculo, 0,1 em do marca-texto), então não encosta nas vizinhas. Uma ênfase por palavra (cor OU marca, nunca as duas) e círculo só em palavra de até 8 letras. A chave é a palavra normalizada: minúscula, só letras e números (`"você."` vira `você`). Uma chave que não é palavra do texto não faz nada.
- `<WordSwap words={["tempo.", "designer.", "câmera."]} />` com textos literais: o dono edita cada palavra.

## Textura e luz

| Componente | Propriedades | Notas |
|---|---|---|
| `<Grain>` | `amount?` (padrão 0,08, no máximo 0,12), `blend?` | Grão de filme que se move. Um por cena, por cima de tudo. |
| `<LightLeak>` | `color?`, `second?`, `intensity?`, `speed?`, `at?` | Luz quente que atravessa o quadro. |
| `<Glow>` | `color?`, `x?`, `y?`, `size?` (fração), `intensity?`, `pulse?` (0 a 1) | Brilho macio atrás de algo. |
| `<Vignette>` | `strength?` | Escurece as bordas. |

## Marca, cor e preço

| Nome | Assinatura | Notas |
|---|---|---|
| `usePalette()` | `{ c, alpha, mix, heading, body }` | `c("accent")` é a cor do papel; `c("ink")` é a cor de texto que lê na cena atual; `alpha("text", 0.2)` com transparência; `mix("primary", "text", 0.4)` mistura; `heading` e `body` são as fontes da marca. Para desenhar formas próprias com as cores da marca. Os papéis já trazem a paleta da peça quando o pedido pediu cores ou um visual (a direção grava a paleta; logo, nome e fontes seguem da marca): escreva sempre o papel, nunca o hex que o pedido citou. A nota BRAND que vem com o pedido traz `scheme` (`light` ou `dark`) e `tones` (o tom de cada papel): leia-os ali para escolher os papéis; o objeto `brand` do código não os tem. O texto vai no papel de tom oposto ao do fundo. |
| `<PriceTag>` | `item`, `size?` (px do número), `role?`, `at?`, `entrance?: "punch" | "none"`, `style?` | O preço como herói tipográfico: moeda pequena, número grande, centavos no alto. Formatado do item, no idioma da marca. Sem preço no item, não desenha nada. Os algarismos nunca animam. |
| `<Logo>` | `height?`, `role?`, `style?` | O logo da marca; sem logo, o nome como assinatura. |

## Transições

A transição vai na cena que entra e toca sobre os primeiros quadros dela, com a cena anterior ainda andando.

| Transição | Quadros | Quando |
|---|---|---|
| `cut`, `slide`, `zoom`, `brand-mask`, `color-wipe` | 0 a 14 | As da primeira camada. Ainda valem. |
| `match` | 0 | Corte seco em que um elemento continua no mesmo lugar e tamanho nas duas cenas (a mesma forma, o mesmo produto). |
| `fade` | 10 | Calma, para editorial e luxo. Nunca em toda cena. |
| `push-left`, `push-right`, `push-up`, `push-down` | 14 | A nova cena empurra a anterior. |
| `whip-left`, `whip-right`, `whip-up`, `whip-down` | 9 | Chicote com desfoque na direção. Energia. |
| `zoom-through` | 12 | A câmera atravessa para a cena seguinte. |
| `stack` | 16 | A nova cena sobe por cima da anterior, como um cartão. |
| `shape-<forma>` | 18 | A cena nova abre por uma forma: `shape-circle`, `shape-star`, `shape-squircle`, `shape-burst`, ... (qualquer forma com nome). |

`transitionFrames={22}` muda a duração de uma transição. Um nome que não existe toca como corte seco.

## Exemplo mínimo

```tsx
import { Sequence, Scene, Soundtrack, CallToAction, sec, Safe, Camera, Layer, Grid, Kinetic, WordSwap, PriceTag, Grain } from "@fab/motion";

export default function Piece({ items }) {
  return (
    <Sequence soundtrack="track">
      <Soundtrack />
      <Scene canvas duration={sec(2)} bg="primary">
        <Camera keys={[{ at: 0, zoom: 1.15 }, { at: 60, zoom: 1, ease: "outQuint" }]}>
          <Layer depth={1.5}><Grid color="text" alpha={0.07} size={135} drift={[0, -40]} /></Layer>
          <Safe align="flex-start">
            <Kinetic mode="mask-up" fit color="ink">Pão</Kinetic>
            <WordSwap words={["quente.", "fresco.", "de hoje."]} at={4} every={15} size={190} color="accent" />
          </Safe>
        </Camera>
        <Grain amount={0.07} />
      </Scene>
      <Scene canvas duration={sec(2.4)} bg="accent" transition="shape-circle">
        <Safe>
          <Kinetic mode="mask-up" size={84} upper>{items[0]?.name ?? ""}</Kinetic>
          <PriceTag item={items[0]} size={400} role="primary" at={10} />
        </Safe>
      </Scene>
      {/* ... */}
    </Sequence>
  );
}
```

`<Background>` também existe como elemento (`<Background type="ai-image" prompt="..." slot="..." />`, dentro da cena) e vale como a propriedade `background`; para uma imagem dentro de um cartão, de um celular ou de uma moldura, use `<Picture>`. `<Transition>` só existe para peças antigas: use a propriedade `transition` da cena. As funções `sequenceLength` e `slidesOf` são do palco da plataforma; a composição não as chama.
