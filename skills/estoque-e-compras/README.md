# Estoque e Compras (`estoque-e-compras`)

## Edição terminal

Esta é a edição para agentes de terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) que constroem o app pelo CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; mudou só o encanamento:
- As etapas do Studio viraram o fluxo do agente: primeiro movimento, a conversa (perguntas com opções), o plano mostrado ao dono antes de codar, a construção, conferir antes de dizer pronto e mudanças depois.
- Schema e automações são editados em `fab.schema.json` e `fab.automations.json` (`fabapp pull`, editar, `fabapp push`); o código sobe com `fabapp deploy`.
- A marca (cor, fonte, raio) é definida pelo agente em `apps/<slug>/fab.config.json → theme`, com aprovação do dono.
- Os critérios de aceite viraram a lista de conferência do plano, sem teto, conferida na pré-visualização e por busca no código.
- O CLI não grava registros: os dados de exemplo vêm de um botão "Carregar exemplos" no app ou do CMS do Studio.
- A memória do app vira `DECISOES.md` na raiz do projeto.
- O contrato da plataforma pelo terminal está em `references/fabapp-cli.md`.

A seção abaixo descreve a edição Studio (etapas e tamanhos são dela).

Faz o app gerado planejar estoque e reposição: movimentações que não se apagam, inventário, velocidade de venda, data estimada de ruptura, ponto de pedido, estoque de segurança, quanto comprar, temporada, parados com o dinheiro empatado, pedido ao fornecedor com mensagem pronta, recebimento que dá entrada e conta a pagar que bate com o pedido, e aviso diário para a tela "Repor agora".

- **Categoria**: commerce
- **Etapas**: briefing, plan, build, edit
- **Tokens** (validador): corpo ~4.100; referências ~6.900 (cabem inteiras também no briefing)
- **Autor**: Equipe Fabapp, versão 1.0.0

## Origem e licenças

| Skill de referência | Repositório | Licença |
|---|---|---|
| `inventory-planner` (com `reference/velocity_and_reorder.md`, `seasonality.md`, `po_drafting.md`, `data_sources.md`, `gotchas.md`) | https://github.com/anthropics/knowledge-work-plugins, plugin small-business, commit da38ec1 | Apache 2.0 |
| `restock` | mesmo repositório | Apache 2.0 |

Obra derivada: texto reescrito em português para a plataforma Fabapp, sem cópia de parágrafos; os arquivos foram modificados (adaptação e tradução), conforme a seção 4 da licença Apache 2.0. Também guiada por `analise/03-crm-e-negocio.md` (template de domain skill §4.1 e §4.2, regras BR §4.3).

## Mapa de cobertura

| Função ou técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Vendas e saldo por Shopify, Square, NetSuite ou planilha | SKILL, construção: Vendas | Venda lançada no app, `CsvImport` de vendas, ou `integrations.call('shopify','listOrders')` por botão. Square e NetSuite não existem na plataforma |
| Campos necessários por item e o que fazer se faltar | `modelo-de-dados.md`; `calculo-de-reposicao.md` Conferências | Cada falta vira linha na tela "Qualidade dos dados" |
| Data da contagem ("contado em") | Conferências (contagem antiga); `counted_at` | Aviso de recontagem para quem vende mais de 1 por dia |
| Prazo perguntado uma vez e lembrado | Conferências (fornecedor sem prazo) | Grava em `supplier.lead_time_days` |
| Várias localizações | Briefing, pergunta 4 | Primeira versão com um estoque; por loja é próximo passo |
| Variações com velocidade própria | Construção: Schema; armadilhas | Cada variação é um item com `group` |
| Excluir cancelados e reembolsados | Construção: Vendas | Na importação do Shopify |
| Kits consomem componentes | Armadilhas | Pergunta no briefing; baixa por kit fica fora da primeira versão |
| Controle parcial de estoque (Square) | `tracks_stock` | Item fora do cálculo |
| Ponto de pedido do ERP como contexto, não verdade | `legacy_min`; Conferências; armadilhas | Mostra o antigo ao lado do calculado |
| Conferências de dados (negativo, sem cadastro, código duplicado, menos de 28 dias, falta de estoque) | Conferências | Tela "Qualidade dos dados" |
| Mapeamento de colunas da planilha mostrado ao dono | Construção: Vendas | Antes de gravar |
| Velocidade de 7 e 28 dias e a tabela de padrões | Cálculo: As duas velocidades | Igual |
| Diferença acima de 50%: olhar os pedidos | Tabela de padrões | Mostra a maior venda e oferece "atacado pontual" (`is_bulk`) |
| Tirar falta de estoque do divisor | Decisão fixa 4; Dias com estoque | Saldo diário reconstruído pelas movimentações |
| Tirar atacado pontual, devoluções no período da venda, promoções | Velocidades; `is_bulk`; `return` com `sold_on`; eventos | Promoção vira evento pontual informado pelo dono |
| Item novo sem velocidade confiável | "Pouco histórico" | Igual |
| Velocidade de ruptura = maior; de compra = 28 dias; nunca o mesmo nome | Decisão fixa 3; Cálculo | Igual, com as duas na linha |
| Cobertura com o que está a caminho | Cobertura | `a_caminho` das linhas de pedido |
| Margem = max(7, prazo/2) com teto de 30 | Cobertura, margem | Igual; também vira estoque de segurança e ponto de pedido em unidades |
| Escada: já vai faltar, pedir agora, em breve (45), tudo certo (45 a 120), demais (120) | Tabela de situação | Igual |
| Velocidade zero sem cobertura; exceção de temporada com data de decisão | Cálculo; `sazonalidade-e-armadilhas.md` Em observação | Automação `relative` em `decide_by` |
| Alvo = (60 + prazo) × v28; descontar saldo e a caminho | Quantidade a comprar | Meta editável em Configurações |
| Arredondar para a embalagem, para baixo se passar de 90 dias | Quantidade a comprar | Igual, dizendo a direção |
| Nunca quantidade negativa; dizer quando não sabe o que está a caminho | Quantidade a comprar | Igual |
| Pedido mínimo é do pedido inteiro; três números e o dono decide | Mínimo do fornecedor | Igual |
| Cada linha mostra a conta (bloco do filtro) | Cada linha mostra a conta | Em português, aberto com um toque |
| Parados: zero em 28 dias, mais de 120 dias, sem movimento em 90; total empatado | Parados | Tela própria com sugestão de liquidar, kit, desconto |
| Temporada só com 400 dias; perguntar sem isso; etiqueta da origem | Sazonalidade | Igual |
| Fator = janela do ano passado ÷ 28 dias antes; teto 3 e piso 0,3; categoria; falta no ano passado | Sazonalidade | Igual |
| Fim de temporada limita o pedido, mostrando os dois números | Fim da temporada | Igual |
| Eventos conhecidos (obra, promoção, aumento, férias do fornecedor) | Eventos conhecidos | Evento pontual na tela Temporadas |
| Lista de compras com total e itens que vão faltar primeiro | Repor agora; aprovação 1 | Topo da tela |
| Duas aprovações: lista e envio | Decisão fixa 9; `compras-e-recebimento.md` | Igual, envio por fornecedor |
| Estrutura do pedido; seguir a numeração do dono | O pedido | `autonumber` com `start` |
| Último preço com data; sem preço, em branco | O pedido | Igual |
| E-mail ao fornecedor no jeito do dono; sem amostra, neutro e dizer | Mensagem ao fornecedor | `invokeLLM` opcional com amostra |
| Perguntar o preço quando está velho | Mensagem ao fornecedor | Mais de 60 dias |
| Substituição e parcial: recalcular, nunca aceitar pelo dono | Substituição | Campos na linha do pedido |
| Registro para a conta bater (ap-processor, conferência de três vias) | Recebimento; A conta bate com o pedido | Feito dentro do app: pedido x recebido x cobrado |
| Codificação da despesa; perguntar em fornecedor novo | `payable.expense_category` | A tela pergunta, nunca chuta |
| Nada é pago aqui | Conta a pagar; "Não fazer" | O app registra a baixa feita fora |
| Sem conector: arquivos e registro que existe | SKILL e compras | Tudo mora no app, com impressão do pedido |
| Ritmo no calendário (oferecer uma vez) | Automação diária; Ritmo | Automação `schedule` + sugestão de dia fixo no `finish`; não cria evento no calendário |
| Saída visual com tabela de ruptura, pílulas de urgência, painel de compra, parados | Plano, tela 1 e 5 | É a própria tela do app |
| Próximos passos (fluxo de caixa, pagar contas) | Briefing: próximos prompts | Sugestões ao dono |
| Não fazer (inventar, falta como procura, repor parado, esquecer a caminho, temporada sem ano, enviar sem aprovação, unidades sem reais) | Não fazer | Igual, mais as regras de movimentação |
| Exemplos resolvidos (oficina do Ray) | Exemplos nos cálculos e na mensagem | Com nomes e valores brasileiros |
| Análise: movimentação só de acréscimo, inventário, papéis, seed, regras BR | Decisões 1; modelo; construção; Regras brasileiras | Papel `stock`; CNPJ alfanumérico; NF-e de 44 dígitos |

## Trocas feitas por limite da plataforma

- **Tarefa agendada que calcula e age**: a automação só avisa (`schedule` diário com link para `/repor`); a conta é feita quando a tela abre.
- **Lembretes com data** (`relative`) disparam também quando o pedido já chegou ou a conta já foi paga (não há condição); os textos dizem "se já chegou" e "se já pagou, desconsidere".
- **Sem soma no servidor**: velocidades e totais são calculados no navegador a partir de movimentações paginadas; `on_hand` é cache recalculável.
- **Calendário recorrente**: não há criação de evento recorrente na plataforma; ficou a automação diária e a sugestão de dia fixo.
