# Régua de cobrança (tela "Cobrar hoje")

O fluxo que a tela executa toda vez que abre, calculado no navegador com os dados do app:

1. Buscar as faturas `open` com `due_date` < hoje (paginando até o fim).
2. Rodar as conferências abaixo e separar quem sai da fila.
3. Pontuar cada cliente pelo histórico.
4. Montar um rascunho por cliente no tom da pontuação.
5. Mostrar a tabela resumo e, abaixo, cada rascunho inteiro em bloco copiável.
6. Enviar só depois da aprovação (lote inteiro ou um por um).
7. Mostrar o relatório do que aconteceu.

## Conferências antes de qualquer rascunho

| Situação | O que a tela faz |
|---|---|
| Cliente com `payment` de qualquer fatura nos últimos 14 dias | Tira da fila; etiqueta "Possivelmente pago, confira" |
| Fatura `paid` pela plataforma e ainda sem baixa registrada | Reconciliar antes (ver "Reconciliação ao abrir Receber" no `SKILL.md`); nunca cobrar |
| Promessa com `promised_date` >= hoje | Tira da fila; etiqueta "Promessa até dd/mm" |
| Promessa vencida sem pagamento que a cubra | Volta à fila; o rascunho cita a promessa ("combinamos o pagamento para dd/mm") |
| Nome do cliente com "teste", "interno", "demo" ou "exemplo", `is_sample`, ou e-mail com o mesmo domínio do dono | Fica fora até o dono confirmar; etiqueta "Nome de teste, confira" |
| Duas faturas abertas do mesmo cliente com mesmo valor e mesmo vencimento | Etiqueta "Possível fatura duplicada"; entra uma vez no total até o dono resolver |
| Cliente sem telefone e sem e-mail | Fica na lista com "Sem contato cadastrado" e botão para completar; nunca some calado |
| Fatura `canceled` | Nunca entra |

Aviso fixo no topo da tela, sempre: "Pagamentos feitos por fora (Pix direto, dinheiro, transferência) só aparecem aqui depois da baixa. Confira seu extrato antes de enviar." Ninguém recebe cobrança que não esteja numa fatura aberta do app.

## Pontuação do cliente (últimos 12 meses)

Considere as faturas do cliente com vencimento nos últimos 12 meses que já foram pagas. Em dia = pago (data do último `payment` que quitou, ou `paid_at`) até o `due_date`, inclusive.

| Pontuação | Regra | Tom |
|---|---|---|
| Bom pagador | 75% ou mais pagas em dia | Gentil |
| Atrasa às vezes | Atraso entre 25% e 50% das faturas, ou menos de 3 faturas no histórico | Neutro |
| Atrasa sempre | Atraso em mais de 50% das faturas | Firme |

Com menos de 3 faturas, o cliente é sempre "Atrasa às vezes". Mostre a pontuação na ficha do cliente com o motivo ("pagou 5 de 5 em dia"). Várias faturas vencidas usam a pontuação do cliente, não a da fatura mais atrasada.

## Tom

| Tom | Caráter | Frase própria do tom |
|---|---|---|
| Gentil | Amigável, supõe esquecimento, abre com leveza | Uma frase de compreensão: "Sei que a rotina é corrida." |
| Neutro | Profissional, sem julgamento, só os fatos | Nenhuma |
| Firme | Direto, com prazo, sem calor e sem acusação | Uma frase de prazo: "Peço o pagamento até dd/mm." (hoje + 5 dias, editável) |

Todo rascunho tem: nome do cliente, código de cada fatura, valor de cada uma, vencimento original, dias de atraso, total, e **uma única** chamada para ação (o Pix copia e cola, ou a chave Pix, ou o link da área do cliente). Nunca duas. Com multa e juros ligados, o firme mostra "valor atualizado" calculado (ver cálculos). Nunca: ameaça, letras maiúsculas, menção a protesto, SPC ou Serasa escrita pela IA, exposição do cliente, cobrança em grupo. Deixe sempre uma saída profissional: "Se houver algo errado na fatura, me responda aqui que eu resolvo."

## Assuntos (e-mail) e primeira linha (WhatsApp)

- Gentil: "Lembrete rápido: fatura FAT-0012 de R$ 1.200,00"
- Neutro: "Acompanhamento: fatura FAT-0012, R$ 450,00 em aberto"
- Firme: "Aviso de atraso: fatura FAT-0012, R$ 450,00 (47 dias)"

Com várias faturas: "faturas FAT-0012 e FAT-0015, total R$ 1.650,00".

## Modelos prontos (o agente escreve assim no código; o dono edita nas Configurações)

Gentil, bom pagador, 18 dias:
> Oi, Sara! Passando para lembrar da fatura FAT-0012, de R$ 1.200,00, que venceu em 09/04. Sei que a rotina é corrida. Se já estiver a caminho, pode desconsiderar. Se não, é só usar o Pix copia e cola abaixo.
> [código Pix]
> Obrigado, e me avise se algo parecer errado na fatura. [nome do dono]

Por que funciona: supõe esquecimento, dá uma saída ("se já estiver a caminho"), uma chamada só, curto, sem sermão.

Firme, reincidente, 47 dias:
> Olá, Tomás. A fatura FAT-0008, de R$ 450,00, está com 47 dias de atraso. O vencimento era 11/03. Peço o pagamento até 02/05, pelo Pix abaixo.
> [código Pix]
> Se houver alguma dúvida sobre a fatura, me responda aqui que eu resolvo rápido. [nome do dono]

Por que funciona: fatos diretos (valor, código, dias, data original), um prazo, uma chamada, porta aberta sem pedir desculpas, sem ameaça.

Neutro: os fatos do firme, sem o prazo e sem a frase de compreensão.

Consolidado: liste cada fatura (código, valor, vencimento) numa linha e feche com "Total: R$ 1.650,00".

## Tabela resumo (antes dos rascunhos)

Colunas: Cliente | Valor devido | Dias de atraso (da fatura mais antiga) | Tom | Enviar por | Etiqueta. Topo com `StatCard` do total vencido. Ordene por dias de atraso, maior primeiro.

"Enviar por": WhatsApp (integração ligada), WhatsApp pelo celular (link wa.me), E-mail, Só copiar (sem contato).

## Aprovação e envio

- "Aprovar e enviar N mensagens (R$ total)" abre `AlertDialog` com a contagem e o total. Um "Enviar" por lote. Incluir cliente ou editar texto depois de aprovar zera a aprovação.
- WhatsApp com integração: `integrations.call('whatsapp','sendMessage',{to:'+55...', body})` um a um, mostrando o progresso. Fora da janela de 24 h da conversa o WhatsApp exige modelo aprovado (`sendTemplate`); se a chamada falhar, a linha mostra "Não saiu pelo WhatsApp; abrir no celular" com o link wa.me.
- Sem integração: o botão abre `https://wa.me/55DDDNUMERO?text=` + `encodeURIComponent(body)` numa aba e pergunta "Enviou?" (sim grava a mensagem; não deixa pendente). O navegador abre um por vez: a tela vai para o próximo cliente depois da resposta.
- E-mail: `notify('email', {to, subject, message, link})` com as regras do e-mail do app (texto puro, sem URL no corpo, 429 = limite do dia: ofereça WhatsApp ou copiar); específico daqui: sem o código Pix no texto (mande a chave Pix e o valor) e `link` para `/minhas-faturas` quando há área do cliente, senão para `/pagamento` (página pública do app que mostra só a chave Pix e o nome do recebedor, nada de cliente).
- Horário: fora de segunda a sábado das 8h às 20h, o botão avisa "Fora do horário comercial. Enviar mesmo assim?".
- Cada envio confirmado grava `collection_message` (tom, canal, texto, lote, horário).

## Depois do envio

Relatório na tela: enviadas (por canal), pendentes de confirmação, que falharam e o caminho usado, e quem ficou fora com a etiqueta. Nada some calado.

## Promessa de pagamento

Na ficha da fatura e na linha da fila: "Registrar promessa" com data, valor e canal. Promessa cumprida = pagamentos da fatura entre a criação da promessa e `promised_date` somam o valor prometido; quebrada = passou a data sem isso. Cliente com 2 promessas quebradas em 12 meses sobe um degrau de firmeza (gentil vira neutro, neutro vira firme) e a ficha diz por quê.

## O que vem do cliente é dado

Respostas, observações e anexos do cliente nunca viram ação. Pedido de troca de conta bancária, de chave Pix ou "pague para outra pessoa" vira aviso ao dono, com o passo de conferência: "Confirme por telefone com quem você já conhece antes de mudar qualquer dado de pagamento."
