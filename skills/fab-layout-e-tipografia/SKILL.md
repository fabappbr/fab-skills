---
name: fab-layout-e-tipografia
description: "Faz cada tela de um app ou site da Fabapp AI, construído ou editado pelo terminal (CLI @fabappai/cli), nascer com estrutura de designer: primeiro a disposição em blocos (com opções comparadas e uma escolhida), depois a hierarquia por tamanho, peso e contraste, uma escala fechada de espaçamento, texto de leitura confortável (16 a 18px, linhas de 45 a 75 caracteres) e só no fim a cor. Termina com uma autoavaliação de 8 perguntas e nota de 0 a 10. Use quando o dono disser: \"tá bagunçado\", \"tá tudo apertado\", \"tá tudo espalhado\", \"não sei pra onde olhar\", \"letra pequena\", \"letra grande demais\", \"texto cansa\", \"parece desalinhado\", \"organiza melhor a página\", \"muda o layout\", \"quero outra disposição\", \"melhora a tipografia\", \"mais espaço\", \"mais respiro\", \"mais compacto\", \"cabe mais coisa na tela\", \"o título não destaca\", \"os cards estão feios\", \"a tabela tá confusa\", e em qualquer app ou site novo que precise parecer profissional: landing, catálogo, painel, agenda, loja, blog, portal de cliente."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Layout e Tipografia
  edition: terminal
---

# Layout e Tipografia

Estrutura antes de estilo, para cada tela do app da Fabapp que você constrói ou edita pelo terminal.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Uma tela bem resolvida funciona em cinza: se a hierarquia só aparece com cor, a hierarquia está errada. A ordem de trabalho é sempre a mesma: **blocos → hierarquia → espaço → texto → cor → profundidade → imagem**. Esta skill decide disposição, tamanhos, pesos, medidas e ritmo, por classes Tailwind e tokens do tema. Cor, fonte e raio são da marca: no terminal, quem os grava é você, em `apps/<slug>/fab.config.json → theme`, depois de propor ao dono e ele aprovar (seção "A marca no tema"). No código continuam só tokens e classes. Complementa a `fab-agencia` (direção de arte e motion de agência) e funciona sozinha.

## Números fixos (valem em todas as etapas)

**Espaçamento, só esta escala**: 4, 8, 16, 24, 32, 48, 64 px = `1, 2, 4, 6, 8, 12, 16` no Tailwind (`gap-*`, `p-*`, `space-y-*`, `py-*`). Passo intermediário de 12px (`3`) só entre dois valores da escala; 80px (`py-20`) só no topo de uma página de venda. Nada de `p-[13px]`. Se o app já segue um estilo que fixa outra escala ou outro `py-*` de seção (minimalista, premium, brutalista; anotado em `DECISOES.md`, ou a skill desse estilo instalada e em uso neste app), o estilo vence e o item correspondente desta skill sai da lista de conferência.

| Relação | Espaço |
|---|---|
| ícone e rótulo | `gap-1` a `gap-2` (4 a 8) |
| itens do mesmo grupo (linhas de uma lista, botões lado a lado) | `gap-2` a `gap-3` |
| blocos dentro de um card (título, conteúdo, rodapé) | `gap-4` a `gap-6` (16 a 24), card com `p-4 sm:p-6` |
| grupos diferentes na mesma seção | `gap-8` (32) |
| seções da página | `py-12` a `py-16` (48 a 64); estilo do app que fixar outro `py-*` vence |

**Espaço entre grupos é sempre maior que dentro do grupo.** Comece com espaço demais e tire; quase nunca se tira o suficiente.

**Tipografia, a partir do corpo**:
- Corpo de leitura `text-base` (16px) ou `text-lg` (18px); secundário `text-sm` (14px); legenda `text-xs` (12px), nunca menor. Campo de formulário com 16px no celular.
- Entrelinha do corpo 1,5 a 1,6 (`leading-normal` ou `leading-relaxed` em texto longo); títulos `leading-tight` (1,25); exibição grande `leading-none` a `leading-tight`.
- Medida de 45 a 75 caracteres: `max-w-prose` (cerca de 65) em todo parágrafo corrido; nunca texto de ponta a ponta.
- Escala de razão perto de 1,2: 12, 14, 16, 18, 20, 24, 30, 36 (`text-xs` a `text-4xl`); 48 e 60 (`text-5xl`, `text-6xl`) só no topo de página de venda ou quando o assunto da tela é um número.
- Pesos: 400 no corpo, 500 em rótulo e ênfase leve, 600 em subtítulo, 700 em título e número principal; nada abaixo de 400 em corpo.
- No máximo duas famílias, e elas são da marca: `titleFont` e `bodyFont` no `theme`. Títulos em `h1`/`h2`/`h3` já recebem a fonte de título (`font-display`) e o corpo a de texto (`font-sans`). Nunca `font-family` no código, nunca carregar fonte (nada de `@import url(fonts.googleapis...)`), nunca um `div` estilizado fingindo ser título (perde a fonte de título e a estrutura).
- Espaçamento entre letras de todos os títulos do app vai em `theme.titleTracking` (ex.: `"-0.02em"`, nunca mais apertado que `-0.04em`). Outro ajuste global de títulos (entrelinha, caixa alta) vai em `src/app-typography.css`, dentro de `@layer base`, famílias só por `var(--font-display)` e `var(--font-sans)`, nunca nome de fonte; se a plataforma recusar esse arquivo (app do modo antigo), faça pelas classes nas páginas. O resto é classe na página. `font-mono` é fixo (JetBrains Mono) e serve só para código e dado técnico.
- No máximo 3 níveis de título por página.

**Layout obrigatório da plataforma** (a skill nunca contradiz): contêiner `mx-auto max-w-* px-6`; h1 `text-3xl sm:text-4xl` (pode subir mais em tela que merece, sempre começando por esse); no máximo 2 colunas na base (celular), com as demais por breakpoint (`sm:grid-cols-2 lg:grid-cols-3`); `min-w-0` em filho de grade ou flex que contém linha larga; nenhuma largura fixa em px; linha que rola de lado com `ScrollRow`, nunca `overflow-x-auto`; modal com `DialogHeader`/`DialogBody`/`DialogFooter`.

**Grade por largura**: celular pensa em 4 colunas (na prática 1 ou 2), tablet em 8 (2 ou 3), computador em 12 (`lg:grid-cols-12` com `lg:col-span-8` + `lg:col-span-4` para conteúdo e lateral, ou 3 a 4 cards). Vão `gap-4` no celular e `gap-6` no computador. Página `max-w-5xl` ou `max-w-6xl`; texto `max-w-prose`; formulário `max-w-md` a `max-w-lg`.

**Alinhar à esquerda por padrão.** Centralizar só título curto de topo de página de venda, estado vazio, ação única e formulário curto isolado (entrar, cadastrar). Nunca centralizar parágrafo de várias linhas.

**Cor só por token**: `bg-background`, `bg-card`, `bg-muted`, `text-foreground`, `text-muted-foreground`, `border-border`, `bg-primary`, `text-primary-foreground`, `text-primary-text`, `text-destructive`. Os neutros do tema já saem tingidos pela marca; para uma superfície com tom da marca, `bg-primary/5` a `bg-primary/10`. Nada de hex, `bg-white`, `text-gray-*`. Nunca edite `src/index.css` nem `src/fab-theme.css` (são da plataforma; o segundo é reescrito pelo tema a cada build).

## A marca no tema (cor, fonte e raio)

No Studio a marca vem do briefing da IA da plataforma e da aba Marca do dono. No terminal não há briefing: você propõe, o dono aprova, você grava. O único lugar de cor, fonte e raio do app é `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`, seção 4):

- `mode`: `light`, `dark` (usa a paleta `dark`) ou `system`.
- `primary`, `primaryFg` (texto sobre o preenchimento da marca), `bg`, `card`, `text`, `accent`, `destructive`: cores em hex. Não escreva `primaryText`: a cor de texto AA da marca é derivada.
- `dark: { bg, card, text, primary }`: a paleta do escuro.
- `radius`: NÚMERO em px (100 ou mais vira pílula). Casa com o conjunto de densidade (tabela em `references/espaco-grid-e-composicao.md`): contido no Preciso, macio no Acolhedor.
- `titleFont` e `bodyFont`: nome exato do catálogo do Google Fonts. Nome inexistente não dá erro: o app sai na fonte do sistema. Confira a grafia.
- `titleTracking`: espaçamento entre letras dos títulos (ex.: `"-0.02em"`).

Como fazer: `fabapp pull`, proponha ao dono a paleta, o par tipográfico (títulos e corpo, no máximo duas famílias, nada de fonte engraçadinha, manuscrita ou monoespaçada no corpo) e o raio, com uma linha do porquê. Pergunte com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion; sem ela, uma mensagem curta com as opções numeradas), a proposta recomendada primeiro com "(Recomendado)". Com o sim, grave o `theme`, rode `fabapp push` e anote em `DECISOES.md`, seção **Marca** (paleta, fontes, raio, modo, e o porquê). O tema só aparece no ar no próximo `fabapp deploy`. Confira o contraste da paleta escolhida (números em `references/cor-profundidade-imagem.md`): `text` sobre `bg` e sobre `card`, `primaryFg` sobre `primary`, no claro e no `dark`.

Num app que já tem marca, cor, família e raio só mudam quando forem o problema: proponha a troca ao dono com o motivo, e só grave com o sim dele. O logotipo é do dono: ele sobe no Studio.

## A conversa

- O objetivo da tela se lê no pedido ("mais contatos", "menos gente desistindo", "tá confuso"); sem direção, use o objetivo natural da tela (`references/wireframe-em-blocos.md`). Num app novo, não pergunte a disposição: escolha e mostre no plano.
- Marca ainda não decidida (sem `theme` próprio e sem seção Marca em `DECISOES.md`): faça a pergunta da seção "A marca no tema" antes do plano.
- Na mudança de layout sem direção do dono, a pergunta de estruturas está em "Mudanças depois".

## O plano: o wireframe em blocos

Antes de codar, escreva o plano e mostre ao dono; ele aprova antes da construção. Antes de qualquer decisão de estilo, para cada tela principal (até 5), escreva na parte de Telas:

1. **Tipo da tela**: Vender (página pública, landing, vitrine), Operar (painel, agenda, cadastros, tudo depois do login) ou Ler (blog, ajuda, política). Página de venda pede expressão e respiro; tela de operar pede densidade certa e consistência; nunca levar o herói da landing para dentro do app.
2. **O elemento dominante** (UM por tela: o catálogo, os próximos horários, o saldo, a busca) e **a ação principal**.
3. **Opções de disposição**: pense em 2 ou 3. A Opção 1 é a segura (o padrão do nicho ou das telas que o app já tem); as outras seguem filosofias diferentes da lista de `references/wireframe-em-blocos.md`. Escolha uma pelo objetivo da tela (mais contato, menos desistência, mais tempo lendo, achar fácil) e registre a escolhida em blocos, de cima para baixo, no formato de `references/wireframe-em-blocos.md`, com uma linha dizendo por que ganhou. As descartadas ficam em uma linha cada.
4. **O sistema da tela**: corpo 16 ou 18, conjunto de densidade (Acolhedor ou Preciso, tabela em `references/espaco-grid-e-composicao.md`) e um só conjunto de cantos (o raio base é o `theme.radius`; as classes usam só os degraus do conjunto escolhido).

O plano traz também a marca proposta (as chaves do `theme` que você vai gravar), as suposições com alternativa e o que não entra.

Cada decisão conferível vira item da **lista de conferência** do plano, todos os que se aplicam, sem teto. Adote estes, adaptando o texto à tela:
- "Cada tela tem um elemento dominante e uma única ação com `bg-primary`"
- "Espaçamento só na escala 1, 2, 4, 6, 8, 12, 16 do Tailwind; seções com `py-12` a `py-16`" (quando o estilo do app fixar outra escala ou outro `py-*`, ele vence e este item sai)
- "Todo parágrafo corrido limitado a `max-w-prose`; corpo em `text-base` ou `text-lg`"
- "Títulos são `h1`/`h2`/`h3` em ordem, no máximo 3 níveis; h1 `text-3xl sm:text-4xl`"
- "Texto alinhado à esquerda, exceto topo de venda, estado vazio e formulário curto"
- "A disposição de [tela] segue os blocos do plano na ordem descrita"
- "Em 375px nada rola de lado e a grade tem no máximo 2 colunas"
- "Números em coluna com `tabular-nums` e alinhados à direita nas tabelas"
- "O `theme` tem as fontes, o raio e a paleta aprovados, com nomes de fonte exatos do Google Fonts, e nenhum hex nem `font-family` no código"

## A construção: a ordem de cada tela

Ordem da construção: definição primeiro (o `theme` aprovado, com `fabapp push`), depois o código em `.fabapp/workspace/src/`.

1. **Blocos em cinza.** Monte a tela na ordem do wireframe do plano só com tokens neutros (`bg-background`, `bg-card`, `bg-muted`, `text-foreground`, `text-muted-foreground`, `border-border`). Nenhum `bg-primary` ainda.
2. **Hierarquia por tamanho, peso e contraste.** Três alavancas: tamanho (grande, base, pequeno), peso (700, 500, 400), cor do texto (`text-foreground`, `text-muted-foreground`). Combine, não multiplique: o principal é grande OU negrito OU escuro; os três juntos só no elemento mais importante da tela. Rótulo é secundário e o valor é o principal: rótulo `text-sm text-muted-foreground`, valor `text-base font-medium` ou maior. Número assunto da tela: `text-3xl font-bold tabular-nums` com o rótulo pequeno. Hierarquia nunca esconde o que o cliente precisa para decidir (preço, condição, como cancelar). Botões: principal cheio, secundário `variant="outline"` ou `"secondary"`, terciário `variant="ghost"` ou link. Ação destrutiva de rotina não precisa gritar em vermelho: vermelho no botão de confirmação do `ConfirmDialog`.
3. **Espaço** pela tabela de relações. Um grupo se reconhece pela proximidade antes de ganhar caixa; card só quando a separação precisa de superfície.
4. **Texto de leitura**: corpo, entrelinha e medida dos números fixos; regras de `references/tipografia.md` (títulos com mais espaço acima que abaixo, negrito OU itálico, caixa alta só em rótulo curto com `tracking-wide`, caracteres certos do português).
5. **Cor de ação**: agora sim `bg-primary` na ação principal, na seleção atual e em estados; `text-primary-text` em links e destaques de texto, com parcimônia. Toda cor tem um trabalho; cor sem trabalho sai.
6. **Profundidade**: `shadow-sm` é o teto para card; sombra maior só no que flutua (menu, diálogo, que o kit já resolve). Profundidade sem sombra: `bg-card` sobre `bg-muted`, borda `border-border` fina, um elemento sobrepondo outro.
7. **Imagens**: decorativa com `<AppImage slot prompt alt>`, uma por linha e nunca dentro de `.map()`; de dado vinda do registro; proporção reservada e recorte com `object-cover`; texto sobre foto com véu. O CLI não gera imagem: o dono troca ou gera cada slot no Studio. Detalhes em `references/cor-profundidade-imagem.md`.

Os detalhes de grade, formulário, tabela, painel, raio e densidade estão em `references/espaco-grid-e-composicao.md`: aplique as tabelas de lá.

## Conferir antes de dizer pronto

1. **Autoverificação.** Responda o diagnóstico de 8 perguntas (abaixo) para cada tela construída, lendo o próprio código. Nota = acertos ÷ 8 × 10, arredondada. Abaixo de 10, corrija tudo o que falhou numa leva só, confira mais uma vez no máximo e pare.
2. **Na pré-visualização.** Com `fabapp dev` rodando, abra cada rota em 375px e no computador: a disposição segue os blocos do plano, nada rola de lado, a grade tem no máximo 2 colunas no celular, a hierarquia se lê com a vista embaçada. Percorra cada item da lista de conferência (rota, elemento, estado).
3. **Por busca no código** (`grep` em `.fabapp/workspace/src`), zero ocorrência de: hex e neutro fixo (`#[0-9a-fA-F]{3,8}`, `bg-white`, `text-gray-`), `font-family`, espaçamento arbitrário (`p-[`, `gap-[`, `m-[`), `window.confirm`, `alert(`, `prompt(`, `animation-timeline`, `<img` com URL externa, `import(`. E nenhuma edição em `index.css` ou `fab-theme.css`.
4. **Definição e deploy.** `fabapp push` (confira a saída) e `fabapp deploy`. `account_builds_busy` (409): espere e repita. `build_failed` (422): não repita; conserte pelo arquivo, linha e coluna da mensagem.
5. **Mensagem final ao dono**: só o que foi conferido, a nota final do diagnóstico e o que ainda ficou abaixo (sem inventar teste que não foi feito), o link, e a lista do que ele faz no Studio (subir o logotipo, trocar ou gerar cada slot de imagem; depois das trocas, você publica o que é seu e roda `fabapp dev --reset` antes de editar de novo).

## Mudanças depois

Leia `DECISOES.md` e os arquivos da tela antes de mudar.

**Quando o dono pede outro layout** sem dizer qual ("muda o layout da página inicial", "quero outra disposição"): antes de codar, pergunte com a ferramenta de perguntas de opção (no Claude Code, AskUserQuestion; sem ela, opções numeradas) 2 ou 3 estruturas descritas em palavras simples, a segura primeiro e recomendada. Exemplo para a página inicial de um salão:
- Manter a ordem e só organizar melhor os espaços (Recomendado)
- Abrir com os serviços e preços logo no topo, foto menor
- Abrir com os próximos horários livres para agendar direto

**Quando pede só o visual** ("só deixa mais bonito", "sem mudar o lugar das coisas"): a estrutura fica travada. Muda só hierarquia, espaço, pesos e profundidade; blocos, ordem e conteúdo continuam.

**Quando muda a estrutura**: o conteúdo, os textos, as rotas e os rótulos do menu continuam os mesmos; muda a disposição.

**Quando o problema é a fonte, a cor ou o raio**: proponha a troca no `theme` (seção "A marca no tema"), grave só com o sim, `fabapp push`, anote em `DECISOES.md` e publique com `fabapp deploy`.

Queixas comuns e o conserto:

| O dono diz | Causa provável | Conserto |
|---|---|---|
| "tá bagunçado", "não sei pra onde olhar" | tudo com o mesmo peso; espaço igual em todo lugar | um elemento dominante; espaço entre grupos maior que dentro; rótulos rebaixados |
| "tá apertado" | falta de respiro | subir um degrau da escala entre grupos e seções; card `p-6` |
| "tá espalhado", "cabe pouco" | espaço de venda numa tela de operar | conjunto Preciso: `gap-2`, `p-4`, linhas de 40 a 44px |
| "letra pequena", "cansa ler" | corpo em `text-sm`, linha larga, entrelinha curta | corpo `text-base`/`text-lg`, `max-w-prose`, `leading-relaxed` |
| "o título não destaca" | título e corpo com o mesmo peso | título um degrau acima e `font-bold`, corpo `text-muted-foreground` onde é apoio |
| "tá desalinhado" | centralizado misturado com esquerda; botões em alturas diferentes | alinhar à esquerda; `flex flex-col` + `mt-auto` no botão dos cards |
| "cara de amador" | pouco espaço, largura sem limite, cor fazendo o trabalho da hierarquia | refazer na ordem da construção a partir do passo 2 |
| "sem profundidade", "chapado" | nenhuma diferença entre superfícies | `bg-card` sobre `bg-muted`, `shadow-sm` no que se destaca, `border-b` entre seções |
| "as cores brigam" | cor de destaque espalhada | cor só na ação, na seleção e no estado; o resto nos neutros do tema |
| "o botão não aparece" | ação principal com pouco contraste com a vizinhança | uma só ação cheia na área, as outras `outline` ou `ghost` |

Aplique o mesmo diagnóstico de 8 perguntas antes e depois; diga as duas notas na mensagem final. Preferência duradoura que o dono revelar ("sempre mais compacto", "nunca carrossel") vai para `DECISOES.md`, seção Preferências.

## Diagnóstico de 8 perguntas (nota 0 a 10, na construção e nas mudanças)

| # | Pergunta | Como conferir no código | Se não |
|---|---|---|---|
| 1 | A hierarquia aparece com a vista embaçada (teste do borrão)? | existe UM elemento claramente maior e mais pesado; secundários um degrau abaixo; o resto `text-muted-foreground` | aumentar o contraste entre principal e secundário |
| 2 | Funciona em cinza? | tirando `bg-primary` e `text-primary-text`, a ordem de leitura continua; cor aparece só em ação, seleção e estado | reforçar tamanho, peso e espaço |
| 3 | Tem espaço suficiente? | seções `py-12`+, grupos `gap-8`, cards `p-4`+ | subir um degrau, principalmente entre grupos |
| 4 | Rótulos abaixo dos valores? | rótulo menor ou `text-muted-foreground`, valor maior ou mais pesado | rebaixar rótulos |
| 5 | Espaço segue a escala? | só `1, 2, 4, 6, 8, 12, 16` (e `3` entre dois deles) | trocar os valores soltos |
| 6 | Texto com largura limitada? | parágrafos com `max-w-prose` | limitar a ~65 caracteres |
| 7 | Contraste suficiente? | texto principal `text-foreground`; `text-muted-foreground` só em apoio; nada de opacidade baixa em texto que precisa ser lido | subir para o token mais forte |
| 8 | Sombras combinam com a altura? | card no máximo `shadow-sm`; sombra grande só no que flutua | ajustar à escala |

10 = as 8 passam (hierarquia lê embaçada e em cinza, todo valor na escala); 9 = uma lacuna (em geral hierarquia fraca ou pouco espaço); 6 a 8 = duas ou três; 5 ou menos = quatro ou mais (espaço arbitrário, cor fazendo o papel da hierarquia ou contraste ruim). Sempre diga a nota e as linhas a corrigir para chegar a 10.
