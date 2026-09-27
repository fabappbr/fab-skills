---
name: fab-modelo-de-dados
description: "O app da Fabapp AI construído ou editado pelo terminal (CLI @fabappai/cli) nasce com o modelo de dados certo para o negócio no fab.schema.json: cada cadastro, etapa e relação com o nome que o dono usa (glossário antes das tabelas), ciclos de vida com transições permitidas e quem pode executá-las, histórico do que aconteceu, regras de exclusão e duplicidade, e dados prontos para relatório (fatos separados de cadastros). Use quando o dono pedir sistema, CRM, ERP, controle, gestão, cadastro de clientes, ordem de serviço, pedidos, orçamentos, estoque, financeiro, contas a pagar e receber, funil de vendas, fluxo de aprovação, matrícula, prontuário, locação, filiais ou várias empresas, ou disser 'organizar meus clientes', 'sair da planilha', 'controlar os pedidos', 'saber em que pé está cada serviço', 'cada funcionário vê só o dele', 'quero relatório por mês'. Use também ao mudar campos, status, relações ou permissões de um app que já existe, mesmo que o pedido pareça pequeno."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Modelo de Dados
  edition: terminal
---

# Modelo de dados na linguagem do negócio

O maior risco de um sistema não é técnico: é um modelo que não reflete como o negócio funciona. Esta skill faz o vocabulário do dono virar o modelo (menus, colunas, botões e schema com a mesma palavra), dá a cada registro com status um ciclo de vida explícito e deixa os dados prontos para relatório. Tudo é traduzido para o schema real da Fabapp, o arquivo `fab.schema.json` do projeto. Leia `references/padroes-de-schema.md` e `references/diagramas-e-relatorios.md` antes do plano e aplique as tabelas.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir: o glossário e as decisões de modelo já tomadas estão lá.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Antes de começar: regras que valem do começo ao fim

1. **Uma palavra por conceito, no app inteiro.** Se o dono diz "paciente", é "Paciente" no menu, no título, na coluna, no botão ("Novo paciente"), no aviso e no `name` do modelo. Nunca "cliente" numa tela e "paciente" em outra. Sinônimo solto (cliente, freguês, contato, usuário para a mesma coisa) é defeito.
2. **Nome difícil é modelo errado.** Se um conceito não tem nome claro, ou precisa de "tipo" para mudar de comportamento ("cliente que ainda não comprou"), provavelmente são dois conceitos (Interessado e Cliente). Separe antes de criar campos.
3. **Ids técnicos em inglês, rótulos no idioma do app.** Modelo `{id:"service_order", name:"Ordem de serviço"}`; campo `{id:"due_date", label:"Vencimento", type:"date"}`; opção de enum `{value:"in_progress", label:"Em andamento"}`. Id em `snake_case`, sem acento, nunca muda depois de criado (os dados são guardados pelo id).
4. **Só os tipos que existem:** `text, richtext, number, money, boolean, date, datetime, time, image, file, video, audio, url, email, phone, color, icon, enum, ref, list, geo, json, autonumber`. Não existem select, multiselect, relation, rating, longtext, int, timestamp, índice, unique, campo calculado nem validador customizado. As alternativas estão em `references/padroes-de-schema.md`.
5. **Dinheiro é `money`**, nunca `number` nem texto. Aparece como R$ 1.234,56 via `formatMoney`.
6. **Relação 1:N mora no filho** (`ref` com `to`), nunca array de ids no pai. N:N é um modelo de junção com dois `ref`.
7. **Todo registro com etapas tem máquina de estados**: `enum` com as etapas, transições permitidas, quem executa cada uma e o que cada uma dispara. Sem "status" de texto livre.
8. **Nada de modelo "perfil" ou `app_user`.** Dado extra da pessoa que usa o app vai em `appUser.fields`. Multiempresa usa os modelos canônicos `organization` e `membership`. Ids canônicos de blueprint se escrevem exatamente como a plataforma espera (tabela na referência).
9. **Todo modelo declara `access`** por ação (`read`, `create`, `update`, `delete`). Nunca legível e gravável por todos.
10. **Não invente dados do negócio** (regra de fab-leitura-do-pedido): preço, CNPJ, número de clientes e etapas que o dono não disse viram suposição registrada, não fato.

## A conversa: o que perguntar

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Pergunte só o que muda o modelo. No máximo 4 perguntas desta skill, de uma vez, com as opções abaixo adaptadas ao ramo (troque "pedido" e "cliente" pelas palavras do dono). O resto decida e registre como suposição.

1. **"Quem vai usar o sistema no dia a dia?"** (uma escolha)
   - "Eu e minha equipe, e todos veem tudo (Recomendado)"
   - "Eu e minha equipe, mas cada funcionário vê só o que é dele"
   - "Só eu"
   - "Mais de uma empresa ou filial, cada uma com seus dados separados"
2. **"Por quais etapas um [pedido] passa até terminar?"** (uma escolha, com espaço para o dono escrever a própria) Ofereça as etapas típicas do ramo como opção recomendada. Exemplo para oficina: "Orçamento → Aprovado → Em serviço → Pronto → Entregue (Recomendado)"; "Aberto → Concluído (mais simples)"; "Quero descrever as minhas etapas". Pode cancelar em qualquer etapa? Inclua "Cancelado" na recomendada quando o ramo cancela.
3. **"Como você chama quem compra de você?"** (uma escolha, com espaço para o dono escrever a própria) Só quando o ramo tem mais de um nome comum: "Cliente (Recomendado)", "Paciente", "Aluno", "Associado". Mesma lógica para o registro principal: "Pedido", "Ordem de serviço", "Atendimento".
4. **"O que você quer acompanhar em números?"** (várias escolhas) "Quanto entrou por mês (Recomendado)", "O que mais vende", "Quanto cada funcionário produziu", "Clientes que sumiram", "Nada por enquanto".

Não pergunte sobre tabelas, campos, tipos ou regras de acesso: isso é decisão sua. Com as respostas, anote em `DECISOES.md` (Identidade e Decisões) o glossário (palavra de cada conceito), as etapas do ciclo principal e quem usa; o que você decidiu sozinho vai para as suposições do plano (ex.: "apagar um cliente com pedidos fica bloqueado; ele pode ser arquivado").

## O plano: do glossário ao schema

O plano é um texto que você escreve e mostra ao dono antes de codar; o dono aprova antes da construção. Siga esta ordem. Cada passo vira uma parte da seção "Modelo de dados" do plano.

**1. Glossário do negócio (antes de qualquer tabela).** Liste os substantivos e verbos que o dono usa ("o cliente pede, a gente orça, ele aprova, a gente executa e entrega"). Substantivos viram modelos ou campos; verbos viram transições. Escreva a tabela:

| Conceito | Palavra no app | Id | O que é |
|---|---|---|---|
| quem compra | Cliente | `customer` | pessoa ou empresa atendida |

Desafie ambiguidade: "orçamento" e "pedido" são a mesma coisa em momentos diferentes (um modelo com etapas) ou coisas diferentes (dois modelos)? Se o orçamento pode virar vários pedidos ou morrer sem virar, são dois.

**2. Contextos.** Se a mesma palavra muda de sentido entre áreas (o "cliente" do comercial tem funil; o "cliente" do financeiro tem cobrança), não faça um modelo gigante com os campos de todos. Em app de pequeno negócio isso vira: um modelo por conceito com os campos que o conceito precisa, e as áreas separadas por telas e papéis. Só divida em dois modelos quando os ciclos de vida forem diferentes.

**3. Entidades, valores e agregados.** Teste de entidade: "continua sendo o mesmo se todos os atributos mudarem?" (cliente sim: modelo próprio). Teste de valor: "é definido só pelos atributos?" (endereço, período, valor em dinheiro: campos ou `json` dentro do registro, não modelo). Agregado = uma raiz e o que só existe por ela (pedido e seus itens). Regra que precisa valer sempre dentro do agregado ("total do pedido = soma dos itens") fica no código que grava a raiz. Mantenha agregados pequenos: outro agregado se refere por `ref`, nunca por cópia do registro inteiro.

**4. Subdomínio principal.** Diga em uma frase onde está a vantagem do negócio (ex.: "o orçamento rápido e certo"). É ali que o modelo ganha profundidade (etapas, regras, histórico). Login, pagamento, e-mail e notificação são genéricos: use o que a plataforma já dá, nunca modele do zero.

**5. Modelos e campos.** Uma tabela por modelo: id, rótulo, tipo, obrigatório, observação. Aplique a normalização na medida de `references/padroes-de-schema.md`: nada de lista de valores num texto, nada de dado de outro cadastro repetido (nome do cliente no pedido), exceto a cópia congelada de propósito (preço do item no momento da venda).

**6. Relações.** Escreva como frases com cardinalidade, uma por linha: "Cliente 1 → N Pedido (o pedido guarda `customer`)", "Aluno N ↔ N Turma via Matrícula". Para cada relação, a política ao apagar o pai: bloquear, apagar junto ou deixar vazio (padrão: bloquear).

**7. Ciclo de vida.** Para cada modelo com etapas, a tabela de transições:

| De | Para | Ação (botão) | Quem pode | O que dispara |
|---|---|---|---|---|
| Orçamento | Aprovado | Aprovar | admin, atendente | histórico + aviso ao cliente |

Estados finais (Entregue, Cancelado) não têm saída, salvo "Reabrir" explícito. Evento no passado ("Pedido aprovado") é o nome do que aconteceu e é o que o histórico grava.

**8. Números e relatórios.** Se o dono quer acompanhar algo, separe fatos (o que acontece e se soma: venda, atendimento, lançamento, movimento de estoque) de cadastros (quem e o quê: cliente, serviço, profissional, forma de pagamento, unidade). Aplique `references/diagramas-e-relatorios.md`: todo fato tem data própria do negócio, valor em `money` e `ref` para cada cadastro pelo qual o dono quer filtrar.

**9. Acesso.** Uma linha por modelo com a regra de cada ação e o motivo.

**Diagramas.** O plano é lido no terminal: títulos, listas, negrito e tabelas funcionam; mermaid não vira desenho e o dono leigo não lê bloco de código. Então o diagrama de entidades vai como a lista de relações do passo 6, o de estados como a tabela do passo 7 e o de sequência como passos numerados ("1. Atendente cria o pedido. 2. Cliente aprova pelo link. 3. ..."). Um diagrama por conceito; se passar de 8 modelos, divida por área.

**Lista de conferência.** Escreva como frases conferíveis, todas as que o app usa; "(código)" quando se confere no código, "(tela)" quando se confere na pré-visualização:
- "O schema usa as palavras do glossário: modelos X, Y, Z com os rótulos A, B, C" (código)
- "`[modelo].status` é enum com as opções [lista]; a tela só mostra os botões das transições permitidas a partir da etapa atual" (código)
- "Cada mudança de etapa grava um registro em `[modelo]_event` com etapa anterior, nova, quem fez e quando" (código), quando houver histórico
- "Criar [cadastro] com o mesmo [CPF/e-mail/código] de um existente mostra 'Já existe um cliente com este CPF' e não cria" (código)
- "Apagar [pai] com [filhos] é bloqueado com a explicação e a opção Arquivar" (código)
- "Todo valor em dinheiro aparece como R$ 1.234,56 e toda data como dd/mm/aaaa" (tela)
- "Nenhuma tela chama o mesmo conceito por dois nomes" (tela)

Nas suposições do plano, registre o que você decidiu sem perguntar (política de exclusão, etapas, quem vê o quê), cada uma com impacto e alternativa.

## A construção: o schema e o código que o sustentam

**`fab.schema.json`.** Rode `fabapp pull`, edite o arquivo inteiro (`{"models":[...], "roles":[...], "appUser":{...}, "currency":"BRL", "locale":"pt-BR"}`, com `currency: "BRL"` e `locale: "pt-BR"` para app brasileiro) e envie com `fabapp push` antes de escrever o código que depende dele. Leia a saída: 400 ou 422 trazem o caminho exato; "The platform added" pede outro `pull`. Cada modelo: `id`, `name` (rótulo do glossário), `labelField`, `access` e `fields` com `label`. Siga os modelos de JSON de `references/padroes-de-schema.md`.

- `labelField` aponta para um campo legível (`name`, `title`). Registro sem nome natural (pedido, fatura, OS) ganha `autonumber` com prefixo em português (`{"id":"number","label":"Número","type":"autonumber","start":1,"format":"PED-{0000}"}`) e ele é o `labelField`. Nunca `id`.
- `enum` sempre com `options` `{value,label}`; o valor em inglês, o rótulo em português.
- Galeria é `list` com `of:"image"`; etiquetas soltas são `list` sem `of`.
- `ref` exige `to`. O rótulo do registro apontado chega como `<campo>__label`: use-o nas listas em vez de buscar o pai de novo.

**Máquina de estados em código.** Para cada modelo com etapas, um arquivo `src/lib/<modelo>-flow.ts` é a única fonte da verdade:

```ts
export const ORDER_STATUS = { quote: "Orçamento", approved: "Aprovado", in_progress: "Em serviço", ready: "Pronto", delivered: "Entregue", cancelled: "Cancelado" } as const;
export type OrderStatus = keyof typeof ORDER_STATUS;
export const ORDER_TRANSITIONS: Record<OrderStatus, { to: OrderStatus; action: string; roles: string[] }[]> = {
  quote: [{ to: "approved", action: "Aprovar", roles: ["admin", "attendant"] }, { to: "cancelled", action: "Cancelar", roles: ["admin"] }],
  // ...estados finais com lista vazia
  delivered: [], cancelled: [],
};
```

A tela de detalhe mostra só os botões de `ORDER_TRANSITIONS[atual]` que o papel da pessoa permite; as demais ações não aparecem desabilitadas sem motivo. Os rótulos do enum e dos badges saem desse arquivo. O servidor só confere o `access` do modelo (ele não conhece transições): transição crítica de dinheiro ou aprovação fica restrita também no `access.update` do modelo ao papel certo; quando a regra precisar ser garantida no servidor, use uma função de backend com `auth` `role:<slug>` (só em plano pago que inclua funções) e diga ao dono esse limite.

**O que cada transição dispara.** Automação não tem condição: `{type:"data", event:"updated"}` dispara em toda edição do modelo. Por isso:
- Aviso em toda transição: grave o evento em `<modelo>_event` (tipo, de, para, `description` já escrita pelo código, `ref` para o registro e para a pessoa avisada) e crie a automação `data created` nesse modelo com `body: "{{description}}"`, em `fab.automations.json` (sempre `fabapp pull` antes, porque o `push` substitui o conjunto inteiro):

```json
{ "automations": [
  { "name": "Aviso de etapa do pedido", "trigger": { "type": "data", "model": "order_event", "event": "created" },
    "action": { "type": "notify", "channel": "inapp", "to": "notify_user",
                "title": "Pedido atualizado", "body": "{{description}}" } }
] }
```
- Aviso só em algumas transições: dispare no próprio código da ação (e-mail com `notify`, WhatsApp pela integração ou link `wa.me`, push com `sendPush` quando quem clica é admin) ou numa função de backend com `ctx.sendPush`/`ctx.notify`.
- Prazo (vence amanhã, retorno em 30 dias): campo de data no registro e automação `relative` com `offset_days`.

**Unicidade (não existe unique).** Chave natural (CPF, CNPJ, e-mail, código, placa) é gravada normalizada e conferida com `count` antes de criar, com "Já existe um cliente com este CPF" e link para ele; a importação por planilha faz upsert pela mesma chave (protocolo de fab-dados-seguros). O que é desta skill: a chave normalizada é um campo próprio do schema (`cpf`, `email_norm`, `sku`), declarado no plano, para o filtro do servidor achar.

**Exclusão.** `remove` já é exclusão lógica: o registro some das listas sem precisar de `deleted_at`. Para cada relação, implemente a política escolhida no plano antes de chamar `remove` no pai:
- bloquear (padrão): `count({ customer: id })` > 0 → ConfirmDialog explicando "Este cliente tem 3 pedidos. Arquive em vez de apagar." com a ação Arquivar;
- apagar junto (itens de um pedido): `deleteMany({ order: id })` e depois `remove(id)`;
- deixar vazio (vínculo opcional): `updateWhere({ seller: id }, { seller: null })`.
Quando o dono precisa "tirar da frente sem perder", use `archived` (boolean) ou a etapa final `archived`, com filtro padrão escondendo arquivados.

**Valores derivados (não existe campo calculado).** Calcule na tela quando é barato (idade, dias em atraso, subtotal). Grave no registro quando precisa filtrar ou ordenar por ele (total do pedido, saldo): a função que salva os itens recalcula e grava o total do pai na mesma ação, e esse é o único caminho de escrita desse campo.

**Validação.** Todo formulário tem schema `zod` com as mesmas regras do modelo (obrigatórios, formato de CPF/CNPJ com dígito verificador, e-mail, período com `refine` "fim depois do início"). O servidor devolve 422 para tipo errado ou obrigatório faltando: mostre `e.message` junto do campo.

**Datas do negócio.** O servidor ordena por `created_at` mas não filtra por ele. Todo registro que será filtrado por período tem um campo próprio (`sold_at`, `due_date`, `scheduled_at`), preenchido pelo formulário ou pelo código na criação. Filtre e ordene no servidor (`filter`, `sort`, `limit`, `offset`); some no cliente só o que precisa somar (não há soma no servidor).

**Consultas e criação com nome do negócio.** Em `src/lib/<modelo>.ts`, junte o acesso a dados em funções com nomes do glossário, usadas por todas as telas: `listOverdueInvoices(page)`, `listTodayBookings()`, e não `getByStatus(3)` espalhado. Filtros que se repetem viram constantes nomeadas (`const OVERDUE = { status: "open", due_date: { lt: hoje } }`) combinadas por objeto. Criação de raiz com regra (pedido a partir de orçamento, matrícula) é uma função só (`createOrderFromQuote`) que valida tudo e falha com mensagem clara em vez de criar registro pela metade. Dados que chegam de fora (integração, planilha, resposta de IA) são traduzidos ali para os campos do glossário antes de gravar.

**Dado sensível.** Senha, número de cartão e token nunca viram campo. CPF, dados de saúde e financeiros ficam em modelos com `read` restrito ao papel que precisa; nada disso aparece em modelo `public`.

**Quem é dono do registro.** Para "cada funcionário vê só o dele", o modelo tem um `ref` para a pessoa (`assigned_to`) e `access.read` `{"any":["role:admin",{"owner_field":"assigned_to"}]}`. Filtro "Meus" usa `created_by` ou o campo de posse. Para multiempresa, siga o modelo `organization` + `membership` da referência e carimbe `organization` e `members` em todo registro compartilhado.

## Mudanças depois: mudar o modelo sem perder dados

Comece por `fabapp pull` e leia o `fab.schema.json` atual e `DECISOES.md`.

- **Renomear é mudar o rótulo, nunca o id.** "Chame cliente de paciente": troque `name` do modelo, `label` dos campos e todos os textos das telas (grep pela palavra antiga), mantenha `id: "customer"`. Mudar id deixa os dados antigos órfãos.
- **Nova etapa** = nova opção no enum + linhas novas em `<modelo>-flow.ts` + botões. Etapa removida: mantenha a opção enquanto houver registros nela e ofereça migrar com `updateWhere`.
- **Conceito que se partiu** ("tem cliente que só pediu orçamento"): proponha o modelo novo e diga ao dono o que acontece com os registros existentes; o CLI não grava registros, então mover dados é do dono: pelo CMS do Studio (editar ou importar planilha) ou por uma tela de administração do próprio app, usada por ele logado como admin. Nunca mova nem diga que moveu em silêncio.
- **Campo que virou lista de valores** (tags num texto) ou **dado repetido** que diverge: normalize para `list`, `enum` ou `ref` e explique a migração ao dono.
- Toda decisão de modelo que o dono tomou (palavra escolhida, política de exclusão, quem vê o quê) vai para `DECISOES.md` (seção Decisões), para a próxima sessão não desfazer.

## Conferir antes de dizer pronto: diagnóstico (0 a 10)

Vale no plano, na construção e nas mudanças. Some 1 ponto por item atendido e relate na mensagem final só o que conferiu:

1. Um leigo do ramo lê os nomes de modelos, campos, etapas e botões e reconhece o negócio.
2. Cada conceito tem uma palavra só em todas as telas e no schema.
3. Agregados pequenos: filhos com `ref` no filho, nenhum array de ids no pai, nenhum dado de outro cadastro copiado sem motivo.
4. Todo modelo com etapas tem enum, `-flow.ts` com transições e papéis, e a tela respeita isso.
5. Mudanças importantes deixam rastro (`<modelo>_event` ou campos de data da etapa).
6. Duplicidade conferida com `count` nas chaves naturais; exclusão com política definida por relação.
7. Todo modelo tem `access` explícito por ação e nenhum é público para escrita e leitura ao mesmo tempo.
8. Fatos têm data própria, `money` e `ref` para os cadastros de filtro.
9. Nada de tipo inexistente, modelo perfil, `app_user` ou id canônico escrito diferente.
10. O plano (ou a mudança) registrou nas suposições ou em `DECISOES.md` as decisões tomadas sem perguntar.

Nota 9 ou 10: modelo pronto. 5 ou 6: há vocabulário técnico ou fronteiras vazando, corrija antes de dizer pronto. 3 ou menos: refaça a partir do glossário.

Na prática: `fabapp push` sem erro, `grep` pela palavra antiga de cada conceito renomeado (nenhuma tela com dois nomes), e na pré-visualização do `fabapp dev` crie um registro de teste, passe-o por cada transição, confira o histórico e o aviso, e apague o teste. O CLI não semeia dados: diga ao dono o que ele cadastra ou importa no CMS do Studio para começar.
