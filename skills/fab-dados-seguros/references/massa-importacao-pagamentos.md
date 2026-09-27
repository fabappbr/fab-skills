# Operações em massa, importação, mesclagem e pagamentos (código pronto)

## 1. Ação em massa com prévia, contagem, confirmação e registro

Os ids mostrados na prévia são exatamente os que serão alterados: a pessoa confirma um conjunto fechado, não um filtro que pode mudar enquanto ela lê. Antes de executar, a contagem é refeita; se mudou, a prévia volta.

```tsx
// src/components/BulkActionDialog.tsx
import { useState } from "react";
import { collection, type FilterValue } from "@/lib/fab-client";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogBody, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Field } from "@/components/ui/field";
import { LoadingButton } from "@/components/ui/loading-button";
import { Progress } from "@/components/ui/progress";
import { toast } from "sonner";

type Filtro = Record<string, FilterValue>;
export type AcaoEmMassa =
  | { tipo: "archive" } | { tipo: "delete" } | { tipo: "update"; patch: Record<string, unknown>; descricao: string };

const LOTE = 200;
const LIMITE_CONFIRMACAO_DIGITADA = 20;

export async function prepararPrevia(model: string, filtro: Filtro, campoNome: string) {
  const col = collection<{ id: string } & Record<string, unknown>>(model);
  const total = await col.count(filtro);
  const ids: string[] = []; const nomes: string[] = [];
  for (let offset = 0; offset < total; offset += LOTE) {
    const pagina = await col.list({ filter: filtro, sort: "created_at", limit: LOTE, offset, fields: [campoNome] });
    for (const r of pagina) { ids.push(r.id); if (nomes.length < 5) nomes.push(String(r[campoNome] ?? "")); }
    if (pagina.length < LOTE) break;
  }
  return { total, ids, nomes };
}

export function BulkActionDialog(props: {
  open: boolean; onOpenChange: (o: boolean) => void; model: string; nomeNoPlural: string;
  filtro: Filtro; previa: { total: number; ids: string[]; nomes: string[] }; acao: AcaoEmMassa;
  onConcluido: () => void; onPreviaMudou: () => void;
}) {
  const { previa, acao } = props;
  const [digitado, setDigitado] = useState("");
  const [feitos, setFeitos] = useState(0);
  const [executando, setExecutando] = useState(false);
  const exigeDigitar = previa.total > LIMITE_CONFIRMACAO_DIGITADA || acao.tipo === "delete";
  const liberado = !exigeDigitar || digitado.trim() === String(previa.total);
  const verbo = acao.tipo === "archive" ? "arquivar" : acao.tipo === "delete" ? "excluir de vez" : acao.descricao;

  async function executar() {
    const col = collection(props.model);
    setExecutando(true);
    try {
      const agora = await col.count(props.filtro);
      if (agora !== previa.total) { toast.info("A lista mudou desde a prévia. Confira de novo."); props.onPreviaMudou(); return; }
      let afetados = 0;
      for (let i = 0; i < previa.ids.length; i += LOTE) {
        const lote = previa.ids.slice(i, i + LOTE);
        if (acao.tipo === "delete") {                       // o filtro não aceita `id`: apaga por id, 5 por vez
          for (let j = 0; j < lote.length; j += 5) {
            const r = await Promise.allSettled(lote.slice(j, j + 5).map(id => col.remove(id)));
            afetados += r.filter(x => x.status === "fulfilled").length;
          }
        } else {
          const patch = acao.tipo === "archive" ? { archived: true, archived_at: new Date().toISOString() } : acao.patch;
          afetados += (await col.updateMany(lote, patch)).updated;
        }
        setFeitos(i + lote.length);
      }
      await collection("audit_log").create({
        action: acao.tipo === "delete" ? "bulk_delete" : acao.tipo === "archive" ? "archive" : "bulk_update",
        model: props.model, filter: props.filtro, expected: previa.total, affected: afetados,
        summary: `${verbo}: ${afetados} de ${previa.total} ${props.nomeNoPlural}`,
      });
      const fora = previa.total - afetados;
      if (fora > 0) toast.warning(`${afetados} ${props.nomeNoPlural} atualizados. ${fora} ficaram de fora porque você não tem permissão sobre eles.`);
      else toast.success(`${afetados} ${props.nomeNoPlural} atualizados.`);
      props.onConcluido(); props.onOpenChange(false);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Não foi possível concluir. Nada além do que já apareceu foi alterado.");
    } finally { setExecutando(false); }
  }

  return (
    <Dialog open={props.open} onOpenChange={props.onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{`Vai ${verbo} ${previa.total} ${props.nomeNoPlural}`}</DialogTitle>
          <DialogDescription>
            {previa.nomes.join(", ")}{previa.total > previa.nomes.length ? ` e mais ${previa.total - previa.nomes.length}` : ""}.
            {acao.tipo === "delete" ? " Não dá para desfazer." : acao.tipo === "archive" ? " Você pode restaurar depois em Arquivados." : ""}
          </DialogDescription>
        </DialogHeader>
        <DialogBody>
          {exigeDigitar ? (
            <Field label={`Digite ${previa.total} para confirmar`} htmlFor="confirmar-qtd">
              <Input id="confirmar-qtd" inputMode="numeric" autoComplete="off" value={digitado} onChange={e => setDigitado(e.target.value)} />
            </Field>
          ) : null}
          {executando ? <Progress value={(feitos / Math.max(1, previa.total)) * 100} aria-label="Progresso" /> : null}
        </DialogBody>
        <DialogFooter>
          <Button variant="outline" onClick={() => props.onOpenChange(false)} disabled={executando}>Cancelar</Button>
          <LoadingButton loading={executando} disabled={!liberado} variant={acao.tipo === "delete" ? "destructive" : "default"} onClick={executar}>
            {`Confirmar e ${verbo}`}
          </LoadingButton>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
```

Uso: a lista com seleção (ou "todos do filtro atual") chama `prepararPrevia` ao clicar em "Arquivar selecionados", guarda o resultado em estado e abre o diálogo. Confira os nomes exatos dos exports do `dialog` e do `LoadingButton` no kit antes de importar. Para seleção manual (checkboxes), a prévia é a própria lista de ids selecionados (`total` = quantidade, `nomes` = os primeiros 5) e a recontagem compara com a seleção atual, não com um filtro: o filtro de lista não aceita `id` (dá 422).

Regras que o componente implementa:
- **Até 20 registros:** confirmar num clique. **Acima de 20, ou excluir de vez:** digitar o número. O número vem da contagem feita na hora, nunca de um valor fixo.
- **Execução em lotes de 200** com barra de progresso. Um erro no meio para tudo e diz o que já foi feito (o que já foi gravado não volta sozinho).
- **Resultado comparado:** `afetados` menor que o esperado vira aviso com o número, não sucesso silencioso.
- **`audit_log` depois de executar**, com esperado e afetado. Para dinheiro ou dado crítico, e com plano que tenha funções, a operação inteira pode ir para uma função `role:admin` que faz a alteração e grava o registro juntas, sem depender do navegador.
- A tela "Atividades" (só admin) lista o `audit_log` com filtro por pessoa, ação e período. É histórico, não desfazer.

## 2. Mesclar duplicados

Mesclar é irreversível: o secundário é arquivado e seus filhos passam para o principal. Fluxo:

1. **Achar grupos:** percorra o modelo em páginas de 200 (`fields` só com as chaves), agrupe num `Map` pela chave normalizada (e-mail, documento, telefone) e mostre os grupos com mais de um registro.
2. **Escolher o principal** no grupo (por padrão o mais antigo). Mostre lado a lado os campos que diferem; o principal fica com os seus e herda do secundário só os campos que estão vazios nele.
3. **Prévia:** para cada modelo filho com `ref` para o cadastro (pedidos, agendamentos, anotações), `count({ customer: idSecundario })`. "Vai mover 12 pedidos e 3 agendamentos de 'Ana S.' para 'Ana Souza' e arquivar 'Ana S.'. Não dá para desfazer." Confirmação digitada se passar de 20.
4. **Executar:** `updateWhere({ customer: idSecundario }, { customer: idPrincipal })` em cada modelo filho, confira os números, `update` do principal com os campos herdados, `update` do secundário com `archived: true` e `merged_into: idPrincipal` (campo `text`), e `audit_log` com `action: "merge"`.

## 3. Importação de planilha com atualização pela chave

Dependências, instaladas dentro de `.fabapp/workspace` e enviadas pelo `fabapp deploy`: `npm install papaparse@^5.4.1` e `npm install -D @types/papaparse@^5.3.14`. Planilha do Excel: peça para salvar como CSV, ou use `read-excel-file` para `.xlsx`.

```ts
// src/lib/importar.ts
import { collection } from "@/lib/fab-client";
import type { ZodType } from "zod";

export const normalizar = {
  email: (v: string) => v.trim().toLowerCase(),
  digitos: (v: string) => v.replace(/\D/g, ""),                                  // CPF, CEP
  cnpj: (v: string) => v.toUpperCase().replace(/[^0-9A-Z]/g, ""),                // CNPJ novo tem letras
  telefone: (v: string) => { const d = v.replace(/\D/g, ""); return d ? "+" + (d.length <= 11 ? "55" + d : d) : ""; },
  texto: (v: string) => v.trim().replace(/\s+/g, " "),
};

export type Status = "criar" | "atualizar" | "igual" | "erro";
export type LinhaPlano<T> = { linha: number; chave: string; dados?: T; existenteId?: string; status: Status; motivo?: string };
export type Relatorio = { linha: number; status: "criado" | "atualizado" | "sem mudança" | "erro"; motivo?: string };

const LOTE = 200;
const espera = (ms: number) => new Promise(r => setTimeout(r, ms));

export async function planejar<T extends Record<string, unknown>>(opts: {
  model: string; campoChave: keyof T & string; linhas: Record<string, string>[];
  mapear: (bruta: Record<string, string>) => unknown; esquema: ZodType<T>; normalizarChave: (v: string) => string;
}): Promise<LinhaPlano<T>[]> {
  const plano: LinhaPlano<T>[] = [];
  const vistas = new Map<string, number>();
  opts.linhas.forEach((bruta, i) => {
    const linha = i + 2;                                   // linha 1 é o cabeçalho
    const r = opts.esquema.safeParse(opts.mapear(bruta));
    if (!r.success) { plano.push({ linha, chave: "", status: "erro", motivo: r.error.issues[0]?.message ?? "Dados inválidos" }); return; }
    const chave = opts.normalizarChave(String(r.data[opts.campoChave] ?? ""));
    if (!chave) { plano.push({ linha, chave, status: "erro", motivo: "Sem a informação que identifica o cadastro" }); return; }
    if (vistas.has(chave)) { plano.push({ linha, chave, status: "erro", motivo: `Repetido na planilha (linha ${vistas.get(chave)})` }); return; }
    vistas.set(chave, linha);
    plano.push({ linha, chave, dados: { ...r.data, [opts.campoChave]: chave }, status: "criar" });
  });
  const chaves = plano.filter(p => p.status === "criar").map(p => p.chave);
  const existentes = new Map<string, Record<string, unknown> & { id: string }>();
  for (let i = 0; i < chaves.length; i += LOTE) {
    const achados = await collection<Record<string, unknown> & { id: string }>(opts.model)
      .list({ filter: { [opts.campoChave]: { in: chaves.slice(i, i + LOTE) } }, limit: LOTE });
    for (const a of achados) existentes.set(String(a[opts.campoChave]), a);
  }
  for (const p of plano) {
    const atual = p.status === "criar" ? existentes.get(p.chave) : undefined;
    if (!atual || !p.dados) continue;
    const muda = Object.entries(p.dados).some(([k, v]) => v !== undefined && v !== "" && atual[k] !== v);
    p.existenteId = atual.id; p.status = muda ? "atualizar" : "igual";
  }
  return plano;
}

export async function executar<T extends Record<string, unknown>>(model: string, plano: LinhaPlano<T>[],
  aoAvancar?: (feitas: number) => void): Promise<Relatorio[]> {
  const col = collection<T & { id: string }>(model);
  const rel = new Map<number, Relatorio>();
  let feitas = 0;
  for (const p of plano) {
    if (p.status === "erro") rel.set(p.linha, { linha: p.linha, status: "erro", motivo: p.motivo });
    if (p.status === "igual") rel.set(p.linha, { linha: p.linha, status: "sem mudança" });
  }
  const novos = plano.filter(p => p.status === "criar");
  for (let i = 0; i < novos.length; i += LOTE) {
    const lote = novos.slice(i, i + LOTE);
    try {
      await col.bulkCreate(lote.map(p => p.dados as Partial<T & { id: string }>));
      lote.forEach(p => rel.set(p.linha, { linha: p.linha, status: "criado" }));
    } catch {
      for (const p of lote) {                                // o lote é tudo ou nada: isola a linha com problema
        try { await col.create(p.dados as Partial<T & { id: string }>); rel.set(p.linha, { linha: p.linha, status: "criado" }); }
        catch (e) { rel.set(p.linha, { linha: p.linha, status: "erro", motivo: e instanceof Error ? e.message : "Não foi possível criar" }); }
      }
    }
    feitas += lote.length; aoAvancar?.(feitas);
  }
  const atualizar = plano.filter(p => p.status === "atualizar");
  for (let i = 0; i < atualizar.length; i += 5) {           // 5 por vez para não estourar o limite de requisições
    await Promise.all(atualizar.slice(i, i + 5).map(async p => {
      for (let tentativa = 1; tentativa <= 3; tentativa++) {
        try { await col.update(p.existenteId!, p.dados as Partial<T & { id: string }>); rel.set(p.linha, { linha: p.linha, status: "atualizado" }); return; }
        catch (e) {
          const status = (e as { status?: number }).status;
          if (status === 429 && tentativa < 3) { await espera(1500 * tentativa); continue; }
          rel.set(p.linha, { linha: p.linha, status: "erro", motivo: e instanceof Error ? e.message : "Não foi possível atualizar" }); return;
        }
      }
    }));
    feitas += Math.min(5, atualizar.length - i); aoAvancar?.(feitas);
  }
  return plano.map(p => rel.get(p.linha)!).sort((a, b) => a.linha - b.linha);
}
```

A tela de importação:
1. **Arquivo:** `Papa.parse(file, { header: true, skipEmptyLines: true, complete: r => setLinhas(r.data) })`.
2. **Colunas:** a pessoa liga cada coluna da planilha a um campo do app (sugestão automática pelo nome do cabeçalho).
3. **Prévia:** `planejar(...)` e mostra a contagem ("120 novos, 34 serão atualizados, 5 sem mudança, 3 com erro") e as 10 primeiras linhas com o que vai acontecer. Nada foi gravado ainda.
4. **Importar:** `executar(...)` com barra de progresso; no fim, entrada no `audit_log` (`action: "import"`, `expected` = linhas válidas, `affected` = criados + atualizados).
5. **Relatório:** tabela por linha na ordem da planilha, "Baixar erros" (CSV só com as linhas de erro e o motivo) e "Reenviar só os erros" (a pessoa corrige o CSV de erros e importa de novo; como a chave atualiza, reimportar a planilha inteira também é seguro).
6. **Dependentes:** para importar clientes e pedidos juntos, importe e confira os clientes primeiro; os pedidos buscam o cliente pela chave normalizada e ficam com erro "Cliente não encontrado" se ele não existir.

A normalização é a MESMA do formulário de cadastro: o formulário grava `normalizar.email(email)` e confere `count({ email })` antes de criar, senão a importação e o cadastro manual criam duplicados um do outro.

## 4. Pagamentos

**Compra avulsa (loja, serviço, ingresso).** O valor cobrado vem sempre de registros com preço, resolvido no servidor:

```tsx
const checkout = useCheckout();
async function finalizarCompra() {
  try {
    const pedido = await collection<Pedido>("order").create({ status: "pending", total: totalCalculado });  // buyer carimbado pela plataforma
    const { redirect_url } = await checkout({
      items: carrinho.map(i => ({ product_id: i.productId, quantity: i.qty })),   // preço de cada produto lido no servidor
      successUrl: `${location.origin}/pedidos/${pedido.id}`,
      cancelUrl: `${location.origin}/carrinho`,
      metadata: { order_id: pedido.id },                                          // é por aqui que a plataforma marca o pedido pago
    });
    location.href = redirect_url;
  } catch (e) { toast.error(e instanceof Error ? e.message : "Não foi possível abrir o pagamento."); }
}
```

- Nunca `amount` num item de checkout: item sem referência é cobrado pelo valor que o navegador mandou. Sempre `product_id`, `{ model_id, record_id }` ou `price_id`.
- Não cobre `{ model_id: "order", record_id }` quando o `total` do pedido foi calculado na tela: o servidor cobra o `total` gravado, que veio do navegador. Cobre os itens.
- O `total` e o `status` do pedido são gravados pelo navegador na criação e podem ser forjados por quem chama a API na mão. Por isso: antes de entregar algo de valor, a equipe confere o pagamento no painel do gateway; e, com plano que tenha funções, o pedido é criado por uma função `user` que grava sempre `status: "pending"` e calcula o `total` pelos preços dos produtos.
- Serviço com `price` (corte, consulta, diária) é cobrado direto por `{ model_id: "service", record_id }`, sem inventar um `product`.

**Tela de retorno** (`/pedidos/:id`):

```tsx
// o filtro não aceita `id`: acompanha os pedidos recentes da pessoa e acha o da rota
const { rows, loading } = useLive<Pedido>("order", { filter: { buyer: user.id }, sort: "-created_at", limit: 10 });
const pedido = rows.find(p => p.id === id);
if (loading) return <Skeleton className="h-40" />;
if (!pedido) return <EmptyState title="Pedido não encontrado" action={<Button asChild><Link to="/pedidos">Ver meus pedidos</Link></Button>} />;
return pedido.status === "paid"
  ? <Alert>Pagamento confirmado. Seu pedido {pedido.code} está sendo preparado.</Alert>
  : <Alert>Aguardando a confirmação do pagamento. No Pix isso pode levar alguns minutos; você pode fechar esta tela, o pedido fica em Meus pedidos.</Alert>;
```

Nunca marque pago por causa do endereço de retorno (`?success=1`): a pessoa pode pagar e fechar o navegador antes, ou abrir o endereço sem pagar.

**Assinatura (acesso contínuo).**
- Cada nível (Básico, Pro) é um registro próprio de `plan`; não misture níveis num registro só. Preços em `collection("plan").list()`.
- Venda por `useSubscribe()`, dentro de `<SubscribeGate>`. Só a assinatura ativa libera `plan:premium`; conteúdo com `read:"plan:premium"`.
- Estados que a tela "Minha assinatura" mostra, lidos do registro `subscription` da pessoa: ativa; pagamento atrasado (a plataforma mantém o acesso enquanto o gateway tenta cobrar de novo: mostre o aviso para atualizar o cartão em `<PaymentMethods/>`); cancelada (sem acesso).
- Cancelar: se `source` é `play` ou `appstore`, o botão chama `openStoreSubscriptions()`; senão, o cancelamento do gateway pelo app.
- A tela de assinatura tem "Restaurar compras" (o plano vem da sessão: `useEntitlement` lê `user.plan`, então o botão recarrega a página ou pede para entrar de novo) e links visíveis para Termos e Privacidade.
- Pix não é prometido em assinatura; cartão sim.

**Chaves e contas.**
- Nenhuma chave no app. O dono conecta o gateway no Studio. Chave colada na conversa: não escreva em arquivo; peça para conectar pelo Studio e trocar a chave no painel do gateway, porque ela ficou exposta. Oriente a não compartilhar a chave secreta com terceiros e a trocá-la quando alguém com acesso sair da empresa.
- Recomende ao dono verificação em duas etapas por aplicativo autenticador (não SMS) na conta do gateway.

**Checklist antes de vender de verdade** (passe ao dono na mensagem final, em linguagem simples, quando o app vende):
1. O gateway está conectado no Studio e, se a conexão oferecer o ambiente de testes, uma compra de teste foi feita e o pedido ficou "pago" sozinho.
2. Uma compra real de valor baixo foi feita e estornada pelo painel do gateway, e o pedido apareceu como pago.
3. Um Pix (em compra avulsa) foi pago e o pedido mudou de "aguardando" para "pago" sem ninguém mexer.
4. A tela "Meus pedidos" de um cliente não mostra pedido de outro cliente.
5. Produtos e planos têm preço certo no app; o valor cobrado é o do cadastro.
6. Imposto e nota fiscal: o app não calcula nem emite; o dono combina com o contador como emitir.
7. Marketplace com vários vendedores: o app recebe tudo na conta do dono; a divisão entre vendedores é feita fora do app.
