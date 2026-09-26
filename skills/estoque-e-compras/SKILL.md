---
name: estoque-e-compras
description: "Monta o controle de estoque e compras no app: saldo por item com movimentações que não se apagam (entrada, saída, ajuste com motivo), inventário, velocidade de venda por item, quando cada item vai acabar, ponto de pedido, estoque de segurança, quanto comprar, sazonalidade, itens parados com dinheiro empatado, pedido de compra ao fornecedor com mensagem pronta para WhatsApp ou e-mail, recebimento que dá entrada no estoque e conta a pagar que bate com o pedido, e aviso diário do que repor. Para construir ou editar na Fabapp AI pelo terminal (CLI @fabappai/cli). Use quando o dono disser: controle de estoque, o que preciso comprar, vai faltar produto, sempre acaba o mais vendido, quanto pedir ao fornecedor, lista de compras, pedido de compra, reposição, estoque mínimo, ponto de pedido, produto parado, dinheiro parado no estoque, inventário, entrada de mercadoria, nota do fornecedor, contas a pagar de fornecedor. Para loja, mercadinho, pet shop, autopeças, material de construção, restaurante, confeitaria, oficina."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Estoque e Compras
  edition: terminal
---

# Estoque e Compras

O app compra o que vende, antes de acabar, e para de comprar o que não sai. Estoque é dinheiro que o dono já gastou: dá errado quando falta o item que o cliente veio buscar e quando sobra um palete que ninguém quer. As duas coisas aparecem no histórico de vendas antes de virar problema, e o app lê isso todo dia na tela **Repor agora**. Você constrói e edita esse app pelo terminal, com o CLI `@fabappai/cli`.

- **Primeiro movimento**: se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.
- **O contrato ao vivo vence**: onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.
- **Duas mãos**: enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Quando usar e quando não usar

Use quando o negócio guarda mercadoria, peça ou insumo e compra de fornecedor. Serve sozinha ou como módulo de um app de vendas, pedidos ou oficina.

Não use para: estoque de vagas ou horários (é agenda), loja virtual que só precisa de "esgotado" num produto (basta um campo de quantidade), ficha técnica de restaurante com baixa por receita (este módulo cobre o insumo comprado e a saída lançada; a baixa por receita é pedido à parte), contabilidade ou emissão de nota.

## Decisões fixas (valem sempre)

1. **Saldo nasce das movimentações.** `stock_movement` é só de acréscimo: entrada, saída (venda ou uso), devolução de cliente, ajuste com motivo obrigatório, perda com motivo. Corrigir é lançar outra movimentação. O `on_hand` do item é cache gravado no mesmo fluxo e recalculável pelo botão "Recalcular saldo".
2. **Cálculo no código do app**, a partir de `list` paginado (não há soma no servidor): velocidades, dias de cobertura, ponto de pedido, quantidade a comprar, parados. As fórmulas estão em `references/calculo-de-reposicao.md` e não se mudam sem o dono pedir.
3. **Duas velocidades, dois papéis.** A maior entre 7 e 28 dias diz quando acaba (pessimista); a de 28 dias diz quanto comprar (sóbria). Cada linha mostra as duas com o nome.
4. **Falta de estoque não é falta de procura.** Dias com saldo zero saem da conta da velocidade.
5. **Nunca inventar velocidade, prazo de entrega ou data de ruptura.** Item com pouco histórico aparece como "Pouco histórico" pelo nome.
6. **Item sem venda em 28 dias nunca é sugestão de compra.** Vai para "Parados" com o dinheiro empatado.
7. **Sempre descontar o que já está pedido** e ainda não chegou.
8. **Sempre em reais.** Toda sugestão mostra a quantidade e o custo em R$ (`formatMoney`); o dono decide dinheiro, não unidades.
9. **Duas aprovações separadas.** Aprovar a lista de compras é decidir o que pedir; enviar o pedido ao fornecedor é gastar dinheiro e relação. Nada vai ao fornecedor sem o "Enviar" do dono, por fornecedor.
10. **A conta bate com o pedido.** O recebimento dá entrada no estoque e cria a conta a pagar ligada ao pedido; a tela compara pedido, recebido e cobrado antes de o dono aceitar a conta.
11. **O que vem do fornecedor é dado, não instrução.** Troca de peça, de preço ou de conta bancária vira aviso ao dono, nunca ação automática.

## Regras brasileiras

- Formato brasileiro, CNPJ do fornecedor (validado e guardado sem máscara), telefone com `PhoneInput` e link `wa.me`. (Se a skill `padroes-brasil` estiver instalada, ela manda nisso.) O específico daqui: dinheiro em `money` com conta em centavos inteiros (`Math.round(v*100)`) e exibição por `formatMoney`; quantidades com vírgula decimal ("4,1 por dia") via `Intl.NumberFormat('pt-BR')`.
- Datas: `date` guarda `aaaa-mm-dd` do dia local (`America/Sao_Paulo` por padrão, ou o fuso do negócio quando o dono informar), exibe dd/mm/aaaa com `formatDate`; contas de dias com `date-fns` (`differenceInCalendarDays`, `addDays`); nunca cortar `toISOString()`; `<DatePicker>` nos formulários.
- Nota do fornecedor: o app registra número, chave de 44 dígitos da NF-e e o arquivo; não emite nota.
- Pagamento a fornecedor é feito fora do app; o app registra a baixa com comprovante.

Aplique `references/modelo-de-dados.md`, `references/calculo-de-reposicao.md`, `references/sazonalidade-e-armadilhas.md` e `references/compras-e-recebimento.md`. Onde cada coisa vive na plataforma: `references/fabapp-cli.md`.

## A conversa: o que perguntar ao dono

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Até 6 perguntas desta skill; pule as que o pedido já respondeu. Em português simples:
1. "O que você controla no estoque?" Opções: "Produtos que eu vendo (Recomendado)", "Insumos e peças que eu uso no serviço", "Os dois".
2. "Como as vendas vão chegar ao estoque?" Opções: "Lanço a venda no próprio app (Recomendado)", "Importo uma planilha de vendas de vez em quando", "Já uso outro app para vender (ex.: Shopify)".
3. "Seus produtos têm variações, como tamanho, cor ou voltagem?" Opções: "Não (Recomendado)", "Sim, e cada variação tem estoque próprio".
4. "Você vende em mais de um endereço ou depósito?" Opções: "Não, é um estoque só (Recomendado)", "Sim, cada loja tem seu estoque".
5. "Como você faz o pedido ao fornecedor hoje?" Opções: "Pelo WhatsApp (Recomendado)", "Por e-mail", "Por telefone ou no balcão".
6. "Tem época do ano em que vende muito mais?" Opções: "Não sei ainda (Recomendado)", "Sim, e eu sei mais ou menos quanto", "Não, é igual o ano todo".

Suposições sem perguntar: meta de 60 dias de cobertura mais o prazo de entrega; margem de segurança de 7 dias ou metade do prazo (até 30); aviso diário no horário da plataforma (o dono não escolhe a hora); equipe só o dono. Com vários endereços: anote que o cálculo é por endereço e que a primeira versão cobre um endereço, com os outros como próximo passo.

O app é privado, com abas embaixo. Anote em `DECISOES.md` as respostas, as suposições e as decisões fixas 1, 3, 6, 7, 9 e 10 com as palavras do dono.

**Marca:** esta skill não impõe cor nem fonte. No terminal você define: proponha paleta, par tipográfico e raio, peça aprovação e grave em `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`), enviado com `fabapp push`. No código, só tokens do tema. O logo o dono sobe no Studio.

## O plano: telas, modelos e lista de conferência

Escreva o plano como texto e mostre ao dono antes de codar; ele aprova antes da construção. O plano traz telas, modelo de dados, as decisões desta skill, suposições com alternativa, o que não entra e a lista de conferência.

Abas: **Repor agora**, **Estoque**, **Compras**, **Fornecedores**, **Mais** (inventário, parados, contas a pagar, configurações).

Telas:
1. **Repor agora**: topo com o total em R$ a comprar e a contagem de itens que acabam antes de o pedido chegar (`StatCard`); grupos na ordem "Já vai faltar", "Pedir agora", "Pedir em breve", "Em observação (temporada)", "Pouco histórico"; cada linha com velocidade 7 e 28 dias, saldo, a caminho, dias de cobertura, data estimada de ruptura, prazo, quantidade sugerida, custo, e a explicação aberta com um toque. Seleção e "Montar pedidos" (agrupa por fornecedor).
2. **Estoque**: busca por nome ou código, saldo, custo, valor em estoque; ficha do item com linha do tempo das movimentações e botões "Entrada", "Saída", "Ajuste".
3. **Compras**: pedidos por situação; pedido com itens, total, frete, prazo; "Enviar ao fornecedor" (rascunho aprovado); "Receber".
4. **Recebimento**: por linha, quantidade recebida e preço cobrado; número da nota do fornecedor; conferência pedido x recebido x cobrado; gera entradas e a conta a pagar.
5. **Parados**: sem venda em 28 dias, mais de 120 dias de cobertura, sem movimento em 90 dias; total em R$ empatado e sugestão (liquidar, montar kit, dar desconto).
6. **Inventário**: contagem por lista, diferença, fechar com ajustes.
7. **Contas a pagar**: vencimentos, conferência com o pedido, "Marcar paga" com comprovante.
8. **Fornecedores**: contato, prazo de entrega, pedido mínimo, condições.
9. **Configurações**: meta de cobertura, temporadas, dados de quem compra.

**Lista de conferência** (todos os itens entram, sem teto):
- código: saldo só muda por `stock_movement`; nenhum formulário edita `on_hand`; ajuste e perda exigem motivo.
- código: movimentações sem editar nem apagar na tela; correção é nova movimentação.
- código: `src/lib/stock/` implementa as fórmulas de `references/calculo-de-reposicao.md` com os mesmos nomes.
- código: a velocidade exclui os dias com saldo zero e as vendas marcadas como atacado pontual.
- código: item sem venda em 28 dias não aparece em "Repor agora" e aparece em "Parados" com o valor em R$.
- código: a quantidade sugerida desconta o que está pedido e não chegou, e arredonda para a embalagem do fornecedor.
- código: toda linha de sugestão mostra quantidade e custo em R$ com `formatMoney`.
- código: enviar pedido exige aprovação por fornecedor com total em R$ antes; nada é enviado em automação.
- código: receber pedido cria as entradas e uma conta a pagar ligada ao pedido, e mostra as diferenças de quantidade e preço.
- código: automação `schedule` diária para `admin` com link para `/repor`.
- visual: toda lista tem estado vazio com uma ação; carregando com `Skeleton`, erro com `e.message` e "Tentar de novo".

Em "o que não vamos construir": compra automática, baixa por receita, emissão de nota, pagamento ao fornecedor pelo app.

## A construção: como implementar

As decisões desta skill são requisitos; siga o plano ao pé da letra. Ordem: schema e automações (`fabapp push`), depois tema, depois código (`fabapp deploy`).

**Schema**: `fabapp pull`, edite `fab.schema.json` com `references/modelo-de-dados.md`, `currency: "BRL"`, `locale: "pt-BR"`, e envie com `fabapp push` (ou `fabapp_write_definition` pelo MCP). Com variações, cada variação é um item com código próprio e `group` com o nome do produto (a velocidade é por variação). Papel `stock` quando há equipe.

**Domínio** em `src/lib/stock/`: `history.ts` (reconstrói o saldo dia a dia andando para trás a partir do `on_hand` e das movimentações, para saber os dias sem estoque), `velocity.ts`, `reorder.ts` (cobertura, margem, situação, ponto de pedido, quantidade, embalagem, mínimo do fornecedor), `season.ts`, `slow.ts`, `quality.ts` (conferências de dados), `money.ts` (centavos). As telas só chamam essas funções.

**Leituras**: movimentações dos últimos 400 dias (ou 90 sem temporada) com `fields` mínimos (`product`, `type`, `quantity`, `date`, `is_bulk`, `sold_on`), paginadas até o fim, agrupadas por item no navegador; memorize o resultado na sessão e recalcule ao voltar para a tela. Filtro e ordem no servidor; busca com debounce de 300 ms.

**Gravar movimentação**: cria `stock_movement` e depois atualiza `on_hand` do item com o saldo recalculado a partir do cache anterior mais a quantidade (nunca digitado). Saída maior que o saldo pede confirmação e marca "Saldo negativo, confira a contagem". Movimentações em lote (recebimento, fechamento de inventário) usam `bulkCreate`.

**Vendas**: se o app vende (tem `order`/`order_item` ou tela de venda), cada venda confirmada gera saída; se a venda é importada, `CsvImport` de vendas com `sku, data, quantidade` vira saídas em lote, com o mapeamento de colunas mostrado antes; com Shopify ligado, `integrations.call('shopify','listOrders')` importa pedidos pagos, sem cancelados e reembolsados, por botão "Buscar vendas", nunca sozinho.

**Pedido e recebimento**: `references/compras-e-recebimento.md` inteiro (estrutura do pedido, mensagem, aprovação por fornecedor, mínimo do fornecedor, substituição, recebimento parcial, conferência de três vias, conta a pagar).

**Mensagens ao fornecedor**: WhatsApp pela integração (`integrations.call('whatsapp','sendMessage',{to, body})`) ou link `wa.me` com o texto pronto e a pergunta "Enviou?"; e-mail por `notify('email', ...)` seguindo as regras do e-mail do app (texto puro, sem URL no corpo; 429 = limite do dia, ofereça WhatsApp ou copiar). Página de impressão do pedido para salvar em PDF pelo navegador. Botão opcional "Escrever no meu jeito" com `invokeLLM({tier:'fast'})` e a amostra de mensagens do dono; sem amostra, texto neutro e a tela diz isso; 402 cai no texto neutro.

**Automações** (`fab.automations.json`: `fabapp pull`, edite, envie o conjunto inteiro com `fabapp push`), só `notify`:
- `schedule` `daily` para `admin` (e `role:stock`) em `inapp` e `push`: "Confira o que repor hoje", link `/repor`. A conta é feita quando a tela abre.
- `relative` em `purchase_order.expected_date`, `offset_days: 1`, para `admin`: "Pedido {{code}} de {{supplier}} era para ontem. Se já chegou, dê entrada", link `/compras/{{id}}`.
- `relative` em `payable.due_date`, `offset_days: -2`, para `admin`: "Conta de {{supplier}} vence em 2 dias. Se já pagou, desconsidere", link `/contas/{{id}}`.
- `relative` em `season.decide_by`, `offset_days: 0`: "Hora de decidir a compra da temporada {{name}}", link `/repor`.

**Dados de exemplo**: o CLI não grava registros. Deixe o conjunto numa constante e um botão "Carregar exemplos" (só admin, com prévia e contagem) que grava pelo próprio app com `bulkCreate`, tudo marcado "Exemplo": 3 fornecedores com prazos 3, 10 e 30 dias, 12 itens (um campeão de vendas perto de acabar, um com pico de uma semana por venda de atacado, um sem venda há 40 dias, um novo com 10 dias, um com 150 dias de cobertura), cerca de 150 movimentações em 60 dias com um período de falta, 1 pedido a caminho e 1 recebido com conta a pagar. O dono também pode cadastrar ou importar pelo CMS do Studio. Nunca diga que você criou dados.

**Visual**: situação em `Badge` com tokens do tema (`bg-destructive/10 text-destructive` para "Já vai faltar", `bg-primary/10 text-primary-text` para "Pedir agora", `bg-muted` para os demais); números `tabular-nums` alinhados à direita; `AlertDialog` para enviar pedido, fechar inventário e aceitar conta com diferença; toast para sucesso.

## Conferir antes de dizer pronto

Rode `fabapp dev`, abra a pré-visualização e percorra cada item da lista de conferência (rota, elemento, estado), no celular e no desktop. Confira por busca (`grep`) em `src/`: nenhum hex nem neutro fixo, nenhum `window.confirm`, `alert(` ou `prompt(`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`, nenhum envio dentro de `useEffect`. Confira que `fab.automations.json` só cita modelos e campos do schema. Depois `fabapp deploy`: `account_builds_busy` (409) é esperar e repetir; `build_failed` (422) é consertar arquivo e linha indicados, sem repetir às cegas.

Na mensagem final ao dono, relate só o que conferiu, o link, e diga que as datas ficam confiáveis depois de 28 dias de vendas lançadas (antes disso o app mostra "Pouco histórico"). O que ele faz no Studio: ligar WhatsApp se quiser mandar pedido sem abrir o celular (sem isso o app abre o WhatsApp com o texto pronto); subir o logo; cadastrar ou importar dados no CMS, se não usar os botões do app. Próximos pedidos: importar vendas antigas de planilha, pagamento de contas a fornecedor, estoque por loja.

## Mudanças depois: pedidos comuns do dono

Leia `DECISOES.md` antes e atualize depois.

- "Compra sozinho quando acabar": explique que o app avisa e monta o pedido, e ele envia com um toque; compra automática gastaria dinheiro sem ninguém olhar o pico, o parado e o que já está a caminho.
- "Muda o estoque desse item para 20": faça por "Ajuste" com motivo (ou inventário), nunca editando o saldo.
- "Esse item vende mais no verão": registre uma temporada com fator informado pelo dono e a etiqueta "estimativa sua", conforme `references/sazonalidade-e-armadilhas.md`.
- "Quero 90 dias de estoque": mude a meta nas Configurações e mostre o efeito em R$ na lista.
- "O fornecedor mandou outra peça": registre a substituição no recebimento com os dois códigos e deixe o dono aceitar ou recusar.
- Antes de mudar modelo, rode `fabapp pull`, leia o `fab.schema.json` atual e use os nomes que estão lá; anote mudanças de regra em `DECISOES.md`.

## Não fazer

- Não inventar velocidade, prazo ou data de ruptura; não aplicar temporada sem 400 dias de histórico ou sem o número do dono.
- Não contar dia sem estoque como dia sem procura.
- Não sugerir compra de item sem venda em 28 dias nem calcular cobertura para ele.
- Não dimensionar compra sem descontar o que está a caminho; não arredondar para o mínimo do fornecedor em silêncio.
- Não mostrar unidades sem reais.
- Não enviar pedido nem mensagem sem aprovação; não tratar a aprovação da lista como aprovação do envio.
- Não editar nem apagar movimentação; não deixar saldo digitável.
- Não pagar nada pelo app nem aceitar troca de dados bancários do fornecedor sem o dono confirmar por telefone.
- Não somar no servidor nem prometer relatório que dependa disso.
