---
name: fab-spec-de-sistema
description: "Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli): faz sistemas de várias telas saírem completos e coerentes, decidindo o que cada tela contém (o comportamento fica com fab-ux-de-sistemas). O plano descreve cada tela (lista, detalhe, formulário, painel) com campos, colunas, filtros, ações, quem vê cada ação e as mudanças de status, mais um PRD enxuto (objetivos, o que fica fora, histórias, prioridades); a construção define tipos, rótulos e funções de dados uma vez só; nada de tela pela metade nem botão sem ação; e o app é conferido em lista vazia, sem login, campo vazio, texto longo e celular. Use quando o dono pedir CRM, sistema de gestão, controle de clientes, ordens de serviço, estoque, financeiro, contas a pagar e receber, agenda da equipe, painel administrativo, portal com área logada, controle de alunos, pacientes, obras, pedidos ou chamados, ou qualquer app com cadastro, lista e status. Também quando o pedido acrescenta campo, status, tela ou papel num sistema que já existe."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Spec de Sistema
  edition: terminal
---

# Spec de Sistema

Para apps com várias telas de dados: cadastro, lista, detalhe, status, papéis. O plano descreve cada tela com detalhe
suficiente para reconstruí-la, em linguagem de negócio. A construção define os nomes uma vez e todas as telas usam os
mesmos. Nada fica pela metade. No fim, cinco situações que mais quebram app de verdade são conferidas.

Aplica-se quando o app tem 3 ou mais telas de dados, 2 ou mais modelos ligados, ou papéis diferentes. Site de uma
página só não precisa desta skill.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
`references/fabapp-cli.md` (Node, `status`, login, `create` ou `link`, `pull`, `dev`, contrato ao vivo) e só então
comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) discordarem
sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Regras da spec (valem no plano, na construção e nas mudanças)

1. **Linguagem de negócio primeiro.** Não escreva "usa estado de carregamento"; escreva "o botão Salvar mostra
   carregando e não deixa enviar duas vezes". Detalhe técnico só quando muda o comportamento: regra de acesso,
   validação, nome de modelo.
2. **Uma palavra por conceito.** O termo que o dono usa ("atendimento", "OS", "paciente") é o mesmo no menu, no título,
   na coluna, no botão, no aviso e no `name` do modelo. O `id` técnico fica em inglês.
3. **Lógica escondida é escrita.** Dependência entre campos (pessoa física mostra CPF, jurídica mostra CNPJ), botão que
   só aparece em certo status, formato (R$ 1.234,56, dd/mm/aaaa, telefone (11) 91234-5678), ordem padrão da lista,
   tamanho da página, busca com espera de 300ms, atualização automática.
4. **Todo status e todo tipo é listado inteiro**, com valor, rótulo, tom do selo e significado.
5. **Não chute.** Se o significado de negócio de um campo ou regra não está claro, isso vira suposição no plano ou
   decisão registrada na construção. Nunca um significado inventado apresentado como certo.
6. **Cada tela se lê sozinha.** A descrição de uma tela traz tudo o que ela precisa; não escreva "igual à tela X".

## O plano: PRD enxuto

O plano é um texto que você escreve e mostra ao dono antes de codar; ele aprova antes da construção. Organize em
seções (Visão geral, Telas, Funcionalidades, Modelo de dados, O que NÃO vamos construir, Lista de conferência) e
encaixe nelas:

- **Problema** (Visão geral, 2 a 3 frases): quem sofre, com que frequência, o que custa não resolver, com a evidência
  que o dono deu, e como é feito hoje (papel, planilha, outro sistema: define se haverá importação).
- **Módulos** (quando há mais de um): tabela módulo | telas | o que resolve.
- **Objetivos** (3 a 5): resultados, não entregas. "A recepção confirma os horários do dia em menos de 5 minutos", não
  "tela de agenda". Separe objetivo de quem usa e objetivo do negócio.
- **O que NÃO vamos construir** (3 a 5, cada um com motivo: pouco impacto, complexo demais agora, é outra frente, cedo
  demais). Isso segura o escopo durante a construção.
- **Histórias por papel**, as mais importantes primeiro: "Como <papel específico>, quero <capacidade> para
  <benefício>". Inclua as de erro, vazio e limite. Cada história é independente, tem valor para quem usa, é pequena e
  dá para conferir. Erros a evitar: vaga ("quero mais rapidez"), que prescreve o componente ("quero um menu suspenso"),
  sem benefício, grande demais ("quero gerenciar minha equipe"), interna ("a equipe técnica quer refatorar").
- **Prioridade**: P0 = sem isso a primeira versão não resolve o problema (teste: "se cortar, ainda resolve?"; se não,
  é P0). P1 = melhora muito, mas o núcleo funciona sem; vai para os próximos passos e precisa ser algo que se fará
  mesmo. P2 = futuro; não se constrói, mas o modelo de dados não pode impedir (ex.: o `ref` já no filho certo, o status
  com espaço para a etapa futura). Se tudo é P0, nada é P0.
- **Métricas**: de reação rápida (quantos usam, quantos terminam a ação principal, tempo, erros, frequência) e de
  longo prazo (retorno, receita, menos mensagens de suporte). Meta específica, com limite de sucesso e meta
  esticada, e momento de medir ("metade dos clientes confirma pelo app em 30 dias; ótimo se forem 70%"). O app só conta com `count()` e somas feitas na tela; se a métrica é P0, ela
  vira um cartão no painel com o filtro escrito.
- **Perguntas em aberto** viram suposições no plano: as de alto impacto (mudam quem usa, o que é pago, o que é
  público) no topo, cada uma com a alternativa escrita como pergunta que o dono pode escolher; as de baixo impacto,
  que se resolvem depois, no fim. Quando uma de alto impacto bloqueia, pergunte ao dono com a ferramenta de perguntas
  de opção da sua ferramenta (no Claude Code, AskUserQuestion; sem ela, uma mensagem curta com as opções numeradas),
  com a recomendada primeiro, marcada "(Recomendado)". Não liste o que dá para responder pelo contexto.
- **Prazo e fases**: se o dono citou uma data (inauguração, volta às aulas), diga o que entra antes dela; o resto
  vira fase seguinte nos próximos passos.
- **Regras gerais do app** (uma linha cada, valem para toda tela sem repetir): formatos de dinheiro, data e telefone;
  o glossário; "toda exclusão pede confirmação"; "listas começam pelas mais novas, 25 por página"; "erro aparece
  abaixo do campo"; o modelo de papéis em uma frase.
- **Tela inicial de quem opera** abre na tarefa (fila, agenda do dia, quadro de pedidos), sem herói nem painel
  decorativo (se a skill `fab-ux-de-sistemas` estiver instalada, ela detalha como a tela se comporta). O painel do dono tem 3 a 5 números.
- **Escopo durante o refinamento**: cada acréscimo pedido entra junto com um corte, ou vai para os próximos passos.
  Confira cada requisito contra o problema. Mais de 15 telas: proponha a primeira versão com o módulo central e liste
  os outros módulos como próximos passos.

## O plano: spec por tela

Primeiro o inventário (tabela na seção Telas): nº, tela, rota, aba ou menu, tipo (lista, detalhe, formulário,
painel), quem acessa. Depois cada tela, no formato de `references/modelos.md`, em 4 a 12 linhas, abrindo com uma frase (o que faz, que
situação traz a pessoa até ela) e as regiões (busca, lista, painel lateral, barra de ações):

- **Lista**: filtros (campo, tipo, opções, padrão); colunas (formato, ordenável, filtrável); ações por linha, cada
  uma com o papel que a vê; ações em massa (só com seleção; destrutiva pede confirmação); ordem padrão; 25 por página;
  contagem total ("32 clientes"); filtros e busca no servidor; filtros guardados na URL, para não se perderem ao voltar;
  no máximo 7 colunas visíveis no computador.
- **Formulário**: cada campo com rótulo visível, tipo da plataforma, obrigatório, padrão, validação, dependências e
  o que acontece depois de salvar. Até 3 campos cabem num Dialog; editar mantendo o contexto vai num Sheet (no
  celular, `side="bottom"`; no computador, lateral); cadastro
  grande é página própria, em seções. Mais de 8 a 10 campos que se agrupam naturalmente viram etapas (`Stepper`), cada
  etapa um assunto só; 4 a 6 campos ficam numa página. O indicador "Etapa 2 de 4" nunca muda de total no meio. Campo
  de arquivo diz os tipos aceitos e o tamanho máximo.
- **Detalhe**: blocos ou abas, o que cada um mostra, ações disponíveis por papel e por status.
- **Painel**: cada cartão com o significado exato, o filtro e o período; 3 a 5 números com comparação ao período
  anterior; atalho para a lista onde se age; com que frequência atualiza (ao abrir, ou em tempo real com `useLive`).
- Dialog e Sheet são descritos dentro da tela que os abre, por inteiro.

**Interações** como "ação → resposta": gatilho, validação, o que é gravado, sucesso (texto do aviso, o que atualiza) e
falha (mensagem). Cubra: abrir a tela (consulta e ordem padrão), buscar, filtrar, limpar, criar, editar, excluir,
paginar, ordenar, selecionar, ação em massa, mudar status, importar ou exportar planilha, campos que dependem de
outros, o que cada papel vê, atualização em tempo real.

**Máquina de status** para cada modelo com status: estado, para onde pode ir, quem pode mover, o que dispara (aviso
ou nada). Transição não listada não existe na tela. Automação não tem condição: avisa a cada criação ou alteração do
registro. Aviso de uma transição só = cada mudança de status grava um registro de histórico (`<modelo>_event` com
`from_status`, `to_status`, quem mudou) e a automação `created` nesse modelo avisa com o status no texto; o histórico
ainda vira a linha do tempo do detalhe.

**Dicionário de status e tipos**: para cada `enum`, valor (id em inglês), rótulo, tom do selo (neutro, marca, perigo,
contorno) e significado.

**Relações entre telas**: de onde se chega (com que parâmetro, ex. `/clientes/:id`), para onde se vai, e que ação numa
tela muda o que outra mostra.

**Exclusão com filhos**: para cada `ref`, o que acontece quando o registro pai é excluído (a exclusão é lógica):
bloquear com mensagem ("Este cliente tem 3 OS; encerre-as antes") conferindo com `count` antes de excluir, ou manter
os filhos mostrando "Removido". Escolha e escreva.

**Lado servidor**: cada automação com gatilho, para quem, canal e texto; cada função de backend com quem chama,
entrada, saída e o que acontece na falha.

**Papéis**: tabela papel × ação. Esconder o botão não protege nada: cada linha dessa tabela tem a regra `access` do
modelo que a garante.

**Glossário** (fim da seção Modelo de dados): termo do negócio | id do modelo | campos-chave | status. É o contrato de
nomes que a construção segue.

Antes de emitir o plano, confira pela lista da seção 13 de `references/modelos.md` e corrija só o que faria a
construção sair errada: tela sem spec, status sem dicionário, ação sem papel, contradição, marcador vazio.

## O plano: lista de conferência

Item = frase conferível, com caminho feliz, erro e borda, e o que NÃO deve acontecer. Nada de "rápido", "fácil",
"intuitivo". A lista de conferência fecha o plano, sem teto de quantidade: entram todos os itens abaixo que valem para
este sistema, adaptados ao app, cada um marcado com como se confere (no código: leitura e `grep`; na tela: a
pré-visualização do `fabapp dev`):

1. (no código) "Toda lista tem estado vazio com a ação de criar, e mensagens próprias para busca sem resultado e filtro
   que zerou."
2. (no código) "Rotas da área logada levam ao login sem sessão e voltam para a tela pedida depois de entrar."
3. (no código) "Campo opcional vazio aparece como 'Não informado'; nenhuma tela mostra undefined, null, NaN ou 'Invalid
   Date'."
4. (na tela) "Nomes com 40 caracteres e valores de R$ 1.234.567,89 cabem nas listas e cartões sem quebrar o layout."
5. (na tela) "Em 375px de largura, as listas viram cartões, os filtros abrem num painel e a página não rola de lado."
6. (no código) "A mudança de status só oferece as transições da máquina de status, e só para o papel que pode."
7. (no código) "O botão de cada ação só aparece para o papel da tabela, e a regra `access` do modelo bate com ela."
8. (no código) um por P0 do fluxo principal, citando a tela e o que é gravado.

## A construção: nomes definidos uma vez

A construção pode sair em paralelo (por exemplo, com subagentes): um esqueleto (schema, rotas, `src/lib/*`,
componentes compartilhados) e depois cada página sozinha, vendo só o esqueleto. Mesmo escrevendo em sequência, o
contrato mora no esqueleto e segue uma convenção que qualquer página adivinha:

| Coisa | Convenção | Exemplo (modelo `service_order`) |
|---|---|---|
| Arquivo do domínio | `src/lib/<id-com-hifen>.ts` | `src/lib/service-order.ts` |
| Tipo | PascalCase do id | `ServiceOrder` |
| Coleção | camelCase no plural | `serviceOrders = collection<ServiceOrder>('service_order')` |
| Opções de enum | `<ID>_<CAMPO>_OPTIONS` | `SERVICE_ORDER_STATUS_OPTIONS` |
| Rótulo de enum | `<modelo><Campo>Label(v)` | `serviceOrderStatusLabel('open')` |
| Transições | `<ID>_TRANSITIONS` e `can<Modelo>Transition(de, para)` | `canServiceOrderTransition` |
| Validação do formulário | `<modelo>Schema` (zod) | `serviceOrderSchema` |
| Leitura | `use<Modelos>(params)` e `use<Modelo>(id)` | `useServiceOrders`, `useServiceOrder` |
| Escrita | `create<Modelo>`, `update<Modelo>`, `change<Modelo>Status` | `changeServiceOrderStatus(id, to)` |

Mapa de arquivos antes de escrever: cada arquivo com uma responsabilidade; o que muda junto mora junto
(`src/components/<dominio>/` para as peças de uma tela: cartão da linha, seção do formulário, Dialog); página grande
é dividida em componentes. Em app existente, siga o padrão que já está lá.

Ordem da construção:
1. **Schema** no `fab.schema.json` (depois de `fabapp pull`), igual ao plano, enviado com `fabapp push` antes do
   código que depende dele: `enum` com `options` `{value,label}` do dicionário, `ref` no filho,
   `money` para dinheiro, `autonumber` para número de OS ou pedido, `access` igual à tabela de papéis.
2. **Um arquivo de domínio por modelo**, completo, antes das páginas: tipo, coleção, opções e rótulos, transições,
   schema zod, leitura com filtro, ordem, `limit` e `offset` no servidor, escrita. Percorra a spec de cada tela e
   garanta que toda função que ela pede está exportada (o esqueleto é o único lugar onde nomes nascem). Um componente
   `src/components/status-badge.tsx` recebe valor e opções e pinta o selo pelo tom. Siga o exemplo de código de
   `references/modelos.md`.
3. **Páginas** implementando a spec ao pé da letra: toda coluna, filtro, ação, condição de papel, transição e
   mensagem. Página importa de `@/lib/<dominio>` e nunca redefine tipo, rótulo ou lista de status. `formatMoney`,
   `formatDate` e `formatDateTime` vêm do fab-client.

**Sem marcador vazio**. Isto é falha de construção, nunca escreva:
- TODO, FIXME, "em breve", "implementar depois", "adicionar validação", comentário `// ...resto igual`;
- `href="#"`, botão sem `onClick`, ação que só faz `console.log`, `catch` vazio;
- lorem ipsum, lista fixa no código no lugar da consulta ao modelo;
- nome importado que nenhum arquivo exporta, ou o mesmo conceito com dois nomes (`clientName` numa tela,
  `customerName` na outra);
- "mesma coisa da tela X": repita o que é preciso.

## A construção: foco de revisão

Cinco situações que a spec quase nunca cita e que mais quebram o app na mão de alguém. O silêncio da spec sobre um
caso não autoriza quebrar nele: a gravidade é o que a pessoa sofre. Implemente em toda lista, detalhe e formulário:

1. **Lista vazia**: quatro estados distintos. Sem dados ainda: `EmptyState` com a ação principal ("Cadastrar primeiro
   cliente"). Busca sem resultado: "Nada encontrado para 'x'" com "Limpar busca". Filtro que zerou: "Nenhum item com
   esses filtros" com "Limpar filtros". Erro: a mensagem do erro e "Tentar de novo". Carregando: `Skeleton`, nunca
   spinner no meio do conteúdo.
2. **Usuário sem login**: área logada manda para o login e volta à tela pedida; tela pública funciona sem sessão
   (`read:'public'` no modelo). 401 leva ao login; 403 mostra "Você não tem permissão para isso"; 409 e 422 mostram
   `e.message` perto do campo.
3. **Campo vazio**: opcional sem valor mostra "Não informado"; `ref` sem `__label` mostra "Removido"; dinheiro e data
   nulos não viram "R$ NaN" nem "Invalid Date"; imagem ausente mostra as iniciais.
4. **Texto longo**: nomes como "Maria Aparecida dos Santos Oliveira", descrição de 500 caracteres, valor de
   R$ 1.234.567,89. Use `min-w-0`, `truncate` com `title` ou `line-clamp-2`, `break-words`; botões em português são
   mais longos, não fixe largura.
5. **Celular (375px)**: abaixo de `md` a tabela vira lista de cartões; filtros num `Sheet`; ações da linha num
   `DropdownMenu`; formulário em uma coluna; alvo de toque de 44px; linha que rola de lado só com `ScrollRow`.

## A construção: seguir sem parar e registrar decisões

- Não pare para perguntar "posso continuar?". O plano é a autoridade; onde ele é omisso ou errado, escolha a menor
  mudança que o satisfaz e siga.
- Toda escolha que o plano não fez é registrada: **"Decidi X porque Y; se estiver errado, custa Z."** Desvio sem
  registro é decisão escondida do dono.
- Só quatro coisas param a construção: apagar ou sobrescrever dados (o token do CLI não apaga registros; o dono decide
  e faz no CMS do Studio); enfraquecer segurança (abrir leitura ou escrita pública, afrouxar login); efeito fora do
  app (mandar mensagem ou e-mail a clientes reais, publicar: sem o dono pedir, `fabapp deploy --no-publish` só salva);
  plano tão quebrado que qualquer caminho é chute. Nesses casos, construa o resto e deixe a pergunta nos próximos
  passos da mensagem final.
- Decisão durável (regra de negócio que o próximo pedido não deve reabrir, ex.: "OS cancelada não volta a aberta") vai
  para `DECISOES.md`, na seção **Decisões**: uma decisão por linha, sem apagar as que já existem. Recusa do dono vai em
  **Fora do escopo**; o que ficou para depois não. Decisão miúda (nome de componente) fica só na mensagem final.

Antes da mensagem final, confira com olhos novos:
1. **Cobertura**: cada tela, campo, ação e transição do plano tem arquivo que a implementa? Complete o que faltar.
2. **Marcador vazio**: nenhum item da lista acima.
3. **Nomes**: cada import existe; cada conceito tem um nome só; o termo do glossário é o mesmo em toda tela.
4. **Foco de revisão**: as cinco situações em toda lista, detalhe e formulário.
5. `npx tsc -b` e `npx vite build` passaram em `.fabapp/workspace` depois da última alteração; `fabapp push` e
   `fabapp deploy` limpos; cada item da lista de conferência visto no código ou na pré-visualização.

Na mensagem final, diga pronto só do que foi conferido. Primeiro: o que foi feito e conferido, e a lista "Decisões que
tomei" com o custo se estiver errado. Depois, os próximos passos: os P1, as perguntas das quatro paradas, os fatos que
o dono precisa preencher, o que ele faz no Studio (integrações, domínio, cadastrar registros no CMS) e melhorias
pequenas que ficaram de fora. Nada de "deve funcionar".

| Desculpa | Realidade |
|---|---|
| "Lembro o que a spec da tela diz" | Você lembra um resumo. Releia a tela no plano: ela tem os valores exatos. |
| "O plano está errado aqui, faço o certo e pronto" | Faça o certo e registre a decisão. Desvio sem registro é segredo. |
| "Registro as decisões no final" | No final você já esqueceu metade. Registre quando decidir. |
| "Vou perguntar antes de seguir" | Só as quatro paradas param. O resto você decide e registra. |
| "Já que estou aqui, arrumo outras coisinhas" | Cada extra é mudança que o dono não pediu. Liste nos próximos passos. |

Nada de pronto sem evidência conferida nesta sessão: "deve compilar", "só desta vez" e "o dono tem pressa" não são
evidência. Se a skill `fab-verificar-antes-de-entregar` estiver instalada, ela traz o passo a passo completo e vale aqui.

## Mudanças depois: mexer no sistema sem quebrar a spec

1. Leia primeiro o contexto global: rotas, arquivos de domínio, schema, papéis e automações. Depois o arquivo de
   domínio do modelo afetado. Estenda-o; nunca redefina tipo ou rótulo dentro da
   página.
2. **Propague a mudança inteira**:
   - campo novo: schema, tipo, schema zod, formulário, coluna da lista (se ajuda a decidir), detalhe, filtro (se
     alguém vai buscar por ele);
   - status novo: acrescente o valor no fim das opções, nas transições, no tom do selo, nos filtros e nas automações
     que citam status;
   - termo renomeado: troque o rótulo em todo lugar (menu, título, coluna, botão, aviso, `name` do modelo) e mantenha
     o `id`;
   - papel novo: tabela de papéis, regras `access`, botões condicionados.
3. **Nunca mude em silêncio** (se a skill `fab-redesign-e-polimento` estiver instalada, ela traz a lista completa): rota, `id` de modelo ou campo, **valor** de enum
   (registros antigos guardam o valor; troque só o rótulo), nomes do menu, campos de formulário, logo, textos legais.
   Se o pedido exige, diga na mensagem final.
4. Tela que usa dado fixo no código (lista escrita à mão, número de enfeite, espera simulada) é dívida: ao tocá-la,
   troque pela consulta ao modelo e diga na mensagem final.
5. Aplique o foco de revisão às telas tocadas e confira cobertura, nomes, `npx tsc -b`, a pré-visualização das telas
   tocadas e o `fabapp deploy`.
6. Registre decisões duráveis em `DECISOES.md` (mesmas regras da construção).

**Quando o dono pede para entender ou documentar o app** ("o que meu app faz?", "me passa a documentação", "quais
telas eu tenho?"): não mude código. Leia rotas, schema, domínio, páginas e automações e responda na conversa, em
linguagem de negócio: visão geral, módulos, inventário de telas e, para as telas pedidas, a spec no formato de
`references/modelos.md`. Nome visível vem do texto da tela, nunca da variável. O que não dá para entender pelo código
é marcado "a confirmar com você", nunca inventado.

## Modelos

Aplique os modelos de `references/modelos.md`: spec de lista, formulário, detalhe e painel, dicionário de status,
máquina de status, relações entre telas, arquivo de domínio em TypeScript e a lista de conferência da spec.
