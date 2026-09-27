# Construção: React, CSS e o piso de qualidade

O padrão de engenharia do site sobre a surface da Fabapp. Cada regra aqui ou cria o polimento ou evita um bug que já embarcou. Leia antes de escrever código (Fase 7).

## O ponto de partida

A plataforma monta a aplicação assim: `main.tsx` (em `StrictMode`) renderiza o `App.tsx` da plataforma, que envolve tudo em `FabProvider` e `BrowserRouter` e renderiza o seu `AppRoutes`. Você nunca edita `main.tsx`, `App.tsx`, `index.css` ou `index.html`. Tudo que é seu começa em `src/routes.tsx`.

O roteador é declarativo (`BrowserRouter` com `<Routes>`), não o roteador de dados: recursos como `<ScrollRestoration>` e o `viewTransition` do roteador de dados não existem aqui. Role para o topo e faça transições de página pelo padrão de `motion-e-interacao.md`.

## A estrutura de `src/`

```
src/
  routes.tsx                 # entrypoint: importa o CSS do site e declara as rotas dentro do layout
  styles/site.css            # tokens do site, escala fluida, componentes, motion em CSS
  lib/content.ts             # TODO o texto do site, vindo do pacote de design, num lugar só
  lib/motion.ts              # registro do GSAP, tokens de easing em JS, helpers de reduced motion
  components/site/
    SiteLayout.tsx           # header, <main id="main">, footer, rolar para o topo, camada de ambiente
    Header.tsx  Footer.tsx  SkipLink.tsx  Cta.tsx  LeadForm.tsx  WhatsAppButton.tsx
    sections/Hero.tsx  sections/Manifesto.tsx  sections/Servicos.tsx  ...
    art/Logo.tsx  art/Motif.tsx          # SVG desenhado à mão, como componentes
  pages/
    Home.tsx  Sobre.tsx  NotFound.tsx
```

**O texto vive em `lib/content.ts`.** Cada linha do pacote de design entra ali, ao pé da letra, e os componentes leem de lá. A próxima mudança de texto pedida pelo usuário é uma linha num arquivo.

**`routes.tsx` com layout e página 404:**

```tsx
import { Routes, Route } from "react-router-dom";
import "./styles/site.css";
import SiteLayout from "./components/site/SiteLayout";
import Home from "./pages/Home";
import Sobre from "./pages/Sobre";
import NotFound from "./pages/NotFound";

export function AppRoutes() {
  return (
    <Routes>
      <Route element={<SiteLayout />}>
        <Route index element={<Home />} />
        <Route path="sobre" element={<Sobre />} />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  );
}
```

Imports simples de `./pages/*`: o build transforma cada página (menos a home) em carregamento sob demanda sozinho. Não use `React.lazy` nas páginas. Use `React.lazy` para peças pesadas DENTRO de uma página (a cena WebGL, o player).

**Rolar para o topo na troca de rota**, no `SiteLayout`:

```tsx
const { pathname, hash } = useLocation();
useEffect(() => { if (!hash) window.scrollTo({ top: 0 }); }, [pathname, hash]);
```

## A arquitetura de CSS sobre Tailwind v4

A plataforma é dona do `index.css` (o `@import "tailwindcss"`, o `@theme inline` e os tokens do tema). O site acrescenta, nunca disputa:

- **Utilitários do Tailwind** para layout e espaçamento do dia a dia, lendo os tokens do tema (`bg-background`, `text-foreground`, `bg-primary`, `font-display`, `font-sans`, `font-mono`).
- **`src/styles/site.css`** para o que utilitário não expressa bem: tokens do site, escala fluida, keyframes, scroll-driven animations, componentes de assinatura. Importado uma vez no `routes.tsx`.
- **Tudo do `site.css` dentro de camadas nativas** (`@layer base` para elementos, `@layer components` para classes do site), para os utilitários continuarem vencendo quando aplicados. Uma regra fora de camada vence qualquer utilitário e mata `text-*`, `font-*` e `tracking-*` em silêncio.
- **`src/app-typography.css`** é o lugar para a identidade dos títulos (`h1` a `h6`); a plataforma envolve esse arquivo em `@layer base`.
- `@plugin`, `@config` e `tailwind.config.*` são ignorados pelo build. Plugins do Tailwind entram declarando o pacote permitido no `package.json`.

### Tokens do site e escala fluida

```css
@layer base {
  :root {
    /* escala tipográfica fluida: de 375px a 1440px */
    --step--1: clamp(0.83rem, 0.8rem + 0.15vw, 0.94rem);
    --step-0:  clamp(1rem, 0.95rem + 0.25vw, 1.19rem);
    --step-1:  clamp(1.25rem, 1.13rem + 0.55vw, 1.62rem);
    --step-2:  clamp(1.56rem, 1.33rem + 1.05vw, 2.28rem);
    --step-3:  clamp(1.95rem, 1.54rem + 1.9vw, 3.2rem);
    --step-4:  clamp(2.44rem, 1.72rem + 3.3vw, 4.6rem);
    --step-5:  clamp(3.05rem, 1.8rem + 5.8vw, 7rem);
    --step-hero: clamp(3.5rem, 1rem + 11vw, 13rem);

    --space-section: clamp(6rem, 4rem + 8vw, 12.5rem);
    --gutter: clamp(1rem, 0.6rem + 1.8vw, 2.5rem);

    --ease-in-brand: cubic-bezier(0.22, 1, 0.36, 1);
    --ease-ui: cubic-bezier(0.65, 0, 0.35, 1);
    --dur-1: 240ms; --dur-2: 520ms; --dur-3: 1100ms;
  }
}
```

No JSX: `className="text-[length:var(--step-4)] leading-[0.95] tracking-[-0.03em] font-display"`. O `length:` é obrigatório: `text-[var(--step-4)]` sem ele é lido pelo Tailwind como COR, e o tamanho some em silêncio. Os números são pontos de partida: ajuste pela fonte escolhida.

### Medida de texto

Limite a largura em `ch` NO PRÓPRIO elemento de texto (`max-w-[62ch]` no `<p>`), nunca no contêiner: `ch` resolve contra a fonte do elemento, e um teto no contêiner é medido na fonte errada. Contêineres levam `px`, `rem` ou `min()`.

## Fontes

- As duas faces principais vêm do tema (`titleFont`, `bodyFont`), carregadas pela plataforma sem bloquear a pintura, com a pilha de recuo embutida.
- Para uma terceira face ou uma fonte auto-hospedada: pacote `@fontsource-variable/<familia>` (ou `@fontsource/<familia>`) importado no `routes.tsx`, e uma variável própria no `site.css`. Os arquivos da fonte vêm do pacote npm, nunca soltos no workspace.
- Nunca `@import url(...)` de fonte remota em CSS.
- Evite o salto de layout quando a fonte chega: escolha uma fonte de recuo parecida e, na display, ajuste `size-adjust` ou `ascent-override` num `@font-face` de recuo quando o salto for visível.

## Desempenho: o orçamento

Metas medidas com Lighthouse mobile no site no ar (dispositivo emulado de gama média, rede 4G lenta):

| Métrica | Meta |
|---|---|
| LCP | abaixo de 2,5s |
| CLS | abaixo de 0,1 |
| INP / TBT | INP abaixo de 200ms, TBT abaixo de 200ms |
| Nota de desempenho | 90 ou mais (Nível 3 com WebGL: 80 ou mais, dito ao usuário) |
| Acessibilidade, boas práticas, SEO | 100, 100, 100 |
| JS inicial da home | abaixo de ~180 KB gzip além do que a plataforma já carrega |

Como chegar lá:
- **A primeira `AppImage` da página é o LCP** e ganha prioridade sozinha. Nunca comece ela com opacidade zero nem atrás de uma tela de carregamento.
- **`width` e `height` em toda imagem** (ou `aspect-ratio` no contêiner) para zerar CLS.
- **Imagens abaixo da dobra** com `loading="lazy"` (a `AppImage` faz isso a partir da segunda).
- **Plugins pesados sob demanda:** WebGL, Rive, player de vídeo e carrossel de galeria entram com `React.lazy` + `Suspense`, montados quando a seção se aproxima da tela (IntersectionObserver com `rootMargin` de algumas centenas de pixels).
- **Importe só o que usa** (`gsap/ScrollTrigger`, não o pacote inteiro de plugins).
- **Nada de trabalho no scroll** fora de `requestAnimationFrame` ou ScrollTrigger; escritas no DOM só quando o valor muda.
- **Animações contínuas pausam fora da tela** e em aba escondida.

## Legibilidade de texto sobre imagem

Texto sobre imagem conquista a própria legibilidade. Quatro camadas, depois a auditoria:

1. **Scrim base:** um escurecimento radial suave sobre a imagem inteira, sempre ligado, sem achatar a foto:
   ```css
   .scrim { position: absolute; inset: 0; pointer-events: none;
     background: radial-gradient(ellipse 120% 90% at 50% 45%, oklch(0.15 0.01 60 / 0) 35%, oklch(0.15 0.01 60 / 0.6) 100%); }
   ```
2. **Scrim local atrás do bloco de texto:** uma elipse centrada no próprio texto, que morre antes dos cantos (por volta de 76%), com pico de alfa entre 0,55 e 0,72 calibrado contra a imagem real. Quando o assunto está no centro e o texto nos dois lados, use duas elipses, uma por coluna, e deixe o centro livre.
3. **Sombra de texto em três camadas** (borda justa, brilho médio, queda larga), desligada em botões:
   ```css
   --tshadow: 0 1px 2px oklch(0.12 0 0 / 0.9), 0 3px 12px oklch(0.12 0 0 / 0.7), 0 10px 44px oklch(0.12 0 0 / 0.75);
   ```
4. **Chip para texto pequeno** sobre imagem: pílula com fundo translúcido e `backdrop-filter: blur(10px)`.

**A auditoria do pior pixel:** esconda o texto (`visibility: hidden`), capture a página composta naquela região, ache o pixel mais claro (para texto claro) dentro da caixa do texto, e calcule o contraste contra a cor do texto. Precisa de 4,5:1 para texto de corpo e 3:1 para títulos grandes. Calibre contra o pior pixel, nunca a média. A rota de Chrome headless em `autoteste-e-publicacao.md` faz isso. Como as imagens reais entram pelo Studio depois, refaça a auditoria no site no ar quando o dono trocar as imagens.

## Acessibilidade (o piso)

- Marcos semânticos: `<header>`, `<nav>`, `<main id="main" tabindex="-1">`, `<footer>`, link de pular para `#main` visível no foco, hierarquia real de títulos (um `h1` por página).
- `:focus-visible` desenhado no acento, nunca removido.
- Alvos de toque de pelo menos 44px sob `(pointer: coarse)`, sem trocar o `display` sem re-declarar o alinhamento.
- Decorações com `aria-hidden="true"`; SVG informativo com `<title>`.
- Imagens com `alt` que descreve o que importa; decorativas com `alt=""`.
- Formulário com `<label>` real, mensagens de erro ligadas por `aria-describedby`, estado de envio anunciado (`aria-live="polite"`).
- Contraste computado: 4,5:1 para corpo, 3:1 para texto grande e bordas de controles. Bordas finas decorativas costumam falhar como borda de campo: dê a elas um valor próprio mais forte.
- Movimento reduzido honrado por completo (ver `motion-e-interacao.md`).
- Idioma: o `lang` do documento vem da plataforma; trechos em outro idioma ganham `lang` próprio.

## SEO por rota

- A home e cada rota estática têm título e descrição no bloco `seo.pages` do `fab.config.json` (ver `plataforma-fabapp.md`).
- Rotas dinâmicas (`/cases/:slug`, `/blog/:slug`) chamam `<FabHead title description image />` quando o registro carrega.
- Um `h1` por página que diz o que é oferecido, com o termo que o cliente busca.
- Links internos com texto descritivo, nunca "clique aqui".
- A página 404 é desenhada, na voz da marca, com o caminho de volta e a chamada para ação.

## O piso de qualidade (tudo, sempre)

- **Nunca force rolagem lateral:** `overflow-x: clip` em `html` e `body` (com `hidden` antes, como recuo). Decorações posicionadas ganham espaço reservado e se escondem em telas baixas com `@media (max-height: ...)`.
- Linhas de texto alinhadas na linha de base (`items-baseline`), não caixas centradas.
- Aspas e apóstrofos tipográficos, reticências de verdade, números com `tabular-nums` onde alinham.
- Favicon da marca em SVG (a plataforma usa o ícone do tema), `theme-color` coerente.
- `og:image` absoluta em PNG ou JPG (pelo `seo.ogImage`).
- Nenhum console com erro ou aviso de React (chaves de lista, props inválidas).
- Nenhuma imagem, fonte ou vídeo binário dentro do workspace.
- TypeScript sem `any` solto nos componentes do site. O `vite build` não checa tipos, mas import quebrado ou erro de sintaxe derruba o build da plataforma com `build_failed`: rode `npx tsc --noEmit` no workspace antes do deploy para pegar o que o build não pega.
