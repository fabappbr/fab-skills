# O kit @fab/motion

Os 28 componentes que a composição pode usar. Todos leem o tema da marca (`brand.colors`, `brand.fonts`, `brand.radius`), respeitam a zona segura do formato e sabem tocar o efeito sonoro da própria entrada.

Nomes de componentes, propriedades e valores são em inglês, como todo o código da plataforma. O texto que aparece na peça continua no idioma da marca.

> Contrato proposto em 23/10/2026, antes do código do kit existir. Quando o pacote estiver publicado, os tipos em `packages/fab-motion` são a fonte da verdade e este arquivo é atualizado a partir deles.

## Utilitários e dados

| Nome | O que é |
|---|---|
| `sec(seconds)` | Converte segundos em quadros pelo `fps` da peça (30). Use sempre; nunca escreva quadros à mão. |
| `brand` | `{ name, logo, colors: { primary, accent, background, text }, fonts: { heading, body }, radius, tone, industry, locale }` |
| `items` | `[{ id, name, price?, wasPrice?, unit?, installments?, photo?, description?, link? }]`, já conferidos. |
| `reviews` | `[{ author, text, rating, date }]`, só reais. Pode vir vazio. |
| Cores | Onde se pede cor, use o nome do papel: `"primary" | "accent" | "background" | "text"`. Hex não é aceito. |

## Estrutura

| Componente | Propriedades | Notas |
|---|---|---|
| `<Sequence>` | `soundtrack?`, `snapToBeat?`, `format` (vem da peça) | Raiz do vídeo. Ordena as cenas; com `snapToBeat`, ajusta cada corte para a batida mais próxima (até 4 quadros). |
| `<Scene>` | `duration`, `background`, `transition?`, `sfx?`, `editedByOwner?` | Um momento. Desenha a zona segura e a área de texto. |
| `<Transition>` | `type: "cut" | "slide" | "zoom" | "brand-mask" | "color-wipe"`, `direction?`, `sfx?` | Também pode ir como `transition` na `<Scene>`. |
| `<Slide>` | `role: "cover" | "item" | "end"`, `continues?` | Quadro do carrossel. `continues` deixa a forma da marca atravessar para o próximo slide. |

## Texto

| Componente | Propriedades | Notas |
|---|---|---|
| `<Title>` | `entrance: "word" | "letter" | "line" | "rise"`, `highlight?` (palavra a colorir) | Quebra de linha é calculada pelo tamanho. Até 7 palavras. |
| `<Eyebrow>` | `variant: "uppercase" | "pill"` | A linha pequena acima do título: urgência, data, categoria. Até 4 palavras. |
| `<Caption>` | `position: "center" | "safe-bottom"` | Para quem assiste sem som. Até 8 palavras. |
| `<List>` | `items` (texto ou item), `marker: "number" | "dot" | "check"`, `interval` | Até 5 linhas. Cada linha entra separada. |
| `<AnimatedNumber>` | `value` (de dado), `suffix?`, `duration?` | Conta até o valor. Recusa número literal. |

## Comércio

| Componente | Propriedades | Notas |
|---|---|---|
| `<Price>` | `item`, `showWasPrice?`, `showInstallments?`, `size: "m" | "l" | "xl"` | Formata pelo `brand.locale`. Lê `price`, `wasPrice`, `unit`, `installments` do item. |
| `<Badge>` | `text`, `shape: "circle" | "star" | "ribbon"`, `color?` | "-20%" só se `wasPrice` e `price` existirem; o kit calcula. |
| `<Product>` | `item`, `cutout?`, `shadow?`, `motion: "spring" | "float" | "gentle-spin"` | Foto real do item. Sem foto, não renderiza (use `<Title>`). |
| `<ProductGrid>` | `items`, `columns: 2`, `showPrice?` | 2 a 4 itens. |
| `<Compare>` | `a`, `b`, `labels: [string, string]`, `variant: "wipe" | "side-by-side"` | Antes e depois, plano A e B. |

## Marca

| Componente | Propriedades | Notas |
|---|---|---|
| `<LogoIntro>` | `variant: "stamp" | "draw" | "reveal"`, `duration?` (máx. 1 s) | Só quando o pedido pede marca. Nunca como primeira cena de anúncio. |
| `<EndCard>` | `cta`, `contact?` (`@`, telefone, site), `seconds?` | Última cena. Logo + nome + chamada. |
| `<BrandShape>` | `shape: "circle" | "blob" | "band" | "grid"`, `position`, `motion?` | Elemento gráfico que se repete em todas as peças da marca. |

## Prova e informação

| Componente | Propriedades | Notas |
|---|---|---|
| `<Testimonial>` | `review`, `showStars?` | Só de `reviews`. Corta o texto em até 12 palavras com reticências. |
| `<Rating>` | `source: "app" | "google"`, `average`, `total` | De dado. |
| `<Hours>` | `days`, `ranges`, `highlight?` | |
| `<Address>` | `address`, `neighborhood?`, `landmark?` | Alfinete animado, sem mapa. |
| `<Countdown>` | `until` (data), `units: ["days", "hours"]` | O vídeo mostra o tempo restante no dia da exportação. |

## App e chamada

| Componente | Propriedades | Notas |
|---|---|---|
| `<AppScreen>` | `route`, `taps?`, `frame: "iphone" | "android"` | Gravação real do app. Só com projeto. |
| `<Tap>` | `x`, `y`, `at` | Indicador de toque sobre a `<AppScreen>`. |
| `<CallToAction>` | `action: "whatsapp" | "open-app" | "link-in-bio" | "call" | "order"`, `text` | Um verbo. O link sai com `utm_source=motion`. |
| `<QrCode>` | `target`, `caption?` | Para vitrine, TV da loja, impresso. |

## Fundo e som

| Componente | Propriedades | Notas |
|---|---|---|
| `<Background>` | `type: "color" | "gradient" | "photo" | "owner-video" | "ai-video" | "ai-image"`, `source`, `fit`, `dim?`, `blur?`, `prompt?` (para IA, sem texto), `slot?` | Também aceito como `background` da `<Scene>`. Escurece sozinho até o texto passar no contraste. |
| `<Soundtrack>` | `track`, `volume`, `sfx?`, `beats` (vem da trilha) | Um por peça, dentro da `<Sequence>`. |

## Vagas de mídia

Pedir mídia gerada é declarar uma vaga (`slot`). A plataforma gera depois da composição, mostra o custo e preenche:

```tsx
<Scene duration={sec(2)} background={{ type: "ai-video", prompt: "bancada de doceria com luz da manhã, açúcar caindo devagar, sem texto, sem pessoas", slot: "opening" }} />
<Background type="ai-image" prompt="textura de papel creme com manchas suaves de cacau, sem texto" slot="price-bg" />
```

O `prompt` da vaga pode estar no idioma da marca; o adaptador traduz para o modelo, se preciso.
