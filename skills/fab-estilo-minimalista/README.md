# Estilo Minimalista Editorial (`fab-estilo-minimalista`)

## Edição terminal

Esta pasta é a edição terminal, para Claude Code, Codex, OpenCode, Cursor, Gemini CLI e outras ferramentas que leem Agent Skills e constroem apps da Fabapp AI pelo CLI `@fabappai/cli`. O conhecimento do estilo é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: antes de começar, a conversa, o plano, a construção, conferir antes de dizer pronto, mudanças depois.
- A marca não vai mais num campo de entrega do briefing: o agente grava paleta, fontes, tracking e raio em `apps/<slug>/fab.config.json → theme` e envia com `fabapp push`.
- O `theme` tem a chave `card`: o cartão branco sobre o fundo osso da original voltou (`card: #FFFFFF`), coisa que o build do Studio não podia fazer.
- Os critérios de aceite (antes limitados a 8) viraram a lista de conferência completa do plano, e a conferência final roda com `fabapp dev`, `grep` e `fabapp deploy`.
- A memória do app é o `DECISOES.md` na raiz do projeto.
- `references/fabapp-cli.md` é o contrato da plataforma pelo terminal, igual em todas as skills.

## Edição Studio (origem desta edição)

Pacote estético que dá ao app ou site gerado pela Fabapp o visual minimalista editorial: monocromático quente, títulos em serifa, cartões planos com borda de 1px, pastéis só em detalhes e movimento discreto.

- Categoria: visual
- Etapas: briefing, plan, build, edit
- Tokens (validador): ver a última linha deste arquivo
- Complementa a `fab-agencia` (processo de agência e direção de arte para sites); este pacote é um estilo fechado, que serve também para app de uso diário.

## Origem

- `minimalist-skill` (nome original `minimalist-ui`, "Premium Utilitarian Minimalism UI Architect") do repositório taste-skill, https://github.com/Leonxlnx/taste-skill, commit c184364 (baixado em 24/09/2026).
- Licença: MIT. Copyright (c) 2026 Leonxlnx. Texto da licença: "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND."
- Obra derivada, reescrita em português para a plataforma Fabapp. Análise usada: `analise/01` seção 3 (taste-skill e irmãs).

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| 1. Visão geral: minimalismo utilitário, estilo documento, rejeitar SaaS genérico | Abertura do SKILL.md | Mantido; vale para site e app |
| 2. Proibido Inter, Roboto, Open Sans | Briefing, `body_font` (a proibição fica junto do `brand`, o único lugar com nome de fonte) | Mantido |
| 2. Proibido Lucide/Feather/Heroicons finos | Construção, Ícones | Trocado: lucide com `strokeWidth={2.25}` uniforme (o kit, o QA de ícones e o `EmptyState` usam lucide); efeito de traço grosso da Phosphor Bold |
| 2. Sem `shadow-md/lg/xl`, sombra < 0,05 | Proibição 1, critério de aceite, conferência | Mantido e conferível |
| 2. Sem fundo de cor primária em seção grande | Proibição 2, critério | Mantido (`bg-primary` só em botão) |
| 2. Sem gradiente, neon, glassmorphism (exceto blur de navbar) | Proibição 3 | Mantido com a exceção |
| 2. Sem `rounded-full` em contêiner, cartão, botão principal | Proibição 4, critério | Mantido |
| 2. Sem emoji | Proibição 5, critério | Mantido |
| 2. Sem John Doe, Acme, Lorem | Proibição 6 | Adaptado a nomes brasileiros e marcação de exemplo |
| 2. Sem clichês "Elevate, Seamless, Unleash..." | Proibição 7 | Lista reescrita com os clichês em PT-BR |
| 3. Sans: SF Pro, Geist, Helvetica Neue, Switzer | Briefing, `body_font: Geist` | Pagas trocadas por Geist (Google Fonts); nome de fonte só no `brand` |
| 3. Serifa editorial: Lyon Text, Newsreader, Playfair, Instrument Serif | Briefing, `title_font: Newsreader` | Lyon (paga) fora; Instrument Serif só como alternativa de título (a plataforma exige regular e negrito na fonte de texto) |
| 3. Tracking -0.02 a -0.04em, entrelinha 1.1 nos títulos | Tipografia; `app-typography.css` | Via classes e `app-typography.css` em `@layer base`, sem nome de fonte |
| 3. Mono: Geist Mono, SF Mono, JetBrains Mono | `font-mono` | A mono da plataforma é fixa (JetBrains Mono, que estava na lista) |
| 3. Texto `#111`/`#2F3437`, entrelinha 1.6, secundário `#787774` | Briefing, `brand.text`; `leading-[1.6]` | Hex só no `brand` do briefing (a tabela de paleta descreve em palavras e dá o token); secundário derivado pela plataforma |
| 4. Fundo `#FFF`/`#F7F6F3`/`#FBFBFA`, cartão `#FFF`/`#F9F9F8` | Briefing, `brand.bg`; pergunta 1 | Cartão fica com a cor do fundo (conferido no código: a plataforma copia o `bg` da marca para o cartão); separação pela borda |
| 4. Borda `#EAEAEA` | `border-border` | Derivada pela plataforma do texto e fundo |
| 4. Quatro pastéis com texto | Tabela de pastéis; pergunta 2; tokens semânticos | Um vira `accent`; etiquetas usam `info/success/warning/destructive` com transparência |
| 5. Bento assimétrico, borda 1px, raio 8 a 12, padding 24 a 40 | Construção, Grade bento; `radius: 8` | Mantido; na base uma coluna (regra da plataforma) |
| 5. CTA `#111`, raio 4 a 6, sem sombra, hover `#333` ou scale 0.98 | Construção, Botões | `bg-primary` + `hover:bg-primary/90` + `active:scale-[0.98]` |
| 5. Tags em pílula, `text-xs`, uppercase, tracking 0.05em, fundo pastel | Construção, Etiquetas; critério | Mantido |
| 5. Acordeão sem caixa, `border-bottom`, ícone + e - | Construção, FAQ; critério | Mantido (lucide Plus/Minus) |
| 5. `<kbd>` com borda, raio 4, fundo bone, mono | Construção, Atalhos | Mantido com tokens |
| 5. Janela falsa de sistema com três círculos | Construção, Janela de software | Mantido com `bg-border` |
| 6. Ícones Phosphor Bold/Fill ou Radix, traço padronizado | Construção, Ícones | lucide com traço grosso padronizado |
| 6. Ilustração em traço de tinta com forma pastel | Pergunta 3 do briefing; prompt de `AppImage` | A plataforma gera a imagem pelo `prompt` |
| 6. Foto dessaturada quente com grão 0.04 | Construção, Imagens | `saturate`/`sepia` + camada de ruído |
| 6. picsum como placeholder | Proibição 8 | Trocado por `AppImage` (placeholder temático da plataforma); picsum é foto sem relação com o negócio |
| 6. Fundo de seção com imagem fraca, luz radial 0.03, padrão de linhas | Construção, Profundidade de fundo; critério visual | Com tokens (`var(--accent)`, `var(--border)`), sem hex |
| 7. Entrada 12px + fade, 600ms, `cubic-bezier(0.16,1,0.3,1)`, IntersectionObserver | Construção, Movimento; critério | `Reveal` do kit (12px, IO) com duração e curva por classe |
| 7. Hover de cartão com sombra 0 2px 8px 0.04 em 200ms; `scale(0.98)` no active | Construção, Movimento e Botões | Mantido |
| 7. Stagger `index * 80ms` | Construção, Movimento; critério | `Math.min(i,6)*80` (teto da plataforma para lista) |
| 7. Mancha de gradiente lenta 20s+, fixa, sem ponteiro | Construção, Profundidade (opcional) | `animate-[spin_60s_linear_infinite]` numa camada fixa, só `motion-safe` |
| 7. Só `transform`/`opacity`, `will-change` com parcimônia | Construção, Movimento | Mantido; `animation-timeline` proibido pela plataforma |
| 8. Protocolo de execução (7 passos) | Construção, "Ordem de trabalho"; Conferência antes do finish | Mantido e virou conferência |
| 8. `py-24`/`py-32` entre seções | Construção, Espaço | `py-16 sm:py-24 lg:py-32` (base menor no celular) |
| 8. Texto em `max-w-4xl`/`max-w-5xl` | Construção, Espaço; critério | Mantido com o contêiner obrigatório `px-6` |
| (sem equivalente) Aplicação em app de uso diário | Construção, "Quando é app de uso diário" | Acrescentado: a plataforma proíbe herói de slogan na home de produto |
| (sem equivalente) Edição | "Na edição" | Cor pelo patch de tema; fonte e raio na aba Marca do Studio (`set_brand` só troca logo e nome) |

## O que ficou de fora ou foi trocado

- Hex e nomes de fonte no código: proibidos pela plataforma. Vão na `brand` do briefing; no código só tokens.
- Cartão branco sobre fundo osso: a marca não tem cor de cartão própria; o cartão herda o fundo e se destaca pela borda de 1px.
- Phosphor/Radix Icons: trocados por lucide com traço grosso uniforme.
- Fontes pagas (SF Pro, Lyon Text, Switzer, SF Mono): trocadas por Geist, Newsreader e a mono fixa da plataforma.

## Contradições com a taste-skill

A taste-skill desencoraja Instrument Serif como padrão e desencoraja Lucide; esta skill recomenda serifa editorial nos títulos e usa lucide. Cada pacote vale dentro dele: o SKILL.md diz isso na abertura.

## Tokens

Saída do validador: corpo ~4,5 mil tokens, referências 0.
