# Risco, roteiros de contato, operações em massa e relatórios

O melhor sinal de perda não é "parou de pagar": é o comportamento dos 60 a 90 dias antes disso. Agir nessa janela
é a razão do app existir.

## 1. Ritmo do cliente

Para cada cliente, a partir das datas dos eventos de valor (15 meses):
```
intervalo normal = mediana dos intervalos entre eventos dele (precisa de 3 ou mais eventos)
quieto           = dias desde o último evento > 2 x intervalo normal
sumido           = dias desde o último evento > 3 x intervalo normal
```
Com menos de 3 eventos: use a mediana da empresa (mediana dos intervalos normais de todos) e mostre o selo
"estimativa".

| Cliente | Normal | Sem vir há | Leitura |
|---|---|---|---|
| Dana R. | 3 meses | 7 meses | Quieta, vale uma ligação |
| Condomínio Ipê | 12 meses | 13 meses | Normal, deixar em paz |
| Marcos A. | 6 semanas | 5 meses | Sumido, reconquista |

## 2. Pontos de risco (padrão; o dono ajusta em Ajustes)

| Sinal | Pontos | Regra | Fonte |
|---|---|---|---|
| Contato principal saiu da empresa | 40 | `key_contact_left` marcado pela equipe | cliente empresa |
| Sumido | 35 | acima de 3x o ritmo | eventos |
| Quieto | 20 | acima de 2x o ritmo (não soma com Sumido) | eventos |
| Uso caiu mais de 50% | 30 | eventos nos últimos 90 dias contra os 90 anteriores (precisa de 2 ou mais nos anteriores) | eventos |
| Uso caiu de 20% a 50% | 10 | idem | eventos |
| Sem usar o app há 30 dias | 30 | nenhum `usage_ping` do cliente com login nos últimos 30 dias | uso do app |
| Pagamento atrasado há mais de 15 dias | 25 | cobrança vencida sem pagamento | cobrança do app |
| Pagamento atrasado de 1 a 15 dias | 10 | idem | cobrança do app |
| Avaliação de 1 ou 2 estrelas nos últimos 90 dias | 25 | `feedback`/`review` ligados ao cliente | avaliações |
| Chamado urgente ou alto aberto há mais de 7 dias | 20 | `ticket` do cliente | chamados |
| 3 ou mais chamados em 7 dias | 20 | idem | chamados |
| 2 tentativas de contato sem resposta | 15 | `retention_task` com `no_answer` nos últimos 30 dias | tarefas |
| Faltou ou cancelou o último agendamento | 10 | status do agendamento | agenda |
| Sem contato da empresa há 60 dias | 10 | `last_contact_at` vazio ou antigo | cliente |
| Disse que está vendo concorrente | 5 | `competitor_note` | cliente |

- Soma limitada a 100. Faixas: **Vermelho 70 ou mais** (risco de perder em menos de 30 dias), **Amarelo 40 a 69**
  (30 a 60 dias), **Verde abaixo de 40** (só acompanhar).
- Sinal cuja fonte não existe no app fica desligado e o Painel lista "Sinais sem dados: pagamento (o app não tem
  cobrança)". Nunca suponha zero.
- "Sem usar o app": o cliente logado grava um `usage_ping` por dia ao abrir o app (`count` antes de criar); a
  equipe lê o mais recente de cada cliente. Sinal desligado quando o app não tem login de cliente.
- **Criticou e sumiu** (avaliação 1 ou 2 seguida de nenhum evento) vai ao topo da faixa, qualquer que seja o valor:
  o cliente disse o que estava errado e foi embora; é o mais recuperável porque a correção já é conhecida.

Ordem da lista: faixa, criticou e sumiu, gasto em 12 meses, frequência, valor do último evento. Diga na tela qual
critério de valor foi usado.

## 3. Roteiros de contato (viram tarefas no "Criar plano")

**Vermelho**
| Quando | Tarefa |
|---|---|
| Em até 4 horas | Ligar: "Vi que [sinal]. Está tudo bem?" |
| Mesmo dia, cliente de valor alto | O dono fala pessoalmente |
| Dia 1 | Descobrir a causa: serviço, atendimento, preço, mudança de vida ou concorrente |
| Dia 3 | Combinar um plano com o cliente: o que muda, prazo, quem cuida |
| Dia 7 | Check-in: "O que combinamos está funcionando?" |
| Dia 14 | Revisar: os sinais voltaram ao normal? Se não, o dono assume |

**Amarelo**
| Quando | Tarefa |
|---|---|
| Dia 0 | Mensagem de check-in citando o sinal |
| Dia 2 | Ligar, se não respondeu |
| Dia 5 | Lembrar o valor: o que ele já aproveitou (dados reais do histórico) |
| Dia 10 | Sinais continuam: vira roteiro Vermelho |

Alerta por faixa: Vermelho aparece para o responsável e para o dono; Amarelo, só para o responsável.

## 4. Operações em massa (criar plano, reatribuir carteira, marcar perdidos)

1. **Protocolo** de operação segura (o mesmo da skill `fab-dados-seguros`, se instalada): (grupo por caixa ou por filtro buscado página a página, prévia com contagem exata
   antes de gravar, botão até 20 registros e número digitado acima de 20, `bulkCreate` ou `updateMany` em lotes de 200
   com relatório por registro, 429 tenta uma vez e para, entrada no `audit_log` com quem fez e valores anteriores).
2. **Específico da retenção**: a prévia mostra os 20 primeiros nomes e "e mais N" e diz o que muda e se dá para
   desfazer (tarefas se cancelam; perdido se desmarca); a prévia vale 5 minutos e depois refaz a busca.
3. **Quem pode**: `admin`; atendente cria plano só para os próprios clientes.
4. **Reatribuir carteira** (alguém saiu): filtro por `owner_user`, novo responsável, prévia, confirma; tarefas
   abertas mudam junto.

## 5. Relatórios

Todos no navegador, a partir de `list` paginada. Números só dos dados. Janelas com seletor.

**Perda de clientes (churn) mensal**, últimos 12 meses em barras:
```
ativo no dia D     = teve evento de valor nos active_window_days (padrão 90) antes de D
ativos no início   = ativos no dia 1 do mês
perdidos no mês    = ativos no início que não estão ativos no último dia do mês
churn do mês       = perdidos no mês / ativos no início
retenção do mês    = 100% - churn
```
Negócio de assinatura ou mensalidade: churn = assinaturas canceladas no mês / ativas no dia 1. Mostre também
clientes novos no mês e reativados (estavam inativos e voltaram).

**Painel de saúde** (`StatCard`): clientes em Vermelho, em Amarelo, % em Vermelho, taxa de salvamento, churn do
último mês fechado, reativados no mês.

| Métrica | Fórmula | Verde | Amarelo | Vermelho |
|---|---|---|---|---|
| % da base em Vermelho | vermelhos / clientes ativos | abaixo de 10% | 10% a 20% | acima de 20% |
| Taxa de salvamento | clientes com plano no mês que tiveram evento de valor em até 30 dias / clientes com plano | 50% ou mais | 30% a 49% | abaixo de 30% |
| Churn do mês | fórmula acima | igual ou melhor que a média dos 3 meses anteriores | até 50% pior | 2 vezes pior ou mais |
| Ativação no prazo | ver `boas-vindas-e-mensagens.md` | 70% ou mais | 10 pontos abaixo | 20 pontos abaixo |

Referência só para software por assinatura entre empresas: churn mensal de clientes abaixo de 1% é bom. Para
comércio e serviço local, compare com o próprio histórico, como na tabela.

**Tendência**: linha semanal de vermelhos e amarelos a partir de `risk_snapshot`.

**Revisão trimestral (aprender com as perdas)**, tela em Relatórios:
- Perdidos nos últimos 90 dias: quais sinais estavam presentes (`lost_signals`), contados; quais perdidos não
  tinham sinal nenhum (o que o app não viu).
- Alarmes falsos: clientes que ficaram Vermelhos e voltaram sozinhos, sem contato.
- Ajuste: lista maior do que a equipe consegue ligar, suba a linha do Vermelho ou baixe o peso do sinal que mais
  gera alarme falso; perdeu cliente fora da lista, desça a linha ou suba o peso do sinal que estava presente. A
  tela mostra essas duas frases com os números; o dono muda em Ajustes, e a mudança vai para o `audit_log`.

## 6. Listas prontas

- Sem contato da empresa há 60 dias (`last_contact_at` antigo) e nunca contatados (`last_contact_at` vazio).
- Descadastrados de mensagens (para não contar com eles em campanha).
- Clientes empresa sem nenhum evento aberto ou previsto.
- Clientes com chamado urgente ou alto aberto há mais de 7 dias (se o app tem chamados).
