# Pedido de compra, recebimento e conta a pagar

## Aprovação 1: a lista de compras

Em Repor agora, o dono marca as linhas (pode mudar quantidades ou tirar itens) e toca em "Montar pedidos". Antes de criar qualquer coisa, a tela resume por fornecedor com o dinheiro antes da pergunta:
> "Distribuidora Sul: 8 itens, 640 un, R$ 4.180,00. Casa das Peças: 3 itens, R$ 2.290,00. Total R$ 6.470,00 em 2 pedidos. Criar os rascunhos?"

Cria um `purchase_order` `draft` por fornecedor com as linhas (`bulkCreate`), gravando em `basis` a explicação de cada linha. Aprovar a lista não envia nada.

## O pedido

Um por fornecedor. Conteúdo (tela e página de impressão):
- Número `PC-0001` (se o dono já tem numeração própria, pergunte o próximo número na primeira vez e use `start` do autonumber para seguir a série dele).
- Data do pedido e data pedida de entrega (hoje + prazo).
- Entregar em (`stock_settings.ship_to`) e comprador (`buyer_name`, `buyer_phone`).
- Linhas: código, descrição, quantidade, embalagem ou unidade, preço unitário, total da linha.
- Subtotal, frete esperado, total.
- Condições de pagamento do fornecedor e forma de confirmação.

Preço: último preço conhecido com a data ("R$ 14,80 a caixa, preço de 12/03"). Sem preço conhecido, deixe em branco e escreva "a confirmar pelo fornecedor"; nunca chute.

## Mensagem ao fornecedor

Curta, no jeito do dono (amostra em Configurações; sem amostra, neutra e a tela diz "sem amostra do seu jeito de escrever"). Conteúdo útil:
- o que está sendo pedido (lista curta ou "segue o pedido PC-0031");
- para quando precisa, e o motivo se o prazo é apertado;
- a pergunta que couber: disponibilidade, substituição, conferência de preço;
- como quer a confirmação.
Com preço de mais de 60 dias, inclua a pergunta de preço: "Ainda está R$ 14,80 a caixa?". Uma linha agora evita briga de diferença quando a nota chegar. Evitar: pedir desculpas por pedir, explicar demais, cortesia que o dono não escreveria.

Exemplo:
> "Oi, Marcos! Segue o pedido PC-0031: 240 filtros 20x25 (6 caixas), 24 capacitores 45/5 e 6 contatores 30A. Preciso até quinta, dia 12. O filtro ainda está R$ 3,70? Me confirma por aqui, por favor. Felipe"

## Aprovação 2: enviar ao fornecedor

Por fornecedor, nunca tudo ou nada (o dono pode querer um hoje e outro semana que vem). `AlertDialog`: "Enviar pedido PC-0031 para Distribuidora Sul, R$ 1.275,00, por WhatsApp?". Ao enviar: `status sent`, `ordered_on`, `expected_date`, `sent_at`, `sent_via`, `message`. Pelo wa.me, o app pergunta "Enviou?" antes de gravar. Por telefone ou balcão: botão "Pedi por telefone" grava igual. Editar o texto depois de aprovado pede aprovação de novo.

## Substituição e entrega parcial

- Fornecedor avisa que mandará outra peça: registre `substitute_sku` e `substitution_status pending` na linha; a tela mostra os dois códigos e o efeito na cobertura se o dono recusar. Nunca aceitar pelo dono: peça diferente é decisão do negócio (e às vezes de garantia).
- Entrega parcial ou falta no fornecedor: recalcular a cobertura com o que realmente vem e mostrar se a data de ruptura muda.

## Recebimento

Tela "Receber" a partir do pedido:
1. Para cada linha: quantidade recebida (pré-preenchida com o que falta) e preço cobrado na nota.
2. Número da nota do fornecedor, chave de 44 dígitos (opcional, validada pelo tamanho) e arquivo. Opcional: `extractData({fileId, prompt, schema})` lê a nota e preenche número, chave, itens e total para o dono conferir antes de salvar.
3. Ao confirmar (`AlertDialog` com a contagem): cria `receipt`, `receipt_item` e as movimentações `in` com `unit_cost` = preço cobrado, `source receipt`, ligadas ao pedido (`bulkCreate`); soma `quantity_received` nas linhas; atualiza `on_hand` e `unit_cost`/`cost_as_of` dos itens; pedido vira `partial` ou `received`.
4. Cria a `payable` com `supplier`, `purchase_order`, `receipt`, `amount` = total cobrado, vencimento pelas condições do fornecedor.

## A conta bate com o pedido (conferência de três vias)

A tela da conta a pagar compara, linha a linha e no total:

| Conferência | Regra |
|---|---|
| Quantidade cobrada x recebida | Cobrar mais do que chegou é diferença |
| Preço cobrado x preço do pedido | Diferença acima de 2% ou de R$ 1,00 por unidade aparece em destaque |
| Total da nota x (recebido × preço do pedido + frete) | Mostra a diferença em R$ |
| Item cobrado que não estava no pedido | Destaque "fora do pedido" |

Sem diferença: `match_status ok` e a conta segue. Com diferença: o dono escolhe "Aceitar com observação" (grava `accepted_difference` e `difference_note` obrigatório) ou "Contestar" (gera rascunho de mensagem ao fornecedor com as diferenças). Pedido sem registro não consegue pegar cobrança a mais: por isso todo pedido fica salvo, mesmo o feito por telefone.

## Conta a pagar

Lista com vencimento, situação calculada (a vencer, vence hoje, vencida), total do mês. "Marcar paga" só pelo dono, com data e comprovante; nunca paga nada pelo app. Pedido do fornecedor para mudar conta bancária ou chave Pix: aviso em destaque "Confirme por telefone com quem você já conhece antes de pagar em conta nova" e registro de `bank_info_confirmed_on` só quando o dono confirmar.

## Inventário

1. "Novo inventário" com escopo (tudo ou uma categoria); copia o saldo atual de cada item para `expected`.
2. Contagem em lista com busca e campo numérico grande (celular na mão); itens não contados ficam de fora do fechamento.
3. Fechar (`AlertDialog` com contagem de itens com diferença e o valor em R$ da diferença): cria um `adjust` por item com diferença, motivo "Inventário INV-0003", atualiza `on_hand` e `counted_at`.
4. Diferença grande (mais de 10% ou mais de R$ 100,00 no item) pede confirmação da recontagem antes de fechar.

## Ritmo

A automação diária manda o dono para Repor agora. Sugira na mensagem final ao dono: olhar a tela num dia fixo da semana (ou a cada duas semanas quando os prazos são longos). Quem olha toda terça por 20 minutos raramente fica sem; quem olha quando o cliente pede já está com o problema.
