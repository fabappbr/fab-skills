# Movimento e Interação: coreografia de agência sem engasgo

Movimento é direção, não decoração. Cada coisa que se move precisa responder "o que isso diz sobre a marca?". Leia antes de construir (Fase 7).

## A personalidade de movimento

Antes de qualquer código, o pacote de design nomeia a personalidade de movimento da marca em três palavras e dois tokens de easing. Exemplos:

| Marca | Personalidade | Easing de entrada | Easing de interação | Durações |
|---|---|---|---|---|
| Marcenaria artesanal | lenta, pesada, precisa | `cubic-bezier(0.22, 1, 0.36, 1)` | `cubic-bezier(0.65, 0, 0.35, 1)` | 900 a 1400ms |
| Estúdio de música | elástica, rítmica, com impacto | `cubic-bezier(0.34, 1.56, 0.64, 1)` | `cubic-bezier(0.25, 1, 0.5, 1)` | 400 a 700ms |
| Clínica | calma, suave, sem surpresa | `cubic-bezier(0.25, 0.1, 0.25, 1)` | `ease-out` | 500 a 800ms |
| SaaS técnico | exata, rápida, confiante | `cubic-bezier(0.16, 1, 0.3, 1)` | `cubic-bezier(0.4, 0, 0.2, 1)` | 300 a 600ms |

Declare os tokens uma vez no CSS do site (`--ease-in-brand`, `--ease-ui`, `--dur-1`, `--dur-2`, `--dur-3`) e use em tudo. Movimento coerente é o que faz o site parecer dirigido.

## Camada 0: o kit de motion da plataforma (primeiro, sempre)

O workspace já traz `src/components/ui/motion.tsx`, o kit de scroll da Fabapp: testado em Chrome e Safari, com movimento reduzido respeitado, um único listener de scroll para a página inteira. **Toda decisão de motion do pacote de design vira uma chamada a um destes componentes antes de qualquer CSS ou biblioteca.** O que o kit não cobre vai para as camadas seguintes.

```tsx
import { Parallax, ScrollScale, Pin, Marquee, Counter, TextReveal } from "@/components/ui/motion";
import { Reveal } from "@/components/ui/reveal";

// Hero: a imagem anda com o scroll e o título entra palavra a palavra
<section className="relative h-[88vh] overflow-hidden">
  <Parallax speed={0.3} className="absolute inset-0">
    <AppImage slot="hero" prompt="..." className="h-full w-full object-cover" />
  </Parallax>
  <div className="relative z-10 ...">
    <TextReveal as="h1" className="display-hero">Casas e espaços feitos para a vida que acontece neles.</TextReveal>
  </div>
</section>

// Faixa de prova: os números contam quando entram na tela
<Counter value={140} suffix="+" locale="pt-BR" />  <Counter value={38000} suffix=" m²" locale="pt-BR" />

// Processo em capítulos: a seção fica presa por 3 telas e o progresso escolhe o capítulo
<Pin height={3}>
  {(p) => <ProcessChapters active={Math.min(2, Math.floor(p * 3))} progress={p} />}
</Pin>

// Projetos: cada capa cresce e assenta ao cruzar a tela
{projects.map((pr) => <ScrollScale key={pr.id} from={0.92} to={1} fade><ProjectCard project={pr} /></ScrollScale>)}

// Clientes ou depoimentos em letreiro contínuo
<Marquee speed={40}><span className="mx-10">Cliente A</span><span className="mx-10">Cliente B</span></Marquee>

// Entrada simples de uma seção
<Reveal><h2>Sobre o ateliê</h2></Reveal>
```

Regras do kit: o `Parallax` recebe o tamanho no wrapper e a imagem em `object-cover`; o `Pin` fica entre 2 e 4 telas e o filho é uma função do progresso; o `TextReveal` é para o título do hero e uma frase forte por seção, nunca para parágrafo; o `Counter` recebe número, não texto. Os easings da marca (`--ease-in-brand`, `--ease-ui`) continuam valendo para hovers, transições e o que você escrever em CSS.

**Não use `animation-timeline` (scroll-driven animations em CSS) para revelação nem parallax:** o Safari ignora, o site fica parado em todo iPhone, e a revisão de qualidade da plataforma devolve o arquivo. O kit faz o mesmo em todos os navegadores.

## As camadas (escolha a mais baixa que resolve)

| Camada | Ferramenta | Peso | Quando |
|---|---|---|---|
| 0 | **Kit de motion da plataforma** (`@/components/ui/motion`) | zero | Parallax, escala no scroll, seção fixada com capítulos, letreiro, contador, texto revelando, entradas |
| 0 | CSS nativo moderno | zero | Hovers, transições de página, `@starting-style`, gradiente animado, tipografia variável |
| 0,5 | `tailwindcss-motion` (plugin permitido) | zero de JS | Entradas por preset em sites de Nível 1 |
| 1 | **GSAP** + `@gsap/react` (ScrollTrigger, SplitText e todos os plugins, gratuitos desde a 3.13) | ~40 KB gzip com ScrollTrigger e SplitText | Narrativa de scroll, seções fixadas, scrub, texto dividido, linhas do tempo |
| 1 | **Motion** (`motion`, importado de `motion/react`) | ~5 KB com `LazyMotion` | Animação de estado do React: menus, abas, listas, `AnimatePresence`, layout |
| 1 | **Lenis** (`lenis`) | ~4 KB | Rolagem suave, quando a experiência de scroll é o produto |
| 1 | **Embla** (`embla-carousel-react`) | ~7 KB | Carrosséis e galerias com arraste |
| 2 | `three` + `@react-three/fiber` 9 + `@react-three/drei`, ou **OGL** para shaders simples | 30 a 200 KB | WebGL no Nível 3, sempre sob demanda |
| 2 | `@rive-app/react-canvas` ou `@lottiefiles/dotlottie-react` | variável | Ilustração animada interativa |

**Regras de escolha:**
- **Um motor de animação principal.** GSAP para narrativa de scroll, Motion para animação de interface. Os dois juntos só com motivo dito em voz alta.
- **Lenis só quando o scroll é a experiência** (Nível 3, storytelling). Nunca em site de serviço local ou onde há formulário longo.
- **WebGL só no Nível 3, só em desktop capaz,** carregado com `React.lazy` depois da primeira pintura, com imagem estática como recuo.
- Arquivos `.riv` e `.lottie` são binários: hospede no armazenamento do app e use a URL absoluta. Lottie em JSON pode viver em `src/`.

Instale dentro de `.fabapp/workspace` com `npm install gsap @gsap/react`, confira a versão, e o `fabapp deploy` leva as dependências.

## Camada 0: o CSS moderno que um júri reconhece

Tudo abaixo roda sem JavaScript. Envolva em `@supports` o que ainda não está em todos os navegadores, e mantenha o estado final visível como padrão, para o navegador sem suporte mostrar a página completa.

### Revelação guiada pelo scroll (scroll-driven animations): só onde o kit não chega, e nunca sozinha

O `<Reveal>` e o `<ScrollScale>` do kit fazem isto em todo navegador. A receita abaixo fica para efeitos que o kit não tem, sempre dentro de `@supports` e com o estado final visível sem ela.

```css
@keyframes rise { from { opacity: 0; transform: translateY(2.5rem); } to { opacity: 1; transform: none; } }

@media (prefers-reduced-motion: no-preference) {
  @supports (animation-timeline: view()) {
    .rise {
      animation: rise linear both;
      animation-timeline: view();
      animation-range: entry 5% cover 30%;
    }
  }
}
```

A animação é amarrada à posição do elemento na tela, então rolar para cima desfaz. Sem JS, sem IntersectionObserver.

**Arme as revelações na primeira rolagem.** Na página parada no topo, todo elemento abaixo da dobra fica no estado inicial da animação (apagado, deslocado). Auditorias como o Lighthouse medem justamente esse estado e acusam contraste baixo, e buscadores leem a página assim. Prefixe as regras com uma classe que o JS coloca no `html` no primeiro `scroll` (`.motion-ready .rise { ... }`): antes dela, tudo está no estado final; depois, os elementos abaixo da dobra (que ninguém está vendo) voltam ao início e revelam normalmente. Numa construção real, isso levou a acessibilidade de 96 para 100.

**Para o hero no topo da página, prefira `scroll(root)` com faixa em `vh`** (`animation-range: 4vh 95vh`) em vez de `view-timeline` com `contain`: a faixa `contain` do elemento fixado já começava parcialmente avançada no carregamento e deixava o texto do topo meio apagado.

### Barra de progresso de leitura e parallax (parallax: use `<Parallax>` do kit)

```css
.progress { transform-origin: 0 50%; animation: grow linear both; animation-timeline: scroll(root); }
@keyframes grow { from { transform: scaleX(0); } to { transform: scaleX(1); } }

.parallax { animation: drift linear both; animation-timeline: view(); animation-range: cover; }
@keyframes drift { from { transform: translateY(-8%); } to { transform: translateY(8%); } }
```

### Linha SVG que se desenha com o scroll

```html
<svg viewBox="0 0 1200 400" aria-hidden="true"><path class="draw" pathLength="1" d="..." /></svg>
```
```css
.draw { fill: none; stroke: currentColor; stroke-dasharray: 1; stroke-dashoffset: 1; }
@supports (animation-timeline: view()) {
  .draw { animation: draw linear both; animation-timeline: view(); animation-range: entry 20% cover 60%; }
}
@keyframes draw { to { stroke-dashoffset: 0; } }
@media (prefers-reduced-motion: reduce) { .draw { stroke-dashoffset: 0; animation: none; } }
```

### Entrada de elementos que aparecem (`@starting-style`)

```css
.menu { opacity: 1; transform: none; transition: opacity var(--dur-1) var(--ease-ui), transform var(--dur-1) var(--ease-ui), display var(--dur-1) allow-discrete; }
@starting-style { .menu { opacity: 0; transform: translateY(-0.5rem); } }
.menu[hidden] { display: none; opacity: 0; }
```

### Altura automática animada, gradiente animado, tipografia variável

```css
:root { interpolate-size: allow-keywords; }            /* acordeões animam até height:auto (progressivo) */

@property --angle { syntax: "<angle>"; inherits: false; initial-value: 0deg; }
.halo { background: conic-gradient(from var(--angle), var(--c1), var(--c2), var(--c1)); animation: spin 12s linear infinite; }
@keyframes spin { to { --angle: 360deg; } }

.breathe { font-variation-settings: "wght" var(--w, 400); transition: font-variation-settings var(--dur-2) var(--ease-in-brand); }
.breathe:hover { --w: 800; }
```

### Transição entre páginas (View Transitions)

```tsx
import { flushSync } from "react-dom";
import { useNavigate } from "react-router-dom";

export function useTransitionNavigate() {
  const navigate = useNavigate();
  return (to: string) => {
    const reduce = matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (!document.startViewTransition || reduce) return navigate(to);
    document.startViewTransition(() => flushSync(() => navigate(to)));
  };
}
```
```css
::view-transition-old(root) { animation: 280ms var(--ease-ui) both fade-out; }
::view-transition-new(root) { animation: 420ms var(--ease-in-brand) both fade-in; }
.case-cover { view-transition-name: var(--vt-name); }   /* a capa do card vira o hero da página do case */
```

Dê o mesmo `view-transition-name` (único na página) à imagem do card e ao hero da página de destino, e a imagem voa de um para o outro. É um dos gestos mais premiados em portfólios.

### Outros recursos para usar sem medo

`:has()` (estado do pai pelo filho, por exemplo o card que escurece os irmãos), container queries (`@container`, nativo no Tailwind v4), `subgrid`, `text-wrap: balance | pretty`, `mask-image` e `clip-path` para revelações, `backdrop-filter`, `mix-blend-mode: difference` para cursor e texto sobre imagem, `scroll-snap` para galerias no celular, `color-mix()` e cores relativas em `oklch`. Anchor positioning e `scroll-state` queries são progressivos: use só com recuo.

## Camada 1: GSAP em React, do jeito certo

```tsx
import { useRef } from "react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { SplitText } from "gsap/SplitText";
import { useGSAP } from "@gsap/react";

gsap.registerPlugin(useGSAP, ScrollTrigger, SplitText);

export function Manifesto() {
  const scope = useRef<HTMLElement>(null);

  useGSAP(() => {
    const mm = gsap.matchMedia();
    mm.add("(prefers-reduced-motion: no-preference)", () => {
      SplitText.create(".manifesto-title", {
        type: "lines,words",
        mask: "lines",
        autoSplit: true,                      // re-divide quando a fonte carrega ou a largura muda
        onSplit: (self) => gsap.from(self.words, {
          yPercent: 110, duration: 1.1, ease: "expo.out", stagger: 0.04,
          scrollTrigger: { trigger: self.elements[0], start: "top 80%", once: true },
        }),
      });
    });
    return () => mm.revert();
  }, { scope });

  return <section ref={scope}>…<h2 className="manifesto-title">…</h2></section>;
}
```

As regras que evitam os bugs clássicos:

- **Sempre `useGSAP` com `scope`.** Ele cria um contexto e reverte tudo (tweens, ScrollTriggers, SplitText) ao desmontar, inclusive no duplo efeito do StrictMode. Seletores ficam presos ao escopo.
- **Movimento reduzido pelo `gsap.matchMedia()`**: o código de animação só existe na condição `no-preference`, e virar a preferência com a página aberta reverte tudo para o estado final.
- **SplitText com `autoSplit` e `onSplit`** quando o texto usa fonte web: sem isso, a divisão é feita na fonte de recuo e as linhas quebram errado quando a fonte chega. O SplitText mantém o texto acessível para leitores de tela.
- **Troca de rota:** role para o topo e chame `ScrollTrigger.refresh()` depois que a página nova montar e as imagens acima da dobra tiverem tamanho. Imagens sem `width`/`height` deslocam os gatilhos.
- **Pin só com `invalidateOnRefresh: true`** e valores em função (`x: () => -(track.scrollWidth - innerWidth)`), para redimensionar não quebrar.
- **Scrub com suavização curta** (`scrub: 0.6`) para sentir peso sem atraso.
- **Nunca anime `top`, `left`, `width`, `height` ou `margin`.** Só `transform`, `opacity`, e com cuidado `clip-path` e `filter`.

### Seção horizontal fixada

```tsx
useGSAP(() => {
  const mm = gsap.matchMedia();
  mm.add("(min-width: 900px) and (prefers-reduced-motion: no-preference)", () => {
    const track = scope.current!.querySelector<HTMLElement>(".track")!;
    gsap.to(track, {
      x: () => -(track.scrollWidth - window.innerWidth),
      ease: "none",
      scrollTrigger: { trigger: scope.current, pin: true, scrub: 0.6, end: () => "+=" + track.scrollWidth, invalidateOnRefresh: true },
    });
  });
  return () => mm.revert();
}, { scope });
```

No celular e com movimento reduzido, a mesma trilha vira rolagem horizontal nativa com `scroll-snap`. Nunca prenda o visitante de celular numa seção fixada.

### Lenis com GSAP

```tsx
import Lenis from "lenis";
import "lenis/dist/lenis.css";

useEffect(() => {
  if (matchMedia("(prefers-reduced-motion: reduce)").matches) return;
  const lenis = new Lenis({ autoRaf: false, lerp: 0.1 });
  lenis.on("scroll", ScrollTrigger.update);
  const tick = (time: number) => lenis.raf(time * 1000);
  gsap.ticker.add(tick);
  gsap.ticker.lagSmoothing(0);
  return () => { gsap.ticker.remove(tick); lenis.destroy(); };
}, []);
```

Monte uma vez só, no layout do site. Links de âncora passam por `lenis.scrollTo`. Campos com rolagem própria levam `data-lenis-prevent`.

## Camada 1: Motion para a interface

```tsx
import { LazyMotion, domAnimation, m, AnimatePresence, useReducedMotion } from "motion/react";

<LazyMotion features={domAnimation} strict>
  <AnimatePresence mode="wait">
    {open && <m.div key="panel" initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -8 }} transition={{ duration: 0.3, ease: [0.16, 1, 0.3, 1] }} />}
  </AnimatePresence>
</LazyMotion>
```

`LazyMotion` com `m` mantém o peso baixo. `useReducedMotion()` decide o recuo. `layout` e `layoutId` fazem o indicador de aba deslizar e o card expandir para detalhe.

## Coreografia de texto: o princípio do eco

Cada momento importante ganha uma entrada própria, e a entrada ecoa o que o conteúdo diz. Um título sobre "peso" desce e assenta com massa. Uma frase sobre "precisão" entra letra por letra em grade. Uma promessa de "calma" surge de desfoque para nítido. Entrada e mensagem leem como um evento só; é isso que faz a página parecer dirigida.

Um cardápio de partida, não uma lista fechada:

| Entrada | Ecoa | Como |
|---|---|---|
| Linhas sobem da máscara | chegada, confiança | SplitText `mask: "lines"`, `yPercent: 110`, stagger por linha |
| Palavras com impacto e overshoot | impacto, energia | escala de 0,6 até 1,08 e volta a 1, easing com overshoot |
| Letras se montam em dispersão | algo se juntando | offsets aleatórios com semente, voltam a zero |
| Desfoque para nítido | névoa clareando, foco | duas cópias empilhadas, crossfade só de opacidade; o desfoque é estático, nunca anime `filter` em texto grande |
| Peso variável que cresce | força, respiração | `font-variation-settings` guiado por scroll |
| Metades que se abrem | revelação, abertura | duas metades partem da linha central |
| Contador que sobe | prova, escala | `tabular-nums`, conta ao entrar, pula para o valor com movimento reduzido |

Inventar uma entrada nova para este site é o trabalho. A parte fixa vale para toda invenção: só transform e opacity, easing dos tokens, reversível quando faz sentido, e estado final imediato com movimento reduzido.

## O momento interativo único

Um por site, no tema, no meio da jornada: uma ação que encena a própria ideia da marca. Um pressionar e segurar que deixa um aroma assentar. Um arrastar que costura uma bainha. Um cursor que acende a luz de um ambiente escuro. Um controle que muda a estação do ano nas imagens. O visitante não só lê a ideia; ele a executa.

A mecânica que faz parecer desenhado em vez de truque:
- O progresso constrói enquanto o visitante age; soltar cedo desce suave, nunca estala para zero.
- Completar entrega algo real (o conteúdo da seção acende, um número aparece, um som opcional toca).
- Funciona com teclado (espaço segura, setas arrastam) e com toque.
- Movimento reduzido recebe o estado final pronto, sem precisar agir.

## Detalhes de interação que um júri nota

- **Cursor personalizado** só com `(pointer: fine)`, acompanhando por `transform` com suavização num loop que descansa, crescendo sobre links, e nunca escondendo o cursor nativo em campos de texto.
- **Botões magnéticos**: o botão segue o cursor alguns pixels dentro de um raio e volta com mola. Só `(pointer: fine)`.
- **Hover de imagem**: zoom de 1,03 a 1,06 dentro de máscara, ou revelação por `clip-path`. Nunca sombra genérica.
- **Links sublinhados desenhados**: a linha cresce da esquerda com `scaleX`, sai pela direita.
- **Marquee**: trilha duplicada, `translateX(-50%)` em loop, trilha maior que 2560px, pausa no hover e no movimento reduzido.
- **Carregamento inicial**: nada de tela de carregamento que esconde o conteúdo. A primeira pintura já é o hero; a introdução, se existir, dura no máximo 1,2s e nunca começa a imagem principal em opacidade zero (isso atrasa o LCP).

## O piso de movimento (tudo, sempre)

- **Nada estala.** Toda aparição, hover e troca de estado tem easing dos tokens.
- **Só `transform` e `opacity`.** Para brilho pulsante, ponha a sombra num pseudo-elemento e anime a opacidade dele.
- **Um elemento vivo por seção**, em nível de sussurro, ciclo de 4s ou mais, com atraso negativo para já estar no meio do ciclo na primeira pintura.
- **Pause o que está fora da tela** (classe alternada por IntersectionObserver) e tudo em aba escondida: `body.paused *, body.paused *::before, body.paused *::after { animation-play-state: paused !important; }` alternado no `visibilitychange`. `animation-play-state` não herda; defini-la num contêiner não alcança os filhos.
- **Loops de `requestAnimationFrame` descansam** quando convergem e quando saem da tela. Suavização independente da taxa de quadros: `v += (alvo - v) * (1 - Math.pow(1 - k, dt / 16.667))`.
- **Escalonamento de 60 a 150ms**, e aposente os atrasos quando a entrada termina: a regra que zera `transition-delay` precisa igualar a especificidade das regras `:nth-child` que ela aposenta, ou todo hover nos irmãos atrasa para sempre.
- **Estados inicial e final de entrada prefixados pelo contêiner** (`.card .part`, `.card.in .part`) para vencerem a cascata.
- **Nunca estilo dinâmico num elemento com animação `forwards`**: entrada no pai, estilo dinâmico no filho.
- **Texto mascarado ganha respiro** de padding em `em` com margem negativa casada, ou g, y e p perdem o rabo.
- **Nunca sobrescreva `el.style.transition` em JS.** Alterne uma classe.
- **Movimento reduzido honrado por completo e ao vivo**, nas duas direções: ao ligar, cada elemento guiado por scroll vai para o estado final e os motores param; ao desligar, os motores voltam a comandar e nada fica fixado para trás. `gsap.matchMedia()` e `useReducedMotion()` resolvem isso; animações CSS ficam dentro de `@media (prefers-reduced-motion: no-preference)`.
