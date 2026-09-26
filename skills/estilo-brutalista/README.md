# Estilo Brutalista (`estilo-brutalista`)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: a conversa com o dono (perguntas com opções), o plano mostrado antes de codar, a construção, a conferência antes de dizer pronto e as mudanças depois.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida pelo próprio agente com `fabapp dev`, busca no código e `fabapp deploy`.
- A memória do app virou `DECISOES.md` na raiz do projeto; o resumo final virou a mensagem ao dono com o que foi conferido e o que ele faz no Studio.
- A marca não vai mais num campo de entrega do briefing: o agente grava paleta, fontes, tracking e raio 0 em `apps/<slug>/fab.config.json → theme` e envia com `fabapp push`.
- A armadilha do "tema escuro" no prompt do Studio virou a do `mode: "dark"`: na versão Terminal o bloco `dark` do `theme` recebe os mesmos valores do topo, senão entra o escuro padrão da plataforma.

Pacote estético que dá ao app ou site gerado pela Fabapp o visual brutalista industrial, em uma de duas versões fechadas: Impresso Suíço (papel claro, tinta preta, vermelho) ou Terminal Tático (fundo preto-carvão, texto fósforo, vermelho).

- Categoria: visual
- Etapas: briefing, plan, build, edit
- Tokens (validador): ver a última linha deste arquivo
- Complementa a `fab-agencia` (processo de agência para sites premium); aqui é um estilo fechado, que também serve para painel denso de dados.

## Origem

- `brutalist-skill` (nome original `industrial-brutalist-ui`, "Industrial Brutalism & Tactical Telemetry UI") do repositório taste-skill, https://github.com/Leonxlnx/taste-skill, commit c184364 (baixado em 24/09/2026).
- Licença: MIT. Copyright (c) 2026 Leonxlnx. "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND."
- Obra derivada, reescrita em português para a plataforma Fabapp. Análise usada: `analise/01` seção 3.

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| 1. Meta: suíço + manual industrial + terminal militar/aeroespacial | Abertura | Mantido; vale para site e painel |
| 2. Dois arquétipos, escolher UM e não misturar | Tabela "Os dois modos"; pergunta 1 do briefing; critério visual | Escolha vira pergunta ao dono com recomendação pelo tipo de negócio |
| 2.1 Impresso Suíço: claro, sans monolítica, grade com linhas, números gigantes sangrando, vermelho | Tabela de modos; Construção, Tipografia | Número gigante vem de dado real |
| 2.2 Terminal: só escuro, dados tabulares densos, mono dominante, molduras ASCII, fósforo, linhas de tela | Tabela; Construção (tabela densa, texturas) | `font-mono` no invólucro do layout |
| 3.1 Macro: Neue Haas Black, Inter Black, Archivo Black, Roboto Flex, Monument | Briefing, `title_font: Archivo Black` | Pagas fora; Archivo Black do Google Fonts (conferido no catálogo da plataforma); nome de fonte só no `brand` |
| 3.1 `clamp(4rem,10vw,15rem)`, tracking -0.03 a -0.06em, entrelinha 0.85 a 0.95, caixa alta | Tipografia; `app-typography.css`; critério | Piso do clamp 1.875rem (o `text-3xl` obrigatório da plataforma em 375px; evita palavra longa em PT estourar a tela) |
| 3.2 Micro mono: JetBrains, IBM Plex, Space Mono, VT323, Courier Prime; 10 a 14px; tracking 0.05 a 0.1em; entrelinha 1.2 a 1.4; caixa alta | Tipografia; critério | Mono fixa da plataforma (JetBrains Mono); as outras não podem ser carregadas pelo build |
| 3.3 Serifa de contraste (Playfair, EB Garamond) com retícula/pontilhado | Fora (ver abaixo) | A marca só tem duas fontes e o build não carrega fonte; o contraste textural ficou nas fotos com retícula e pontilhado |
| 4. Sem gradiente, sombra suave, transparência | Proibições; critério; conferência | Mantido; a exceção das listras de `repeating-linear-gradient` (faixa de aviso, código de barras, linhas de tela) e dos pontos da retícula está escrita na proibição, no critério e na conferência |
| 4. Uma paleta de substrato por projeto | Tabela de modos; critério visual | Mantido |
| 4. Claro `#F4F4F0`/`#EAE8E3`, tinta `#050505` a `#111111`, vermelho `#E61919`/`#FF2A2A` | `brand` no briefing | Hex só no `brand` do briefing (a tabela de modos descreve em palavras e dá o token); no escuro usamos `#FF2A2A` pelo contraste |
| 4. Escuro `#0A0A0A`/`#121212`, `#EAEAEA`, sem `#000` | `brand` no briefing | Mantido; armadilha de "tema escuro" no prompt documentada |
| 4. Verde terminal `#4AF626` em um elemento só | Tabela de modos; conferência | Token `text-success` (a marca não tem quinta cor) |
| 5. Grade de planta, CSS Grid | Regras de espaço; Construção, Grade | Mantido; no máximo 2 colunas na base |
| 5. Compartimentos com borda 1 a 2px, `<hr>` de largura total | Regras; Construção; critério | `border-foreground`, `border-t-2` |
| 5. Densidade bimodal | Regras de espaço | Mantido |
| 5. Nenhum `border-radius` | `radius: 0`; critério; conferência | Mantido; Switch trocado por Checkbox |
| 6. Moldura ASCII e direcionais | Construção, Símbolos | Mantido |
| 6. ®, ©, ™ como elementos geométricos | Construção, Símbolos | Mantido com trava: nunca colado a nome (afirmaria registro de marca) |
| 6. Cruzes nas interseções, código de barras, faixas de aviso, strings aleatórias (`REV 2.6`) | Construção, Símbolos e Grade | Strings derivadas de dado real quando possível; nenhum número com cara de fato |
| 7. Retícula e pontilhado 1 bit (`mix-blend-multiply` + pontos SVG) | Construção, Texturas; pergunta 2 | Pontos por `radial-gradient` com token; pontilhado pelo `prompt` do `AppImage` |
| 7. Linhas de tela CRT com `repeating-linear-gradient` | Construção, Texturas | Mantido (rgba permitido; sem hex) |
| 7. Ruído SVG global de baixa opacidade | Construção, Texturas; critério | Camada fixa sem ponteiro |
| 8.1 `display:grid; gap:1px` com fundos contrastantes | Construção, Grade; critério | Mantido com tokens |
| 8.2 Tags semânticas `<data>`, `<samp>`, `<kbd>`, `<output>`, `<dl>` | Construção, Tags semânticas; critério | `DescriptionList` do kit para `<dl>` |
| 8.3 `clamp()` só na macro | Construção, Tipografia | Mantido |
| (sem equivalente) Movimento | Construção, Movimento | Decisão Fabapp: seco e curto (a plataforma pede páginas vivas; a original não define) |
| (sem equivalente) App de uso diário | Plano; Construção, tabelas | Home de produto sem herói de slogan |
| (sem equivalente) Edição | "Na edição" | Cor pelo patch de tema; fonte e raio na aba Marca (`set_brand` só troca logo e nome) |

## O que ficou de fora ou foi trocado

- Serifa de contraste degradada (3.3): exigiria uma terceira fonte; a plataforma carrega só título, texto e a mono fixa. O efeito textural foi mantido nas imagens.
- Monos alternativas (IBM Plex Mono, Space Mono, VT323, Courier Prime): a mono da plataforma é fixa em JetBrains Mono.
- Verde exato `#4AF626`: vira o token de sucesso do tema.
- Hex no código: proibido pela plataforma; tudo vai na `brand` do briefing.

## Contradições com a taste-skill

A taste-skill pede poucos rótulos em caixa alta e reduz "marcadores de sistema"; este pacote usa micro mono em caixa alta e códigos técnicos como textura. Cada pacote vale dentro dele: o SKILL.md diz isso na abertura.

## Tokens

Saída do validador: corpo ~4,2 mil tokens, referências 0.
