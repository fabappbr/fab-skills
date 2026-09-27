# Relatórios do atendimento: fórmulas e telas

A plataforma só agrega no servidor com `count()`. Todo o resto é calculado no navegador a partir de `list` paginada
(`limit:200`, `offset` até voltar menos que 200), pedindo só os campos necessários (`fields`). Mostre "Calculando…"
com `Skeleton` enquanto pagina. Janela padrão: últimos 30 dias, com seletor 7, 30, 90 dias. Todos os números saem dos
dados do app; nunca de estimativa. Filtro de data usa `opened_at`: filtrar por `created_at` dá erro 422, porque
só campos declarados no esquema são filtráveis.

## Cartões do topo (`StatCard`)

| Cartão | Como calcular |
|---|---|
| Abertos agora | `count({closed_at:{null:true}})` |
| Atrasados | `count({closed_at:{null:true}, due_at:{lt: agora}})` |
| Sem responsável | `count({closed_at:{null:true}, assigned_to:{null:true}})` |
| Aguardando triagem | `count({triaged:false, closed_at:{null:true}})` |

## Abertos por prioridade

Quatro `count()` com `{closed_at:{null:true}, priority:x}`. Barras horizontais na ordem Urgente, Alta, Média, Baixa,
com o número ao lado. Clicar numa barra abre a Fila filtrada.

## Tempo de primeira resposta

Chamados criados na janela com `first_response_at` preenchido: `minutos = first_response_at - opened_at`.
- Mostre a **mediana** como número principal (um caso extremo não distorce) e a média em texto menor.
- **% dentro do prazo**: `first_response_at <= first_response_due_at` / total com resposta.
- Chamados ainda sem resposta entram à parte: "7 ainda sem primeira resposta".
- Quebra por prioridade em tabela: prioridade, mediana, % no prazo.

## Tempo de resolução

Chamados com `closed_at` dentro da janela: `closed_at - opened_at`. Mediana, média, % dentro de `due_at`, quebra
por prioridade e por categoria.

## Urgentes e altos abertos há mais de 7 dias

Lista, não número: `{priority:{in:['urgent','high']}, closed_at:{null:true}, opened_at:{lt: agora - 7 dias}}`,
ordenada pelo mais antigo. Cada linha com protocolo, assunto, cliente, responsável, dias em aberto e botão para
abrir. Estado vazio: "Nenhum urgente parado. Bom sinal." Esta lista é o principal alerta de cliente em risco.

## Outras visões

- **Volume por dia** (criados e fechados), linha, últimos 30 dias.
- **Por categoria**: `count()` por categoria ativa, abertos e fechados na janela.
- **Por responsável**: abertos, atrasados, fechados na janela e mediana de resolução de cada um.
- **Resoluções**: distribuição por tipo de resolução na janela (barras). Muitos "Cliente não respondeu" pedem
  revisão do texto das respostas; muitos "Duplicado" pedem melhorar a busca de chamado aberto.
- **Reabertos**: % de fechados na janela com `reopen_count > 0`.
- **Por canal**: de onde chegam os chamados.

## Formatação

- Duração: menos de 1 h em minutos ("45 min"); até 48 h em horas e minutos ("2 h 15 min"); acima, dias e horas
  ("3 d 4 h").
- Porcentagem com vírgula e sem casas quando inteira ("87%", "87,5%").
- Datas dd/mm/aaaa e hora 24h com `formatDate`/`formatDateTime`.
- Colunas numéricas alinhadas à direita.

## Base grande

Acima de uns 5 mil chamados na janela, a paginação no navegador fica lenta. Nesse caso sugira ao dono (próxima
mudança) um modelo de resumo diário atualizado por função de backend, que exige o plano com funções. Até lá, reduza a
janela padrão para 7 dias.
