# Modelo de Dados (`fab-modelo-de-dados`)

## Edição terminal

Esta é a edição para agentes que constroem pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio. O que mudou:

- Topo com primeiro movimento (`references/fabapp-cli.md`), contrato ao vivo e a regra das duas mãos.
- Briefing virou "A conversa" (ferramenta de perguntas de opção do agente, ou opções numeradas); o glossário e as etapas vão para `DECISOES.md` em vez do prompt entregue ao construtor do Studio.
- O plano é texto no terminal mostrado ao dono antes de codar; os critérios de aceite viraram a lista de conferência, sem teto, marcados "(código)" ou "(tela)"; `assumptions` viraram as suposições do plano.
- O schema é o arquivo `fab.schema.json` (`fabapp pull`, editar, `fabapp push`), com a mesma gramática de modelos e `access`. A automação do histórico ganhou o exemplo em `fab.automations.json` (sempre `pull` antes do `push`).
- Mover dados em mudanças de modelo: o CLI não grava registros; o dono faz no CMS do Studio ou numa tela de admin do app. `update_knowledge` virou `DECISOES.md`.
- O diagnóstico final ganhou a conferência prática (`push`, `grep` da palavra antiga, registro de teste passando por cada transição na pré-visualização).
- `mermaid` no app entra com `npm install` dentro de `.fabapp/workspace`.

Faz o app nascer com o modelo de dados na linguagem do negócio: glossário antes das tabelas, ciclos de vida com transições, histórico, regras de duplicidade e exclusão, e fatos separados de cadastros para relatório, tudo no schema real da Fabapp.

- **Categoria**: other
- **Etapas**: briefing, plan, build, edit
- **Tamanho aproximado** (validador): corpo ~4.990 tokens (briefing ~1.240, plano ~2.470, construção ~2.860, edição ~1.400); referências ~5.800 tokens (cabe no limite de 8 mil do briefing).

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| domain-driven-design | https://github.com/wondelai/skills (caminho `domain-driven-design`, commit c172996) | MIT, Copyright (c) 2025 Wondel.ai sp. z o.o. |
| database-schema-designer | https://github.com/softaworks/agent-toolkit (`skills/database-schema-designer`, commit 3027f20) | MIT |
| mermaid-diagrams | https://github.com/softaworks/agent-toolkit (`skills/mermaid-diagrams`, commit 3027f20) | MIT |
| modeling-dimension-tables | https://github.com/PostHog/skills (`skills/omnibus/modeling-dimension-tables`, commit f89d437) | MIT, Copyright (c) 2025 |

Texto reescrito (obra derivada permitida pelas licenças MIT). Avisos de licença MIT: "Permission is hereby granted, free of charge, to any person obtaining a copy of this software... The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."

## Verificações na plataforma que moldaram a skill

- O plano (`studio/src/vibe/Markdown.tsx`) renderiza títulos, listas, negrito e tabelas, mas não bloco de código nem mermaid: por isso os diagramas vão como tabelas e listas de relações.
- O servidor filtra só por campos do schema e por `created_by`/`owner_id`/`user_id` (`appapi/service.py`): `created_at` ordena mas não filtra, e `id` não é filtrável. Daí a regra "todo fato tem data própria".
- Registro devolve `id`, `created_at`, `created_by`; não há `updated_at` exposto.
- Automações não têm condição (`automations.md`): daí o modelo de histórico com automação `data created` e os avisos condicionais no código da ação.

## Mapa de cobertura

| Função/técnica da original | Onde está | Adaptação |
|---|---|---|
| DDD: linguagem ubíqua, glossário vivo, "nome difícil = modelo errado" | Regras 1 e 2; plano passo 1; edição (renomear) | Glossário no plano; `update_knowledge` guarda a palavra escolhida |
| DDD: tradução custa caro, tabela de mal-entendidos | Regra 1, erros comuns (ref. padrões) | Um conceito, uma palavra em menu, coluna, botão e schema |
| DDD: whirlpool (cenário, conceitos, negociação de nomes, protótipo, retorno) | Briefing (perguntas com a palavra do dono) e plano passo 1 | Perguntas com opções no lugar de sessões de modelagem |
| DDD: evolução da linguagem e refatoração ao mudar termo | Edição: renomear rótulo, nunca id | Sem migração: id fixo, rótulos e textos trocados |
| DDD: armadilhas de jargão, abreviação, sinônimos, persistência | Ref. padrões, "Armadilhas de nome" | Igual |
| DDD: contextos delimitados, mesmo termo com sentidos diferentes, sinais de fronteira | Plano passo 2 | Em app de PME: modelo por conceito, áreas por tela e papel; dois modelos só com ciclos diferentes |
| DDD: nove padrões de mapeamento de contexto (Shared Kernel, ACL, OHS, Conformist, etc.) | Build "dado que chega de fora é traduzido"; erros comuns "dado externo cru" | Só a Camada Anticorrupção tem uso real num app gerado (integrações, planilha, IA). Os demais tratam de relação entre times e ficaram de fora |
| DDD: entidade vs valor (testes de identidade e atributo), preferir valor | Plano passo 3; ref. padrões "Entidade, valor, agregado" | Valor vira campos ou `json`; entidade vira modelo |
| DDD: agregados pequenos, invariantes na raiz, referência por id, consistência eventual | Plano passo 3; ref. padrões; build "valores derivados" | `ref` no filho, total recalculado no único caminho de escrita, regra entre agregados com `count` |
| DDD: eventos de domínio no passado, específicos, payload na medida | Plano passo 7; ref. diagramas "Eventos de domínio" | Modelo `<modelo>_event` imutável |
| DDD: outbox, entrega pelo menos uma vez, idempotência | Ref. diagramas (gravar evento só após o update; `LoadingButton`; `count` antes) | Sem fila própria na plataforma |
| DDD: event sourcing | Ref. diagramas ("não reconstrua o estado a partir dos eventos") | Fora: estado atual no registro, histórico só explica |
| DDD: sagas e ações compensatórias | Ref. diagramas, último item de eventos | Passo a passo no código da ação ou função, com desfazer explícito |
| DDD: repositórios com nomes do domínio, fábricas que nunca criam inválido, especificações | Build "Consultas e criação com nome do negócio" | Funções em `src/lib/<modelo>.ts`, filtros nomeados, criação com validação |
| DDD: subdomínio principal, de suporte e genérico; comprar o genérico | Plano passo 4 | Genérico = recursos da plataforma (login, pagamento, e-mail) |
| DDD: nota de 0 a 10 com diagnóstico rápido | Seção final "Diagnóstico antes de dizer pronto" | 10 itens conferíveis, faixas 9-10 / 5-6 / 3 |
| DDD: erros comuns (modelo único, agregado gigante, anêmico, sem ACL) | Ref. padrões "Erros comuns" | Exemplos de PME |
| DDD: investimento por fase, alocação de time, Conway | Fora | Tratam de organização de equipes de engenharia, sem equivalente num app gerado |
| Schema designer: 4 fases (análise, design, otimização, migração) | Ordem do plano (passos 1 a 9) e build | Migração vira "nunca trocar id" |
| Schema designer: normalizar até 3FN, desnormalizar com motivo | Plano passo 5; ref. padrões "Normalização na medida" | Três casos de desnormalização (cópia congelada, total gravado, resumo) |
| Schema designer: "domain modeling over UI" | Regras e passo 1 | O schema nasce do glossário |
| Schema designer: tipos certos (DECIMAL para dinheiro, datas como data) | Regra 5; ref. padrões "Dado → tipo" | `money`, `date`, `datetime` |
| Schema designer: PK, FK sempre, ON DELETE caso a caso | Build "Exclusão"; plano passo 6 | Política em código: bloquear, apagar junto, deixar vazio |
| Schema designer: UNIQUE, CHECK, NOT NULL, DEFAULT | Ref. padrões "O que não existe" | `count`, `zod`, `required`, valor inicial no código |
| Schema designer: índices por padrão de acesso | Ref. padrões | Não se aplica: filtro/ordem no servidor; o equivalente é filtrar no servidor sempre |
| Schema designer: created_at/updated_at | Ref. padrões | `created_at` automático; "alterado por" no histórico |
| Schema designer: 1:N, N:N por junção, auto-referência, polimórfico | Ref. padrões "Modelos de JSON" | Junção `enrollment`, `parent`, dois `ref` opcionais + zod |
| Schema designer: embutir vs referenciar (NoSQL) | Ref. padrões "Guardar junto ou separado" | `json`/`list` vs modelo filho |
| Schema designer: migrações reversíveis, zero downtime | Edição | Sem migração; troca de etapa com `updateWhere`, mudanças destrutivas explicadas ao dono |
| Schema designer: segurança (menor privilégio, dados sensíveis) | Build "Dado sensível"; regra 9 | `access` por ação |
| Schema designer: N+1, paginação, agregações pré-calculadas | Build "Datas do negócio"; ref. diagramas "Totais pesados" | `__label` evita buscar o pai; modelo de resumo |
| Schema designer: checklist de verificação | Diagnóstico final | Itens equivalentes na plataforma |
| Schema designer: SQL e templates de migração, EXPLAIN | Fora | Não há SQL nem migração no app gerado |
| Mermaid: guia de escolha de diagrama por propósito | Ref. diagramas, primeira tabela | Formato no plano sem mermaid |
| Mermaid: ERD com cardinalidade, estados, sequência com alt, fluxograma | Plano "Diagramas"; ref. diagramas (sintaxe para uso no app) | Plano não renderiza mermaid (conferido); diagrama no app com pacote `mermaid` se o dono pedir |
| Mermaid: um diagrama por conceito, dividir os grandes, nomes claros, comentários `%%`, armadilhas de sintaxe | Ref. diagramas | Igual |
| Mermaid: temas e cores | Ref. diagramas | Só tema `neutral`; sem hex (regra do QA) |
| Mermaid: C4, arquitetura, git graph, gantt, pizza, exportação | Fora | Arquitetura técnica não interessa ao dono; gráficos são da skill de painéis |
| PostHog: fato longo e somável, dimensão curta, uma linha por entidade | Plano passo 8; ref. diagramas "Fatos e cadastros" | Catálogo de fatos e cadastros por ramo |
| PostHog: chave única na dimensão (fan-out) | Ref. diagramas regra 1 | `count` antes de criar, juntar duplicados |
| PostHog: nomes limpos e estáveis | Ref. diagramas regra 6 | Ids de campo de filtro fixos |
| PostHog: dimensão de data materializada | Ref. diagramas "Calendário" | `src/lib/calendar.ts` com feriados nacionais e dias úteis |
| PostHog: materializar em cadência lenta | Ref. diagramas "Totais pesados" | Modelo de resumo atualizado na escrita ou por função acionada |
| PostHog: registrar e certificar, evitar cópia rival | Ref. diagramas "Uma definição por número" | `src/lib/metrics.ts` |
| PostHog: moeda embutida (não criar tabela de câmbio) | Ref. padrões | `money` + `currency` do app |
| PostHog: recipes HogQL e dbt, joins salvos | Fora | Ferramentas do PostHog/dbt sem equivalente; o `ref` com `__label` faz o papel do join |
| Análise 02: glossário antes das tabelas, uma palavra em menus/colunas/botões/banco | Regras e plano | Igual |
| Análise 02: máquina de estados com transições, quem executa, evento disparado | Plano passo 7; build `-flow.ts` | Com os limites de automação da plataforma |
| Análise 02: dinheiro decimal, created/updated, exclusão lógica, política de exclusão, `tenant_id` | Regra 5, build, ref. padrões | `tenant_id` vira `organization` + `members` canônicos |
| Análise 02: mostrar ER e estados ao leigo antes de gerar | Plano "Diagramas" | Como tabelas no plano |
| Análise 01 §10: fato vs dimensão, calendário com feriados brasileiros | Ref. diagramas | Igual |
