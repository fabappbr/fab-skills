# O kit @fab/motion

Os componentes que a composição pode usar. Todos leem o tema da marca (cores, fontes, raio), respeitam a zona segura do formato e entram com a mola do tom da marca.

Nomes de componentes, propriedades e valores são em inglês, como todo o código da plataforma. O texto que aparece na peça continua no idioma da marca.

> Conferido contra o código do kit em 25/10/2026 (`studio/src/motion/kit`). O kit é a fonte da verdade; uma propriedade que não está aqui não existe.

## Utilitários e dados

| Nome | O que é |
|---|---|
| `sec(seconds)` | Converte segundos em quadros (30 por segundo). Use sempre; nunca escreva quadros à mão. |
| `brand` | `{ name, logo_url, colors: { primary, accent, background, text }, fonts: { heading, body }, radius, tone, locale }` |
| `items` | `[{ name, price_minor, was_price_minor, currency, unit, installments, photo_url, description, link }]`, já conferidos pelo dono. |
| `reviews` | `[{ author, text, rating }]`, só reais. Pode vir vazio. |
| Cores | Onde se pede cor, use o nome do papel: `"primary" | "accent" | "background" | "text"`. Hex não é aceito. |

Passe o item inteiro para o componente (`item={items[0]}`). A composição nunca lê `price_minor`, `was_price_minor` nem `installments` para escrever na tela: quem formata preço é o `<Price>`, e o desconto é o `<Badge>`. O nome (`items[0].name`) pode ir num `<Title>`.

Quase todo componente aceita `delay` (em quadros, desde o início da cena). É assim que se escalona: `delay={0}`, `delay={5}`, `delay={10}`.

## Estrutura

| Componente | Propriedades | Notas |
|---|---|---|
| `<Sequence>` | `soundtrack?` | Raiz do vídeo. Toca as cenas em ordem. `soundtrack="track"` pede a trilha gerada da peça. |
| `<Scene>` | `duration`, `background?`, `transition?`, `sfx?`, `align?: "center" | "top" | "bottom"`, `editedByOwner?` | Um momento. O conteúdo fica dentro da zona segura. `sfx` toca no começo da cena. |
| `<Slide>` | `role: "cover" | "item" | "end"`, `background?`, `continues?` | Quadro do carrossel (o carrossel não usa `<Sequence>`). |
| `<Soundtrack>` | `volume?` (0 a 1, padrão 0,6), `sfx?` (`false` silencia os efeitos) | Opcional, dentro da `<Sequence>`, só para ajustar a mistura. |

A transição vai na cena que entra: `transition: "cut" | "slide" | "zoom" | "brand-mask" | "color-wipe"`. Sem `transition`, é corte seco.

## Texto

| Componente | Propriedades | Notas |
|---|---|---|
| `<Title>` | `entrance?: "word" | "letter" | "line" | "rise"`, `highlight?` (palavra a colorir), `size?: "m" | "l" | "xl"` | Quebra de linha calculada pelo tamanho. Até 7 palavras. |
| `<Eyebrow>` | `variant?: "uppercase" | "pill"` | A linha pequena acima do título: urgência, data, categoria. Até 4 palavras. |
| `<Caption>` | `position?: "center" | "safe-bottom"` | Para quem assiste sem som. Até 8 palavras. |
| `<List>` | `items` (textos), `marker?: "number" | "dot" | "check"`, `interval?` (quadros entre linhas) | Até 5 linhas. Cada linha entra separada. |
| `<AnimatedNumber>` | `value`, `suffix?`, `duration?` | Conta até o valor. O valor vem de dado, nunca digitado. |

## Comércio

| Componente | Propriedades | Notas |
|---|---|---|
| `<Price>` | `item`, `showWasPrice?`, `showInstallments?`, `size?: "m" | "l" | "xl"` | Formata na moeda do item e no idioma da marca. Sem preço no item, não renderiza. |
| `<Badge>` | `item?` ou `text?`, `shape?: "circle" | "star" | "ribbon"`, `color?: "primary" | "accent"` | Com `item`, mostra o desconto calculado (só se houver preço antigo maior). Com `text`, um selo curto ("Novo"). |
| `<Product>` | `item`, `cutout?`, `shadow?`, `motion?: "spring" | "float" | "gentle-spin"`, `height?` | Foto real do item. `cutout` usa o recorte sem fundo (a plataforma gera). Sem foto, não renderiza. |
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
| `<CallToAction>` | `action: "whatsapp" | "open-app" | "link-in-bio" | "call" | "order"`, `text` | Um verbo. |
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
| `"ai-video"` | `prompt`, `slot` | Vídeo gerado de 5 a 10 s, sem som. Caro: o dono confirma o custo antes. Use um, no máximo dois por peça. |

Campos comuns: `dim?` (0 a 1; escurece para o texto passar; com foto ou mídia o padrão já é 0,45) e `blur?`.

## Vagas de mídia

Pedir mídia gerada é declarar uma vaga (`slot`) com um nome curto e um `prompt`. A plataforma gera depois da composição, cobra só quando o arquivo fica pronto e preenche a vaga; até lá, a cena mostra um degradê da marca no lugar.

```tsx
<Scene duration={sec(2)} background={{ type: "ai-video", prompt: "bancada de doceria com luz da manhã, açúcar caindo devagar", slot: "opening" }}>
<Scene duration={sec(3)} background={{ type: "ai-image", prompt: "textura de papel creme com manchas suaves de cacau", slot: "price-bg" }}>
```

- Uma vaga por fundo. Repetir o mesmo `slot` reaproveita a mesma mídia.
- O `prompt` descreve cenário, luz e movimento. A plataforma já acrescenta "sem texto e sem logo"; não peça letra, produto nem pessoa realista.
- Ao ajustar uma peça, mantenha `slot` e `prompt` de um fundo que não mudou: a mídia pronta é reaproveitada sem custo.
