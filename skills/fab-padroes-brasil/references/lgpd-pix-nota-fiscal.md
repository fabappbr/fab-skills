# LGPD, Pix e nota fiscal no app

## LGPD (Lei 13.709/2018)

### Finalidade e base legal de cada dado

Todo dado pessoal que o app guarda tem uma finalidade escrita no plano e uma base legal. A tabela fecha a base de cada caso comum; a página `/privacidade` repete isso em português simples.

| Dado e uso | Base legal | O que o app faz |
|---|---|---|
| Nome, telefone e endereço para atender o pedido ou o agendamento | Execução de contrato | Pede no formulário do pedido. Não precisa de caixa de aceite. |
| CPF/CNPJ para nota fiscal, contrato ou cobrança | Obrigação legal ou contrato | Pede só quando o app emite cobrança, contrato ou guarda nota. |
| Promoções, cupons, novidades por WhatsApp, e-mail ou SMS | Consentimento | Caixa separada, desmarcada, com data e canal gravados. Revogável a qualquer momento. |
| Histórico de compras para o próprio negócio (relatório, fidelidade) | Legítimo interesse | Só para uso interno; nunca compartilhado. |
| Anamnese, prontuário, alergia, lesão, medicação | Tutela da saúde (profissional de saúde) ou consentimento específico | Modelo próprio com acesso por papel (ver abaixo). |
| Dado de criança ou adolescente (escola, pediatria, escolinha) | Consentimento de um dos pais ou responsável | O cadastro é feito pelo responsável, com nome e documento dele. |

### Direitos do titular e como o app atende

| Direito | No app |
|---|---|
| Saber que dados o negócio tem e receber cópia | Botão "Exportar dados" na tela do cliente (administrador). Baixa um JSON. |
| Corrigir | Edição normal do cadastro. |
| Apagar ou anonimizar | Botão "Anonimizar" (administrador). |
| Revogar o consentimento de marketing | Desligar `marketing_opt_in` no cadastro; no app do próprio cliente, um interruptor "Receber promoções" em "Minha conta". |
| Saber com quem o dado é compartilhado | Seção da `/privacidade`: plataforma que hospeda o app, gateway de pagamento conectado, integrações ligadas. |

O prazo da lei para entregar a cópia completa é de até 15 dias do pedido. O app não envia nada sozinho: o administrador exporta e envia.

### Exportar dados do cliente

Na tela de detalhe do cliente, só para `role:admin`:

```ts
async function exportClientData(clientId: string) {
  const client = await collection("client").get(clientId);
  const related: Record<string, unknown[]> = {};
  for (const model of ["order", "booking", "invoice"]) {           // os modelos do app que têm `ref` para client
    const rows: unknown[] = [];
    for (let offset = 0; ; offset += 100) {
      const page = await collection(model).list({ filter: { client: clientId }, limit: 100, offset });
      rows.push(...page);
      if (page.length < 100) break;
    }
    related[model] = rows;
  }
  const blob = new Blob([JSON.stringify({ client, ...related }, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `dados-cliente-${clientId}.json`;
  a.click();
  URL.revokeObjectURL(url);
}
```

Troque a lista de modelos pelos que o app realmente tem com `ref` para o cliente.

### Anonimizar

- É um `update` no cadastro: `name: "Titular anonimizado"`, e `cpf`, `cnpj`, `phone`, `email`, `cep`, `street`, `number`, `complement`, `district`, `city` vazios, `marketing_opt_in: false`, `anonymized_at: agora`. Pedidos, vendas e notas continuam existindo para o caixa e a contabilidade, sem identificar a pessoa.
- Os campos que a anonimização limpa NÃO podem ser `required` no schema: obrigatório faltando dá 422. Obrigatoriedade desses campos fica no `zod` do formulário.
- `ConfirmDialog` com o texto: "Anonimizar Maria Souza? Nome, documento, telefone, e-mail e endereço serão apagados. O histórico de compras continua, sem o nome dela. Não dá para desfazer."
- Cadastro anonimizado aparece na lista como "Titular anonimizado" e sai da busca por nome.
- Registros de saúde de clínica e consultório têm guarda obrigatória (prontuário: 20 anos, Lei 13.787/2018). A anonimização do cadastro não apaga o prontuário; a tela avisa isso ao administrador.

### Dados sensíveis (saúde e afins)

- Modelo próprio, por exemplo `health_record` (`client` ref, `kind` enum, `notes` richtext, `attachments` list of file), com acesso:
  `{"read":"role:clinician","create":"role:clinician","update":"role:clinician","delete":"role:admin"}`
  e o papel `clinician` ("Profissional") em `roles`. Recepção e atendimento comum não leem. Dono e admin são superusuários da plataforma.
- Arquivos de saúde sobem com `uploadFile(file, { visibility: "private" })`.
- Nunca vão para lista geral, busca, texto de notificação, e-mail, WhatsApp ou `invokeLLM` sem o dono pedir.
- Registro de acesso (opcional, para clínica): modelo `access_log` (`record` text, `user_name` text, `viewed_at` datetime) com `{"read":"role:admin","create":"authenticated","update":"role:admin","delete":"role:admin"}`; a tela do prontuário cria uma linha ao abrir.

### Página `/privacidade`

Rota estática, link no rodapé e ao lado de todo formulário que coleta dado ("Como usamos seus dados"). Estrutura, com texto curto e "você":

1. Quem somos: `[Preencher: nome do negócio]`, `[Preencher: CNPJ ou CPF do responsável]`, `[Preencher: endereço]`.
2. Que dados pedimos e para quê (a tabela de finalidades, só com os dados que ESTE app coleta).
3. Com quem compartilhamos: a plataforma que hospeda o app e, se ligados, o meio de pagamento e as integrações.
4. Por quanto tempo guardamos: enquanto você for cliente; dados fiscais por 5 anos; prontuário pelo prazo legal (só em app de saúde).
5. Seus direitos (a tabela de direitos, em frases) e como pedir: `[Preencher: e-mail ou WhatsApp de contato para privacidade]`.
6. Cookies: o aviso de cookies é o da plataforma.
7. Data da última atualização: `[Preencher: data]`.

Os marcadores `[Preencher: ...]` aparecem destacados (`bg-muted` + texto `text-muted-foreground`) para o dono ver que falta completar. Negócio de pequeno porte está dispensado de nomear encarregado (DPO) pela ANPD, mas precisa de um canal de contato: por isso o item 5 é sempre obrigatório.

## Pix e pagamento

### Com pagamento integrado (caminho padrão)

- O dono conecta Stripe, Pagar.me ou Mercado Pago no Studio. O app usa `useCheckout()`; `paymentMethods` fica vazio por padrão (o gateway oferece o que tem) e só vira `['credit_card', 'pix']` quando o dono pediu Pix explicitamente.
- Fluxo: `const checkout = useCheckout()` no componente; a tela cria o pedido (`status: 'pending'`), chama `checkout({ items: [{ model_id, record_id }], successUrl, cancelUrl })` (acrescente `paymentMethods: ['credit_card', 'pix']` só no caso acima) e redireciona para o `redirect_url` devolvido. O QR Code e o "Pix copia e cola" são da página do gateway.
- A plataforma recebe o aviso do gateway e marca o pedido como pago. A tela de sucesso lê o pedido com `useLive` e mostra "Aguardando confirmação do pagamento" até o status mudar. Pix costuma confirmar em segundos; cartão também. O texto não promete prazo.
- Nunca: liberar conteúdo pago no cliente, marcar pago pelo `successUrl`, confiar em parâmetro de URL, escrever webhook próprio ou função que fala direto com o gateway.
- Recorrência: assinatura é `useSubscribe` (cartão). Pix não entra em assinatura. Para mensalidade paga por Pix, o app cria a cobrança do mês como pedido avulso e avisa o cliente com automação `relative` antes do vencimento ("Sua mensalidade vence amanhã") com link para pagar.

### Sem pagamento integrado (Pix manual, confirmado pelo dono)

Quando o dono não quer ou ainda não conectou um gateway:

- Modelo `business_settings` com `pix_key` (text) e `pix_key_type` (enum: cpf, cnpj, email, phone, random), acesso `{"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}`. A chave é cadastrada pelo dono, nunca inventada.
- Na finalização do pedido: mostra a chave com o botão "Copiar chave Pix" (toast "Chave copiada"), o valor com `formatMoney` e, opcional, um `FileUpload` para o cliente anexar o comprovante (`visibility: 'private'`).
- O pedido fica `awaiting_payment`. Só um administrador muda para `paid`, na tela de pedidos, depois de conferir no banco. O cliente vê "Seu pedido é confirmado quando a loja conferir o pagamento."
- QR Code e "Pix copia e cola" estático (BR Code): o app pode gerar, desde que siga o padrão abaixo ao pé da letra (conferido contra o exemplo oficial do Banco Central). Cada campo é id de 2 dígitos + tamanho com 2 dígitos + valor:
  `00 02 "01"` · `26 xx [00 14 "br.gov.bcb.pix" | 01 nn <chave> | 02 nn <descrição curta, opcional>]` · `52 04 "0000"` · `53 03 "986"` · `54 nn <valor com ponto e 2 casas, ex. "450.00">` · `58 02 "BR"` · `59 nn <nome do recebedor, até 25, sem acento>` · `60 nn <cidade, até 15, sem acento>` · `62 xx [05 nn <txid: só letras e números, até 25, ou "***">]` · `63 04 <CRC16>`.
  CRC16-CCITT (polinômio 0x1021, valor inicial 0xFFFF, sem reflexão) sobre o texto inteiro terminado em `6304`, em 4 hexadecimais maiúsculos. Chave: CPF/CNPJ só dígitos, telefone `+55...`, e-mail minúsculo, aleatória como veio. O QR sai do pacote `qrcode` (já instalado). O código estático não avisa o app quando é pago: a confirmação continua manual. Conferência na tela: o dono lê o primeiro QR no app do banco e confere nome e valor antes de divulgar.

  Código pronto (testado contra o exemplo do Banco Central: chave `123e4567-e12b-12d1-a456-426655440000`, "Fulano de Tal", BRASILIA, txid `***`, sem valor, CRC `1D3D`). Copie para `src/lib/pix.ts`, não reescreva:

```ts
// src/lib/pix.ts: BR Code estático do Pix (copia e cola). Sem dependência externa.
function tlv(id: string, value: string): string {
  return id + String(value.length).padStart(2, "0") + value;
}
export function pixCrc16(payload: string): string {
  let crc = 0xffff;
  for (let i = 0; i < payload.length; i++) {
    crc ^= payload.charCodeAt(i) << 8;
    for (let j = 0; j < 8; j++) crc = crc & 0x8000 ? ((crc << 1) ^ 0x1021) & 0xffff : (crc << 1) & 0xffff;
  }
  return crc.toString(16).toUpperCase().padStart(4, "0");
}
function plain(s: string, max: number): string {
  return s.normalize("NFD").replace(/[̀-ͯ]/g, "").replace(/[^A-Za-z0-9 .\-]/g, "").trim().slice(0, max);
}
// `amount` em reais (ex. 450 → "450.00"); omitido = quem paga digita o valor. `txid` só letras e números, até 25; vazio = "***".
export function pixBrCode(input: { key: string; name: string; city: string; amount?: number; txid?: string; description?: string }): string {
  const mai = tlv("00", "br.gov.bcb.pix") + tlv("01", input.key.trim()) +
    (input.description ? tlv("02", plain(input.description, 40)) : "");
  const txid = (input.txid ?? "").replace(/[^A-Za-z0-9]/g, "").slice(0, 25) || "***";
  const payload =
    tlv("00", "01") + tlv("26", mai) + tlv("52", "0000") + tlv("53", "986") +
    (input.amount != null ? tlv("54", (Math.round(input.amount * 100) / 100).toFixed(2)) : "") +
    tlv("58", "BR") + tlv("59", plain(input.name, 25)) + tlv("60", plain(input.city, 15).toUpperCase()) +
    tlv("62", tlv("05", txid)) + "6304";
  return payload + pixCrc16(payload);
}
```

## Nota fiscal

### O que o app faz

Guarda e organiza as notas que o dono emite no emissor dele. Não emite, não transmite à prefeitura ou à Sefaz, não calcula imposto.

### Modelo `invoice`

| Campo | Tipo | Observação |
|---|---|---|
| `kind` | enum `nfse` (Nota de serviço), `nfe` (NF-e), `nfce` (NFC-e) | Serviço usa NFS-e; produto usa NF-e ou NFC-e. |
| `status` | enum `to_issue` (A emitir), `issued` (Emitida), `cancelled` (Cancelada) | |
| `number` | text | |
| `series` | text | |
| `access_key` | text | NF-e e NFC-e: 44 dígitos, guardados sem espaços. |
| `issued_at` | date | |
| `amount` | money | |
| `pdf` | file | |
| `xml` | file | |
| `taxes` | json | Só o que o emissor devolver. O app não calcula. |
| `order` ou `booking` | ref | O pedido ou atendimento que a nota cobre. |
| `client` | ref | |

Acesso: `role:admin` em todas as ações (o contador pode ganhar um papel `accountant` com leitura). Configuração do negócio: `tax_regime` enum `mei`, `simples`, `presumido`, `real`, só informativo.

### Telas

- Aba "Notas" com filtro por status e mês, e a contagem "A emitir: N" (`count({ status: 'to_issue' })`).
- No detalhe do pedido pago: selo "Falta emitir a nota" enquanto não houver `invoice` emitida, e o botão "Registrar nota".
- "Registrar nota" aceita o PDF e, se o dono quiser, usa `extractData({ fileId, prompt, schema })` para ler número, série, chave, data e valor do PDF e preencher o formulário, que o dono confere antes de salvar. Exige login e crédito de IA; sem crédito (402), o formulário fica manual.
- Exportar a lista do mês em CSV para o contador.

### Reforma tributária (IBS e CBS)

A partir de 2026 os layouts de nota ganharam campos de IBS e CBS (ano de teste para o regime regular; Simples e MEI passam a preencher em 2027). Isso é assunto do emissor do dono. O app só guarda em `taxes` o que o emissor devolver e nunca mostra imposto calculado por ele mesmo.

### Emissão automática

Só com emissor externo que tenha API: o dono cadastra o emissor como conector no Studio e o app chama por uma função de backend (`functions/<nome>.ts`; o plano que libera o CLI já libera funções). Sem isso, diga ao dono: "O app guarda suas notas e mostra o que falta emitir. A emissão continua no seu emissor."
