# Redesign e Polimento (fab-redesign-e-polimento)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que editam o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: Antes de começar, A conversa, O plano (com a auditoria e a triagem antes de escrever), A construção, Conferir antes de dizer pronto, Mudanças depois.
- Cor, fonte e raio: o agente propõe, pede o sim e grava em `apps/<slug>/fab.config.json → theme` (`mode`, `primary`, `primaryFg`, `bg`, `card`, `text`, `accent`, `destructive`, `radius`, `titleFont`, `bodyFont`, `titleTracking`, `dark`), com `fabapp push`. O que na Studio era patch de tema com preset, `brand` do briefing ou aba Marca do dono agora é valor escrito pelo agente. Logo continua com o dono, no Studio.
- Os critérios de aceite (teto de 8) viraram a lista de conferência do plano, com todos os itens que se aplicam.
- O QA automático e a revisão visual viraram conferência do agente no `fabapp dev` e busca no código (hex, `font-family`, `window.confirm`/`alert`, `animation-timeline`, `<img>` externo, `await import(` dinâmico, `<title>`), mais a comparação das rotas com as anotadas na auditoria.
- O manual do app virou `DECISOES.md`; o `finish` virou a mensagem final ao dono; o site antigo é lido com a ferramenta web do agente (ou por prints).
- Otimizar: `React.lazy` fica só para componente pesado dentro da página (as rotas o build já divide); o contrato proíbe `await import(`, não o `React.lazy`.

Melhora um app ou site que já existe na Fabapp sem quebrar nada: decide o modo (ajuste ou repaginação), audita antes de mexer, dá nota de usabilidade, conserta na ordem de menor risco e nunca troca em silêncio o que o dono conhece.

- **Categoria**: visual
- **Etapas**: briefing, plan, edit
- **Tamanho** (validador): corpo ~5.180 tokens (briefing ~3.230, plano ~3.350, edição ~3.970 por marcadores); referências ~12.040 tokens (auditoria ~2.870, crítica ~4.020, modos ~5.130). No briefing entram só as duas primeiras referências (cabem nos 8 mil); os modos ficam para plano e edição.
- **Não duplica** a `fab-agencia` (site novo com direção de arte e motion de agência): esta parte do que existe e sugere a `fab-agencia` ao dono quando o pedido é efeito de vitrine.

## Origem e licenças

| Fonte | Repositório | Licença | Aviso |
|---|---|---|---|
| taste-skill, `redesign-skill/SKILL.md` e a seção 11 (Redesign Protocol) do `taste-skill/SKILL.md` | https://github.com/Leonxlnx/taste-skill (commit c184364) | MIT | Copyright (c) 2026 Leonxlnx |
| impeccable, `skill/SKILL.md` e `reference/` (critique, audit, polish, harden, onboard, clarify, distill, quieter, bolder, adapt, optimize, colorize, typeset, layout, animate, delight, craft-floor, operate, routing, overdrive) | https://github.com/pbakaus/impeccable (commit edb9c7f) | Apache 2.0 | Copyright 2025 Paul Bakaus. Obra derivada: texto reescrito em português e adaptado à Fabapp; nenhum arquivo original é redistribuído. O NOTICE do projeto credita ehmo/platform-design-skills (MIT) pelas referências ios.md e android.md, que não foram usadas aqui. |
| wondelai ux-heuristics, `SKILL.md` e `references/` (krug-principles, nielsen-heuristics, audit-template, heuristic-conflicts, dark-patterns, wcag-checklist, cultural-ux) | https://github.com/wondelai/skills (commit c172996, caminho ux-heuristics) | MIT | Copyright (c) 2025 Wondel.ai sp. z o.o. |

Análises usadas: `analise/01-design.md` (seções 2 e 3) e `03-sites-apps-layout/ANALISE.md`.

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| taste 11.A: detectar o modo (greenfield, preservar, repaginar); perguntar uma vez se ambíguo | SKILL, regra 1; briefing (pergunta com opções); edição passo 1 (pergunta no plano da edição) | greenfield vira "é um app novo, a IA diz ao dono"; a pergunta vai como opções clicáveis |
| taste 11.B: auditar antes (tokens de marca, arquitetura, blocos, o que preservar e aposentar, leitura de ousadia/movimento/densidade, SEO) | SKILL, regra 2; edição passo 2; `auditoria.md` | "dials" viram "nível atual de ousadia, movimento e densidade"; SEO vira títulos de página e rotas públicas |
| taste 11.C: preservar arquitetura, cores da marca, voz, acessibilidade, eventos de analytics | SKILL, regra 4 | eventos = `trackEvent`; voz = tratamento e tom |
| taste 11.D: alavancas em ordem de risco (tipografia, espaço, cor, movimento, recomposição, troca de bloco) | SKILL, regra 3 | tipografia por classes (família é da marca); cor pelo patch de tema |
| taste 11.E: árvore evolução pontual x redesign completo (70% do valor com 40% do risco) | SKILL, regra 1 | igual |
| taste 11.F: o que nunca muda em silêncio (URL, rótulos da navegação, campos, logo, textos legais) | SKILL, regra 4 | acrescentados textos do dono, ids do schema, `trackEvent`, voz, títulos indexados |
| redesign-skill: Scan, Diagnose, Fix sem reescrever | edição passos 2 a 4 | leitura com `read_file`, mudança com `edit_file` |
| redesign-skill: auditoria por categoria (tipografia, cor e superfícies, layout, interatividade e estados, conteúdo, componentes, iconografia, qualidade de código, omissões estratégicas) | `auditoria.md` seções 1 a 8 | cada item traduzido para classes Tailwind, tokens e componentes do kit |
| redesign-skill: trocar fonte por Geist/Satoshi etc. | `auditoria.md` 1; SKILL "Como mudar cor, fonte e marca" | trocado: fonte é da marca; vira sugestão ao dono (aba Marca) |
| redesign-skill: textura de ruído, gradiente radial, imagem de fundo do picsum | `auditoria.md` 2 (seção vazia) | trocado: `AppImage` com véu ou fundo de tom da marca; picsum proibido (URL externa, nada a ver com o negócio) |
| redesign-skill: dados "bagunçados" (47,2%), datas aleatórias | `auditoria.md` 6 | trocado: número sai dos dados ou é exemplo marcado (regra Nada inventado) |
| redesign-skill: Lucide é genérico, usar Phosphor | `auditoria.md` 4; edição passo 4 | trocado: `lucide-react` é a biblioteca da plataforma; a regra vira traço e tamanho consistentes e metáfora não gasta |
| redesign-skill: técnicas de upgrade (fonte variável animada, contorno que preenche, máscara de texto, grade quebrada, pilha com parallax, tela dividida, rolagem com inércia, mola, vidro real, borda spotlight, grão, sombra tingida) | `modos-do-dono.md` Ousado (componentes do kit) | parcial: o que o kit de motion faz entra; o resto é sugerido ao dono via `fab-agencia` |
| redesign-skill: prioridade de conserto (fonte, cor, hover, layout, componentes, estados, escala) | SKILL regra 3 e passo 3 (triagem) | fundida com a triagem do polish |
| redesign-skill: regras (pilha existente, não quebrar, conferir dependência, Tailwind v3/v4, mudanças pequenas) | edição passo 4 | Tailwind v4 é fixo na plataforma |
| redesign-skill: favicon, meta tags, cookie consent | `auditoria.md` 7 e 8 | favicon e meta vêm da marca e do SEO da plataforma (`<FabHead>`); consentimento: texto legal é do dono, nunca inventado |
| impeccable: princípios (verificar em passadas limitadas) | SKILL, regra 8; edição passo 5 | a rodada extra é a única; o QA automático da plataforma faz o resto |
| impeccable: "o briefing vence"; refinamento preserva, redesign substitui; nunca dividir a diferença | SKILL, regras 1 e 5 | igual |
| impeccable: modos Persuade, Operate, Read, Experience por superfície | SKILL, regra 7 | Vender, Operar, Ler, Mostrar; casados com os registros editorial e produto da plataforma |
| impeccable: tabela de comandos e roteamento | SKILL, tabela "O que o dono pode pedir"; `modos-do-dono.md` | comandos viram frases do dono em português; o cardápio de próximos passos sai em `next_steps` |
| impeccable critique: avaliação A (design) e B (detector) isoladas em subagentes | edição passo 2 | trocado: julgamento de design antes da varredura mecânica (mesma função de não ancorar); o detector é o QA automático da plataforma |
| impeccable critique: veredito de especificidade, Nielsen 0 a 4 com n/a, faixas, carga cognitiva, jornada emocional, personas, achados P0 a P3, perguntas no fim com opções, pular pergunta com menos de 3 achados | `critica-e-heuristicas.md` | personas com nomes brasileiros; jornada emocional coberta por "Personalidade" e pelo tom em Clarear |
| impeccable critique: snapshot persistido, tendência, lista de ignorados, overlay no navegador | edição passo 6 (achados no `finish`) | trocado: não há disco nem navegador; o histórico fica na conversa e os próximos pedidos em `next_steps` |
| impeccable audit: 5 dimensões 0 a 4, total 20, faixas, padrões sistêmicos, achados positivos | `auditoria.md` "Nota técnica" | igual, com critérios da plataforma |
| impeccable polish: classificar desvio, evidência, triagem, polir o caminho inteiro, verificar | SKILL passo 3; `modos-do-dono.md` Polir | igual |
| impeccable harden: texto, número, quantidade extremos; erros de rede e API; i18n; estados; gestos interrompidos | `modos-do-dono.md` Endurecer | formatos BR (R$, dd/mm/aaaa, 24h, telefone, CEP, CPF, CNPJ), códigos do `ApiError` (401, 402, 403, 404, 409, 422, 429, 500) |
| impeccable harden: RTL, CJK, alemão | README (fora) | fora: apps em português; a expansão de 20 a 30% do português em relação ao inglês ficou |
| impeccable harden: modo offline, service worker | `modos-do-dono.md` Endurecer | trocado: offline não é suportado; mensagem e Tentar de novo |
| impeccable onboard: momento aha, mostrar e não contar, opcional, estados vazios por tipo, tour 3 a 7 passos, não repetir | `modos-do-dono.md` Primeiro uso | "já visto" em `localStorage`; lista de primeiros passos calculada pelos dados |
| impeccable clarify: hierarquia da mensagem, reescrever por função, voz, localização | `modos-do-dono.md` Clarear | glossário vai para `update_knowledge` |
| impeccable distill: fontes de complexidade, essência, simplificar em 6 dimensões, nunca remover função necessária | `modos-do-dono.md` Destilar | remover função exige o sim do dono (regra de não esconder mudança) |
| impeccable quieter e bolder: modo de visitante, fontes de intensidade, escopo soberano, teste do esqueleto | `modos-do-dono.md` Calmo e Ousado | saturação só pelo tema e com o sim |
| impeccable adapt: celular, tablet, desktop, toque, navegação, testes | `modos-do-dono.md` Adaptar | impressão e e-mail HTML fora (o e-mail do app é texto puro via `notify`); `ScrollRow`, abas embaixo |
| impeccable optimize: medir, imagens, bundle, render, animação, rede, Web Vitals | `modos-do-dono.md` Otimizar | trocado: não há Lighthouse; metas como referência e aviso honesto de que não foi medido; paginação e `fields` do SDK |
| impeccable colorize, typeset, layout, animate, delight | `modos-do-dono.md` Colorir, Legível, Layout, Movimento, Personalidade | parâmetros do modo live fora (não há navegador) |
| impeccable craft-floor: verificar e recusar (cards iguais, métrica de herói, eyebrow, números de seção, texto em gradiente, borda lateral, sombra dura, emoji como ícone) | `auditoria.md` 2 a 4 | igual; eyebrow mantido como proibição |
| impeccable operate: fonte única, escala 1,125 a 1,2, estados completos, 150 a 250ms, modal por último | `modos-do-dono.md` Movimento e Legível; `auditoria.md` 4 e 5 | igual |
| impeccable overdrive, live, generate, shape, init, document, extract, hooks, doctor, pin | fora | ferramentas de terminal, navegador ao vivo e arquivos de contexto que a Fabapp não tem; o contexto duradouro é o manual do app (`update_knowledge`); overdrive é sugerido via `fab-agencia` |
| ux-heuristics: Krug (não me faça pensar, cliques, cortar metade das palavras, porta-malas), boa vontade, página inicial, frase de apresentação, teste de custo zero | `critica-e-heuristicas.md` Krug | teste de uso vira sugestão ao dono em `next_steps` |
| ux-heuristics: Nielsen com exemplos, violações e gravidade; escala 0 a 4 com frequência, impacto e persistência | `critica-e-heuristicas.md` | casada com P0 a P3 |
| ux-heuristics: diagnóstico rápido e nota 10/10 | `critica-e-heuristicas.md` Diagnóstico rápido | igual |
| ux-heuristics: erros comuns (navegação misteriosa, escolhas demais, sem "você está aqui", validação, alvos pequenos, hover, desfazer, contraste, botão voltar) | `auditoria.md`, `critica-e-heuristicas.md` diagnóstico e acessibilidade | igual |
| ux-heuristics: conflitos entre heurísticas e documento de decisão | `critica-e-heuristicas.md` Conflitos | o registro da decisão é a linha "qual heurística e por quê" no relatório |
| ux-heuristics: padrões enganosos e regulação | `critica-e-heuristicas.md` Padrões enganosos | GDPR, FTC e CPRA trocados pela LGPD |
| ux-heuristics: checklist WCAG 2.1 AA e ferramentas | `critica-e-heuristicas.md` Acessibilidade | axe, WAVE e leitores de tela fora (sem navegador); critérios conferíveis no código ficam |
| ux-heuristics: UX cultural (cores por cultura, RTL, nomes, endereço, telefone, datas, moeda) | `modos-do-dono.md` Endurecer; `auditoria.md` | só o Brasil: nome completo em um campo, CEP, telefone, datas e moeda locais; RTL e cores por cultura fora |
| ux-heuristics: quando usar cada método (heurística, teste, A/B, analytics) | `critica-e-heuristicas.md` Krug | A/B fora (a plataforma não tem teste A/B) |

## O que ficou de fora ou foi trocado, e por quê
- **Ferramentas de terminal e navegador** (binário do impeccable, detector, overlay, Playwright, subagentes, arquivos PRODUCT.md e DESIGN.md): o gerador da Fabapp não executa nada. O detector virou o QA estático e visual que a plataforma já roda depois do build; o contexto duradouro virou o manual do app.
- **Troca de fonte e raio pelo código**: a família e o raio são da marca; num app existente só o dono troca, na aba Marca. A skill orienta o dono. `set_brand` só define logo e nome.
- **Medição real** (Lighthouse, Web Vitals, aparelho real, gestos com toque sintetizado): não há navegador na edição. A skill manda dizer o que não foi medido.
- **RTL, CJK, cores por cultura**: fora do público (apps brasileiros).
- **overdrive, live, generate**: efeitos de vitrine e iteração ao vivo; sugeridos ao dono via `fab-agencia`.
