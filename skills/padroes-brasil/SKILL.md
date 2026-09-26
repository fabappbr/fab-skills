---
name: padroes-brasil
description: "Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli): faz o app nascer com a base brasileira certa: CPF e CNPJ validados (inclusive o CNPJ novo com letras), telefone com DDD e botão de WhatsApp, CEP que preenche o endereço, dinheiro em R$ 1.234,56 sem erro de centavo, datas dd/mm/aaaa em 24h no fuso de Brasília, feriados, Pix pelo pagamento integrado, LGPD (consentimento, exportar e apagar dados, dado de saúde protegido) e o lugar da nota fiscal. Use em QUALQUER app de negócio brasileiro que cadastre clientes, pacientes, alunos, fornecedores, pedidos, orçamentos, cobranças ou agendamentos: CRM, loja, delivery, clínica, salão, academia, escola, imobiliária, oficina, MEI. Use também quando o dono disser: cadastro com CPF, pedir o CNPJ, buscar endereço pelo CEP, mandar no zap, botão do WhatsApp, receber no Pix, preço em reais, LGPD, política de privacidade, anamnese, guardar a nota fiscal, feriado, horário de Brasília. Na dúvida, use: quase todo app brasileiro toca um destes pontos."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Padrões do Brasil
  edition: terminal
---

# Padrões do Brasil

Esta skill fixa como um app feito para negócio brasileiro guarda, valida e mostra documento, telefone, endereço, dinheiro, data, pagamento e dado pessoal. Cada regra abaixo é uma decisão tomada: aplique como está. O código pronto das validações está em `references/codigo-br.md` (arquivo `src/lib/br.ts`, testado). As regras de LGPD, Pix e nota fiscal em detalhe estão em `references/lgpd-pix-nota-fiscal.md`.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create` ou `link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.


Princípio que vale para tudo: **guardar limpo, validar na entrada, mostrar no formato brasileiro.** O banco guarda só dígitos (ou o formato internacional), o formulário valida com `zod` antes de salvar, e a tela formata na hora de exibir. Máscara nunca vai para o banco.

A plataforma não tem validador customizado nem restrição de unicidade no servidor: toda validação desta skill roda no cliente, no formulário, com `zod`, e toda checagem de duplicidade é um `count({ campo_normalizado: valor })` antes do `create`.

## O plano: o que entra no modelo de dados e na lista de conferência

### Decisões de schema (escreva no plano que você mostra ao dono como decisão, não como referência a esta skill)

| Dado | Campo no schema | Regra |
|---|---|---|
| Moeda e idioma do app | `currency: "BRL"`, `locale: "pt-BR"` na raiz do `fab.schema.json` | Sempre, para negócio no Brasil. É o que faz `formatMoney` e `formatDate` saírem no padrão brasileiro. |
| Tipo de pessoa | `person_type`, `enum` com `[{value:"pf",label:"Pessoa física"},{value:"pj",label:"Pessoa jurídica"}]` | Só quando o app atende PF e PJ. Ele decide qual documento o formulário pede. |
| CPF | `cpf`, `text` | 11 dígitos, sem ponto e traço. |
| CNPJ | `cnpj`, `text` | 14 caracteres, letras maiúsculas e dígitos, sem pontuação. Nunca `number`: o CNPJ agora pode ter letras. |
| Razão social e nome fantasia | `legal_name`, `trade_name`, `text` | Só para PJ. |
| Telefone | `phone`, tipo `phone` | Formato internacional `+5511912345678`. |
| WhatsApp | `is_whatsapp`, `boolean` | Marca se o número recebe WhatsApp. Padrão: ligado para celular. |
| Aceite de marketing | `marketing_opt_in` `boolean`, `marketing_opt_in_at` `datetime`, `marketing_opt_in_channel` `enum` (`form`, `whatsapp`, `balcao`, `importacao`, `app`), `marketing_opted_out_at` `datetime` (descadastro; bloqueia marketing) | Separado do aceite dos termos. Começa desligado. Estes são os nomes que as skills de retenção, CRM e avaliações usam. |
| Endereço | `cep` `text`, `street` `text`, `number` `text`, `complement` `text`, `district` `text`, `city` `text`, `state` `enum` com as 27 UFs | `number` é texto ("S/N", "120A"). Quando o dono liga o Google Maps e o app precisa de mapa ou distância, acrescente um campo `geo`. |
| Dinheiro | tipo `money` | Valor em reais (ex. `1234.56`). Contas feitas em centavos (ver "A construção"). |
| Data sem hora (vencimento, nascimento) | tipo `date` | Nunca `datetime` para data pura. |
| Momento (agendamento, pedido) | tipo `datetime` | Mostrado em 24h no fuso do negócio. |
| Dado de saúde (anamnese, alergia, lesão, prontuário, medicação) | modelo PRÓPRIO, ligado ao cliente por `ref` | Acesso restrito por papel (ver LGPD). Nunca campos soltos no cadastro do cliente. |
| Nota fiscal | modelo `invoice` (ver `references/lgpd-pix-nota-fiscal.md`) | O app guarda a nota; não emite. |

- **Documento único por empresa.** O plano diz qual chave identifica o cliente (CPF/CNPJ quando o app pede; senão telefone; senão e-mail). O formulário confere duplicidade antes de criar. Em app com várias empresas (`organization`), a checagem filtra pela empresa atual.
- **CPF obrigatório só quando o negócio precisa dele** (nota fiscal, contrato, cobrança recorrente, matrícula). Em cadastro de lead, agendamento de salão ou pedido de delivery, CPF é opcional: pedir dado sem finalidade vai contra a LGPD e derruba conversão.
- **Registre no plano o que o app NÃO faz**, na seção "o que NÃO vamos construir", quando o pedido tocar nisso: "o app não emite nota fiscal (guarda a nota emitida no emissor do dono)"; "o app não calcula imposto"; "boleto não está disponível como forma de pagamento do app".

### Lista de conferência

O plano termina com a lista de conferência: os itens que você confere antes de dizer pronto, sem teto de quantidade. Entre os abaixo, entram todos os que o app usa. Todos se conferem no código (leitura e `grep`, veja "Conferir antes de dizer pronto"); os de formulário, também na pré-visualização.

1. "O formulário de cliente valida o CPF (ou CNPJ, conforme o tipo de pessoa) pelo dígito verificador antes de salvar e guarda só os caracteres, sem máscara."
2. "O CNPJ aceita letras e é guardado em maiúsculas; a validação usa o cálculo alfanumérico."
3. "Telefones usam `PhoneInput` e são guardados como +55DDDNÚMERO; o cadastro tem o botão 'Chamar no WhatsApp' que abre wa.me."
4. "Digitar um CEP de 8 dígitos preenche rua, bairro, cidade e UF; se a busca falhar, os campos continuam editáveis."
5. "Todo valor em dinheiro aparece como R$ 1.234,56 por `formatMoney`, e totais são somados em centavos."
6. "Toda data aparece em dd/mm/aaaa e toda hora em 24h por `formatDate`/`formatDateTime`; datas usam `<DatePicker>`."
7. "O aceite de marketing é uma caixa separada, desmarcada, e grava data e canal do aceite."
8. "O modelo de dados de saúde só pode ser lido e alterado pelo papel dos profissionais."
9. "A tela do cliente tem 'Exportar dados' e 'Anonimizar' para o administrador."
10. "A página /privacidade existe e está no rodapé, com marcadores para o dono preencher o que falta."
11. "A liberação de pedido pago depende do status gravado pela plataforma, nunca do retorno do navegador."

## A construção: como implementar cada padrão

Crie `src/lib/br.ts` copiando o código de `references/codigo-br.md` inteiro (é código testado; não reescreva de cabeça). Todo formulário e toda tela usa essas funções.

### CPF e CNPJ

- Campo com máscara durante a digitação (`formatCpf` / `formatCnpj` no `onChange` do valor exibido) e valor salvo limpo (`onlyDigits` para CPF, `normalizeCnpj` para CNPJ).
- Validação no `zod`: `z.string().refine(isValidCpf, "CPF inválido. Confira os números.")` e `z.string().refine(isValidCnpj, "CNPJ inválido. Confira os números e letras.")`. Campo opcional aceita vazio: `.optional().or(z.literal(""))` antes do `refine`, e só valida quando preenchido.
- **CNPJ com letras.** A Receita emite CNPJ alfanumérico desde 31/07/2026 (as 12 primeiras posições podem ter letras de A a Z; os 2 dígitos finais continuam números). O campo aceita letras, transforma em maiúsculas e nunca usa `inputMode="numeric"`. CNPJs antigos, só com números, continuam válidos na mesma função.
- CPF usa `inputMode="numeric"`.
- Com `person_type`, o formulário mostra CPF quando é "pf" e CNPJ + razão social quando é "pj". Troque o rótulo junto: "CPF" / "CNPJ".
- **Duplicidade antes de criar:** `const n = await collection('client').count({ cpf: cpfLimpo })`; se `n > 0`, não crie e mostre "Já existe um cliente com este CPF." com link para abrir o cadastro existente. Ao editar um cliente, ignore o próprio registro.
- Exibição: `formatCpf(c.cpf)`, `formatCnpj(c.cnpj)`. Em lista pública ou tela que outra pessoa vê, mascare o CPF: `***.982.247-**`.
- Busca por documento: normalize o que foi digitado antes do filtro (`{ cpf: onlyDigits(q) }`), porque o banco guarda sem pontuação.

### Telefone e WhatsApp

- Formulário usa `<PhoneInput defaultCountry="BR" countrySelector={false} />` quando o negócio atende só no Brasil (padrão); mantenha o seletor de país só se o dono citar cliente estrangeiro. O valor já sai em `+55...`.
- Validação no `zod`: `z.string().refine((v) => !!parseBrPhone(v), "Telefone inválido. Use DDD + número, ex.: (11) 91234-5678.")`. A função confere DDD existente, celular com 9 dígitos começando em 9 e fixo com 8 dígitos começando de 2 a 5.
- Exibição: `formatBrPhone(p)` mostra `(11) 91234-5678`.
- **Botão "Chamar no WhatsApp"** em todo cadastro de pessoa com celular: `<a href={whatsappLink(phone, texto)} target="_blank" rel="noopener">`, com o ícone `MessageCircle` do lucide. O texto vem pronto e editável, com o nome da pessoa ("Olá, Maria! Aqui é da ..."). Se `whatsappLink` devolve `null` (fixo ou número inválido), o botão não aparece. Sem integração de WhatsApp ligada no Studio, o link wa.me é o caminho; com a integração ligada, envio automático usa `integrations.call('whatsapp', 'sendMessage', ...)` só para mensagem de serviço (confirmação, lembrete, status).
- **Marketing só com aceite.** Mensagem de promoção, cupom ou campanha vai só para quem tem `marketing_opt_in = true` (a tela de envio filtra por isso no servidor) e todo texto de marketing termina com a saída: "Para não receber mais, responda SAIR." Mensagem de serviço (confirmação do que a pessoa pediu) não precisa do aceite.
- Chave de busca e de importação: o telefone já normalizado em `+55...`.

### CEP e endereço

- Campo CEP com `formatCep`, `inputMode="numeric"`. Quando chega a 8 dígitos válidos, chame `lookupCep` e preencha rua, bairro, cidade e UF. Mostre um `Spinner` pequeno ao lado durante a busca.
- A consulta vai direto do navegador ao ViaCEP (serviço público e gratuito, aceita chamada de qualquer site); só o CEP sai do app, nenhum dado da pessoa. Se voltar `null` (CEP não existe, sem internet, serviço fora), mostre abaixo do campo "Não achamos este CEP. Preencha o endereço abaixo." e deixe tudo editável. Os campos preenchidos continuam editáveis sempre.
- Depois de preencher, o foco vai para "Número", que o CEP nunca traz.
- `AddressInput` é outra coisa: é o autocompletar do Google Maps (só funciona quando o dono liga o Maps; sem ele vira texto simples) e devolve `{address, lat, lng}` para campo `geo`. Use `AddressInput` quando o app precisa de localização no mapa (entrega por distância, mapa de imóveis); use o CEP + campos separados quando precisa de endereço para cadastro, entrega ou nota. Os dois podem conviver.
- UF é `Select` com as 27 siglas, não texto livre.
- Exibição em uma linha: `Rua Tal, 120, apto 3, Bela Vista, São Paulo/SP, 01310-100`.

### Dinheiro

- Formulário usa `<CurrencyInput currency="BRL" locale="pt-BR" />`. Exibição usa `formatMoney(valor)`, que sai `R$ 1.234,56`. Nunca `toFixed`, nunca "R$" colado à mão, nunca ponto como separador decimal na tela.
- **Conta em centavos.** Soma, desconto, parcela e total usam `sumMoney`, `lineTotal`, `applyDiscountPercent`, `splitInstallments` de `br.ts`. Somar `0.1 + 0.2` em float dá `0.30000000000000004`; em centavos, dá certo. Parcelas: a diferença de centavo vai na primeira parcela, e a soma das parcelas é sempre igual ao total.
- Painel de faturamento soma no cliente a partir de `list` paginado (não existe soma no servidor), sempre com `sumMoney`.
- Preço que o dono não informou não é inventado: o campo fica vazio e a tela mostra "Preço a definir" ou "Sob consulta".

### Datas, horas e fuso

- Exibição só por `formatDate` (dd/mm/aaaa) e `formatDateTime` (dd/mm/aaaa, 14:30). Hora em 24h, sem "AM/PM". Entrada de data só por `<DatePicker>`.
- **Fuso.** Negócio com endereço fixo mostra horário no fuso dele. Passe `{ dateStyle: 'short', timeStyle: 'short', timeZone: 'America/Sao_Paulo' }` no `formatDateTime` de agenda e pedido (troque pelo fuso do negócio quando o dono for de Manaus, Cuiabá, Rio Branco, Noronha etc.). Assim o cliente que abre de outro estado vê o horário do atendimento, não o do celular dele.
- "Hoje" é `todayBr()` (aaaa-mm-dd no fuso de Brasília). Nunca `new Date().toISOString().slice(0, 10)`: em UTC, depois das 21h já é o dia seguinte.
- Dia da semana e mês por extenso, quando aparecer, em português e minúsculo ("segunda-feira, 5 de outubro"), com `formatDate(d, { weekday: 'long', day: 'numeric', month: 'long' })`.

### Feriados

- App com agenda, prazo em dias úteis ou horário de funcionamento usa `nationalHolidays(ano)` de `br.ts`: os 10 feriados nacionais (incluindo 20 de novembro, nacional desde 2024) e, como pontos facultativos, Carnaval e Corpus Christi.
- Na agenda, dia de feriado aparece marcado com o nome. Decisão padrão: feriado nacional fecha a agenda para novos horários; ponto facultativo fica aberto e só marcado. O dono muda isso por dia.
- Feriado estadual e municipal muda por cidade: o app tem o modelo `closed_day` (`date`, `reason`) para o dono cadastrar esses dias e as folgas. Não invente feriado local.

### Pix e pagamento

- Pix só existe no app pelo pagamento integrado (Stripe, Pagar.me ou Mercado Pago, que o dono conecta no Studio), na compra avulsa por `useCheckout`. `paymentMethods` fica vazio por padrão (o gateway oferece o que tem); `['credit_card', 'pix']` só quando o dono pediu Pix explicitamente. Pix não entra em assinatura (`useSubscribe` é cartão).
- **Confirmação é da plataforma.** O pedido nasce `pending`; quem muda para pago é o webhook do gateway, que a plataforma já trata (ela marca `paid` no registro cobrado, `record_id`). A tela de retorno ("Obrigado") só LÊ o status do pedido e, enquanto for `pending`, mostra "Aguardando confirmação do pagamento" e acompanha por `useLive`. Nunca libere conteúdo, nunca marque como pago e nunca mostre "Pagamento aprovado" a partir do redirect, de um parâmetro na URL ou de um botão "Já paguei". Baixa manual feita por admin ou financeiro com comprovante é permitida e grava um `payment`. Nunca escreva webhook próprio de pagamento.
- Sem gateway conectado, o caminho real está em `references/lgpd-pix-nota-fiscal.md` (Pix manual confirmado pelo dono).
- Boleto não aparece como forma de pagamento do app; PayPal, PagSeguro, Asaas e Cielo não são integrados. Se o dono pedir, diga isso em uma frase e ofereça o que existe.

### LGPD

Aplique a seção LGPD de `references/lgpd-pix-nota-fiscal.md` inteira. O mínimo que todo app que guarda dado pessoal tem:

- Formulário pede só o que o negócio usa. Cada campo pessoal tem finalidade: se o plano não diz para que serve o dado, ele não entra.
- Caixa de aceite de marketing separada, desmarcada, com texto claro ("Quero receber novidades e promoções por WhatsApp e e-mail."). Aceite dos termos e da política, quando existir, é outra caixa. Gravar `marketing_opt_in_at` e `marketing_opt_in_channel` no momento do aceite; descadastro grava `marketing_opted_out_at` e bloqueia marketing dali em diante (o registro do descadastro fica; nunca apague o cliente por isso).
- Página `/privacidade` (rota estática, no rodapé e ao lado de todo formulário que coleta dado) com o texto-base da referência e marcadores visíveis `[Preencher: ...]` para o que só o dono sabe (razão social, CNPJ, e-mail de contato do encarregado). Nunca invente CNPJ, endereço ou nome de encarregado.
- Banner de cookies: não escreva. A plataforma injeta o aviso de cookies quando o dono liga o cartão de cookies nas integrações do Studio.
- Tela do cliente, para o administrador: "Exportar dados" (baixa um arquivo JSON com o cadastro e os registros ligados a ele) e "Anonimizar" (troca nome, documento, telefone, e-mail e endereço por valores neutros e grava `anonymized_at`, com `ConfirmDialog` que explica que não dá para desfazer). Anonimizar é `update`, não `remove`: o histórico de vendas continua valendo para o caixa, sem identificar a pessoa.
- Dado de saúde e outros dados sensíveis (religião, biometria, origem racial, vida sexual, dado de criança) ficam em modelo próprio com acesso por papel e nunca vão para lista, busca pública, e-mail ou texto de notificação.

### Nota fiscal

- O app **não emite** nota fiscal. Ele registra a nota que o dono emitiu no emissor dele (prefeitura, Sebrae, contador, sistema emissor): número, série, chave, tipo, status, data, valor, PDF e XML anexados, ligados ao pedido ou atendimento. Modelo e tela em `references/lgpd-pix-nota-fiscal.md`.
- O tipo segue o que o negócio vende: serviço (salão, clínica, academia, consultoria, oficina na mão de obra) usa NFS-e; produto em venda para empresa ou envio usa NF-e; produto no balcão para consumidor usa NFC-e. O app guarda o regime tributário do dono (MEI, Simples Nacional, Lucro Presumido, Lucro Real) nas configurações, só como informação.
- O app nunca calcula imposto (ISS, ICMS, IBS, CBS). Se o emissor devolver os valores, o app só guarda e mostra.
- Pedido "emitir nota automática": diga ao dono que o app guarda a nota e avisa quando falta emitir; a emissão automática depende de um emissor externo com API, ligado pelo dono como conector no Studio, e de uma função de backend (`functions/<nome>.ts`; o plano que libera o CLI já libera funções).

### Texto e tratamento

- Tratamento "você" em todo texto do app. Nada de "tu", "o senhor" ou "prezado cliente", a não ser que o dono peça.
- Números no padrão brasileiro: `1.234,5` (use `Intl.NumberFormat('pt-BR')`), porcentagem `12,5%`.
- Texto visível em português do Brasil: "celular", "CEP", "bairro", "estado" (não "province", "zip").

## Mudanças depois: quando o dono mexe nesses dados

- Ao acrescentar CPF, CNPJ, telefone, CEP ou dinheiro num app existente, aplique as mesmas regras da construção e crie `src/lib/br.ts` se ainda não existir (abra o arquivo antes para conferir).
- **Registros antigos com máscara.** O schema não tem migração: dados já gravados com ponto e traço continuam assim. As telas exibem com as funções de formatação (que aceitam os dois jeitos), e as buscas procuram pelo valor limpo. Para limpar o que já existe: o token do CLI não grava registros. Diga ao dono como corrigir no CMS do Studio (editar, ou exportar a planilha, limpar a coluna e importar de novo), ou ofereça uma tela de administração no app (com `<CsvImport/>` ou um botão "Limpar máscaras" que o admin logado usa, com `ConfirmDialog`). Nunca diga que "corrigiu os dados".
- Trocar CNPJ de `number` para `text` num app que já tem dados: mude o tipo no `fab.schema.json` (`fabapp push`) e confira se há registros (o dono no CMS do Studio, ou você entrando como admin na pré-visualização); CNPJ guardado como número perdeu os zeros à esquerda, então a correção completa com zeros até 14 caracteres, pelo mesmo caminho do item anterior (o dono no CMS ou a tela de administração do app).
- Pedido de "mandar WhatsApp para todos os clientes": a tela filtra `marketing_opt_in = true`; se ninguém tem o aceite gravado, explique ao dono em linguagem simples que a lei pede o aceite e ofereça a caixa de aceite no cadastro.
- Pedido de "apagar o cliente a pedido dele": use o "Anonimizar" desta skill quando houver histórico de vendas; sem histórico, `remove` resolve.

## Checklist final (plano, construção e mudanças)

- [ ] `currency: "BRL"` e `locale: "pt-BR"` no schema.
- [ ] CPF e CNPJ guardados sem máscara, validados por dígito verificador; CNPJ como texto aceitando letras.
- [ ] Duplicidade conferida com `count` antes de criar.
- [ ] Telefone em `+55...` por `PhoneInput`, validado por DDD; botão wa.me em cadastro com celular.
- [ ] CEP preenche o endereço e, se falhar, deixa digitar.
- [ ] Nenhum valor em dinheiro fora de `formatMoney`; nenhuma soma de float sem passar por centavos.
- [ ] Nenhuma data fora de `formatDate`/`formatDateTime`; nenhum `toISOString().slice(0, 10)`; `<DatePicker>` em toda data.
- [ ] Pix pelo `useCheckout` (pago só pelo status da plataforma) ou, sem gateway, Pix na chave do dono com baixa manual feita por um administrador.
- [ ] Aceite de marketing separado e registrado; `/privacidade` com marcadores; dado sensível em modelo com acesso por papel.
- [ ] Nota fiscal guardada, nunca emitida nem calculada pelo app.
- [ ] Nenhum CNPJ, endereço, preço ou nome de responsável inventado.

## Conferir antes de dizer pronto

O QA do Studio não roda no `fabapp deploy`: confira o checklist por busca no código, dentro de `.fabapp/workspace`, e revise cada ocorrência.

```bash
cd .fabapp/workspace
grep -rnE 'toISOString\(\)\.(slice|split)|type="date"' src      # data cortada em UTC ou input nativo de data
grep -rnE 'toFixed\(|R\$' src                                   # dinheiro fora de formatMoney e de br.ts
grep -rn 'inputMode="numeric"' src                             # vale em CPF e CEP, nunca no campo de CNPJ
grep -nE '"(cpf|cnpj|cep|phone)"' ../../fab.schema.json         # nenhum desses com "type": "number"
grep -rnE 'hour12|hh:mm a' src                                 # hora em 24h
grep -rn 'wa\.me' src                                          # o link sai de whatsappLink(), não montado à mão
grep -rln '@/lib/br' src                                       # br.ts existe e é usado pelos formulários
```

Depois, na pré-visualização do `fabapp dev`: um CPF e um CNPJ inválidos são recusados com a mensagem abaixo do campo; um CEP real preenche o endereço e um inexistente deixa digitar; um valor em dinheiro aparece como R$ 1.234,56; a caixa de marketing vem desmarcada; `/privacidade` abre pelo rodapé. `fabapp push` com o `currency` e o `locale`, `fabapp deploy` até `✓ Live: <url>`.

## O que o dono faz no Studio

Entregue na mensagem final, só o que o app usa:

- Conectar o gateway de pagamento (Stripe, Pagar.me ou Mercado Pago) para o Pix e o cartão funcionarem.
- Ligar o cartão de cookies nas integrações, se o app usa analytics ou pixel.
- Ligar a integração de WhatsApp, se quiser envio automático de mensagem de serviço (sem ela, o botão wa.me já funciona).
- Ligar o Google Maps, se o app usa `AddressInput` ou campo `geo`.
- Informar os dados dos marcadores `[Preencher: ...]` da `/privacidade` (razão social, CNPJ, contato do encarregado), para você completar o texto e publicar de novo. Nunca invente.
- Cadastrar, pelo próprio app ou no CMS do Studio, os dias fechados (`closed_day`) e, com Pix manual, a chave Pix (`business_settings`). Você não grava registros pelo terminal.
- Cadastrar o emissor de nota como conector, se quiser emissão automática.

Anote em `DECISOES.md` as decisões desta skill que valem para as próximas mudanças (chave de duplicidade, fuso do negócio, regra de feriado, forma de pagamento).

