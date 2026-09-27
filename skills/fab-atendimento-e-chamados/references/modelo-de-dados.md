# Modelo de dados, acessos, avisos e dados de teste (atendimento)

Aplique exatamente em `fab.schema.json` (depois de `fabapp pull`; envie com `fabapp push`). Ids em inglês; rótulos em português no código de tela. Onde o app já tem `customer` ou
`company`, acrescente os `ref` marcados como opcionais; senão, deixe só os campos de texto do solicitante.

## Papéis

```json
"roles": [
  {"slug": "atendente", "name": "Atendente", "description": "Vê a fila inteira, responde, muda etapa e fecha com resolução", "permissions": []},
  {"slug": "supervisor", "name": "Supervisor de atendimento", "description": "Tudo do atendente, mais ações em massa e ajustes", "permissions": ["tickets.bulk"]}
]
```

Se o app já declara o papel `atendente` (outra parte do app), mantenha as permissões que ele tem e só acrescente
as novas. Filas separadas por equipe (ex.: técnico e financeiro): um papel por equipe (`atendente_tecnico`,
`atendente_financeiro`) e o campo `team` no chamado; a fila filtra por `team` do papel de quem abre. O acesso de
leitura continua `{"any":["role:atendente_tecnico","role:atendente_financeiro", ...]}`. O cliente final é `member`.

## Modelos

### `ticket` (chamado)
| campo | tipo | observação |
|---|---|---|
| number | autonumber | `start: 1`, `format: "CH-{00000}"` |
| subject | text, required | labelField |
| opened_at | datetime, required | gravado na criação; é o campo de data para filtros (a plataforma não filtra por `created_at`) |
| description | text, required | texto puro; o cliente não usa editor rico |
| stage | ref `ticket_stage`, required | |
| priority | enum, required | `[{value:"urgent",label:"Urgente"},{value:"high",label:"Alta"},{value:"medium",label:"Média"},{value:"low",label:"Baixa"}]` |
| category | ref `ticket_category` | |
| channel | enum | `form, app, whatsapp, phone, email, walk_in` (Formulário, App, WhatsApp, Telefone, E-mail, Balcão) |
| triaged | boolean | false na criação pelo cliente |
| requester_user | ref `app_user` | cliente logado dono do chamado |
| requester_name | text | visitante ou registro pela equipe |
| requester_email | email | |
| requester_phone | phone | |
| customer | ref `customer` | opcional, se o app tem clientes |
| company | ref `company` | opcional, clientes empresa |
| assigned_to | ref `app_user` | responsável |
| team | text | só com filas separadas |
| attachments | list of `file` | privados |
| first_response_due_at | datetime | calculado |
| due_at | datetime | prazo de resolução, calculado |
| first_response_at | datetime | gravado pelo fluxo |
| closed_at | datetime | gravado pelo fluxo |
| resolution | enum | `fixed, answered, no_customer_reply, duplicate, not_applicable, request_logged` (Resolvido, Dúvida respondida, Cliente não respondeu, Duplicado, Não procede, Pedido de melhoria registrado) |
| resolution_note | text | obrigatório ao fechar (zod) |
| resolved_by | ref `app_user` | |
| reopen_count | number | |

Acesso:
```json
{"read": {"any": ["role:atendente", "role:supervisor", "owner", {"owner_field": "requester_user"}]},
 "create": "public",
 "update": {"any": ["role:atendente", "role:supervisor"]},
 "delete": "role:admin"}
```
Sem formulário público (só área logada), troque `create` para `"authenticated"`. Nunca `read: "public"`.

### `ticket_stage` (etapa)
`name` text required (labelField), `order` number required, `kind` enum `open, waiting, closed` (Em aberto,
Aguardando cliente, Encerrado), `active` boolean. Acesso: `{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}`
(o formulário público precisa achar a primeira etapa; ninguém de fora grava).
Padrão: Novo (1, open), Em atendimento (2, open), Aguardando cliente (3, waiting), Resolvido (4, closed).

### `ticket_category` (categoria)
`name` text required (labelField), `active` boolean, `team` text (opcional). Acesso:
`{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}` (o formulário público
precisa listar as categorias; ninguém de fora grava).

### `ticket_message` (conversa com o cliente)
`ticket` ref `ticket` required, `body` text required, `author_kind` enum `customer, agent`, `channel` enum igual ao
do chamado, `attachments` list of `file`, `notify_user` ref `app_user`. labelField `body`.
```json
{"read": {"any": ["role:atendente", "role:supervisor", {"owner_via": "ticket"}]},
 "create": {"any": ["role:atendente", "role:supervisor", {"owner_via": "ticket"}]},
 "update": "role:admin", "delete": "role:admin"}
```
Mensagem não se edita depois de enviada (histórico só cresce).

### `ticket_note` (nota interna)
`ticket` ref required, `body` text required, `author` ref `app_user`. Acesso:
`{"read":{"any":["role:atendente","role:supervisor"]},"create":{"any":["role:atendente","role:supervisor"]},"update":"role:admin","delete":"role:admin"}`.

### `sla_policy`
`priority` enum igual ao do chamado (labelField), `first_response_hours` number, `resolution_hours` number.
Acesso: leitura `public` (o formulário do visitante calcula o prazo), escrita `role:admin`. Vazio = tabela padrão
do corpo da skill.

### `audit_log`
Protocolo e modelo `audit_log` de operações em massa (o da skill `fab-dados-seguros`, se instalada) (`actor`, `action` text, `model`, `record_id`, `filter`, `expected`,
`affected`, `summary`; leitura `role:admin`, criação com `owner_field: actor`, sem edição). Campos extras do
atendimento: `record_ids` json, `before` json (mapa id -> valores anteriores), `after` json, `note` text.

## Avisos (`fab.automations.json`)

Edite depois de `fabapp pull` e envie com `fabapp push`: o arquivo substitui o conjunto inteiro, então as
automações que o app já tem precisam continuar nele.

```json
{"automations": [
  {"name": "Chamado novo para a equipe",
   "trigger": {"type": "data", "model": "ticket", "event": "created"},
   "action": {"type": "notify", "channel": "push", "to": "role:atendente",
              "title": "Chamado {{number}}", "body": "{{subject}}", "link": "/chamados/{{id}}"}},
  {"name": "Chamado novo no sino",
   "trigger": {"type": "data", "model": "ticket", "event": "created"},
   "action": {"type": "notify", "channel": "inapp", "to": "role:atendente",
              "title": "Chamado {{number}}", "body": "{{subject}}", "link": "/chamados/{{id}}"}},
  {"name": "Resposta nova",
   "trigger": {"type": "data", "model": "ticket_message", "event": "created"},
   "action": {"type": "notify", "channel": "inapp", "to": "notify_user",
              "title": "Nova resposta no chamado", "body": "{{body}}", "link": "/meus-chamados"}},
  {"name": "Prazo de resolução chegou",
   "trigger": {"type": "relative", "model": "ticket", "field": "due_at", "offset_days": 0},
   "action": {"type": "notify", "channel": "inapp", "to": "assigned_to",
              "title": "Prazo do chamado {{number}}", "body": "Se ainda estiver aberto, ele passou do prazo.", "link": "/chamados/{{id}}"}},
  {"name": "Resumo diário",
   "trigger": {"type": "schedule", "every": "daily"},
   "action": {"type": "notify", "channel": "inapp", "to": "admin",
              "title": "Veja a fila de hoje", "body": "Abertos, atrasados e sem responsável.", "link": "/relatorios"}}
]}
```

Notas:
- `{{ticket}}` num `ref` vira o rótulo do registro, não o id; por isso o link da resposta aponta para a lista
  `/meus-chamados`. Quem recebe é `notify_user` (o cliente quando a equipe responde, o responsável quando o cliente
  responde); o responsável abre pela fila.
- Se o dono pediu e-mail, duplique a regra de chamado novo com `channel: "email"` e `to: "admin"`.
- Slack/Discord: mesma regra com `channel: "slack"` ou `"discord"` (o dono conecta no Studio).
- Limite: 30 avisos por pessoa por hora; por isso não há regra em `ticket` `updated`.
- Regra `relative` dispara uma vez por chamado, na hora cheia, mesmo que ele já esteja fechado. Daí o texto.

## Confirmação por e-mail ao visitante (opcional, exige o plano com funções de backend)

Visitante não tem login, então o app não chama `notify` por ele. Se o dono quiser e-mail de confirmação: função
`functions/ticket-confirm.ts` na raiz do workspace, declarada em `fab.functions.json` com `auth: "public"` (o
`fabapp deploy` não confere o manifesto: entrada faltando vira `"user"` em silêncio), que recebe só o `id`, carrega o chamado com `ctx.collection`,
confere que foi criado há menos de 10 minutos e ainda não foi confirmado, e chama
`ctx.notify('email', { to: ticket.requester_email, subject: 'Recebemos seu chamado ' + number, message, link })`
com `link` para a página inicial do app. Marque `confirmed_at` (datetime, acrescente ao `ticket`) para não reenviar. Nunca aceite endereço vindo do
corpo da requisição. Sem esse plano, a tela de confirmação com o protocolo copiável basta; diga isso ao dono.

## Dados para testar (o CLI não grava registros)

Você não semeia dados. Etapas padrão saem do botão "Criar etapas padrão" do próprio app (admin); categorias e SLA,
da tela de Ajustes; o dono também pode cadastrar ou importar planilha no CMS do Studio. Para conferir a construção,
crie pela pré-visualização o conjunto abaixo, marcado como teste, e apague depois (ou entregue a lista ao dono para
ele cadastrar, se quiser ver o app com exemplos).

- Etapas padrão (4), categorias escolhidas na conversa, tabela de SLA (4 linhas).
- 12 chamados: 2 urgentes (um aberto há 9 dias, para o relatório de urgentes parados aparecer), 4 alta, 4 média,
  2 baixa; 5 fechados com resolução e nota; 3 sem responsável; canais variados.
- Nomes e contatos brasileiros variados (Mariana Souza, (21) 98765-4321; Oficina Boa Vista Ltda). Assuntos reais do
  nicho ("Máquina não liga depois do reparo", "Troca de tamanho do pedido 1043").
- Diga ao dono que são exemplos removíveis, e apague o que você criou para testar.
