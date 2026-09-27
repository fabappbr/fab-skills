# Regras brasileiras e recebimento

## Documentos e contato

- **CPF**: 11 dígitos, guardar só dígitos, exibir `000.000.000-00`. Rejeitar todos iguais. DV1: soma de `d[i] × (10 − i)` para i = 0..8; `r = soma % 11`; `dv = r < 2 ? 0 : 11 − r`. DV2: mesmo cálculo com pesos 11..2 sobre os 10 primeiros.
- **CNPJ**: 14 caracteres; os 12 primeiros podem ter letras (CNPJ alfanumérico da Receita a partir de julho de 2026), os 2 últimos são dígitos. Guardar em maiúsculas sem máscara, exibir `00.000.000/0000-00`. Valor de cada caractere = código ASCII − 48 (dígito vale ele mesmo; A vale 17). DV1 com pesos `5,4,3,2,9,8,7,6,5,4,3,2` sobre os 12 primeiros; DV2 com `6,5,4,3,2,9,8,7,6,5,4,3,2` sobre os 13; `r = soma % 11`; `dv = r < 2 ? 0 : 11 − r`. Nunca guardar como número.
- `person_type` decide qual documento o formulário pede. Documento único: `count({ document })` antes de criar.
- **Telefone**: `PhoneInput`; guardar E.164 `+55DDNNNNNNNNN`; celular tem 9 dígitos começando em 9. Exibir `(11) 91234-5678`. Link do WhatsApp: `https://wa.me/55` + DDD + número, só dígitos.
- **LGPD**: dado de cliente nunca é público; cada pessoa vê só o que é dela; mensagem de cobrança só trata da dívida (nada de propaganda junto). A pedido do cliente, o admin exporta a ficha dele (`CsvExport` filtrado).
- **Cobrança (Código de Defesa do Consumidor, art. 42)**: quem deve não pode ser exposto ao ridículo, constrangido ou ameaçado. Por isso: mensagem só para o próprio cliente, nunca em grupo, sem ameaça, sem expor a dívida a terceiros.
- **Multa e juros**: multa de mora limitada a 2% em relação de consumo (CDC, art. 52); juros de mora de 1% ao mês é o padrão usado. Só se o dono ligar e se estiver no contrato dele.

## Pix na chave do dono (sem gateway)

O app gera o código Pix copia e cola estático (BR Code) e o QR (`qrcode`, já instalado) com o valor do saldo. Confirmação é pela baixa manual com comprovante, porque não há aviso do banco.

Montagem (cada campo = id de 2 dígitos + tamanho com 2 dígitos + valor):
```
00 02 "01"
26 xx [ 00 14 "br.gov.bcb.pix" | 01 nn <chave> | 02 nn <descrição curta, opcional> ]
52 04 "0000"
53 03 "986"
54 nn <valor com ponto e 2 casas, ex. "450.00"; opcional: sem o campo 54 o QR sai sem valor e o pagador digita (é o caso da página /pagamento)>
58 02 "BR"
59 nn <nome do recebedor, até 25, sem acento>
60 nn <cidade, até 15, sem acento>
62 xx [ 05 nn <txid: só letras e números, até 25; use o código da fatura sem hífen, ex. "FAT0012"; sem código, use "***"> ]
63 04 <CRC16>
```
CRC16-CCITT (polinômio 0x1021, valor inicial 0xFFFF, sem reflexão) calculado sobre o texto inteiro terminado em `6304`, em 4 caracteres hexadecimais maiúsculos. Teste de mesa que o código deve passar: chave `123e4567-e12b-12d1-a456-426655440000`, nome `Fulano de Tal`, cidade `BRASILIA`, txid `***`, sem valor, dá `...6304` + `1D3D` (exemplo do Banco Central). Chave: CPF/CNPJ só dígitos, telefone `+55...`, e-mail minúsculo, aleatória como veio. Remova acentos de nome e cidade. Critério visual: o dono lê o QR da primeira fatura no app do banco e confere nome e valor antes de usar.

## Link de pagamento pelo gateway (cartão ou Pix)

Só com área do cliente (o pagamento pede usuário logado) e com o gateway conectado no Studio (Stripe, Pagar.me ou Mercado Pago).

1. Página "Minhas faturas": o cliente vê as faturas com `payer` igual ao id dele.
2. Botão "Pagar R$ X": `const checkout = useCheckout(); const { redirect_url } = await checkout({ items: [{ model_id: 'invoice', record_id: fatura.id }], successUrl: origin + '/minhas-faturas/' + fatura.id + '?retorno=1', cancelUrl: origin + '/minhas-faturas/' + fatura.id }); location.href = redirect_url;` (acrescente `paymentMethods: ['credit_card', 'pix']` só quando o dono pediu Pix explicitamente; vazio, o gateway oferece o que tem). Sem `<SubscribeGate>` (é para assinatura de conteúdo digital no app nativo; fatura de serviço não passa pela loja).
3. A plataforma cobra o `price` (saldo) lido do registro no servidor; o valor nunca sai do navegador. Por isso `price` precisa estar sempre igual ao saldo.
4. Confirmação: o webhook do gateway, tratado pela plataforma, grava no registro o `status` com a opção `paid` (procura o literal `paid` nas opções do enum) e carimba `paid_at` quando o campo existe. Pix pode levar minutos: a página de retorno mostra "Pagamento em confirmação" e acompanha com `useLive` até virar paga; nunca marca paga sozinha, nunca libera nada pelo simples retorno.
5. Cartões salvos do cliente: `<PaymentMethods/>` pronto, na área do cliente; nunca formulário próprio de cartão.
6. Pagamento recusado ou abandonado: a fatura continua em aberto; a tela oferece tentar de novo ou o Pix na chave.

Regras que vêm das boas práticas do gateway:
- Confirmação só pelo evento do gateway; a página de sucesso pode nunca carregar (cliente fecha o app depois de pagar).
- Método de pagamento assíncrono (Pix) confirma depois: "concluído" no navegador não é "pago".
- Não restringir métodos sem motivo: `paymentMethods` vazio oferece tudo que o gateway tem.
- Teste primeiro no modo de teste do gateway, com uma fatura de exemplo, antes de mandar a cliente real.
- Chave do gateway nunca aparece no app: fica na plataforma. Nada de função própria, chamada direta ao gateway ou webhook próprio.
- Mensalidade renovada sozinha é `useSubscribe` e só no cartão (Pix não renova sozinho); ela serve para vender acesso ao próprio app, com um `plan` por faixa de preço e `interval` mês ou ano. Mensalidade de serviço (academia, escola, contador) é contrato + fatura do mês + régua.
- Assinatura comprada na loja do celular só se cancela na loja (`openStoreSubscriptions`).

## Boleto

O app não gera boleto. Se o dono emite boleto no banco, registra o número na descrição da fatura e dá baixa manual com forma `bank_slip` quando cair.

## Nota fiscal (registro, não emissão)

- Serviço (salão, clínica, escola, consultoria, oficina de mão de obra): NFS-e, da prefeitura ou do emissor nacional. Produto: NF-e (venda entre empresas, entrega) ou NFC-e (venda ao consumidor no balcão).
- O app guarda: tipo, número, série, chave de acesso (NF-e e NFC-e têm 44 dígitos; valide o tamanho), código de verificação da NFS-e municipal, data, valor, situação e os arquivos PDF e XML (`FileUpload`, privados).
- Leitura do PDF da nota (opcional): `extractData({fileId, prompt, schema})` preenche número, chave, data e valor para o dono conferir antes de salvar.
- Nunca inventar número ou chave. Emissão automática só por integração ou emissor externo que o dono já tenha (fora deste app).
