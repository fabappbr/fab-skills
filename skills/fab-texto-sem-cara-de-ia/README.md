# Texto sem Cara de IA

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: a conversa com o dono (perguntas com opções), o plano mostrado antes de codar, a construção, a conferência antes de dizer pronto e as mudanças depois.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida pelo próprio agente com `fabapp dev`, busca no código e `fabapp deploy`.
- A memória do app virou `DECISOES.md` na raiz do projeto; o resumo final virou a mensagem ao dono com o que foi conferido e o que ele faz no Studio.
- A varredura final virou busca no código feita pelo agente, incluindo `fab.agents.json` (o campo `instructions` dos agentes), antes de `fabapp deploy`.
- As formas fixas que vinham de `fab-textos-de-interface` e `fab-copy-que-vende` continuam escritas aqui, para a skill funcionar sozinha.

Filtro anti-IA em português para todo texto visível do app ou site (páginas, botões, avisos, e-mails, notificações, mensagens de WhatsApp e respostas da IA do próprio app), com hierarquia de evidência, lista dura, os 25 padrões reescritos para o PT-BR, perfis de voz, nota de 0 a 50 e proteção de texto regulado, sem nunca mudar fato.

- **Categoria:** content
- **Etapas:** plan, build, edit
- **Tokens (validador):** corpo ~4.530 (plano ~3.490, construção e edição ~4.050 cada); referências ~9.940
- Não depende de outra skill. Para textos de venda, `fab-copy-que-vende`; para regras por elemento de interface, `fab-textos-de-interface` (sugestões ao dono).

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| humanizer | https://github.com/blader/humanizer (commit 9862685) | MIT, Copyright (c) 2025 Siqi Chen |
| humanizer-br | https://github.com/msigor/humanizer-br (skills/humanizer-br, commit 4535b8d) | MIT, Copyright (c) 2026 msigor |
| humanizar | https://github.com/fabricioctelles/skills (skills/humanizar, commit 3b8da2c) | Apache-2.0, autor https://ft.ia.br |
| ill-communication | https://github.com/alexconner-79/ill-communication (commit 9d34daf) | MIT, Copyright (c) 2026 alexconner-79 |
| stop-slop (só a tabela de pontuação, citada na análise) | https://github.com/hardikpandya/stop-slop | MIT |

Análise usada: `fabapp-skills-referencia-2/04-copy/ANALISE.md` (seções 7 a 10, "Rejeitadas" e "Conceitos-chave").

Apache-2.0 (humanizar): esta é uma obra derivada modificada; o texto foi reescrito e adaptado para a plataforma Fabapp (mudanças: perfis reduzidos aos textos de app, Jev removido, exemplos trocados, travessão removido de todos os exemplos). A licença Apache-2.0 completa está no repositório de origem. MIT: avisos de copyright registrados acima.

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Por que texto de IA soa assim (escolha padrão) | SKILL "Por que..." | Igual |
| Padrões 1 a 5 agem em uma ocorrência; "fraco sozinho" | SKILL hierarquia; catálogo | Igual |
| 25 padrões com antes/depois (blader) | catalogo-25-padroes.md; resumo no SKILL | Exemplos de PME em PT; padrão 10 (hífen em pares do inglês) virou hífen fora do Acordo Ortográfico |
| Fluxo marcar, rascunho, checar, versão final | SKILL construção e edição | Construção = modo criação; edição = revisão |
| Os 5 tiques que sobrevivem à reescrita | catálogo (fim); SKILL construção passo 2 | Os cinco escorregões do modo criação (humanizar) somados |
| Amostra de voz vence (inclusive travessão) | SKILL edição "Texto que o dono escreveu" | Decisão de produto: travessão sai mesmo assim, com aviso no `finish`; o dono pode pedir para manter |
| Modos colado, arquivo, embutido | SKILL construção (arquivo) e `finish` (relatório) | Não há texto colado em chat; o app é o arquivo |
| Não inventar fato, pedir dado | SKILL trava factual | Marcador só para admin, pergunta em `next_steps` |
| Quando não agir; marcas humanas a preservar | SKILL guarda de falso positivo; catálogo fim | Regionalismo brasileiro, contrações |
| Três camadas (tirar, ritmo, voz) de humanizer-br | SKILL edição; padroes-pt-br.md seções 5 e 7 | Igual |
| Sinais fortes, médios e fracos (humanizer-br) | SKILL hierarquia | Travessão fraco como detector, banido por decisão de produto (análise, item 9) |
| Escassez de pontuação, tamanho uniforme, aspas curvas, palavra difícil, ausência de reclamação | SKILL hierarquia (fortes); padroes-pt-br.md seção 5 | Igual |
| Vocabulário para medir densidade | padroes-pt-br.md seção 6 | Igual |
| Formatação e markup (markdown vazando, placeholder esquecido, títulos) | padroes-pt-br.md seção 5 | Placeholder só visível ao admin |
| Escada contar/mostrar/fazer sentir, número com textura, objeção na voz do leitor | padroes-pt-br.md seção 7 | Só com material do dono |
| Teste mental de 4 perguntas | padroes-pt-br.md seção 8 | Igual |
| Formato de saída (auditoria, o que não mexi) | SKILL edição "Relatório no finish" | No `finish` em português simples |
| Trava factual e 6 proteções (humanizar) | SKILL trava factual | Igual |
| Triagem de casos proibidos (bula, contrato, lei, segurança) | SKILL texto protegido | LGPD, saúde, termos |
| Modos completo, direto, revisão, criação | SKILL construção (criação) e edição (revisão, até 2 rodadas) | Tentativas máximas 2 |
| Perfis de voz (13) e detecção por sinal | perfis-e-simplificado.md; SKILL plano (tabela por tipo de texto do app) | WhatsApp virou "WhatsApp de negócio" (sem gíria de pessoa física) |
| Perfil Português Simplificado (PorSimples, Lei 15.263) com 7 operações, 15 regras, métricas | perfis-e-simplificado.md | Exemplo de app |
| Perfis Assertivo, Enxuto, Resumo e regras de consumo rápido | perfis-e-simplificado.md | Painel do dono; números dos dados do app |
| Diagnóstico estruturado com pesos 1 a 3 | SKILL hierarquia + padroes-pt-br.md | Pesos viraram forte/médio/fraco |
| Indicadores quantitativos opcionais (TTR, desvio) | Fora | O gerador não mede; o limite de frase fica como regra |
| Restauração de especificidade e ablação semântica | padroes-pt-br.md seção 3 "Achatamento" | Igual |
| Guarda de falso positivo (tabela) | SKILL guarda | Igual, resumida |
| Verificação final de 12 itens + 6 de brevidade | SKILL construção passos 5 e 6; perfis "Checagem de brevidade" | Varredura em `src/` e automações |
| Avaliação 0 a 100 com 4 dimensões e limiar 80 | Trocada pela nota 0 a 50 de stop-slop (limiar 35); as 4 dimensões ficam no relatório | A análise pede a tabela do stop-slop |
| Controle de tentativas e contrato YAML | perfis-e-simplificado.md "Relatório e controle" | Contrato YAML fora (não há pipeline externo) |
| Estrangeirismos preservados | SKILL guarda; padroes-pt-br.md padrão 11 | Lista do varejo e serviço (delivery, check-in, combo) |
| Suíte de regressão T1 a T8 | Critérios de aceite do plano | A plataforma confere os critérios |
| Integração Jev (avaliação externa) | Fora | O gerador não chama modelos externos nem executa scripts |
| 12 padrões exclusivos PT-BR, composição (12), tom (14), linguagem (9), estilo | padroes-pt-br.md | Tabelas resumidas, exemplos PME |
| Regras duras de ill-communication (sem travessão, tabela de troca, não reescrever regulado, varredura final) | SKILL lista dura, tabela do travessão, texto protegido, construção passo 5 | Locale britânico trocado por PT-BR |
| Catálogo ai-tells (vocabulário, enchimento, inflação, construções, atribuição, estrutura, tom) | catalogo-25-padroes.md e padroes-pt-br.md | Sem duplicar |
| Perfil de voz preenchível | SKILL plano (perfil por tipo de texto) e `update_knowledge` | Preenchido pelo briefing e pelo dono |
| Microcopy de ill-communication | Coberto pela lista dura (toast, "Ops", "com sucesso") | Regras completas por elemento ficam na skill `fab-textos-de-interface` |
| Stop-slop: 5 dimensões, limiar 35/50, 8 regras, checagens rápidas | SKILL "Pontuação de 0 a 50" | Igual, em PT |
| IA dentro do app | SKILL construção passo 4; critério de aceite | Novo: o filtro vai no `system` do `invokeLLM` e nos agentes |

Trocas principais e motivo:
- Travessão: as fontes divergem (humanizer-br o rebaixa a sinal fraco; ill-communication o proíbe). A Fabapp proíbe por decisão de produto, sem fingir que é detecção.
- Jev, métricas numéricas e contrato YAML saíram porque o gerador não executa ferramentas nem chama modelos externos; a função (diagnóstico e nota) ficou com a nota de 0 a 50 e os critérios de aceite.
