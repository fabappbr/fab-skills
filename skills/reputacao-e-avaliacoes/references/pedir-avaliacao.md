# Pedir avaliação: momento, canais, mensagens e o link do Google

## Momento certo (decisão por nicho; a conversa com o dono confirma)

| Negócio | `send_at` |
|---|---|
| Restaurante, delivery | 2 h depois da entrega |
| Salão, barbearia, estética, clínica, terapia | dia seguinte ao atendimento, 10h |
| Oficina, assistência técnica, instalação | 2 dias depois da entrega do serviço, 10h |
| Loja online | 3 dias depois da entrega, 10h |
| Hotel, pousada | dia seguinte ao check-out, 10h |
| Curso, aula | 7 dias depois do início, 10h |

Regras de horário: se o horário calculado cair entre 20h e 8h, mova para 10h do próximo dia; domingo move para
segunda às 10h. Use `date-fns` no fuso do aparelho. A automação `relative` avisa na hora cheia, então o minuto não
importa.

Um pedido por atendimento (`related_id` único, conferido com `count`) e no máximo um pedido por cliente a cada 30
dias. Não insista: sem resposta, o pedido fica "Enviado" e pronto.

## Canais (todos dão ao cliente o mesmo link `/avaliar/{token}` do app)

| Canal | Como | Observação |
|---|---|---|
| WhatsApp com mensagem pronta | botão abre `https://wa.me/55DDDNUMERO?text=<mensagem codificada>`; a pessoa da equipe aperta enviar | sempre funciona; marca `sent_at` ao clicar |
| WhatsApp automático | `integrations.call('whatsapp','sendTemplate', {to, template, components})` | o dono conecta no Studio; fora de 24 h da última conversa só com modelo aprovado pela Meta; cliente precisa ter aceitado receber mensagens |
| E-mail | `notify('email', {to, subject, message, link})` chamado pela equipe logada | regras do e-mail do app (texto puro, sem URL no corpo, 429 = limite do dia); `link` = `/avaliar/{token}` |
| Aviso no app | automação `relative` para `customer_user` | só cliente com login |
| Link copiado | botão "Copiar link" | para colar em qualquer lugar |

## Mensagens padrão (o dono edita em Ajustes; substitua os campos, nunca invente)

WhatsApp:
```
Oi, {primeiro nome}! Aqui é {assinatura}. Como foi {serviço}? Leva 30 segundos para contar:
{link}
Sua opinião ajuda a gente a melhorar.
```
E-mail (assunto "Como foi {serviço}?"):
```
Oi, {primeiro nome}. Aqui é {assinatura}. Queremos saber como foi {serviço}. São só duas perguntas e leva 30
segundos. Toque no botão abaixo.
```
Sem promessa de brinde. Sem pedir "5 estrelas". Sem citar o Google na mensagem de convite: o Google aparece na tela
de obrigado, para todas as notas.

## A tela de obrigado e o Google

- Texto igual para qualquer nota. Botão "Avaliar no Google" abre `google_review_url` em nova aba.
- Nota 1 a 3 ganha, além disso, o bloco "Quer que a gente fale com você?" (liga `wants_contact`). O Google continua
  lá. Tirar o Google das notas baixas é o pedido seletivo que a política do Google proíbe e que engana o consumidor.
- Nada de "Se gostou, avalie no Google; se não gostou, fale com a gente". Essa frase é o filtro proibido.

## Como o dono pega o link do Google (texto de ajuda em Ajustes)

"No Google, abra o Perfil da sua empresa, toque em 'Pedir avaliações' e copie o link. Cole aqui." Campo `url` com
validação de endereço. Enquanto vazio: botão escondido e cartão de configuração. Nunca monte um link do Google por
conta própria nem use um exemplo.

## Clientes de primeira vez e sinais de operação (quando o app tem pedidos)

Se o app tem `order` ou atendimentos com datas, o Painel acrescenta, só com os campos que existem:
- **prazo de entrega subindo**: mediana da janela contra a janela anterior, os dois números;
- **devolução ou cancelamento repetido do mesmo item**: 3 ou mais na janela é problema do item, não de 3 pessoas;
- **entregas parciais subindo**;
- **clientes de primeira compra que não voltaram**, em % da janela.
Esses sinais aparecem antes das avaliações ruins, algumas semanas antes. Se o motivo da devolução não é registrado,
o cartão diz "motivo não registrado" em vez de adivinhar.

## O cliente que criticou e sumiu

Com `customer` ligado à `feedback`: crítica nos últimos 90 dias e nenhuma compra ou atendimento depois dela vira o
selo "Criticou e não voltou" no topo da Triagem, com a sugestão "Ligue você mesmo; não mande cupom". É o sinal mais
claro de cliente perdido e o mais recuperável, porque ele já disse o que estava errado. Recuperar clientes sumidos em
geral (ritmo de compra, lista de risco, mensagem de volta) é outro trabalho; se o dono quiser, sugira instalar a skill
"Retenção de Clientes" (`retencao-de-clientes`).
