---
name: fab-estilo-premium-suave
description: "Dá ao site ou app da Fabapp AI, construído ou editado pelo terminal (CLI @fabappai/cli), o acabamento de estúdio caro: muito espaço, tipografia grande, cartões em dupla moldura como vidro num encaixe de alumínio, sombras difusas quase invisíveis, botões em pílula com ícone num círculo, menu flutuante em cápsula de vidro e movimento com peso e mola. Três climas fechados: Vidro Etéreo (preto profundo com brilhos), Luxo Editorial (creme, serifa grande, textura de papel) e Estrutura Suave (branco ou prata, sans forte, flutuante). Use quando o dono pedir algo premium, sofisticado, luxo, caro, chique, estilo Apple, vidro, estilo site de agência, 'com cara de marca grande', 'bem acabado', 'suave', ou quando o negócio vende confiança e desejo: clínica de estética, arquitetura, imobiliária de alto padrão, hotel, pousada, restaurante sofisticado, joalheria, moda, fotografia, SaaS, startup, bem-estar. Use também quando o dono disser que o site está 'simples demais' ou 'com cara de barato'."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Estilo Premium Suave
  edition: terminal
---

# Estilo Premium Suave

Pacote estético fechado de nível estúdio de ponta: profundidade tátil, ritmo espacial de cinema, microinterações cuidadas e movimento fluido com massa. A linguagem é a das marcas de tecnologia mais caprichadas: superfícies que parecem peças usinadas, nada colado chapado no fundo.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Este pacote vale inteiro dentro dele. Outras skills de gosto proíbem a etiqueta em pílula acima do título; aqui ela faz parte do estilo, nas páginas de vitrine. Se outra skill de estilo instalada disser o contrário, aqui vale o que está aqui. Acima do pacote só está o contrato da plataforma (`references/fabapp-cli.md`: cores e fontes pelo tema, layout obrigatório, acesso aos dados).

## Em todas as partes: a especificação do estilo

### Os três climas (escolha UM por app)

| Clima | Para quem | Paleta (em palavras; os valores exatos vão só no `theme` do `fab.config.json`) | Tipografia (a família exata vai só no `theme`) | Textura |
|---|---|---|---|---|
| Vidro Etéreo | SaaS, IA, tecnologia, startup, games | fundo preto profundo, texto quase branco, principal violeta de brilho | título em grotesca larga, texto em sans geométrica | orbes de luz desfocados atrás; cartões quase pretos com fio claro a 10% (`ring-foreground/10`) |
| Luxo Editorial | estética, imobiliária, hotel, moda, restaurante, agência, arquitetura | fundo creme, texto café, principal café profundo, destaque sálvia apagada | título em serifa variável de alto contraste, texto em sans humanista | grão de papel a 3% |
| Estrutura Suave | saúde, bem-estar, consumo, portfólio, clínica, estúdio | fundo prata claro, texto e principal quase pretos, destaque cinza-prata | título em grotesca forte, texto em sans geométrica | componentes flutuando com sombra ambiente muito difusa |

No código só existem tokens (`bg-background`, `text-foreground`, `bg-primary`, `bg-accent`, `font-display`); o código nunca escreve hex, `font-family` com nome nem `@import` de fonte.

### Os três arranjos de layout (o plano escolhe UM por página de vitrine, pelo conteúdo)

1. **Bento assimétrico**: grade tipo alvenaria com cartões de tamanhos diferentes (um `lg:col-span-8 lg:row-span-2` ao lado de dois `lg:col-span-4` empilhados, numa grade `lg:grid-cols-12`). No celular: uma coluna, `gap-6`, todo `col-span` volta a 1. Use quando há 4 a 7 recursos ou serviços.
2. **Cascata em Z**: elementos empilhados como cartões físicos, sobrepostos de leve, alguns girados `-rotate-2` ou `rotate-3`. No celular (abaixo de `md`): sem rotação e sem margem negativa, empilhados com espaço normal (sobreposição atrapalha o toque). Use em portfólio, galeria, cardápio de destaques.
3. **Divisão editorial**: tipografia enorme na metade esquerda (`md:w-1/2`) e, à direita, fileira de imagens em pílula que rola de lado (`ScrollRow`) ou cartões escalonados. No celular: largura total, texto em cima, conteúdo embaixo (a rolagem lateral pode ficar). Use quando a página é guiada por texto.

Regra de celular para todos: abaixo de `md`, qualquer arranjo assimétrico vira `w-full` com blocos `py-8`, dentro do contêiner obrigatório `px-6`. Seção de altura cheia usa `min-h-[100dvh]`, nunca `h-screen` (o Safari do iPhone pula).

Variedade: dentro do mesmo app, páginas de vitrine vizinhas não repetem o mesmo arranjo, e o plano registra por escrito qual clima e quais arranjos foram escolhidos (é o que impede dois apps do mesmo nicho saírem iguais).

### Proibições (a peça falha se tiver qualquer uma)

1. Fonte de marca fora do clima (a lista das famílias do pacote e das proibidas está em "A marca no `fab.config.json`").
2. Ícone de traço grosso: todos os ícones `lucide-react` com `strokeWidth={1.25}` (traço fino e preciso, no lugar de Phosphor Light ou Remix Line da original).
3. Borda cinza sólida genérica de 1px em cartão de vitrine e sombra dura (`shadow-md`, `shadow-lg`, sombra com opacidade alta). Profundidade vem da dupla moldura e de sombra difusa.
4. Menu grudado de ponta a ponta no topo; grade simétrica de 3 colunas sem espaço largo (se houver 3 colunas, `gap-10` ou mais).
5. Transição `linear` ou `ease-in-out` padrão em interação, e mudança de estado instantânea sem interpolação. (A única exceção é o laço contínuo do `Marquee`.)

## Antes de começar

- Rode o primeiro movimento de `references/fabapp-cli.md` e leia `DECISOES.md`. Se lá já houver uma marca registrada, pergunte ao dono se o estilo premium suave substitui essa marca antes de tocar no `theme`.
- `fabapp pull` para ter o `apps/<slug>/fab.config.json` atual no disco.

## A conversa: perguntas e a marca que você grava

Decida o clima pelo negócio (tabela acima) e confirme com o dono numa pergunta só, com o recomendado primeiro. Pergunte com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas.

1. "Qual clima combina mais com a sua marca?"
   - O clima do nicho, marcado "(Recomendado)", descrito em palavras simples:
   - "Vidro escuro: fundo preto profundo com brilhos de luz, bem tecnológico"
   - "Luxo editorial: fundo creme, títulos grandes com serifa, textura de papel"
   - "Suave e limpo: fundo claro prateado, letras fortes, peças flutuando"

Se o dono já tem cor de marca, ela vira o `primary` do clima escolhido, e o resto da paleta do clima fica. Não pergunte fonte, cantos nem layout: são do estilo.

### A marca no `fab.config.json`

Você grava a linha do clima escolhido em `apps/<slug>/fab.config.json → theme` (é o único lugar onde hex e nome de fonte aparecem; chaves em `references/fabapp-cli.md`) e envia com `fabapp push`. O tema só aparece no ar no próximo `fabapp deploy`.

- Vidro Etéreo: `mode` `"dark"`, `primary` `#8B7CF6`, `bg` `#050505`, `text` `#F5F5F5`, sem `accent` (a plataforma deriva do violeta); `titleFont` `Unbounded`, `bodyFont` `Geist`. O bloco `dark` recebe os MESMOS `bg`, `card`, `text` e `primary`. Armadilha: com `mode: "dark"` a plataforma usa a paleta `dark`; se ela ficar vazia, entra o escuro padrão da plataforma no lugar do preto profundo do clima.
- Luxo Editorial: `mode` `"light"`, `primary` `#4A3A2E`, `bg` `#FDFBF7`, `text` `#2A211C`, `accent` `#E6E9DF`; `titleFont` `Fraunces`, `bodyFont` `Plus Jakarta Sans`.
- Estrutura Suave: `mode` `"light"`, `primary` `#18181B`, `bg` `#F4F4F5`, `text` `#18181B`, `accent` `#E4E4E7`; `titleFont` `Bricolage Grotesque`, `bodyFont` `Geist`.
- Nos três: `card` igual ao `bg` (o núcleo da dupla moldura se destaca pela casca, pelo brilho interno e pela sombra, não pela cor), `primaryFg` igual ao `bg` do clima (texto da pílula sobre o principal), `titleTracking` `"-0.03em"`, `radius` `16` (os cartões de vitrine usam o raio grande próprio do estilo por classe). Se o dono tem cor de marca, ela entra em `primary` (e no `primary` do bloco `dark`, no Vidro Etéreo), com `primaryFg` que dê contraste sobre ela.
- Fontes pagas da original trocadas: Clash Display por Bricolage Grotesque, PP Editorial New por Fraunces; Geist e Plus Jakarta Sans já estão no Google Fonts. Nunca use Inter, Roboto, Arial, Open Sans ou Helvetica.

Fontes pelo nome exato do catálogo do Google Fonts: nome errado não dá erro, o app sai na fonte do sistema.

Anote em `DECISOES.md`, seção Marca: "Estilo visual: Premium Suave, clima <nome>", a paleta, as fontes, o raio e os arranjos por página.

## O plano

Escreva o plano e mostre ao dono antes de codar. Em "Visão geral", escreva "Estilo: Premium Suave, clima <nome>; arranjos: <página>: <arranjo>" e o tom do clima. Suposição, com alternativa: "Usei o estilo premium suave no clima X; dá para trocar cores e fontes depois, é só pedir que eu mudo o tema."

Se for app de uso diário: a home abre na tarefa, com o estado e as ações, sem herói de slogan; o estilo mora nos cartões em dupla moldura, nos botões em pílula, na barra de abas flutuante e no movimento.

Todos estes itens entram na **lista de conferência** do plano:

- Todo cartão de vitrine, imagem de destaque e grade de recursos usa a dupla moldura: casca `rounded-[2rem] p-1.5 bg-foreground/5 ring-1 ring-foreground/5` e núcleo `rounded-[calc(2rem-0.375rem)]` com brilho interno.
- Botões principais são pílulas `rounded-full px-6 py-3`; o que tem seta leva a seta dentro de um círculo próprio `size-8 rounded-full`, encostado na borda direita.
- Seções de vitrine têm `py-24 md:py-32 lg:py-40`.
- Toda transição de interação usa `ease-[cubic-bezier(0.32,0.72,0,1)]`; nenhum `ease-linear` ou `ease-in-out` fora do `Marquee`.
- Blocos de vitrine entram por scroll subindo 64px com desfoque que some, em 800ms ou mais, por IntersectionObserver.
- `backdrop-blur` só em elemento `fixed` ou `sticky`; o grão, se houver, é camada `fixed pointer-events-none`.
- Nenhum `shadow-md`, `shadow-lg`, `shadow-xl` nem `h-screen`.
- O menu é uma cápsula de vidro flutuante, solta do topo; o menu do celular abre em tela cheia com os links subindo um a um (visual).
- Abaixo de 768px, todo arranjo assimétrico vira uma coluna, sem rotação nem sobreposição (visual).
- O `theme` do `fab.config.json` tem a linha do clima escolhido (no Vidro Etéreo, também o bloco `dark`) e o `fabapp push` passou sem erro.

O dono aprova o plano antes da construção.

## A construção: como aplicar, peça por peça

Ordem de trabalho: primeiro o `theme` no `fab.config.json` e `fabapp push`, depois o clima e o arranjo de cada página (registre no `DECISOES.md`), depois o fundo com textura, a escala de espaço e os tamanhos enormes de título, depois todos os cartões e grades em dupla moldura, depois as curvas de transição, o menu e os botões com ícone interno. Entregue o código pronto, sem versões genéricas de reserva.

### Dupla moldura (casca e núcleo)
Nenhum cartão, imagem ou contêiner de destaque fica chapado no fundo:
```tsx
<div className="rounded-[2rem] bg-foreground/5 p-1.5 ring-1 ring-foreground/5">
  <div className="rounded-[calc(2rem-0.375rem)] bg-card p-8 shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_20px_40px_-24px_rgba(0,0,0,0.12)]">…</div>
</div>
```
Vale para cartões de recurso, imagens em destaque, blocos de preço e o formulário principal de contato (os campos por dentro seguem o `Field` do kit). Nada de moldura dentro de moldura dentro de moldura: uma dupla moldura por peça.

### Botão com ilha interna
- `Button` do kit com `className="group h-auto rounded-full py-1.5 pl-6 pr-1.5 gap-3 transition-transform duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] active:scale-[0.98]"`.
- Seta dentro de círculo, encostada à direita: `<span className="grid size-8 place-items-center rounded-full bg-background/15 transition-transform duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] group-hover:translate-x-1 group-hover:-translate-y-px group-hover:scale-105"><ArrowUpRight strokeWidth={1.25} className="size-4"/></span>`. Seta nunca solta ao lado do texto.
- Botão sem seta: só a pílula `rounded-full px-6 py-3`.

### Etiqueta acima do título (só em vitrine)
- Antes de H1 e H2 principais das páginas de vitrine: `<span className="inline-flex rounded-full px-3 py-1 text-[10px] font-medium uppercase tracking-[0.2em] bg-foreground/5 ring-1 ring-foreground/10">`. Texto real e curto ("Estúdio", "Serviços", "Contato"), nunca jargão técnico falso. Na home de app de uso diário, não use.

### Espaço e tipografia
- Seções de vitrine `py-24 md:py-32 lg:py-40`; contêiner `mx-auto max-w-6xl px-6`.
- Título de vitrine: parte do tamanho obrigatório da plataforma e cresce por tela: `text-3xl sm:text-4xl md:text-6xl lg:text-7xl leading-[1.02] tracking-[-0.03em] text-balance`. Os títulos já saem na `titleFont` do tema; ajuste global de tracking e entrelinha em `src/app-typography.css` (dentro de `@layer base`, sem nome de fonte).

### Fundo e textura por clima
- Vidro Etéreo: dois orbes numa camada `pointer-events-none fixed inset-0 -z-10`: `absolute left-[10%] top-[-10%] size-[40rem] rounded-full bg-primary/25 blur-3xl` e `absolute right-[5%] top-[30%] size-[32rem] rounded-full bg-success/15 blur-3xl` (o esmeralda da original pelo token de sucesso). Núcleos de cartão `bg-card` com `ring-1 ring-foreground/10`.
- Luxo Editorial: grão de papel numa camada `pointer-events-none fixed inset-0 z-40 opacity-[0.03]` com `<svg>` inline de `feTurbulence`.
- Estrutura Suave: fundo liso com peças flutuando: sombra `shadow-[0_24px_48px_-24px_rgba(0,0,0,0.10)]` nos núcleos.

### Menu em cápsula flutuante e menu de tela cheia
- Cabeçalho (a casca do site): `fixed inset-x-0 top-[max(1.5rem,env(safe-area-inset-top))] z-30 mx-auto w-max rounded-full bg-background/70 px-2 py-2 ring-1 ring-foreground/10 backdrop-blur-xl`. Conteúdo começa com `pt-28`.
- Hambúrguer que vira X: duas barras `absolute h-px w-5 bg-foreground transition-transform duration-500 ease-[cubic-bezier(0.32,0.72,0,1)]`; aberto, uma `rotate-45` e a outra `-rotate-45`, ambas centralizadas. Nunca só sumir.
- Menu aberto: `fixed inset-0 z-50 bg-background/80 backdrop-blur-3xl`, links grandes que sobem de uma caixa invisível: fechado `translate-y-12 opacity-0`, aberto `translate-y-0 opacity-100`, com `transition-all duration-700 ease-[cubic-bezier(0.32,0.72,0,1)]` e atraso `100ms`, `150ms`, `200ms`... por item (`style={{transitionDelay}}`).
- App de uso diário: a barra de abas de baixo vira cápsula flutuante: `md:hidden fixed inset-x-4 bottom-[max(1rem,env(safe-area-inset-bottom))] z-30 rounded-full bg-background/80 ring-1 ring-foreground/10 backdrop-blur-xl`, e o conteúdo ganha `pb-28 md:pb-0`.

### Entrada por scroll (pesada e suave)
O `Reveal` do kit sobe só 12px; este estilo pede mais. Escreva `src/components/FadeUp.tsx` com `useInView(ref, threshold)` e `useReducedMotion()` de `@/components/ui/motion`:
```tsx
import { useRef, type ReactNode } from "react";
import { cn } from "@/lib/utils";
import { useInView, useReducedMotion } from "@/components/ui/motion";

export function FadeUp({ children, delay = 0, className }: { children: ReactNode; delay?: number; className?: string }) {
  const ref = useRef<HTMLDivElement>(null); const seen = useInView(ref, 0.15); const reduced = useReducedMotion();
  return (
    <div ref={ref} style={{ transitionDelay: `${delay}ms` }} className={cn("transition-all duration-[900ms] ease-[cubic-bezier(0.32,0.72,0,1)]", seen || reduced ? "translate-y-0 blur-0 opacity-100" : "translate-y-16 blur-md opacity-0", className)}>
      {children}
    </div>
  );
}
```
Use nos blocos de vitrine, com `delay={Math.min(i,6)*60}` em fileiras. O desfoque existe só durante a entrada e termina em `blur-0`. Nunca escute `scroll` na janela; nunca envolva a rota inteira nem lista longa de dados. Para uma imagem que cresce ao entrar, `ScrollScale from={0.92} to={1} fade`; para título que aparece palavra por palavra, `TextReveal`. Nada de `animation-timeline`. Confira a assinatura de `useInView` no próprio `src/components/ui/motion.tsx` do workspace antes de usar.

### Desempenho e camadas
- Anime só `transform` e `opacity` (e o `blur` da entrada); nunca `top`, `left`, `width`, `height`. `will-change` só no que está animando.
- `backdrop-blur` só em fixo ou sticky (cabeçalho, menu, abas, modal). Nunca em conteúdo que rola.
- Escala de camadas fixa, sem `z-[9999]`: cabeçalho e abas `z-30`, grão `z-40`, menu de tela cheia `z-50`; tooltips e modais ficam com o que o kit já usa.

### Imagens
- Decorativa: `<AppImage slot prompt>` dentro da dupla moldura, com proporção fixa (`aspect-[4/5]`, `aspect-[16/10]`) e `rounded-[calc(2rem-0.375rem)] object-cover`. Na Divisão editorial, as pílulas de imagem são `rounded-full aspect-[3/4] w-40` dentro de `ScrollRow`. Uma `AppImage` por linha, nunca dentro de `.map()`: o dono troca ou gera cada slot no Studio, e a troca grava o `src` na tag pela linha (numa fileira de pílulas, escreva cada `AppImage` na sua linha).
- Texto sobre foto sempre com véu (`bg-gradient-to-t from-black/60`).

## Conferir antes de dizer pronto

Rode `fabapp dev`, abra a pré-visualização e percorra cada item da lista de conferência do plano, no celular (abaixo de 768px) e no desktop. Confira no código, por busca (`grep` em `.fabapp/workspace/src`), e relate só o que conferiu:

1. Nenhuma fonte, ícone grosso, borda cinza genérica, sombra dura, layout ou curva proibidos.
2. Clima e arranjos escolhidos e aplicados, registrados no `DECISOES.md`.
3. Todo cartão e contêiner de destaque em dupla moldura.
4. Botões com seta no padrão de ilha interna.
5. Seções de vitrine com pelo menos `py-24`.
6. Toda transição com curva própria.
7. Entrada por scroll presente nos blocos de vitrine.
8. Abaixo de 768px, uma coluna em `w-full`, sem rotação.
9. Animações só de `transform` e `opacity`.
10. `backdrop-blur` só em elementos fixos.
11. A impressão geral é de site de estúdio caro, não de modelo com fontes bonitas.
12. As regras que a plataforma impõe e o `deploy` não confere: nenhum hex nem `font-family` no código, nenhum `window.confirm`/`alert`/`prompt`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`.

Depois `fabapp push` (se o `theme` mudou) e `fabapp deploy`. `account_builds_busy` (409): espere e repita. `build_failed` (422): conserte pelo arquivo, linha e coluna da mensagem antes de tentar de novo. Confira no ar que o fundo e as fontes são os do clima (fonte com nome errado cai na do sistema em silêncio; no Vidro Etéreo, o preto profundo e não o escuro padrão).

Na mensagem final ao dono: o que foi conferido, o link, e o que ele faz no Studio (trocar ou gerar as imagens de cada slot, subir o logo).

## Mudanças depois: manter o estilo e trocar a marca do jeito certo

- Peça nova segue o mesmo clima: dupla moldura, pílulas, curva `cubic-bezier(0.32,0.72,0,1)`, ícones de traço 1.25.
- Cor, fonte e raio mudam só no `theme` do `fab.config.json` (nunca em CSS), com os nomes exatos do clima e raio 16, seguidos de `fabapp push` e `fabapp deploy`; no Vidro Etéreo, mude também o bloco `dark`. O logo o dono sobe no Studio. Atualize a seção Marca do `DECISOES.md`.
- Nunca mude em silêncio rotas, nomes de campos, textos que o dono escreveu, logo e textos legais (se a skill `fab-redesign-e-polimento` estiver instalada, ela traz a lista completa).
