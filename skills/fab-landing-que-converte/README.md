# Landing que Converte

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- Os modelos (`lead`, `testimonial`, `testimonial_submission`, `faq_item`, `conversion_event`, `business_profile`) vão no `fab.schema.json` e a automação de lead novo no `fab.automations.json` (`fabapp pull`/`push`).
- SEO: o agente escreve título, descrição, `pages`, `index: false` das rotas de admin e `ogImage` em `apps/<slug>/fab.config.json → seo`; `<FabHead>` só em rota dinâmica.
- Registros: o CLI não grava nem lê registros. Depoimentos, FAQ, números de prova e a configuração do teste A/B são cadastrados pelo dono (CMS do Studio ou painel de admin do app); no diagnóstico de "não converte", o agente pede ao dono os números da tela "Resultados da página".
- O aprendizado dos testes e as decisões vão no `DECISOES.md` na raiz do projeto (antes, memória do app no Studio). Nas referências, só essas menções mudaram.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Landing page construída a partir das dúvidas reais dos clientes do dono: funil medido no próprio app, tabela de objeção e resposta que decide blocos e ordem, prova no ponto de atrito, botão único e teste A/B com leitura honesta.

- **Categoria:** sites
- **Etapas:** briefing, plan, build, edit
- **Tokens (validador):** corpo ~4.770 (cada etapa recebe de ~1.500 a ~2.700); referências ~6.000 (cabem inteiras no briefing, limite 8.000)
- **Arquivos:** `SKILL.md`, `references/objecoes-e-provas.md`, `references/titulos-cta-e-testes.md`

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| cro-methodology (SKILL.md e as 6 referências: RESEARCH, PERSUASION, OBJECTIONS, COPYWRITING, funnel-analysis, testing-methodology) | https://github.com/wondelai/skills, `cro-methodology`, commit c172996 | MIT, Copyright (c) 2025 Wondel.ai sp. z o.o. |
| landing-page-copy (SKILL.md, hero-formulas, objection-library) | https://github.com/rampstackco/claude-skills, `skills/landing-page-copy`, commit 3d4510a | MIT, Copyright (c) 2026 RampStack Co. |

A metodologia CRO da original resume o livro "Making Websites Win" (Karl Blanks e Ben Jesson); aqui ficou só a técnica, reescrita em português. Análise consultada: `03-sites-apps-layout/ANALISE.md` (fichas 4 e 8).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Princípio "não adivinhe, descubra" | SKILL, abertura; briefing | O dono é a pesquisa (WhatsApp, balcão, avaliações) |
| Nota 0 a 10 com as 7 perguntas do diagnóstico rápido e faixas | SKILL, "Nota de 0 a 10" | Usada no plano, na edição e no `finish` |
| Processo de 9 passos (métrica, funil, pesquisa, inteligência, ICE, experimento, escala) | Plano (funil, tabela, medição), edição, `titulos-cta-e-testes.md` | Métrica de negócio = leads e fechamentos medidos com `count()` |
| Mapa do funil, artéria entupida, elo que falta, conta de impacto, 80/20, venda casada, visualização e vazamento | `titulos-cta-e-testes.md` "Funis"; plano item 1 | Funis de negócio pequeno; elos resolvidos com automações `data`/`relative` e páginas do app |
| Benchmarks de funil por setor | Mesma seção | Mantidos como referência internacional, nunca meta do dono |
| Atribuição multitoque (primeiro, último, linear...) | Mesma seção, "Origem" | Último toque por `utm_*` no lead; primeiro toque opcional no navegador; modelos avançados fora (sem volume de dado) |
| Pesquisa: fontes primárias e secundárias, perguntas de saída, pós-compra, navegação, e-mail, boas práticas de questionário | Briefing; `objecoes-e-provas.md` "Onde achar"; `titulos-cta-e-testes.md` "Pesquisa" | Pesquisa pós-compra vira página `/pesquisa` com uma pergunta, linkada no e-mail |
| Testes de usabilidade, 5 segundos, primeiro clique, gravações, mapas de calor e tabela achado → ação | `titulos-cta-e-testes.md` "Pesquisa"; critério visual de 5 segundos | Clarity ligado pelo dono no painel (a plataforma injeta; Hotjar não está integrado) |
| Entrevistas com clientes (quem, perguntas, dicas) | Briefing perguntas 3 e 5; "Pesquisa" | Resumidas nas perguntas que mais revelam |
| As 5 objeções universais e a tabela O/CO | SKILL plano item 2; `objecoes-e-provas.md` | Coluna "onde entra" e "formato" decidem blocos e ordem |
| Objeção implícita e "só a resposta" | Plano item 2; referência | Exemplo em português |
| Posicionamento: ponto de atrito, no fluxo, acima da dobra, várias vezes | Plano item 2; referência "Onde cada resposta" | Mantido |
| Perguntas de auditoria O/CO | Referência | Mantidas |
| Ativos de persuasão (5 categorias), lista de desejos, gatilhos, sanduíche, exibição | `objecoes-e-provas.md` | Lista "a conseguir" vai para `next_steps` com o jeito de conseguir |
| Hierarquia de provas | Referência; plano item 4 | Exemplos brasileiros |
| Regra ética (não fabricar depoimento, estatística, selo) e "resolver com evidência" | SKILL, "Regra ética" | Mais escassez falsa e atividade inventada; provas vêm de modelos com `authorized` |
| Copywriting: benefício, números específicos, escaneável, voz ativa, "você", cortar adjetivos, erros comuns | SKILL construção "Estrutura"; tabela de erros | Mantido |
| Fórmulas de título (8 da landing-page-copy e 5 da CRO), subtítulo, o que evitar, 5 critérios, prioridade de teste de título | `titulos-cta-e-testes.md` | Exemplos de PME brasileira |
| As 7 seções da landing e a versão curta | Plano item 3 | Versão de 4 blocos para negócio simples |
| Regras de CTA (ação + resultado, primeira pessoa, específico, baixa fricção, evitar genéricos, posições, par com o título) | SKILL construção "O botão"; referência | Rótulos em português; barra fixa com área segura |
| Fluxo de trabalho (oferta, público, linguagem, 5 a 10 títulos, estrutura, cortes, teste do botão) | Briefing e plano itens 3 e 6 | Texto é escrito no app, não entregue em markdown |
| Formato de saída em markdown por seção e variantes | Plano item 6 (títulos alternativos) | A saída final é a página construída |
| Lista pós-importação (URLs, celular, SEO) | Critérios de aceite; revisão automática da plataforma | A plataforma abre a página no navegador e confere |
| "Se faltar dado, declarar a lacuna" | Regra ética; blocos ocultos sem dado | Mantido |
| Biblioteca de objeções (8 categorias, sintomas, respostas, 5 a 8 por página, mapa de posições, exemplo trabalhado) | `objecoes-e-provas.md` | Exemplo trocado por eletricista residencial |
| Hipótese, métricas principal/secundária/proteção, ICE com rubricas, variante ponderada, filtro 10x, exemplo | `titulos-cta-e-testes.md` "Hipótese" | Mantido |
| Metodologia A/B: tamanho de amostra, ciclo completo, não espiar, significância prática, multivariado, promover vencedora, documentação, tabela de aprendizados, quando falha | `titulos-cta-e-testes.md` "Teste A/B"; edição | Implementação real: sorteio 50/50 no navegador, `variant` nos registros, conta de significância sobre contagens, vencedora só depois da data fixada |
| Comparação de plataformas de teste (Optimizely, VWO...) | Não incluído | Substituído pela receita própria no app; ferramentas externas exigiriam snippet, que a plataforma proíbe |
| Dinâmica de equipe de CRO (papéis, adesão de gestores, velocidade de testes) | Não incluído | Público é dono de pequeno negócio sozinho; a parte útil (decidir por dado, não por opinião) está na tabela de erros |
| Erros comuns (tabela) e falhas da landing-page-copy | SKILL, "Erros comuns" | Unificados |
| Medição com analytics | SKILL construção "Medição" | `conversion_event` próprio + `trackEvent` (Meta Pixel quando ligado); GA4 injetado pela plataforma |
| Formulário de lead | SKILL construção | `access` de visitante da plataforma, `zod`, LGPD, automação `notify` ao dono |
