# Textos de Interface

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou o encanamento:

- As etapas do Studio viraram o fluxo do agente: a conversa com o dono (perguntas com opções), o plano mostrado antes de codar, a construção, a conferência antes de dizer pronto e as mudanças depois.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida pelo próprio agente com `fabapp dev`, busca no código e `fabapp deploy`.
- A memória do app virou `DECISOES.md` na raiz do projeto; o resumo final virou a mensagem ao dono com o que foi conferido e o que ele faz no Studio.
- As regras que vinham de outras skills (CTA de venda, lista dura anti-IA) estão escritas aqui em uma frase, para a skill funcionar sozinha.
- A conferência final ganhou a busca por `window.alert`/`confirm`/`prompt` e o percurso na pré-visualização (lista vazia, exclusão, formulário, falha de rede).

Escreve e revisa os textos de dentro do app (botões, erros, estados vazios, confirmações, toasts, rótulos, placeholders, dicas, onboarding, notificações e e-mails automáticos) com regra fixa por elemento, voz gerada do briefing, glossário único e português simplificado, sem inventar fato.

- **Categoria:** content
- **Etapas:** plan, build, edit
- **Tokens (validador):** corpo ~4.740 (plano ~3.040, construção e edição ~3.990 cada); referências ~4.860
- Não depende de outra skill. Para os textos de venda do site, a skill `copy-que-vende` é sugestão ao dono; para o filtro anti-IA completo, `texto-sem-cara-de-ia`.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| ux-writing (humbleteam) | https://github.com/humbleteam/ux-writing (commit a12a8b3) | MIT, Copyright (c) 2026 Humbleteam |
| ux-writing (content-designer) | https://github.com/content-designer/ux-writing-skill (commit 98cacde) | MIT, Copyright (c) 2026 Christopher Greer |

Apoio pontual (lista de microcopy, confirmshaming, texto regulado): alexconner-79/ill-communication, MIT, Copyright (c) 2026 alexconner-79. Análise: `fabapp-skills-referencia-2/04-copy/ANALISE.md` (seções 5, 6 e 7).

Texto reescrito em português para a plataforma Fabapp; os avisos de copyright MIT ficam registrados aqui.

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Modo escrever x modo limpar | SKILL construção x edição | A etapa decide o modo |
| Tabela de regras por elemento (8 elementos) | SKILL "Regra por elemento" | Ampliada com título, ajuda, notificação, permissão, onboarding; exemplos em PT |
| Botão com verbo + resultado, sentence case | SKILL regras 1 e 2 | Infinitivo como padrão brasileiro de app |
| Erro: o que houve + como resolver | SKILL tabela e tipos de erro | Mapeado para os status reais do `ApiError` (401, 402, 403, 409 de cadastro duplicado, 422, 429) e falha de rede sem `status` |
| Estado vazio: o que falta + uma ação | SKILL tabela; padroes-por-elemento.md | Componente `empty-state`, critério de aceite |
| Confirmação destrutiva com consequência | SKILL tabela e construção | Contagem real com `count()`; `remove` é exclusão lógica |
| Toast no passado sem exclamação | SKILL regra 7 e tabela | Sem "com sucesso", via `sonner` |
| Placeholder nunca substitui rótulo | SKILL tabela e formulários | `Field` com rótulo visível |
| Dica não repete o rótulo | SKILL tabela | Igual |
| Lacuna nomeada ("slot, not a guess") e linha "Needs:" | SKILL regra 6 e "Fatos que a frase precisa" | No app o dado vem do registro na hora; regra do dono vira pergunta no `finish` (next_steps) |
| 13 padrões banidos com exemplo | acessibilidade-e-checklist.md | Exemplos de PME; travessão descrito por nome |
| Duas checagens (tabela + regra do elemento) | SKILL edição passo 2 | Igual |
| Teste do tipo de elemento ambíguo | SKILL edição passo 1 | O código mostra onde a string é usada; pergunta só se continuar ambíguo |
| Preservar fatos na reescrita; "está bom, não mude" | SKILL edição passos 3 e 4 | Igual |
| Autochecagem de 8 perguntas, um sim reescreve | SKILL construção "Checagem" | Igual, em PT |
| Texto de compliance e guia de voz vencem | SKILL edição 6; plano (guia do dono vence) | LGPD, saúde, consentimento |
| Idioma não inglês: regras estruturais valem, vocabulário não | Toda a skill em PT com vocabulário próprio | Lista em PT |
| Quatro qualidades (propósito, concisão, conversa, clareza) | SKILL abertura; acessibilidade-e-checklist.md nota 0 a 10 | Igual |
| Tipos de erro (validação, sistema, bloqueio, permissão) | SKILL "Tipos de erro" | Exemplos PT |
| Tom por estado emocional e por tipo de conteúdo | SKILL "Tom pelo momento" | Igual |
| Quadro de voz (conceitos, adjetivos, faça/não faça) | SKILL plano | Gerado do briefing, gravado com `update_knowledge` |
| Padrões detalhados em 3 vozes | padroes-por-elemento.md | Clínica, restaurante, loja jovem |
| Moldes de estado vazio, erro, onboarding | padroes-por-elemento.md | Igual, exemplos PME |
| Processo de edição em 4 fases | Coberto pela checagem de 8 perguntas e pela nota das quatro qualidades | Unificado |
| Metas de tamanho e compreensão (8/14/25 palavras) | acessibilidade-e-checklist.md; SKILL regra 5 | Recalibrado para 13 a 18 palavras (português simplificado) |
| Nível de leitura (7ª série etc.) | acessibilidade-e-checklist.md | Traduzido para PorSimples e Lei 15.263/2025 |
| Acessibilidade (leitor de tela, cognitiva, cor, WCAG 4,5:1) | acessibilidade-e-checklist.md; SKILL construção | Contraste pelos tokens do tema (a IA não escolhe cor) |
| Escrever para tradução e texto 20 a 40% maior | acessibilidade-e-checklist.md | Sem concatenar frases; plural tratado |
| Linguagem inclusiva | acessibilidade-e-checklist.md | Exemplos PT |
| Texto regulado e padrões enganosos (confirmshaming) | acessibilidade-e-checklist.md; SKILL edição 6 | Consentimento LGPD |
| Checklist de fluxo inteiro (9 passos) | acessibilidade-e-checklist.md; SKILL edição 5 | Igual |
| Exemplos antes/depois com nota | acessibilidade-e-checklist.md | Em PT |
| Ferramentas de teste (Hemingway, WAVE, axe, VoiceOver) e integração Figma | Fora | O gerador não executa ferramentas; a plataforma já abre o app no navegador e revisa critérios de aceite |
| Locale britânico padrão (ill-communication) | Trocado por PT-BR e formatos brasileiros | Regra 8 |

Trocas principais e motivo:
- A linha "Needs:" da humbleteam virou pergunta no `finish`, porque o app gerado lê o dado real do banco na hora e só a regra do negócio fica com o dono.
- Métricas de teste com usuários e ferramentas externas saíram: a conferência vira critério de aceite que a plataforma revisa depois do build.
