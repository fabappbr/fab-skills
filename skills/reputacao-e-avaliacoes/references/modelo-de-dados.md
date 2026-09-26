# Modelo de dados, acessos e avisos (reputação)

Tudo vai no `fab.schema.json` (depois de `fabapp pull`), enviado com `fabapp push`. Ids em inglês, rótulos em português. Papel da equipe: `atendente` (vê e responde avaliações); declare
`{"slug":"atendente","name":"Atendente","description":"Vê e responde avaliações","permissions":[]}` se ainda não
existe, e mantenha as permissões que ele já tiver. Dono e
admin são superusuários. Filtros de data usam campos declarados (`received_at`, `send_at`): a plataforma não filtra
por `created_at`.

## `feedback` (avaliação recebida ou colada; privada)
| campo | tipo | observação |
|---|---|---|
| author_name | text, required | labelField; como o cliente se identificou |
| rating | number | 1 a 5; vazio quando a fonte não tem estrelas (ex.: reclamação) |
| body | text | literal, nunca editado |
| source | enum, required | `app_form` (Pesquisa do app), `google`, `reclame_aqui`, `ifood` (iFood ou marketplace), `social` (Instagram ou Facebook), `whatsapp`, `other` |
| received_at | datetime, required | data da avaliação (a de origem, quando colada) |
| external_url | url | página da avaliação lá fora |
| author_contact | text | telefone ou e-mail, privado |
| customer | ref `customer` | opcional, se o app tem clientes |
| related_to | text | serviço, pedido ou profissional |
| request_token | text | liga ao `review_request` |
| status | enum | `new` (Nova), `replied` (Respondida), `handling` (Em tratativa), `resolved` (Resolvida) |
| sentiment | enum | `positive`, `mixed`, `negative`, `unfair` (Elogio, Misto, Crítica, Injusta ou falsa) |
| themes | list of text | |
| wants_contact | boolean | cliente pediu contato |
| consent_publish | boolean | cliente autorizou mostrar |
| already_answered | boolean | o dono já respondeu lá fora; não rascunhar |
| reply_draft | text | |
| reply_final | text | só depois de Aprovar |
| reply_posted_at | datetime | |
| reply_by | ref `app_user` | |

```json
{"read": {"any": ["role:atendente"]}, "create": "public",
 "update": {"any": ["role:atendente"]}, "delete": "role:admin"}
```
Sentimento inicial pela nota (1 e 2 crítica, 3 misto, 4 e 5 elogio); a IA ou o dono ajustam para misto ou
injusta. Sem convite (`request_token` vazio), a Triagem mostra o selo "Sem convite" e o Painel permite filtrar só
com convite: é a defesa contra envio falso pelo formulário público.

## `review_request` (pedido de avaliação; privado)
`customer_name` text required (labelField), `phone` phone, `email` email, `customer` ref `customer` (opcional),
`customer_user` ref `app_user` (quando o cliente tem login), `related_to` text, `related_id` text (id do
atendimento de origem, para não pedir duas vezes), `service_done_at` datetime, `send_at` datetime required,
`channel` enum `whatsapp_link, whatsapp_api, email, push, link`, `token` text required, `status` enum `scheduled,
sent, answered, skipped` (Agendado, Enviado, Respondido, Pulado), `sent_at` datetime.
Acesso: tudo `{"any":["role:atendente"]}`, delete `role:admin`.

## `business_profile` (público, um registro; o mesmo "Dados do negócio" de sites-por-segmento)
Não crie um segundo cadastro do negócio: use `business_profile` (`name` text labelField, `whatsapp` phone e os demais
campos que o app já tiver) e acrescente `google_review_url` url. O logo é o da marca do app (o dono sobe no Studio), não campo.
Acesso `{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}`.

## `voice_profile` (privado, um registro)
`signature` text (ex.: "Carla, da Padaria Estrela"), `tone` enum `warm, direct, formal`, `contact_route` text
(telefone ou WhatsApp para crítica), `authorized_offers` list of text, `words_to_avoid` list of text,
`sample_replies` text (respostas antigas do dono, para copiar o jeito), `corrections` text (acumula as edições do
dono), `theme_list` list of text (temas do negócio). Acesso: leitura e escrita `{"any":["role:atendente"]}`,
delete `role:admin`.

## `testimonial` (vitrine; público; esquema compartilhado com landing-que-converte e copy-que-vende)
`author_display` text required (labelField, "Mariana S."), `author_detail` text (bairro, profissão ou cidade), `photo`
image, `rating` number, `body` text (a frase literal), `result` text (o número ou fato específico que o cliente cita),
`objection` enum `trust, price, fit, timing, effort` (a dúvida que o depoimento responde; usado pela landing),
`received_at` datetime, `source_label` text, `feedback_id` text (o id da origem como TEXTO, não `ref`, para a leitura
pública não expor nada da `feedback`), `authorized` boolean (consentimento do cliente para publicar), `active` boolean
(o dono mostra ou esconde). A vitrine lê só `authorized: true` e `active: true`.
Acesso `{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}`.

## `rating_summary` (público; uma linha por fonte)
`source` enum igual ao da `feedback` (labelField), `average` number, `count` number, `period_label` text
("01/06/2026 a 26/09/2026"), `origin` enum `app_computed, owner_input`, `measured_at` datetime. Mesmo acesso da
vitrine. Só existe se o dono escolheu mostrar média.

## `review_reply` (resposta a avaliação `review` de cliente logado)
`review_id` text required, `body` text required (labelField), `notify_user` ref `app_user`. Acesso: leitura
`{"any":["role:atendente",{"owner_field":"notify_user"}]}`, escrita `{"any":["role:atendente"]}`.

## `review` (canônico, só com login de cliente e itens)
Campos garantidos: `target` text (id do item), `author` ref `app_user`, `rating` number 1 a 5, `body`,
`helpful_count`. A peça `<Rating targetId={item.id}/>` desenha média, distribuição, formulário e lista; não
construa estrelas nem média à mão. Em página pública de marketing use `<Rating canReview={false}/>`. O Painel lê
`review` como a fonte "Avaliações no app" e não mistura a média com a `feedback`.

## `audit_log`
Modelo `audit_log` do protocolo de operação segura (o mesmo da skill `dados-seguros`, se instalada) (`actor`, `action` text, `model`, `record_id`, `filter`, `expected`,
`affected`, `summary`). Campos extras das avaliações: `record_ids` json, `before` json, `after` json. Registra: aprovar
resposta, publicar e tirar depoimento, apagar avaliação colada, importação.

## Avisos (`fab.automations.json`)

O arquivo substitui o conjunto inteiro: rode `fabapp pull`, acrescente estas regras às que já existem e envie tudo com `fabapp push`.

```json
{"automations": [
  {"name": "Hora de pedir avaliação",
   "trigger": {"type": "relative", "model": "review_request", "field": "send_at", "offset_days": 0},
   "action": {"type": "notify", "channel": "push", "to": "role:atendente",
              "title": "Pedir avaliação: {{customer_name}}", "body": "{{related_to}}", "link": "/avaliacoes/pedidos"}},
  {"name": "Convite ao cliente com login",
   "trigger": {"type": "relative", "model": "review_request", "field": "send_at", "offset_days": 0},
   "action": {"type": "notify", "channel": "push", "to": "customer_user",
              "title": "Como foi {{related_to}}?", "body": "Sua opinião leva 30 segundos.", "link": "/avaliar/{{token}}"}},
  {"name": "Avaliação nova",
   "trigger": {"type": "data", "model": "feedback", "event": "created"},
   "action": {"type": "notify", "channel": "push", "to": "admin",
              "title": "Nova avaliação: {{rating}} estrelas", "body": "{{body}}", "link": "/avaliacoes/triagem"}},
  {"name": "Resposta do dono ao cliente",
   "trigger": {"type": "data", "model": "review_reply", "event": "created"},
   "action": {"type": "notify", "channel": "inapp", "to": "notify_user",
              "title": "Respondemos sua avaliação", "body": "{{body}}", "link": "/"}},
  {"name": "Respostas pendentes",
   "trigger": {"type": "schedule", "every": "daily"},
   "action": {"type": "notify", "channel": "inapp", "to": "admin",
              "title": "Avaliações esperando resposta", "body": "Críticas primeiro.", "link": "/avaliacoes/triagem"}}
]}
```
- A regra ao cliente só entrega quando `customer_user` está preenchido; sem login, quem envia é a equipe.
- Avaliação colada pela equipe também dispara "Avaliação nova" (a automação não tem condição); o texto serve.
- Sem condição por nota: o título leva a nota para o dono ver de cara.
- Canal e-mail ao cliente logado: duplique a regra do convite com `channel: "email"` se o dono escolheu e-mail.

## Dados de exemplo (marcados como exemplo)

O CLI não grava registros. Este conjunto fica numa constante e o botão "Carregar exemplos" (só admin, com prévia e contagem) grava pelo próprio app; o dono também pode cadastrar ou importar pelo CMS do Studio. Nunca diga ao dono que criou avaliações.

8 `feedback` de `app_form` e 4 de `google` coladas, notas variadas (duas críticas, um misto, uma injusta), com
temas do nicho; 5 `review_request` em estados diferentes. Nenhum `testimonial` e nenhum `rating_summary` de exemplo:
a vitrine pública nunca mostra dado fictício.
