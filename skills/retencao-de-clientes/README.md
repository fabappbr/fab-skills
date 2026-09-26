# Retenção de Clientes

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- O CLI não grava registros: os dados de exemplo vêm de um botão "Carregar exemplos" no app ou do CMS do Studio.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz o app achar o cliente que está sumindo antes de ele ir embora, com nota de risco explicável, roteiros de contato
em tarefas criadas em massa com prévia, sequência de boas-vindas do cliente novo em dias fixos, reconquista de inativos com mensagem
aprovada pelo dono, consentimento e descadastro (LGPD) e relatórios de retenção e perda mensal.

- **Categoria**: other
- **Etapas**: briefing, plan, build, edit
- **Tokens aproximados**: ver a saída do validador no fim deste arquivo.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| `customer-retention` (+ `resources/customer-health-signals.md`) | https://github.com/HubSpot/agent-cli-skills (commit 71f2bde) | Apache 2.0, Copyright 2026 HubSpot, Inc. |
| `bulk-operations` (padrões de segurança citados pela `customer-retention`) | idem | Apache 2.0, Copyright 2026 HubSpot, Inc. |
| `churn-prediction` (+ `references/framework-notes.md`, `gtm-lifecycle-stages.md`, `lifecycle-metrics-by-stage.md`, `templates/output-template.md`, `scripts/check-output.py`) | https://github.com/LeadMagic/gtm-skills (commit 547f9b0) | MIT, Copyright (c) 2026 LeadMagic LLC |
| `onboarding-sequences` (+ `references/framework-notes.md`, `activation-playbook.md`, `lifecycle-skill-index.md`, mesmas referências compartilhadas, template e script) | idem | MIT, Copyright (c) 2026 LeadMagic LLC |

Aviso exigido pela licença MIT das partes derivadas da LeadMagic:

> Copyright (c) 2026 LeadMagic LLC. Permission is hereby granted, free of charge, to any person obtaining a copy of
> this software and associated documentation files (the "Software"), to deal in the Software without restriction,
> including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
> conditions: The above copyright notice and this permission notice shall be included in all copies or substantial
> portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.

Obra derivada: texto reescrito em português, com mudança de finalidade (de agente que opera CRM ou escreve um plano
para app que faz o trabalho). Também guiou o desenho a análise interna `analise/03-crm-e-negocio.md` (2.4
Retenção, 4.1 e 4.2) e o trecho de clientes quietos da `review-reputation` (anthropics/knowledge-work-plugins,
Apache 2.0).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| HubSpot: achar clientes sem contato há 60 dias, sem atividade de vendas, nunca contatados | risco-e-relatorios.md seção 6; ponto "sem contato há 60 dias"; prazo de parado padrão 60 | `last_contact_at` gravado quando tarefa ou mensagem acontece |
| Verificar propriedades no portal antes de filtrar | SKILL.md "Evento de valor"; sinais desligados sem fonte | O plano nomeia os modelos reais; sinal sem fonte aparece como "sem dados" |
| Assinaturas em atraso ou canceladas (receita em risco) | pontos de pagamento atrasado; churn de assinatura | Lê a cobrança que o app tiver |
| Ligar assinatura em risco ao contato | tarefa sempre com `ref` do cliente | Igual |
| Tarefa de follow-up associada; tarefa sem associação é invisível | SKILL.md regra 4; `retention_task.customer` obrigatório | Igual |
| Criação de tarefas em massa para uma coorte, dry-run antes, ordem preservada | SKILL.md "Criar plano"; risco-e-relatorios.md seção 4 | Prévia, `bulkCreate` atômico em lotes de 200, relatório por lote |
| Digest acima de 100 e confirmação com a contagem; paginação; log de auditoria sem desfazer | risco-e-relatorios.md seção 4 | Digitar o número acima de 100; prévia de 5 minutos; `audit_log` |
| Sinais nível 1: sem contato 60 dias, assinatura atrasada, ticket alto ou urgente com mais de 7 dias, opt-out de e-mail | risco-e-relatorios.md seção 2 e 6 | Pontos e listas; descadastro bloqueia marketing |
| Sinais nível 2: sem atividade 30 dias, sem engajamento de e-mail 45 dias, empresa sem negócio aberto | seção 2 (uso caiu, sem usar o app), seção 6 (empresa sem evento) | Abertura de e-mail não é medida pela plataforma: trocada por uso do app e eventos |
| Combinar sinais (OU) e deduplicar | `computeRisk` soma por cliente | Um cliente, uma nota |
| Lacuna: sem nota de saúde nativa, usar propriedade própria | nota calculada em `src/lib/retention.ts` | Calculada ao abrir, retrato em `risk_snapshot` |
| Lacuna: sem sequências de reengajamento | sequência de boas-vindas e reconquista | Automações `relative` avisam e a equipe envia |
| LeadMagic churn: indicadores antecedentes olhando 90 dias antes da perda | risco-e-relatorios.md abertura e revisão trimestral | `lost_signals` guarda os sinais na perda |
| Sinais de uso (login caindo, uso da função chave -30%, 14 dias sem ação chave, vários usuários parando, falhas repetidas) | seção 2 | Viraram eventos de valor, queda de uso 20-50% e mais de 50%, sem usar o app 30 dias |
| Sinais de engajamento (e-mail, sentimento do suporte, sem resposta 2 tentativas, reunião perdida) | seção 2 | Avaliação ruim, chamados, 2 tentativas sem resposta, falta no agendamento |
| Sinais de negócio (campeão saiu, cortes, concorrente, renovação chegando sem engajamento) | seção 2 | Marcações manuais: contato principal saiu (40), concorrente (5); corte e renovação: fora por falta de fonte, anotados na tarefa |
| Pesos Crítico 40, Alto 25, Médio 20, Baixo 15 | seção 2 | Mesmos números nos sinais equivalentes |
| Faixas Vermelho 70+, Amarelo 40-69, Verde abaixo de 40, com prazo de risco | SKILL.md; seção 2; critério | Igual, editável em Ajustes |
| Roteiro Vermelho (4 h, executivo, causa, plano, dia 7, dia 14 escala) e Amarelo (e-mail, ligar dia 2, valor dia 5, escala dia 10) | seção 3 | Viram tarefas com datas; "executivo" vira o dono |
| Monitoramento diário, rota de alerta, painel ordenado por risco, tendência semanal | SKILL.md regra 8; automação diária; `risk_snapshot` | Sem tarefa agendada: cálculo ao abrir e aviso diário |
| Retroalimentação: pós-morte das perdas, ajuste trimestral de pesos, falsos positivos, precisão contra cobertura | seção 5 "Revisão trimestral" | Frases de ajuste com números; mudança registrada |
| Métricas de retenção (GRR, churn de clientes, % em risco alto, taxa de salvamento, contração) | seção 5 tabela | Adaptadas; GRR e contração só fazem sentido em assinatura, cobertos pelo churn de assinatura; referência SaaS citada como tal |
| Checagem de qualidade e script `check-output.py` | critérios de aceite | O script só conferia palavras num documento; trocado pelos critérios conferíveis da plataforma |
| Template de saída do agente | fora | O resultado é o app |
| Citar frameworks nomeados (Gainsight, Reforge, Lincoln Murphy) | fora | O dono leigo não precisa; as técnicas estão todas no texto |
| Onboarding: momento de valor define tudo; 40-60% da perda nos 90 dias | boas-vindas-e-mensagens.md abertura e seção 1 | Evento de ativação por nicho |
| Exemplos de momento de valor por tipo de produto | seção 1 tabela | Reescrita para negócios locais |
| Meta: 80% ativam na 1ª semana; ativado retém 80%, não ativado menos de 30% | seção 1 métricas | Meta de 70% (linha de pequena empresa da referência de métricas) e prova 2x com os dados |
| Mapa das boas-vindas dias 0, 1, 3, 7, 14, 30 | seção 2; automações | Igual, com variante ativado ou não |
| Multicanal: no app (3 passos, não o tour), e-mail disparado por comportamento, SMS, ligação para cliente grande | seções 2 e 3 | Variante por comportamento na tela; SMS e ligação incluídos |
| Conteúdo: guia rápido, vídeo, biblioteca de modelos, FAQ | SKILL.md próximos prompts | Página "Primeiros passos" como próximo prompt (não aumenta o MVP) |
| Medição: ativação, tempo até valor, conclusão, perda no início, A/B, cortar passo sem efeito | seção 1 métricas; seção 2 "Melhorar a sequência de boas-vindas" | Sem A/B automático: um texto por vez, mês contra mês |
| Playbook de ativação: definição, benchmarks de TTA por segmento, planilha para escolher o evento, passagem de bastão, experimentos, anti-padrões de vaidade, checklist de auditoria com nota | seção 1 (definição, vaidade, prova 2x), seção 6 (checklist com nota 9, 6-8, 5) | Benchmarks por faixa de contrato em dólar trocados por janela por nicho; experimentos viram mudança de um texto por vez; passagem vendas para sucesso vira "responsável do cliente" |
| Estágios do ciclo de vida, Bowtie, índices de skills, métricas de outros estágios (consciência, aquisição, receita, indicação) | fora | Fora do escopo de retenção; indicação e avaliação são cobertas por outras skills da equipe, sugeridas ao dono |
| Métricas de ativação e retenção com Verde/Amarelo/Vermelho | risco-e-relatorios.md seção 5; boas-vindas-e-mensagens.md seção 1 | Mantidas as linhas aplicáveis |
| review-reputation: ritmo próprio (2x quieto, 3x sumido), menos de 3 pedidos usa mediana com selo de estimativa, ordenar por valor, crítica mais sumiço no topo, tabela de oferta por segmento, parar depois de uma, perguntar o que o dono pode honrar | SKILL.md regras 2, 3, 6, 7; risco seção 1; sequência de boas-vindas seção 4 | Igual |

Acréscimos Fabapp: consentimento e descadastro com registro (LGPD), regras da Meta para WhatsApp, CDC arts. 30 e 42,
horário de envio, limite de uma mensagem de marketing por semana, armadilha do filtro por `created_at`.

## Saída do validador

```
name=retencao-de-clientes stages=('briefing', 'plan', 'build', 'edit') body_all~3865 tokens per_stage={'briefing': 1655, 'plan': 1989, 'build': 2114, 'edit': 2350} refs~7143 tokens files=4
title: Retenção de Clientes | desc chars: 1007
OK
```
