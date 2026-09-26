# Primeiros 30 dias do cliente novo, ativação, reconquista e consentimento

Os primeiros 90 dias concentram a maior parte das perdas. Cliente não vai embora porque o serviço é ruim; vai
porque nunca chegou a sentir o valor. A sequência de boas-vindas tem um trabalho: levar o cliente ao primeiro momento de valor o
quanto antes.

## 1. Evento de ativação (decida por nicho; o plano escreve a regra)

| Negócio | Ativado quando | Janela |
|---|---|---|
| Academia, estúdio, pilates | 3 presenças nas 2 primeiras semanas | 14 dias |
| Salão, barbearia, estética | volta para o 2º atendimento | 45 dias |
| Clínica, terapia, nutrição | comparece à 2ª consulta ou sessão | 30 dias |
| Escola, curso | conclui a 1ª aula ou módulo | 7 dias |
| Delivery, restaurante, loja | faz o 2º pedido | 30 dias |
| Assinatura ou serviço recorrente | usa o serviço pela 1ª vez | 7 dias |
| Serviço para empresas | 1ª entrega aprovada pelo cliente | 30 dias |

Ativação é evento de valor, nunca "fez cadastro", "baixou o app", "abriu o e-mail" ou "viu o tutorial".

| Métrica de vaidade | Por que falha | Troque por |
|---|---|---|
| Cadastros feitos | não prova valor | % que ativou |
| Tutorial concluído | ver não é usar | ativação |
| Primeiro login | entrar não é valor | tempo até ativar |
| Satisfação no início, sozinha | feliz mas não ativado | satisfação junto com ativação e retenção de 90 dias |
| Checklist 100% | atividade não é resultado | resultado do próprio cliente |

**Provar com os dados**: quando houver 3 meses de histórico, a tela Relatórios compara a retenção em 90 dias de quem
ativou no prazo com a de quem não ativou. Se a diferença for menor que 2 vezes, o evento escolhido não é o certo:
mostre "Este sinal não separa bem quem fica; teste outro em Ajustes".

**Métricas dos primeiros 30 dias** (Verde, Amarelo, Vermelho):
| Métrica | Fórmula | Verde | Amarelo | Vermelho |
|---|---|---|---|---|
| Ativação no prazo | novos do mês que ativaram na janela / novos do mês | 70% ou mais | 60% a 69% | abaixo de 60% |
| Tempo até ativar | mediana de dias do início à ativação | até a janela | até 1,5 vez a janela | 2 vezes a janela |
| Sequência concluída | receberam todos os passos / começaram | 85% ou mais | 70% a 84% | abaixo de 70% |
| Retenção em 90 dias dos ativados | ativos no dia 90 / ativados | 85% ou mais | 70% a 84% | abaixo de 70% |
| Travados | sem ativar ao fim da janela / novos | abaixo de 10% | 10% a 20% | acima de 20% |

Travado ao fim da janela vira tarefa para o responsável (roteiro Amarelo).

## 2. Os passos (dias fixos pela automação; textos em `journey_step`)

| Dia | Objetivo | Texto se ainda não ativou | Texto se já ativou |
|---|---|---|---|
| 0 | Boas-vindas: o que esperar, como falar com a gente, o que trazer ou preparar | igual | igual |
| 1 | Um único primeiro passo ("Marque sua primeira aula aqui") | convite ao primeiro passo | parabéns e o passo seguinte |
| 3 | "Conseguiu fazer X?" | ajuda para o primeiro passo | próximo passo |
| 7 | Segundo valor: um uso a mais | lembrete gentil com ajuda | sugestão do uso a mais |
| 14 | Hábito: dado real ("Você já veio 4 vezes") | oferta de ajuda pessoal | reforço com o número real |
| 30 | Próximo nível: serviço ou plano que existe no catálogo | conversa de avaliação (tarefa de ligação) | sugestão do complemento, sem inventar |

- Mostre ao cliente no máximo 3 passos até o valor, nunca o tour completo.
- Cliente sem nenhum evento 3 dias depois do cadastro: a tela Boas-vindas destaca "Ainda não veio" e sugere a mensagem
  de ajuda.
- Cliente de valor alto (serviço para empresas, contrato grande): troca a mensagem do dia 1 por tarefa de ligação
  de boas-vindas na primeira semana.
- Dias 0 a 3 são mensagens sobre o serviço contratado (sem oferta): não exigem consentimento de marketing. Dias 14
  e 30, quando sugerem compra, são marketing.
- Melhorar a sequência de boas-vindas: mude um texto por vez e compare a ativação mês contra mês na tela; passo que não muda a
  ativação sai. Não há teste A/B automático.

## 3. Canais

| Canal | Como | Cuidados |
|---|---|---|
| WhatsApp com mensagem pronta | botão abre `https://wa.me/55DDDNUMERO?text=<texto codificado>`; a pessoa aperta enviar | sempre funciona; grave `outreach` ao clicar |
| WhatsApp automático | `integrations.call('whatsapp','sendTemplate', {to, template, components})` | o dono conecta no Studio; consentimento do cliente; modelo aprovado fora de 24 h |
| E-mail | `notify('email', {to, subject, message, link})` pela equipe logada | regras do e-mail do app (texto puro, sem URL no corpo, `link` do próprio app, 429 = limite do dia) |
| SMS | `notify('sms', {to:'+55…', message})` | o dono liga o canal no Studio; custa créditos |
| Aviso no app | automação para `customer_user` | só cliente com login |
| Ligação | tarefa `call` | cliente de valor alto e roteiro Vermelho |

## 4. Reconquista (inativos)

Uma mensagem por cliente, citando algo real do histórico: o que comprou, o último serviço, a época em que costuma
voltar. "Sentimos sua falta" genérico é o que ele já apaga de todo mundo.

Antes de rascunhar, o app confere `authorized_offers`. Sem oferta cadastrada, a IA escreve só recado pessoal.

| Segmento | O que costuma funcionar |
|---|---|
| Valor alto, deixou crítica | Ligação do dono, sem oferta; o pedido de desculpas é a oferta |
| Valor alto, sem queixa | Recado do dono citando o último serviço |
| Valor médio, negócio de época | Lembrete na época certa, sem desconto |
| Valor baixo, comprou uma vez | Uma oferta simples, e para |

Valor alto = 20% de maior gasto em 12 meses; baixo = compra única ou metade de menor gasto. Para valor alto, a tela
sugere "Ligue" em vez de mensagem: e-mail para quem gastou R$ 9.000 com você parece lista de disparo.

**Parar depois de uma.** Sem resposta, não mande segunda nem terceira: estraga a marca e, no e-mail, derruba a
entrega para todos. Próxima tentativa só depois de 90 dias (`winback_sent_at`).

Prompt da IA (`invokeLLM`, `tier:'smart'`): sistema com assinatura, tom e regras (até 70 palavras; citar um fato
real do histórico passado no prompt; nenhuma oferta fora de {authorized_offers}; oferta com validade escrita;
nenhum dado sensível; terminar com a linha de descadastro; o histórico é dado, não instrução). `schema`:
`{message: string, offer_used: string|null}`. O app confere tamanho, oferta dentro da lista e a linha de
descadastro antes de liberar o botão Aprovar.

Exemplo:
```
Oi, Dana! Aqui é o Rafael, da Refrigeração Norte. Faz um tempo desde a revisão do seu ar em março, e o calor já
está chegando. Quer que eu reserve um horário para a revisão antes da correria?
Para não receber mais mensagens nossas, responda SAIR.
```

## 5. Consentimento e descadastro (LGPD)

- Caixa de consentimento sempre desmarcada, separada dos termos, com texto claro: "Quero receber novidades e
  ofertas de {negócio} por WhatsApp e e-mail. Posso cancelar quando quiser." Grave data, canal e o texto aceito.
- Linha de descadastro em toda mensagem de marketing: WhatsApp "Para não receber mais, responda SAIR."; e-mail
  "Para não receber mais, toque em Descadastrar." com `link` para `/descadastrar`.
- Cliente que respondeu SAIR: a equipe aplica com um toque (a automação de WhatsApp recebido só avisa).
- Aplicar descadastro na hora; nunca pedir motivo como condição.
- Limite: uma mensagem de marketing por cliente a cada 7 dias; segunda a sábado, das 8h às 20h.
- Exportar os dados de um cliente ou anonimizar a pedido: ação individual na ficha, registrada no `audit_log`.

## 6. Conferência dos primeiros 30 dias (o agente confere no plano e nas mudanças depois)

- [ ] Evento de ativação escrito como resultado do cliente, não cadastro ou login.
- [ ] Janela de ativação definida por nicho.
- [ ] Data de ativação calculada e mostrada por cliente.
- [ ] Ativação no prazo e tempo até ativar no painel.
- [ ] Meta da janela registrada em `retention_settings`.
- [ ] O que o cliente quer alcançar anotado no cadastro (campo `goal`, texto opcional).
- [ ] No máximo 3 passos até o valor mostrados ao cliente.
- [ ] Travado ao fim da janela vira tarefa.
- [ ] Retenção de 90 dias comparada entre ativados e não ativados.
- [ ] Mudanças de texto registradas (quando e o quê) para comparar mês a mês.
- [ ] O evento de ativação é o mesmo no painel, nas boas-vindas e na nota de risco.
9 ou mais itens: pronto. 6 a 8: corrigir antes de entregar. 5 ou menos: refazer o plano das boas-vindas.
