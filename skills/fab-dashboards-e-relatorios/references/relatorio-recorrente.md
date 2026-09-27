# Relatório recorrente e narrativa dos números

## O pacote de relatório: definido uma vez, entregue na cadência

O dono já sabe que números quer; o que falta é eles chegarem na segunda sem ele correr atrás. Na Fabapp o pacote é:
uma página de relatório dentro do app (que calcula ao abrir) + um aviso automático com o link. A automação só avisa,
não calcula: por isso o número nunca vai no texto do aviso, só o link.

**Definição (uma vez).** O conteúdo do relatório é fixo no código: os KPIs do painel, a lista de atenção e a
narrativa abaixo. O canal do aviso e a cadência oferecida são decididos no plano e escritos em `fab.automations.json`
na construção, enviado com `fabapp push` depois de um `fabapp pull` (automação não tem condição nem filtro, e o app não a altera em tempo de execução). O que fica em registro
(modelo `report_setting`, acesso `role:admin` em tudo, um registro só) é o que o app consegue ligar e desligar
sozinho: `cadence` (`enum`: `weekly`, `monthly`, `off`) e `offered` (`boolean`). Uma vez definido, o relatório nunca
pergunta de novo o que o dono quer ver.

**Página.** Rota `/relatorios/:periodo` (`2026-09` para mês, `2026-S37` para semana, `2026-09-15` para dia) e
`/relatorios/ultimo`, que abre o último período FECHADO. Só período fechado entra no relatório; o período em
andamento fica no painel.

**Aviso na cadência (automação real da plataforma; gatilhos possíveis: `data`, `schedule` só `daily` ou `hourly`,
`relative` com `offset_days` inteiro, `webhook`; ação única `notify`).**
- Diário (só se o dono escolheu isso na conversa): automação `{ "type": "schedule", "every": "daily" }` com
  `{ "type": "notify", "channel": "inapp", "to": "admin", "title": "Seu resumo de ontem está pronto", "link": "/relatorios/ultimo" }`.
  Chega uma vez por dia, na hora da plataforma (não dá para escolher hora nem minuto). Um gatilho `schedule` não
  tem registro, então `to` só pode ser `admin` ou `role:<slug>` e não há `{{campo}}`. Ele dispara sempre: o dono
  desliga só pedindo uma edição do app (diga isso a ele na mensagem final).
- Semanal ou mensal: a plataforma não tem agenda semanal nem mensal. Use o modelo `report_delivery` com `send_at`
  (`datetime`, ex.: segunda 08:00 `-03:00`, ou dia 1 às 08:00) e `period_key` (`text`), acesso `role:admin` em tudo,
  e a automação `{ "type": "relative", "model": "report_delivery", "field": "send_at", "offset_days": 0 }` com
  `{ "type": "notify", "channel": "inapp", "to": "admin", "title": "Relatório da semana pronto", "link": "/relatorios/{{period_key}}" }`.
  Quando o dono liga a cadência, o app cria as próximas 12 entregas com `bulkCreate`; toda vez que o painel ou o
  relatório abre, o app completa até ter 12 entregas futuras (conferindo com `count({ period_key })` para não
  duplicar). Desligar a cadência apaga as futuras com `deleteMany({ send_at: { gte: agora } })`. A entrega segue o
  relógio da plataforma, por hora, não por minuto.
- Canal: uma automação por canal, fixa na construção. Padrão: `inapp` e, se o app tiver push, uma segunda automação
  igual com `channel: "push"` (os dois são grátis). `email` usa crédito de integração do dono e tem limite diário;
  o `body` não pode ter URL, o link vai no `link`. Diga ao dono o limite real: "o aviso chega com o link; os
  números aparecem quando você abre".

**Oferecer a cadência uma vez só.** Depois que o dono abrir o primeiro relatório, um cartão no fim da página pergunta
"Quer receber isso toda segunda de manhã?" (Sim / Agora não). Sim liga a cadência e confirma em uma linha: "Pronto.
O aviso chega toda segunda, por volta das 8h." Agora não grava `offered=true` e o cartão nunca mais aparece. Nunca
ofereça antes de ele ver um relatório.

**Entrega nunca falha em silêncio.** O aviso sai mesmo com dado faltando; a página mostra a lacuna com nome ("Nenhuma
venda lançada de 10 a 12/09: os números da semana podem estar incompletos") e segue com o resto. Uma segunda sem
relatório parece app quebrado.

**Uma leitura só.** O relatório junta o pacote (os KPIs do dono) e o contexto do negócio no mesmo lugar, na ordem:
resumo do pacote, depois "E o negócio, está bem?" em duas ou três linhas (caixa, tendência de vendas, funil, a lista
de atenção e a única coisa que pede atenção agora). Nunca dois relatórios separados.

**Imprimir.** Botão "Imprimir ou salvar em PDF" com `window.print()` e classes `print:` (esconde navegação e botões,
fundo do tema, quebra de página antes de cada seção). É a forma de mandar o relatório para o contador ou sócio.

## Estrutura da página de relatório (uma página)

1. **Manchete**: uma frase com o achado principal ("Faturamento subiu 15%, mas o desconto subiu mais rápido").
2. **Números do período**: os mesmos `StatCard`s do painel, com a comparação.
3. **O que funcionou**: 2 ou 3 pontos, cada um com número.
4. **O que pede atenção**: 1 a 3 pontos, cada um com número.
5. **Causa provável**: um gráfico pequeno que mostra o porquê (ex.: desconto médio por semana), com uma frase.
6. **Recomendação**: 1 a 3 ações.
7. **Foco do próximo período**: 1 a 3 itens.
8. **Notas sobre os dados** (2 a 4 linhas): o que conta como venda, período e fuso, quantos registros, o que ficou de
   fora e por quê.

Relatório mensal pode trazer o placar de horizontes (uma tabela): faturamento, pedidos, ticket e clientes em 30, 90 e
365 dias, cada um com variação e sinal (melhorando, piorando, estável), só os horizontes que os dados cobrem.

Falta de dado não vira seção vazia, "N/A" nem pedido de desculpas: omite-se o que não dá para medir e a lacuna vai só
nas notas. Menos dados, relatório mais curto.

## Resumo por modelo (o texto que o código monta)

Escolha o modelo pela trajetória da métrica principal contra o período anterior:
- **Crescimento forte (acima de +10%)**: "[Período] cresceu [x]%, puxado por [maior contribuição]. [Observação].
  Vale conferir se o ritmo se mantém ou foi pontual."
- **Estável (de -5% a +10%)**: "[Período] ficou estável, [direção] [x]%. [Ponto forte]. O foco é ajuste fino."
- **Queda (abaixo de -5%)**: "[Período] caiu [x]%, principalmente por [menos pedidos, ticket menor ou clientes que
  sumiram]. [Próxima ação]."
- **Sinais misturados**: "[Positivo], mas [negativo]. [Métrica] melhorou [x]; [outra] piorou [y] e merece olhar."

O resumo sintetiza, não enumera: nada de "Faturamento X, pedidos Y, ticket Z" em fila, nem "nos últimos 30 dias X,
nos últimos 90 Y". Nada de "o negócio foi bem na maioria das métricas" ou "há espaço para melhorias" sem número.

## Estrutura da história

Contexto, conflito, resolução: onde estávamos (a base), o que mudou (o problema ou a oportunidade), o que fazer.
Comece pelo "e daí?": o achado vem primeiro, o método por último. Não enterre o achado; não despeje números; não use
jargão; termine com a próxima ação.

Três formas de relatório conforme a pergunta do dono:
- **Problema e solução**: o gancho em número ("Estamos perdendo R$ 2,4 mil por mês em faltas"), o contexto, o padrão
  encontrado, a ação, o impacto esperado, o pedido.
- **Tendência**: onde começamos, o que mudou (linha do tempo das ações), antes e depois em tabela, o aprendizado, o
  próximo alvo.
- **Comparação**: a pergunta ("abrir sábado ou domingo?"), as duas opções lado a lado com os mesmos critérios, a
  recomendação, o risco.

Recursos visuais: revelação em camadas (no app, o toque no KPI abre o detalhe que explica, e depois o detalhe do
detalhe); contraste antes e depois; anotação do evento no gráfico ("Promoção de 15/08") e linha de meta tracejada.

Incerteza dita com honestidade e em faixa quando for estimativa: "impacto estimado entre R$ 400 e R$ 600", "com 45
vendas no período".

## Plano de ação (no relatório mensal)

No máximo 5 ações, agrupadas por prazo: esta semana (vem do pulso de 30 dias), este mês (do momento de 90 dias), este
trimestre (da estrutura de 365 dias). Cada ação: o que (uma frase concreta), por quê (o dado), quando (data) e como
medir o sucesso (número). Termina sempre com 2 ou 3 limites que não podem piorar (tabela de `kpis-por-negocio.md`).

Impacto estimado só com os dados do app e fórmula à vista, por exemplo: cada 1 p.p. a mais de recompra ≈ clientes
novos no ano × 0,01 × (valor médio de quem compra de novo - valor médio de quem compra uma vez); cada 1 p.p. a menos de
desconto ≈ receita com desconto × 0,01. Marque como estimativa.

## Pergunta pontual ("como foi agosto?")

Resposta curta na tela de relatório daquele período: 2 ou 3 frases com os números, 1 ou 2 observações de contexto,
uma ação se couber. Mês de calendário usa o mês fechado. Sem 12 meses de histórico não há comparação com o mesmo mês
do ano anterior: mostre o valor, a fatia no total do período disponível e a comparação com a média dos meses
anteriores, sem comentar a ausência.

## Briefing diário do vendedor (CRM)

Quando o app é de vendas, o relatório diário é: negócios que fecham nos próximos 7 dias, negócios mexidos nas últimas
24 h, e a linha "Funil aberto: N negócios, R$ X". Semanal: funil por etapa e por vendedor (ranking). Mensal: ganhos e
perdidos, taxa de ganho por vendedor, receita ganha por mês de fechamento.
