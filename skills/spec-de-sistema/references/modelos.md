# Modelos da spec de sistema

Exemplo único do começo ao fim: oficina mecânica com ordens de serviço (OS). Troque os nomes pelos do negócio do dono.

## 1. PRD enxuto (vai na Visão geral e nas seções do plano)

**Problema:** a oficina controla as OS em papel e no WhatsApp. O dono não sabe quantas estão paradas esperando peça,
e o cliente liga várias vezes por dia perguntando se o carro está pronto.

**Objetivos:**
- Quem usa: o mecânico atualiza o andamento da OS em menos de 30 segundos pelo celular.
- Quem usa: o cliente vê o andamento da própria OS sem ligar.
- Negócio: o dono sabe, ao abrir o app, quantas OS estão atrasadas e quanto há para receber.

**O que NÃO vamos construir (com o motivo):**
- Estoque de peças: é outra frente; a OS só registra que está esperando peça.
- Emissão de nota fiscal: a plataforma não emite; a OS guarda o número e o PDF que o dono anexar.
- Agendamento de revisão: pouco impacto no problema atual; entra depois.

**Histórias (ordem de prioridade):**
1. Como atendente, quero abrir uma OS com cliente, placa e defeito para o mecânico começar.
2. Como mecânico, quero mudar a OS para "Aguardando peça" para o dono ver o que está parado.
3. Como cliente, quero ver o andamento da minha OS para não precisar ligar.
4. Como dono, quero ver as OS atrasadas primeiro para cobrar a equipe.
5. Como atendente, ao buscar uma placa que não existe, quero ver "Nada encontrado" e o botão de abrir OS.

**Prioridades:** P0 = abrir OS, lista com filtros, mudar status, detalhe com histórico, área do cliente. P1 = painel
com valores do mês, exportar planilha. P2 = estoque (o modelo `service_order` já tem o status `waiting_parts`, que
depois se liga ao estoque).

**Métricas:** OS abertas por semana (`count` com filtro de data), OS atrasadas hoje (`count` com `due_date` menor que
hoje e status aberto), ligações de cliente perguntando andamento (o dono informa; meta: metade em 30 dias).

**Suposições (no plano, as de alto impacto primeiro):**
- high: "Assumi que o cliente entra com e-mail e vê só as OS dele." Alternativa: "O cliente acompanha por um link sem
  conta?"
- low: "Assumi 25 OS por página, as mais novas primeiro."

## 2. Inventário de telas

| Nº | Tela | Rota | Menu | Tipo | Quem acessa |
|---|---|---|---|---|---|
| 1 | Ordens de serviço | `/os` | aba "OS" | lista | admin, atendente, mecânico |
| 2 | Nova OS | `/os/nova` | botão na lista | formulário | admin, atendente |
| 3 | OS | `/os/:id` | clique na linha | detalhe | admin, atendente, mecânico |
| 4 | Painel | `/painel` | aba "Painel" | painel | admin |
| 5 | Minhas OS | `/minhas-os` | aba "Minhas OS" | lista | cliente |

## 3. Spec de lista (tela 1)

**Ordens de serviço** (`/os`). O atendente e o mecânico acham a OS e agem nela.

Filtros:

| Filtro | Tipo | Opções | Padrão | Observação |
|---|---|---|---|---|
| Busca | texto | | vazio | placa (`contains` no servidor), espera 300ms, volta à página 1 |
| Cliente | escolha | Combobox dos clientes | vazio | filtra `customer` pelo id escolhido (o nome mora em outro modelo, não dá para buscar por ele aqui) |
| Status | vários | do dicionário | Aberta, Em andamento, Aguardando peça | fica salvo ao voltar para a tela |
| Atrasadas | liga/desliga | | desligado | prazo menor que hoje e status não final |

Colunas:

| Coluna | Formato | Ordena | Observação |
|---|---|---|---|
| OS | `OS-0001` | sim | clique abre o detalhe |
| Cliente | texto, corta com reticências | sim | |
| Placa | `ABC1D23` | não | |
| Status | selo com tom | não | |
| Prazo | dd/mm/aaaa, em vermelho se atrasada | sim | "Sem prazo" se vazio |
| Total | R$ 1.234,56 | sim | "Não informado" se vazio |

Ações:

| Ação | Quem vê | O que faz |
|---|---|---|
| Nova OS | admin, atendente | abre `/os/nova` |
| Mudar status (na linha) | admin, atendente, mecânico | menu com só as transições permitidas |
| Excluir | admin | confirmação "Excluir a OS-0001? Isso não pode ser desfeito pelo app." e exclusão lógica |
| Exportar | admin | baixa planilha com os filtros atuais |

Interações:
- **Abrir a tela** → carrega a página 1, 25 por página, mais novas primeiro, com os filtros padrão; `Skeleton`
  enquanto carrega; contagem "32 OS" no topo.
- **Buscar** → espera 300ms, volta à página 1, mostra "Nada encontrado para 'xyz'" com "Limpar busca" se vazio.
- **Mudar status** → gravado; aviso "OS-0001 agora está Aguardando peça"; a linha atualiza; falha mostra a mensagem
  do erro e a linha volta ao status anterior.
- **Celular** → cada OS vira cartão (OS, cliente, selo, prazo); filtros num `Sheet`; ações da linha num
  `DropdownMenu`.

## 4. Spec de formulário (tela 2)

**Nova OS** (`/os/nova`), página própria em duas seções ("Cliente e veículo", "Serviço").

| Campo (rótulo) | id | Tipo | Obrigatório | Padrão | Validação e observação |
|---|---|---|---|---|---|
| Cliente | `customer` | `ref` → `customer` | sim | | busca por nome; "Cadastrar cliente" abre Dialog com nome e telefone |
| Placa | `vehicle_plate` | `text` | sim | | 7 caracteres, maiúsculas, formato antigo ou Mercosul |
| Defeito relatado | `description` | `text` | sim | | 3 a 2000 caracteres |
| Prazo | `due_date` | `date` | não | hoje + 3 dias | `DatePicker`, não aceita data passada |
| Total | `total` | `money` | não | | `CurrencyInput`, maior ou igual a zero |
| Fotos | `photos` | `list` de `image` | não | | até 6 |

- **Salvar** → validação zod no cliente; botão mostra carregando e não envia duas vezes; sucesso: aviso "OS-0012
  aberta" e vai para `/os/:id`; 422: mensagem perto do campo; outro erro: aviso com `e.message`.
- **Cancelar** com dados preenchidos → confirmação "Descartar esta OS?".

## 5. Spec de detalhe (tela 3)

**OS** (`/os/:id`), chega da lista ou de um aviso com o id.
- Cabeçalho: número, selo de status, cliente (link para o cliente), placa.
- Abas: "Serviço" (defeito, fotos, prazo, total), "Histórico" (linha do tempo das mudanças de status: quem, quando,
  de qual para qual).
- Ações por status e papel: botões das transições permitidas; "Editar" para admin e atendente enquanto não estiver
  Entregue; "Enviar no WhatsApp" abre `https://wa.me/55DDDNUMERO?text=...` com o andamento.
- OS inexistente ou sem permissão: "Essa OS não existe ou você não tem acesso" com botão para a lista.

## 6. Spec de painel (tela 4)

| Cartão | Significado exato | Consulta | Comparação |
|---|---|---|---|
| Abertas | OS com status não final | `count({status:{in:[...]}})` | ontem |
| Atrasadas | prazo menor que hoje e status não final | `count` com `due_date:{lt:hoje}` | semana passada |
| Aguardando peça | status `waiting_parts` | `count` | ontem |
| A receber no mês | soma de `total` das OS entregues no mês | `list` paginado e soma na tela | mês anterior |

Cada cartão leva à lista com o filtro correspondente. Somas pesadas: um modelo de resumo atualizado por função.

## 7. Dicionário de status e tipos

`service_order.status`:

| Valor | Rótulo | Tom do selo | Significado |
|---|---|---|---|
| `open` | Aberta | contorno | OS criada, ninguém começou |
| `in_progress` | Em andamento | marca | mecânico trabalhando |
| `waiting_parts` | Aguardando peça | neutro | parada por falta de peça |
| `done` | Pronta | marca | serviço terminado, carro ainda na oficina |
| `delivered` | Entregue | neutro | carro devolvido ao cliente (final) |
| `cancelled` | Cancelada | perigo | desistência (final) |

Tons e variantes do `Badge`: marca = `default`, neutro = `secondary`, perigo = `destructive`, contorno = `outline`.

## 8. Máquina de status

| De | Pode ir para | Quem move | Dispara |
|---|---|---|---|
| Aberta | Em andamento, Cancelada | mecânico, atendente, admin | registro de histórico |
| Em andamento | Aguardando peça, Pronta, Cancelada | mecânico, admin | registro de histórico |
| Aguardando peça | Em andamento, Cancelada | mecânico, admin | registro de histórico |
| Pronta | Entregue | atendente, admin | histórico + aviso ao cliente |
| Entregue | nenhum | | |
| Cancelada | nenhum | | |

Aviso ao cliente: o modelo `service_order_event` (campos `service_order` ref, `customer_user` ref ao usuário do
cliente, `from_status`, `to_status`, `to_status_label`) recebe um registro a cada mudança; a automação
`{type:"data", model:"service_order_event", event:"created"}` com
`{type:"notify", channel:"inapp", to:"customer_user", title:"Sua OS mudou", body:"Agora está: {{to_status_label}}", link:"/minhas-os"}`
avisa o cliente em toda mudança. `to` precisa ser um `ref` que aponta para um usuário do app. Para avisar só em "Pronta", a mudança de status é feita por uma função de backend que
chama `ctx.notify` só nessa transição.

## 9. Relações entre telas

| Tela | Chega de | Parâmetro | Vai para | Atualiza |
|---|---|---|---|---|
| Ordens de serviço | aba, cartão do painel | filtros na URL (`?status=waiting_parts`) | OS, Nova OS | |
| Nova OS | lista | | OS criada | lista e painel |
| OS | lista, aviso, Minhas OS | `:id` | cliente, WhatsApp | lista, painel, Minhas OS |
| Minhas OS | aba do cliente | | OS (só leitura) | |

## 10. Papéis e acesso

| Ação | admin | atendente | mecânico | cliente |
|---|---|---|---|---|
| Ver todas as OS | sim | sim | sim | não |
| Ver as próprias OS | | | | sim |
| Abrir e editar OS | sim | sim | não | não |
| Mudar status | sim | sim | sim | não |
| Excluir | sim | não | não | não |

Regra do modelo que garante a tabela:

```json
"access": {
  "read": {"any": ["role:admin", "role:attendant", "role:mechanic", {"owner_field": "customer_user"}]},
  "create": {"any": ["role:admin", "role:attendant"]},
  "update": {"any": ["role:admin", "role:attendant", "role:mechanic"]},
  "delete": "role:admin"
}
```

`customer_user` é o `ref` ao usuário do app do cliente, copiado do cadastro do cliente quando a OS é aberta. Não use
`owner_via: "customer"`: o dono do registro de cliente é quem o cadastrou (o atendente), não o cliente.

## 11. Glossário

| Termo do negócio | id do modelo | Campos-chave | Status |
|---|---|---|---|
| Ordem de serviço, OS | `service_order` | `code`, `customer`, `customer_user`, `vehicle_plate`, `status`, `due_date`, `total` | dicionário da seção 7 |
| Cliente | `customer` | `name`, `phone`, `user` | |
| Histórico da OS | `service_order_event` | `service_order`, `customer_user`, `from_status`, `to_status` | |

## 12. Arquivo de domínio (construção)

`src/lib/service-order.ts`, escrito completo no esqueleto, antes das páginas:

```ts
import { useCallback, useEffect, useState } from "react";
import { z } from "zod";
import { collection, type FilterValue } from "@/lib/fab-client";

export type ServiceOrderStatus = "open" | "in_progress" | "waiting_parts" | "done" | "delivered" | "cancelled";

export type ServiceOrder = {
  id: string;
  code?: string;
  customer: string;
  customer__label?: string;
  customer_user?: string | null;
  vehicle_plate: string;
  description: string;
  status: ServiceOrderStatus;
  due_date?: string | null;
  total?: number | null;
  photos?: string[] | null;
  created_at?: string;
};

export type ServiceOrderEvent = {
  id: string;
  service_order: string;
  customer_user?: string | null;
  from_status: ServiceOrderStatus;
  to_status: ServiceOrderStatus;
  to_status_label: string;
  created_at?: string;
};

export const serviceOrders = collection<ServiceOrder>("service_order");
export const serviceOrderEvents = collection<ServiceOrderEvent>("service_order_event");

export type BadgeTone = "default" | "secondary" | "destructive" | "outline";

export const SERVICE_ORDER_STATUS_OPTIONS: { value: ServiceOrderStatus; label: string; tone: BadgeTone }[] = [
  { value: "open", label: "Aberta", tone: "outline" },
  { value: "in_progress", label: "Em andamento", tone: "default" },
  { value: "waiting_parts", label: "Aguardando peça", tone: "secondary" },
  { value: "done", label: "Pronta", tone: "default" },
  { value: "delivered", label: "Entregue", tone: "secondary" },
  { value: "cancelled", label: "Cancelada", tone: "destructive" },
];

export function serviceOrderStatusLabel(value?: string | null): string {
  return SERVICE_ORDER_STATUS_OPTIONS.find((o) => o.value === value)?.label ?? "Não informado";
}

export const SERVICE_ORDER_TRANSITIONS: Record<ServiceOrderStatus, ServiceOrderStatus[]> = {
  open: ["in_progress", "cancelled"],
  in_progress: ["waiting_parts", "done", "cancelled"],
  waiting_parts: ["in_progress", "cancelled"],
  done: ["delivered"],
  delivered: [],
  cancelled: [],
};

export function canServiceOrderTransition(from: ServiceOrderStatus, to: ServiceOrderStatus): boolean {
  return SERVICE_ORDER_TRANSITIONS[from].includes(to);
}

export const serviceOrderSchema = z.object({
  customer: z.string().min(1, "Escolha o cliente"),
  vehicle_plate: z.string().trim().toUpperCase().regex(/^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$/, "Placa inválida"),
  description: z.string().trim().min(3, "Descreva o defeito").max(2000, "Até 2000 caracteres"),
  due_date: z.string().nullable().optional(),
  total: z.number().nonnegative("Não pode ser negativo").nullable().optional(),
  photos: z.array(z.string()).max(6, "Até 6 fotos").optional(),
});
export type ServiceOrderInput = z.infer<typeof serviceOrderSchema>;

export type ServiceOrderListParams = {
  search?: string;
  customer?: string;
  status?: ServiceOrderStatus[];
  page?: number;
  pageSize?: number;
  sort?: string;
};

function errorMessage(e: unknown): string {
  return (e as { message?: string } | null)?.message ?? "Não foi possível carregar.";
}

export function useServiceOrders(params: ServiceOrderListParams) {
  const { search = "", customer = "", status = [], page = 1, pageSize = 25, sort = "-created_at" } = params;
  const [rows, setRows] = useState<ServiceOrder[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [nonce, setNonce] = useState(0);
  const statusKey = status.join(",");

  useEffect(() => {
    let alive = true;
    const filter: Record<string, FilterValue> = {};
    if (search.trim()) filter.vehicle_plate = { contains: search.trim().toUpperCase() };
    if (customer) filter.customer = customer;
    if (statusKey) filter.status = statusKey.split(","); // array = "qualquer destes" (in) no servidor
    setLoading(true);
    setError(null);
    Promise.all([
      serviceOrders.list({ filter, sort, limit: pageSize, offset: (page - 1) * pageSize }),
      serviceOrders.count(filter),
    ])
      .then(([list, count]) => { if (alive) { setRows(list); setTotal(count); } })
      .catch((e) => { if (alive) setError(errorMessage(e)); })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [search, customer, statusKey, page, pageSize, sort, nonce]);

  const refresh = useCallback(() => setNonce((n) => n + 1), []);
  return { rows, total, loading, error, refresh };
}

export function useServiceOrder(id: string | undefined) {
  const [row, setRow] = useState<ServiceOrder | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [nonce, setNonce] = useState(0);
  useEffect(() => {
    if (!id) return;
    let alive = true;
    setLoading(true);
    serviceOrders.get(id)
      .then((r) => { if (alive) setRow(r); })
      .catch((e) => { if (alive) setError(errorMessage(e)); })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [id, nonce]);
  const refresh = useCallback(() => setNonce((n) => n + 1), []);
  return { row, loading, error, refresh };
}

export function createServiceOrder(input: ServiceOrderInput, customerUser: string | null) {
  const data = serviceOrderSchema.parse(input);
  return serviceOrders.create({ ...data, customer_user: customerUser, status: "open" });
}

export function updateServiceOrder(id: string, input: Partial<ServiceOrderInput>) {
  const data = serviceOrderSchema.partial().parse(input);
  return serviceOrders.update(id, data);
}

export async function changeServiceOrderStatus(order: ServiceOrder, to: ServiceOrderStatus) {
  if (!canServiceOrderTransition(order.status, to)) {
    throw new Error(`Não dá para passar de ${serviceOrderStatusLabel(order.status)} para ${serviceOrderStatusLabel(to)}.`);
  }
  const updated = await serviceOrders.update(order.id, { status: to });
  await serviceOrderEvents.create({
    service_order: order.id,
    customer_user: order.customer_user ?? null,
    from_status: order.status,
    to_status: to,
    to_status_label: serviceOrderStatusLabel(to),
  });
  return updated;
}
```

Espera da busca: um `src/lib/use-debounced-value.ts` com `useDebouncedValue(value, 300)`, também no esqueleto. O
selo: `src/components/status-badge.tsx` com `<StatusBadge value={os.status} options={SERVICE_ORDER_STATUS_OPTIONS} />`
que usa `<Badge variant={tone}>`.

## 13. Conferência da spec (plano e construção)

Completude:
- Toda tela do inventário tem spec; todo campo de formulário tem tipo, obrigatório, padrão e validação.
- Toda coluna tem formato e se ordena; toda ação tem quem a vê e o que faz.
- Todo `enum` está no dicionário com todos os valores; toda máquina de status tem quem move e o que dispara.
- Abrir a tela está descrito em todas as telas; relações entre telas completas (de onde, parâmetro, para onde).
- Dialog e Sheet descritos dentro da tela que os abre.

Precisão:
- Rotas iguais às de `src/routes.tsx`; rótulos iguais aos da tela, nunca o nome da variável.
- Validação igual ao schema zod; papéis iguais às regras `access`.
- Dicionário igual às `options` do schema; nada inventado sem virar suposição ou decisão registrada.

Leitura:
- Linguagem de negócio; nenhuma tela chamada pelo nome do componente ("Lista de OS", não "ServiceOrderTable").
- Interações como "ação → resposta"; cada tela se lê sozinha.

Armadilhas:

| Armadilha | Como aparece | Correção |
|---|---|---|
| Conteúdo de Dialog esquecido | Botão "Cadastrar cliente" sem os campos descritos | Descrever os campos dentro da tela |
| Dependência entre campos não escrita | Pessoa jurídica sem campo CNPJ | Escrever "se tipo = jurídica, mostra CNPJ obrigatório" |
| Permissão escondida | Botão Excluir aparece para todos | Tabela de papéis + regra `access` |
| Parâmetro de rota ignorado | `/os/:id` sem tratar id inexistente | Mensagem de "não existe ou sem acesso" |
| Estado de erro faltando | Falha ao salvar sem aviso | Mensagem com `e.message` |
| Tela sem relação | Tela que ninguém abre | Ligar no menu ou numa ação, ou tirar do plano |
| Dado fixo no código | Lista de status repetida na página | Importar do arquivo de domínio |
