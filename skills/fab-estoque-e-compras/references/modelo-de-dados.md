# Modelo de dados do estoque e compras

Ids e campos em inglês; rótulos em português. `S` = `{"any":["role:admin","role:stock"]}`. Sem equipe, `S` vale só `role:admin`. Nada aqui é público.

## supplier (fornecedor)
`labelField: name`. `name` text obrigatório; `contact_name` text; `phone` phone; `whatsapp` boolean; `email` email; `document` text (CNPJ sem máscara, maiúsculas, validado quando preenchido); `lead_time_days` number (prazo de entrega em dias; vazio = perguntar uma vez e gravar); `min_order_value` money (pedido mínimo em R$); `min_order_units` number; `payment_terms` text ("28 dias", "à vista"); `bank_info_confirmed_on` date; `notes` text.
Acesso: leitura e escrita S; `delete` = `role:admin`.

## product (item de estoque)
Use o modelo canônico `product` (`name`, `price` money, `type`, `provider_price_id` opcional) com extras opcionais: `sku` text (código, único; conferir com `count` pela forma minúscula sem espaços); `group` text (produto de origem da variação); `category` text; `unit` text (un, cx, kg, m); `unit_cost` money (último custo); `cost_as_of` date (data do último custo); `supplier` ref supplier; `lead_time_days` number (sobrepõe o do fornecedor); `pack_size` number (múltiplo de compra, ex. caixa com 12); `on_hand` number (cache do saldo, nunca no formulário); `counted_at` datetime (última contagem); `tracks_stock` boolean (falso = item fora do cálculo, ex. serviço); `legacy_min` number (estoque mínimo antigo que o dono usava, só referência); `active` boolean; `is_sample` boolean.
Se o app já tem outro modelo de item de venda, use esse e acrescente os mesmos campos opcionais.
Acesso: `read` = `authenticated`; escrita = S.

## stock_movement (movimentação, só acréscimo)
`product` ref product obrigatório; `type` enum `["in","out","return","adjust","loss"]` obrigatório; `quantity` number obrigatório (sempre positivo em in, out, return e loss; em adjust pode ser negativo); `sold_on` date (em `return`: data da venda devolvida); `date` datetime obrigatório; `reason` text (obrigatório em adjust e loss, zod); `unit_cost` money (em entradas); `is_bulk` boolean (venda de atacado pontual, fora da velocidade); `purchase_order` ref purchase_order; `receipt` ref receipt; `stock_count` ref stock_count; `source` enum `["manual","sale","import","receipt","count"]`; `reference` text (número da venda ou da nota).
Acesso: `read` = S; `create` = S; `update` e `delete` = `role:admin` e a tela não oferece.

## purchase_order (pedido de compra)
`labelField: code`. `code` autonumber `format: "PC-{0000}"`; `supplier` ref supplier obrigatório; `status` enum `["draft","sent","partial","received","canceled"]` (escrito pelos botões e pelo recebimento, nunca no formulário); `ordered_on` date; `expected_date` date (pedido + prazo); `freight` money; `total` money (cache calculado das linhas); `message` text (rascunho aprovado); `sent_at` datetime; `sent_via` enum `["whatsapp","whatsapp_link","email","phone","copy"]`; `cancel_reason` text; `notes` text.
Acesso: S; `delete` = `role:admin`.

## purchase_order_item (linha do pedido)
`purchase_order` ref obrigatório; `product` ref obrigatório; `quantity` number obrigatório; `unit_price` money (último preço conhecido; vazio = fornecedor informa); `price_as_of` date; `quantity_received` number (somado pelo recebimento); `substitute_sku` text; `substitution_status` enum `["none","pending","accepted","rejected"]`; `basis` text (explicação gravada: velocidades, cobertura, meta, arredondamento).
Acesso: S.

## receipt (recebimento)
`labelField: code`. `code` autonumber `format: "REC-{0000}"`; `purchase_order` ref obrigatório; `received_on` date obrigatório; `supplier_invoice_number` text (número da nota do fornecedor); `supplier_invoice_key` text (chave de 44 dígitos da NF-e, só dígitos); `invoice_file` file (PDF ou XML, privado); `billed_total` money (total cobrado na nota); `notes` text.
Acesso: S.

## receipt_item (linha recebida)
`receipt` ref obrigatório; `po_item` ref purchase_order_item obrigatório; `product` ref obrigatório; `quantity` number obrigatório; `billed_unit_price` money.
Acesso: S.

## payable (conta a pagar)
`labelField: code`. `code` autonumber `format: "CP-{0000}"`; `supplier` ref obrigatório; `purchase_order` ref; `receipt` ref; `amount` money obrigatório; `due_date` date obrigatório; `status` enum `["open","paid","canceled"]` (por evento: "Marcar paga" com comprovante, cancelar com motivo); `paid_on` date; `proof` file; `match_status` enum `["ok","accepted_difference"]` (gravado quando o dono aceita a conferência); `difference_note` text (obrigatório em diferença aceita); `supplier_invoice_number` text; `expense_category` text (categoria da despesa para o contador; fornecedor novo sem categoria: a tela pergunta, nunca chuta).
Vencida é calculada (`status open` e `due_date` < hoje). Acesso: `read` e `create` = S; `update` = `role:admin` (quem aceita diferença e marca paga é o dono); `delete` = `role:admin`.

## stock_count (inventário)
`labelField: code`. `code` autonumber `format: "INV-{0000}"`; `started_at` datetime; `closed_at` datetime; `status` enum `["open","closed"]`; `scope` text (categoria ou "tudo"); `notes` text. Acesso: S.

## stock_count_line (linha contada)
`stock_count` ref obrigatório; `product` ref obrigatório; `expected` number (saldo no início, copiado); `counted` number; `note` text. Diferença é calculada. Acesso: S.

## season (temporada)
`labelField: name`. `name` text obrigatório; `category` text ou `product` ref (um dos dois); `starts_on` date obrigatório; `ends_on` date; `factor` number (multiplicador); `factor_source` enum `["owner","history"]` obrigatório; `decide_by` date (início menos prazo, gravado pelo código); `notes` text.
Acesso: S.

## stock_settings (um registro)
`cover_target_days` number (padrão 60); `max_cover_days_on_round` number (padrão 90); `overstock_days` number (padrão 120); `dead_days` number (padrão 90); `voice_sample` text (mensagens que o dono já mandou a fornecedor); `ship_to` text (endereço de entrega); `buyer_name` text; `buyer_phone` phone.
Acesso: `read` = S; escrita = `role:admin`.

## Papéis
`stock` (Estoque: movimenta, conta, recebe, monta pedido; não envia pedido, não aceita diferença de conta, não marca conta paga). `owner` e `admin` fazem tudo.
