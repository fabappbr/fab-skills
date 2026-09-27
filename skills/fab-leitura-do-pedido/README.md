# Leitura do Pedido

## Edição terminal

Esta é a edição para agentes que constroem e editam apps da Fabapp AI pelo terminal (Claude Code, Codex, OpenCode,
Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio (tamanho, nota de clareza,
banco de perguntas, "disse/assumi", verdade do produto, modos e controles, "Entendi assim", exemplos); o que mudou:

- Não há briefing nem botão de começar: o portão é o plano que o agente escreve e o dono aprova antes de qualquer
  código. "No briefing" virou "A conversa"; os campos do `deliver_prompt` (`prompt`, `assumptions`, `next_prompts`,
  `warnings`, `brand`) viraram seções do plano (Visão geral, Suposições, Próximos passos, Avisos, Marca).
- `ask_questions` virou a ferramenta de perguntas de opção da ferramenta do agente (AskUserQuestion no Claude Code),
  com o mesmo teto de rodadas; `update_brief` virou o estado de cada tema que o agente mantém; `show_references` virou
  links de referências reais; `fetch_url` virou a leitura de páginas da própria ferramenta.
- A marca: pelo terminal o agente propõe paleta, fontes e raio no plano (para `fab.config.json → theme`), sem gastar
  pergunta da leitura com isso.
- Os critérios de aceite viraram a lista de conferência, sem teto, marcada "no código" ou "na tela".
- Removida a arbitragem entre skills ligadas no mesmo pedido (orquestração do Studio). `fab-redesign-e-polimento` é citada
  como recomendação.
- Acrescentados: `DECISOES.md` depois da aprovação, primeiro movimento, contrato ao vivo e a regra das duas mãos.
  `references/fabapp-cli.md` é copiado pelo script de montagem.

Transforma o pedido vago do dono em entendimento firme antes de construir: tamanho do pedido, nota de clareza,
perguntas em lotes com resposta sugerida, "o que você disse" separado de "o que eu assumi", verdade do produto (com a
lista "não inventar"), modo de cada tela e a frase "Entendi assim". Tudo termina no `deliver_prompt` e no plano.

- **Categoria:** other
- **Etapas:** briefing, plan
- **Tokens (validador):** corpo ~6.380 (briefing ~5.570, plano ~5.870); referências ~1.830
- **Arquivos:** `SKILL.md`, `references/exemplos.md`

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| brainstorming (superpowers) | https://github.com/obra/superpowers, commit 5bf4e78 | MIT |
| requirements-clarity | https://github.com/softaworks/agent-toolkit, `skills/requirements-clarity`, commit 3027f20 | MIT, Copyright (c) 2026 Leonardo Flores |
| impeccable (SKILL.md, reference/init.md, shape.md, new-work.md, operate.md, craft.md, routing.md, PRODUCT.md) | https://github.com/pbakaus/impeccable, commit edb9c7f | Apache 2.0 (ver LICENSE e NOTICE.md do repositório) |
| taste-skill (seções 0, 1, 7, 9.D, 11) | https://github.com/Leonxlnx/taste-skill, commit c184364 | MIT |

Avisos de copyright exigidos pela MIT: superpowers, Copyright (c) 2025 Jesse Vincent; requirements-clarity,
Copyright (c) 2026 Leonardo Flores; taste-skill, Copyright (c) 2026 Leonxlnx. As três sob a licença MIT. A parte derivada de impeccable é obra derivada
sob Apache 2.0: o texto foi reescrito em português para a Fabapp e alterado para a plataforma (mudanças descritas no
mapa abaixo). O texto é próprio; nenhum parágrafo foi copiado.

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| brainstorming: estabelecer entendimento comum (descobrir intenção, escrever o entendimento, carregar a intenção) | Seção 4 "O que você disse e o que eu assumi" | A nota vira mensagem antes do `deliver_prompt` e a Visão geral do plano |
| brainstorming: separar o que foi dito de suposições | Seção 4 + `assumptions` | Suposição no formato "Assumi X. Se não for, Y." |
| brainstorming: quando o pedido já traz propósito, refletir e não perguntar de novo | Seção 4 e nota 90+ | Igual |
| brainstorming: HARD-GATE (nada implementado antes da aprovação) | Abertura da skill e seções de briefing/plano | O portão é o botão de começar do `deliver_prompt` e `approved=true` no plano |
| brainstorming: aprovação vale só para o que foi mostrado | Tabela de pensamentos, linha "Ele aprovou a ideia" | Igual |
| brainstorming: três caminhos (spike, bounded, architectural) anunciados em voz alta | Seção 1 (sondagem, limitado, arquitetural) + frases de anúncio | Vocabulário leigo |
| brainstorming: na dúvida, o caminho mais pesado; catraca só sobe | Seção 1, regras 2 e 3 | Igual |
| brainstorming: "bounded mede o repo, não a familiaridade" | Seção 1, regra 1 | "Limitado mede o app do dono" |
| brainstorming: anti-padrão "simples demais para aprovar" e tabela Red Flags | Tabela "Pensamento / Realidade" | 6 linhas adaptadas |
| brainstorming: checklist por caminho e fluxo (dot) | Seção 1 (tabela) e "No briefing: da conversa à entrega" | Sem diagrama; a ordem virou lista numerada |
| brainstorming: avaliar escopo e decompor em subprojetos | Seção 1, regra 5 | Núcleo na 1ª versão, resto em `next_prompts` / "O que NÃO vamos construir" |
| brainstorming: uma pergunta por vez, múltipla escolha preferida | Seção 3 | Trocado por lotes de 2 a 3 perguntas com opções: a plataforma limita rodadas e o `ask_questions` mostra cartões; a regra "uma por vez" sobrevive como "um tema por lote" |
| brainstorming: propor 2 a 3 abordagens com recomendação; YAGNI | Seção 3 (opções com troca no `hint`) + "Por quê?" | A abordagem vira pergunta com opção recomendada |
| brainstorming: apresentar o design em seções com aprovação a cada seção | Plano com Visão geral, Telas, O que NÃO vamos construir | Adaptado: o dono aprova o plano inteiro (a plataforma tem uma aprovação só); correção reaplica as conferências |
| brainstorming: design em unidades com um propósito | "No plano", item "Cada tela com um propósito só" | Unidade = tela |
| brainstorming: trabalhar em código existente (seguir padrões, melhoria pontual, sem reforma sem relação) | Seção 7, "Refazer algo que já existe" | Igual, no vocabulário do dono |
| brainstorming: escrever o spec e commitar | Markdown do plano / `prompt` do `deliver_prompt` | Sem arquivo nem git: o artefato é o plano |
| brainstorming: autorrevisão do spec (placeholder, coerência, escopo, ambiguidade) | "No plano", 4 conferências | Igual |
| brainstorming (spec-document-reviewer): calibrar, só apontar o que causa erro | "Corrija só o que faria o app sair errado" | Sem subagente revisor |
| brainstorming: portão de revisão do spec pelo usuário | `approved=true` e reemissão do `deliver_prompt` | Igual em função |
| brainstorming: transição para writing-plans | Plano aprovado libera a construção | A skill `fab-spec-de-sistema` é sugestão, não dependência |
| brainstorming: Visual Companion "just in time", decisão por pergunta | Seção 3, `show_references` | Sem servidor local: referências reais no briefing |
| requirements-clarity: detectar pedido vago (4 tipos) | Nota de clareza + descrição da skill | Os 4 tipos viraram dimensões da nota |
| requirements-clarity: quando NÃO ativar | Seção 2, parágrafo "Não abra rodada" | Igual |
| requirements-clarity: rubrica 30/25/25/20 com subitens | Seção 2, tabela | "Especificidade técnica" trocada por "Operação do negócio" (a pilha é fixa); pesos mantidos |
| requirements-clarity: iterar até 90 | Seção 2, "O que fazer com a nota" | Até 3 rodadas; abaixo de 90 o resto vira suposição registrada que conta metade (limite de rodadas da plataforma) |
| requirements-clarity: 2 a 3 perguntas por rodada, uma categoria por vez, maior impacto primeiro | Seção 3 | Igual (rodada 1 até 5, respeitando o `ask_questions`) |
| requirements-clarity: análise de lacunas em 4 dimensões | Rubrica e banco de perguntas | Igual |
| requirements-clarity: formato de pergunta com exemplo; formato de atualização da nota | Seção 3 e `update_brief` | A nota não é mostrada em número ao leigo; o painel de seções mostra o avanço |
| requirements-clarity: princípios Por quê? (YAGNI) e Mais simples? (KISS) | Seção 2 | Igual |
| requirements-clarity: estrutura do PRD e fases de execução | `deliver_prompt` (prompt, assumptions, next_prompts, warnings) e plano | Fases viram `next_prompts` ordenados; riscos viram `warnings` |
| requirements-clarity: DO/DON'T ("não suponha sem confirmar") | Seção 4 | Trocado: suposição é permitida só registrada e visível, porque o briefing tem teto de rodadas |
| requirements-clarity: critérios de aceite checáveis | "No plano", lista de `acceptance_criteria` | Com `kind` code/visual |
| impeccable: modos Persuade, Operate, Read, Experience escolhidos pela superfície | Seção 6 | Persuadir, operar, ler, experiência |
| impeccable operate.md: produto sem estranheza, densidade permitida, estados completos, movimento curto | Tabela de modos e controles | Resumido ao que o plano decide |
| impeccable new-work §2: perguntas por modo | Seção 3, "Perguntas por modo de tela" | Igual |
| impeccable init: explorar antes de perguntar | Seção 2 (conta o que está no pedido, anexo, site lido) | `fetch_url` no lugar de ler o repositório |
| impeccable init: até 3 perguntas por rodada, confirmar inferências, registrar o que ficou indefinido | Seções 3 e 5 (inferidos marcados) | Igual |
| impeccable init: testar se há quem responda antes de supor | Seção 3, "tanto faz" | Sem resposta vira decisão registrada e avisada na resposta seguinte |
| impeccable init: não perguntar estética na entrevista de produto | Seção 3 | Identidade tem a pergunta própria do briefing |
| impeccable init: o que pertence e o que não pertence ao PRODUCT.md; proibido inventar provas | Seção 5, três listas | "Não informado, não inventar" |
| impeccable PRODUCT.md: seções Users, Purpose, Positioning, Operating Context, Capabilities, Brand Commitments, Evidence on Hand, Accessibility | Seções 2, 3 (pergunta 5 = posicionamento), 5 e 7 | Cabem no prompt e na Visão geral; "Evidence on Hand" com as ausências vira a lista "não inventar" |
| impeccable init: pergunta de stack, `buildPath` comp/código, modo live, doctor, hooks | Fora | A pilha é fixa, não há comp nem navegador ao vivo no briefing |
| impeccable PRODUCT.md: Product Principles | Fora | O dono leigo não formula princípios; tom e preferências vão para `brand.tone` |
| impeccable init: portão de conclusão (arquivo precisa existir) | "No briefing", passo 5 | O `deliver_prompt` precisa ser chamado; texto no chat não vale |
| impeccable shape: cadência, rodada 1 (propósito, pessoas, resultado), rodada 2 (material, estados, fidelidade, o que fica intocado, o que faria parecer errado) | Seção 3, perguntas 1 a 11 | Faixas mínimo/típico/máximo na pergunta 6 |
| impeccable shape: brief de 7 itens, confirmar e parar | Campos do `deliver_prompt` e do plano | Confirmar = botão de começar / aprovação |
| impeccable: "o brief vence"; refinar preserva, redesenhar substitui | Seção 7, "Refazer algo que já existe" | Igual |
| impeccable new-work: verdade limita afirmações, não demonstrações | Seção 5, regra 3 | Demonstração só marcada como exemplo |
| taste 0.A: seis sinais do briefing | Seção 7 | Igual |
| taste 0.B: "Design Read" de uma linha | Seção 7, "Entendi assim" | Mostrada ao dono cedo e na entrega |
| taste 0.C: uma pergunta só quando a leitura diverge | Seção 7 | Igual |
| taste 0.D: disciplina anti padrão | Seção 7 ("a leitura decide o tom") | Cores e fontes são da marca; a parte visual fica na leitura de tom |
| taste 1, 1.A, 1.B, 7: três dials, tabela de inferência, presets, definições | Seção 6, controles "Sóbrio/ousado", "Parado/animado", "Arejado/completo" | Presets refeitos para os casos da Fabapp; valores de CSS trocados por comportamento, porque o build não escolhe cor nem fonte |
| taste 9.D: efeito "Jane Doe" | Seção 5, regras 3 e 6 | Nomes brasileiros; números inventados proibidos (a original manda "bagunçar" números, o que aqui seria fabricação) |
| taste 11.A: detectar recomeço, preservar ou repaginar; perguntar uma vez | Seção 7 | Igual |
| taste 11.C e 11.F: o que nunca muda em silêncio | Seção 7 | Rotas, menu, campos, logo, textos legais, textos do dono |
| taste 11.B, 11.D, 11.E: auditoria visual e alavancas de redesenho | Fora | São decisões de construção visual, cobertas pela `fab-agencia` e pelas regras do build |
| Restrições silenciosas (acessibilidade, público infantil, regulado) | Seção 5, regra 5 | Igual |

## O que ficou de fora e por quê

- Servidor do Visual Companion, scripts, arquivos em disco e git: a Fabapp não roda scripts; o equivalente é
  `show_references`, o `deliver_prompt` e o plano.
- Aprovação por seção: a plataforma tem uma aprovação do plano; a skill compensa com as quatro conferências e a
  reemissão quando o dono corrige.
- Pergunta de stack e caminho comp/código do impeccable: a pilha é fixa e o briefing não fala de tecnologia.
