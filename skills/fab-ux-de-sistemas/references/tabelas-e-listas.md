# Tabelas de trabalho e listas

## Anatomia (de cima para baixo)

```
PageHeader: "Pedidos" + subtítulo "156 no total" + ação primária "Novo pedido"
Barra: [busca] [Etapa ▾] [Vendedor ▾] [Período]            [Exportar]
Chips: Etapa: Aberto ✕  Vendedor: Ana ✕  Limpar filtros      Mostrando 1 a 25 de 156
(com seleção) 3 selecionados  [Mudar etapa ▾] [Excluir]  Limpar seleção
Tabela: ☐ | Número ↓ | Cliente | Etapa | Total | Entrega | ⋯
Rodapé: [25 por página ▾]                  Página 1 de 7  ‹ Anterior  Próxima ›
```

## Receita (dados no servidor, estado na URL)

```tsx
const [params, setParams] = useSearchParams();
const q = params.get("q") ?? "";
const status = params.get("status") ?? "";
const sort = params.get("sort") ?? "-ordered_at";
const page = Number(params.get("page") ?? 1);
const pageSize = Number(params.get("size") ?? 25);
const set = (patch: Record<string, string | null>, keepPage = false) => {
  const next = new URLSearchParams(params);
  Object.entries(patch).forEach(([k, v]) => (v ? next.set(k, v) : next.delete(k)));
  if (!keepPage) next.delete("page");               // filtro, busca ou ordem novos voltam à página 1
  setParams(next, { replace: true });
};
// busca: estado local do input + debounce de 300 ms que chama set({ q })
useEffect(() => {
  const filter: Record<string, unknown> = {};
  if (q) filter.customer_name = { contains: q };   // busca em campo de texto do próprio modelo
  if (status) filter.status = status;
  setLoading(true);
  Promise.all([
    collection<Order>("order").list({ filter, sort, limit: pageSize, offset: (page - 1) * pageSize,
      fields: ["number", "customer", "status", "total", "delivery_date"] }),
    collection("order").count(filter),
  ]).then(([rows, total]) => { setRows(rows); setTotal(total); setError(null); })
    .catch((e: ApiError) => setError(e))
    .finally(() => setLoading(false));
}, [q, status, sort, page, pageSize]);
```

- Estado na URL = filtros persistem ao abrir um registro e voltar, e o link filtrado pode ser compartilhado.
- `fields` só com as colunas da tabela; o rótulo do `ref` chega como `customer__label`.
- Lista que precisa atualizar sozinha (fila da cozinha, chamados): `useLive("order", { filter, sort, limit })`.

## Ordenação

- Clique no cabeçalho: crescente; de novo: decrescente; terceira vez: volta à ordem padrão.
- Coluna ativa sempre com seta (↑ ou ↓); ordenável mas inativa com ↕ discreto; não ordenável sem ícone.
- `aria-sort="ascending" | "descending"` no `<th>` ativo e anúncio da mudança numa região `aria-live="polite"`.
- Ordem padrão = a mais útil para a tarefa (fila: mais antigo primeiro; histórico: mais recente primeiro).
- Ordenação sempre no servidor (`sort: "campo"` ou `"-campo"`). Ordenar no navegador uma lista paginada ordena só a página visível.

## Filtros

| Dado | Controle |
|---|---|
| Texto | busca com debounce de 300 ms (`contains` ou `starts`) |
| Enum (etapa, categoria) | `Select` ou grupo de `Checkbox` (vários valores = array no filtro) |
| Sim/não | `Switch` |
| Data | dois `DatePicker` (de, até) ou atalhos Hoje, 7 dias, 30 dias, Este mês |
| Número ou valor | mínimo e máximo (`gte`, `lte`) |
| Cadastro relacionado | `Combobox` com busca no servidor |

Onde ficam: 1 a 3 filtros em linha acima da tabela; 4 a 8 num painel recolhível (ou `Sheet` no celular) com contador "Filtros (3)"; filtros dependentes entre si num `Sheet` próprio. Filtros ativos aparecem como chips removíveis, com "Limpar filtros" quando houver algum, e a contagem de resultados atualiza a cada mudança.

## Paginação, carregar mais ou rolagem infinita

- Sistema de trabalho (achar um registro, voltar à posição, exportar): **paginação**. Padrão 25 por página, escolha 10, 25, 50, 100; "Mostrando 26 a 50 de 156"; primeira e última página quando passar de 5 páginas.
- Feed ou catálogo para explorar: "Carregar mais" com total conhecido ("Mostrando 75 de 480"), posição preservada ao voltar e botão de voltar ao topo.
- Nunca lista sem limite. Acima de mil registros, só paginação no servidor.

## Seleção e ações em massa

| Ação | Comportamento |
|---|---|
| Checkbox da linha | marca ou desmarca a linha |
| Shift + clique | marca o intervalo desde a última marcada |
| Checkbox do cabeçalho | marca todas da página (estado intermediário se só algumas) |
| "Selecionar todos os 156" | aparece quando a página inteira está marcada e a ação aceita filtro |

- Barra de ações só com seleção, mostrando a contagem, as ações e "Limpar seleção". Checkbox sem ação em massa não deve existir.
- Ação destrutiva sempre com `ConfirmDialog destructive`: "Excluir 3 pedidos? PED-0012, PED-0013 e PED-0015 somem das listas." Botão "Excluir 3 pedidos", nunca "Sim".
- Operação longa mostra progresso ("Atualizando 12 de 40") e pode ser interrompida entre um item e outro; ao terminar, toast com o resumo e, quando der, "Desfazer".
- Anúncio para leitor de tela: "3 linhas selecionadas".

## Linha, detalhe e edição na linha

- Clique na linha abre o detalhe (página ou `Sheet`); ações da linha num menu `⋯` (`DropdownMenu`) com alvo de 44 px no toque.
- Expandir linha (seta ▶/▼) só para detalhe curto; o conteúdo expandido fica recuado e visualmente preso à linha.
- Edição na linha: ativa por clique no ícone de lápis ou duplo clique, borda visível no modo edição, salva com Enter ou ao sair, Esc cancela, valida antes de salvar, indicador de salvando, e toast com "Desfazer".

## Celular: cartões, não rolagem lateral

```tsx
<div className="hidden md:block"><Table>…</Table></div>
<ul className="space-y-3 md:hidden">
  {rows.map((r) => (
    <li key={r.id} className="rounded-xl border border-border bg-card p-4">
      <div className="flex min-w-0 items-center justify-between gap-3">
        <span className="truncate font-semibold text-foreground">{r.customer__label}</span>
        <Badge>{ORDER_STATUS[r.status]}</Badge>
      </div>
      <div className="mt-1 flex justify-between text-sm text-muted-foreground">
        <span>{r.number}</span><span className="tabular-nums">{formatMoney(r.total)}</span>
      </div>
    </li>
  ))}
</ul>
```
No cartão: a identificação (quem), o status, o número mais importante e no máximo mais uma informação. As outras colunas ficam no detalhe. Seleção em massa no celular: toque longo ou botão "Selecionar" que mostra os checkboxes.

## Colunas

- 7 a 10 visíveis no máximo; as de menor prioridade escondidas abaixo de `lg` ou num controle "Colunas".
- Número e dinheiro à direita com `tabular-nums`; texto à esquerda; status como `Badge` com texto.
- Primeira coluna identifica o registro (nome ou número) e é o link para o detalhe.
- Linha de 40 px (denso) a 52 px (confortável), decidido no plano e igual em todo o app.
- Exportar: `<CsvExport model fields filter />` com o filtro atual.

## Estados da tabela

| Estado | O que aparece |
|---|---|
| Primeiro carregamento | cabeçalho real + 5 a 10 linhas de `Skeleton` com a largura das colunas |
| Troca de página ou filtro | tabela atual com opacidade reduzida e indicador pequeno; nada pula |
| Sem dados ainda | `EmptyState`: o que vai aparecer aqui + botão de criar o primeiro (e importar planilha, se houver) |
| Busca sem resultado | "Nenhum pedido para 'Joao'" + sugestões + limpar busca |
| Filtro zerou | chips dos filtros ativos + "Limpar filtros" |
| Erro ao carregar | mensagem do servidor + "Tentar de novo" |

## Acessibilidade da tabela

`<table>` semântica (o `Table` do kit), `scope="col"` nos cabeçalhos, `aria-label` com o nome da lista, `aria-sort` na coluna ativa, ações da linha alcançáveis por Tab e ativadas com Enter ou Espaço, seleção e ordenação anunciadas, paginação operável por teclado.

## Números de referência

| Item | Valor |
|---|---|
| Linhas por página | 25 |
| Colunas visíveis | 7 a 10 |
| Debounce da busca | 300 ms |
| Linhas de skeleton | 5 a 10 |
| Altura da linha | 40 a 52 px |
| Largura mínima de coluna | 60 px |
| Confirmação em exclusão em massa | sempre |

## Erros que a revisão reprova

Sem seta de ordenação; ordenar no navegador com paginação no servidor; paginação sem contagem total; botões de ação minúsculos; tabela vazia só com cabeçalho; edição na linha sem desfazer; checkbox sem ação em massa; filtro que se perde ao navegar; troca de página sem indicação de carregamento; rolagem lateral forçada no celular.
