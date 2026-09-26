# Modelo de dados, acessos e avisos (retenção)

Tudo vai no `fab.schema.json` (depois de `fabapp pull`), enviado com `fabapp push`. Ids em inglês, rótulos em português. Papel da equipe: `atendente`. Dono e admin são
superusuários. Filtros de data sempre em campos declarados: a plataforma não filtra por `created_at` (dá 422).

## Campos de retenção no cliente

Se o app já tem `customer` (ou `student`, `patient`, `client`), acrescente estes campos a ele; senão, crie
`customer` com `name` (labelField), `phone` phone, `email` email e estes:

| campo | tipo | observação |
|---|---|---|
| started_at | datetime, required | início do relacionamento; base das boas-vindas |
| owner_user | ref `app_user` | responsável pelo cliente |
| customer_user | ref `app_user` | quando o cliente tem login no app |
| marketing_opt_in | boolean | começa falso (nomes de padroes-brasil) |
| marketing_opt_in_at | datetime | |
| marketing_opt_in_channel | enum | `form, whatsapp, balcao, importacao, app` (Formulário, WhatsApp, Balcão, Importação, App) |
| marketing_opted_out_at | datetime | descadastro; bloqueia marketing |
| winback_sent_at | datetime | última tentativa de reconquista |
| last_contact_at | datetime | último contato da equipe (tarefa feita ou mensagem enviada) |
| key_contact_left | boolean | cliente empresa: a pessoa que decidia saiu |
| competitor_note | boolean | disse que está olhando outro fornecedor |
| lost_at | datetime | |
| lost_reason | enum | `price, service, quality, moved, no_need, competitor, unknown` (Preço, Atendimento, Qualidade, Mudou de cidade, Não precisa mais, Foi para concorrente, Não informou) |
| lost_signals | list of text | motivos de risco no momento da perda |
| goal | text | o que o cliente quer alcançar, anotado no início |

Acesso do cliente (quando não havia regra melhor no app):
```json
{"read": {"any": ["role:atendente", {"owner_field": "customer_user"}]},
 "create": {"any": ["role:atendente"]},
 "update": {"any": ["role:atendente"]},
 "delete": "role:admin"}
```

Cliente com login: o sinal "sem usar o app" vem do modelo `usage_ping` (abaixo), não do perfil do usuário. A
permissão `users.read` só dá à equipe um diretório (id, nome, papéis); campos extras do perfil (`appUser.fields`)
não chegam a quem não é admin, então não guarde a última atividade lá. Nunca crie modelo espelho do usuário.
Para o seletor de responsáveis (`admin.listUsers`), o papel `atendente` recebe `users.read`:
`{"slug":"atendente","name":"Atendente","description":"Cuida da carteira de clientes","permissions":["users.read"]}`.
Se o papel `atendente` já existe no app, mantenha as permissões dele e só acrescente `users.read`.

Em cadastro de clientes que já existia no app, `started_at` entra como opcional e o código preenche na primeira
leitura com a data do evento de valor mais antigo do cliente; `required` só quando o `customer` nasce nesta skill.

## `usage_ping` (uso do app pelo cliente com login; um por dia)
`user` ref `app_user` required, `customer` ref required, `day` date required (labelField). Ao abrir o app, o
cliente logado confere com `count({user, day})` e cria um registro para o dia se não houver. Acesso:
`{"read":{"any":["role:atendente",{"owner_field":"user"}]},"create":{"owner_field":"user"},"update":"role:admin","delete":"role:admin"}`.
"Sem usar o app há 30 dias" = nenhum `usage_ping` do cliente nos últimos 30 dias (filtro por `day`).

## `visit` (evento de valor, só quando o app não tem pedido, agendamento ou pagamento)
`customer` ref required, `happened_at` datetime required, `amount` money, `kind` text (labelField), `note` text.
Acesso: tudo `{"any":["role:atendente"]}`, delete `role:admin`.

## `retention_task` (tarefa de contato)
| campo | tipo | observação |
|---|---|---|
| title | text, required | labelField ("Ligar para Dana R.") |
| customer | ref, required | tarefa sem cliente não existe |
| assigned_to | ref `app_user`, required | |
| due_at | datetime, required | |
| kind | enum | `call, whatsapp, email, visit, review` (Ligar, WhatsApp, E-mail, Visita, Revisar) |
| playbook | enum | `red, yellow, onboarding, winback, manual` |
| step | text | "Dia 3: plano com prazo" |
| reason | text | motivos de risco no momento da criação |
| status | enum | `open, done, no_answer, canceled` (Aberta, Feita, Sem resposta, Cancelada) |
| outcome | text | o que aconteceu |
| done_at | datetime | |

Acesso: leitura e escrita `{"any":["role:atendente"]}`; delete `role:admin`. A tela "Minhas tarefas" filtra por
`assigned_to`. Concluir grava `done_at` e `last_contact_at` no cliente.

## `outreach` (histórico de mensagens, só cresce)
`customer` ref required, `channel` enum `whatsapp_link, whatsapp_api, email, sms, push, call`, `kind` enum
`welcome, first_steps, check_in, winback, retention, transactional`, `is_marketing` boolean, `body` text
(labelField), `offer` text, `approved_by` ref `app_user`, `sent_at` datetime required, `response` enum `none,
replied, came_back, opted_out`. Acesso: leitura e criação `{"any":["role:atendente"]}`; update só `response`
pela tela; delete `role:admin`.

## `journey_step` (textos das boas-vindas; o dono edita)
`day` number required (0, 1, 3, 7, 14, 30), `title` text (labelField), `message_activated` text, `message_not_yet`
text, `is_marketing` boolean, `active` boolean. Acesso: leitura `authenticated`, escrita `role:admin`. Mudar o DIA
exige mudar a automação: a tela diz "Para mudar o dia, peça ao assistente".

## `optout_request` (descadastro vindo de fora)
`contact` text required (labelField; telefone só dígitos com 55, ou e-mail em minúsculas), `channel` enum `web,
whatsapp, email, in_person`, `requested_at` datetime required, `applied_at` datetime. Acesso:
`{"read":"role:admin","create":"public","update":"role:admin","delete":"role:admin"}`.

## `retention_settings` (um registro)
`inactive_days` number (60), `active_window_days` number (90), `activation_rule` text (a regra em português, ex.:
"2º atendimento em até 45 dias"), `activation_window_days` number, `red_threshold` number (70),
`yellow_threshold` number (40), `weights` json (pontos por sinal; vazio = tabela padrão), `authorized_offers` list
of text, `signature` text, `business_whatsapp` phone, `consent_text` text. Acesso: leitura
`{"any":["role:atendente"]}`, escrita `role:admin`.

## `risk_snapshot` (retrato para tendência)
`period` text required (labelField, "2026-S39" ou "2026-09"), `kind` enum `week, month`, `red` number, `yellow`
number, `green` number, `active` number, `lost` number, `new_customers` number, `reactivated` number,
`churn_rate` number, `measured_at` datetime. Acesso: leitura `{"any":["role:atendente"]}`, criação
`{"any":["role:atendente"]}`, update e delete `role:admin`. Antes de gravar, `count({period})` para não duplicar.

## `audit_log`
Modelo `audit_log` do protocolo de operação segura (o mesmo da skill `dados-seguros`, se instalada) (`actor`, `action` text, `model`, `record_id`, `filter`, `expected`,
`affected`, `summary`). Campos extras da retenção: `record_ids` json, `before` json, `after` json.

## Avisos (`fab.automations.json`)

O arquivo substitui o conjunto inteiro: rode `fabapp pull`, acrescente estas regras às que já existem e envie tudo com `fabapp push`.

Nas regras abaixo, `customer` é o id do cadastro real de clientes do app (troque por `student`, `patient` etc.
quando for o caso); o campo e os `ref` precisam existir no esquema, senão a regra nunca dispara.

Um aviso à equipe por dia das boas-vindas (repita a regra para 0, 1, 3, 7, 14 e 30, mudando `offset_days` e o título):
```json
{"name": "Boas-vindas dia 3",
 "trigger": {"type": "relative", "model": "customer", "field": "started_at", "offset_days": 3},
 "action": {"type": "notify", "channel": "inapp", "to": "owner_user",
            "title": "Dia 3 de {{name}}", "body": "Hora do check-in.", "link": "/retencao/boas-vindas"}}
```
Cliente com login recebe o seu (mesmos dias, `to: "customer_user"`, `channel: "push"`), com texto de
relacionamento sem oferta, porque a automação não sabe se ele aceitou marketing:
```json
{"name": "Boas-vindas ao cliente",
 "trigger": {"type": "relative", "model": "customer", "field": "started_at", "offset_days": 0},
 "action": {"type": "notify", "channel": "push", "to": "customer_user",
            "title": "Boas-vindas, {{name}}!", "body": "Veja como aproveitar desde o primeiro dia.", "link": "/"}}
```
Demais:
```json
[
 {"name": "Tarefa vencendo",
  "trigger": {"type": "relative", "model": "retention_task", "field": "due_at", "offset_days": 0},
  "action": {"type": "notify", "channel": "inapp", "to": "assigned_to",
             "title": "{{title}}", "body": "Se já fez, marque como feita.", "link": "/retencao"}},
 {"name": "Clientes em risco de hoje",
  "trigger": {"type": "schedule", "every": "daily"},
  "action": {"type": "notify", "channel": "inapp", "to": "admin",
             "title": "Veja quem está sumindo", "body": "A lista de hoje está pronta.", "link": "/retencao"}},
 {"name": "Pedido de descadastro",
  "trigger": {"type": "data", "model": "optout_request", "event": "created"},
  "action": {"type": "notify", "channel": "inapp", "to": "admin",
             "title": "Pedido de descadastro", "body": "{{contact}}", "link": "/retencao"}}
]
```
- Sem `owner_user` preenchido o aviso das boas-vindas não chega a ninguém: o cadastro do cliente preenche com quem
  cadastrou, e a tela Hoje mostra os passos do dia de qualquer forma.
- Automação `relative` dispara uma vez por registro, na hora cheia; não tem condição.
- Limite da plataforma: 30 avisos por pessoa por hora.

## Dados de exemplo (marcados como exemplo)

O CLI não grava registros. Este conjunto fica numa constante e o botão "Carregar exemplos" (só admin, com prévia e contagem) grava pelo próprio app; o dono também pode cadastrar ou importar pelo CMS do Studio. Nunca diga ao dono que criou os dados.

25 clientes com nomes e DDDs variados; eventos de valor de 15 meses com ritmos diferentes (semanais, mensais,
trimestrais, um anual); 4 clientes sumidos (um com avaliação ruim, se o app tem avaliações), 5 quietos, 3 novos
nas boas-vindas, 2 perdidos com motivo; 2 sem consentimento de marketing e 1 descadastrado.
