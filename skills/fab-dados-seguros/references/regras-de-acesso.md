# Regras de acesso, diagnóstico, concorrência e modelagem

## 1. Os padrões em detalhe

Gramática de regra: `public`, `authenticated`, `owner` (quem criou), `role:<slug>`, `perm:<x>`, `plan:<tier>`, `{"owner_field":"campo"}` (o campo guarda o id de um usuário), `{"owner_in":"lista"}` (o id está na lista), `{"owner_via":"ref"}` (dono do registro pai, um salto), `{"any":[...]}` (ou), `{"all":[...]}` (e). Admin e dono do app passam em tudo.

**Dono único.** Cada usuário só com o que é dele. `read:"owner"` usa quem criou; prefira `owner_field` quando o registro pode ser criado por outra pessoa em nome do dono.

```json
{"id":"workout_log","access":{"read":"owner","create":"authenticated","update":"owner","delete":"owner"}}
```

**Cliente + equipe.** O cliente vê e cria só o que é dele; a equipe vê tudo e altera; só o admin apaga.

```json
{"id":"booking","fields":[{"id":"customer","type":"ref","to":"app_user","required":true}, "..."],
 "access":{"read":{"any":["role:staff",{"owner_field":"customer"}]},
           "create":{"any":["role:staff",{"owner_field":"customer"}]},
           "update":"role:staff","delete":"role:admin"}}
```

Se o cliente também pode cancelar o próprio agendamento, a mudança de status do cliente passa por uma função que confere dono e estado (exemplo no SKILL.md), em vez de dar `update` ao cliente, que poderia alterar data, preço e status à vontade.

**Equipe atende só o que é dela.** Campo `assigned_to` (ref `app_user`) e `read: {"any":["role:manager",{"owner_field":"assigned_to"}, {"owner_field":"customer"}]}`. O gerente vê tudo, cada atendente vê o que recebeu.

**Só a equipe (dado interno).** Clientes do CRM, estoque, contas a pagar: nenhum usuário comum lê. Em app só da equipe (sem cliente logando), dê a todos os funcionários o papel `staff` e use `role:staff`, nunca `authenticated`, porque cadastro aberto transforma `authenticated` em qualquer pessoa.

**Membros de um espaço (empresa, família, casal, turma).** Os modelos canônicos `organization` e `membership` com `<OrgSwitcher/>`, `<Members/>` ou `<PairingGate/>`. Cada modelo compartilhado ganha `organization` (ref) e `members` (lista de ids), acesso `owner_in:"members"`, e o código carimba na criação `organization: org.id, members: org.members` (de `useSpace()`). Cuidado: quando alguém entra ou sai do espaço, os registros antigos continuam com a lista velha. A tela de membros, ao adicionar ou remover, atualiza os registros do espaço (`updateWhere({ organization: org.id }, { members: novaLista })` em cada modelo compartilhado, feito pelo admin, com entrada no `audit_log`). Quem sai perde o acesso só depois disso.

**Público lê, admin escreve.** Vitrine, cardápio, blog, depoimento, plano de preços. Filhos que a tela pública mostra (fotos, horários, variações) também `read:"public"`.

**Formulário de visitante.** `{"read":"role:admin","create":"public","update":"role:admin","delete":"role:admin"}`. O visitante não tem identidade: a plataforma descarta qualquer campo de dono que ele mande. Valide com `zod`, limite o tamanho dos textos e não deixe o visitante escolher campos internos (status, responsável). Nunca `create:"authenticated"` num formulário de site: o botão principal responde 403 a todo visitante.

**Filho via pai.** `cart_item → cart`, `order_item → order`, `message → conversation`, `photo → listing`: `{"owner_via":"cart"}`. A plataforma confere que o pai é seu ao criar o filho. Um salto só, e o pai precisa ter dono próprio (`owner`, `owner_field` ou `owner_in`). Nunca repita a regra do pai no filho com caminho de ponto.

**Conteúdo pago.** `read:"plan:premium"` no modelo do conteúdo (`lesson_content`, arquivos, receitas exclusivas). `RequirePlan` e `SubscribeGate` são só tela; a proteção é a regra.

**Atribuição (quem cria não é o dono).** O personal cria o treino do aluno: `read` com `owner_field:"student"`, mas `create`/`update` com `role:trainer`. Sob regra de dono, o usuário comum tem o campo de dono forçado para o próprio id, e o personal não conseguiria atribuir.

**Perfil do usuário final.** Dado extra da pessoa vai em `appUser.fields` e `updateProfile`. Nunca um modelo "perfil" espelho, nunca `collection("app_user")`. Como a própria pessoa edita esses campos, nenhum deles decide permissão.

**Modelo de resumo.** Totais prontos gravados por função (vendas por mês, ranking de vendedores) recebem a regra de quem pode ver o número: faturamento é `role:admin`, não `authenticated`.

## 2. Autenticação não é autorização (IDOR)

```json
// Errado: qualquer usuário logado lê e altera o pedido de qualquer outro trocando o id na URL
{"id":"order","access":{"read":"authenticated","create":"authenticated","update":"authenticated","delete":"authenticated"}}

// Certo
{"id":"order","access":{"read":{"any":["role:staff",{"owner_field":"buyer"}]},
                        "create":{"any":["role:staff",{"owner_field":"buyer"}]},
                        "update":"role:staff","delete":"role:admin"}}
```

```tsx
// Errado: "protege" filtrando na tela; a API entrega todos os pedidos a qualquer logado
const pedidos = await collection<Pedido>("order").list({ filter: { buyer: user.id } });

// Certo: a regra do modelo restringe; o filtro só organiza a tela
const pedidos = await collection<Pedido>("order").list({ sort: "-created_at", limit: 20 });
```

Regra de texto único (`"access":"authenticated"`) vale só para leitura; as escritas caem no padrão fechado. Regra de dono sozinha como acesso inteiro (`"access":{"owner_field":"owner_id"}`) vale para TODAS as ações, inclusive leitura: numa vitrine, ninguém além do dono vê. Divida por ação.

## 3. Armadilhas silenciosas

| Armadilha | O que acontece, sem erro | Certo |
|---|---|---|
| `authenticated` em dado de cliente com cadastro aberto | qualquer pessoa cria conta e lê tudo | `owner_field`, `role:` ou `owner_in` |
| `update`/`delete: "authenticated"` | um usuário altera ou apaga o registro de outro | dono ou papel |
| Caminho com ponto (`"venue.owner_id"`) | casa com ninguém; só o admin vê | `owner_via` no filho |
| `owner_field` apontando para ref de outro modelo | casa com ninguém; criar dá 403 | `owner_via`, ou ref para `app_user` |
| `read:"public"` esquecido em modelo de tela pública | vitrine vazia para visitante | `read:"public"` explícito |
| `read:"public"` por engano em dado pessoal | lista de clientes aberta para a internet | revise cada `public` |
| `ctx.collection` em função | ignora todas as regras | a função confere `ctx.user` e o registro |
| Função `public` que grava | endpoint aberto para qualquer um | `user`/`role:` no manifesto; `public` só para um lead validado |
| `ctx.sendPush` ou agente dentro de função aberta | qualquer visitante notifica todo mundo ou roda IA com privilégio | função `role:admin`, entrada validada |
| Campo de `appUser.fields` ou do registro decidindo permissão | a pessoa se promove sozinha | papel atribuído pelo admin |
| Permissão guardada no `localStorage` (`isAdmin`) | editável no navegador | ler de `useAuth()`; o servidor decide |
| Chave ou segredo no código | vai para o navegador de todo visitante | integração no Studio |
| Arquivo sensível com `visibility:"public"` | qualquer um com o link abre | `private` |
| `updateMany`/`updateWhere` com registros que a pessoa não pode alterar | pula esses registros; `updated` menor que o esperado | compare e avise quantos ficaram de fora |
| Afrouxar a regra para sumir um 403 | o erro some e o dado vaza | diagnóstico abaixo |
| `create:"authenticated"` sem campo de dono na regra | o id do cliente vem do corpo e não é conferido | `owner_field` também no `create` |
| Item de checkout com `amount` e sem referência | cobra o valor que o navegador mandou | sempre `product_id`, `model_id`+`record_id` ou `price_id` |

## 4. Diagnóstico: 403, 401, 422 e lista vazia

Siga na ordem. Mude uma coisa por vez e confira.

| Sintoma | Causa provável | Correção |
|---|---|---|
| Lista vazia para visitante, cheia para o admin | modelo sem `read:"public"` | `read:"public"` se a tela é pública de propósito |
| Lista vazia para o usuário, cheia para o admin | `owner_field` com ponto, apontando para ref de outro modelo, ou campo de dono vazio nos registros | corrija o campo; registros antigos sem dono: o dono preenche no CMS do Studio (ou por uma tela de admin do app); você não grava registros pelo CLI |
| Filho some (itens do pedido, mensagens) | filho sem `owner_via`, ou `owner_via` com dois saltos, ou filho criado sem o ref do pai | `owner_via` para o pai com dono próprio; ref obrigatório |
| 403 ao criar | regra de criação exige papel que a pessoa não tem; ou dono preenchido com id de outro | atribua o papel certo; deixe a plataforma carimbar o dono |
| 403 no formulário do site | modelo com `create:"authenticated"` | `create:"public"` com leitura do admin |
| 403 ao alterar | a pessoa não é dona nem tem o papel; ou tentou trocar o campo de dono | função com checagem, ou papel |
| 401 | sessão ausente ou vencida | tela de login; chamada feita antes do login terminar |
| 422 | campo desconhecido, obrigatório faltando ou tipo errado | confira o schema; valide com `zod` antes |
| 402 | sem crédito (IA) ou limite do plano | avise o dono; não é regra de acesso |
| 409 | conflito devolvido por função (já reivindicado, já cancelado) | mostre a mensagem `e.message` |
| `updated` ou `deleted` menor que o esperado | parte dos registros fora da regra de alteração | informe quantos; não abra a regra |
| Funcionou para o admin e mais ninguém | admin passa em tudo: o teste com admin não prova a regra | raciocine com um usuário comum e um visitante |

Depois de 2 ou 3 correções sem resolver, pare, releia o `access` inteiro do modelo e do pai, consulte `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) e explique ao dono em uma frase o que está travando.

## 5. Concorrência e integridade sem transação

A plataforma não tem transação entre chamadas nem restrição de unicidade. Estes padrões evitam os erros típicos:

- **Saldo por lançamentos, não por sobrescrita.** Estoque, pontos, saldo de pacote: duas vendas ao mesmo tempo que leem "10" e gravam "9" perdem uma baixa. Grave cada movimento num modelo próprio (`stock_movement` com `product`, `quantity` positiva ou negativa, `reason`, `created_at`) e calcule o saldo somando os movimentos (ou num modelo de resumo atualizado por função). Movimento nunca é editado: correção é outro movimento.
- **Reivindicar com atualização condicional.** Para "pegar" uma tarefa, vaga ou pedido sem dois pegarem o mesmo, atualize filtrando pelo estado esperado e confira quantos mudaram:

```ts
// `code` é o campo autonumber do chamado (único, emitido pela plataforma); o filtro não aceita `id`
const { updated } = await collection("ticket").updateWhere({ code: chamado.code, status: "open" }, { status: "claimed", assigned_to: user.id });
if (updated === 0) { toast.error("Outra pessoa já pegou este chamado."); return; }
const atual = await collection<Chamado>("ticket").get(chamado.id);          // confirma quem ficou com ele
if (atual.assigned_to !== user.id) toast.error("Outra pessoa já pegou este chamado.");
```

Para disputa que não pode falhar nunca (última vaga paga, estoque de item único), a reivindicação vai numa função, que relê o registro antes de gravar e devolve 409 quando perdeu.

- **Lote tudo ou nada.** `bulkCreate` grava até 200 de uma vez ou nenhum. Crie os pais primeiro; só crie os filhos se o lote dos pais deu certo.
- **Unicidade.** `count({ chave: valorNormalizado })` antes do `create`, com a mesma normalização do cadastro. Ainda pode haver corrida rara (dois cadastros no mesmo segundo): a tela "Mesclar duplicados" resolve depois.
- **Ação curta.** Chamada externa (pagamento, IA) acontece antes de gravar o estado final; nunca deixe um registro "em processamento" esperando a resposta de outro serviço sem prazo. Se ficou preso, a tela mostra e permite tentar de novo.

## 6. Modelagem que protege a integridade

| Dado | Tipo certo | Errado comum |
|---|---|---|
| Dinheiro | `money` | `text` ou `number` sem regra; soma direta de decimais (0,1 + 0,2). Some em centavos: `Math.round(v * 100)` e divida no fim |
| Data sem hora (vencimento) | `date` | `datetime` (vira o dia anterior no fuso do Brasil) |
| Momento | `datetime` | texto "10/09 às 14h" |
| Sim ou não | `boolean` | texto "sim"/"não" |
| Situação | `enum` com `options` | texto livre (cada um escreve de um jeito) |
| Telefone, e-mail | `phone`, `email` | `text` |
| Código legível (pedido, OS) | `autonumber` com `format` (`PED-{0000}`) como `labelField` | usar o id como rótulo |
| Relação | `ref` no filho, com `required` | lista de ids no pai |
| Dado que você filtra | campo próprio | escondido dentro de `json` (não dá para filtrar) |

- Ids de modelo e campo em inglês, minúsculos, com `_` (`order_item`, `created_at`); o texto visível em português.
- Validação que o servidor não faz (formato de CPF, faixa de valor, data no futuro) é feita com `zod` em todo formulário; o servidor só confere tipo, obrigatório e campo conhecido.
- Campo derivado (total do pedido, idade, saldo) não aparece como campo editável: é calculado na tela ou gravado por função.
- Não copie o mesmo dado em dois lugares (nome do cliente no pedido); use o `__label` do ref. Cópia só quando o valor deve congelar no tempo (preço do item no momento da venda), e aí com nome que diz isso (`unit_price_at_sale`).

## 7. Consultas que não vazam nem truncam

- Filtro, ordem e paginação no servidor. Total por `count`, nunca pelo tamanho da página.
- **Contagem por situação sem baixar tudo:** um `count` por opção do `enum`, em paralelo.

```ts
const opcoes = ["pending", "paid", "fulfilled"] as const;
const totais = await Promise.all(opcoes.map(s => collection("order").count({ status: s })));
```

- **Somar exige percorrer todas as páginas.** Uma página cheia (exatamente o `limit`) quase sempre significa que há mais: continue até vir uma página menor, e confira com o `count`. Para painel pesado, modelo de resumo atualizado por função.
- **Paginação por cursor** em lista longa ou rolagem infinita: filtre por um campo de data PRÓPRIO do modelo, preenchido na criação (`sent_at`, `occurred_at`), porque `created_at` e `updated_at` só servem para ordenar e dão 422 no filtro: `list({ filter: { sent_at: { lt: ultimoVisto } }, sort: "-sent_at", limit: 20 })`. Não pula nem repete registro quando entram novos. O mesmo vale para "pedidos do mês": campo de data próprio.
- **Sem uma chamada por item:** filhos pelo `ref` do pai (`filter: { order: id }`), nome do ligado pelo `__label`, vários valores de um campo do schema com `in` em blocos de até 200. O filtro não aceita `id`: para vários registros por id, carregue a lista uma vez e indexe num `Map`, ou `get` em paralelo.
- **Projeção:** `fields: [...]` só com as colunas que a tela usa, principalmente em lista pública (não mande CPF e telefone para a vitrine).
- **Busca:** `contains` com debounce de ~300ms. Não é busca por relevância; para catálogo grande, ofereça filtros por campo.

## 8. Privilégio mínimo

- Cada papel com só as permissões do trabalho (`perm:estoque.ajustar`, `perm:financeiro.ver`). Funcionário que registra venda não é `admin`.
- Permissões da plataforma para gerir usuários: `users.read`, `users.invite`, `users.roles`, `users.plan`. Só quem administra a equipe recebe `users.roles`.
- Ao desligar alguém: tire o papel, remova da lista de membros dos registros compartilhados e confira no `audit_log` o que a pessoa fez por último.
- App com dado de saúde, financeiro ou documento: ofereça `<TwoFactor/>` para as contas da equipe.
- Dependência nova entra com `npm install <pacote>` dentro de `.fabapp/workspace`, com versão definida no `package.json` (`^1.4.0`), nunca `"*"` ou `"latest"`, e só pacote conhecido.
