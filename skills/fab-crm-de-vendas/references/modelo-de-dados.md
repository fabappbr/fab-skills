# Modelo de dados do CRM

Ids e campos em inglês, rótulos em português. Crie só os modelos das telas que o plano incluiu, no `fab.schema.json` (depois de `fabapp pull`), enviado com `fabapp push`. `ref` mora sempre no filho; para listar filhos, consulte (`collection('activity').list({filter:{deal:id}})`). Usuário do app é `ref` com `to:"app_user"` (nunca `collection('app_user')`).

## Relações

- `company` 1:N `contact` (contato pode não ter empresa: cliente PF).
- `deal` N:1 `contact` (principal, obrigatório), N:1 `company` (opcional), N:1 `pipeline_stage`, N:1 responsável (`seller`).
- `deal_contact`: outras pessoas do negócio e o papel de cada uma (decisor, influenciador, usuário, campeão, financeiro).
- `activity` e `task` ligam a `deal` e/ou `contact` (pelo menos um).
- `stage_history` e `audit_log`: só acréscimo.
- Módulos: `close_plan_step` (N:1 deal), `proposal` (N:1 deal) e `proposal_item` (N:1 proposal, N:1 product), `inquiry` (lead do formulário), `routing_rule`, `segment`, `prospect`.
- Configuração: `pipeline_stage`, `crm_option` (origens, motivos de perda, segmentos), `custom_field_def`, `crm_settings` (registro único).

## Campos por modelo

Obrigatório = `required: true` no schema e no zod. Campos marcados (app) são gravados pelo código, nunca por campo de formulário.

**company** (labelField `name`): `name` text obrig · `trade_name` text · `cnpj` text (só letras maiúsculas e dígitos) · `segment` ref crm_option · `size` enum [mei, micro, pequena, media, grande] · `city` text · `state` text (UF, 2 letras) · `website` url · `seller` ref app_user (responsável) obrig · `notes` text · `custom` json · `last_activity_at` datetime (app) · `is_sample` boolean.

**contact** (labelField `name`): `name` text obrig · `person_type` enum [pf, pj] · `company` ref company · `role` text (cargo) · `email` email · `email_norm` text (app) · `phone` phone · `phone_norm` text (app, +55DDDNÚMERO) · `whatsapp` boolean · `cpf` text (só dígitos) · `city` text · `state` text · `lifecycle` enum [lead, oportunidade, cliente, promotor, outro] (app) · `lead_status` enum [novo, tentando, conectado, reuniao_marcada, agora_nao, desqualificado] · `disqualify_reason` text · `recontact_on` date · `attempts` number (app) · `source` ref crm_option obrig · `source_detail` text · `seller` ref app_user (responsável) obrig · `marketing_opt_in` boolean · `marketing_opt_in_at` datetime · `marketing_opt_in_channel` enum (opções de fab-padroes-brasil) · `marketing_opted_out_at` datetime · `tags` list · `custom` json · `first_seen` date · `last_activity_at` datetime (app) · `is_sample` boolean.
Validação: nome e pelo menos um entre telefone e e-mail.

**deal** (labelField `title`): `title` text obrig · `code` autonumber `NEG-{0000}` · `contact` ref contact obrig · `company` ref company · `seller` ref app_user (responsável) obrig · `stage` ref pipeline_stage obrig · `status` enum [aberto, ganho, perdido] (app, deriva de `stage.kind`) · `amount` money (estimado; pode ser 0, mas aparece na Saúde dos dados) · `final_amount` money (obrig ao ganhar) · `expected_close` date obrig · `closed_at` date (app) · `lost_reason` ref crm_option (obrig ao perder) · `lost_note` text · `competitor` text · `next_step` text obrig se aberto · `next_step_due` date obrig se aberto · `next_step_owner` enum [nos, cliente] · `stage_entered_at` datetime (app) · `last_activity_at` datetime (app) · `proposal_sent_at` datetime · `source` ref crm_option · `deal_type` enum [novo, renovacao, expansao] · `parent_deal` ref deal (renovação ou expansão ligada ao negócio original) · `contract_end` date (recorrentes) · `big_deal` boolean (liga o placar de negócio grande) · `qualification` json · `criteria` json · `business_case` json · `handoff` json · `custom` json · `is_sample` boolean.

Formatos dos json do negócio:
- `qualification`: `{situacao:{text,level}, dor:{…}, impacto:{…}, prazo:{…}, decisao:{…}}`, `level` 0 (não sabe), 1 (suspeita), 2 (confirmado com evidência). No negócio grande, as 7 dimensões do placar de `pipeline-e-etapas.md`.
- `criteria`: `{"<stageId>": {"<índice do critério>": {done, evidence_activity, note, at}}}`.
- `business_case`: `{situacao_atual, custo_do_problema, resultado_desejado, solucao, investimento_e_retorno, risco_de_esperar, por_que_nos}`, cada item `{text, evidence_activity|null}`.
- `handoff`: `{prometido, criterios_de_sucesso, contatos, primeiro_resultado_ate}`.

**pipeline_stage** (labelField `name`): `name` text obrig · `pipeline` text (padrão "Vendas") · `order` number obrig · `probability` number 0 a 100 · `kind` enum [aberta, ganha, perdida] obrig · `goal` text · `actions` text · `exit_criteria` list · `requires_proposal` boolean · `max_days` number · `forecast` enum [funil, melhor_cenario, compromisso, ganho, perdido].

**stage_history**: `deal` ref obrig · `from_stage` ref pipeline_stage · `to_stage` ref pipeline_stage obrig · `changed_by` ref app_user · `changed_at` datetime · `days_in_previous` number · `amount_at` money · `reason` text (voltou etapa, pulou etapa, avançou sem critério).

**deal_contact**: `deal` ref obrig · `contact` ref obrig · `role` enum [decisor, influenciador, usuario, campeao, financeiro, outro].

**activity** (labelField `summary`): `type` enum [ligacao, whatsapp, email, reuniao, visita, nota, proposta] obrig · `occurred_at` datetime obrig · `summary` text obrig (3 a 5 linhas) · `deal` ref deal · `contact` ref contact · `company` ref company · `outcome` enum [agendou, interessado, agora_nao, pessoa_errada, indicou_outro, sem_interesse, nao_atendeu] (ligações) · `objection` text (palavras do cliente) · `next_step_set` boolean · `origin` enum [manual, ia, importacao, formulario, whatsapp] · `source_hash` text (app, evita registrar o mesmo texto duas vezes) · `file` file · `seller` ref app_user (responsável) obrig · `is_sample` boolean.

**task** (labelField `title`): `title` text obrig · `type` enum [ligar, whatsapp, email, reuniao, visita, outro] · `due_at` datetime obrig · `done` boolean · `done_at` datetime · `priority` enum [baixa, media, alta] · `assigned_to` ref app_user obrig · `deal` ref deal · `contact` ref contact.

**inquiry** (lead do formulário público; labelField `name`): `name` text obrig · `phone` phone · `email` email · `company_name` text · `message` text obrig · `interest` text · `city` text · `channel` text · `marketing_opt_in` boolean · `status` enum [novo, respondido, convertido, descartado, suspeito] · `bucket` enum [quente, qualificado, incerto, fora] · `assigned_to` ref app_user · `contact` ref contact · `responded_at` datetime · `draft` text · `route_note` text.

**routing_rule** (labelField `name`): `name` text · `order` number · `field` enum [cidade, uf, segmento, origem, interesse, valor] · `operator` enum [igual, contem, maior_ou_igual, menor] · `value` text · `assignee` ref app_user obrig · `active` boolean.

**audit_log**: protocolo e modelo `audit_log` de fab-dados-seguros (`actor`, `action` text, `model`, `record_id`, `filter`, `expected`, `affected`, `summary`). Campos extras do CRM: `before` json · `after` json · `reason` text. Valores de `action` usados aqui: `move_stage, change_value, change_date, change_owner, delete, merge, import, bulk_update, transfer, routing_accepted, routing_changed, export, anonymize`.

**crm_option** (labelField `label`): `kind` enum [origem, motivo_perda, segmento] obrig · `label` text obrig · `order` number · `active` boolean.

**custom_field_def** (labelField `label`): `entity` enum [contact, company, deal] obrig · `key` text obrig (minúsculas, sem espaço) · `label` text obrig · `type` enum [texto, numero, dinheiro, data, sim_nao, lista] · `options` list · `required` boolean · `order` number · `active` boolean.

**crm_settings** (registro único, `key` = "main"): `key` text · `response_minutes` number (60) · `quiet_days` number (14) · `stale_next_step_days` number (14) · `risk_days` number (60) · `icp` json · `lead_criteria` json (atende, não atende, sinais de quente, indicar para) · `voice_samples` list (até 3 mensagens que o dono aprovou) · `big_deal_min` money.

**close_plan_step**: `deal` ref obrig · `title` text obrig · `side` enum [nos, cliente, outro] · `responsible` text · `due` date · `status` enum [a_fazer, em_andamento, feito, bloqueado] · `order` number · `typical_days` number · `note` text.

**segment**: `name` text · `entity` enum [contact, company] · `groups` json (o campo `json` só aceita objeto, nunca lista: grave `{"groups":[...]}`; dentro do grupo E, entre grupos OU) · `created_by` ref app_user.

**prospect** (labelField `company_name`): `company_name` text obrig · `cnpj` text · `city` text · `segment` text · `size` text · `why_now` text · `signal_date` date · `signal_source` text · `contact_name` text · `contact_role` text · `contact_route` text · `contact_confidence` enum [verificado, deduzido, desconhecido] · `fit` number · `signal` number · `reach` number · `score` number (app) · `warm_path` text · `status` enum [novo, no_crm, cortado] · `list_tag` text · `seller` ref app_user (responsável).

**product** (labelField `name`): `name` text obrig · `price` money obrig · `sku` text · `recurrence` enum [unico, mensal, anual]. **proposal** (labelField `code`): `code` autonumber `PROP-{0000}` · `deal` ref obrig · `seller` ref app_user (responsável) obrig (cópia do dono do negócio) · `valid_until` date · `status` enum [rascunho, enviada, aceita, recusada, vencida] · `notes` text. **proposal_item**: `proposal` ref obrig · `product` ref product · `name` text obrig · `qty` number obrig · `unit_price` money obrig (pode diferir do produto) · `discount_pct` number. Total e desconto somado são calculados na tela, nunca gravados à mão.

## Acesso (`access`)

Dono (owner/admin) é superusuário e vê tudo. Sem equipe, não crie `gestor` nem `vendedor`; mantenha as regras abaixo (elas já servem para um usuário só).

```json
{
 "carteira (company, contact, deal, prospect)": {"read":{"any":["role:gestor",{"owner_field":"seller"}]},"create":{"any":["role:gestor",{"owner_field":"seller"}]},"update":{"any":["role:gestor",{"owner_field":"seller"}]},"delete":"role:admin"},
 "task": {"read":{"any":["role:gestor",{"owner_field":"assigned_to"},{"owner_via":"deal"}]},"create":"authenticated","update":{"any":["role:gestor",{"owner_field":"assigned_to"}]},"delete":"role:admin"},
 "activity": {"read":{"any":["role:gestor",{"owner_field":"seller"},{"owner_via":"deal"},{"owner_via":"contact"}]},"create":{"any":["role:gestor",{"owner_field":"seller"}]},"update":"role:admin","delete":"role:admin"},
 "stage_history, deal_contact, close_plan_step": {"read":{"any":["role:gestor",{"owner_via":"deal"}]},"create":{"any":["role:gestor",{"owner_via":"deal"}]},"update":{"any":["role:gestor",{"owner_via":"deal"}]},"delete":"role:admin"},
 "proposal": "igual à carteira", "proposal_item": {"read":{"owner_via":"proposal"},"create":{"owner_via":"proposal"},"update":{"owner_via":"proposal"},"delete":{"owner_via":"proposal"}},
 "inquiry": {"read":{"any":["role:gestor",{"owner_field":"assigned_to"}]},"create":"public","update":{"any":["role:gestor",{"owner_field":"assigned_to"}]},"delete":"role:admin"},
 "audit_log": "o de fab-dados-seguros; leitura pode abrir para role:gestor",
 "configuração (pipeline_stage, crm_option, custom_field_def, crm_settings, routing_rule, product)": {"read":"authenticated","create":"role:admin","update":"role:admin","delete":"role:admin"},
 "segment": {"read":"role:gestor","create":"role:gestor","update":"role:gestor","delete":"role:gestor"}
}
```
`stage_history` em `update` fica sem uso na tela (só acréscimo). Em `stage_history` com vendedor, grave sempre `changed_by`. `ref` para registro (deal, contact) nunca vai em `owner_field`: use `owner_via`. Caminho com ponto não funciona.

Papéis (só com equipe): `{"slug":"gestor","name":"Gestor","description":"Vê a equipe, roteia leads, transfere carteira e vê relatórios","permissions":["users.read"]}` e `{"slug":"vendedor","name":"Vendedor","description":"Vê e trabalha só a própria carteira","permissions":[]}`. Vendedor não exclui nem faz lote fora da própria carteira; a tela esconde os botões e a regra de acesso garante. Transferir carteira é do gestor ou do dono (vendedor não consegue gravar outro id no `seller`). O campo se chama `seller`, não `owner`: em automação, `owner` quer dizer quem criou o registro. Lista de vendedores para seletores: `admin.listUsers` (precisa de `users.read`).

## Campos derivados (gravados só pelo código)

`deal.status` e `closed_at` (da etapa), `stage_entered_at`, `last_activity_at` (em deal, contact e company, atualizado ao criar atividade), `contact.lifecycle`, `attempts`, `email_norm`, `phone_norm`, `prospect.score`, totais de proposta. Probabilidade e categoria de previsão vêm da etapa e não são copiadas para o negócio.

Eventos que mudam `lifecycle` (só para frente; nunca volta): primeiro negócio aberto do contato vira Oportunidade; primeiro negócio ganho vira Cliente; Promotor é marcado pelo dono (indicou alguém). Desqualificar mexe em `lead_status`, não no ciclo de vida. Ao criar negócio a partir de um lead, `lead_status` do contato passa a "reuniao_marcada" ou "conectado" conforme o botão usado.

## Normalização e chaves naturais

- **E-mail**: `trim().toLowerCase()` em `email_norm`. Lista de lixo recusada na importação: contém "teste", "noreply", "naoresponda".
- **Telefone**: só dígitos; tira 0 de operadora; prefixa 55. Celular = DDD válido + 9 dígitos começando em 9. Fixo = DDD + 8 dígitos começando em 2 a 5. DDDs válidos: 11 a 19, 21, 22, 24, 27, 28, 31 a 35, 37, 38, 41 a 49, 51, 53 a 55, 61 a 69, 71, 73 a 75, 77, 79, 81 a 89, 91 a 99. Guarde `+5511912345678` em `phone_norm`; mostre `(11) 91234-5678`. Link: `https://wa.me/5511912345678?text=` + `encodeURIComponent(texto)`.
- **CPF**: 11 dígitos, dígitos verificadores módulo 11, recusa sequência repetida. Opcional, validado se preenchido. Mostre `123.456.789-09`.
- **CNPJ**: guarde 14 caracteres em maiúsculas sem máscara. Desde julho de 2026 a Receita emite CNPJ alfanumérico: as 12 primeiras posições aceitam letras e dígitos, as 2 últimas são dígitos. Dígito verificador: cada caractere vale (código ASCII menos 48), pesos 5,4,3,2,9,8,7,6,5,4,3,2 e depois 6,5,4,3,2,9,8,7,6,5,4,3,2, resto 0 ou 1 vira 0, senão 11 menos o resto. Mostre `12.ABC.345/01DE-35`.
- **Duplicidade antes de criar**: `count({ email_norm })`, depois `phone_norm`, depois documento. Achou: abre o existente com aviso "Já existe", nunca cria em silêncio. Não existe restrição de unicidade no servidor; esta checagem é a única barreira. A contagem respeita o acesso: para o vendedor ela só enxerga a própria carteira, então duplicado entre carteiras aparece para o dono ou gestor na Saúde dos dados. Se o dono quiser barrar na hora, o agente cria a função `check_duplicate` (`functions/check_duplicate.ts` com entrada em `fab.functions.json`; exige o mesmo plano pago que libera o CLI; `ctx.collection` vê a base toda) que responde só "já existe, com Fulano".

## Campos e objetos personalizados

O dono não pode mudar o schema de dentro do app (schema é o `fab.schema.json`, escrito pelo agente). Por isso:
- **Campo extra** = definição em `custom_field_def` + valor no json `custom` do registro. O formulário monta os campos na ordem, com o tipo (texto, número, dinheiro, data, sim ou não, lista de opções), e o zod é gerado das definições (obrigatório vira `min(1)`). A ficha mostra os extras numa seção "Mais informações". Limite: não filtra no servidor e não entra em regra de roteamento; filtro por campo extra é feito na tela sobre a lista já carregada. Quando o dono precisa filtrar, somar ou rotear por ele, o agente promove o campo a coluna real (edita o `fab.schema.json` e roda `fabapp push`) e o app copia os valores com prévia.
- **Objeto novo** (visita técnica, obra, contrato, equipamento) nunca é json: é modelo próprio criado numa mudança depois, no `fab.schema.json`, com `labelField` legível, campos obrigatórios, `ref` no filho e `owner_via`. Apagar um objeto apaga todos os registros dele: o agente avisa o dono com a contagem e pede confirmação antes.

## Regras brasileiras e LGPD

- Consentimento de marketing separado do contato comercial, com data e canal. Segmento de marketing e exportação para campanha excluem quem tem `marketing_opted_out_at` e quem não tem `marketing_opt_in` (nomes de fab-padroes-brasil) (a tela mostra quantos saíram).
- Toda mensagem de marketing por WhatsApp tem uma linha de saída ("Se não quiser mais receber, responda SAIR"); resposta SAIR grava `marketing_opted_out_at`.
- Na ficha do contato, só para o dono: "Exportar dados desta pessoa" (CSV com contato, atividades e negócios) e "Anonimizar" (troca nome por "Anonimizado", apaga e-mail, telefone, CPF e observações, mantém valores dos negócios para relatório; prévia, confirmação e `audit_log`).
- Nota fiscal não é emitida pelo app. O negócio ganho pode guardar número da nota em campo extra ou anexo.

## Dados de exemplo (todos `is_sample: true`)

O CLI não grava registros (ver `references/fabapp-cli.md`, "Registros: você não semeia dados"). Este conjunto vira uma constante em `src/lib/crm/sample-data.ts` e o botão "Carregar exemplos" (só dono, com prévia e contagem) grava pelo próprio app com `bulkCreate` em blocos de 200. O dono também pode cadastrar ou importar pelo CMS do Studio. Nunca diga ao dono que criou os dados.

Etapas do funil escolhido; origens (Instagram, Indicação, Google, Site, WhatsApp, Feira); motivos de perda (Preço, Escolheu concorrente, Sem orçamento agora, Não respondeu mais, Não era o que precisava); 8 empresas e 30 contatos com nomes brasileiros variados e DDDs de 6 estados; 15 negócios espalhados nas etapas, 5 parados há mais de 14 dias, 2 perdidos com motivo, 2 ganhos; 40 atividades nos últimos 60 dias; 6 tarefas (2 vencidas); 4 leads do formulário (1 quente). Valores coerentes com o ramo do dono. O botão "Remover exemplos" (dono) faz `deleteMany({is_sample:true})` por modelo, com prévia e contagem.
