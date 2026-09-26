# Layout e Tipografia (layout-e-tipografia)

## Edição terminal

Esta é a edição para agentes que constroem e editam apps da Fabapp AI pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; muda o encanamento:

- As etapas do Studio viram o fluxo do agente: Antes de começar, A conversa, O plano, A construção, Conferir antes de dizer pronto, Mudanças depois.
- Cor, fonte e raio deixam de ser só da marca vinda do briefing ou da aba Marca: o agente propõe ao dono, pede aprovação e grava em `apps/<slug>/fab.config.json → theme` (`mode`, `primary`, `primaryFg`, `bg`, `card`, `text`, `accent`, `destructive`, `radius`, `titleFont`, `bodyFont`, `titleTracking`, `dark`), envia com `fabapp push` e anota em `DECISOES.md`. No código continuam só tokens e classes. Espaçamento global de títulos passa para `theme.titleTracking`.
- Os critérios de aceite (teto de 8) viram a lista de conferência do plano, com todos os itens que se aplicam, mais um sobre o `theme`.
- O QA automático e a autoverificação antes do `finish` viram a conferência do agente: diagnóstico de 8 perguntas, `fabapp dev` em 375px e no computador, busca no código (hex, `font-family`, espaçamento arbitrário, `window.confirm`/`alert`, `animation-timeline`, `<img>` externo, `await import(`) e `fabapp deploy` tratando 409 e 422.
- A pergunta de disposição na edição usa a ferramenta de perguntas de opção do agente; o manual do app (`update_knowledge`) vira `DECISOES.md`.
- A regra de skill de estilo ligada no mesmo pedido virou: o estilo anotado em `DECISOES.md` (ou a skill de estilo em uso no app) vence na escala e no `py-*` de seção.
- Imagens: `AppImage` uma por linha e nunca em `.map()`; o dono troca ou gera cada slot e sobe o logotipo no Studio.
- `references/fabapp-cli.md` (o contrato da plataforma pelo terminal) é copiado pelo script de montagem.

Faz cada tela nascer com estrutura antes de estilo: wireframe em blocos com opções comparadas no plano, construção em cinza, hierarquia por tamanho, peso e contraste, escala fechada de espaçamento, tipografia a partir do corpo, cor só no fim e autoavaliação de 8 perguntas com nota de 0 a 10.

- **Categoria**: visual
- **Etapas**: plan, build, edit
- **Tamanho** (validador): corpo ~3.860 tokens (plano ~2.440, construção ~2.490, edição ~2.440 por marcadores); referências ~9.280 tokens (cor, profundidade e imagem ~2.100, espaço e grade ~2.700, tipografia ~2.180, wireframe ~2.240).
- **Não duplica** a `fab-agencia` (direção de arte e motion de agência): esta decide disposição, medidas e ritmo em qualquer app ou site, e não escolhe fonte nem cor.

## Origem e licenças

| Fonte | Repositório | Licença | Aviso |
|---|---|---|---|
| wondelai refactoring-ui, `SKILL.md` e `references/` (advanced-patterns, theming-dark-mode, animation-microinteractions, data-visualization, accessibility-depth) | https://github.com/wondelai/skills (commit c172996, caminho refactoring-ui) | MIT | Copyright (c) 2025 Wondel.ai sp. z o.o. |
| bencium ui-typography, `SKILL.md`, `css-templates.md`, `html-entities.md` (regras destiladas de *Practical Typography*, de Matthew Butterick) | https://github.com/bencium/bencium-claude-code-design-skill (commit 8b152ec, caminho typography/skills/typography) | MIT | Copyright (c) 2026 bencium.io |
| Magdoub wireframe, `SKILL.md`, `README.md`, `wireframe/brain/design-taste.md`, `wireframe/templates/*` | https://github.com/Magdoub/claude-wireframe-skill (commit 44a5814) | MIT | Copyright (c) 2026 Magdoub |

Análise usada: `03-sites-apps-layout/ANALISE.md` (fichas 2, 10 e 12 e os conceitos-chave).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| refactoring-ui: cinza primeiro, cor por último | SKILL (abertura e construção passo 1 e 5); `cor-profundidade-imagem.md` | "cinza" = só tokens neutros do tema até o passo da cor |
| refactoring-ui: sistemas e escalas fechadas; comece com espaço demais | SKILL "Números fixos" | escala em classes Tailwind |
| refactoring-ui 1: hierarquia por tamanho, peso e cor; combinar alavancas sem multiplicar; rótulo secundário; cor semântica não é peso; hierarquia de botões; limite ético | SKILL construção passo 2 | tokens `text-foreground`/`text-muted-foreground`, variantes de `Button` |
| refactoring-ui 2: escala 4 a 64, entre grupos maior que dentro, larguras (texto 45 a 75, formulário 300 a 500), ícone 4px, card 24, seções 48 a 64 | SKILL "Números fixos" e tabela de relações | `max-w-prose`, `max-w-md`/`lg`, `py-12`/`py-16` |
| refactoring-ui 3: escala 12 a 36 (~1,2), entrelinha por contexto, pesos, duas famílias | SKILL "Números fixos"; `tipografia.md` | famílias vêm da marca; ajuste global em `src/app-typography.css` |
| refactoring-ui 4: 5 a 9 tons por cor, HSL, cinzas tingidos, nunca preto puro, contraste | `cor-profundidade-imagem.md` | trocado: tons e cinzas tingidos saem do tema da marca; a skill usa tokens e opacidade (`bg-primary/5`) |
| refactoring-ui 5: escala de sombras, sombra em duas partes, profundidade sem sombra, não abusar | `cor-profundidade-imagem.md` Profundidade | teto `shadow-sm` em card, como a plataforma pede |
| refactoring-ui 6: imagens e ícones (tamanho, object-fit, véu, estados vazios) | `cor-profundidade-imagem.md` Imagens | `AppImage`, `AvatarFallback`, `lucide-react` |
| refactoring-ui 7: não centralizar tudo, sangrar imagem, variar tratamento, alinhar para relacionar | SKILL "Alinhar à esquerda"; `espaco-grid-e-composicao.md` Composição | igual |
| refactoring-ui: erros comuns (amador, chapado, difícil de ler, tudo igual, poluído, cores brigando, botão não aparece, valores arbitrários) | SKILL edição, tabela de queixas | igual, em frases do dono |
| refactoring-ui: diagnóstico de 8 perguntas e nota = acertos ÷ 8 × 10 com faixas | SKILL "Diagnóstico de 8 perguntas" | cada pergunta com a forma de conferir no código |
| advanced-patterns: vazio, formulário (larguras, placeholder, estados, botões, colunas), imagem, ícone, estados de interação, psicologia da cor, raio, truncamento, breakpoints, modal, menu, navegação, abas | `espaco-grid-e-composicao.md`; `cor-profundidade-imagem.md` | componentes do kit (`Field`, `EmptyState`, `Dialog`, `Tabs`, `Breadcrumb`); raio base é da marca |
| theming-dark-mode | `cor-profundidade-imagem.md` Modo escuro | trocado: o tema compõe claro e escuro; a skill só usa tokens e confere; alternador de tema e paletas por data-attribute fora (são da plataforma) |
| animation-microinteractions: propósito, durações, curvas, padrões, carregamento, microinterações, movimento reduzido, desempenho, checklist | `cor-profundidade-imagem.md` Movimento fino | `Reveal`, `useReducedMotion`, `sonner`; sem `animation-timeline` |
| data-visualization: escolha do gráfico, barras, linhas, pizza, cores, tabelas, painel, anotações, acessibilidade | `espaco-grid-e-composicao.md` Tabelas e Painéis | `Chart`, `StatCard`, `DataTable`; números sempre dos dados |
| accessibility-depth: WCAG, foco, tabindex móvel, leitor de tela, ferramentas | `cor-profundidade-imagem.md` Acessibilidade de estrutura | Radix do kit já faz foco e setas; ferramentas de teste fora (sem navegador) |
| ui-typography: modos de aplicação (impor calado, auditar) | `tipografia.md` abertura | igual |
| ui-typography: aspas, apóstrofo, traços, reticências, matemática, marcas, parágrafo, acentos, pontuação | `tipografia.md` Caracteres e Pontuação | versão brasileira; intervalos com "a"; travessão e meia-risca fora do texto do app |
| ui-typography: aviso de escape `\u` em JSX | `tipografia.md` Caracteres | igual |
| ui-typography: espaços (um só, que não quebra, tipos) | `tipografia.md` | R$, unidades, Dr., ©, § |
| ui-typography: negrito ou itálico, sublinhado, caixa alta com 5 a 12%, versalete, tamanho, espaçamento, kerning, ligaduras, algarismos, escolha e mistura de fontes | `tipografia.md` Ênfase | kerning e ligaduras já vêm ligados no navegador; fonte é da marca |
| ui-typography: corpo primeiro, medida 45 a 90, entrelinha 120 a 145%, margens, alinhamento, parágrafos, títulos (10 regras), citação, listas, tabelas, linhas, viúvas e órfãs, colunas | `tipografia.md`; `espaco-grid-e-composicao.md` | entrelinha fixada em 1,4 a 1,6 (meio-termo entre Butterick e Refactoring UI, como pede a análise); margens = `px-6` da plataforma |
| ui-typography: responsiva (regras iguais, clamp, max-width, padding) | `tipografia.md` Tamanho e escala | degraus responsivos do Tailwind no lugar de `clamp` |
| ui-typography: telas, modo escuro, máximas de página | `tipografia.md` | igual |
| css-templates: modelo base, OpenType, escuro, impressão, JSX | `tipografia.md` (algarismos, impressão, JSX) | CSS global substituído por classes e `src/app-typography.css` |
| html-entities: tabela de substituição e entidades | `tipografia.md` tabela | caractere real em JSX |
| wireframe: duas personas (arquiteto de UX, designer visual) e estrutura travada na fase de cor | SKILL (ordem de trabalho; edição "só o visual"); `wireframe-em-blocos.md` | as fases viram passos da mesma construção |
| wireframe: 5 opções (1 segura + 4 exploratórias), nomes curtos, filosofias (22) | SKILL plano passo 3; `wireframe-em-blocos.md` | 2 ou 3 opções escritas no plano (custo de texto); a lista inteira de filosofias ficou |
| wireframe: objetivo de otimização (conversão, desistência, tempo, descoberta) extraído ou perguntado | `wireframe-em-blocos.md` O objetivo decide | lido do pedido; pergunta ao dono só na edição |
| wireframe: tabela de notas 1 a 5 estrelas e recomendação | `wireframe-em-blocos.md` | igual, no plano |
| wireframe: conteúdo realista, estados, anotações numeradas | `wireframe-em-blocos.md` Formato | notas (1), (2) no bloco |
| wireframe: contexto de design persistente | `wireframe-em-blocos.md` Edição | manual do app via `update_knowledge` |
| wireframe: pergunta de plataforma (celular, desktop, ambos) | fora | todo app da Fabapp é responsivo e o app nativo é o mesmo web |
| wireframe: variantes Clean e Polished | `wireframe-em-blocos.md` Dois níveis de acabamento | Limpo nas telas de operar, Caprichado nas de venda; mesma paleta, nunca escuro |
| wireframe: anti-padrões de CSS (borda sem padding, seção cortada, gradiente imperceptível, conteúdo vazando, escuro no polido) | `wireframe-em-blocos.md` Armadilhas | igual |
| design-taste: superfície, bordas, espaçamento, intenção de cor, tipografia, animação, estados | `wireframe-em-blocos.md` Acabamento | tokens e classes |
| design-taste: tokens Acolhedor e Preciso | `espaco-grid-e-composicao.md` Conjuntos de densidade | paletas hex dos tokens fora (cor é da marca); espaço, raio e sombra ficaram, casados com os registros da plataforma |
| design-taste: testes da troca, do borrão, da assinatura, dos tokens; vícios de IA | `wireframe-em-blocos.md` | igual |
| wireframe: HTML com abas, navegador simulado, 5 agentes em paralelo, CSS por opção, `open` no navegador, templates | fora | a Fabapp não gera protótipo HTML à parte: o wireframe é texto no plano e a construção é o próprio app |

## O que ficou de fora ou foi trocado, e por quê
- **Escolha de fonte e cor**: vêm da marca (briefing ou aba Marca). A skill decide tamanho, peso, entrelinha, medida e onde a cor aparece. Paletas hex das fontes originais (design-taste, dark mode) não entram.
- **Protótipo HTML navegável com 5 opções e agentes paralelos**: não há navegador nem subagentes no gerador; o wireframe vira blocos escritos no plano com 2 ou 3 opções comparadas, e na edição a escolha vira pergunta com opções.
- **CSS global** (modelo base de Butterick, `clamp`, `@font-face`): a plataforma é dona do CSS; o que sobra de global vai em `src/app-typography.css`.
- **Pés e polegadas, okina havaiana, regras de aspas do inglês**: trocadas pelas convenções do português.
- **Ferramentas de teste** (axe, WAVE, leitores de tela, simuladores de daltonismo): sem navegador; os critérios conferíveis no código ficaram.
