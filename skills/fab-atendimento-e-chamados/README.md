# Atendimento e Chamados

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- Os dados de exemplo (que no Studio eram proposta para o dono aprovar) viraram dados de teste criados pela pré-visualização e apagados depois; etapas padrão continuam no botão do próprio app, e o dono cadastra ou importa no CMS.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz o app gerado ter uma central de atendimento: chamado com protocolo, etapas configuráveis, prioridade, prazo
(SLA), triagem, responsável, conversa com o cliente separada da nota interna, fechamento com resolução obrigatória,
operações em massa com prévia e relatórios de tempo de resposta.

- **Categoria**: other
- **Etapas**: briefing, plan, build, edit
- **Tokens aproximados**: ver a saída do validador no fim deste arquivo.

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| `ticket-resolution` | https://github.com/HubSpot/agent-cli-skills (commit 71f2bde) | Apache 2.0, Copyright 2026 HubSpot, Inc. |
| `bulk-operations` (+ `resources/json-patterns.md`, `resources/pagination-loop.sh`) | idem | Apache 2.0, Copyright 2026 HubSpot, Inc. |

Obra derivada sob a Apache 2.0: texto reescrito em português para outra finalidade (construir apps na Fabapp, não
operar o CLI da HubSpot). Nenhum trecho foi colado. Também guiou o desenho a análise interna
`analise/03-crm-e-negocio.md` (seções 1.4, 1.5, 2.1, 2.4 e 4.1 a 4.2).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Descobrir pipelines e etapas a cada sessão; ids de etapa variam por portal, nunca fixar | SKILL.md regra 2; Construção "Etapas e opções vêm do banco"; critério de aceite | Etapas viram registros `ticket_stage` com `kind`; o código lê do banco e nunca fixa id |
| Conferir valores de enum (prioridade, categoria, resolução) no portal, não supor o padrão | Edição "Antes de mexer em opções" | `read_file` do esquema e `read_records` antes de mudar opções |
| Criar chamado: só `subject` obrigatório; sem etapa cai na primeira etapa do pipeline padrão | Construção "Criar chamado" | Assunto e descrição obrigatórios com zod; entra na primeira etapa `open` pela ordem |
| Associar chamado a contato e empresa | fab-modelo-de-dados.md (`customer`, `company`, `requester_*`) | `ref` quando o app já tem os modelos; campos de texto para visitante |
| Entrada em massa de uma fila JSONL | operacoes-em-massa.md seção 8 | Importação de planilha com `CsvImport`, chave natural normalizada e relatório por linha |
| Triagem: abertos por prioridade; sem responsável | Plano tela Triagem; relatorios.md cartões | Tela própria e cartões com `count()` |
| Filtrar por responsável | Fila, filtro por responsável; aba Meus | Filtro no servidor |
| Avançar etapa em massa a partir de uma busca, com dry-run antes | operacoes-em-massa.md seções 1 a 4 | Prévia obrigatória com contagem e amostra antes de gravar |
| Acima de 100 linhas: digest que expira em 5 min e `--confirm` com a contagem | operacoes-em-massa.md seção 3 | Digitar o número exato acima de 100; prévia vale 5 minutos e é refeita |
| Reatribuir em massa | operacoes-em-massa.md seção 6 | Filtro por responsável, prévia, confirmação |
| Registrar nota de resolução ligada ao chamado | SKILL.md Construção "Responder e registrar", `ticket_note` | Nota interna em modelo separado, invisível ao cliente |
| Fechar com `hs_resolution` de lista, não texto livre; o sistema calcula fechado, data e tempo | SKILL.md regras 3 e 4; "Fechar e reabrir" | Resolução em enum mais nota obrigatória; `closed_at` e tempos gravados pelo fluxo, nunca digitados |
| Limitação: sem API de conversas/caixa de entrada | SKILL.md Edição e "o que NÃO vamos construir" | A plataforma também não lê e-mail; WhatsApp só avisa. A equipe registra; dito ao dono |
| Saída de escrita: um resultado por linha na ordem da entrada (`ok` ou erro) | operacoes-em-massa.md seção 4 | Relatório por registro e "tentar de novo só os que falharam" |
| Ler em lote, nunca um por um | operacoes-em-massa.md seção 1; relatorios.md | `list` paginada com `fields`, nunca `get` em laço |
| Paginar antes de operar; 100 por página; nunca contar com uma chamada solta | relatorios.md; operacoes-em-massa.md; critério de aceite | Paginar com `limit:200` até voltar menos; "resultado do tamanho exato da página está cortado" |
| Remodelar leitura em escrita (`jq`) | operacoes-em-massa.md seção 4 | `updateMany(ids, data)` em lotes de 200 |
| `history` é log de auditoria, não desfaz | operacoes-em-massa.md seção 5; modelo `audit_log` | Log com valores anteriores; "Desfazer" só para mover e reatribuir; apagado não volta |
| Upsert vence buscar e depois criar; chave natural em minúsculas | operacoes-em-massa.md seção 8; duplicidade no formulário público | Não há upsert nem índice único: normalizar e conferir com `count` antes de criar |
| Higiene de limite de taxa: testar com poucas linhas; 429 por linha, refazer só as falhas | operacoes-em-massa.md seção 4 | 429 tenta o lote uma vez, depois para e mostra o pendente |
| Frequência por campo (contar por valor) | relatorios.md "Por categoria", "Resoluções", "Por canal" | `count()` por valor |
| Exportar para CSV | operacoes-em-massa.md seção 8 (implícito) e peça `CsvExport` | Sugerido via peça pronta da plataforma |
| Operações destrutivas bloqueadas por tipo de credencial | operacoes-em-massa.md seção 7 | Vira permissão: `admin` ou `perm:tickets.bulk` |
| Enviar feedback ao CLI | fora | Não se aplica a um app gerado |
| `owners list`; equipe não é objeto, agrupar por dono no cliente | fab-modelo-de-dados.md (papéis por equipe, campo `team`) | Equipe vira papel e campo |
| Relatório "tickets urgentes abertos há mais de 7 dias" (da análise, sinal de retenção) | relatorios.md | Lista com filtro por `opened_at` |
| Template de domain skill da análise (quando usar, entidades, campos, estados, telas, relatórios, automações, regras BR, papéis, seed, não fazer) | SKILL.md inteiro e fab-modelo-de-dados.md | Cada seção do template tem destino |

Acréscimos da versão Fabapp sem equivalente direto na original: protocolo autonumerado, SLA com tabela padrão,
formulário público com acesso de visitante, área "Meus chamados", avisos por automação, regras do Decreto do SAC,
CDC e LGPD, armadilha do filtro por `created_at` (a plataforma só filtra campos declarados).

## Saída do validador

```
name=fab-atendimento-e-chamados stages=('briefing', 'plan', 'build', 'edit') body_all~4560 tokens per_stage={'briefing': 1798, 'plan': 2271, 'build': 2551, 'edit': 2867} refs~4227 tokens files=4
title: Atendimento e Chamados | desc chars: 1002
OK
```
