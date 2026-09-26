---
name: financeiro-e-cobranca
description: "Monta o financeiro do pequeno negócio dentro do app: catálogo, orçamento com itens, desconto e validade que vira venda, contas a receber com faturas e parcelas, régua de cobrança com mensagem no tom certo para cada cliente (gentil para quem paga em dia, firme para quem sempre atrasa) aprovada pelo dono e enviada por WhatsApp ou e-mail, promessa de pagamento, Pix e link de pagamento, baixa com comprovante, mensalidades, registro de nota fiscal e relatórios de cobrança. Para construir ou editar o app na Fabapp AI pelo terminal (CLI @fabappai/cli). Use quando o dono disser: quem está me devendo, contas a receber, cobrar cliente atrasado, fiado, caderninho, inadimplência, lembrete de vencimento, cobrança no WhatsApp, orçamento, proposta, fatura, recibo, parcelas, mensalidade dos alunos, cliente que paga por mês, controle financeiro, dar baixa, Pix, link de pagamento, relatório de cobrança. Serve para prestador de serviço, agência, escola, academia, oficina, consultoria e loja que vende a prazo."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Financeiro e Cobrança
  edition: terminal
---

# Financeiro e Cobrança

O app faz o trabalho de um assistente financeiro do dono: transforma orçamento em venda, venda em fatura, fatura em dinheiro recebido, e diz todo dia quem deve, quanto, há quanto tempo e com que tom cobrar. A IA do app prepara; o dono aprova e envia. Nenhuma mensagem sai sozinha para cliente atrasado. Você constrói e edita esse app pelo terminal, com o CLI `@fabappai/cli`.

- **Primeiro movimento**: se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.
- **O contrato ao vivo vence**: onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.
- **Duas mãos**: enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Quando usar e quando não usar

Use quando o negócio vende com pagamento depois da venda (a prazo, por fatura, parcelado, mensalidade, fiado) ou faz orçamento antes de vender. Serve de módulo dentro de um CRM, de uma agenda ou de um app de pedidos.

Não use sozinha para: loja virtual em que o cliente paga na hora do pedido (o pagamento já é o `order` com `useCheckout`; aproveite só a parte de relatórios), venda de acesso ao próprio app (plano premium é `useSubscribe`), contabilidade completa, folha de pagamento ou emissão de nota fiscal (o app registra a nota, não emite). Contas a pagar a fornecedor entram só como lista simples de vencimentos se o dono pedir.

## Decisões fixas (valem sempre)

1. **Dinheiro**: campo `money`; toda conta em centavos inteiros no código (`Math.round(v*100)`), exibição só com `formatMoney` (formato brasileiro R$ 1.234,56), números em coluna com `tabular-nums` alinhados à direita. Nunca somar `money` com ponto flutuante cru.
2. **Datas**: `date` guarda `aaaa-mm-dd` do dia local (`America/Sao_Paulo` por padrão, ou o fuso do negócio quando o dono informar); exibe dd/mm/aaaa com `formatDate`; dias de atraso = diferença de dias de calendário com `date-fns` sobre a data local. Nunca cortar `toISOString()`.
3. **Estado derivado nunca é digitado.** A fatura guarda só o fato (`status`: `open`, `paid`, `canceled`), escrito por evento (baixa, confirmação do pagamento, cancelamento com motivo). "Vencida", "dias de atraso", "faixa de atraso", "saldo", "expirado" e o tom do cliente são calculados na tela. Nenhum formulário tem campo de status, saldo ou total.
4. **Confirmação de pagamento é da plataforma.** O link de pagamento usa `useCheckout`; quem marca `paid` é o webhook da plataforma. A página de retorno nunca marca nada como pago. Pagamento por fora (Pix direto, dinheiro, transferência, boleto do banco, maquininha) só vale com baixa manual feita por admin ou financeiro, com comprovante.
5. **Nada sai sem aprovação.** Mensagem de cobrança, envio de orçamento e lote de faturas: o app mostra a prévia com a contagem e o total, e só envia depois do "Enviar" do dono. Uma aprovação vale para um lote; editar um rascunho depois de aprovar pede nova aprovação.
6. **Uma mensagem por cliente por lote**, juntando todas as faturas vencidas dele com o total.
7. **Nunca cobrar quem pode ter pago**: cliente com pagamento registrado nos últimos 14 dias ou com promessa de pagamento em dia sai da fila e aparece como "Possivelmente pago, confira" ou "Promessa até dd/mm".
8. **Números saem dos dados do app.** Painel, régua e relatórios somam no cliente a partir de `list` paginado (sem soma no servidor). Nada de valor inventado; dado de exemplo leva a marca "Exemplo".
9. **Histórico não se apaga.** Pagamentos, mensagens enviadas e promessas são só de acréscimo: corrigir é lançar estorno ou nova entrada com motivo.

Aplique `references/modelo-de-dados.md` (modelos, campos, acesso), `references/regua-de-cobranca.md` (pontuação, tons, modelos de mensagem, conferências), `references/calculos-e-relatorios.md` (fórmulas) e `references/regras-br-e-pagamento.md` (Pix, CPF/CNPJ, nota fiscal, link de pagamento). Onde cada coisa vive na plataforma: `references/fabapp-cli.md`.

## A conversa: o que perguntar ao dono

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Até 6 perguntas desta skill, em português simples; pule as que o pedido já respondeu. O resto é suposição anotada.

Perguntas principais:
1. "O que você cobra dos seus clientes?" Opções: "Serviços ou trabalhos avulsos (Recomendado)", "Produtos vendidos a prazo", "Mensalidade de quem é cliente fixo", "Um pouco de cada".
2. "Você faz orçamento antes de fechar a venda?" Opções: "Sim, com itens, desconto e validade (Recomendado)", "Não, eu já lanço a cobrança direto".
3. "Como seus clientes costumam te pagar?" (várias) Opções: "Pix na minha chave (Recomendado)", "Link de pagamento com cartão ou Pix", "Dinheiro ou maquininha", "Boleto do meu banco".
4. "Por onde você quer mandar as cobranças? Você sempre aprova antes de sair." Opções: "WhatsApp (Recomendado)", "E-mail", "Os dois".
5. "Seus clientes vão entrar no app para ver e pagar as faturas?" Opções: "Não, só eu e minha equipe usamos (Recomendado)", "Sim, cada cliente vê as próprias faturas".
6. "Quem mais usa o financeiro?" Opções: "Só eu (Recomendado)", "Eu e uma pessoa do financeiro", "Eu, financeiro e vendedores".

Perguntas extras, só se a resposta anterior deixar dúvida que muda o app:
- Se cobra mensalidade: "O valor da mensalidade é sempre o mesmo todo mês?" Opções: "Sim, valor fixo com dia de vencimento (Recomendado)", "Muda conforme o uso".
- Se vende a prazo: "Você parcela?" Opções: "Sim, em até 12 vezes (Recomendado)", "Não, é sempre uma parcela só".
- "Você emite nota fiscal?" Opções: "Sim, de serviço (NFS-e)", "Sim, de produto (NF-e ou NFC-e)", "Não emito (Recomendado)". Diga que o app guarda o número e o arquivo da nota; a emissão continua no sistema da prefeitura ou do contador.
- "Cobra multa e juros de quem atrasa?" Opções: "Não (Recomendado)", "Sim, 2% de multa e 1% ao mês".

O app é privado, estilo app com abas embaixo. Anote em `DECISOES.md` as decisões acima e as regras fixas 3 a 7 com as palavras do dono.

**Marca:** esta skill não impõe cor nem fonte. No terminal você define: proponha paleta, par tipográfico e raio, peça aprovação e grave em `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`), enviado com `fabapp push`. No código, só tokens do tema. O logo o dono sobe no Studio.

## O plano: telas, modelos e lista de conferência

Escreva o plano como texto e mostre ao dono antes de codar; ele aprova antes da construção. O plano traz telas, modelo de dados, as decisões desta skill, suposições com alternativa, o que não entra e a lista de conferência.

Navegação de app com 4 ou 5 abas: **Hoje**, **Receber**, **Vendas** (orçamentos e catálogo), **Clientes**, **Relatórios** (configurações dentro de Relatórios ou no menu do perfil). Com área do cliente, o cliente tem só "Minhas faturas".

Telas obrigatórias (corte o que o dono não usa, nunca a régua):
1. **Hoje**: total a receber, total vencido, recebido no mês (`StatCard`), fila "Cobrar hoje" com contagem, promessas que vencem hoje, faturas que vencem em 3 dias, e o aviso de conferência de pagamentos por fora.
2. **Cobrar hoje** (a régua): tabela Cliente | Valor devido | Dias de atraso | Tom | Enviar por, com etiquetas "Possivelmente pago, confira", "Promessa até dd/mm", "Nome de teste, confira", "Possível fatura duplicada". Abaixo, um rascunho por cliente em bloco copiável. Botões: aprovar lote, enviar um, editar, pular, registrar promessa.
3. **Receber**: lista de faturas com filtro por faixa (a vencer, 1 a 30, 31 a 60, 61 a 90, mais de 90 dias) e busca; ficha da fatura com parcelas, pagamentos, mensagens enviadas, promessas, nota fiscal, e os botões "Dar baixa", "Cobrar", "Copiar Pix", "Cancelar fatura" (motivo obrigatório).
4. **Orçamento**: editor com itens do catálogo ou avulsos, quantidade, preço (pode mudar só neste orçamento), desconto % por item e no total, validade, total calculado; página de impressão; "Marcar como enviado", "Cliente aceitou" (gera as faturas com parcelas e datas) e "Cliente recusou" (motivo).
5. **Catálogo**: produtos e serviços com preço, código, unidade, ativo; recorrente quando é mensalidade.
6. **Clientes**: busca por nome, telefone, CPF/CNPJ; ficha com saldo, histórico de pagamento (pontuação e tom), botão WhatsApp.
7. **Mensalidades** (se houver): contratos ativos, "Gerar faturas do mês" com prévia e contagem, MRR.
8. **Relatórios**: a receber por faixa de atraso, recebido no mês, inadimplência, previsão 30/60/90 dias, receita recorrente, notas pendentes.
9. **Pagamento** (`/pagamento`, pública, fora da casca): nome do negócio, chave Pix, QR sem valor e WhatsApp do dono, lidos de `payment_info`; nenhum dado de cliente. É o `link` dos e-mails de cobrança quando não há área do cliente.
10. **Configurações**: dados de cobrança (chave Pix, nome e cidade do recebedor), prazo padrão, multa e juros, amostra do jeito de escrever do dono, modelos de mensagem.

Modelos: use exatamente os de `references/modelo-de-dados.md`, cortando os que a conversa descartou.

**Lista de conferência** (todos os itens entram, sem teto; são requisitos da construção quando a tela existe):
- código: nenhum formulário de fatura, orçamento ou pagamento tem campo de status, saldo ou total digitável.
- código: status da fatura na tela vem de `invoiceView()` (paga, cancelada, vencida, aberta), calculado com a data local.
- código: a fila "Cobrar hoje" junta as faturas vencidas por cliente, uma mensagem por cliente, com o total.
- código: cliente com pagamento nos últimos 14 dias ou promessa em dia não recebe rascunho; aparece com a etiqueta.
- código: o tom sai da pontuação de `references/regua-de-cobranca.md` (12 meses, mínimo de 3 faturas).
- código: enviar exige a aprovação do lote na tela; nada de envio em `useEffect` ou automação para cliente atrasado.
- código: o link de pagamento usa `useCheckout` com `items: [{ model_id: 'invoice', record_id }]` (a plataforma cobra o `price` do registro), e a página de retorno só lê o status com `useLive`.
- código: baixa manual exige valor, data, forma e comprovante (ou motivo sem comprovante) e grava um `payment`; não altera pagamentos antigos.
- código: todo valor aparece com `formatMoney` e toda data com `formatDate`.
- código: "Gerar faturas do mês" e "Aprovar lote" mostram prévia com contagem e total antes de gravar ou enviar.
- visual: o código Pix copia e cola da fatura é lido pelo app do banco (conferir com o dono na primeira fatura).
- visual: toda lista tem estado vazio com uma ação ("Nenhuma fatura vencida. Ver próximas a vencer"); carregando com `Skeleton`, erro com `e.message` e "Tentar de novo".

Em "o que não vamos construir": emissão de nota fiscal, geração de boleto, envio automático para cliente atrasado, conciliação com extrato bancário.

## A construção: como implementar

Siga o plano ao pé da letra; as decisões desta skill são requisitos. Ordem: schema e automações (`fabapp push`), depois tema, depois código (`fabapp deploy`).

**Schema**: `fabapp pull`, edite `fab.schema.json` com os modelos e acessos de `references/modelo-de-dados.md`; `currency: "BRL"`, `locale: "pt-BR"`; envie com `fabapp push` (ou `fabapp_write_definition` pelo MCP). `status` da fatura com opções em texto simples `["open","paid","canceled"]` e rótulos em português num mapa no código: é por esse valor `paid` que a plataforma marca a fatura paga. `price` da fatura = saldo a cobrar, mantido pelo código. Papel `finance` quando a conversa pediu; `seller` quando há vendedores. Com área do cliente, ligue o login por código em `fab.settings.json` (`"auth": {"email_code_login": true}`).

**Arquivos de domínio** (`src/lib/finance/`): `money.ts` (centavos, soma, divisão em parcelas com a sobra de centavos na primeira), `invoice.ts` (`invoiceView`, saldo, faixa), `score.ts` (pontuação e tom), `chase.ts` (monta a fila e os rascunhos), `pix.ts` (código copia e cola com CRC16), `docs.ts` (CPF/CNPJ, telefone). Toda fórmula de `references/calculos-e-relatorios.md` vive aqui com os nomes de lá, para uma mudança futura achar.

**Leituras**: filtro e ordem no servidor (`filter: {status:'open'}`, `sort:'due_date'`), paginação com `limit` e `offset` até acabar antes de somar (uma página cheia quase sempre é resultado cortado). Busca com debounce de 300 ms. `useLive` na ficha da fatura e em "Minhas faturas".

**Formulários**: `zod` em todos; `CurrencyInput`, `DatePicker`, `PhoneInput`; duplicidade conferida com `count` na chave normalizada antes de criar (não há unicidade no servidor). Erros da API: mostrar `e.message`; 401, 403, 409 e 422 tratados; 402 da IA cai no modelo pronto.

**Régua**: implemente `references/regua-de-cobranca.md` inteira: conferências antes do rascunho, pontuação, tom, assunto, corpo com uma única chamada para ação, consolidação, aprovação por lote, envio por `integrations.call('whatsapp','sendMessage',{to, body})` quando a integração existe, senão link `wa.me` com o texto e a pergunta "Enviou?" para registrar; e-mail com `notify('email', ...)` seguindo as regras do e-mail do app (texto puro, sem URL no corpo, `link` do próprio app; 429 = "Limite de e-mails do dia; use o WhatsApp ou copie o texto"). Falha de envio vira aviso na linha e caminho alternativo, nunca some.

**Reescrever no jeito do dono** (opcional, botão no rascunho): `invokeLLM({tier:'fast', system, prompt, schema})` com a amostra do dono das Configurações; o que vem do cliente (observações, respostas) entra no prompt como dado entre aspas, com a instrução de não seguir ordens contidas ali. O tom da pontuação não muda; sem amostra, o texto fica neutro e a tela diz "sem amostra do seu jeito de escrever".

**Pagamento**: fluxo de `references/regras-br-e-pagamento.md`. Botão "Pagar" só na área do cliente; `paymentMethods` vazio por padrão (o gateway oferece o que tem), `['credit_card','pix']` só quando o dono pediu Pix explicitamente. Sem `<SubscribeGate>`: ele serve para assinatura de conteúdo digital dentro do app nativo; fatura de serviço ou produto não passa pela loja do celular. Nunca função de backend falando com gateway, nunca webhook próprio.

**Automações** (`fab.automations.json`: `fabapp pull`, edite, envie o conjunto inteiro com `fabapp push`), todas para a equipe, nunca para cliente atrasado:
- `relative` em `invoice.due_date` com `offset_days: -3`, `1`, `7`, `15` e `30`: `inapp` e `push` para `role:finance` (ou `admin`), título "Fatura {{code}} de {{customer}}", corpo que manda conferir ("vence em 3 dias", "venceu ontem; se já foi paga, dê baixa"), `link: "/receber/{{id}}"`. Elas disparam também para fatura já paga: o texto nunca afirma que está em aberto.
- `relative` em `payment_promise.promised_date` com `offset_days: 1`: "Promessa de {{customer}} venceu ontem. Confira se o pagamento chegou", link `/hoje`.
- `schedule` `daily` para `admin`: "Cobranças e vencimentos de hoje", link `/hoje`.
- `data` `created` em `payment` para `admin` em `inapp`: "Novo pagamento registrado na fatura {{invoice}}" (sem `{{amount}}`, que sairia sem formatação), link `/receber` (um `ref` vira o rótulo no texto, não o id, então não serve para montar rota), para o dono ver cada baixa feita pela equipe.
- Aviso de 3 dias antes ao próprio cliente só se a conversa pediu área do cliente e o dono escolheu: `relative -3` para o campo `payer`, corpo que termina em "Se já pagou, desconsidere".

**Reconciliação ao abrir Receber** (admin ou financeiro): fatura `paid` pela plataforma sem `payment` de forma `link` ganha um `payment` com o valor de `price` e a data de `paid_at`, e `price` vai a 0. Confira com `count` antes de criar, para nunca duplicar.

**Importar planilha** (Configurações, para quem vem do caderno ou do Excel): clientes, catálogo e faturas em aberto com importação upsert por chave natural normalizada (aqui a chave da fatura é cliente + valor + vencimento; a do produto é o código sem espaços e minúsculo), com relatório por linha. Sem nenhuma integração o app funciona igual: a planilha entra, a régua sai.

**Dados de exemplo**: o CLI não grava registros. Deixe o conjunto numa constante e um botão "Carregar exemplos" (só admin, com prévia e contagem) que grava pelo próprio app com `bulkCreate`, tudo marcado "Exemplo": 10 clientes PF e PJ com DDDs variados (um bom pagador, um que atrasa às vezes, um reincidente com 4 faturas pagas com atraso), 6 produtos ou serviços, 3 orçamentos (rascunho, enviado, aceito), 18 faturas espalhadas nas faixas de atraso, 5 pagamentos com forma variada, 1 promessa em dia e 1 vencida, 2 contratos de mensalidade. O dono também pode cadastrar ou importar pelo CMS do Studio. Diga ao dono que são exemplos removíveis e nunca que você criou dados.

**Texto e visual**: rótulos em português do dono ("Dar baixa", "Cobrar", "Quem me deve"); valores `tabular-nums`; etiquetas de faixa com `Badge` usando tokens do tema (`bg-destructive/10 text-destructive` para mais de 30 dias, `bg-muted` para a vencer); nenhuma cor fixa; `AlertDialog` para cancelar fatura e aprovar lote; toast para sucesso.

## Conferir antes de dizer pronto

Rode `fabapp dev`, abra a pré-visualização e percorra cada item da lista de conferência (rota, elemento, estado), no celular e no desktop. Confira por busca (`grep`) em `src/`: nenhum hex nem neutro fixo, nenhum `window.confirm`, `alert(` ou `prompt(`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`, nenhum envio dentro de `useEffect`. Confira que `fab.automations.json` só cita modelos e campos do schema. Depois `fabapp deploy`: `account_builds_busy` (409) é esperar e repetir; `build_failed` (422) é consertar arquivo e linha indicados, sem repetir às cegas.

Na mensagem final ao dono, relate só o que conferiu (por exemplo: "fila junta faturas por cliente; baixa grava pagamento com comprovante"), o link, e o que ele faz no Studio:
- conectar o gateway (Stripe, Pagar.me ou Mercado Pago) só se escolheu link de pagamento, em modo de teste primeiro;
- conectar WhatsApp se quiser enviar sem abrir o celular (sem isso o app abre o WhatsApp com a mensagem pronta);
- subir o logo; cadastrar ou importar dados no CMS, se não usar os botões do app.

No próprio app ele cadastra a chave Pix nas Configurações. Avisos: o app não emite nota fiscal; boleto não é gerado pelo app; mensalidade paga por assinatura automática só no cartão (Pix não renova sozinho). Próximos pedidos sugeridos: relatórios extras, área do cliente, importar clientes de planilha.

## Mudanças depois: pedidos comuns do dono

Leia `DECISOES.md` antes e atualize depois.

- "Manda sozinho a cobrança": explique que o app prepara e ele aprova com um toque, porque não dá para saber se o cliente pagou por fora; ofereça o aviso de 3 dias antes ao cliente (texto com "se já pagou, desconsidere") e o lembrete diário para ele.
- "Quero boleto": o app não gera boleto; ofereça link com Pix ou cartão e a baixa manual do boleto emitido no banco.
- "Muda o status para pago": nunca crie campo editável; faça pelo "Dar baixa" com comprovante.
- "Apaga esse pagamento": estorno com motivo (pagamento negativo), nunca remoção.
- "Cobra mais firme": ajuste o texto do tom, sem ameaça, sem letras maiúsculas, sem expor o cliente (regra do Código de Defesa do Consumidor em `references/regras-br-e-pagamento.md`).
- Mudar pontuação, faixas ou prazos: altere as constantes em `src/lib/finance/` e anote a decisão em `DECISOES.md`.
- Antes de mexer em modelo, rode `fabapp pull`, leia o `fab.schema.json` atual e use os nomes e opções de enum que estão lá; nunca suponha nome de campo.
- Qualquer mudança de acesso em `invoice`, `payment` ou `customer`: mantenha o cliente vendo só o que é dele e nunca deixe leitura pública.

## Não fazer

- Não criar campo de status, saldo, total, dias de atraso ou "vencida" digitável.
- Não marcar pago no cliente nem na página de retorno do pagamento; não escrever webhook ou função que chame gateway.
- Não enviar mensagem de cobrança sem aprovação, nem por automação a cliente atrasado.
- Não cobrar quem pagou nos últimos 14 dias ou tem promessa em dia.
- Não mandar duas mensagens ao mesmo cliente no mesmo lote.
- Não inventar valor, cliente, CNPJ, chave Pix ou número de nota; campo vazio mostra o marcador para o dono preencher.
- Não prometer Pix em mensalidade automática, boleto gerado pelo app ou emissão de nota.
- Não apagar pagamento, mensagem ou promessa; não deixar `invoice`, `payment` ou `customer` com leitura pública.
- Não guardar dinheiro como texto nem somar sem arredondar para centavos.
