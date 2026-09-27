# Copy que Vende

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: a conversa (perguntas com opções pela ferramenta de perguntas), o plano mostrado ao dono antes de codar, a construção, a conferência antes de dizer pronto e as mudanças depois.
- Os critérios de aceite viraram a lista de conferência do plano, conferida pelo próprio agente com `fabapp dev`, busca no código e `fabapp deploy`.
- O SEO agora é escrito pelo agente em `fab.config.json → seo` (home e `pages`); `FabHead` fica para rota dinâmica.
- A memória do app virou `DECISOES.md` na raiz do projeto. Dados de exemplo não são semeados: o dono cadastra no CMS do Studio.
- As regras que vinham de outras skills (tiques de IA, botão no infinitivo, link do WhatsApp, esquema de `testimonial`) estão escritas aqui em uma frase, para a skill funcionar sozinha.

Escreve os textos de venda do site ou app (título, subtítulo, CTAs, benefícios, como funciona, provas, perguntas frequentes, páginas de serviço, sobre, preços e mensagens de boas-vindas) partindo do posicionamento, montados no roteiro StoryBrand e revisados em sete passadas, sem inventar fato.

- **Categoria:** content
- **Etapas:** briefing, plan, build, edit
- **Tokens (validador):** corpo ~5.580 (briefing ~1.910, plano ~2.180, construção e edição ~3.350 cada); referências ~8.250
- **Complementa** a `fab-agencia` (direção de arte e motion): esta skill só decide palavras e ordem das seções; não escolhe cor, fonte nem animação.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| obviously-awesome | https://github.com/wondelai/skills (obviously-awesome, commit c172996) | MIT, Copyright (c) 2025 Wondel.ai sp. z o.o. |
| storybrand-messaging | https://github.com/wondelai/skills (storybrand-messaging, commit c172996) | MIT, Copyright (c) 2025 Wondel.ai sp. z o.o. |
| copywriting | https://github.com/coreyhaines31/marketingskills (skills/copywriting, commit 5b2c000) | MIT, Copyright (c) 2025 Corey Haines |
| copy-editing | https://github.com/coreyhaines31/marketingskills (skills/copy-editing, commit 5b2c000) | MIT, Copyright (c) 2025 Corey Haines |

Análise usada: `fabapp-skills-referencia-2/04-copy/ANALISE.md` (seções 1 a 4 e "Como adaptar frameworks em inglês").

As licenças MIT permitem obra derivada desde que o aviso de copyright e a permissão acompanhem as cópias substanciais. O texto aqui é reescrito em português para a plataforma Fabapp; os avisos acima ficam registrados neste README.

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Positioning is context, não mensagem | SKILL regra 1; posicionamento.md abertura | Alternativas típicas de PME brasileira nomeadas |
| Nota 0 a 10 de posicionamento com faixas | posicionamento.md; SKILL plano 1 | Igual, exigida no plano |
| Canvas de 10 campos | SKILL plano 1 (canvas mínimo de 8 linhas) | Narrativa de vendas e mensagem viram roteiro SB7 e título |
| 5 passos (alternativas, atributos, valor, cliente, categoria) | posicionamento.md seções 1 a 5 | Exemplos de bairro |
| 5 tipos de alternativa + agrupamento + segmento | posicionamento.md tabela | Adjacente = WhatsApp, Instagram, planilha |
| Entrevista com 15 a 20 clientes felizes | Briefing perguntas 1 a 3 | Não há clientes para entrevistar; o dono responde por eles, com opções |
| Análise do "não fazer nada" e como vencê-lo | posicionamento.md seção 1 | Só com fato real |
| Teste "Só nós" e teste da verdade; atributo x característica | posicionamento.md seção 2 | Tabela com exemplos locais |
| Pontuação do atributo 4 x 1 a 5, pilar 16+ | posicionamento.md seção 2 | Igual |
| Verificação de unicidade (concorrente, cliente, tempo, vendas) e revisão trimestral | Resumido no teste "Só nós" e em "Mudar a cada mês" | Sem equipe de vendas nem trimestre; dono confirma no briefing |
| Cadeia "E daí?" 2 a 4 níveis, parar antes do genérico | posicionamento.md seção 3; SKILL passada 3 | Igual |
| 2 a 4 temas de valor, hierarquia, provas por tema | posicionamento.md seção 3 | Provas do mundo PME (registro, foto real, nota informada) |
| Cliente ideal acionável, critério negativo, testes de lista/anúncio | posicionamento.md seção 4 | Bairro, rotina, gatilho no lugar de dados de empresa |
| Categoria: disputa direta, subcategoria, nova; imposto de educação | posicionamento.md seção 5 | Subcategoria como padrão para PME |
| Tendências e sinais de abuso | posicionamento.md seção 5 | Igual |
| Declaração de posicionamento e checklist do canvas | posicionamento.md "Declaração e revisão"; SKILL plano 1 | Igual |
| Erros comuns e diagnóstico rápido | posicionamento.md | Igual, com ações da plataforma |
| Workshop de equipe (agenda minuto a minuto, remoto, discordar e comprometer, revisão de 90 dias) | Fora | Não há equipe nem workshop; o briefing faz o papel das pré-perguntas (o que o cliente não acha em outro lugar) |
| Estudos de caso | posicionamento.md "Lições dos casos reais" | Lições cruzadas mantidas, casos de SaaS cortados |
| SB7 (personagem, problema 3 níveis, guia, plano, CTA, fracasso, sucesso) | storybrand-e-paginas.md; SKILL plano 2 | Exemplos de academia, dentista, oficina; sem "Imagine..." |
| Nota SB7 7 itens + 3 da frase-resumo | storybrand-e-paginas.md; SKILL plano 2 | Plano abaixo de 8 volta a ser escrito |
| BrandScript (ficha) | SKILL plano 2 (7 linhas no plano) | Ficha vira linhas do markdown do plano |
| One-liner, fórmulas PSR, BAB, "existimos porque", testes | storybrand-e-paginas.md | Exemplos de nicho brasileiro; vira SEO, rodapé e WhatsApp |
| Wireframe da home e páginas internas (serviço, sobre, caso, preços) + checklists | storybrand-e-paginas.md; SKILL plano 3 e construção | Ordem vira critério de aceite; composição visual livre (regra da plataforma) |
| CTA direto e de transição; ética do botão | SKILL regra 8; storybrand-e-paginas.md | Lead magnet = formulário que grava lead |
| Sequências de e-mail (boas-vindas 5, nutrição 3:1, reengajamento, assuntos, segmentação, métricas) | storybrand-e-paginas.md "Mensagens" | Automação `relative` + `notify` e-mail para quem tem conta; visitante vira lead com mensagens de WhatsApp prontas. Métricas de abertura fora: a plataforma não mede e-mail |
| Consistência multicanal (redes, vídeo, podcast, imprensa) | storybrand-e-paginas.md "Consistência entre canais" | Reduzido a site, e-mail, WhatsApp e bio; roteiros de vídeo, podcast e press release fora (o app não produz esses canais) |
| Conversa de vendas: descoberta, objeções, preço | Briefing (descoberta); "Objeções viram perguntas frequentes"; página de preços (valor antes do preço) | O site não faz ligação; objeção vira FAQ |
| Contexto antes de escrever (página, público, oferta, tráfego) | Briefing | Perguntas com opções |
| Clareza > esperteza, benefício > característica, específico, linguagem do cliente, uma ideia por seção | SKILL regras 3 e 4; passadas | Igual |
| Regras de estilo (simples, ativo, confiante, honesto, sem exclamação) | SKILL regra 9; titulos-cta-revisao.md | Igual, em PT |
| Fórmulas de título (6 grupos) | titulos-cta-revisao.md | Traduzida a função, exemplos PME |
| Teste "Now you can" | titulos-cta-revisao.md; SKILL plano 4 e critério | "Agora você pode..." |
| Human Action Model, caso SavvyCal, métricas de clareza | titulos-cta-revisao.md | Igual, resumido |
| Perception Gap | titulos-cta-revisao.md | Exemplos de PME |
| Fórmula de CTA e CTAs fracos | SKILL construção; titulos-cta-revisao.md | Imperativo com "seu/sua" no site, infinitivo no app; fracos em PT |
| Seções de landing e templates de página | storybrand-e-paginas.md; SKILL plano 3 | Consolidados no roteiro SB7 |
| Saída com alternativas e anotações | SKILL plano 4 (3 candidatos com porquê) | Registrado no plano |
| Meta content (título e descrição SEO) | SKILL construção "SEO"; critério | `fab.config.json → seo`, `FabHead` |
| Transições naturais e as que denunciam IA | titulos-cta-revisao.md | Lista em PT |
| Sete passadas com volta às anteriores | SKILL construção; titulos-cta-revisao.md | Rodadas antes do `finish` e na edição |
| Painel de especialistas com notas | titulos-cta-revisao.md | Só relatar se avaliou |
| Checagens de palavra, frase, parágrafo; palavras simples | titulos-cta-revisao.md | Tabela PT |
| Problemas comuns e conserto | titulos-cta-revisao.md | Igual |
| Atualização de conteúdo (refresh x reescrita, cadência) | titulos-cta-revisao.md; SKILL edição | Cadência ligada a mudanças do negócio |
| Checar `product-marketing.md` | SKILL edição (`update_knowledge` e memória do app) | A memória do app faz o papel do arquivo de contexto |
| Evals das originais | Critérios de aceite do plano | A plataforma confere os critérios depois do build |

Trocas principais e motivo:
- Nada de depoimento ou número inventado: a prova mora num modelo de dados e a seção some para o visitante quando vazia, com cartão "Falta: ..." para o admin (a plataforma não grava registros no build).
- Workshop, entrevistas, métricas de e-mail e canais de mídia ficaram fora porque não há equipe nem ferramenta equivalente no app gerado; a função (descobrir alternativa, atributo e cliente) passou para as perguntas do briefing.
