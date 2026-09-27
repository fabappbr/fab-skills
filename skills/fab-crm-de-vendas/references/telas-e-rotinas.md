# Telas e rotinas

Casca: app com abas embaixo no celular (Hoje, Funil, Contatos, Leads, Mais) e as mesmas seções no cabeçalho no computador. Sem Leads no plano, a 4ª aba é Tarefas. "Mais" abre Ligar hoje, Tarefas, Saúde dos dados, Relatórios, Carteiras, Segmentos, Prospecção, Importar, Configurações (só as incluídas). Login fora da casca; o app é privado (tela de entrada com painel dividido), exceto `/contato`.

Escopo: vendedor vê a própria carteira (regra de acesso). Gestor e dono têm o seletor "Minha carteira · Equipe · Vendedor X", que começa em "Minha carteira". Carteira vazia mostra "Sua carteira ainda está vazia" com ação (Novo contato, Importar); nunca amplia sozinho para a equipe.

## Hoje (resumo diário)

Ordem fixa, cada bloco com no máximo 5 itens e "ver todos":
1. **Precisa de você**: leads quentes sem resposta (com o tempo esperando), tarefas vencidas, negócios com fechamento vencido, rascunhos esperando aprovação. Vazio: "Nada urgente. Bom trabalho."
2. **Compromissos de hoje**: tarefas e reuniões com `due_at` hoje, cada uma com o contexto do negócio (etapa, valor, última atividade em uma linha, o que mudou desde o último toque) e um foco sugerido (o critério de saída que falta).
3. **Fechando em 14 dias**: negócios abertos com `expected_close` até hoje + 14, com selos "sem próximo passo" e "sem atividade há N dias".
4. **Leads novos e envelhecendo**: do formulário e sem resposta, mais antigos primeiro.
5. **3 ações principais do dia**, cada uma com o botão que a executa (Ligar, Abrir negócio, Responder).
Rodapé: funil aberto (quantidade e R$) e previsão ponderada do mês (`StatCard`). Números vêm da carteira em escopo.

## Ligar hoje (lista de ligações)

Seletor de quantos (1 a 10, padrão 5) e de data (padrão hoje). Sempre mostra exatamente N quando existem N candidatos.

Pontuação de cada contato com negócio aberto ou lead ativo (some):

| Sinal | Pontos |
|---|---|
| Lead quente sem resposta | 40 |
| Reunião marcada para amanhã ou hoje (confirmar) | 35 |
| Próximo passo vencido ou para hoje, do tipo ligar | 30 |
| Mensagem do cliente sem resposta há mais de 3 dias | 25 |
| Negócio fecha em até 14 dias | 20 |
| Valor acima da mediana dos abertos | 15 |
| `lead_status` conectado | 15 |
| Sem contato há 7 a 30 dias | 10 |
| Em cadência (tentando, menos de 5 tentativas) | 8 |

Empate: vence quem tem mensagem do cliente sem resposta. Se todos empatam, ordene pela escada de fatos (próximo passo vencido, fechamento mais próximo, maior valor, mais tempo sem contato) e diga "Ordem por data e valor: os sinais ficaram iguais".

Cartão de ligação:
```
1. Ana Souza, Padaria Trigo Bom
Negócio: R$ 18.400,00 · Etapa: Proposta enviada · Último contato: há 9 dias
Sinal: pediu desconto no WhatsApp em 12/09
PONTOS DA CONVERSA
• (das 3 últimas atividades)
• (o critério de saída que falta)
• pergunta aberta: (a pergunta da qualificação com nível 0)
OBJETIVO DA LIGAÇÃO: (uma frase: avançar etapa, retomar, fechar)
```
Botões: Ligar (`tel:`), WhatsApp (link wa.me), Registrar resultado (os 7 resultados de `pipeline-e-etapas.md`; "Não atendeu" soma `attempts` e marca tentativa), Adiar. Registrar resultado cria a atividade e pede o próximo passo.
Extras: "Folha para imprimir" (página de impressão: uma linha por pessoa, objetivo, 2 ou 3 pontos, linha em branco para anotar; sem gráficos). Com Google Agenda ligada no Studio: "Reservar 20 min para cada ligação" mostra os horários propostos e só grava (`google.calendarInsert`) os que o usuário marcar. Mensagem do cliente sem resposta há mais de 3 dias: rascunho de retomada curto (uma frase sobre a conversa anterior, uma com próximo passo), para aprovar.

## Leads novos (resposta rápida)

Formulário público em `/contato` (nome, WhatsApp, e-mail opcional, mensagem, interesse, cidade, consentimento de marketing desmarcado) cria `inquiry`. Automação avisa o dono e o gestor na hora. Com WhatsApp integrado, a automação de mensagem recebida avisa também, e o dono cola a mensagem em "Novo lead" (a IA separa nome, telefone e pedido).

Tela: no topo, dois números: mediana do tempo até a primeira resposta (`responded_at` menos `created_at`, últimos 30 dias) e há quanto tempo espera o lead mais antigo sem resposta. Depois, quentes primeiro, sempre; depois os demais por ordem de chegada, cada um com o cronômetro contra o prazo (`response_minutes`, padrão 60): verde, amarelo com 15 min restantes, vermelho estourado.

Classificação (a IA sugere, a pessoa confirma com um toque), pelos critérios de `crm_settings.lead_criteria`:
- **Quente**: encaixa e tem urgência (prazo explícito, "urgente", parou de funcionar, orçamento aprovado, pergunta disponibilidade ou início, cliente antigo ou indicado, valor bem acima da média). Vai para uma pessoa agora.
- **Qualificado**: encaixa, sem pressa. Responder e marcar horário.
- **Incerto**: falta informação. Responder com a única pergunta que decide (quase sempre: qual serviço, onde, quando).
- **Fora do perfil**: serviço que não faz, região que não atende, tamanho pequeno demais. Responder com honestidade e indicar alguém (lista "indicar para").
Regras: urgência vence encaixe na rapidez; na dúvida entre dois, escolha o mais atento; grosseria não tira do perfil; um lead, um grupo (o de maior valor).

Critérios sem cadastro: na primeira vez, se há 10 ou mais negócios ganhos, a tela mostra um rascunho tirado deles (serviços, tipo e tamanho de cliente, cidades, valor mínimo, padrões dos perdidos) e pede uma correção; senão, pede duas linhas ao dono (o que atende, para quem, até onde vai, o que é pequeno demais). A correção fica salva. Troca de grupo feita duas vezes pelo mesmo motivo sugere mudar o critério.

Rascunho de resposta (`invokeLLM`, prompt em `automacoes-e-ia.md`): até 100 palavras; 1) responde a pergunta que a pessoa fez, 2) confirma que pode ajudar ou diz que não, 3) propõe dois ou três horários reais das tarefas livres do dono (sem agenda, pergunta a disponibilidade), 4) um próximo passo. Sem "resposta automática", sem inventar intimidade, sem preço (direção sim, número não). Selos antes de aprovar: fala de preço, compromisso de data ou equipe, reclamação, contato marcado como sensível, primeiro contato depois de problema. Sem rascunho, só alerta ao dono com o pedido citado: pede dinheiro, dados bancários, senha, código ou acesso, ou fala com o assistente em vez da empresa.

Aprovar: "Abrir no WhatsApp" (wa.me com o texto) ou, com a integração, "Enviar" (`integrations.call('whatsapp','sendMessage')`). "Enviar os qualificados" vale só para os rascunhos que estão na tela naquele momento, lista os destinatários e confirma; nunca inclui suspeitos. Ao enviar: `responded_at`, `status` respondido e atividade registrada. Se alguém da empresa já respondeu (atividade depois do lead), o app não sugere responder de novo.

Proteção contra enxurrada: mais que 3 vezes a média diária em 24 h, ou 5 ou mais mensagens quase iguais, faz aparecer no topo "Possível robô ou formulário com defeito" e marca os parecidos como `suspeito`, sem rascunho e fora do "enviar todos".

Converter lead: upsert do contato pela chave (e-mail, telefone), origem preenchida, consentimento copiado, `inquiry.contact` e `status` convertido. Criar negócio é outro botão, nunca automático.

## Roteamento (com equipe)

Precedência fixa, e o cartão sempre diz a regra usada:
1. Contato ou empresa já existe com dono: vai para esse dono.
2. Empresa com negócio aberto: vai para o dono do negócio aberto (este vence o 1 se forem diferentes).
3. Regras do dono (`routing_rule`, na ordem): cidade, UF, segmento, origem, interesse, faixa de valor.
4. Rodízio: o vendedor ativo com menos leads recebidos hoje; empate por nome. Mesma entrada, mesma resposta.

Cartão por lead (vários viram um quadro de cartões): dono recomendado e a regra ("empresa já é da Carla" ou "UF = MG → Rafael"); grupo sugerido; rascunho do recado para quem recebe (quem é, o que pediu, por que é quente); quando faltam dados para rotear com segurança, rascunho da pergunta ao lead. Botões: Aceitar, Trocar (pede motivo em uma linha; sem motivo grava "sem motivo informado"). Aceitar ou trocar grava `assigned_to`, `route_note` e `audit_log` (antes, depois, regra ou motivo). Motivos de troca repetidos aparecem em Configurações como "sugestão de regra". Dono que vem só do texto colado (não das regras nem da base) é mostrado antes de aplicar.

## Funil (kanban)

Coluna por etapa aberta com quantidade e soma em R$ no topo; Ganho e Perdido recolhidos no fim. Filtros: vendedor, origem, fechamento no mês, parados. Cartão: título, contato, valor, dias na etapa, selo de parado, próximo passo com data (vermelho se vencido). Arrastar abre o diálogo de mudança de etapa; nunca muda direto. No celular, lista agrupada por etapa com "Mover" no cartão.

## Ficha do negócio

Cabeçalho: título, valor, etapa, probabilidade (da etapa), fechamento previsto, dono, próximo passo editável. Abas: Resumo, O que falta, Linha do tempo, Pessoas, Plano de fechamento (módulo), Proposta (módulo), Mais informações (campos extras).

**O que falta** (roda ao abrir, sem IA; a frase de resumo pode ser escrita pela IA a partir dos dados):
1. Alvo: próxima etapa (padrão) ou "até fechar" (todas as seguintes).
2. Para cada critério de saída do alvo: feito, em andamento (há tarefa aberta ligada) ou não iniciado, com a evidência (link da atividade) e de quem é (nós, cliente, outra pessoa da empresa).
3. Qualificação: só as perguntas que bloqueiam o avanço entram como lacuna.
4. Caminho: ordene as lacunas; a primeira é a que destrava mais itens seguintes; marque o que pode andar em paralelo.
5. Data mais cedo crível = hoje + soma das medianas de dias das etapas restantes. Se passar do `expected_close`, selo "data de fechamento não é crível".
6. Resumo de uma ou duas frases ("Avança quando X e Y acontecerem; o caminho passa por Z"), tabela de lacunas (lacuna, de quem, o que trava, evidência), itens já andando com data prevista (não pedir de novo) e sugestões: próximo passo = ação 1; nova data de fechamento se não é crível. Cada sugestão tem "Aplicar"; nada é gravado sem o clique.

**Pessoas**: `deal_contact` com papel. Um só contato no negócio gera o selo "depende de uma pessoa só".

**Linha do tempo**: atividades mais recentes primeiro, filtro por tipo e período, modo compacto (data, tipo, resumo de uma linha). Nota de correção fica ao lado da original.

## Plano de fechamento (módulo)

Para negócios em Proposta ou depois. Duas partes:
- **Por que comprar agora** (`business_case`): situação atual e custo, resultado desejado (as métricas do cliente), solução proposta ligada a cada resultado, investimento e retorno em conta simples, risco de esperar, por que nós (só diferenciais a que o cliente reagiu). Cada item aponta a atividade que o prova; item sem evidência ganha o selo "validar na próxima conversa" e não entra no texto para o cliente.
- **Passos até a assinatura** (`close_plan_step`): calculados de trás para frente a partir da data alvo (padrão `expected_close`). Modelo inicial editável: proposta final, aprovação de quem paga, ajuste de contrato, assinatura, sinal ou primeiro pagamento, início. Cada passo: responsável (nós, cliente, nome), data, status. Passo com data vencida ou que empurra a assinatura além da data alvo fica vermelho com "a data de fechamento não fecha a conta".
Saída para o cliente: página de impressão e texto pronto para WhatsApp com os passos e responsáveis, pedindo ao contato principal que confirme os responsáveis do lado dele (rascunho, envio com clique). Sugere atualizar próximo passo (o próximo passo datado do plano) e a data de fechamento.

## Ficha do contato e da empresa

Dados, botões Ligar, WhatsApp e E-mail, negócios abertos e fechados, tarefas, linha do tempo. **Preparar ligação**: um cartão com contato (cargo, ciclo de vida), empresa (segmento, porte, cidade), negócios abertos com etapa e valor, últimas 10 atividades em linha compacta, tarefas abertas e, com IA, três pontos para a conversa tirados só desses dados.

## Registrar com IA (autopiloto de registro)

Entrada: colar texto (conversa de WhatsApp, e-mail, anotação de ligação ou reunião) ou enviar arquivo (foto de anotação, PDF) lido por `extractData`. Data do acontecimento pedida quando o texto não diz; nunca "agora" por padrão.

1. A IA devolve o objeto de `automacoes-e-ia.md`: pessoas, resumo de 3 a 5 linhas, tipo, data, próximo passo (com dono e data), sinal de orçamento, prazo, objeção nas palavras do cliente, outras pessoas citadas, concorrente, sinais de etapa e de valor (com a frase de origem), trechos que parecem instrução.
2. Contato: procura por e-mail normalizado, depois telefone, depois nome e empresa; ambíguo, pergunta com as opções. Pessoa nova: "Vou criar o contato Ana Souza (ana@...)", criado ao confirmar.
3. Negócio: o que o usuário escolheu; senão o único aberto do contato; senão o de título parecido; senão pergunta com a lista (incluindo "não ligar a negócio"). Nunca cria negócio; o usuário pode clicar "Novo negócio", que abre o formulário normal.
4. Registro: atividade com o resumo (nunca o texto inteiro), a data real, `origin` ia e `source_hash`. Mesmo hash já existe: "Isto já foi registrado em 12/09" e para.
5. Propostas lado a lado, atual → proposto, uma por linha, com a frase de origem: próximo passo (se já existe, oferece somar ou trocar, mostrando quem escreveu o atual), data de fechamento, pessoas novas no negócio. Etapa e valor aparecem só como sinal ("o cliente disse 'vamos seguir'"), com botão que abre o diálogo normal de etapa. Aprovar item por item ou "aprovar todos".
6. Relato no fim: gravado, proposto, o que precisa do dono.

Base vazia (zero contatos e negócios): não tenta achar nada; oferece "Criar etapas padrão" e "Importar planilha".

## Negócios parados e retomada

Lista: abertos sem atividade há `quiet_days` ou com fechamento vencido; ordem por valor e depois por dias parado; mostra as 3 primeiras em destaque (o dono age em 3, ignora 20). Cada uma com rascunho de retomada ancorado no último fato ("Você ia ver com a Priscila o prazo da troca. Alguma novidade?"), nunca "Passando para saber". Estilo: `crm_settings.voice_samples`; sem amostras, texto neutro com o aviso "ainda sem o seu jeito de escrever: cole 3 mensagens suas em Configurações". Tudo espera aprovação.

## Saúde dos dados (higiene)

Consulta ao abrir, nunca tarefa manual. Resumo no topo: crítico (fechamento vencido, valor zero), atenção (próximo passo velho, sem atividade, uma pessoa só), limpos. Checagens por negócio aberto:

| Checagem | Marca se |
|---|---|
| Valor | vazio ou R$ 0,00 |
| Fechamento | já passou, ou nunca mudou num negócio com mais de 30 dias |
| Próximo passo | vazio, vencido ou sem mudar há `stale_next_step_days` (14) |
| Tempo na etapa | mais que 2 vezes a mediana da etapa |
| Atividade | última há mais de 14 dias, ou nenhuma |
| Pessoas | nenhum contato ou só um |
| Critério da etapa | etapa pede proposta e não há proposta |
| Dono | sem dono |
Por contato e empresa: sem e-mail e sem telefone, sem dono, sem origem, telefone inválido, contato sem empresa quando é PJ, empresa sem negócio aberto (só informativo).

Sugestões com "Aplicar": próximo passo no formato "dd/mm, verbo, o quê, com quem" tirado da última atividade; data de fechamento = hoje + mediana dos dias restantes; etapa quando a evidência contradiz (só sinal). Ações em lote no fim ("12 negócios com data vencida: empurrar 30 dias") pelo padrão de lote.

**Duplicados**: carrega a base inteira paginando (nunca uma página só: duplicado que cruza páginas some) e agrupa por `email_norm`, `phone_norm`, CPF, CNPJ, e nome da empresa sem acento e sem "Ltda", "ME", "EIRELI". **Mesclar com prévia**: escolhe o principal (padrão: o mais antigo), mostra campo a campo qual valor fica (o do principal, ou o preenchido quando o principal está vazio), conta o que será movido (atividades, negócios, tarefas, pessoas nos negócios) e avisa "Mesclar não tem volta". Ao confirmar: `updateWhere({contact: secundario}, {contact: principal})` em cada modelo filho, atualiza o principal, remove o secundário e grava `audit_log` com antes e depois. Em lote, pares acima de 100 exigem digitar o número.

## Carteiras e transferência (com equipe)

Tabela por vendedor: contatos, empresas, negócios abertos, valor aberto, tarefas vencidas; linha "Sem dono" com atalho para distribuir. **Transferir carteira** (vendedor saiu ou redistribuição): de quem, para quem, o que (contatos, empresas, negócios abertos, tarefas abertas; negócios fechados opcional). Prévia por tipo com contagem e amostra, confirmação pelo padrão de lote, `audit_log` por tipo. Mudança de responsável de um registro só: campo "Responsável" na ficha, só para gestor e dono.

## Segmentos e exportação

Construtor de filtro sobre contatos (ou empresas): ciclo de vida, status do lead, dono ou sem dono, origem, cidade, UF, segmento e porte da empresa, tags, consentimento, última atividade antes ou depois de uma data, nunca contatado, quantidade de negócios abertos (0, 1 ou mais, 2 ou mais para oferta a quem já compra). Dentro do grupo, E; entre grupos, OU. Cada grupo roda no servidor com os operadores do SDK; a união por id e os filtros que o servidor não expressa (quantidade de negócios, campo extra, trecho de texto) são feitos na tela depois de paginar. Contagem ao vivo antes de salvar. Segmentos prontos: leads sem dono, conectados sem negócio, clientes sem contato há 60 dias, clientes com 2 ou mais negócios. Salvar grava `segment`. Ações sobre o segmento: exportar CSV (`CsvExport`; "para campanha" exclui sem consentimento e opt-out e diz quantos saíram; grava `audit_log` exportar), dar dono em lote, criar tarefa para cada um (padrão de lote).

## Importar planilha (upsert por chave natural)

`CsvImport` para .csv; .xlsx lido no navegador com o pacote `read-excel-file`. Passos: 1) mapear colunas (usa os cabeçalhos da própria planilha e sugere o campo); 2) escolher a chave (e-mail, telefone ou documento, normalizados), o responsável e a origem padrão para linhas sem esses dados; 3) prévia: quantos serão criados, quantos atualizados, quantos com erro e por quê (e-mail inválido, telefone sem DDD, CPF inválido, obrigatório vazio); 4) regra de sobrescrita: campo preenchido na base só é trocado se o usuário marcar "atualizar campos já preenchidos" (padrão: só preenche vazios); 5) executar em blocos de 200 (`bulkCreate` para novos, `update` para existentes), com barra de progresso. Relatório por linha na ordem da planilha (ok ou erro com motivo), baixável, e "Reprocessar só os erros" depois de corrigir. Negócios na importação só se a planilha tiver coluna de etapa e o usuário mapear; se alguma criação de contato falhar, os negócios daquela linha não são criados (não ligar registro errado). Tudo em `audit_log` importar, com `origin` importacao.

## Prospecção (módulo)

1. **Perfil do cliente ideal** tirado dos clientes que pagam, não da descrição do dono: valor por cliente = total ganho × anos de relação, descontado se o negócio levou muito para fechar. Compare o quarto de cima com o quarto de baixo em segmento, porte, cidade, origem e primeiro produto; mostre só as dimensões em que diferem. Texto no jeito do dono: "Seus melhores clientes: ... Os que dão menos retorno: ...". O dono corrige uma vez e salva em `crm_settings.icp`. Com menos de 10 clientes: "Ainda não dá para ver padrão", e o perfil vem do que o dono disser. No máximo 5 critérios.
2. **Lista de prospecção** (`prospect`): entrada por planilha ou manual; a tela "Onde procurar" orienta (associações e sindicatos do setor, lista de expositores de feira, Junta Comercial, alvarás e licenças da prefeitura, perfis no Google Maps e Instagram, aplicativos de entrega para restaurantes, reclamações públicas de clientes de concorrentes). O app não busca empresas na internet.
3. **Nota**: encaixe (0 a 10), sinal (0 a 10), alcance (0 a 10); total = encaixe × 0,4 + sinal × 0,4 + alcance × 0,2. Encaixe: 9 a 10 todos os critérios; 7 a 8 falha um secundário; 5 a 6 falta algo importante; 3 a 4 vizinho (só com sinal forte); padrão de pior cliente limita a 4. Sinal: nova unidade, obra ou alvará 10; contratando para a área 9; troca de dono ou gestor 8; ganhou contrato ou investimento 8; reclamações recentes do fornecedor atual 8; época de compra 6; site ou marca renovados 5; nada 2. Alcance: indicação por cliente em comum 10; decisor com contato verificado 8; decisor com contato deduzido 6; pessoa que não decide 4; só telefone geral 3; nenhum 1. Sinal exige data e fonte ("alvará de 14/03, prefeitura"); sem isso é boato e vale 2. Nota abaixo de 4 fica em "cortados". Empate: sinal mais recente. Meta: 40 a 60 empresas; lista menor é honesta.
4. Tela: as 10 primeiras com uma linha de motivo cada ("Abriu segunda loja em março; fornecedor atual com 3 reclamações no trimestre"), contato com selo verificado, deduzido ou desconhecido (empresa sem contato fica na lista). Exporta CSV. **Levar para o CRM**: "Vou criar 47 empresas e 39 contatos com a etiqueta 'prospeccao-2026-09'. Nada que já existe muda." Upsert pelas chaves, só com o sim.

## Propostas (módulo)

Catálogo de produtos; proposta ligada ao negócio com itens (quantidade, preço unitário que pode diferir do catálogo, desconto %), validade e status. Total e descontos calculados na tela. Página de impressão (salvar como PDF pelo navegador) e texto para WhatsApp. Enviar a proposta (clique) preenche `proposal_sent_at` e registra atividade "proposta". Proposta vencida muda para `vencida` ao abrir a lista.

## Configurações

Etapas (ordem por arrastar, probabilidade, tipo, objetivo, ações, critérios de saída, limite de dias, exige proposta, categoria de previsão); origens, motivos de perda e segmentos; campos extras; regras de roteamento e sugestões vindas das trocas; critérios de lead; prazos (resposta, parado, risco); até 3 mensagens de exemplo do dono; valor de negócio grande; "Remover exemplos".

## Padrão de operação em massa (um componente só)

`BulkAction` em `src/components/crm/`: recebe o filtro ou os ids, busca tudo paginando, mostra contagem e amostra de 10 com antes → depois, botão "Confirmar N" (até 20) ou campo "Digite N para confirmar" (acima de 20, protocolo de fab-dados-seguros), executa em blocos de 200 com progresso, relata sucesso e falhas por registro, grava um `audit_log` com a contagem, o filtro e o resumo. Excluir em lote é só do dono e usa `deleteMany`; mesclar e anonimizar dizem que não têm volta. `audit_log` é histórico, não desfazer: a tela "Histórico" lista as ações recentes com quem, quando e quantos.
