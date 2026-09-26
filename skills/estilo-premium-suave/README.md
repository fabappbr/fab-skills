# Estilo Premium Suave (`estilo-premium-suave`)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- A marca não vai mais num campo de entrega do briefing: o agente grava a linha do clima (paleta, fontes, tracking, raio 16) em `apps/<slug>/fab.config.json → theme` e envia com `fabapp push`.
- A armadilha do "tema escuro" no prompt do Studio virou a do `mode: "dark"`: no Vidro Etéreo o bloco `dark` do `theme` recebe os mesmos valores do topo, senão entra o escuro padrão da plataforma.
- O registro do clima e dos arranjos, que ia no resumo do build, vai no `DECISOES.md` na raiz do projeto.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Pacote estético de acabamento de estúdio caro para site ou app na Fabapp: três climas fechados (Vidro Etéreo, Luxo Editorial, Estrutura Suave), três arranjos de layout, cartões em dupla moldura, botões em pílula com ilha interna, menu flutuante e movimento com peso.

- Categoria: visual
- Etapas: briefing, plan, build, edit
- Tokens (validador): ver a última linha deste arquivo
- Complementa a `fab-agencia`: aquela conduz o processo de agência (direção de arte, conversão, publicação); esta é uma linguagem visual pronta, aplicável também a app de uso diário.

## Origem

- `soft-skill` (nome original `high-end-visual-design`, "Principal UI/UX Architect & Motion Choreographer") do repositório taste-skill, https://github.com/Leonxlnx/taste-skill, commit c184364 (baixado em 24/09/2026).
- Licença: MIT. Copyright (c) 2026 Leonxlnx. "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND."
- Obra derivada, reescrita em português para a plataforma Fabapp. Análise usada: `analise/01` seção 3.

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| 1. Objetivo nível agência: profundidade, ritmo, microinteração, movimento fluido | Abertura; item 11 da lista final | Mantido |
| 1. Mandato de variância: nunca o mesmo layout duas vezes | "Variedade" nos arranjos; plano registra clima e arranjos | Adaptado: páginas vizinhas não repetem arranjo; registro por escrito |
| 2. Fontes proibidas (Inter, Roboto, Arial, Open Sans, Helvetica) | Proibição 1; lista no `brand` do briefing | Mantido (nome de fonte só na seção do briefing) |
| 2. Fontes premium (Geist, Clash Display, PP Editorial New, Plus Jakarta Sans) | Briefing, `brand` por clima | Clash Display por Bricolage Grotesque, PP Editorial New por Fraunces (todas conferidas no catálogo da plataforma); a tabela de climas descreve em palavras |
| 2. Ícones grossos proibidos; Phosphor Light ou Remix Line | Proibição 2 | lucide com `strokeWidth={1.25}` (kit e QA de ícones usam lucide) |
| 2. Borda cinza genérica e sombra dura proibidas | Proibição 3; critério | Mantido |
| 2. Navbar grudada de ponta a ponta; 3 colunas simétricas sem espaço | Proibição 4 | Mantido (`gap-10` mínimo em 3 colunas) |
| 2. `linear`/`ease-in-out` e mudança instantânea proibidos | Proibição 5; critério | Mantido; exceção do laço do `Marquee` |
| 3. Motor de variância "silencioso" | Briefing (clima pelo nicho, confirmado com o dono) e plano (arranjo pelo conteúdo) | A escolha deixa de ser aleatória: vira decisão registrada |
| 3.A Vidro Etéreo `#050505`, orbes roxo/esmeralda, cartões com `backdrop-blur-2xl`, fio branco/10, grotesca larga | Tabela (em palavras); `brand` no briefing; Fundo e textura | Orbes com `bg-primary/25` e `bg-success/15` desfocados; cartões SEM blur (a própria seção 6 da original proíbe blur em conteúdo que rola); Unbounded |
| 3.A Luxo Editorial `#FDFBF7`, sálvia, café, serifa variável, grão 0.03 | Tabela (em palavras); `brand` no briefing; Fundo e textura | Fraunces; grão fixo sem ponteiro |
| 3.A Estrutura Suave: prata ou branco, grotesca forte, sombras ambiente difusas | Tabela (em palavras); `brand` no briefing; Fundo e textura | Bricolage Grotesque; sombra `rgba` difusa (sem hex) |
| 3.B Bento assimétrico + colapso no celular | Arranjo 1 | Mantido com `lg:grid-cols-12` |
| 3.B Cascata em Z com rotação -2/3 graus + colapso | Arranjo 2 | Mantido |
| 3.B Divisão editorial + pílulas de imagem rolando | Arranjo 2 e 3; Imagens | `ScrollRow` (a plataforma proíbe `overflow-x-auto`) |
| 3. Regra universal de celular `w-full px-4 py-8`; `min-h-[100dvh]` | Regra de celular | `px-6` (contêiner obrigatório da plataforma vence o `px-4`) |
| 4.A Dupla moldura (casca `p-1.5`/`p-2`, `rounded-[2rem]`, núcleo com brilho interno e raio concêntrico) | Construção; critério | Tokens `foreground/5` no lugar de `black/5`/`white/5` (segue o tema) |
| 4.B Botão pílula `px-6 py-3` com seta em círculo `w-8 h-8` encostado | Construção, Botão com ilha; critério | Mantido |
| 4.C Macroespaço `py-24` a `py-40` | Espaço; critério | `py-24 md:py-32 lg:py-40` |
| 4.C Etiqueta em pílula antes de H1/H2 (`text-[10px]`, `tracking-[0.2em]`) | Etiqueta acima do título | Só em vitrine; na home de app de uso diário não (regra da plataforma contra slogan com selo em produto) |
| 5. Curvas `cubic-bezier(0.32,0.72,0,1)`, 700ms | Todas as transições; critério | Mantido |
| 5.A Navbar em cápsula de vidro solta do topo | Menu em cápsula | Mantido com área segura; é a casca do site |
| 5.A Hambúrguer que vira X | Menu | Mantido |
| 5.A Menu de tela cheia com vidro pesado | Menu | `bg-background/80 backdrop-blur-3xl` |
| 5.A Links com revelação escalonada `translate-y-12`, atrasos 100/150/200 | Menu | Mantido |
| 5.B Botão magnético: `active:scale-[0.98]`, ícone desliza na diagonal e cresce 105% | Botão com ilha | Mantido |
| 5.C Entrada `translate-y-16 blur-md opacity-0` em 800ms+ por IntersectionObserver | Entrada por scroll; critério | Componente `FadeUp` com `useInView`/`useReducedMotion` do kit (o `Reveal` sobe só 12px) |
| 6. Só `transform`/`opacity`; `will-change` com parcimônia | Desempenho | Mantido |
| 6. Blur só em fixo/sticky | Desempenho; critério | Mantido |
| 6. Grão só em pseudo-elemento fixo sem ponteiro | Fundo e textura; critério | Camada fixa (a plataforma não deixa editar CSS global) |
| 6. Disciplina de z-index | Desempenho e camadas | Escala fixa 30/40/50 |
| 7. Protocolo de execução em 5 passos | Construção, "Ordem de trabalho" | Mantido |
| 8. Checklist final de 11 itens | "Antes de chamar finish" e critérios de aceite | Mantido item a item |
| (sem equivalente) App de uso diário | Plano; barra de abas flutuante | Home de produto sem herói |
| (sem equivalente) Edição | "Na edição" | Cor pelo patch de tema; fonte e raio na aba Marca (`set_brand` só troca logo e nome) |

## O que ficou de fora ou foi trocado

- Hex e fontes no código: proibidos pela plataforma; tudo na `brand` do briefing.
- `backdrop-blur` nos cartões do Vidro Etéreo: contradiz a regra de desempenho da própria original; os cartões ficam quase pretos com fio de 10%.
- Phosphor Light e Remix Line: trocados por lucide de traço 1.25.
- `px-4` no celular: a plataforma exige `px-6` no contêiner.
- Rolar os dados aleatoriamente: vira escolha pelo nicho confirmada com o dono, para o resultado ser previsível e editável.

## Contradições com a taste-skill

A taste-skill limita etiquetas acima de título (no máximo 1 a cada 3 seções) e a image-to-code manda reduzir pílulas; este pacote coloca etiqueta em pílula antes dos títulos principais de vitrine. Cada pacote vale dentro dele: o SKILL.md diz isso na abertura.

## Tokens

Saída do validador: corpo ~4,4 mil tokens, referências 0.
