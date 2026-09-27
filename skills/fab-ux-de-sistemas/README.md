# UX de Sistemas e Painéis (`fab-ux-de-sistemas`)

## Edição terminal

Esta é a edição para agentes que constroem pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio. O que mudou:

- Topo com primeiro movimento (`references/fabapp-cli.md`), contrato ao vivo e a regra das duas mãos; `DECISOES.md` guarda as decisões de interface.
- Marca: no terminal o agente DEFINE cor, fonte e raio no `apps/<slug>/fab.config.json → theme` (proposta aprovada pelo dono, `fabapp push`). A direção visual do plano, que no Studio ia para `brand{tone,color,reference}`, vira essa proposta de tema. Logo continua com o dono no Studio. No código, só tokens.
- Referências a `fab-padroes-brasil`, `fab-direcao-de-arte`, `fab-dados-seguros` e `fab-spec-de-sistema` viraram recomendação ("se estiver instalada"), com a regra essencial escrita aqui.
- Plano mostrado ao dono antes de codar; critérios de aceite viraram a lista de conferência, sem teto.
- A conferência final ganhou a pré-visualização do `fabapp dev`, a busca por texto do que a plataforma proíbe e a publicação com tratamento de `build_failed` (422) e `account_builds_busy` (409).

Fecha as decisões de estrutura, telas, estados, avisos, busca e acabamento de painéis administrativos, CRMs e sistemas internos gerados pela Fabapp, com o kit de UI e o SDK reais.

- **Categoria**: other
- **Etapas**: plan, build, edit
- **Tamanho aproximado** (validador): corpo ~4.270 tokens (plano ~1.980, construção ~2.980, edição ~1.490); referências ~6.570 tokens.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| ux-designer (SKILL.md e as 29 referências) | https://github.com/szilu/ux-designer-skill (commit 3f05899) | MIT, Copyright (c) 2026 Szilárd Hajba |
| interface-design | https://github.com/Dammyjay93/interface-design (`.claude/skills/interface-design`, commit 2f9be32) | MIT, Copyright (c) 2026 Damola Akinleye |
| information-architecture | https://github.com/julianoczkowski/designer-skills (`information-architecture`, commit c259656) | Apache-2.0 |

Texto reescrito como obra derivada. Licenças MIT: "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." Apache-2.0: esta skill é uma obra derivada com alterações (reescrita em português e adaptada à plataforma Fabapp); a licença completa está em http://www.apache.org/licenses/LICENSE-2.0.

## Verificações na plataforma que moldaram a skill

- `DataTable` do kit busca, ordena e pagina no navegador e não tem seleção: por isso fica só para listas pequenas e fechadas; a tabela de trabalho é `Table` + `Checkbox` + `Pagination` com `list`/`count` no servidor.
- O servidor não filtra por `id`: excluir uma seleção de ids é `remove` em sequência; `deleteMany`/`updateWhere` só por filtro de campo; `updateMany(ids)` para editar em lote.
- `Stepper` esconde os nomes das etapas abaixo de `sm`: daí o texto "Etapa 2 de 4: Endereço".
- Cores e fontes vêm da marca; a direção visual do interface-design vira `brand{tone,color,reference}` no plano. Na edição, cor muda pelo patch de tema; fonte e raio o dono troca na aba Marca; `set_brand` só troca logo e nome.

## Mapa de cobertura

| Função/técnica da original | Onde está | Adaptação |
|---|---|---|
| szilu: filosofia (calma, julgamento, IA como copiloto) | Decisões fixas; build "Recurso de IA" | |
| szilu: fluxo de revisão (contexto, ver de verdade, extremos, achados por impacto) | Edição (pedido vago) e "Conferência antes do finish" (320 px, teclado, estados) | Renderizar e rodar axe viram a abertura no navegador e a revisão visual que a plataforma já roda; achados viram correções |
| szilu: fluxo de construção (reusar, todos os estados, semântica primeiro, verificar olhando) | Build "Use o que existe", "Estados", conferência | |
| szilu: padrões de UI gerada por IA a evitar | Build "Vícios de interface gerada por IA" | Lista completa |
| szilu: regras centrais visuais, interação, formulários, navegação, acessibilidade | Decisões fixas 2, 3, 6; build formulários; ref. acabamento | |
| szilu: árvore modal / painel / página | Decisão fixa 6 | `Dialog`, `Sheet`, página, `Stepper` |
| szilu: árvore de tipo de notificação | Decisão fixa 8; ref. estados "Avisos por gravidade" | `AlertDialog`, `Alert`, sonner, `useNotifications` |
| szilu: valores de referência (alvo, contraste, latência, transições, toast, debounce) | Ref. estados (tempos), ref. acabamento (contraste, alvos, movimento), ref. tabelas | |
| szilu 01 heurísticas de Nielsen, princípios, hierarquia | Ref. acabamento "Princípios" | Uma linha aplicada por heurística |
| szilu 02 leis de UX (Fitts, Hick, Miller/Cowan, Jakob, pico e fim, Tesler, Gestalt, Doherty, Zeigarnik etc.) | Ref. acabamento "Leis úteis" | |
| szilu 03 acessibilidade WCAG 2.2 (critérios novos, contraste, teclado, formulários, movimento) | Ref. acabamento "Acessibilidade" | Critérios citados por número. Legislação (EAA, ADA) fora: público brasileiro; a meta WCAG 2.2 AA fica |
| szilu 04 design visual (cor, tipografia, espaço, grid) | Ref. acabamento "Hierarquia" | Psicologia das cores e harmonias ficam fora: cor vem da marca |
| szilu 05 arquitetura de informação (estruturas, navegação, rótulos, card sorting, erros de IA) | Plano passo 3; decisões 3 e 4 | Card sorting e tree testing viram agrupamento mental no plano (não há pesquisa com usuários) |
| szilu 06 interação (microinterações, estados de feedback, animação, gestos, movimento reduzido) | Ref. acabamento "Movimento"; ref. estados | Háptico fora (app web; casca nativa é configurada depois) |
| szilu 07 formulários (rótulos, validação, obrigatórios, etapas, botões) | Build "Formulários" | Etapas longas são tema da skill de formulários, citada só como sugestão |
| szilu 08 mobile (polegar, alvos, barra inferior, safe area) | Decisão 3; ref. tabelas "Celular"; conferência | |
| szilu 09 escrita de interface | Ref. estados "Textos modelo" | Em português |
| szilu 10 pesquisa com usuários | Fora | Não há pesquisa no fluxo do gerador; o equivalente é o plano com critérios de aceite e a revisão automática da plataforma |
| szilu 11 design systems e tokens | Decisão 10; build (componente no segundo uso) | Tokens do tema da plataforma |
| szilu 12a/12b colaboração, presença, conflitos, offline, permissões | Ref. estados (409, 403, dados antigos); decisão de offline | Presença e cursores fora (sem recurso na plataforma); offline não suportado |
| szilu 13a/13b canvas e quadro branco | Fora | Fora do escopo de painéis; quadro kanban recebe só a alternativa ao arrastar |
| szilu 14 padrões de IA | Build "Recurso de IA dentro do sistema" | Rotular, revisar, cancelar, desfazer |
| szilu 15 ética e padrões obscuros | Ref. acabamento "Ética de interface" | Regulação estrangeira fora |
| szilu 16 onboarding | Decisão 7 (vazio com próxima ação) | O onboarding completo fica para a skill de formulários e onboarding, sugerida ao dono |
| szilu 17 notificações (tipos, gravidade, canais, central, permissão, preferências) | Ref. estados "Avisos por gravidade" | Push com `EnablePushButton`; preferências em `appUser.fields` |
| szilu 18 visualização e painéis | Ref. acabamento "Dados na tela inicial" | Resumo; gráficos em profundidade são da skill de painéis |
| szilu 19 busca (caixa, autocompletar, facetas, zero resultado) | Build "Busca"; ref. estados "Busca" | Busca por voz e IA fora |
| szilu 20 design emocional e confiança | Ref. estados (voz, erro sem culpa); ref. acabamento (pico e fim) | Selos e prova social ficam fora (sistema interno) |
| szilu 21 tabelas (layout, ordenação, filtros, paginação, massa, expansão, vazios, barra, a11y, métricas, anti-padrões) | Ref. tabelas inteira | Receita com `useSearchParams`, `list`, `count` |
| szilu 22 desempenho percebido (limiares, skeleton, otimista, CLS, stale) | Ref. estados; build "Estados" | Pré-carregamento e métricas Web Vitals ficam com a plataforma |
| szilu 23 i18n | Decisão 9 (formato brasileiro) | RTL e plurais complexos fora: apps em português |
| szilu 24 voz e multimodal | Fora | Sem entrada por voz na plataforma |
| interface-design: o problema do padrão, onde os padrões se escondem | Plano passo 2; conferência "Troca" | |
| interface-design: intenção primeiro (quem, verbo, sensação) | Plano passo 1; build "Antes de escrever cada tela" | Checkpoint no raciocínio, não no app |
| interface-design: exploração do domínio (5 conceitos, mundo de cores, assinatura, 3 padrões rejeitados) | Plano passo 2 | Cores viram `brand.reference`; a paleta final é da marca |
| interface-design: renderizar a direção | Trocado | Sem ferramenta de render no gerador; a plataforma abre o app e faz revisão visual |
| interface-design: hierarquia (um ponto focal, escala por razão, peso vence tamanho, densidade em px, ritmo, proporções, 60/30/10) | Decisão 2; ref. acabamento "Hierarquia" | Classes Tailwind e tokens |
| interface-design: camadas sutis, bordas, teste do olhar embaçado | Ref. acabamento "Superfícies"; conferência | |
| interface-design: expressão infinita, a cor mora em algum lugar | Plano passo 2; vícios de IA | |
| interface-design: usar o que existe (nativo, primitivo, feito à mão; sistema, componente, token, utilitário) | Build "Use o que existe" | Mapa do kit |
| interface-design: essenciais de design system (tokens, 4 níveis de texto, espaçamento, profundidade única, raio, controles, modo escuro) | Ref. acabamento; decisão 10 | Modo escuro e raio base vêm do tema da marca |
| interface-design: acabamento e movimento (raio concêntrico, tabular-nums, alvos, sombras, easing, duração) | Ref. acabamento "Superfícies" e "Movimento" | Sem hex e sem `font-family`; fonte da marca |
| interface-design: sugerir e perguntar | Plano (direção escrita no plano, que o dono aprova) | O plano é a confirmação |
| interface-design: testes troca, olhar embaçado, assinatura, tokens | "Conferência antes do finish" | Teste de tokens dispensado: nomes de token são da plataforma |
| interface-design: salvar `system.md` e checar consistência | Edição: `update_knowledge` | Memória do app no lugar do arquivo |
| interface-design: comandos de revisão e limpeza | Edição (pedido vago) | |
| information-architecture: ler o que já existe antes de propor | Edição (seguir padrão das vizinhas) | |
| information-architecture: entrevista com resposta recomendada (o que se faz mais, profundidade, o que cresce, tipos de usuário, tela dos 80%) | Decisão 1; plano passo 3 | A IA decide e registra; o dono aprova no plano |
| information-architecture: documento (mapa com URLs, navegação, hierarquia por tela, fluxos, glossário, reuso de componentes, crescimento, URLs) | Plano passo 3 e 4 | Reuso de componentes vira regra do build; URL com filtros em `useSearchParams` |
| Análise 02: tela dos 80% é a home; valores padrão (25 linhas, 300 ms, 7 a 10 colunas); quatro vazios; tabelas de trabalho; formulário por tamanho; densidade por ramo | Decisões fixas e referências | |
