---
name: retencao-de-clientes
description: "Faz o app segurar cliente: mostra quem está sumindo antes de ir embora, com nota de risco que explica o motivo (sumiu do ritmo dele, comprou menos, pagamento atrasado, chamado parado, avaliação ruim), cria tarefas de contato em massa com prévia, acompanha o cliente novo nos primeiros 30 dias com boas-vindas e check-ins em dias certos, reativa quem parou há 60 dias com mensagem aprovada pelo dono e mede retenção e perda de clientes mês a mês, respeitando o consentimento e o descadastro. Pelo terminal na Fabapp AI (CLI @fabappai/cli). Use quando o dono disser: clientes somem, quero que o cliente volte, cliente inativo, reativar clientes, fidelizar, retenção, churn, cancelamentos, aluno parou de vir, paciente não voltou, quem não compra há tempo, pós-venda, boas-vindas ao cliente novo, acompanhamento do cliente, régua de relacionamento, clientes em risco, recuperar cliente. Para academia, salão, clínica, escola, delivery, loja, assinatura, serviço. Também acrescenta retenção a app existente (CRM, loja, agenda)."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Retenção de Clientes
  edition: terminal
---

# Retenção de Clientes

Cliente raramente avisa que vai embora: ele para. O app construído com esta skill acha esse cliente cedo, diz por que
ele está em risco, organiza quem da equipe fala com ele e quando, e mede se funcionou. Tudo abaixo é requisito; um
componente que "se aproxima" não satisfaz. Você constrói e edita esse app pelo terminal, com o CLI `@fabappai/cli`.

- **Primeiro movimento**: se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
  `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então
  comece. Leia `DECISOES.md` se existir.
- **O contrato ao vivo vence**: onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga
  a documentação ao vivo e avise o dono em uma linha.
- **Duas mãos**: enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Sempre: base e regras que não mudam

**Evento de valor.** A retenção é medida pelo que o cliente faz de valor: pedido, atendimento concluído, aula com
presença, mensalidade paga, visita. O plano nomeia qual modelo do app é esse evento, o campo do cliente (`ref`), o
campo de data e o de valor em dinheiro. App sem nenhum desses: crie `visit` (cliente, data, valor, tipo). Não crie
segundo cadastro de clientes se o app já tem um (rode `fabapp pull` e leia o `fab.schema.json` antes).

1. **Risco explicável.** A nota vai de 0 a 100 e cada ponto tem motivo escrito na tela ("Sumiu: 7 meses sem vir;
   o normal dele é 3 meses. +35"). Tabela de pontos, faixas e ritmo em `references/risco-e-relatorios.md`; aplique
   ao pé da letra.
2. **Ritmo do próprio cliente, não média da empresa.** Quieto = intervalo atual maior que 2 vezes o intervalo
   normal dele (mediana); sumido = maior que 3 vezes. Cliente anual não entra na lista só por estar 5 meses fora.
3. **Ordenar por valor, não por silêncio.** Faixa primeiro; dentro dela, quem criticou e sumiu no topo, depois o
   gasto dos últimos 12 meses. "Trabalhar hoje" mostra 15 nomes: 15 que a equipe liga valem mais que 200 que
   ninguém liga.
4. **Toda tarefa tem cliente, responsável e data.** Tarefa solta não aparece em lugar nenhum; o modelo exige o
   `ref` do cliente.
5. **Ação em lote segue o protocolo de operação segura e grava no modelo `audit_log`** (prévia com contagem, número
   digitado acima de 20, lotes de 200, entrada no `audit_log`); o específico da retenção está em
   `references/risco-e-relatorios.md`, seção Operações em massa. (Se a skill `dados-seguros` estiver instalada, ela
   detalha o protocolo.)
6. **Mensagem de marketing só com consentimento; descadastro em toda mensagem; parar depois de uma tentativa de
   reconquista.** Detalhes em `references/boas-vindas-e-mensagens.md`.
7. **Nada sai sem o dono aprovar**, uma mensagem por vez, e nenhuma oferta fora da lista que o dono autorizou.
8. **A plataforma não roda cálculo agendado.** O risco é calculado quando alguém abre a tela; a automação diária só
   avisa "veja os clientes em risco de hoje". Diga isso ao dono.

Referências: `references/modelo-de-dados.md`, `references/risco-e-relatorios.md`,
`references/boas-vindas-e-mensagens.md` e `references/fabapp-cli.md` (onde cada coisa vive na plataforma).

## A conversa: o que perguntar

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela,
uma mensagem curta com as opções numeradas. Até 6 perguntas desta skill; pule as que o pedido já respondeu.

1. **O que mostra que o cliente continua com você?**
   - Ele compra ou faz pedido de novo (Recomendado para loja e delivery)
   - Ele volta para um novo atendimento ou consulta
   - Ele vem às aulas ou treinos
   - Ele paga a mensalidade ou assinatura
2. **Depois de quanto tempo sem aparecer você considera o cliente parado?**
   - 60 dias (Recomendado)
   - 30 dias (negócio de compra frequente, como delivery ou academia)
   - 90 dias (serviço de intervalo longo)
3. **Como você quer receber o cliente novo nos primeiros 30 dias?**
   - Boas-vindas e check-ins nos dias 0, 1, 3, 7, 14 e 30, com a mensagem pronta para a equipe enviar (Recomendado)
   - Só boas-vindas e um check-in no dia 7
   - Não quero sequência para cliente novo
4. **Por onde falar com o cliente?** (várias)
   - WhatsApp, com a mensagem pronta para apertar enviar (Recomendado)
   - E-mail
   - Aviso no app, se o cliente tem login
   - WhatsApp automático (precisa conectar o WhatsApp Business no Studio)
5. **O que você pode oferecer para um cliente voltar?** (várias)
   - Uma ligação ou recado pessoal, sem oferta (Recomendado para cliente de valor alto)
   - Um desconto na volta (diga quanto)
   - Um serviço cortesia (diga qual)
   - Nada além do contato
6. **Quem faz os contatos?**
   - Eu e a equipe, cada cliente com um responsável (Recomendado)
   - Só eu

Suposições padrão: janela de "ativo" de 90 dias para o relatório de perda mensal; mensagens de segunda a sábado,
das 8h às 20h; no máximo uma mensagem de marketing por cliente a cada 7 dias; uma tentativa de reconquista, depois
90 dias sem insistir. Use o que o app já tem (cobrança, chamados, avaliações) como sinal; o que não existe fica
desligado e aparece como "sem dados" no painel. Anote em `DECISOES.md`: evento de valor, prazo de parado, sequência
de boas-vindas, canais, ofertas autorizadas, quem contata.

**Marca:** esta skill não impõe cor nem fonte. No terminal você define: proponha paleta, par tipográfico e raio,
peça aprovação e grave em `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`), enviado com
`fabapp push`. No código, só tokens do tema. O logo o dono sobe no Studio.

## O plano: telas, dados e lista de conferência

Escreva o plano como texto e mostre ao dono antes de codar; ele aprova antes da construção. O plano traz telas,
modelo de dados, as decisões desta skill, suposições com alternativa, o que não entra e a lista de conferência.

**Modelos** (esquema e acessos em `references/modelo-de-dados.md`; aplique exatamente): campos de retenção no
`customer` (ou o cadastro que o app já tem), `retention_task`, `outreach`, `journey_step`, `optout_request`,
`retention_settings`, `risk_snapshot`, `audit_log`, e o evento de valor.

**Telas da equipe** (abas: Hoje, Em risco, Boas-vindas, Relatórios, Ajustes):
1. **Hoje** `/retencao`: 15 clientes para trabalhar hoje (faixa, motivo principal, valor em 12 meses, botão
   WhatsApp e "Criar plano"); tarefas vencidas e do dia do usuário; clientes novos com passo das boas-vindas hoje;
   pedidos de descadastro a aplicar.
2. **Em risco** `/retencao/risco`: lista completa com nota, faixa (Vermelho, Amarelo), motivos com pontos,
   responsável; filtros por faixa e responsável; seleção para "Criar plano de contato" em massa.
3. **Ficha do cliente**: cartão "Saúde do cliente" na página que o app já tem (ou `/clientes/:id`): nota, motivos,
   ritmo ("costuma voltar a cada 35 dias; está há 82"), últimos eventos, tarefas, histórico de mensagens,
   consentimento.
4. **Boas-vindas** `/retencao/boas-vindas`: clientes dos últimos 30 dias, dia das boas-vindas, passo do dia, ativado
   ou não; botão de enviar o passo.
5. **Reativar** `/retencao/reativar`: parados há 60 dias ou mais (regra do ritmo), ordenados por valor, com rascunho
   pela IA e aprovação um por um.
6. **Relatórios** `/retencao/relatorios`: de `references/risco-e-relatorios.md`.
7. **Ajustes**: pesos, prazos, textos das boas-vindas, ofertas autorizadas, texto do consentimento.
Página pública `/descadastrar`.

**Avisos** (só `notify`): passos das boas-vindas por automação `relative` sobre `customer.started_at` para a equipe
(e para o cliente com login); tarefa vencendo para o responsável; resumo diário para admin; pedido de descadastro
para admin. Textos em `references/modelo-de-dados.md`.

**Lista de conferência** (inclua todos, mais a conferência dos primeiros 30 dias de
`references/boas-vindas-e-mensagens.md`):
- código: a nota de risco soma exatamente os pontos da tabela de `references/risco-e-relatorios.md`, limitada a
  100, com faixas Vermelho 70+, Amarelo 40 a 69, Verde abaixo de 40.
- código: todo motivo de risco exibido traz o dado que o gerou e os pontos.
- código: quieto e sumido usam a mediana dos intervalos do próprio cliente (3 ou mais eventos) ou a mediana da
  empresa com o selo "estimativa".
- código: a lista em risco ordena por faixa, depois crítica mais sumiço, depois gasto em 12 meses.
- código: criar plano em massa mostra prévia (clientes, tarefas, responsável, datas), pede o número digitado acima
  de 20 tarefas, cria com `bulkCreate` em lotes de 200 e grava `audit_log`.
- código: nenhuma mensagem de marketing sai para cliente sem `marketing_opt_in` ou com `marketing_opted_out_at` ou
  com pedido de descadastro pendente; o botão fica desabilitado com o motivo.
- código: toda mensagem de marketing termina com a instrução de descadastro.
- código: cliente com `winback_sent_at` nos últimos 90 dias não aparece para nova reconquista.
- código: relatórios paginam até o fim antes de somar; filtros de data usam campos declarados, nunca `created_at`.
- visual: estado vazio com ação em cada lista ("Ninguém em risco hoje. Ver todos os clientes").

"O que não vamos construir": cálculo automático de madrugada; envio automático sem aprovação; teste A/B automático.

## A construção: como implementar

Ordem: schema e automações (`fabapp push`), depois tema, depois código (`fabapp deploy`). Vale também para
mudanças depois.

**Esquema e avisos** de `references/modelo-de-dados.md`: `fabapp pull`, edite `fab.schema.json` e
`fab.automations.json` (o arquivo de automações substitui o conjunto inteiro: mantenha as que já existem e
acrescente) e envie com `fabapp push` (ou `fabapp_write_definition` pelo MCP). Os pontos, o ritmo e as faixas ficam
num único arquivo `src/lib/retention.ts` com funções puras (`computeRhythm`, `computeRisk`, `rankCustomers`),
testáveis e reusadas por todas as telas. Pesos vêm de `retention_settings.weights` quando preenchido; senão, da
tabela padrão.

**Carregar dados.** Eventos de valor dos últimos 15 meses com `list({filter:{<data>:{gte}}, fields:[cliente, data,
valor], limit:200, offset})` até voltar menos que 200; agrupe por cliente no navegador. Sinais extras só se o
modelo existe no app: cobrança vencida, `ticket` aberto, `feedback`/`review`, `retention_task` sem resposta. Mostre
progresso ("Lendo 1.200 pedidos…"). Acima de 10 mil eventos na janela, avise o dono que a tela vai ficar lenta e
sugira, como próximo pedido, um resumo calculado por função de backend (`functions/<nome>.ts` com entrada em
`fab.functions.json`; exige o mesmo plano pago que libera o CLI).

**Criar plano de contato.** Botão na lista e na ficha. Monta as tarefas do roteiro da faixa (Vermelho ou Amarelo,
em `references/risco-e-relatorios.md`) com datas a partir de agora, responsável = responsável do cliente (ou quem
clicou), `reason` = motivos atuais. Prévia: "12 clientes, 72 tarefas, responsáveis: Ana (40), Bruno (32), primeira
data hoje 15h". Confirma, grava em lotes com `bulkCreate` (atômico por lote), relata por lote e registra no
`audit_log`. Cliente que já tem plano aberto é pulado e listado como "já tem plano".

**Primeiros 30 dias do cliente novo.** `started_at` (datetime) é gravado quando o cliente é cadastrado ou faz o
primeiro evento de valor. As automações avisam a equipe no dia de cada passo; a tela Boas-vindas mostra o texto do
`journey_step` daquele dia já com os dados do cliente e escolhe a variante: se o cliente já fez o evento de
ativação, texto do próximo passo; se não, texto de ajuda para o primeiro passo. Envio pelos canais de
`references/boas-vindas-e-mensagens.md`; cada envio grava `outreach`.

**Reativação.** Lista pela regra do ritmo com mínimo de `inactive_days` (padrão 60). Para cada cliente, "Rascunhar"
chama `invokeLLM({tier:'smart', system, prompt, schema})` com o histórico real (último serviço, data, item
favorito) e a lista de ofertas autorizadas; o dono edita, aprova e envia um por um. Regras da mensagem e tabela de
oferta por segmento em `references/boas-vindas-e-mensagens.md`. 402 cai no caminho manual ("Sem créditos de IA;
escreva à mão") e o histórico do cliente entra no prompt como dado, não instrução. Ao enviar, grave
`winback_sent_at` e `outreach`.

**Consentimento e descadastro.** Formulários de cliente têm a caixa de marketing desmarcada, com o texto de
`retention_settings.consent_text`; marcar grava `marketing_opt_in`, `marketing_opt_in_at` e
`marketing_opt_in_channel`. `/descadastrar` cria `optout_request` (telefone ou e-mail, normalizados). Antes de
qualquer envio de marketing, confira `marketing_opted_out_at` e `count` de `optout_request` pendente com o mesmo
contato. A tela Hoje mostra os pedidos pendentes com "Aplicar" (grava `marketing_opted_out_at`, fecha o pedido,
registra no log).

**Perdido.** "Marcar como perdido" pede motivo (enum) e grava `lost_at`, `lost_reason` e `lost_signals` (os motivos
de risco daquele momento), para a revisão trimestral.

**Retrato semanal e mensal.** Ao abrir Relatórios, se não existe `risk_snapshot` da semana (ou do mês fechado),
grave um com as contagens calculadas. É o que permite a linha de tendência sem cálculo agendado.

**Erros.** `ApiError` com `e.message`; 403 "Você não tem acesso a este cliente"; 429 no e-mail "Limite de e-mails
do dia; use o WhatsApp". Nunca `window.confirm`.

**Dados de exemplo.** O CLI não grava registros. Os exemplos de `references/modelo-de-dados.md` ficam numa
constante com o botão "Carregar exemplos" (só admin, com prévia), marcados como exemplo. O dono também pode
cadastrar ou importar pelo CMS do Studio. Nunca diga que criou dados.

## Conferir antes de dizer pronto

Rode `fabapp dev`, abra a pré-visualização e percorra cada item da lista de conferência (rota, elemento, estado),
no celular e no desktop, inclusive `/descadastrar`. Confira por busca (`grep`) em `src/`: nenhum hex nem neutro
fixo, nenhum `window.confirm`, `alert(` ou `prompt(`, nenhum `animation-timeline`, nenhum `<img>` com URL externa,
nenhum `await import(`, nenhum envio dentro de `useEffect`. Confira que `fab.automations.json` só cita modelos e
campos do schema (troque `customer` pelo cadastro real quando for outro). Depois `fabapp deploy`:
`account_builds_busy` (409) é esperar e repetir; `build_failed` (422) é consertar arquivo e linha indicados, sem
repetir às cegas.

Na mensagem final ao dono, relate só o que conferiu, o link, e repita que o risco é calculado quando a tela abre.
O que ele faz no Studio: conectar o WhatsApp Business se escolheu envio automático; ligar SMS se quiser esse canal;
subir o logo; cadastrar ou importar dados no CMS, se não usar os botões do app. Próximos pedidos: página "Primeiros
passos" para o cliente; revisão trimestral dos pesos.

## Mudanças depois: pedidos comuns

Leia `DECISOES.md` antes e atualize depois.

- **"Mande para todos os inativos de uma vez"**: mantenha a aprovação, mas ofereça aprovar o texto-modelo uma vez e
  revisar a lista com prévia e contagem antes; cada envio continua respeitando consentimento e o limite de uma
  tentativa. Envio automático sem prévia: não.
- **"Mude o dia 3 para dia 5"**: é automação (`offset_days` em `fab.automations.json`, com `fabapp pull` antes e
  `fabapp push` depois) e texto do `journey_step`; mude os dois e avise que clientes já nas boas-vindas seguem a
  regra nova a partir de agora.
- **"O risco está errado para fulano"**: abra os motivos dele; ajuste peso em Ajustes, não no código. Registre a
  mudança no `audit_log`.
- **"Lista grande demais"**: suba a linha do Vermelho (ex.: 80) em Ajustes; lista curta demais e cliente perdido
  fora dela: desça.
- **Cobrança junto com reativação**: não misture; atraso vira tarefa de conversa particular.

## Regras brasileiras

- **LGPD específica da retenção**: mensagem de relacionamento sobre o serviço contratado (boas-vindas, lembrete do
  agendado) tem base na execução do contrato; reativação, oferta e check-in de relacionamento são marketing e exigem
  consentimento (campos `marketing_opt_in*` e `marketing_opted_out_at`). Na dúvida, trate como marketing.
- **WhatsApp**: fora da janela de 24 h da última conversa, só modelo aprovado pela Meta; sem a integração, link
  `https://wa.me/55DDDNUMERO?text=...` com o texto pronto.
- **CDC**: oferta enviada vincula (art. 30): só oferta que o dono autorizou e pode cumprir, com validade escrita.
  Cobrança sem constrangimento nem ameaça (art. 42), nunca misturada com convite de volta.
- **Horário**: mensagens de segunda a sábado, das 8h às 20h.
- Formato brasileiro (R$ 1.234,56, dd/mm/aaaa, telefone, "você"); exportar os dados de um cliente e anonimizar a
  pedido são ações individuais na ficha, registradas no `audit_log`. (Se a skill `padroes-brasil` estiver
  instalada, ela manda nisso.)

## Não fazer

- Não ordenar risco só por tempo sem comprar, nem comparar todo mundo com a média da empresa.
- Não mostrar nota de risco sem o motivo.
- Não criar tarefa sem cliente, sem responsável ou sem data.
- Não enviar marketing sem consentimento, nem sem descadastro, nem fora do horário.
- Não mandar segunda tentativa de reconquista antes de 90 dias.
- Não inventar desconto, brinde, número ou histórico do cliente na mensagem.
- Não prometer ao dono cálculo automático diário: a tela calcula ao abrir.
- Não contar cliente que "baixou o app" ou "fez cadastro" como ativado: ativação é evento de valor.
