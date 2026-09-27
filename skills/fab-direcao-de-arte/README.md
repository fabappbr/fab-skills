# Direção de Arte (`fab-direcao-de-arte`)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem e editam
apps da Fabapp AI com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- **A marca é gravada pelo agente.** Tudo que na Studio ia para o `brand` do `deliver_prompt`, para `brand_color`,
  para o patch `theme` da edição (`preset`, `primary`, `mode`), para a aba Marca do dono ou para `set_brand`, aqui
  o agente propõe ao dono, pede aprovação, grava em `apps/<slug>/fab.config.json → theme` (chaves `mode`,
  `primary`, `primaryFg`, `bg`, `card`, `text`, `accent`, `destructive`, `radius`, `titleFont`, `bodyFont`,
  `titleTracking`, `dark`) e envia com `fabapp push`. Não há `preset`: o agente escreve os valores. O logo o dono
  sobe no Studio.
- **Sementes com `primaryFg`.** A tabela das 16 sementes ganhou a coluna `primaryFg`, conferida pela mesma fórmula de
  contraste (na Studio a plataforma escolhia branco ou preto). Em Poste de Barbeiro, o quase preto da semente não
  passava de 4,5:1 e foi trocado por um mais fundo.
- **Modo escuro pelo `mode`.** A regra da Studio sobre expressões como "tema escuro" no prompt deixou de existir; o
  escuro é `mode: "dark"` com a paleta repetida no bloco `dark`.
- **Etapas viraram o fluxo do agente:** antes de começar, a conversa (perguntas com opções), o plano mostrado ao
  dono, a construção, conferir antes de dizer pronto, mudanças depois. Os três critérios do frontmatter e os
  candidatos de critério viraram uma lista de conferência sem teto.
- **QA por conta do agente:** o que o QA do Studio pegava (hex, `font-family`, `window.confirm`,
  `animation-timeline`, `<img>` externo, `await import(`) virou busca por `grep` no código, mais a volta pela
  pré-visualização do `fabapp dev` e o tratamento de `build_failed` (422) e `account_builds_busy` (409).
- **Memória do app** virou `DECISOES.md` na raiz do projeto (seção Marca). O `finish` virou a mensagem final ao dono
  com a lista do que ele faz no Studio.
- `references/fabapp-cli.md` (o contrato da plataforma pelo terminal) é copiado pelo script de montagem.

Dá a qualquer app ou site gerado pela Fabapp uma direção visual própria, ancorada no mundo concreto do negócio:
decide a direção, a paleta e as fontes no briefing (campo `brand` do `deliver_prompt`, com contraste conferido),
registra o contrato no plano com critérios de aceite conferíveis, aplica composição, tipografia, movimento, imagens
e um momento assinatura na construção, e preserva ou repagina com método na edição.

- **Categoria:** visual
- **Etapas:** briefing, plan, build, edit
- **Tamanho (validador):** corpo ~5.760 tokens (briefing ~2.980, plan ~1.490, build ~2.260, edit ~1.100);
  referências ~12.240 tokens. No briefing cabem inline `1-sementes-e-fontes.md`, `calibracao-e-piso.md` e
  `setores.md` (~7.800 tokens); `construcao.md` é das etapas de plano, construção e edição, e o que o briefing
  precisa dele (presets dos dials) está repetido no corpo.
- **Complementa, não duplica:** a `fab-agencia` cuida de site premium com motion de agência; esta skill vale para
  qualquer app ou site, inclusive telas de operar, e cita a `fab-agencia` só como sugestão ao dono.

## Arquivos

- `SKILL.md`: método por etapa (quem decide o quê; leitura, candidatos, teste do vizinho, semente, perguntas e marca
  no briefing; contrato e critérios no plano; aplicação na construção; preservar ou repaginar na edição).
- `references/1-sementes-e-fontes.md`: 16 sementes nomeadas em português com contraste conferido por script contra o
  código de contraste da plataforma, fontes de treino a evitar com rota de exceção, fontes por voz (todas conferidas
  no catálogo de fontes da plataforma), estratégia de cor em quatro tokens, fórmula de contraste e clichês por setor.
- `references/calibracao-e-piso.md`: os seis rostos de IA com valores, clichês de texto em português, piso "conferir"
  e "recusar", checagem final.
- `references/construcao.md`: dials em classes e presets, tipografia em classes, composição por modo, catálogo de
  momentos assinatura, receitas de "mais ousado / mais discreto / mais simples / mais personalidade / efeito uau",
  protocolo de repaginação.
- `references/setores.md`: requisitos por setor brasileiro (ação principal, o que não pode faltar, o que afasta).

## Origem e licenças

1. **anthropics/skills**, `frontend-design` e `theme-factory` (commit 3337550). Licença Apache 2.0 (LICENSE.txt de
   cada skill). theme-factory: Copyright 2026 Anthropic, PBC. Obra derivada: texto reescrito em português e adaptado à
   Fabapp; temas substituídos por sementes próprias.
2. **pbakaus/impeccable** (commit edb9c7f). Licença Apache 2.0. Copyright 2025 Paul Bakaus. Obra derivada: texto
   reescrito e adaptado; nenhum arquivo copiado. Os arquivos `ios.md` e `android.md` (derivados de ehmo, MIT, ver
   NOTICE.md do projeto) não foram usados.
3. **Leonxlnx/taste-skill**, `taste-skill` (commit c184364). Licença MIT. Copyright (c) 2026 Leonxlnx. O aviso de
   copyright e de permissão da MIT acompanha esta obra derivada: "Permission is hereby granted, free of charge, to any
   person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the
   Software without restriction... The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software."
4. **nextlevelbuilder/ui-ux-pro-max-skill** (commit dcc40ff). Licença MIT. Copyright (c) 2024 Next Level Builder. Mesmo
   aviso MIT acima. Dos CSVs (`products.csv`, `ui-reasoning.csv`, `typography.csv`, `google-fonts.csv`, `colors.csv`,
   `landing.csv`, `styles.csv`, `motion.csv`) veio o raciocínio por setor como requisito; nenhuma paleta por setor foi
   trazida.
5. Análise usada: `analise/01-design.md` (o que aproveitar e o que não copiar).

As mudanças feitas em relação às originais estão no mapa abaixo (exigência de aviso de modificação da Apache 2.0).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| frontend-design: persona com cliente que já recusou propostas genéricas | SKILL.md, abertura | igual, em português |
| frontend-design: ancorar no assunto, no material e no vocabulário do setor | briefing, "ler o negócio" passo 3 | mundo concreto brasileiro (lousa, comanda, receituário) |
| frontend-design: confirmar o assunto com o cliente | briefing, leitura em uma linha mostrada ao dono | "Entendi assim: ..." |
| frontend-design: herói abre com o mais característico; número gigante é padrão | construcao.md, composição persuadir; calibração rosto 4 | igual |
| frontend-design: uma ou duas famílias, claramente distintas; tipo como elemento ativo | 1-sementes, regras de par; construcao, tipografia | fontes pela marca, tamanho e peso por classe |
| frontend-design: linhas abaixo de 80 caracteres, serifada com mais entrelinha | construcao, tipografia; piso | 65 a 75ch |
| frontend-design: evitar palavra destacada no título, caixa alta em rótulo, rótulos desnecessários | SKILL.md construção, tipografia; piso recusar | ênfase só na mesma família, uma vez |
| frontend-design: estrutura é informação; numeração só com sequência | calibracao, recusar | igual |
| frontend-design: movimento raro, um momento orquestrado | SKILL.md movimento; construcao dials | kit de movimento da plataforma |
| frontend-design: cinco clusters de IA com valores (creme #F4F1EA + terracota #D97757, preto + neon, jornal, kit SaaS, cromo) | calibracao, seis rostos; resumo no corpo | mais o roxo de IA (#742fc2, padrão da própria plataforma) |
| frontend-design: brief vence, padrão não é escolha | SKILL.md "Sempre" | igual |
| frontend-design: plano em duas passadas (tokens 4 a 6 cores, tipo, layout ASCII, princípios) e revisão contra o brief | briefing (direções) e plano (contrato) | 4 tokens da marca; layout descrito na PRIMEIRA DOBRA |
| frontend-design: teste do prompt vizinho | briefing, candidatos passo 3 | "mesmo negócio em outra cidade" |
| frontend-design: especificidade de CSS | fora | Tailwind por classe e componentes do kit tornam irrelevante |
| frontend-design: contenção, "gaste a ousadia num lugar", Chanel | SKILL.md momento assinatura; construcao | igual |
| frontend-design: piso sem anunciar (responsivo, foco, movimento reduzido) | calibracao, conferir | igual |
| frontend-design: autocrítica com captura de tela | construção, "Piso e entrega" | a plataforma abre o app, confere critérios e faz revisão visual; a skill manda passada única e finish só com o conferido |
| frontend-design: anotar o que já tentou | edição, `update_knowledge` | memória do app |
| frontend-design: escrita (usuário, voz ativa, ação com o mesmo nome no fluxo, erro sem desculpa, vazio como convite) | SKILL.md "Copy como design" | igual, com exemplos em português |
| theme-factory: 10 temas com 4 cores, par de fontes e "melhor para" | 1-sementes, 16 sementes | nomes em português, mundo em vez de setor, contraste conferido, fontes do Google Fonts |
| theme-factory: mostrar vitrine, perguntar, esperar escolha | briefing, pergunta 1 | 3 direções com a sorteada recomendada, sem PDF |
| theme-factory: criar tema na hora | fechar a marca passo 3 | paleta própria com fórmula de contraste |
| theme-factory: aplicar com consistência e contraste | fechar a marca; construção, travas | via `brand` e tokens |
| taste-skill 0: leitura do brief, sinais, restrições silenciosas | briefing, "ler o negócio" | idem, com modos |
| taste-skill 0.B: "Design Read" de uma linha | briefing passo 1 | em português, mostrado ao dono |
| taste-skill 0.C: uma pergunta só quando diverge | briefing, perguntas | uma rodada de até 3 (cadência da plataforma) |
| taste-skill 0.D: disciplina antipadrão | calibração | igual |
| taste-skill 1: três dials, inferência e presets | briefing (presets e palavras do dono); construcao, dials | nomes leigos (ousadia, movimento, densidade), presets de negócios brasileiros |
| taste-skill 2: mapa para design systems oficiais | fora | a pilha é fixa (shadcn); não se instala outro sistema |
| taste-skill 3: arquitetura (Next, RSC, next/font, Motion) | fora | pilha da plataforma; fontes pela marca; movimento pelo kit |
| taste-skill 3.C: Phosphor preferido, Lucide desencorajado | construcao, ícones | a plataforma usa `lucide-react`; mantida a disciplina de uma família e um traço |
| taste-skill 3.D: emoji desencorajado | calibracao, recusar | igual |
| taste-skill 3.E: `min-h-[100dvh]`, grid em vez de conta de flex | calibracao, recusar; construcao | igual |
| taste-skill 4.1: tipografia, desencorajar Inter, disciplina de serifa, Fraunces e Instrument Serif banidas, rodízio de serifas | 1-sementes, fontes de treino e por voz | rodízio com serifas do Google Fonts conferidas; fontes pagas (Söhne, GT America) trocadas por equivalentes abertas |
| taste-skill 4.1: folga de descendente em itálico | calibracao, checagem final | igual |
| taste-skill 4.2: um acento, saturação abaixo de 80%, regra do lilás, uma paleta, trava de cor | SKILL.md fechar a marca e travas; calibracao | igual |
| taste-skill 4.2: paleta premium bege, latão e expresso proibida como padrão, com alternativas e rodízio | calibracao rosto 1 com alternativas | rodízio pela semente |
| taste-skill 4.3: viés anticentro | construcao, dials | igual |
| taste-skill 4.4: card só com hierarquia, sombra tingida, trava de raio | construcao, profundidade; SKILL.md travas | raio da marca via `rounded-*` |
| taste-skill 4.5: estados, toque, contraste de botão, CTA sem quebra, CTA sem intenção duplicada, contraste de formulário | SKILL.md regras contáveis; calibracao | igual |
| taste-skill 4.6: rótulo acima, sem placeholder como rótulo | calibracao, checagem final | igual |
| taste-skill 4.7: herói cabe na tela, escala do título, topo até `pt-24`, até 4 elementos, logo wall abaixo, nav em uma linha e até 80px, bento com ritmo e N células, repetição de família, zigue-zague, eyebrow 1 a cada 3 com ceil, cabeçalho dividido, fundo variado no bento, colapso mobile | SKILL.md regras contáveis; construcao; calibracao | h1 com a base obrigatória da plataforma crescendo a partir de `md` |
| taste-skill 4.8: imagem por ferramenta de geração, picsum, logos reais do Simple Icons | SKILL.md imagens | `AppImage` gera; imagem externa é proibida pela plataforma, então picsum e CDN de logos saem; parede de logos só com logos reais enviados pelo dono |
| taste-skill 4.9: densidade de conteúdo, listas longas, ficha técnica, autoauditoria de copy, números falsos, um registro | construcao; calibracao | igual |
| taste-skill 4.10: citações até 3 linhas | calibracao, checagem final | aspas tipográficas |
| taste-skill 4.11: trava de tema | SKILL.md travas | igual |
| taste-skill 5: vidro, magnético, microinterações perpétuas, movimento motivado, um marquee, GSAP sticky e pan | construcao, movimento e assinatura | esqueletos GSAP trocados por `Pin`, `ScrollScale`, `Parallax`, `Marquee` do kit |
| taste-skill 5.D e 6: escuta de rolagem proibida, só transform e opacity, movimento reduzido, grão em camada fixa, z-index | calibracao; construcao | `animation-timeline` também recusado (QA) |
| taste-skill 6.C e 8: modo duplo claro e escuro obrigatório | fechar a marca | a plataforma deriva o escuro sozinha; a skill decide um tema pela cena e trava |
| taste-skill 6.D: Web Vitals | construcao (proporção de imagem) | `priority` do herói já é automático na plataforma |
| taste-skill 7: definições dos dials | construcao, dials em classes | igual |
| taste-skill 9: sinais de IA (visual, tipo, layout, "João da Silva", verbos vazios, SVG feito à mão, telas falsas) | calibracao | nomes e verbos em português |
| taste-skill 9.F: sinais de teste de produção (versão, numeração, ponto médio, pontos coloridos, legendas, faixas, cidade e hora, aviso de rolagem) | calibracao, recusar | igual |
| taste-skill 9.G: travessão banido | SKILL.md "Sempre"; checagem | igual |
| taste-skill 10: vocabulário de padrões | construcao, formas de herói e famílias de layout | só o que o kit realiza |
| taste-skill 11: protocolo de repaginação, auditoria, preservação, alavancas, árvore de decisão, o que nunca muda | construcao, protocolo; SKILL.md edição | igual |
| taste-skill 12: biblioteca de blocos | fora | contrato de um projeto em andamento, sem conteúdo |
| taste-skill 13: fora de escopo (painéis) | modo operar | coberto pela impeccable operate |
| taste-skill 14: checagem final de ~60 itens | calibracao, checagem final; critérios do plano | o que é conferível vira critério de aceite |
| impeccable SKILL: ir até o fim, verificação em passadas limitadas | SKILL.md construção, "Piso e entrega" | uma passada e correção em lote |
| impeccable: brief vence; refinar preserva, repaginar substitui | SKILL.md "Sempre"; edição | igual |
| impeccable: modos Persuadir, Operar, Ler, Experimentar | SKILL.md "Sempre"; construcao | igual |
| impeccable init: fatos do produto, evidência disponível e ausente, nada inventado | SKILL.md "Sempre"; setores | lugar marcado para o dono |
| impeccable shape: perguntas por rodada, sem pedir valores de CSS | briefing, perguntas | opções leigas |
| impeccable new-work 1: redesenho, mundo estabelecido, marca incompleta, sem autoridade | briefing passo 2; edição | igual |
| impeccable new-work 2: o que perguntar por modo | briefing passo 2 | igual |
| impeccable new-work 3: estender sem torneio de conceito | edição, primeiro item | igual |
| impeccable new-work 3: mecanismo, cena, lar cultural, vala da categoria e o oposto, 7 candidatos, 3 famílias de material | briefing, candidatos | igual |
| impeccable new-work 3: concept-seed (sorteio) e desafiantes de catálogo com fusão e veredito | briefing passo 4 | sorteio com semente do nome (sem binário); desafiantes de catálogo trocados pela porta clássica e pelas rodadas "mais seguro / mais ousado" |
| impeccable new-work 3: porta clássica permanente, re-roll com registros, duas rodadas e pergunta | briefing passos 5 e 6 | igual |
| impeccable new-work 3: página de decisão, comps por imagem, build-phase, comp-diff, plates, font-match | fora | a plataforma não gera comps no briefing nem mede pixels; a ambição fica no contrato (caminho "code-led" da original) e a plataforma confere critérios e faz revisão visual |
| impeccable new-work 4: estratégia de cor antes das cores, cor em escala de página, claro/escuro pela cena | briefing, fechar a marca; 1-sementes | estratégias traduzidas para 4 tokens |
| impeccable new-work 4: fontes como objetos do mundo, lista de fontes de treino, calibração e viés de renderização | 1-sementes; calibracao | mais os padrões da própria plataforma |
| impeccable new-work 5: contrato de seis blocos, nunca no código, surface brief | plano, bloco "Direção visual" | blocos pedidos: tese, mundo próprio, primeira dobra, forma, acabamento, momento assinatura (a história ficou dentro da tese e da primeira dobra) |
| impeccable new-work 5: DESIGN.md escrito no fim | memória do app semeada pelo plano; `update_knowledge` na edição | igual em função |
| impeccable new-work 6: comprometer cada átomo, primeira dobra como tese, provar e não afirmar, autorar conteúdo, técnica nomeada, ritmo de estúdio, movimento como material | SKILL.md construção; construcao | igual |
| impeccable new-work 7: inspeção em dois tamanhos, revisor isolado, documentador | construção, "Piso e entrega" | substituído pela abertura, revisão de critérios e revisão visual da plataforma |
| impeccable craft-floor: conferir e recusar | calibracao | classes Tailwind |
| impeccable operate: teste da familiaridade, tipo, cor, componentes, movimento, restrições e permissões | construcao, operar; SKILL.md composição | igual |
| impeccable typeset: papéis, medida, luz sobre escuro, números tabulares, parágrafo | construcao, tipografia | avaliação isolada e detector trocados pela revisão da plataforma |
| impeccable layout: proximidade, ritmo, escala de 4, olhar apertado | construcao | igual |
| impeccable colorize: papéis, contraste por par, escuro não invertido | 1-sementes; fechar a marca | OKLCH trocado por "girar o matiz mantendo a claridade" |
| impeccable bolder, quieter, distill, delight, overdrive | construcao, pedidos de intensidade | propor 2 ou 3 caminhos no "uau" |
| impeccable animate: foco, material por significado, tempos, curva, stagger, acessibilidade | SKILL.md movimento; construcao | kit da plataforma |
| impeccable critique, audit, polish, harden, onboard, clarify, adapt, optimize | parcial | ficam com outras skills; daqui vieram só estado vazio, erro, copy e regra de polir sem redesenhar |
| impeccable live, generate, hooks, doctor, document, extract, visualize | fora | dependem de navegador, binário ou arquivos locais; a função de detector é do QA da plataforma |
| ui-ux-pro-max: prioridades (acessibilidade e toque críticos) | calibracao, conferir | 44px, 8px, 4,5:1 |
| ui-ux-pro-max: raciocínio por setor com must-have e antipadrões | setores.md | reescrito para setores brasileiros, com registros profissionais e regras de conselhos |
| ui-ux-pro-max: paleta por setor (spa rosa, clínica azul, academia laranja) | 1-sementes, clichês por setor | usada como lista do que evitar |
| ui-ux-pro-max: tokens semânticos com pares "on-" e checagem de contraste | fechar a marca; 1-sementes | pares verificados por script |
| ui-ux-pro-max: master + overrides por página | plano (contrato) e modos por superfície | memória do app |
| ui-ux-pro-max: contrato de consulta, não persistir o não verificado | fontes e sementes conferidas no catálogo real | sem busca BM25 (a skill chega inteira) |
| ui-ux-pro-max: dials opcionais e escala de espaço por densidade | construcao, dials | igual |
| ui-ux-pro-max: pares de fontes e catálogo Google Fonts | 1-sementes, fontes por voz | pares clichês viraram lista a evitar |
| ui-ux-pro-max: landing patterns, charts, stacks, GSAP | fora ou parcial | gráficos são de outra skill; pilha fixa; GSAP trocado pelo kit |
| ui-ux-pro-max pro-rules: ícones (família, traço, tamanho, preenchido x contorno), toque, claro/escuro, espaço | construcao, ícones; calibracao | igual |
| Análise 01: produto antes da estética, lista "não inventar" | SKILL.md "Sempre"; setores | igual |
| Análise 01: modos por rota, sorteio com semente do projeto, contrato validável, dials leigos, regras contáveis, harden brasileiro | todo o corpo | semente pelo nome do negócio, porque no briefing o id do projeto ainda não existe |

## Trocado por limite da plataforma

- **Cor e fonte fora do build.** O build não escolhe cor nem fonte; por isso toda decisão de paleta, fontes e raio
  mora no briefing (`brand`). Na edição, cor principal e modo vão pelo tema da plataforma; `set_brand` só troca logo
  e nome, então fonte, fundo exato e raio de um app pronto são orientados ao dono (Studio, painel Marca).
- **Modo escuro.** Expressões como "tema escuro" no prompt ligam a paleta escura automática e descartam o `bg` da
  marca; a skill manda fazer o escuro pelo `bg` e `text` e descrever pelo material ("fundo preto-carvão").
- **App sem briefing.** A paleta do primeiro build vem do nicho; a skill mantém a direção em composição e tipografia
  e lista no `finish` os valores para o dono aplicar.
- **Sem comps de imagem, sem detector próprio, sem revisor isolado.** A ambição vai no contrato escrito e nos
  critérios de aceite, que a plataforma confere depois do build (QA estático, abertura no navegador, revisão visual).
