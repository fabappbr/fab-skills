# Dados Seguros (`dados-seguros`)

## Edição terminal

Esta é a edição para agentes que constroem pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio. O que mudou:

- Topo com primeiro movimento (`references/fabapp-cli.md`), contrato ao vivo e a regra das duas mãos; `DECISOES.md` lido no começo e usado para registrar decisões de acesso.
- O `access` é escrito no `fab.schema.json` (`fabapp pull`, editar, `fabapp push`) com a mesma gramática; funções e manifesto sobem com `fabapp deploy`, que não confere o manifesto.
- O plano é um texto mostrado ao dono antes de codar; os critérios de aceite viraram a lista de conferência, com os 4 itens (sem o teto de 3 do Studio).
- Pergunta ao dono pela ferramenta de perguntas de opção do agente (ou mensagem com opções numeradas).
- Dados reais: o CLI não grava registros. Onde o Studio propunha preenchimento ou exclusão aprovada pelo dono, a skill manda o dono ao CMS do Studio ou a uma tela de admin do próprio app.
- "Conferir antes de dizer pronto" ganhou busca por texto, teste com visitante, usuário comum e equipe na pré-visualização do `fabapp dev`, e a lista do que o dono faz no Studio (gateway, papéis, cadastros).
- `lookup_docs` virou `fabapp_docs` ou `llms-full.txt`; dependências entram com `npm install` dentro de `.fabapp/workspace`.

Segurança e integridade dos dados no modelo de acesso real da Fabapp (o `access` por modelo do `set_schema`, as funções de backend e os pagamentos da plataforma): padrão de acesso por modelo, autenticação diferente de autorização, armadilhas silenciosas, operações em massa com prévia, confirmação e auditoria, importação por chave natural, arquivamento e pagamento confirmado só pela plataforma.

- **Categoria:** other
- **Etapas:** plan, build, edit
- **Tokens (saída do validador):** corpo ~6.100 (plano ~1.900, construção e edição ~5.340); referências ~9.900 (`regras-de-acesso.md`, `massa-importacao-pagamentos.md`)

## Origem e licenças

| Fonte | Repositório | Licença |
|---|---|---|
| supabase (SKILL.md, references/skill-feedback.md, assets, CHANGELOG) | https://github.com/supabase/agent-skills (commit 551274e) | MIT, "Copyright (c) 2026 Supabase" |
| supabase-postgres-best-practices (SKILL.md e as 30 referências) | idem | MIT, "Copyright (c) 2026 Supabase" |
| stripe-best-practices (SKILL.md e references/ billing, connect, payments, security, tax, treasury) | https://github.com/stripe/ai (commit a4b08e0) | MIT, "Copyright (c) 2024-2025 Stripe" |
| bulk-operations (SKILL.md, resources/json-patterns.md, resources/pagination-loop.sh) | https://github.com/HubSpot/agent-cli-skills (commit 71f2bde) | Apache 2.0, "Copyright 2026 HubSpot, Inc." |

Texto reescrito em português e adaptado; nenhum parágrafo copiado. As licenças MIT exigem manter o aviso de copyright e a permissão em cópias substanciais; a Apache 2.0 exige indicar que houve modificação: este material é obra derivada modificada, reescrita para a plataforma Fabapp.

Análises usadas: `analise/02-codigo-e-processo.md` §2 (Supabase) e `analise/03-crm-e-negocio.md` §1.4 a §1.6 (prévia, digest e confirmação; idempotência e chaves naturais; qualidade de dados) e §3.3 (Stripe).

## Fatos da plataforma conferidos no código (26/09/2026)

- A plataforma carimba o campo de dono na criação quando a regra de criação tem `owner_field`/`owner_in`, e só quem é autorizado por papel (ou o admin) preenche outro id (`appapi/service.py`, `_stamp_owner` e `_may_assign`). Por isso a skill usa `{"any":["role:staff",{"owner_field":"customer"}]}` na criação.
- O filtro de lista aceita só campos do schema e `created_by`/`owner_id`/`user_id`: `id`, `created_at` e `updated_at` dão 422 (`_apply_filters`); ordenar por `created_at` pode. A skill não filtra por `id` nem por data de sistema.
- O checkout lê o valor do registro referenciado (`product_id` ou `model_id`+`record_id`, campo `price`, depois `total`...), mas um item sem referência segue com o `amount` que o navegador mandou (`payments/service.py`, `_resolve_checkout_items`). A skill proíbe `amount` e cobrança pelo `total` de um pedido calculado na tela.
- O pedido canônico tem `buyer`, `total`, `status` (`pending`, `paid`, `failed`, `refunded`, `fulfilled`) e `provider_payment_id`; o pagamento confirmado grava o status pago pelo webhook da plataforma; `past_due` mantém o acesso e só `canceled` tira.
- `status` e `total` do pedido podem ser gravados pelo cliente na criação (não há campo protegido). A skill manda conferir no gateway antes de entregar algo de valor, ou criar o pedido por função.

## Mapa de cobertura

### supabase (SKILL.md)

| Técnica original | Onde está | Adaptação |
|---|---|---|
| 1. Verificar changelog e docs antes | SKILL princípio 4 e edição | `lookup_docs` e leitura do schema atual; não suponha nome de campo |
| 2. Verificar o trabalho ("fix sem verificação é incompleto") | SKILL princípio 5 e checklist final | só relatar no `finish` o que conferiu |
| 3. Parar depois de 2 ou 3 tentativas | SKILL princípio 4, refs §4 | |
| 4. Expor tabela à Data API | fora | toda tabela da Fabapp é exposta pela API; o `access` é o único portão (dito no início do SKILL) |
| 5. RLS em toda tabela exposta, políticas do modelo real e não o mesmo `auth.uid()` em tudo | SKILL "padrões de acesso" e "access explícito em todo modelo" | 9 padrões com JSON |
| user_metadata editável não decide autorização | SKILL "Campo que a pessoa edita" e refs §3 | `appUser.fields`, campos do registro, `localStorage` |
| Excluir usuário não invalida token; claims velhas | refs §8 "ao desligar alguém" | tirar papel e membros dos registros; o JWT não é do app |
| Nunca expor service_role ou secret no cliente | SKILL "Nenhuma chave no código" e refs §4 de pagamentos | chave colada na conversa: não gravar, conectar no Studio, trocar |
| Tokens com escopo (PAT) | refs §8 privilégio mínimo | papéis e `perm:` com o mínimo |
| Views ignoram RLS | SKILL funções e refs §3 | `ctx.collection` ignora o `access`; modelo de resumo com regra própria |
| UPDATE exige política de SELECT (atualização silenciosa em 0) | refs §3 e §4 | `updated` menor que o esperado; comparar e avisar |
| `auth.role()` quebra com login anônimo | SKILL princípio 2 | `authenticated` com cadastro aberto equivale a público |
| `TO authenticated` sozinho é IDOR | SKILL princípio 2 e refs §2 | par Errado/Certo em JSON e TSX |
| UPDATE precisa de USING e WITH CHECK | SKILL "Carimbo de dono" | a plataforma impede reatribuir o campo de dono; criação com dono na regra |
| Nunca SECURITY DEFINER para resolver erro de permissão | SKILL princípio 3 e edição | nunca afrouxar a regra; pergunta com opções quando o dono pede para abrir |
| SECURITY DEFINER em `public` chamável por todos | SKILL funções e refs §3 | função `public` com `ctx.collection` é endpoint aberto |
| Storage: upsert exige INSERT+SELECT+UPDATE | refs §3 | trocado pela armadilha real de arquivo: `visibility` pública em documento |
| Fixar versões e lockfile | refs §8 | versão definida no `package.json` |
| CLI, MCP, migrações, advisors | fora | não existe CLI de banco nem migração no build da Fabapp; o schema é aplicado pelo `set_schema` |
| Debugging: buscar a doc antes de diagnosticar | SKILL edição e refs §4 | tabela de sintomas 403/401/422/402/409/lista vazia |
| skill-feedback (abrir issue) | fora | o dono não tem repositório de skill; feedback é pelo Studio |

### supabase-postgres-best-practices

| Referência | Onde está | Adaptação |
|---|---|---|
| security-rls-basics (filtro no app não é segurança) | SKILL introdução e refs §2 | par TSX: filtro na tela x regra no modelo |
| security-rls-performance | fora | a plataforma avalia as regras; o conceito de "uma checagem por lista, não por linha" está em `owner_via` e no `in` |
| security-privileges (mínimo privilégio) | refs §8 e SKILL plano (papéis) | |
| schema-data-types | refs §6 tabela | dinheiro em centavos, `date` x `datetime`, `enum`, `boolean` |
| schema-constraints | refs §6 e SKILL importação | sem restrição no servidor: `zod` e `count` antes de criar |
| schema-primary-keys | refs §6 | ids da plataforma; `autonumber` como código legível |
| schema-lowercase-identifiers | refs §6 | ids em inglês, minúsculos, com `_` |
| schema-foreign-key-indexes | refs §6 (relação no filho) | índices são da plataforma |
| schema-partitioning | fora | a plataforma cuida do armazenamento; o conceito de separar o histórico está no modelo de resumo |
| data-n-plus-one | refs §7 | `ref` do pai, `__label`, `in` em campo do schema, `Map` |
| data-pagination (cursor) | refs §7 | cursor por campo de data próprio (o filtro não aceita `created_at`) |
| data-upsert | SKILL importação e refs de massa §3 | busca em lote pela chave + `bulkCreate`/`update`; corrida residual assumida |
| data-batch-inserts | refs de massa §3 | `bulkCreate` de até 200, tudo ou nada |
| lock-short-transactions | refs §5 "ação curta" | |
| lock-skip-locked, lock-advisory | refs §5 "reivindicar com atualização condicional" | `updateWhere` pelo estado esperado + releitura; função para disputa crítica |
| lock-deadlock-prevention | fora | não há transação nem lock no app |
| query-missing/composite/covering/partial/index-types, advanced-jsonb-indexing | refs §6 e §7 | sem índices no app: filtro no servidor, projeção `fields`, campo filtrável fora de `json` |
| advanced-full-text-search | refs §7 | `contains` com debounce; limite dito |
| conn-* (pooling, limites, timeouts, prepared statements) | fora | conexões são da plataforma |
| monitor-* (EXPLAIN, pg_stat_statements, vacuum) | fora | não há acesso ao banco |
| Formato regra com impacto e par Incorrect/Correct | refs §2, §3 | |

### stripe-best-practices

| Técnica original | Onde está | Adaptação |
|---|---|---|
| Webhook obrigatório; entrega no handler, não na página de sucesso | SKILL pagamentos e refs de massa §4 | a plataforma trata o webhook; o app nunca escreve o seu; tela de retorno espera o status |
| `checkout.session.async_payment_succeeded` (pagamento atrasado) | refs de massa §4 | Pix confirma minutos depois; estado "aguardando" |
| Assinatura: ciclo de vida por eventos, dunning | refs de massa §4 | ativa, atrasada (mantém acesso), cancelada |
| Um produto por nível de plano | refs de massa §4 | um registro `plan` por nível |
| Nunca `payment_method_types` (métodos dinâmicos) | SKILL pagamentos | `paymentMethods` vazio; restringir só a pedido do dono; Pix fora de assinatura |
| Customer Portal (autoatendimento) | refs de massa §4 | tela "Minha assinatura", `PaymentMethods`, cancelamento pela loja quando `source` é da loja |
| Sandboxes e ambiente de teste separado | refs de massa §4 checklist | "se a conexão no Studio oferecer o ambiente de testes" (não prometido) |
| Chave restrita (RAK) em vez de secreta | fora (parcial) | a conexão é feita no Studio; a skill não controla o tipo de chave. Ficou a orientação de não compartilhar e trocar a chave |
| Chaves fora do código, rotação, incidente (trocar a chave vazada) | SKILL e refs de massa §4 | |
| Verificar assinatura do webhook, IP allowlist | fora | feito pela plataforma |
| CSP | fora | cabeçalho é da plataforma |
| Chave em app móvel ou cliente | SKILL "Nenhuma chave no código" | |
| OAuth `state` (CSRF) | fora | login social é da plataforma |
| 2FA por app autenticador, não SMS | refs de massa §4 e refs §8 | conta do gateway; `<TwoFactor/>` para a equipe do app |
| SAML/SCIM | fora | não se aplica a pequeno negócio no app gerado |
| PCI: nunca dados de cartão no seu servidor | SKILL pagamentos | `<PaymentMethods/>` |
| Tax: não assumir que o imposto está ligado; não aconselhar onde registrar | SKILL pagamentos e checklist | o app não calcula imposto nem emite nota; "consulte o contador" |
| Connect (marketplace, divisão, liability) | SKILL plano ("o que NÃO vamos construir") e checklist | não há divisão de pagamento; tudo cai na conta do dono |
| Treasury, API version, SDKs, `StripeClient`, `integration_identifier`, APIs obsoletas | fora | código de integração é da plataforma |
| Mapear eventos por metadata só como alternativa | trocado | na Fabapp o vínculo É `metadata.order_id` (contrato da plataforma) |
| Go-live checklist | refs de massa §4 | 7 itens em linguagem de dono |
| Valor nunca vindo do cliente (implícito no Checkout Sessions) | SKILL e refs de massa §4 | proibido `amount` em item; não cobrar `total` calculado na tela |

### bulk-operations (HubSpot)

| Técnica original | Onde está | Adaptação |
|---|---|---|
| Dry-run antes de toda operação destrutiva | SKILL massa passo 1 e refs de massa §1 | prévia com contagem e 5 nomes |
| Até 100: prévia por registro; acima: digest que expira em 5 min e `--confirm` com a contagem | SKILL massa passo 2 e 3, refs §1 | até 20 confirma num clique; acima de 20 (ou excluir de vez) digita o número; recontagem na hora substitui a expiração; a execução age sobre os ids fechados da prévia |
| Merge irreversível | refs de massa §2 | mesclar duplicados com prévia dos filhos movidos |
| `history` é log de auditoria, não desfazer | SKILL massa passo 4 e modelo `audit_log` | `create` com `owner_field` impede log em nome de outro |
| Upsert em vez de buscar e criar | SKILL importação e refs de massa §3 | busca em lote pela chave + criação/atualização; corrida residual assumida |
| Chave natural em minúsculas | SKILL importação | e-mail, CPF/CNPJ, telefone normalizados, mesma função do formulário |
| Resultado por linha, na ordem da entrada | refs de massa §3 `executar` | relatório, baixar erros, reenviar só os erros |
| Abortar antes de associar se algum create falhou | SKILL importação passo 6 e refs de massa §3 | pais antes dos filhos |
| Ler em lote, nunca um por um | SKILL importação passo 3 e refs §7 | `in` em blocos de 200 |
| Paginar primeiro; resultado de exatamente 100 está truncado | refs §7 "somar exige percorrer todas as páginas" e `prepararPrevia` | |
| pagination-loop.sh (laço por cursor) | refs de massa §1 `prepararPrevia` | laço de `offset` até página menor que o lote |
| Rate limit: testar com 50 linhas; 429 por linha, refazer só as falhas | refs de massa §3 | prévia das 10 primeiras; 5 por vez; 429 com espera e nova tentativa |
| Tabela de frequência (contagem por campo) | refs §7 | um `count` por opção do `enum` |
| Unir e deduplicar duas buscas | refs §7 (`Map` por id) | |
| Exportar CSV | refs de massa §3 | `<CsvExport/>` ou CSV gerado |
| Filtro numérico que o servidor não faz | refs §7 | operadores `gt/lt` no servidor; o resto no cliente depois de paginar |
| Associações em lote | refs de massa §2 e refs §1 (membros) | `updateWhere` no `ref` |
| `--help` é a fonte da verdade; listar tipos de objeto | SKILL edição | ler o schema atual antes de escrever |
| Feedback ao dono do CLI | fora | não se aplica |
| Formato JSONL e reshapes com `jq` | fora | não há terminal no app; os reshapes viraram código TypeScript |

### Análise 03 §1.6 (qualidade de dados)

| Técnica | Onde |
|---|---|
| Não adivinhar nome de propriedade | SKILL edição |
| Campos derivados são somente leitura | refs §6 |
| Atividade invisível até ser associada | SKILL "Registro filho é criado sempre com o `ref` do pai" |
| Resultado de 100 truncado | refs §7 |
