# Diagramas, eventos e dados para relatório

## Qual diagrama para qual pergunta

| O dono precisa entender | Diagrama | Como vai no plano (texto no terminal, sem mermaid) |
|---|---|---|
| O que se liga a quê | Entidades e relações | lista "A 1 → N B (B guarda `a`)", "A N ↔ N B via C" |
| Por quais etapas um registro passa | Estados | tabela De, Para, Ação, Quem pode, O que dispara |
| Quem faz o quê e em que ordem | Sequência | passos numerados com o ator no início ("3. Cliente aprova pelo link") e desvios "Se recusar → volta para Orçamento" |
| Um processo com decisões | Fluxo | passos numerados com "Se ... →" |
| Onde cada área mora no app | Mapa de telas | lista indentada com a rota de cada tela |

Regras: um diagrama por conceito; nomes do glossário, no singular; cardinalidade exata (um e só um, zero ou um, um ou mais, zero ou mais); caminho de erro sempre escrito; mais de 8 modelos ou 12 passos, divida por área. Comece pelo essencial e acrescente detalhe só se o dono perguntar.

Cardinalidade em palavras: "exatamente um" (`||`), "zero ou um" (`|o`), "um ou mais" (`}|`), "zero ou mais" (`}o`).

### Quando o dono quer o diagrama dentro do app

Se o dono pedir uma tela "Como funciona" com o fluxo desenhado, o app pode usar o pacote npm `mermaid` (`npm install mermaid` dentro de `.fabapp/workspace`, enviado pelo `fabapp deploy`), renderizado num `useEffect` com `mermaid.initialize({ startOnLoad:false, theme:"neutral" })` e `mermaid.render`. Nunca `themeVariables` com hex (a plataforma proíbe cor fixa no código; confira com uma busca antes de publicar). Sintaxe mínima:

```
erDiagram
  CLIENTE ||--o{ PEDIDO : faz
  PEDIDO ||--|{ ITEM : contem
stateDiagram-v2
  [*] --> Orcamento
  Orcamento --> Aprovado : Aprovar
  Orcamento --> Cancelado : Cancelar
  Aprovado --> Pronto : Concluir
  Pronto --> [*]
sequenceDiagram
  actor Cliente
  Atendente->>Sistema: cria pedido
  Sistema-->>Cliente: link de aprovação
  alt aprovou
    Cliente->>Sistema: aprova
  else recusou
    Cliente->>Sistema: recusa
  end
```
Comentários com `%%`; palavra desconhecida quebra o diagrama; evite `{}` em comentários e acentos em nomes de nós (use rótulo entre aspas se precisar).

## Eventos de domínio

Um evento é algo que aconteceu e que o dono consideraria importante ("você se importaria se isso acontecesse?"). Nome sempre no passado e específico:

| Vago | Específico |
|---|---|
| Pedido atualizado | Item adicionado, Endereço de entrega trocado, Pedido aprovado |
| Pagamento processado | Pagamento confirmado, Pagamento estornado |
| Cliente alterado | Cliente arquivado, Telefone confirmado |

Formato: `<Registro> <ação no passado>`. O que o registro de evento guarda: tipo, quando (`happened_at`), o registro de origem (`ref`), quem fez (`created_by`), de e para (em transições) e o que for preciso para avisar sem consultar de novo (descrição pronta, valor, cliente). Nem pouco (só o id) nem o registro inteiro copiado.

Regras práticas na Fabapp:
- Evento é fato: criado, nunca editado. `update` e `delete` do modelo de histórico só para admin.
- Grave o evento no mesmo clique que muda a etapa, logo depois do `update` dar certo. Se o `update` falhar, não grave o evento.
- Idempotência: o botão fica em carregamento (`LoadingButton`) até terminar, para um clique duplo não criar dois eventos; antes de criar, pode conferir `count({ order: id, event_type, to_status })` quando a repetição for danosa.
- O estado atual mora no registro; o histórico explica como se chegou lá. Não reconstrua o estado a partir dos eventos.
- Processo que atravessa vários registros (pedido aprovado reserva estoque e gera cobrança) roda no código da ação ou numa função, passo a passo, com desfazer explícito se um passo falhar (ex.: cancelar a reserva).

## Fatos e cadastros (esquema estrela)

**Fato**: o que acontece e se soma. Muitos registros, um por acontecimento, com data e valores somáveis. Ex.: venda, item vendido, atendimento, agendamento realizado, lançamento financeiro, movimento de estoque, visita.
**Cadastro (dimensão)**: quem e o quê. Poucos registros, um por coisa, com descrições. Ex.: cliente, produto, serviço, profissional, forma de pagamento, unidade, canal de origem.

Regras:
1. **Um registro por coisa no cadastro, chave natural única.** Cadastro duplicado (o mesmo cliente duas vezes) multiplica errado todo relatório que o usa. Confira com `count` antes de criar e ofereça juntar duplicados.
2. **O fato carrega o `ref`; o cadastro carrega as descrições.** Nada de nome do serviço digitado no atendimento: `service` como `ref` e o rótulo vem em `service__label`. Exceção: a cópia congelada de preço e nome no momento da venda.
3. **Grão definido**: diga no plano o que é uma linha do fato ("um item vendido", não "um pedido" se o dono quer saber o que mais vende).
4. **Data própria do negócio** em todo fato (`sold_at`, `paid_at`, `happened_at`), porque o servidor não filtra por `created_at`.
5. **Valores somáveis** em `money` ou `number`; situação em `enum`; cada eixo de filtro que o dono citou vira um `ref` ou `enum` no fato.
6. **Nomes estáveis**: os ids dos campos de filtro (`customer`, `service`, `professional`, `payment_method`, `branch`) são a superfície que telas e relatórios usam; não troque depois.

Catálogo para pequenos negócios:

| Ramo | Fato (uma linha =) | Cadastros pelos quais o dono filtra |
|---|---|---|
| Salão, clínica, estúdio | atendimento realizado | cliente, serviço, profissional, forma de pagamento |
| Oficina, assistência | item de OS (peça ou mão de obra) | cliente, veículo ou aparelho, técnico, tipo de serviço |
| Loja, delivery | item vendido | produto, categoria, cliente, canal, forma de pagamento |
| Escola, curso | mensalidade ou presença | aluno, turma, curso, professor |
| Financeiro | lançamento (entrada ou saída) | categoria, conta, fornecedor ou cliente, centro de custo |
| Estoque | movimento (entrada, saída, ajuste) | produto, local, motivo |
| Comercial | negócio (oportunidade) com etapa | cliente, vendedor, origem |

## Calendário

Não é um modelo: é `src/lib/calendar.ts` com `date-fns`, uma vez, usado por todas as telas. Para cada data: dia, semana (início na segunda), mês, trimestre, ano, dia da semana, fim de semana, feriado e dia útil. Feriados nacionais fixos (1/1, 21/4, 1/5, 7/9, 12/10, 2/11, 15/11, 20/11, 25/12) e móveis calculados pela Páscoa (Carnaval segunda e terça, Sexta-feira Santa, Corpus Christi). Feriado municipal ou estadual o dono cadastra, se quiser, num modelo `holiday` (`date`, `name`). Semana e mês sempre no fuso do app; nunca `toISOString().slice(0,10)`.

## Uma definição por número

Todo número que aparece em mais de uma tela (faturamento do mês, ticket médio, clientes ativos, inadimplência) é definido uma vez em `src/lib/metrics.ts`, com o filtro exato e a regra (ex.: "faturamento = soma de `total` dos pedidos com etapa Entregue e `ordered_at` no mês, sem Cancelados"). Telas importam dali; nunca uma segunda versão com regra parecida. O texto da regra aparece num ícone de ajuda ao lado do número.

## Totais pesados

Somar no cliente funciona até alguns milhares de registros (paginando `list` com `fields` só com o que soma). Acima disso, ou quando o painel abre toda hora, crie um modelo de resumo (`monthly_summary` com `month`, `branch`, `revenue`, `orders_count`) atualizado no mesmo código que grava o fato (soma o valor novo ao resumo do mês) ou por uma função de backend (só em plano pago que inclua funções) que o admin aciona com um botão "Recalcular". Resumo é um por chave (mês + unidade): confira com `count` antes de criar. Não existe tarefa agendada que recalcule sozinha; a automação `schedule` só avisa.
