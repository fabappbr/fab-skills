# Modelo de dados do financeiro

Ids e campos em inglês; rótulos em português. `F` = `{"any":["role:admin","role:finance"]}`. Escreva no `fab.schema.json` (depois de `fabapp pull`) e envie com `fabapp push`. Corte o modelo que a conversa com o dono descartou (sem orçamento: tire `quote` e `quote_item`; sem mensalidade: tire `contract`; sem nota: tire `fiscal_note`).

## customer (cliente)
`labelField: name`. Campos: `name` text obrigatório; `person_type` enum `["pf","pj"]` obrigatório; `document` text (CPF 11 dígitos ou CNPJ 14 caracteres, sem máscara, CNPJ em maiúsculas); `phone` phone (E.164, +55...); `whatsapp` boolean; `email` email; `payment_terms_days` number (prazo padrão, ex. 30); `notes` text; `payer` text (id do usuário do app do cliente, só com área do cliente); `is_sample` boolean.
Obrigatório no formulário (zod): nome e pelo menos telefone ou e-mail. Documento opcional, validado quando preenchido, único (conferir com `count`).
Acesso: `read` e `update` = F mais `role:seller` quando há vendedores; `create` idem; `delete` = `role:admin`. Nunca público.

## product (produto ou serviço)
Modelo canônico: `name`, `price` money, `type` enum `["service","product","recurring"]`, `provider_price_id` text (deixe opcional, a plataforma usa). Extras opcionais: `sku` text, `unit` text (un, h, m², mês), `interval` enum `["month","year"]` para recorrente, `active` boolean, `description` text.
Acesso: `read` = `authenticated`; escrita = F.

## quote (orçamento)
`labelField: code`. `code` autonumber `format: "ORC-{0000}"`, `start: 1`; `customer` ref customer obrigatório; `title` text; `issued_on` date; `valid_until` date obrigatório; `discount_pct` number (desconto geral, 0 a 100); `total` money (cache gravado pelo código a cada salvar; nunca no formulário); `status` enum `["draft","sent","accepted","rejected"]` (escrito pelos botões); `accepted_on` date; `reject_reason` text; `installments` number (1 a 12); `first_due_date` date; `notes` text; `deal` ref opcional se o app tiver CRM.
"Expirado" é calculado: `status` em draft ou sent e `valid_until` < hoje. Aceitar orçamento expirado pede confirmação e nova validade.
Acesso: F mais `role:seller` (vendedor vê os que criou: `{"any":["role:admin","role:finance","owner"]}` na leitura quando há vendedores).

## quote_item (item do orçamento)
`quote` ref quote obrigatório; `product` ref product opcional (item avulso sem ref); `description` text obrigatório (cópia do nome no momento); `quantity` number obrigatório (> 0); `unit_price` money obrigatório (cópia do preço, pode mudar só aqui); `discount_pct` number (0 a 100). Total da linha é calculado.
Acesso igual ao do orçamento.

## invoice (fatura ou parcela)
`labelField: code`. `code` autonumber `format: "FAT-{0000}"`; `customer` ref customer obrigatório; `quote` ref quote; `contract` ref contract; `competence` text (`aaaa-mm`, para mensalidade); `description` text; `installment` text ("2/3"); `issued_on` date; `due_date` date obrigatório; `amount` money obrigatório (valor original, maior que zero); `price` money (saldo a cobrar agora, mantido pelo código; é o que o link de pagamento cobra); `status` enum de texto simples `["open","paid","canceled"]`; `paid_at` datetime (a plataforma carimba); `cancel_reason` text; `payer` text (id do usuário do cliente, cópia de `customer.payer`); `late_fee_applies` boolean.
Rótulos no código: open = "Em aberto", paid = "Paga", canceled = "Cancelada"; "Vencida" só na tela.
Acesso: `read` = `{"any":["role:admin","role:finance",{"owner_field":"payer"}]}`; `create`, `update` = F; `delete` = `role:admin` (e a tela usa cancelar, não apagar).

## payment (pagamento recebido)
`invoice` ref invoice obrigatório; `customer` ref customer obrigatório; `amount` money obrigatório (negativo só em estorno); `paid_on` date obrigatório; `method` enum `["pix","cash","transfer","card_machine","bank_slip","link","other"]` obrigatório; `receipt` file (comprovante); `no_receipt_reason` text; `reversal_of` ref payment; `reversal_reason` text; `notes` text.
Só acréscimo: `create` = F; `update` e `delete` = `role:admin` e a tela não oferece. Estorno = novo `payment` com valor negativo, `reversal_of` e motivo.

## payment_promise (promessa de pagamento)
`invoice` ref invoice obrigatório; `customer` ref customer obrigatório; `promised_date` date obrigatório; `amount` money obrigatório; `channel` enum `["whatsapp","phone","email","in_person"]`; `notes` text. Cumprida ou quebrada é calculado. Acesso: `create` = F; `update`/`delete` = `role:admin`.

## collection_message (mensagem de cobrança)
`customer` ref customer obrigatório; `invoices_codes` text (códigos juntados, "FAT-0012, FAT-0015"); `total` money; `tone` enum `["gentle","neutral","firm"]`; `channel` enum `["whatsapp","whatsapp_link","email","copy"]`; `subject` text; `body` text; `sent_at` datetime; `batch` text (id do lote aprovado); `delivery_note` text (falha e caminho usado).
Gravada só quando enviada ou confirmada ("Enviou?" = sim). Rascunho vive na tela, não no banco. Acesso: `create` = F; `update`/`delete` = `role:admin`.

## contract (mensalidade)
`labelField: title`. `customer` ref customer obrigatório; `title` text; `monthly_amount` money obrigatório; `due_day` number (1 a 28); `start_date` date obrigatório; `end_date` date; `status` enum `["active","paused","canceled"]` (botões com motivo); `cancel_reason` text. Acesso: F.

## fiscal_note (nota fiscal registrada)
`invoice` ref invoice; `quote` ref quote; `customer` ref customer; `kind` enum `["nfse","nfe","nfce"]` obrigatório; `number` text obrigatório; `series` text; `access_key` text (só dígitos); `verification_code` text (NFS-e municipal); `issued_on` date obrigatório; `amount` money; `status` enum `["issued","canceled"]`; `pdf` file; `xml` file. Acesso: F.

## payment_info (dados para receber, um registro, público)
`labelField: business_name`. `business_name` text; `pix_key` text; `pix_key_type` enum `["cpf","cnpj","phone","email","random"]`; `pix_receiver_name` text (até 25 letras, sem acento); `pix_city` text (até 15 letras, sem acento); `whatsapp_business` phone.
Acesso: `read` = `public` (a página `/pagamento` mostra a chave a quem recebeu a cobrança); escrita = `role:admin`. Só dado que o dono já divulga para receber.

## finance_settings (configurações do financeiro, um registro)
`default_terms_days` number; `charge_late_fees` boolean; `late_fee_pct` number (padrão 2); `interest_month_pct` number (padrão 1); `voice_sample` text (1 a 3 mensagens que o dono já escreveu); `firm_deadline_days` number (padrão 5).
Acesso: `read` = F; escrita = `role:admin`.

## Papéis
`finance` (Financeiro: faturas, baixas, mensagens, notas), `seller` (Vendedor: clientes, catálogo para leitura, orçamentos próprios; não dá baixa nem cancela fatura). `owner` e `admin` já existem. Com área do cliente, o cliente é usuário comum (`member`) ligado por `payer`: o admin cria a conta com `admin.createUser({email, name})`, grava o id em `customer.payer` e nas faturas; o cliente entra com código por e-mail.
