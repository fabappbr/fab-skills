---
name: estilo-minimalista
description: "Dá ao app ou site da Fabapp AI, construído ou editado pelo terminal (CLI @fabappai/cli), o visual minimalista editorial de ferramenta de trabalho premium: fundo branco-osso, texto grafite, títulos em serifa editorial, cartões planos com borda de 1px, grade bento assimétrica, tons pastel apagados só em etiquetas, quase nenhuma sombra e movimento discreto. Use quando o dono pedir algo limpo, clean, minimalista, sóbrio, simples, estilo Notion, estilo documento, estilo revista, cara de escritório moderno, 'sem exagero', 'sem cores berrantes', 'bem clean', ou quando o negócio pede calma e confiança: escritório de advocacia, contabilidade, consultoria, psicologia, estúdio de design, editora, blog, ferramenta interna. Use também quando o dono disser que o app está 'poluído', 'carregado' ou 'cheio de cor' e quiser algo mais refinado."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Estilo Minimalista Editorial
  edition: terminal
---

# Estilo Minimalista Editorial

Pacote estético fechado: paleta monocromática quente, contraste tipográfico de revista, muito espaço em branco, componentes planos e cor usada como recurso escasso. Serve para site e para app de uso diário (a versão de app está em "A construção").

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Este pacote vale inteiro dentro dele. Se outra skill de estilo ou de gosto instalada disser o contrário (por exemplo, proibir serifa nos títulos ou pedir etiqueta em pílula acima de todo título), aqui vale o que está aqui. Acima do pacote só está o contrato da plataforma (`references/fabapp-cli.md`: cores e fontes pelo tema, layout obrigatório, acesso aos dados).

## Em todas as partes: a especificação do estilo

### Paleta (os valores exatos vão só no `theme` do `fab.config.json`; o código nunca escreve hex)

| Papel | Como é | Token no código |
|---|---|---|
| Fundo da página | branco-osso quente (ou branco puro, se o dono escolher) | `bg-background` |
| Superfície de cartão | branca, levemente mais clara que o fundo osso (no terminal o `theme` tem a chave `card` própria); o cartão se separa pela borda de 1px, não pela cor | `bg-card` |
| Texto principal | grafite escuro, nunca preto puro | `text-foreground` |
| Texto secundário | cinza morno, que a plataforma deriva do texto e do fundo | `text-muted-foreground` |
| Botão principal | quase preto com texto claro | `bg-primary text-primary-foreground` |
| Bordas e divisórias | cinza ultraclaro, que a plataforma deriva | `border-border`, `divide-border` |
| Destaque suave | um pastel apagado escolhido na conversa (tabela abaixo) | `bg-accent` |

Pastéis de etiqueta (fundo claro com texto escuro do mesmo tom). Na conversa, um deles vira o `accent` do tema; no código, as etiquetas de status usam os tokens semânticos com transparência:

| Tom | No código |
|---|---|
| Azul claro | `bg-info/10 text-info` |
| Verde claro | `bg-success/10 text-success` |
| Amarelo claro | `bg-warning/15 text-foreground` |
| Vermelho claro | `bg-destructive/10 text-destructive` |

### Tipografia (as famílias exatas vão só no `theme`)

- Títulos e citações: uma serifa editorial de leitura em tela, a `titleFont` do tema (classe `font-display` e variável `var(--font-display)`). A original citava fontes pagas; a equivalente livre está em "A marca no `fab.config.json`".
- Texto, interface e botões: uma sans geométrica com caráter, a `bodyFont` do tema. O código nunca escreve `font-family` com nome nem `@import` de fonte.
- Mono (atalhos, metadados, códigos): a classe `font-mono`, que a plataforma já carrega com a mono fixa dela; nenhuma outra mono entra.
- Títulos: entrelinha `leading-[1.1]`, espaçamento entre letras `tracking-[-0.03em]` (faixa da original: -0.02em a -0.04em). O h1 parte do tamanho obrigatório da plataforma e cresce por tela: `text-3xl sm:text-4xl lg:text-6xl` no herói do site, `text-3xl sm:text-4xl` na tela de app.
- Texto corrido: `leading-[1.6]`, `text-foreground`; secundário em `text-muted-foreground`.

### Proibições (valem no app pronto e são conferíveis)

1. Nada de sombra pesada: nenhum `shadow-md`, `shadow-lg`, `shadow-xl`. Sombra só a ultradifusa de hover descrita abaixo, com opacidade abaixo de 0,05.
2. Nenhuma seção ou bloco grande com fundo na cor forte (`bg-primary` em faixa de seção, herói azul, verde ou vermelho). `bg-primary` só em botão.
3. Nada de gradiente visível, neon ou vidro 3D. Exceções: desfoque leve no cabeçalho fixo (`backdrop-blur-sm bg-background/80`) e as camadas quase invisíveis de profundidade de fundo descritas na construção (luz radial e grade de linhas).
4. Nada de `rounded-full` em cartão, contêiner grande ou botão principal. Pílula só em etiqueta pequena.
5. Nenhum emoji em texto, título, botão, `alt` ou código. No lugar, ícone.
6. Nenhum nome genérico de exemplo ("Fulano de Tal", "João Silva" repetido, "Empresa X", "Lorem ipsum", "Acme"). Use nomes brasileiros variados e realistas, marcados como exemplo quando não forem do dono.
7. Nenhum clichê de copy de IA ("Eleve", "Transforme", "Descubra o poder", "soluções inovadoras", "próximo nível", "jornada", "mergulhe"; se a skill `texto-sem-cara-de-ia` estiver instalada, ela traz a lista dura completa). Escreva frases simples e específicas do negócio.
8. Nenhuma foto de banco externa nem `picsum`: imagem decorativa é `<AppImage slot prompt>`; imagem de dado vem do registro.

## Antes de começar

- Rode o primeiro movimento de `references/fabapp-cli.md` e leia `DECISOES.md`. Se lá já houver uma marca registrada, pergunte ao dono se o estilo minimalista substitui essa marca antes de tocar no `theme`.
- `fabapp pull` para ter o `apps/<slug>/fab.config.json` atual no disco.

## A conversa: perguntas e a marca que você grava

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Pergunte só o que muda o visual; o resto já está decidido pelo pacote. No máximo estas três, de uma vez:

1. "Que fundo combina mais com o seu negócio?"
   - "Branco-osso, um branco levemente quente, com cara de papel (Recomendado)"
   - "Branco puro, mais frio e técnico"
2. "Onde entra uma cor suave? Ela aparece só em detalhes, como etiquetas e ícones."
   - "Azul bem claro (Recomendado)"
   - "Verde bem claro"
   - "Amarelo bem claro"
   - "Vermelho-rosado bem claro"
3. "Nas imagens decorativas do site, o que você prefere?" (só se for site ou página pública)
   - "Fotos em tom quente e cores suaves (Recomendado)"
   - "Ilustrações em traço preto, estilo desenho à mão, com uma forma colorida suave"

Se o dono já mandou cor ou logo, a cor dele entra como `primary` só se ele insistir que o botão seja dessa cor; o padrão do estilo é o botão quase preto e a cor dele vira o `accent` (o estilo usa cor como detalhe). Diga isso em uma frase simples.

### A marca no `fab.config.json`

Você grava a marca em `apps/<slug>/fab.config.json → theme` (é o único lugar onde hex e nome de fonte aparecem; chaves em `references/fabapp-cli.md`) e envia com `fabapp push`. O tema só aparece no ar no próximo `fabapp deploy`.

- `mode`: `"light"`
- `primary`: `#111111`; `primaryFg`: o mesmo valor do `bg` (texto claro sobre o botão quase preto)
- `bg`: `#F7F6F3` (branco-osso) ou `#FFFFFF` (branco puro)
- `card`: `#FFFFFF` (sobre o branco-osso é o cartão branco da original; sobre o branco puro fica igual ao fundo e a borda separa)
- `text`: `#2F3437`
- `accent`: `#E1F3FE` (azul), `#EDF3EC` (verde), `#FBF3DB` (amarelo) ou `#FDEBEC` (vermelho-rosado)
- `titleFont`: `Newsreader` (serifa editorial; a original citava Lyon Text, que é paga, e Playfair Display; Instrument Serif serve como alternativa só de título, porque tem um peso só e a plataforma exige regular e negrito na fonte de texto)
- `bodyFont`: `Geist` (a original citava SF Pro Display, Helvetica Neue e Switzer, que não estão no Google Fonts). Nunca troque por Inter, Roboto ou Open Sans.
- `titleTracking`: `"-0.03em"`
- `radius`: `8` (número; botões e campos saem com 6px e cartões com 12px, dentro da faixa da original: botão 4 a 6px, cartão até 12px)

Fontes pelo nome exato do catálogo do Google Fonts: nome errado não dá erro, o app sai na fonte do sistema. Se a cor do dono virou `primary` (ele insistiu no botão na cor dele), ela vai em `primary` e `primaryFg` passa a ser a cor de texto que dá contraste sobre ela.

Anote em `DECISOES.md`, seção Marca: "Estilo visual: Minimalista Editorial (fundo claro, títulos em serifa, cartões planos com borda fina, cor só em detalhes)", a paleta, as fontes, o raio e, se for site, qual das duas opções de imagem o dono escolheu.

## O plano

Escreva o plano e mostre ao dono antes de codar. Em "Visão geral", a linha "Estilo: Minimalista Editorial" e o tom "minimalista editorial, calmo, monocromático quente". Suposição, com alternativa: "Usei o estilo minimalista editorial; dá para trocar cores e fontes depois, é só pedir que eu mudo o tema."

Na parte "O que não entra", não liste o estilo; liste só funcionalidades. Se o app for de uso diário (cadastros, pedidos, agenda, painel), escreva no plano que a tela inicial abre na tarefa, com o estado do usuário e as ações, sem herói de slogan, e que o estilo se aplica às superfícies (tabelas planas, cartões com borda, títulos em serifa).

Todos estes itens entram na **lista de conferência** do plano:

- Nenhum arquivo usa `shadow-md`, `shadow-lg` ou `shadow-xl`; cartões não têm sombra em repouso.
- Todo cartão e toda divisória usam borda de 1px com o token `border-border`; nenhum cartão usa `rounded-full` nem raio acima de `rounded-xl`.
- Nenhuma seção ou faixa de página tem fundo `bg-primary`; `bg-primary` aparece só em botões.
- Etiquetas de status são pílulas `text-xs uppercase tracking-[0.05em]` com fundo pastel por token (`bg-info/10`, `bg-success/10`, `bg-warning/15`, `bg-destructive/10`).
- Seções da página pública têm `py-16 sm:py-24 lg:py-32` e o texto corrido fica em até `max-w-4xl`.
- Blocos principais da página pública entram com `<Reveal>` de 600ms e curva `cubic-bezier(0.16,1,0.3,1)`; itens de fileira com atraso `Math.min(i,6)*60`.
- Nenhum emoji e nenhum clichê da lista proibida em texto visível.
- Títulos principais aparecem na fonte serifada do tema, com entrelinha apertada; o texto corrido é grafite, nunca preto puro (visual).
- Nenhuma seção da página pública é uma faixa lisa vazia: cada uma tem imagem, textura de linhas, luz radial suave ou grade bento (visual).
- Se houver perguntas frequentes: o FAQ não tem caixa em volta; itens separados só por `border-b border-border`, com ícone de mais e menos.
- O `theme` do `fab.config.json` tem os valores da marca acima e o `fabapp push` passou sem erro.

O dono aprova o plano antes da construção.

## A construção: como aplicar, peça por peça

Ordem de trabalho (é o protocolo do estilo): primeiro o `theme` no `fab.config.json` e `fabapp push`, depois o espaço em branco entre seções, depois a largura do texto, depois a hierarquia tipográfica pelos tokens, depois bordas de 1px em todo cartão e divisória, depois a entrada por scroll nos blocos principais, e por fim a profundidade de fundo das seções. Entregue o código pronto nesse acabamento, sem depender de ajuste manual.

### Espaço e largura
- Seção de página pública: `py-16 sm:py-24 lg:py-32` (a original pedia `py-24` a `py-32`; a base menor é para o celular). Contêiner `mx-auto max-w-5xl px-6`; texto corrido e títulos longos em `max-w-4xl` ou menos.
- Tela de app: `py-8 sm:py-12`, contêiner `mx-auto max-w-5xl px-6`, grupos separados por espaço, não por caixas.

### Tipografia na prática
- Os títulos já saem na `titleFont` do tema. Se o app ainda não tem `src/app-typography.css`, escreva-o inteiro, com as regras dentro de `@layer base`: `h1, h2, h3 { font-family: var(--font-display); letter-spacing: -0.03em; line-height: 1.1; }`. Nunca escreva nome de fonte nem `@import` de fonte.
- Citação em destaque: `<blockquote className="font-display text-2xl sm:text-3xl leading-[1.2] tracking-[-0.02em]">`.
- Metadados (datas, códigos, contagens): `font-mono text-xs text-muted-foreground`.

### Grade bento de recursos
- Grade assimétrica: `grid gap-4 sm:grid-cols-2 lg:grid-cols-6`, com um cartão largo `lg:col-span-4` ao lado de um estreito `lg:col-span-2`, e a linha seguinte invertida. Na base, uma coluna.
- Cartão: `rounded-xl border border-border bg-card p-6 sm:p-10` (padding de 24px a 40px), sem sombra. Nada de cartão dentro de cartão.

### Botões
- Principal: o `Button` do kit (já sai `bg-primary`), com `shadow-none`, raio `rounded-md` (6px com o tema em 8), hover `hover:bg-primary/90`, pressão `active:scale-[0.98] transition-transform duration-200`.
- Secundário: `variant="outline"` com a mesma borda de 1px, ou link de texto sublinhado `underline-offset-4`.

### Etiquetas de status
- `<span className="inline-flex rounded-full px-2.5 py-0.5 text-xs font-medium uppercase tracking-[0.05em] bg-info/10 text-info">`. Use o tom pelo significado: informação azul, concluído verde, pendente amarelo, problema vermelho.

### FAQ (acordeão sem caixa)
- Itens sem contêiner, separados por `border-b border-border`, pergunta em `py-5 text-left font-medium`, ícone `Plus` que vira `Minus` (lucide) quando aberto. Pode ser o `Accordion` do kit com `className` que tire borda externa e fundo, ou um disclosure simples com `aria-expanded`.

### Atalhos de teclado e janela de software
- Atalho: `<kbd className="rounded border border-border bg-muted px-1.5 py-0.5 font-mono text-xs">Ctrl</kbd>`.
- Quando mostrar uma tela de software (print do sistema do dono, painel de exemplo), envolva num quadro de janela: barra superior `flex gap-1.5 border-b border-border px-4 py-3` com três círculos `size-2.5 rounded-full bg-border`, e o conteúdo abaixo, no mesmo cartão de borda de 1px.

### Ícones
- `lucide-react` com traço único em todo o app: `strokeWidth={2.25}` e tamanho `size-4` ou `size-5`. A original proibia Lucide fino e pedia Phosphor Bold ou Radix; aqui o traço mais grosso e uniforme dá o mesmo efeito técnico, sem pacote extra. Não misture pesos.

### Imagens e ilustrações
- Foto decorativa: `<AppImage slot="..." prompt="warm-toned, desaturated photo of <cena do negócio>, soft natural light, muted colors, editorial" className="aspect-[4/3] w-full rounded-xl object-cover saturate-[.85] sepia-[.08]"/>`. Nunca foto saturada de banco. Uma `AppImage` por linha, nunca dentro de `.map()`: o dono troca ou gera cada slot no Studio, e a troca grava o `src` na tag pela linha.
- Grão quente opcional sobre a foto: uma camada `pointer-events-none absolute inset-0 opacity-[0.04]` com ruído (SVG `feTurbulence` inline).
- Se o dono escolheu ilustração: `prompt="monochrome rough continuous-line ink sketch of <tema> on a white background, with a single offset geometric shape filled in pale <tom do accent>"`.

### Profundidade de fundo (nenhuma seção pública lisa e vazia)
Escolha por seção, sem repetir a mesma em seções vizinhas:
- Luz radial suave: camada `pointer-events-none absolute inset-0 -z-10 bg-[radial-gradient(60%_50%_at_20%_0%,var(--accent),transparent)] opacity-50`.
- Grade de linhas finas: `bg-[linear-gradient(to_right,var(--border)_1px,transparent_1px),linear-gradient(to_bottom,var(--border)_1px,transparent_1px)] bg-[size:48px_48px]` com `[mask-image:radial-gradient(ellipse_at_center,black,transparent_75%)]`.
- Imagem de fundo em largura total com `opacity-10`, atrás do texto.
- Opcional, no máximo um por site: mancha de luz que deriva devagar, numa camada `pointer-events-none fixed inset-0 -z-10` com `bg-[radial-gradient(circle_at_30%_30%,var(--accent),transparent_45%)] opacity-40 motion-safe:animate-[spin_60s_linear_infinite]`. Nunca dentro de contêiner que rola.

### Movimento (discreto, quase invisível)
- Entrada por scroll: `<Reveal className="duration-[600ms] ease-[cubic-bezier(0.16,1,0.3,1)]">` em cada bloco principal (o `Reveal` já sobe 12px com fade e usa IntersectionObserver). Nunca escute `scroll` na janela.
- Fileiras: `delay={Math.min(i,6)*60}` (teto da plataforma), nunca tudo de uma vez. Nunca envolva a rota inteira nem lista longa de dados.
- Hover de cartão clicável: `transition-shadow duration-200 hover:shadow-[0_2px_8px_rgba(0,0,0,0.04)]`.
- Anime só `transform` e `opacity`; nada de `top`, `left`, `width`, `height`. `will-change` só no que está animando. Nada de `animation-timeline`.

### Quando é app de uso diário
- Tela inicial abre na tarefa, com o estado e as ações do usuário, sem herói de slogan.
- Listas como tabela plana: `divide-y divide-border`, sem zebra colorida, sem sombra; linhas com `py-3`.
- Painel: número grande em `text-3xl font-semibold tabular-nums`, rótulo pequeno em `text-muted-foreground`, cartões de borda de 1px, gráfico com uma cor só (a marca) e grade suave.
- Estados de lista: carregando com `Skeleton`, vazio com `EmptyState` e uma ação, erro com `e.message` e "Tentar de novo" (se a skill `ux-de-sistemas` estiver instalada, ela detalha esses estados).

## Conferir antes de dizer pronto

Rode `fabapp dev`, abra a pré-visualização e percorra cada item da lista de conferência do plano, no celular e no desktop. Confira no código, por busca (`grep` em `.fabapp/workspace/src`), e relate só o que conferiu:

1. Busca por `shadow-md`, `shadow-lg`, `shadow-xl`, `rounded-full` em cartão ou botão principal, `bg-primary` em seção: zero.
2. Todo cartão com `border border-border`; nenhum cartão aninhado.
3. Seções públicas com o espaçamento do pacote e com uma camada de profundidade cada.
4. `Reveal` com 600ms e a curva do pacote nos blocos principais; stagger limitado.
5. Nenhum emoji, nenhum clichê da lista, nenhum nome genérico.
6. Ícones lucide com o mesmo `strokeWidth` em todo o app.
7. As regras que a plataforma impõe e o `deploy` não confere: nenhum hex nem `font-family` no código, nenhum `window.confirm`/`alert`/`prompt`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`.

Depois `fabapp push` (se o `theme` mudou) e `fabapp deploy`. `account_builds_busy` (409): espere e repita. `build_failed` (422): conserte pelo arquivo, linha e coluna da mensagem antes de tentar de novo. Confira no ar que os títulos saíram na serifa (fonte com nome errado cai na do sistema em silêncio).

Na mensagem final ao dono: o que foi conferido, o link, e o que ele faz no Studio (trocar ou gerar as imagens de cada slot, subir o logo).

## Mudanças depois: manter o estilo e trocar a marca do jeito certo

- Tudo que entrar numa tela nova segue o mesmo pacote: borda de 1px, sem sombra, pastéis só em etiqueta, mesma entrada por scroll.
- Cor, fonte e raio mudam só no `theme` do `fab.config.json` (nunca em CSS), com os nomes exatos do pacote e raio 8, seguidos de `fabapp push` e `fabapp deploy`. O logo o dono sobe no Studio. Se o dono pedir "mais cor", mova a cor dele para o `accent` e para ícones, e mantenha o botão quase preto, explicando em uma frase. Atualize a seção Marca do `DECISOES.md`.
- Espaçamento entre letras e entrelinha dos títulos mudam em `src/app-typography.css`, uma vez para o app todo.
- Nunca mude em silêncio rotas, nomes de campos, textos que o dono escreveu, logo e textos legais (se a skill `redesign-e-polimento` estiver instalada, ela traz a lista completa).
