# Padrões de schema da Fabapp

## Dado do negócio → tipo de campo

| Dado | Tipo | Observação |
|---|---|---|
| Nome, código, placa, CPF/CNPJ (normalizado) | `text` | chave natural: grave só dígitos e confira duplicidade com `count` |
| Descrição longa com formatação | `richtext` | |
| Quantidade, nota de 1 a 5, duração em minutos | `number` | nota é `number`, não existe rating |
| Preço, total, saldo, parcela | `money` | nunca `number`; moeda do app em `currency` |
| Sim/não, ativo, pago, arquivado | `boolean` | |
| Data sem hora (vencimento, nascimento) | `date` | com `<DatePicker>`; nunca cortar `toISOString()` |
| Momento exato (agendado para, entregue em) | `datetime` | |
| Horário de abertura | `time` | |
| Foto única / galeria | `image` / `list` com `of:"image"` | |
| Contrato, nota fiscal em PDF | `file` | nota fiscal: o app guarda número, chave e PDF; não emite |
| Site, link | `url` | |
| E-mail / telefone | `email` / `phone` | telefone em E.164 com `PhoneInput` |
| Situação, categoria fixa, forma de pagamento fixa | `enum` com `options` `{value,label}` | não existe select |
| Várias etiquetas livres | `list` sem `of` | não existe multiselect |
| Aponta para outro cadastro | `ref` com `to` | um id só, sempre no filho |
| Endereço com mapa | `geo` com `AddressInput` | sem mapa: campos `text` (rua, número, bairro, cidade, UF, CEP) |
| Pequena estrutura que só se lê junto do pai | `json` | ex.: horários da semana, respostas de um questionário |
| Número humano sequencial (pedido, OS, fatura) | `autonumber` com `start` e `format` `PED-{0000}` | gerado pela plataforma; não escrever pelo app |

## O que não existe e a alternativa real

| A original pediria | Na Fabapp |
|---|---|
| UNIQUE | normalizar a chave e `count({chave})` antes de criar; mensagem no campo |
| CHECK, validador | `zod` no formulário (faixa, formato, dígito verificador, `refine` entre campos) |
| NOT NULL | `required: true` (o servidor devolve 422 se faltar) |
| DEFAULT | valor inicial no formulário ou no código que cria (ex.: `status: "quote"`) |
| Coluna calculada | calcular na tela, ou gravar pelo código no único caminho de escrita |
| FOREIGN KEY com ON DELETE | `ref` + política no código (bloquear, apagar junto, deixar vazio) |
| Índice para filtro e ordem | não precisa: filtro, ordem e paginação já rodam no servidor |
| `created_at` | já vem em todo registro (ordena, não filtra) |
| `updated_at`, "alterado por" | não exposto; se o dono precisa ver, grave no histórico `<modelo>_event` |
| `deleted_at` | `remove()` já é exclusão lógica |
| Migração de schema | não há: o schema é mesclado por id; nunca troque id, só rótulo |
| Tabela de câmbio | `money` na moeda do app e `formatMoney` |
| Agregação no banco (SUM, GROUP BY) | só `count()`; somar no cliente a partir de `list` paginado, ou modelo de resumo |

## Normalização na medida

| Forma | Regra | Violação típica | Correção |
|---|---|---|---|
| 1FN | um valor por campo | "produtos: bolo, torta" num texto | modelo `order_item` com `ref` para `order` |
| 2FN | nada que dependa só de parte da identidade | nome do cliente dentro de cada item | o item aponta para o pedido; o pedido aponta para o cliente |
| 3FN | nada que dependa de outro campo que não a identidade | "cidade" e "UF" repetidos em cada pedido | ficam no cliente; o pedido guarda só `customer` |

Desnormalize de propósito, e escreva o motivo no plano (e em `DECISOES.md`), só em três casos:
- **Cópia congelada**: preço unitário, desconto e nome do produto no `order_item` no momento da venda (o preço do catálogo muda; a venda não).
- **Total gravado**: `order.total`, `account.balance`, recalculados pelo mesmo código que grava os itens, para filtrar e ordenar.
- **Resumo**: modelo `monthly_summary` quando o painel precisaria somar milhares de registros.

## Guardar junto (json) ou separado (modelo)

| Pergunta | Junto no pai (`json`/`list`) | Modelo filho com `ref` |
|---|---|---|
| Aparece sempre com o pai? | sim | nem sempre |
| Precisa filtrar, somar ou listar sozinho? | não | sim |
| Quantos por pai? | poucos (até ~20) | muitos |
| Muda separado do pai? | raramente | com frequência |
| Precisa de permissão própria? | não | sim |

## Entidade, valor, agregado

- **Entidade**: tem identidade que sobrevive às mudanças (cliente, pedido, veículo). Vira modelo.
- **Valor**: definido pelos atributos, trocado inteiro, nunca editado aos pedaços (endereço, período, dinheiro, telefone). Vira campos ou `json` no registro; se o dono precisa de vários endereços por cliente e escolher um por pedido, aí vira modelo `address`.
- **Agregado**: uma raiz e o que só existe por ela. Tudo passa pela raiz: itens se criam e apagam pela tela do pedido, e o total é recalculado ali. Entre agregados, só `ref`. Regra que cruza dois agregados ("não deixar dois agendamentos no mesmo horário do mesmo profissional") é conferida com `count` antes de gravar, não guardada como vínculo.
- Na dúvida entre entidade e valor, comece como valor. Transformar valor em modelo depois é fácil; o contrário, não.

## Modelos de JSON

Cadastro com chave natural, só da equipe (papel `staff` declarado em `roles`; nunca `authenticated` em dado de cliente, porque cadastro aberto torna qualquer pessoa "autenticada"):

```json
{"id":"customer","name":"Cliente","labelField":"name",
 "access":{"read":"role:staff","create":"role:staff","update":"role:staff","delete":"role:admin"},
 "fields":[
  {"id":"name","label":"Nome","type":"text","required":true},
  {"id":"person_type","label":"Tipo","type":"enum","options":[{"value":"individual","label":"Pessoa física"},{"value":"company","label":"Pessoa jurídica"}]},
  {"id":"document","label":"CPF ou CNPJ","type":"text"},
  {"id":"phone","label":"WhatsApp","type":"phone"},
  {"id":"email","label":"E-mail","type":"email"},
  {"id":"archived","label":"Arquivado","type":"boolean"}]}
```

Raiz com etapas, número humano e filhos:

```json
{"id":"order","name":"Pedido","labelField":"number","fields":[
  {"id":"number","label":"Número","type":"autonumber","start":1,"format":"PED-{0000}"},
  {"id":"customer","label":"Cliente","type":"ref","to":"customer","required":true},
  {"id":"status","label":"Etapa","type":"enum","required":true,"options":[
    {"value":"quote","label":"Orçamento"},{"value":"approved","label":"Aprovado"},
    {"value":"ready","label":"Pronto"},{"value":"delivered","label":"Entregue"},{"value":"cancelled","label":"Cancelado"}]},
  {"id":"ordered_at","label":"Data do pedido","type":"date","required":true},
  {"id":"total","label":"Total","type":"money"}]}
{"id":"order_item","name":"Item do pedido","labelField":"product_name","fields":[
  {"id":"order","label":"Pedido","type":"ref","to":"order","required":true},
  {"id":"product","label":"Produto","type":"ref","to":"product"},
  {"id":"product_name","label":"Produto","type":"text","required":true},
  {"id":"quantity","label":"Quantidade","type":"number","required":true},
  {"id":"unit_price","label":"Preço unitário","type":"money","required":true}]}
```
Se o app vende pelo checkout da plataforma, o `order` é o canônico de pagamentos: comprador em `buyer` (ref `app_user`), `total` e `status` com `pending`, `paid`, `failed`, `refunded`, `fulfilled` (a plataforma grava `paid` ao confirmar).

Junção N:N com dado próprio (a matrícula tem data e situação):

```json
{"id":"enrollment","name":"Matrícula","labelField":"code","fields":[
  {"id":"code","label":"Código","type":"autonumber","format":"MAT-{0000}"},
  {"id":"student","label":"Aluno","type":"ref","to":"student","required":true},
  {"id":"class_group","label":"Turma","type":"ref","to":"class_group","required":true},
  {"id":"enrolled_on","label":"Data da matrícula","type":"date","required":true}]}
```
Antes de criar, `count({student, class_group})` impede a mesma matrícula duas vezes.

Auto-referência (categoria dentro de categoria): `{"id":"parent","label":"Categoria mãe","type":"ref","to":"category"}`. Hierarquia de no máximo 3 níveis.

Vínculo com um de dois tipos (comentário em pedido ou em cliente): dois `ref` opcionais (`order`, `customer`) e `zod` exigindo exatamente um. Evite "tipo + id em texto": perde o `__label` e a integridade.

Histórico de transições (fato imutável, só criado):

```json
{"id":"order_event","name":"Histórico do pedido","labelField":"description",
 "access":{"read":"role:staff","create":"role:staff","update":"role:admin","delete":"role:admin"},
 "fields":[
  {"id":"order","label":"Pedido","type":"ref","to":"order","required":true},
  {"id":"event_type","label":"O que aconteceu","type":"enum","options":[{"value":"approved","label":"Pedido aprovado"},{"value":"cancelled","label":"Pedido cancelado"}]},
  {"id":"from_status","label":"De","type":"text"},{"id":"to_status","label":"Para","type":"text"},
  {"id":"description","label":"Descrição","type":"text","required":true},
  {"id":"notify_user","label":"Avisar","type":"ref","to":"app_user"},
  {"id":"happened_at","label":"Quando","type":"datetime","required":true}]}
```
`to:"app_user"` é só o alvo do `ref` para a pessoa; nunca `collection('app_user')`. Quem fez vem em `created_by`.

Pessoa que usa o app (sem modelo perfil):

```json
{"appUser":{"fields":[{"id":"job_title","label":"Cargo","type":"text"},{"id":"unit","label":"Unidade","type":"ref","to":"branch"}]},
 "roles":[{"slug":"staff","name":"Equipe","description":"Vê e edita os cadastros do dia a dia","permissions":[]},
          {"slug":"attendant","name":"Atendente","description":"Abre e acompanha pedidos","permissions":[]}]}
```
Grave com `updateProfile`. Papéis `owner`, `admin` e `member` já existem.

Multiempresa: declare `organization` (`name`, `logo`, `owner` ref, `members` lista de ids, `code` texto do convite) e `membership` (`organization` ref, `user` ref, `email`, `role` enum owner/admin/editor/viewer, `status` enum active/pending/inactive, `org_owner` ref, `members` lista). A plataforma completa os campos que faltarem nesses dois modelos. Use `<OrgSwitcher/>`, `<Members/>` e `useSpace()`. Cada modelo compartilhado ganha `organization` (ref) e `members` (list) com `access` `{"owner_in":"members"}`, e o código carimba `organization: org.id, members: org.members` ao criar.

## Receitas de acesso

| Situação | `access` |
|---|---|
| Catálogo público, só a equipe edita | `{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}` |
| Formulário de visitante (contato, orçamento) | `{"read":"role:admin","create":"public","update":"role:admin","delete":"role:admin"}` |
| Equipe inteira vê e edita, só admin apaga | `{"read":"role:staff","create":"role:staff","update":"role:staff","delete":"role:admin"}` (papel declarado em `roles`; `authenticated` aqui deixaria qualquer conta nova editar tudo) |
| Cada funcionário vê o que é dele | `{"read":{"any":["role:admin",{"owner_field":"assigned_to"}]},"create":"authenticated","update":{"any":["role:admin",{"owner_field":"assigned_to"}]},"delete":"role:admin"}` |
| Filho herda a posse do pai (item do pedido do cliente) | `{"read":{"any":["role:admin",{"owner_via":"order"}]}, ...}` (um salto só) |
| Vários donos por registro | `{"owner_in":"members"}` |

Sem `access`: ler e criar exigem login; alterar e apagar só o dono. Uma string sozinha define só a leitura. Caminho com ponto em regra de dono não casa ninguém. Regra errada falha fechada (ninguém vê): se "ninguém vê os próprios registros", confira a regra primeiro.

## Ids canônicos (escreva exatamente assim)

| Recurso | Modelos |
|---|---|
| Chat | `conversation`, `message` |
| Agendamento | `service`, `availability`, `booking` |
| Feed | `post`, `comment`, `like`, `follow` |
| Avaliações | `review` |
| Pagamentos | `plan`, `subscription`, `product`, `order` |
| Curso | `course`, `module`, `lesson`, `lesson_content`, `lesson_progress` |
| Multiempresa e pareamento | `organization`, `membership` |

A notificação interna usa o modelo `notification` da plataforma: não declare.

## Erros comuns

| Erro | Por que falha | Correção |
|---|---|---|
| Nomes técnicos (`record`, `item_data`, `status_code`) | o dono não reconhece nem corrige | palavra do glossário |
| Um modelo para tudo (`customer` com 40 campos de comercial, entrega e cobrança) | inchado e contraditório | campos que o conceito precisa; áreas por tela e papel |
| Agregado gigante (empresa com setores com funcionários com tarefas) | telas lentas, edições que se atropelam | cada entidade com ciclo próprio vira modelo com `ref` |
| Modelo anêmico (regras espalhadas em cada tela) | a regra diverge entre telas | regra num arquivo `src/lib/<modelo>-*.ts` usado por todas |
| Dado externo entrando cru (resposta de integração salva como veio) | o vocabulário alheio contamina o app | traduzir na função ou no `src/lib` para os campos do glossário |
| Status em texto livre | "pronto", "Pronto", "finalizado" | `enum` + `-flow.ts` |
| `number` para dinheiro, texto para data | soma errada, ordem errada | `money`, `date`, `datetime` |
| Array de ids no pai | duas verdades que divergem | `ref` no filho e consulta por filtro |
| Evento vago ("pedido atualizado") | ninguém sabe o que aconteceu | evento específico no passado ("Pedido aprovado", "Pagamento recebido") |

Armadilhas de nome: jargão interno que o dono não usa; abreviação (`cli_ped`); sinônimos misturados (cliente, freguês, contato); nome de armazenamento (`CustomerRecord`, `tabela_pedidos`).
