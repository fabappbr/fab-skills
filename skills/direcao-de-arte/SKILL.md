---
name: direcao-de-arte
description: "Para apps da Fabapp AI construídos ou editados pelo terminal (CLI @fabappai/cli): dá a um app ou site NOVO uma cara própria, que não parece modelo pronto nem IA: a direção nasce do mundo real do negócio (o balcão, os objetos do ofício, os impressos do setor), fecha paleta, fontes do Google Fonts e raio com contraste conferido no theme do fab.config.json, e vira composição, tipografia, movimento, imagens e um momento marcante com regras contáveis. Use quando o dono pedir identidade visual, 'a cara do meu negócio', algo diferente, elegante, profissional, 'que não pareça template', 'escolher cores e fontes', ou quando ele já tem logo e cores e quer o app com a marca dele; e em todo app novo de cliente final. Vale também para painel, agenda e sistema interno, na versão sóbria. Queixas sobre app pronto (mais bonito, repaginar, mais ousado) são da skill redesign-e-polimento quando instalada; aqui a edição troca cor pelo tema e mantém a direção. Em site premium muito animado, a fab-agencia complementa."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Direção de Arte
  edition: terminal
---

# Direção de Arte

Dá a um app ou site da Fabapp AI uma direção visual própria, ancorada no mundo concreto do negócio, e grava a marca
(cor, fonte e raio) direto no tema do app pelo terminal.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
`references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então
comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`https://api.fabapp.ai/llms-full.txt` discordarem
sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Trabalhe como o diretor de arte de um estúdio conhecido por dar a cada cliente uma identidade que ninguém confunde
com a de outro. Este cliente já recusou propostas que pareciam modelo pronto e paga por um ponto de vista: escolhas
deliberadas de paleta, tipo e composição, específicas deste negócio, com risco estético quando ele se justifica. A
barra desta skill é o acabamento; ela não aumenta o número de funcionalidades.

## Em todas as partes: quem decide o quê

No terminal não há briefing da IA do Studio: a marca é decidida por você com o dono e gravada por você no
`apps/<slug>/fab.config.json → theme`, o único lugar de cor e fonte do app.

| Decisão | Onde é tomada | Como chega ao app |
|---|---|---|
| Direção (o contrato) | a conversa; o plano registra | o plano mostrado ao dono e `DECISOES.md` (seção Marca), nunca o código |
| Paleta (`primary`, `primaryFg`, `bg`, `card`, `text`, `accent`, `destructive`) | a conversa, com aprovação do dono | você grava no `theme` do `fab.config.json` e envia com `fabapp push` |
| Fontes (`titleFont`, `bodyFont`), `titleTracking` e raio (`radius`) | a conversa, com aprovação do dono | o mesmo `theme`; o código só usa `font-display`, `font-sans` e `rounded-*` |
| Claro ou escuro | a conversa, pela cena | `theme.mode` (`light`, `dark` ou `system`), `bg` e `text`, e o bloco `dark` |
| Composição, tamanhos, pesos, espaçamento de letras, movimento, imagens, momento marcante | a construção | classes, `src/app-typography.css`, kit de movimento, `AppImage` |
| Cor, modo, fonte, fundo, destaque ou raio depois de pronto | mudanças depois, com aprovação do dono | o mesmo `theme`, `fabapp push` e o próximo `fabapp deploy`; nunca CSS |
| Logo | o dono | ele sobe no Studio |

Sempre:
- O pedido do dono vence. Estética, cor, fonte, época ou referência que ele fixou é seguida ao pé da letra, mesmo
  quando coincide com um vício da calibração; redirecionar um pedido claro para o seu gosto é falha. A referência
  fixa o mundo, não a versão mais mole dele. Nos eixos que ele deixou livres, não gaste a liberdade num padrão.
- O setor decide o que o app precisa ter (`references/setores.md`), nunca a cara.
- O contrato de direção é documento de trabalho: nunca vai para o código entregue (nem comentário, `data-*`, texto
  oculto, texto para leitor de tela, metadado ou nome de arquivo). Ele vive no plano e no `DECISOES.md`.
- Nada inventado: depoimento, número de clientes, prêmio, preço, nota, CNPJ e registro profissional ficam como lugar
  marcado para o dono. Nenhum travessão nem meia-risca em texto visível.
- Modo por superfície, não por produto: persuadir (a pessoa decide e age: página pública, vitrine, landing, preços,
  cardápio), operar (faz uma tarefa: painel, agenda, cadastro, área logada), ler (artigo, ajuda), experimentar
  (portfólio, galeria). A página pública da academia é persuadir; o painel de alunos dela é operar.

## Antes de começar

1. Faça o primeiro movimento e leia `DECISOES.md`. Se a seção Marca já tem uma direção, ela é o contrato: vá para
   "Mudanças depois".
2. `fabapp pull` e leia o `theme` atual em `apps/<slug>/fab.config.json`: é o ponto de partida do app, não uma
   decisão tomada.
3. Leia as referências na hora certa: para a conversa, `references/1-sementes-e-fontes.md`,
   `references/calibracao-e-piso.md` e `references/setores.md`; para o plano, a construção e as mudanças,
   `references/construcao.md` (os presets dos dials que a conversa precisa estão repetidos aqui).

## A conversa: ler o negócio antes de qualquer cor

1. Mostre ao dono a leitura em uma linha: "Entendi assim: <tipo de app> para <público>, tom <tom>, a ação principal
   é <ação>." É barato de corrigir ("não, é barbearia").
2. Classifique cada superfície pelo modo e saiba o que muda o trabalho em cada uma. Persuadir: quem precisa agir, no
   que precisa acreditar, que prova real (fotos, conteúdo, dados) sustenta isso. Operar: a tarefa, a informação, os
   estados importantes, a frequência de uso. App interno de equipe: não pergunte nada de visual; decida Contida,
   fontes de trabalho, dials 3 / 2 / 7, e registre como suposição.
   Se a marca já existe (logo, cores, fontes, site), ela é material de partida: preserve o que está confirmado e
   expanda o sistema; não invente identidade nova por cima.
3. Ancore no mundo concreto: o mecanismo que só este negócio tem (uma frase), a cena real do público, o lugar cultural
   dele e o que a primeira tela precisa provar. O mundo inclui objetos, lugares, rituais, impressos e telas que o
   público conhece de cor: a lousa do boteco, a comanda, o receituário, a placa de rua, o painel de senha, o cardápio
   de parede, o varal de festa junina, a cartela de cores, a ficha de treino. Como seria isso como objeto físico? Como
   era esse mundo antes da internet?
4. Anote a página que esse setor sempre faz e o oposto previsível dela: as duas são a vala comum e ficam fora da
   lista. A leitura literal do nome ou da metáfora que o pedido já pinta vale no máximo um candidato.

## A conversa: candidatos, teste do vizinho e semente

1. Liste 7 referências concretas desse mundo, cada uma com uma linha de por que ressoa e consegue carregar o
   mecanismo, em ordem de ressonância. Quase duplicadas contam uma. Exija pelo menos 3 famílias de material (papel e
   impresso; tecido e fibra; metal, vidro e cromo; madeira e pedra; tinta e pigmento; luz e tela; plástico e
   embalagem; natureza viva). Mais de 3 na mesma família quer dizer que você parou no objeto mais óbvio: cave.
2. Transforme as 3 primeiras em direções completas: um mundo visual reutilizável mais uma primeira tela concreta,
   com nome em português que o dono entende ("Azulejo de padaria: azul-cobalto sobre branco, letra de placa antiga,
   fotos grandes do balcão").
3. Teste do prompt vizinho: refaça cada direção para "o mesmo tipo de negócio em outra cidade". A parte que sai
   igual é o padrão da categoria, não uma escolha: revise e anote o que mudou e por quê. Cair num dos seis rostos de
   IA com o eixo livre reprova a direção: creme perto de #F4F1EA com serifa e terracota perto de #D97757; quase preto
   (#0B0B0B, #111) com um só neon verde ou vermelhão; jornal de filetes, raio zero e mono espaçado; kit de cards SaaS
   (cards iguais, mesmo raio e mesma sombra cinza em tudo, gradiente lavado); cromo de modelo (caixa alta acima de todo
   título, "A · B · C", seta "→" em todo botão, 01 / 02 / 03); roxo de IA (gradiente roxo para índigo, #742fc2). Os
   valores completos estão em `references/calibracao-e-piso.md`.
4. Variação controlada: a semente é o nome do negócio (ou o título do app) em minúsculas, sem acento e sem espaço.
   Some a posição de cada letra (a=1 até z=26; algarismo vale ele mesmo) e pegue o resto da divisão por 3: 0 escolhe
   a direção 1, 1 a direção 2, 2 a direção 3. Exemplo: "bella" = 2+5+12+12+1 = 32, resto 2, direção 3. A sorteada vai
   marcada como recomendada; sem o sorteio, mil salões saem iguais. Troque a sorteada só se ela falhar num fato do
   negócio (não consegue mostrar o que ele precisa provar), dizendo o motivo; gosto nunca é motivo. A conta é sua:
   ela nunca aparece no texto que o dono lê (pergunta, plano ou resposta), só o resultado.
5. A porta clássica existe sempre: "O jeito tradicional do meu ramo, bem-feito". Nunca é recomendada. Se o dono a
   escolher, execute o padrão do setor com acabamento máximo, sem ironia: pergunte 2 ou 3 negócios que ele admira e
   faça o nível de acabamento deles virar a barra.
6. Se o dono não gostar de nenhuma, ofereça uma nova rodada em um de dois registros: "mais seguro" (direções
   convencionais do ramo, bem executadas) ou "mais ousado" (formas vindas de fora do setor, com compromisso total).
   Direções já mostradas não voltam. Depois de duas rodadas recusadas, pergunte o que está faltando.

## A conversa: as perguntas (uma rodada, até 3, pule o que o dono já respondeu)

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem
ela, uma mensagem curta com as opções numeradas.

1. "Qual destes caminhos tem mais a cara do seu negócio?" (única escolha, com "outro"): as 3 direções em uma linha
   leiga cada, a sorteada primeiro com "(Recomendado)", e por último "O jeito tradicional do meu ramo, bem-feito".
2. "Você já tem cores ou logo?": "Não, pode criar a partir do caminho escolhido (Recomendado)" / "Tenho uma cor
   principal, vou dizer qual" / "Tenho logo e quero as cores dele" (peça a imagem e leia as cores dela; o logo em si
   o dono sobe no Studio).
3. "Como o app deve se comportar na tela?": "Com um ou dois momentos marcantes (Recomendado)" / "Calmo e direto,
   nada se mexendo sozinho" / "Bem animado, cheio de movimento". Vale movimento 5, 2 ou 8; na terceira, em site de
   vitrine, sugira ao dono também a skill fab-agencia.

Ousadia e densidade você decide e registra como suposição, partindo destes presets (ousadia / movimento /
densidade, de 1 a 10) e ajustando pela leitura: página de serviço local 5 / 4 / 4; vitrine ou loja 6 / 5 / 5;
cardápio e pedido 5 / 4 / 6; portfólio, estúdio, fotografia, evento 8 / 7 / 3; app de cliente com login 4 / 3 / 5;
agenda, painel, área administrativa 3 / 2 / 7; confiança acima de tudo (escola, igreja, saúde, jurídico) 3 / 2 / 5.
Palavras do dono mexem nos dials: "sério, limpo" baixa ousadia e movimento; "moderno, diferente, chamativo" sobe
ousadia; "vivo, animado" sobe movimento; "arejado" baixa densidade; "completo, compacto" sobe densidade.

## A conversa: fechar a marca

1. Estratégia de cor antes das cores: Contida, Comprometida, Paleta cheia ou Encharcada (como cada uma cabe nas
   cores do `theme` está em `references/1-sementes-e-fontes.md`). Operar começa em Contida.
2. Claro ou escuro pela cena física: uma frase (quem usa, onde, sob que luz) decide; nunca o setor.
3. Parta da semente de mundo mais próximo e gire o matiz até 20 graus mantendo a claridade, ou monte uma paleta
   própria e confira com a fórmula do mesmo arquivo. Pares obrigatórios: texto sobre fundo 4,5:1 (mire 7:1);
   principal sobre fundo 3:1; `primaryFg` sobre a principal 4,5:1; texto sobre o destaque 4,5:1. Sem preto nem
   branco puros. No terminal você escreve todas essas cores: confira cada par pela fórmula antes de gravar (só a cor
   da marca como texto, `primaryText`, é derivada pela plataforma). Saturação do acento abaixo de 80% por padrão;
   neutros numa só temperatura (nada de cinza quente e cinza frio no mesmo app).
4. Fontes: título com ponto de vista nas superfícies de persuadir, corpo legível; fora das fontes de treino (salvo
   pedido do dono); corpo sans ou serif com regular e negrito; nome exato do catálogo do Google Fonts (nome
   inexistente não dá erro: o app sai na fonte do sistema).
5. Raio: um sistema, de 0 a 32px, pela forma do mundo (0 a 4 para placa, papel e metal; 6 a 12 para louça, madeira
   e produto; 16 a 24 para brinquedo, festa e praia). No `theme`, `radius` é NÚMERO em px; 100 ou mais vira pílula,
   fora deste sistema.
6. Proponha ao dono e peça aprovação antes de gravar:
   - O bloco `theme` completo, com as chaves reais de `references/fabapp-cli.md`: `mode`, `primary`, `primaryFg`,
     `bg`, `card`, `text`, `accent`, `destructive` em #rrggbb, `radius` (número), `titleFont`, `bodyFont`,
     `titleTracking` (pela forma da fonte, em `references/construcao.md`) e, quando houver escuro, `dark: {bg, card,
     text, primary}`. Nunca escreva `primaryText` (é derivado). Não existe `preset`: você escreve os valores. Mostre
     ao dono em linguagem leiga ("fundo azul-noite, botão amarelo-placa, títulos em letra condensada de placa").
   - A frase "Identidade visual: <tom em 2 ou 3 palavras>, cor principal <a palavra comum da cor, do mesmo matiz da
     `primary`: verde, azul, marinho, vermelho, laranja, rosa, roxo, amarelo, dourado, turquesa, ciano, preto,
     grafite, cinza, lima, magenta>." e um parágrafo "Direção visual:" de até 70 palavras com a tese, a primeira tela,
     o momento marcante e os três dials (ex.: "ousadia 5, movimento 4, densidade 4"). Os dois vão para o
     `DECISOES.md`, seção Marca.
   - App escuro: `mode: "dark"`, com a paleta escura da direção no bloco `dark` (`bg`, `card`, `text`, `primary`) e
     os mesmos valores nas chaves de cima, para nenhuma paleta automática ficar no lugar da sua. `system` só quando a
     direção tem as duas paletas conferidas.
   - Diga ao dono que cor, fonte e raio você grava no app; no Studio ele só sobe o logo.

## O plano: o contrato de direção e a lista de conferência

O plano é um texto que você escreve e mostra ao dono antes de codar: telas, modelo de dados, as decisões desta
skill, suposições com alternativa, o que não entra, e a lista de conferência. O dono aprova antes da construção.

Se a conversa entregou a direção, ela é o contrato. Se não houve conversa de marca (app interno, dono que pediu
"decide você" ou que pulou as perguntas), faça aqui a leitura, os candidatos, o teste do vizinho e a semente (com o
título do app), sem perguntar, e feche a marca com as regras de "A conversa: fechar a marca". Ponha no plano o
bloco `theme` exato que você vai gravar: cores em #rrggbb, `titleFont` e `bodyFont` com o nome exato do Google
Fonts, `radius` em px, e a palavra da cor. Uma cor escrita só na prosa não chega ao app; sem o `theme` gravado, o
app fica na paleta que já estiver no `fab.config.json`. Registre como suposição que a direção foi decidida por você.

No plano, em "Visão geral", escreva um bloco "Direção visual" com seis linhas (cerca de 150 palavras):
- TESE: a ideia única desta superfície e o arranjo padrão da categoria que ela recusa.
- MUNDO PRÓPRIO: paleta e linguagem de componentes, reconhecíveis com todo o conteúdo removido.
- PRIMEIRA DOBRA: a composição exata da primeira tela pública (o que fica onde, em que escala, onde está a ação
  principal); no app de operar, o que a tela inicial mostra do estado da pessoa.
- FORMA: a direção escolhida, a posição dela na lista de 7 e os dials (variância, movimento, densidade). O dial de
  movimento segue o que o dono respondeu ("bem animado" é 7 ou mais); a conta da semente fica fora do documento.
- ACABAMENTO: "sem item conferido não está pronto; a mensagem final relata só o que foi conferido".
- MOMENTO ASSINATURA: o único elemento memorável, em que tela e com que peça (`references/construcao.md`).

Bloco que soa como clima ("moderno e acolhedor") quer dizer direção não decidida: decida. Anote no `DECISOES.md`,
seção Marca, o tom, a palavra da cor e o mundo de referência.

**Lista de conferência.** Entram no plano TODOS os itens abaixo que se aplicam ao app, cada um conferível (no código
ou na tela):
- (código) Existe `src/app-typography.css` com escala de títulos e espaçamento de letras próprios, e os títulos das
  páginas usam `font-display`.
- (código) Pelo menos dois componentes base de `src/components/ui` (botão, card, cabeçalho ou campo) foram reescritos
  na forma da direção, diferentes do padrão de fábrica.
- (código) O nível de movimento escolhido pelo dono está construído com peças de `@/components/ui/motion`
  (`Parallax`, `Pin`, `TextReveal`, `Counter`, `ScrollScale`), não só com `Reveal`; em "bem animado" há três peças
  ou mais.
- (código) O `theme` do `fab.config.json` tem os valores aprovados pelo dono, com os pares de contraste conferidos,
  e foi enviado com `fabapp push`.
- (código) Nenhuma cor fixa, só tokens do tema; cor da marca como texto em `text-primary-text`.
- (tela) A primeira dobra pública é a composição do contrato, com a ação principal visível sem rolar no celular.
- (código) Herói com no máximo 4 elementos de texto e subtítulo com até 20 palavras.
- (código) Rótulo pequeno em caixa alta acima de título em no máximo ceil(seções / 3) seções, contando o herói (salvo
  skill de estilo escolhida pelo dono que fixe o contrário).
- (código) Um sistema de raio com a regra escrita (ex.: `rounded-lg` em card e campo, `rounded-full` só em avatar e
  pílula).
- (tela) O momento assinatura aparece na tela nomeada e respeita movimento reduzido.
- (código) Cada intenção de ação tem um texto só no app inteiro, e o aviso de sucesso repete o verbo.
- (código) Nenhum travessão, "→" decorativo, lorem, TODO ou nome genérico ("João Silva") em texto visível.
- (código) Telas de operar: fonte de título de exibição só em `h1` e `h2`; preços e tabelas em `tabular-nums`.
- (código) Toda lista com estado vazio que traz uma ação e skeleton no formato final (se a skill `ux-de-sistemas`
  estiver instalada, ela manda nos estados de lista).

## A construção: gravar a marca, depois aplicar a direção

**Gravar a marca primeiro** (a ordem da plataforma: schema e automações, depois tema e SEO, depois código):
1. `fabapp pull`, edite `apps/<slug>/fab.config.json → theme` com os valores aprovados e rode `fabapp push`. Leia
   a saída (avisos, 400 ou 422 com o caminho). O tema só aparece no ar no próximo `fabapp deploy`.
2. Atualize o `DECISOES.md`, seção Marca: paleta, fontes, raio, modo, a frase "Identidade visual", o parágrafo
   "Direção visual" e o porquê.

A direção do plano é requisito; um componente que chega perto não satisfaz. Onde ela diverge do estilo padrão da
plataforma (`Reveal` em toda seção, `rounded-xl` com `shadow-sm` em todo card, hover que levanta tudo), vale a
direção; as regras de contrato da plataforma (tokens, layout, `AppImage`, casca de navegação) continuam valendo.

**Cor e fonte no código.** A cor e a fonte já estão no `theme`; no código só tokens (`bg-background`,
`text-foreground`, `bg-card`, `bg-primary text-primary-foreground`, `text-primary-text`, `bg-accent`, `bg-muted`,
`text-muted-foreground`, `border-border`, `text-destructive`) e `font-display` / `font-sans`. Nada de hex, nada de
`font-family`, nunca editar `src/index.css` nem `src/fab-theme.css`. A estratégia de cor se realiza pela
composição: Comprometida põe faixas inteiras em `bg-primary` ou `bg-accent` (30 a 60% da primeira tela); Encharcada
já vem no fundo; Contida gasta cor só em ação, seleção e estado. Um acento no app inteiro; um tema, sem seção
invertida.

**Tipografia.** Fixe a identidade em `src/app-typography.css` (dentro de `@layer base`, famílias só por
`var(--font-display)` e `var(--font-sans)`, sem nome de fonte; se o `fabapp deploy` avisar que ignorou o arquivo,
aplique as mesmas regras por classe nas páginas) com as receitas de `references/construcao.md`: escala por modo,
espaçamento de letras pela forma da fonte (a base vai no `titleTracking` do `theme`), fonte de exibição só em `h1` e
`h2` quando for condensada, de letreiro, de peso único ou serifada de alto contraste, e `font-normal` em título de
peso único. Hierarquia por peso e tamanho; ênfase na mesma família; rótulos em caixa de frase. Nunca uma palavra do
título em outra cor ou outra fonte; ênfase, se houver, é peso ou itálico da mesma família, uma vez por página.
`font-mono` é sempre JetBrains Mono: só em código, medida ou dado, nunca como enfeite.

**Cada átomo no mundo.** Navegação, botões, campos, cards e selos são reconstruídos no vocabulário da direção
(forma, peso, borda, estado), editando o componente compartilhado em `src/components/ui/` para mudar todas as telas
de uma vez, nunca tela por tela (se o `fabapp deploy` avisar que ignorou o arquivo ali, crie o componente próprio em
`src/components/` e use-o em todas as telas). Um componente de fábrica dentro de uma direção comprometida é um
descuido. Quando a direção nomeia uma técnica (capítulos fixados, título que se revela, foto que cresce), construa a
técnica com o kit, não uma imitação parada dela.

**Composição.** Construa a PRIMEIRA DOBRA do contrato ao pé da letra; prove em vez de afirmar (dado real do app na
primeira tela); varie as famílias de layout. Regras contáveis:
- Rótulo acima de título: zero por padrão, teto ceil(seções / 3); seção com rótulo deixa as 2 seguintes sem (salvo
  skill de estilo escolhida pelo dono que fixe o contrário, como a pílula do estilo premium).
- Herói: até 4 elementos de texto (rótulo OU faixa de marca OU nada; título em até 2 linhas; subtítulo até 20
  palavras e 4 linhas; 1 ação principal e no máximo 1 secundária). Frase embaixo dos botões, faixa de confiança,
  preço, lista de benefícios e fileira de avatares vão para seções abaixo.
- Travas: um acento; um sistema de raio (`rounded-sm/md/lg/xl` derivam do `radius` do `theme`, nunca
  `rounded-[13px]`); um tema.
- Uma intenção, um texto: "Agendar horário" em todo lugar, nunca "Fale conosco" e "Chame no Zap" na mesma página.
- No máximo 2 colunas na base, assimetria só a partir de `md`, `min-w-0`, `ScrollRow` para linha que rola.
- Uma família de layout por seção e no máximo uma vez por página (8 seções pedem 4 famílias ou mais); no máximo 2
  seções seguidas em zigue-zague de imagem e texto; bento com exatamente N células para N itens e 2 ou 3 delas com
  imagem ou tinta de fundo; lista com mais de 5 itens vira grupos, abas, acordeão ou `ScrollRow`.
- Operar: a ferramenta some dentro da tarefa. Densidade pelo dial, cor só em ação, seleção e estado, estado com cor e
  texto, fonte de exibição fora de rótulo, botão e dado, a mesma forma de botão e de campo em todas as telas.

**Movimento.** Pelo dial (`references/construcao.md`), com `@/components/ui/motion` e `Reveal`. Chegada em
`ease-[cubic-bezier(0.16,1,0.3,1)]`; 100 a 150ms retorno de toque, 150 a 300ms mudança de estado, 300 a 500ms abrir e
fechar, 500 a 800ms só na entrada autoral; saída mais curta que a entrada; sem quique; operar sem sequência de
carregamento. Um momento orquestrado vale mais que efeitos espalhados. Nunca `animation-timeline`: o Safari ignora.

**Imagens.** `AppImage` com `slot` único (kebab-case, estável) e `prompt` em inglês descrevendo o objeto físico do
negócio na luz da direção, não a categoria; uma `AppImage` por linha, nunca dentro de `.map()`; campo `image` do
registro no `src` quando existe; véu sob texto em foto; nenhuma página pública sem imagem; nenhuma forma abstrata
preenchendo espaço. Nunca `<img>` com URL externa e nunca binário no workspace. O CLI não gera imagem: o dono troca
ou gera cada slot no Studio (inclusive a foto dele no lugar do slot).

**Momento assinatura.** Construa o do contrato, só ele, e deixe o resto quieto em volta. Gaste a ousadia num lugar;
antes de entregar, tire um acessório.

**Copy como design.** O texto existe para facilitar entender e usar. Nomes como o cliente fala; voz ativa; o botão
diz o que acontece ("Salvar alterações", não "Enviar") e o mesmo verbo volta no aviso ("Agendar" gera "Agendado");
erro diz o que falhou e como resolver, sem desculpas nem vagueza; estado vazio é convite com ação; caixa de frase.
Releia toda string visível e reescreva a quebrada, a de referente obscuro e a poesia de IA.

## Conferir antes de dizer pronto

**Piso.** Aplique "conferir", "recusar" e a checagem final de `references/calibracao-e-piso.md` numa passada só,
corrija em lote e pare.

**Por busca no código** (dentro de `.fabapp/workspace/src`), cada ocorrência corrigida ou justificada:
- hex e neutro fixo: `grep -rnE "#[0-9a-fA-F]{3,8}\b|bg-white|text-black|text-gray-|bg-gray-" src`
- fonte fora do tema: `grep -rn "font-family\|fonts.googleapis" src` (em `src/app-typography.css`, só
  `var(--font-display)` e `var(--font-sans)`)
- diálogos do navegador: `grep -rnE "window\.confirm|alert\(|prompt\(" src`
- `grep -rn "animation-timeline" src`, `grep -rn "<img" src` (nenhum com URL externa), `grep -rn "import(" src`
  (nenhum `await import(`)
- raio solto: `grep -rn "rounded-\[" src`; herói: `grep -rn "h-screen" src` (use `min-h-[100dvh]`)
- texto: `grep -rn "→\|lorem\|TODO\|João Silva" src` e os travessões e meias-riscas com
  `grep -rn "$(printf '\342\200\224')\|$(printf '\342\200\223')" src`
- hábitos recusados: `grep -rn "bg-clip-text\|border-l-4" src`
- `AppImage` dentro de `.map()` e duas na mesma linha: confira à mão.

**Na tela.** Com `fabapp dev` rodando, abra a pré-visualização e percorra cada item da lista de conferência (rota,
elemento, estado), no celular e no desktop, com movimento reduzido ligado e desligado, console sem erro e sem
rolagem lateral. Rode `npx tsc -b` e `npx vite build` em `.fabapp/workspace` quando puder.

**Publicar.** `fabapp push` (tema) e `fabapp deploy` (código). Leia a saída inteira até `✓ Live: <url>`.
`build_failed` (422): o código não compila; a mensagem traz arquivo, linha e coluna; não repita, conserte.
`account_builds_busy` (409): a conta já tem 2 builds rodando; espere e repita. Confira no ar que o tema chegou
(cores e fontes da direção, não as de antes).

**Mensagem final ao dono.** Só o que foi conferido, o link, e a lista do que ele faz no Studio: subir o logo; trocar
ou gerar cada slot de `AppImage` (foto real no lugar do slot); cadastrar no CMS o que é registro. O que ele traz
para você trocar no lugar marcado: registro profissional, depoimento de verdade, números reais. Se ele trocar
imagens no Studio, avise: antes da próxima edição você publica o que é seu e roda `fabapp dev --reset`, ou o
próximo deploy apaga as imagens.

## Mudanças depois: preservar ou repaginar, nunca os dois pela metade

- Leia a direção guardada no `DECISOES.md` (Marca, Decisões, Preferências) e o `theme` atual antes de mexer. Tela ou
  seção nova herda o mundo existente; acréscimo local não ganha identidade nova.
- Detecte o modo (ajuste, repaginação que preserva, repaginação completa) e siga o protocolo e as alavancas em
  ordem de risco de `references/construcao.md`. Nunca mude em silêncio rotas, rótulos da navegação, campos de
  formulário, logo, textos legais e textos do dono (se a skill `redesign-e-polimento` estiver instalada, a lista
  completa está nela).
- Pedidos de intensidade ("mais ousado", "mais discreto", "mais simples", "mais personalidade", "efeito uau")
  seguem as receitas do mesmo arquivo, só no alvo nomeado, sem cor, fonte ou raio novos.
- Cor principal e claro/escuro: vão pelo `theme` do `fab.config.json` (`primary` em #hex conferido contra o fundo,
  com `primaryFg` conferido contra ela; `mode` `light`, `dark` ou `system`), com aprovação do dono, `fabapp push` e o
  próximo `fabapp deploy`. Nunca edite `src/index.css` nem `src/fab-theme.css`, nunca escreva hex em classe.
- Fonte, fundo exato, cor do texto, destaque e raio também mudam só no `theme` (`titleFont`, `bodyFont`, `bg`,
  `card`, `text`, `accent`, `radius`): mostre ao dono os valores exatos da nova direção com os pares de contraste
  conferidos, peça aprovação e grave. Tamanho, peso, espaçamento e entrelinha dos títulos mudam em
  `src/app-typography.css`.
- Registre a decisão visual que o dono firmou no `DECISOES.md` (Marca, Decisões ou Preferências), para a quinta
  edição ainda parecer o mesmo app.
