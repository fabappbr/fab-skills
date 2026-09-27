# Código React de Qualidade (`fab-codigo-react`)

## Edição terminal

Esta é a edição para agentes que constroem pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio. O que mudou:

- Topo com primeiro movimento (`references/fabapp-cli.md`), contrato ao vivo e a regra das duas mãos; `DECISOES.md` lido no começo.
- Etapas do Studio viraram "A construção", "Mudanças depois" e "Conferir antes de dizer pronto". O `finish` virou a mensagem final ao dono.
- `pacote-sob-demanda`: no terminal as rotas ficam com import simples, porque o build da plataforma divide as rotas sozinho (contrato em `references/fabapp-cli.md`); `React.lazy` fica para componente pesado dentro da página.
- O QA do Studio não roda no `fabapp deploy`: a autorrevisão ganhou uma busca por texto (`grep`) do que a plataforma proíbe, `tsc -b`/`vite build` locais, a pré-visualização do `fabapp dev` e o tratamento de `build_failed` (422) e `account_builds_busy` (409).
- Tema: a paleta e o modo escuro são escritos pelo agente em `apps/<slug>/fab.config.json → theme` e enviados com `fabapp push`; no código continuam só tokens.
- Dependências entram com `npm install` dentro de `.fabapp/workspace` e sobem no `fabapp deploy`.

Regras de React para o código do app gerado pela Fabapp (SPA Vite, React 19.0, react-router v7 em `BrowserRouter`), por área e por impacto, com par Errado/Certo em TSX no estilo do código da Fabapp, dizendo o que bloqueia a entrega (CRITICAL/HIGH) e o que é melhoria (MEDIUM/LOW).

- **Categoria:** other
- **Etapas:** build, edit
- **Tokens (saída do validador):** corpo ~4.300; referências ~11.100 (`regras-completas.md`, `interface-web.md`, `transicoes.md`)

## Origem e licenças

| Fonte | Repositório | Licença |
|---|---|---|
| react-best-practices (SKILL.md, AGENTS.md, rules/) | https://github.com/vercel-labs/agent-skills (commit 063bee9) | MIT (declarada no README do repositório) |
| composition-patterns (inteira) | idem | MIT |
| react-view-transitions (SKILL.md, AGENTS.md, references/) | idem | MIT |
| web-design-guidelines (SKILL.md) e as regras que ela busca em `command.md` | https://github.com/vercel-labs/web-interface-guidelines | MIT, Copyright (c) 2025 Vercel Labs |

Texto reescrito em português e adaptado à plataforma; nenhum parágrafo copiado. Aviso MIT: "Permission is hereby granted, free of charge, to any person obtaining a copy of this software... The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." Avisos: web-interface-guidelines, "Copyright (c) 2025 Vercel Labs"; agent-skills declara MIT no README e não traz arquivo LICENSE, o autor é a Vercel.

Análise usada: `analise/02-codigo-e-processo.md` §1 (Vercel) e §5 (como escrever skill).

## Decisões de adaptação

- **Sem servidor React.** As categorias `server-` viraram regras sobre chamadas ao SDK (`dados-`) e sobre as funções de backend (`seg-funcao-autoriza`, `dados-funcao-sem-cascata`).
- **React 19.0 fixo.** `<Activity>`, `useEffectEvent` e `<ViewTransition>` não existem nessa versão e a plataforma proíbe trocar o React. Cada regra que dependia deles ganhou a alternativa real (`hidden`, handler em ref, `document.startViewTransition` com `flushSync`).
- **`BrowserRouter`.** A prop `viewTransition` do react-router é ignorada nesse modo e `useViewTransitionState`/`useBlocker` quebram (conferido no código do react-router 7.18 instalado no template). A skill proíbe os três.
- **QA da plataforma.** `await import(` e `<script src>` são recusados pelo QA; as regras de carregamento sob demanda usam `React.lazy` e `import().then`.
- **Sem arquivo de CSS novo.** As receitas de CSS de view transition viraram Web Animations API sobre os pseudo-elementos.
- **Impacto reclassificado onde o erro é visível ao usuário leigo:** `rendering-conditional-render` (o "0" na tela) era LOW e virou HIGH (`render-sem-zero`); `rerender-no-inline-components` e `rerender-derived-state-no-effect` viraram HIGH (`estado-`), porque são os erros reais do gerador apontados na análise. A área de acessibilidade é HIGH nos itens marcados.
- **Bloqueio x melhoria:** CRITICAL e HIGH entram na autorrevisão antes do `finish`; MEDIUM e LOW são aplicadas ao escrever e nunca justificam reescrever código que funciona.
- **Saída `arquivo:linha`** da web-design-guidelines virou a lista interna da autorrevisão; o dono recebe só o que foi conferido, em frase simples.

## Mapa de cobertura

### react-best-practices

| Regra original | Onde está | Adaptação |
|---|---|---|
| async-parallel | SKILL `dados-paralelo` | `Promise.all` com `collection().list/count` |
| async-dependencies | refs §1 `dados-dependencia-parcial` | encadeamento com `.then` (sem `better-all`, que seria dependência extra) |
| async-defer-await, async-cheap-condition-before-await | SKILL `dados-await-no-ramo` | exemplo com usuário e plano |
| async-api-routes | refs §1 `dados-funcao-sem-cascata` | dentro de `functions/<nome>.ts` |
| async-suspense-boundaries | SKILL `dados-casca-primeiro` | seções com carregamento próprio e `Skeleton`; exceções da original (layout, consulta pequena, conteúdo principal, pulo de layout) mantidas |
| bundle-barrel-imports | SKILL `pacote-import-nomeado` | `import *`, lodash, moment proibidos; `<Icon>` do kit só para ícone vindo de dado |
| bundle-dynamic-imports | SKILL `pacote-sob-demanda` | `React.lazy` em `routes.tsx` |
| bundle-conditional | refs §2 `pacote-condicional` | `import().then`, nunca `await import` (QA) |
| bundle-analyzable-paths | SKILL `pacote-sob-demanda` e refs §2 | mapa de funções com caminho literal |
| bundle-preload | refs §2 `pacote-pre-carregar` | `onMouseEnter`/`onFocus` no `<Link>` |
| bundle-defer-third-party | refs §2 `pacote-terceiros` | a plataforma injeta analytics; nunca snippet |
| server-auth-actions | SKILL `seg-funcao-autoriza` | ordem validar, autenticar (`ctx.user`), autorizar |
| server-cache-react, client-swr-dedup | refs §1 `dados-dedupe-entre-telas` | carregar uma vez no pai; cache de promessa em `src/lib` |
| server-cache-lru | refs §1 `dados-dedupe-entre-telas` | cache de módulo com prazo; funções não guardam memória entre chamadas |
| server-no-shared-module-state | SKILL `seg-cache-por-usuario` | limpar no logout (mesma aba, outra pessoa) |
| server-serialization | SKILL `dados-no-servidor` | projeção `fields` |
| server-parallel-fetching | refs §1 `dados-secoes-independentes` | seções irmãs buscam sozinhas |
| server-parallel-nested-fetching | refs §1 `dados-aninhado-por-item` e SKILL `dados-sem-n-mais-1` | `in` quando dá; encadear por item quando não dá |
| server-after-nonblocking | refs §1 `dados-sem-bloquear-a-resposta` | no cliente dispara sem esperar; na função aguarda tudo (contêiner para) |
| server-dedup-props | fora | não há fronteira RSC; o princípio (derivar no consumidor) está em `dados-secoes-independentes` |
| server-hoist-static-io | fora | função não guarda memória entre chamadas; o equivalente no cliente é `render-jsx-estatico` |
| client-event-listeners | refs §5 `cliente-ouvinte-unico` | |
| client-passive-event-listeners | refs §5 `cliente-ouvinte-passivo` | |
| client-localstorage-schema | SKILL `seg-armazenamento-local` e refs §5 | chave versionada, try/catch, migração |
| rerender-derived-state-no-effect | SKILL `estado-derivado-no-render` | HIGH |
| rerender-no-inline-components | SKILL `estado-componente-dentro` | HIGH, com os sintomas (foco, animação, efeito) |
| rerender-move-effect-to-event | SKILL `estado-acao-no-handler` | |
| rerender-functional-setstate | SKILL `estado-set-funcional` | |
| rerender-simple-expression-in-memo | SKILL e refs §3 | |
| rerender-defer-reads, memo, memo-with-default-value, dependencies, derived-state, split-combined-hooks, lazy-state-init, transitions, use-deferred-value, use-ref-transient-values | refs §3 | uma regra cada, com exemplo |
| rendering-conditional-render | SKILL `render-sem-zero` | HIGH |
| rendering-content-visibility | SKILL `render-lista-longa` | classes arbitrárias do Tailwind, paginação primeiro |
| rendering-activity | refs §4 `render-esconder-sem-desmontar` | `hidden` (sem `<Activity>` no 19.0) |
| rendering-usetransition-loading | refs §4 | |
| rendering-hydration-no-flicker | refs §4 `render-sem-piscar` | sem SSR: inicialização preguiçosa do estado |
| rendering-hydration-suppress-warning | fora | o app usa `createRoot`, não há hidratação |
| rendering-hoist-jsx, animate-svg-wrapper, svg-precision | refs §4 | |
| rendering-resource-hints | refs §4 | cabeçalho e fontes são da plataforma |
| rendering-script-defer-async | refs §2 `pacote-terceiros` | `<script src>` é recusado pelo QA |
| js-* (14 regras) | refs §6, tabela | todas as 14 |
| advanced-event-handler-refs, advanced-use-latest, advanced-effect-event-deps | refs §7 `avancado-handler-em-ref` | ref no lugar de `useEffectEvent` |
| advanced-init-once | refs §7 | |
| Categorias com prefixo e impacto, índice de uma linha, par Incorrect/Correct | SKILL (tabelas) | prefixos em português |

### composition-patterns

| Regra | Onde | Adaptação |
|---|---|---|
| architecture-avoid-boolean-props | SKILL `comp-` | exemplo com card de pedido |
| architecture-compound-components, state-context-interface, state-decouple-implementation | refs §8 `comp-composto-com-contexto` | `state/actions/meta`, provider local x `collection` |
| state-lift-state | refs §8 `comp-estado-icado` | os dois errados da original (efeito sincronizando, ref no envio) |
| patterns-explicit-variants | refs §8 | |
| patterns-children-over-render-props | SKILL e refs §8 | exceção do `renderItem` mantida |
| react19-no-forwardref | SKILL e refs §8 | `ref` como prop, `use()`, `<Contexto value>` |

### react-view-transitions

| Técnica | Onde | Adaptação |
|---|---|---|
| "Se não sabe dizer o que comunica, não use" | SKILL e refs `transicoes.md` | regra de entrada; transição é opcional |
| Tabela de prioridade (shared, suspense reveal, list identity, enter/exit, route) | refs, tabela | reveal virou `animate-in` (sem VT em carregamento) |
| Estilo por contexto (hierárquico, lateral, revalidação) | refs, tabela | |
| Disponibilidade e suporte de navegador | refs, primeira seção | sem canary; react-router ignorado |
| Fluxo de implementação em 7 passos (auditoria, CSS, casca, direcional, reveal, compartilhado, verificação) | refs, passo a passo 1 a 9 | helper `comTransicao`/`useNavegar` |
| Receitas de CSS (fade, slide, direcional, morph, reduced motion) | refs, helper | Web Animations API; tempos 150/210/400ms mantidos |
| Isolar elementos persistentes e flutuantes | refs passo 2 | `viewTransitionName` inline |
| Elemento compartilhado: nome único, um montado por vez, destino pronto, fallback, sem fade na saída, texto que vira borrão | refs passo 5 | |
| Layout displacement, slots fixos | refs passo 6 | |
| useOptimistic fora do instantâneo | refs passo 6 | rótulo muda antes da chamada |
| Indicador de aba deslizante | refs passo 8 | |
| Card expand/collapse com rolagem | refs passo 7 | |
| Tabela de tempos | refs, "Tempos" | |
| Troubleshooting | refs, lista de sintomas | só os que existem sem `<ViewTransition>` |
| Transition types, `addTransitionType`, eventos `onEnter` | refs, helper | direção como argumento do helper; animação no `ready` |
| router.back sem tipo | refs passo 3 | voltar do navegador troca sem animação (aceito) |
| Next.js (transitionTypes, prefetch, layouts) | parcial | prefetch virou "baixe o `lazy` antes de navegar"; o resto é específico do Next |
| Live root (`::view-transition-old(root) display:none`) | fora | exige CSS global que o app não escreve |
| Activity + ViewTransition | fora | sem `<Activity>` no React 19.0 |

### web-design-guidelines (command.md)

| Grupo | Onde | Adaptação |
|---|---|---|
| Accessibility, Focus States | SKILL `a11y-` e refs `interface-web.md` | itens [bloqueia] |
| Forms | refs | `useBlocker` proibido (BrowserRouter), `beforeunload` + `ConfirmDialog`; `DatePicker` |
| Animation | refs | `transition-all` proibido; `useReducedMotion` do kit; `animation-timeline` recusado |
| Typography | refs | `tabular-nums` [bloqueia]; reticências, aspas curvas, espaço inseparável |
| Content Handling, Images, Performance | refs | `AppImage`, paginação, `content-visibility` |
| Navigation & State | refs | `useSearchParams` com exemplo; `ConfirmDialog` ou "Desfazer" |
| Touch, Safe Areas, Layout | refs | `ScrollRow`, área segura da casca |
| Dark Mode & Theming | refs | é da plataforma e da marca; `Select` do kit no lugar de `<select>` |
| Locale & i18n | refs | `formatDate/formatMoney`, `translate="no"` |
| Hydration Safety | refs (campo controlado) | o resto não se aplica (sem SSR) |
| Hover & Interactive States | refs | |
| Content & Copy | refs | Title Case trocado por maiúscula só na primeira letra (padrão brasileiro); "você" |
| Anti-patterns | refs, última seção | |
| Formato de saída `file:line` | SKILL "Antes do finish" | lista interna, não vai ao dono |
| Buscar as regras frescas a cada revisão | trocado | o gerador não acessa a rede no build; as regras foram buscadas em 26/09/2026 e embutidas |
