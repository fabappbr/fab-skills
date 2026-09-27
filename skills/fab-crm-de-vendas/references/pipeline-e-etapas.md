# Funil, etapas e regras de movimento

Etapa descreve o avanço do **cliente**, não a tarefa do vendedor ("Demonstração marcada" é ação; "Cliente confirmou que a solução resolve a dor" é etapa). Cada etapa tem três partes, e sem elas a revisão do funil vira palpite: **Objetivo** (o que cliente e empresa alcançam), **Ações na etapa** (o que o vendedor faz) e **Critério de saída** (evidência que libera o avanço, conferível no registro, nunca "o vendedor sente que vai").

## Funil simples (quem fecha rápido por WhatsApp ou telefone)

Quatro etapas. Dono sem CRM precisa saber o que fazer em seguida, não de uma taxonomia; mais etapas é mais negócio parado na etapa errada.

| Ordem | Etapa | Prob. | Tipo | Critério de saída |
|---|---|---|---|---|
| 1 | Novo | 20% | aberta | Falou com a pessoa e entendeu o pedido |
| 2 | Orçamento enviado | 60% | aberta | Orçamento anexado ou registrado como atividade "proposta" (`requires_proposal`) |
| 3 | Ganho | 100% | ganha | Valor final e data de fechamento |
| 4 | Perdido | 0% | perdida | Motivo de perda |

## Funil consultivo (orçamento, visita, negociação): padrão

| Ordem | Etapa | Prob. | Objetivo | Ações na etapa | Critério de saída | Limite | Previsão |
|---|---|---|---|---|---|---|---|
| 1 | Novo contato | 10% | Interesse confirmado | Responder em até 1 h, entender o pedido | Conversa feita; situação registrada | 7 dias | funil |
| 2 | Qualificado | 25% | Dor e prazo claros | Perguntar situação, dor, impacto, prazo, quem decide | Dor e prazo com nível 2; quem decide identificado | 21 dias | melhor_cenario |
| 3 | Proposta enviada | 50% | Condições apresentadas | Visita ou reunião, montar e enviar proposta | Proposta anexada; falou com quem decide; próximo contato marcado | 30 dias | compromisso |
| 4 | Negociação | 75% | Termos acertados | Ajustar escopo, prazo, forma de pagamento | Cliente disse sim aos termos; falta só assinar ou pagar | 14 dias | compromisso |
| 5 | Ganho | 100% | Venda feita | Registrar valor final, passar para entrega | Valor final; pacote de passagem preenchido | | ganho |
| 6 | Perdido | 0% | Aprender com a perda | Registrar motivo e concorrente | Motivo; concorrente se houver; etapa em que perdeu (vem do histórico) | | perdido |

Ramos com etapa própria (energia solar com visita técnica, obra com medição) ganham uma etapa entre Qualificado e Proposta, nunca passando de 6 abertas. Mais de 9 etapas no total só cria atrito, sem ganhar precisão.

## Mudar de etapa (diálogo único, usado pelo kanban e pela ficha)

1. Avançar: o diálogo lista os critérios de saída da etapa atual com a marcação de cada um (`criteria`). Todos marcados: avança. Faltando: mostra quais e pede uma justificativa de uma linha ("avançou sem critério"), gravada em `stage_history.reason`.
2. Pular etapa: exige os critérios das etapas puladas ou justificativa.
3. Entrar em etapa com `requires_proposal`: exige atividade do tipo "proposta" com anexo ou `proposal` com status enviada; preenche `proposal_sent_at`.
4. Voltar etapa: permitido, com motivo, e aparece no histórico.
5. Perdido: motivo (lista de `crm_option`) obrigatório, concorrente opcional. Ganho: `final_amount` obrigatório; grava `closed_at` = hoje; oferece o pacote de passagem (pós-venda).
6. Em toda mudança: `stage_history` (de, para, quem, quando, dias na anterior, valor no momento), `audit_log`, `stage_entered_at` = agora, `status` pela `kind` da nova etapa, `lifecycle` do contato pelos eventos de `fab-modelo-de-dados.md`.
7. Qualquer etapa aberta exige próximo passo com data; ao mudar de etapa o diálogo já pede o novo próximo passo.

## Qualificação leve (para todo negócio)

Cinco perguntas, preenchidas aos poucos entre Novo contato e Proposta, nunca todas numa conversa só. Cada uma com nível 0 (não sabe), 1 (suspeita) ou 2 (confirmado, com a atividade que prova).

| Pergunta | Quando | Exemplo de evidência |
|---|---|---|
| Situação: como faz hoje | Novo contato, Qualificado | "Usa três fornecedores, controla em caderno" |
| Dor: o que incomoda | Qualificado | Frase do cliente |
| Impacto: quanto custa (R$, tempo, cliente perdido) | Qualificado | "Perde 2 dias por mês" |
| Prazo: o que obriga a decidir e quando | Qualificado, Proposta | Data de inauguração, fim de contrato |
| Decisão: quem decide, quem paga, como aprovam | Proposta | Nome e papel em `deal_contact` |

Regras: sem prazo (nível 0) ao fim de Qualificado, o app sugere mover o contato para "Agora não" com data de retorno; sem prazo não há data de fechamento confiável. Não enviar proposta sem saber quem decide. A qualificação envelhece: ao entrar em Proposta, o diálogo pede para reconfirmar o prazo. Só marque como bloqueio o que impede avançar (quem decide faltando bloqueia; valor exato do orçamento no começo não).

## Placar de negócio grande (quando `big_deal` ou valor acima de `big_deal_min`)

Sete dimensões, nota 0, 1 ou 2 cada (máximo 14), reavaliadas depois de cada conversa:

| Dimensão | Nota 2 exige |
|---|---|
| Métrica | Indicador do cliente com valor de hoje e meta |
| Quem paga | Pessoa com poder de verba, com quem já falamos |
| Critérios de escolha | Lista dos critérios do cliente, com os nossos pontos fortes marcados |
| Processo de decisão | Passos, datas e quem aprova |
| Dor | Dor com custo de não resolver |
| Aliado interno | Passa no teste de 4 itens abaixo |
| Concorrência | Concorrentes, "deixar como está" e "fazer em casa" avaliados |

Teste do aliado (todos os 4): tem poder para influenciar a decisão (não é só entusiasmo); ganha algo pessoal se fechar; explica o problema sem nossa ajuda; se comprometeu a defender a compra quando não estamos na sala.

Portões de avanço: Proposta só com 10 de 14, aliado 2 e quem paga 1 ou mais. Negociação com 12 de 14 e quem paga 2. Previsão "compromisso" só com 13 de 14 e nenhuma dimensão zerada em quem paga, dor ou aliado. Nota abaixo de 6 em Qualificado sugere "Agora não". Nota que cai de uma semana para outra entra na revisão semanal. As cinco perguntas leves e o placar usam os mesmos campos (dor = dor, impacto = métrica, decisão = quem paga, critérios e processo): um lugar só, sem duplicar.

## Tempo na etapa e negócio parado

- Parado por atividade: sem atividade há `quiet_days` (14).
- Parado por etapa: mais que 2 vezes a mediana de dias naquela etapa. Mediana calculada do `stage_history` dos negócios que já saíram dela; com menos de 5 amostras, use a mediana dos abertos na mesma etapa; com menos de 3, use `max_days` da etapa.
- Limites fixos: Qualificado há mais de 21 dias sem prazo = parado; Proposta há mais de 30 dias sem falar com quem decide = em risco; 60 dias na mesma etapa = tarefa ao dono do negócio para decidir (avançar, adiar data ou perder).
- Fechamento vencido: `expected_close` antes de hoje e ainda aberto.
- Previsão sem pressa: probabilidade alta (etapa 50% ou mais) com fechamento a mais de 60 dias: candidato a acelerar.

## Previsão de vendas

| Grupo de etapas | Categoria | Confiança |
|---|---|---|
| Novo contato | Funil | 10 a 20% |
| Qualificado (e etapa técnica) | Melhor cenário | 30 a 50% |
| Proposta, Negociação | Compromisso | 70 a 85% |
| Ganho | Ganho | 100% |

Previsão ponderada = soma de `amount × probabilidade da etapa` dos abertos com `expected_close` no período. Compromisso só conta negócio com os critérios de saída de Proposta cumpridos, não otimismo.

## Conversão entre etapas

Taxa = negócios que entraram na etapa seguinte ÷ negócios que entraram na etapa, no mês, pelo `stage_history`. Compare com a média dos 3 meses anteriores do próprio app. Queda de mais de 10 pontos: o relatório avisa "negócios avançando sem evidência ou objetivo da etapa errado". Referência de mercado B2B consultivo (só para a IA calibrar, nunca mostrar como meta do dono): contato para conversa 15 a 25%, conversa para diagnóstico 40 a 60%, diagnóstico para solução 50 a 70%, solução para proposta 40 a 60%, proposta para ganho 25 a 40%.

## Status do lead e rotina de contato

`lead_status` segue o estado da abordagem, independente do ciclo de vida: Novo (não contatado) → Tentando contato (em cadência) → Conectado (respondeu, atendeu ou indicou alguém) → Reunião marcada. Saídas: Agora não (com `recontact_on`) e Desqualificado (com motivo; não apaga). Ordem de trabalho do dia, de trás para frente: confirmar reuniões marcadas, trabalhar os conectados, fazer os toques da cadência, e só então o primeiro contato dos novos.

Cadência padrão para lead que não respondeu (tarefas criadas com um clique, nunca envio automático):

| Dia | Toque |
|---|---|
| 1 | WhatsApp de apresentação |
| 2 | Ligação 1 (fim de tarde) |
| 3 | E-mail ou WhatsApp citando a ligação |
| 5 | Ligação 2 |
| 7 | WhatsApp com algo útil |
| 9 | Ligação 3 |
| 11 | Mensagem de valor |
| 14 | Última ligação e mensagem de encerramento |

Até a 3ª tentativa acontecem cerca de 93% das conversas; até a 5ª, 98%. Pare em 5 tentativas sem resposta (`attempts`): o app sugere "Agora não" com retorno em 90 dias. Na ligação: diga quem é e peça 30 segundos para explicar o motivo; nunca "estou atrapalhando?"; termine com dia e hora concretos ("quinta às 14h funciona?").

## Resultado da ligação

Toda ligação atendida recebe um resultado só: Agendou, Interessado (sem marcar), Agora não, Pessoa errada (sem indicação), Indicou outra pessoa, Sem interesse. "Não atendeu" conta tentativa, não conversa. Leitura, só com 50 conversas ou mais no período (antes disso é ruído): muita "Pessoa errada" = lista mirando o cargo errado; "Indicou outra pessoa" = ouro para a próxima lista; "Sem interesse" alto: compare por vendedor antes de culpar a mensagem; "Interessado" alto e pouco "Agendou" = falta retomada. Mude uma coisa por vez (lista, mensagem, vendedor ou retomada), nunca duas.

## Depois do ganho (pós-venda como gancho)

O CRM continua depois do "Ganho": entrega, uso, renovação, expansão e indicação.

- **Pacote de passagem** (no ganho): o que foi prometido, critérios de sucesso do cliente, contatos e papéis, data do primeiro resultado. Sem ele, quem entrega começa às cegas.
- **Primeiros passos do cliente**: checklist de entrega como tarefas criadas com um clique (boas-vindas no dia 0, confirmação do primeiro resultado, pedido de avaliação ou indicação ao atingir o resultado).
- **Renovação**: negócio recorrente com `contract_end`; automação `relative` avisa o dono 90 dias antes; "Criar renovação" gera negócio `renovacao` ligado por `parent_deal`. Expansão é negócio `expansao` ligado ao original e fica fora do relatório de cliente novo.
- **Risco de perder o cliente** (tela Clientes em risco): Vermelho com qualquer um de: sem contato há `risk_days` (60) ou nunca contatado; etiqueta "risco" posta pelo vendedor (reclamou ou falou em cancelar); pediu para sair (opt-out). Amarelo: sem atividade há 30 dias; negócio de renovação parado; nenhuma resposta às duas últimas tentativas. Verde: o resto. Rotina vermelho: ligar no dia, entender a causa (produto, atendimento, dinheiro, concorrente), plano com data em 3 dias, conferir em 7 e em 14. Amarelo: mensagem no dia 0, ligação no dia 2, algo de valor no dia 5, vira vermelho no dia 10 se nada mudar. A cada cliente perdido, registrar quais sinais estavam lá 90 dias antes.

## Revisão semanal do funil (roteiro na tela Relatórios)

1. Negócios novos: cumprem o critério da etapa em que estão?
2. Parados há mais de 14 dias: qual pergunta da qualificação falta?
3. Compromissos em risco: o que mudou desde a semana passada?
4. Sem próximo passo: definir ação com data agora.
5. Data de fechamento adiada: é padrão ou caso isolado?

Perguntas de revisão, nunca "como você se sente sobre esse negócio?": qual é a evidência de cada resposta da qualificação? Quem decide e quando falamos com ele por último? Qual é a data que obriga o cliente a decidir e o que acontece se ele perder? O que faria esse negócio morrer?
