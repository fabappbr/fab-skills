---
name: fab-estilo-brutalista
description: "Dá ao app ou site da Fabapp AI, construído ou editado pelo terminal (CLI @fabappai/cli), o visual brutalista industrial: grade rígida com divisórias visíveis, títulos enormes em caixa alta, textos técnicos em fonte mono, cantos retos, uma única cor de alerta (vermelho) e texturas de impressão ou de terminal antigo (retícula, linhas de tela, ruído). Duas versões: impresso suíço (papel claro e tinta preta) ou terminal tático (fundo preto e texto fósforo). Use quando o dono pedir algo brutalista, industrial, cru, técnico, mecânico, estilo manual de máquina, planta técnica, estilo militar, painel de controle, terminal, retrô tecnológico, 'bem diferente', 'tipografia gigante', 'cara de pôster suíço', 'painel denso', ou quando o negócio combina: oficina, serralheria, marcenaria, gráfica, loja de discos, streetwear, estúdio de tatuagem, produtora, portfólio de designer, painel de dados denso, frota, estoque, logística, monitoramento. Use também quando o dono achar o app 'fofo demais' e quiser algo cru."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Estilo Brutalista
  edition: terminal
---

# Estilo Brutalista

Pacote estético fechado que junta o design tipográfico suíço dos anos 60, manuais de máquina industrial e telas de terminal militar e aeroespacial. Grade matemática, contraste extremo de escala tipográfica, cor puramente utilitária e degradação analógica simulada. Serve para site (portfólio, editorial, marca com atitude) e para app denso de dados (painel, estoque, frota).

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Este pacote vale inteiro dentro dele. Se outra skill de estilo ou de gosto instalada disser o contrário (por exemplo, pedir cantos arredondados, sombras suaves, caixa alta com moderação ou "nada de rótulos técnicos"), aqui vale o que está aqui. Acima do pacote só está o contrato da plataforma (`references/fabapp-cli.md`).

## Em todas as partes: a especificação do estilo

### Os dois modos: escolha UM e não misture

| | Impresso Suíço Industrial (claro) | Terminal Tático (escuro) |
|---|---|---|
| Inspiração | identidade corporativa dos anos 60, planta de máquina pesada | banco de dados militar, mainframe, painel de avião (HUD) |
| Fundo (`bg-background`) | papel sem alvejante, um cinza-creme bem claro | preto-carvão de tela desligada, nunca preto puro |
| Texto (`text-foreground`) | tinta carbono, quase preta | fósforo branco, um cinza muito claro |
| Cor única de destaque (`bg-primary`) | vermelho de aviação | o mesmo vermelho, um pouco mais claro para ler no escuro |
| Tipografia dominante | sans pesada monolítica | mono em quase tudo |
| Números ou letras gigantes sangrando a tela | sim | não |
| Linhas de tela (CRT), brilho de fósforo | não | sim |

Um modo por app, nunca uma seção clara no meio de um app escuro ou o contrário. O vermelho é a ÚNICA cor de destaque: riscado, divisória grossa, dado vital, botão principal. No modo terminal, um verde de terminal pode aparecer em UM elemento só (um indicador de status ou uma leitura), com o token `text-success`; se não tiver função clara, não use.

Proibidos nos dois modos: gradiente de cor (degradê), sombra suave, transparência moderna (vidro), qualquer canto arredondado. As únicas funções `gradient` permitidas são listras duras de `repeating-linear-gradient` (faixa de aviso, código de barras, linhas de tela) e os pontos de `radial-gradient` da retícula: são padrões chapados, não degradê.

### Tipografia (as famílias exatas vão só no `theme` do `fab.config.json`)

- **Macro (títulos estruturais)**: a `titleFont` do tema, uma sans de peso máximo (classe `font-display`, variável `var(--font-display)`). A original citava fontes pagas; a equivalente livre está em "A marca no `fab.config.json`".
  - Tamanho fluido só no título macro: `text-[clamp(1.875rem,10vw,15rem)]` (a original começava em 4rem; o piso de 1.875rem é o `text-3xl` obrigatório da plataforma em 375px e evita palavra longa em português estourar a tela).
  - Espaçamento entre letras `tracking-[-0.05em]` (faixa -0.03em a -0.06em), entrelinha `leading-[0.9]` (faixa 0.85 a 0.95), sempre `uppercase`, com `[overflow-wrap:anywhere]`.
- **Micro (dados, telemetria, navegação, rótulos)**: a classe `font-mono` (a mono fixa da plataforma, que estava na lista da original). `text-[11px] sm:text-xs`, `tracking-[0.08em]` (faixa 0.05em a 0.1em), `leading-[1.3]` (faixa 1.2 a 1.4), sempre `uppercase`. Todo metadado, item de navegação, código de unidade e coordenada é micro.
- **Texto corrido**: a `bodyFont` do tema, a versão de texto da mesma família da macro (a plataforma só aceita como fonte de texto uma sans ou serifa com regular e negrito; mono e fonte de um peso só ficam para títulos). No modo terminal, a mono domina: o invólucro do layout recebe `font-mono`, e só os títulos macro ficam em `font-display`. O código nunca escreve nome de fonte nem `@import` de fonte.

### Regras de espaço e forma

- **Grade de planta**: tudo ancorado em CSS Grid; nada flutua solto.
- **Compartimentos visíveis**: zonas separadas por bordas sólidas de 1px ou 2px na cor do texto (`border-foreground`); linhas horizontais `border-t-2 border-foreground` atravessando o contêiner inteiro para separar unidades.
- **Densidade bimodal**: blocos de metadados mono bem apertados convivem com grandes vazios calculados em volta da tipografia macro.
- **Geometria**: todo canto a 90 graus. Tema com `radius` 0; no código, a única classe de raio permitida é `rounded-none` (avatares, etiquetas e imagens do kit que trazem raio próprio recebem `rounded-none`); troque `Switch` por `Checkbox` quadrado.

## Antes de começar

- Rode o primeiro movimento de `references/fabapp-cli.md` e leia `DECISOES.md`. Se lá já houver uma marca registrada, pergunte ao dono se o estilo brutalista substitui essa marca antes de tocar no `theme`.
- `fabapp pull` para ter o `apps/<slug>/fab.config.json` atual no disco.

## A conversa: perguntas e a marca que você grava

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. De uma vez:

1. "Qual das duas versões combina com o seu negócio?"
   - "Papel e tinta: fundo claro de papel, letras pretas enormes e um vermelho forte, estilo pôster suíço (Recomendado)" (recomende esta para site de marca, portfólio, loja, oficina)
   - "Terminal: fundo preto, letras claras de computador antigo e um vermelho de alerta, estilo painel de controle" (recomende esta primeiro quando for painel de dados, monitoramento, frota, estoque, tecnologia, games)
2. "As fotos do site podem ganhar um tratamento de impressão, em preto e branco com pontinhos de retícula?" (só se houver fotos decorativas)
   - "Sim, fica com cara de cartaz impresso (Recomendado)"
   - "Não, quero as fotos com as cores normais"

Se o dono já tem uma cor de marca, ela entra no lugar do vermelho como única cor de destaque, e diga isso em uma frase. Não pergunte fonte nem cantos: são do estilo.

### A marca no `fab.config.json`

Você grava a marca em `apps/<slug>/fab.config.json → theme` (é o único lugar onde hex e nome de fonte aparecem; chaves em `references/fabapp-cli.md`) e envia com `fabapp push`. O tema só aparece no ar no próximo `fabapp deploy`.

- Papel e tinta: `mode` `"light"`, `primary` `#E61919`, `primaryFg` `#F4F4F0`, `bg` `#F4F4F0` (alternativa `#EAE8E3`), `card` igual ao `bg`, `text` `#111111` (faixa da original: `#050505` a `#111111`), `accent` `#EAE8E3`.
- Terminal: `mode` `"dark"`, `primary` `#FF2A2A`, `primaryFg` `#0A0A0A`, `bg` `#0A0A0A` (alternativa `#121212`; nunca `#000000`), `card` igual ao `bg`, `text` `#EAEAEA`, `accent` `#121212`, e o bloco `dark` com os MESMOS valores de `bg`, `card`, `text` e `primary`. Armadilha: com `mode: "dark"` a plataforma usa a paleta `dark`; se ela ficar vazia, entra o escuro padrão da plataforma no lugar do preto-carvão do estilo.
- Nos dois: `titleFont` `Archivo Black` (a original citava Neue Haas Grotesk Black e Monument Extended, pagas, além de Inter Black, Archivo Black e Roboto Flex), `bodyFont` `Archivo` (mesma família, com regular e negrito), `titleTracking` `"-0.05em"`, `radius` `0`.
- Se o dono tem cor de marca, ela entra em `primary` (e no `primary` do bloco `dark`, no Terminal) no lugar do vermelho, com `primaryFg` que dê contraste sobre ela.

Fontes pelo nome exato do catálogo do Google Fonts: nome errado não dá erro, o app sai na fonte do sistema.

Anote em `DECISOES.md`, seção Marca: "Estilo visual: Brutalista, versão Papel e tinta" (ou "versão Terminal"), a paleta, as fontes, o raio 0 e se as fotos terão retícula.

## O plano

Escreva o plano e mostre ao dono antes de codar. Em "Visão geral", a linha "Estilo: Brutalista, versão Papel e tinta" (ou Terminal) e o tom "brutalista industrial, técnico, cantos retos, um vermelho de alerta". Suposição, com alternativa: "Usei o estilo brutalista na versão X; cores e fontes podem ser trocadas depois, é só pedir que eu mudo o tema."

Se o app for de uso diário (painel, estoque, frota), escreva que a tela inicial abre na tarefa, com o estado e as ações, sem herói de slogan, e que o estilo mora na densidade: tabelas mono, números grandes na fonte de título do tema (`font-display`), divisórias de 2px.

Todos estes itens entram na **lista de conferência** do plano:

- Nenhum `rounded-` diferente de `rounded-none` nas telas; nenhum `shadow-`; nenhum `bg-gradient-*`, `bg-linear-*`, `from-`, `to-` nem `backdrop-blur`; as únicas funções `gradient` são as listras de `repeating-linear-gradient` e os pontos de `radial-gradient` da retícula.
- `bg-primary`, `text-primary-text`, `border-primary` e `decoration-primary` aparecem só em botão principal, divisória grossa, riscado ou dado vital.
- O título macro de cada página pública usa `uppercase`, `leading-[0.9]`, `tracking-[-0.05em]` e `text-[clamp(1.875rem,10vw,15rem)]`.
- Navegação, metadados, códigos e rótulos usam `font-mono uppercase tracking-[0.08em]` em 11 a 14px.
- Zonas separadas por `border-foreground` de 1 ou 2px ou por grade `gap-px` sobre `bg-foreground`.
- Dados técnicos usam tags semânticas (`<dl>` ou `DescriptionList`, `<data>`, `<samp>`, `<kbd>`, `<output>`).
- Existe uma camada de ruído fixa com `pointer-events-none` (e, no Terminal, uma de linhas de tela).
- Nenhuma seção muda de fundo claro para escuro ou o contrário; o vermelho é a única cor além do preto e do fundo (visual).
- Se houver fotos com retícula: as fotos decorativas aparecem em preto e branco com retícula de pontos (visual).
- O `theme` do `fab.config.json` tem os valores da versão escolhida (no Terminal, também o bloco `dark`) e o `fabapp push` passou sem erro.

O dono aprova o plano antes da construção.

## A construção: como aplicar, peça por peça

Primeiro o `theme` no `fab.config.json` e `fabapp push`; depois o código.

### Tipografia na prática
- Escreva `src/app-typography.css` inteiro (se ainda não existir), com as regras dentro de `@layer base`: `h1, h2 { font-family: var(--font-display); text-transform: uppercase; letter-spacing: -0.05em; line-height: 0.9; }`. Nunca escreva nome de fonte nem `@import` de fonte.
- Título macro de página: `<h1 className="font-display uppercase text-[clamp(1.875rem,10vw,15rem)] leading-[0.9] tracking-[-0.05em] [overflow-wrap:anywhere]">`. O `clamp` é só para o macro.
- Rótulo micro: `<span className="font-mono text-[11px] sm:text-xs uppercase tracking-[0.08em] leading-[1.3] text-muted-foreground">`.
- No modo Papel e tinta, um número ou letra gigante pode sangrar a borda da tela como elemento gráfico (`aria-hidden`, `overflow-hidden` no pai), vindo de dado real (ano de fundação que o dono informou, contagem de registros, número da seção).

### Grade e divisórias
- Divisórias finas perfeitas: pai `grid gap-px bg-foreground border border-foreground sm:grid-cols-2 lg:grid-cols-4`, filhos `bg-background p-6`. Na base, no máximo 2 colunas.
- Linha de separação de unidade: `<hr className="border-t-2 border-foreground">` em largura total do contêiner.
- Cruzes de registro nos cruzamentos da grade: `<span aria-hidden className="absolute -top-2 -left-2 font-mono text-sm">+</span>` em contêiner `relative`.

### Símbolos e decoração técnica
- Moldura ASCII em rótulos: `[ ENTREGAS ]`, `< VOLTAR >`; direcionais `>>>`, `///`, `\\` antes de links e seções.
- Marcadores `®`, `©`, `™` só como formas gráficas soltas, grandes e isoladas. Nunca colados ao nome do dono ou de um produto: ao lado de um nome eles afirmam registro de marca, e isso seria um fato inventado.
- Códigos de unidade e revisão (`REV 2.6`, `UNIDADE / D-01`, `LOTE 04`) como textura. Prefira derivar do dado real (número do pedido em `autonumber`, data de hoje, total de itens por `count`). Nunca invente número que pareça fato do negócio (clientes atendidos, anos de mercado, nota).
- Faixa de aviso: `h-3 bg-[repeating-linear-gradient(-45deg,var(--primary)_0_10px,transparent_10px_20px)]`.
- Código de barras decorativo: `h-10 w-32 bg-[repeating-linear-gradient(90deg,var(--foreground)_0_2px,transparent_2px_4px,var(--foreground)_4px_5px,transparent_5px_8px)]`.

### Botões, campos e tabelas
- Botão principal: `Button` do kit com `rounded-none uppercase font-mono tracking-[0.08em]`, fundo `bg-primary`; hover inverte (`hover:bg-foreground hover:text-background`); sem sombra.
- Secundário: `variant="outline"` com `rounded-none border-2 border-foreground`.
- Campos: `Field` do kit com `rounded-none border-foreground`; rótulo em micro mono.
- Tabela densa: `font-mono text-xs uppercase tabular-nums`, `divide-y divide-foreground`, cabeçalho com `border-b-2 border-foreground`. Número principal de painel em `font-display text-5xl tabular-nums`.

### Texturas e degradação analógica
- Ruído mecânico (os dois modos): componente com `<svg>` inline de `feTurbulence` numa camada `pointer-events-none fixed inset-0 z-40 opacity-[0.05] mix-blend-multiply` (no Terminal, `mix-blend-screen`). Uma camada só, no layout.
- Linhas de tela (só Terminal): camada `pointer-events-none fixed inset-0 z-40 bg-[repeating-linear-gradient(0deg,transparent,transparent_2px,rgba(0,0,0,0.1)_2px,rgba(0,0,0,0.1)_4px)]`.
- Brilho de fósforo (só Terminal), em um elemento de destaque: `[text-shadow:0_0_8px_currentColor]`.
- Retícula nas fotos (se o dono aceitou): `<div className="relative">` com `<AppImage ... className="grayscale contrast-125 rounded-none"/>` e por cima `<div aria-hidden className="pointer-events-none absolute inset-0 mix-blend-multiply bg-[radial-gradient(var(--foreground)_1px,transparent_1.5px)] bg-[size:4px_4px] opacity-40"/>`. No `prompt` da imagem, peça "high-contrast black and white photo, halftone print look".
- Pontilhado de 1 bit: no `prompt`, "1-bit dithered black and white image of <cena>".

### Tags semânticas
- `<dl>` (ou `DescriptionList` do kit) para pares rótulo e valor, `<data value>` para números, `<samp>` para saída de sistema, `<kbd>` para teclas, `<output>` para resultado calculado na tela.

### Movimento (mecânico e curto)
A original não define movimento; a decisão Fabapp é movimento seco, sem mola:
- Entrada por scroll com `<Reveal className="duration-300 ease-linear">` nos blocos principais do site; fileiras com `delay={Math.min(i,6)*40}`.
- Painel ao vivo: `Marquee` só para faixa de dados reais (últimos pedidos, status); `Counter` para número real.
- Nada de `animation-timeline`, nada de parallax suave, nada de hover que levanta cartão.

### Imagens
- Tipografia é a estrutura; imagem é secundária. Poucas imagens, em molduras de proporção fixa (`aspect-[4/3]`, `aspect-square`) com `border-2 border-foreground rounded-none`.
- Nada de `<img>` com URL externa: decorativa é `<AppImage slot prompt>`, uma por linha e nunca dentro de `.map()` (o dono troca ou gera cada slot no Studio, e a troca grava o `src` na tag pela linha); de dado vem do registro.

## Conferir antes de dizer pronto

Rode `fabapp dev`, abra a pré-visualização e percorra cada item da lista de conferência do plano, no celular e no desktop. Confira no código, por busca (`grep` em `.fabapp/workspace/src`), e relate só o que conferiu:

1. Busca por `rounded-` (exceto `rounded-none`), `shadow-`, `bg-gradient-`, `bg-linear-`, `from-`, `to-`, `backdrop-blur`: zero. `gradient` só dentro de `repeating-linear-gradient` (listras) ou `radial-gradient` (pontos da retícula).
2. Um modo só em todas as telas; nenhum fundo invertido no meio.
3. Vermelho só nos quatro usos permitidos; verde de terminal em no máximo um elemento.
4. Título macro com o `clamp`, caixa alta, entrelinha e tracking do pacote; micro mono em caixa alta em toda navegação e metadado.
5. Camada de ruído (e de linhas de tela no Terminal) fixa e sem ponteiro.
6. Nenhum `®`/`™` colado a nome; nenhum número decorativo que pareça fato do negócio.
7. As regras que a plataforma impõe e o `deploy` não confere: nenhum hex nem `font-family` no código, nenhum `window.confirm`/`alert`/`prompt`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`.

Depois `fabapp push` (se o `theme` mudou) e `fabapp deploy`. `account_builds_busy` (409): espere e repita. `build_failed` (422): conserte pelo arquivo, linha e coluna da mensagem antes de tentar de novo. Confira no ar que o fundo é o do estilo (no Terminal, o preto-carvão, não o escuro padrão) e que os títulos saíram na Archivo Black.

Na mensagem final ao dono: o que foi conferido, o link, e o que ele faz no Studio (trocar ou gerar as imagens de cada slot, subir o logo).

## Mudanças depois: manter o estilo e trocar a marca do jeito certo

- Tela nova segue o mesmo modo (claro ou terminal), cantos retos, divisórias e micro mono.
- Cor, fonte e raio mudam só no `theme` do `fab.config.json` (nunca em CSS), com os nomes exatos do pacote e raio 0, seguidos de `fabapp push` e `fabapp deploy`; no Terminal, mude também o bloco `dark`. O logo o dono sobe no Studio. Se o dono pedir uma segunda cor de destaque, explique que o estilo usa uma só e ofereça trocar o vermelho pela cor dele. Atualize a seção Marca do `DECISOES.md`.
- Caixa alta, espaçamento e entrelinha dos títulos mudam em `src/app-typography.css`, uma vez para o app todo.
- Nunca mude em silêncio rotas, nomes de campos, textos que o dono escreveu, logo e textos legais (se a skill `fab-redesign-e-polimento` estiver instalada, ela traz a lista completa).
