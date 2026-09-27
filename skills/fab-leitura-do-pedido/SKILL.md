---
name: fab-leitura-do-pedido
description: "Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli): transforma um pedido vago em entendimento firme antes de construir. Mede o tamanho do pedido, dá nota de clareza, pergunta em lotes curtos sugerindo a resposta provável, separa o que o dono disse do que foi suposto, protege os fatos que não podem ser inventados (CNPJ, registro profissional, preço, depoimento, números) e define o modo de cada tela. Use quando o dono pedir app, sistema, site, CRM, agenda, loja ou ferramenta com poucas palavras (\"quero um app pra minha clínica\", \"faz um sistema pra minha oficina\", \"preciso de um CRM\", \"um site pro meu salão\"), quando o pedido for grande ou misturar várias coisas (loja, curso, agenda, financeiro, comunidade), quando não estiver claro quem usa, o que é pago ou o que é público, quando perguntar \"dá pra fazer...?\", ou quando disser \"faz do seu jeito\", \"tanto faz\", \"você decide\". Vale para qualquer nicho: saúde, advocacia, imobiliária, oficina, restaurante, academia, escola, igreja, loja."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Leitura do Pedido
  edition: terminal
---

# Leitura do Pedido

Esta skill garante que nada seja construído em cima de um pedido mal entendido. O portão é real: o plano que você
escreve e mostra ao dono antes de qualquer código, e que ele aprova com todas as letras. Esta skill decide o que chega
a esse portão e com que grau de certeza.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
`references/fabapp-cli.md` (Node, `status`, login, `create` ou `link`, `pull`, `dev`, contrato ao vivo) e só então
comece. Leia `DECISOES.md` na raiz do projeto, se existir: o que está lá já foi dito pelo dono. Numa sondagem
(seção 1), responda antes; a configuração só é necessária quando for construir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) discordarem
sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

A leitura tem seis partes, sempre nesta ordem: tamanho do pedido, nota de clareza, perguntas, o que foi dito e o que
foi suposto, a verdade do produto, o modo de cada tela. Tudo termina numa frase: "Entendi assim: ...".

## 1. O tamanho do pedido

Classifique antes da primeira pergunta e diga a classificação ao dono, em português simples, para ele poder corrigir.

| Tamanho | O que é | O que a IA entrega |
|---|---|---|
| **Sondagem** | Dúvida de viabilidade: "dá pra...?", "é possível...?", "só quero testar se...". A saída é uma resposta, não um app. | 2 a 3 frases: o que dá, o que não dá e a recomendação. Nada construído. Se algo for mostrado, é rascunho e diz que é rascunho. |
| **Limitado** | Mudança pequena num fluxo que **já existe** no app do dono: um campo, um filtro, um texto, um botão. | Desenho curto em 2 a 4 frases (o que muda, onde aparece, o que não muda) e só as perguntas que importam. |
| **Arquitetural** | App novo, área nova (financeiro num app de agenda), ou mudança em como as partes se ligam (quem vê o quê, papéis, pagamento, o que é público). | Processo inteiro: nota, rodadas, nota "disse/assumi", verdade do produto, modos, plano com lista de conferência. |

Frases de anúncio (adapte ao caso):
- "Isso é um app novo, com várias telas. Vou entender tudo antes e te mostrar o plano para você aprovar."
- "É um ajuste pequeno no que já existe. Te digo em duas frases como fica e sigo."
- "Essa é uma dúvida de viabilidade. Te respondo o que dá e o que não dá, sem construir nada ainda."

Regras do tamanho:
1. **App novo é sempre arquitetural**, inclusive "uma lista de tarefas simples". Limitado mede o app que existe, não
   a sua familiaridade com o tipo de app: se o fluxo ainda não existe para ser lido, não é limitado.
2. **Na dúvida entre dois tamanhos, fique com o maior.** Escolher o menor para pular trabalho já é a dúvida.
3. **A catraca só sobe.** Se no meio aparecer complexidade escondida (um "pequeno ajuste" que mexe em quem vê o quê,
   em pagamento ou em papéis), pare, diga ao dono "isso é maior do que parecia, vou tratar como parte nova do app" e
   siga o processo maior. Nada desce no meio do caminho.
4. **Cada pedido tem a própria classificação.** Responder a uma sondagem não aprova construir; se o dono depois disser
   "então faz", é um pedido novo e passa pelo processo dele.
5. **Pedido com vários sistemas independentes** (loja + curso + comunidade + financeiro): diga isso antes de refinar
   detalhe. Proponha a primeira versão com o núcleo (a parte de que as outras dependem, ou a que traz dinheiro
   primeiro) e as outras partes como próximos passos, na ordem de menor retrabalho. Cada parte depois terá o próprio
   ciclo de leitura, plano e construção.

| Pensamento | Realidade |
|---|---|
| "É simples demais para precisar de plano" | Um app novo passa pelo plano. Um ajuste recebe duas frases. O tamanho define o formato, não o pulo. |
| "Vou chamar de limitado e pular a parte chata" | Buscar o rótulo menor para economizar trabalho é a própria dúvida. Fique com o maior. |
| "Conheço esse tipo de app, então é limitado" | Limitado mede o app do dono, não a sua experiência. Sem fluxo existente, é arquitetural. |
| "A sondagem deu certo, já aproveito e construo" | A resposta da sondagem é uma recomendação. Construir é outro pedido. |
| "Cresceu, mas já estou quase no fim" | Complexidade descoberta sobe o tamanho. Pare e diga. |
| "Ele aprovou a ideia, então aprovou o resto" | Cada aprovação vale para o que foi mostrado. Plano não mostrado não está aprovado. |

## 2. A nota de clareza (0 a 100)

Dê a nota em silêncio logo depois de ouvir o pedido e refaça depois de cada resposta. Ela diz se já dá para entregar
ou se falta perguntar. Não mostre o número ao dono; diga em palavras ("já entendi quase tudo, faltam dois pontos").

| Dimensão | Item | Pontos |
|---|---|---|
| **Funcional (30)** | O que entra e o que sai: o que se cadastra, o que aparece, o que sai em lista ou relatório | 10 |
| | Quem faz o quê: o passo a passo da ação principal, do começo ao fim | 10 |
| | Como se sabe que deu certo: o que o dono vê quando a ação terminou | 10 |
| **Operação do negócio (25)** | Quem usa e com que papel (cliente, equipe, dono, visitante sem conta) | 8 |
| | Canais e ligações reais: WhatsApp, e-mail, pagamento, planilha que já existe | 8 |
| | Restrições: o que é público e o que é privado, dinheiro, prazos, dados sensíveis | 9 |
| **Completude (25)** | Casos de borda: cancelou, desistiu, faltou, lista vazia, muitos registros | 8 |
| | O que acontece quando dá errado (pagamento recusado, horário ocupado) | 9 |
| | Dados e validação: campos obrigatórios, status que o registro percorre, quem muda o status | 8 |
| **Contexto (20)** | O problema que o app resolve, na palavra do dono | 7 |
| | Para quem é (público, situação, momento em que usa) | 7 |
| | Como o dono vai medir que valeu a pena | 6 |

Como pontuar:
- Conta inteiro o que o dono disse, confirmou ou está claro no pedido, no anexo ou no site dele lido com a ferramenta de leitura de páginas da sua ferramenta.
- Conta **metade** o que você supôs e registrou como suposição com alternativa.
- Conta zero o que você só imaginou e não registrou.

O que fazer com a nota:
- **90 ou mais**: não pergunte. Reflita o entendimento ("Entendi assim") e entregue.
- **70 a 89**: uma rodada focada nos itens abertos de maior peso; o resto vira suposição registrada.
- **Menos de 70**: rodada 1 com 3 a 5 perguntas; refaça a nota; rodada 2 com até 3 perguntas se ainda estiver abaixo
  de 90; o que sobrar vira suposição. No máximo 3 rodadas, no máximo 6 perguntas por rodada (se a ferramenta de
  perguntas aceita menos por chamada, divida a rodada em chamadas seguidas).

Não abra rodada de perguntas quando o pedido já traz telas, campos, papéis e regras, quando é um defeito com o passo a
passo para reproduzir, ou quando cita uma tela ou um campo que já existe: reflita o entendimento e siga.

Duas perguntas que você faz a si mesmo sobre cada função pedida, antes de perguntar detalhe:
- **Por quê?** Essa função é necessária agora? Para que ela serve ao problema do dono? Se não serve, vira próximo passo.
- **Mais simples?** Existe um jeito menor que resolve o mesmo problema? Se existe, ele é a recomendação.

Pergunte o porquê ao dono quando a razão muda o desenho: "Por que a avaliação só depois do atendimento?" revela a regra
que impede avaliação falsa.

## 3. Perguntas em lotes, com a resposta provável sugerida

- Pergunte com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma
  mensagem curta com as opções numeradas.
- Comece pelos itens de maior peso ainda abertos. Um tema por lote, 2 a 3 perguntas relacionadas.
- Cada pergunta tem 2 a 4 opções que o dono consegue imaginar, a recomendada em primeiro, marcada "(Recomendado)", e
  espaço para "Outro". Permita várias respostas quando mais de uma opção pode valer junto; uma só quando se excluem.
- Use as palavras do próprio dono. Dê exemplo quando ajudar ("ex.: corte, barba, sobrancelha").
- Não pergunte o que já foi dito. Não transforme o óbvio em menu: afirme a leitura provável e convide a corrigir.
- Não pergunte tecnologia, e não gaste pergunta desta leitura com cor ou fonte. Se o dono já disse cor, fonte ou uma
  referência visual, registre como fato.
- Quando houver 2 ou 3 jeitos de montar a mesma coisa, ofereça como opções com a troca em uma linha na descrição da
  opção,
  recomendado primeiro, cortando o que não é necessário (ex.: "Agenda por profissional (Recomendado): cada um vê a
  sua" / "Agenda única da casa: mais simples, todos veem tudo").
- Pergunta que se entende melhor vendo do que lendo (lista ou quadro de colunas, cardápio em grade ou em lista): mande
  2 a 4 referências reais (links de sites ou apps que existem e mostram cada forma), na hora em que a pergunta
  aparece. Pergunta de conceito continua em texto.
- Se o dono responder "tanto faz", "decide você" ou não responder: isso é a resposta. Siga com as opções
  recomendadas, registre cada uma como suposição e diga já na resposta seguinte: "Decidi X, Y e Z. Se algo não servir,
  é só me dizer."

Rodada 1: propósito, pessoas e resultado (escolha as 2 a 5 que mais mudam o app):
1. "Quem vai usar o app no dia a dia?" (Só meus clientes / Minha equipe, sem clientes / Clientes e equipe, cada um com
   sua parte). Marque como recomendada a que o pedido sugere.
2. "Qual é a ação mais importante do app?" (Agendar / Comprar ou pedir / Registrar atendimento / Acompanhar andamento).
3. "Conta como essa ação acontece, do começo ao fim: o que a pessoa vê primeiro, o que decide, o que acontece depois
   de confirmar." (aberta)
4. "Como você vai saber que o app está te ajudando?" (Menos mensagens repetidas no WhatsApp / Mais agendamentos ou
   vendas por semana / Menos papel e planilha / Saber quanto entrou no mês).
5. "O que só o seu negócio tem, que um concorrente não poderia dizer igual?" (aberta; só em telas de persuadir)

Rodada 2: material, comportamento e limites (só o que ficou aberto):
6. "Quantos [clientes, pedidos, alunos] por mês, mais ou menos?" (faixas com a típica do nicho recomendada). A resposta
   define mínimo, típico e máximo, e se a lista precisa de busca e paginação.
7. "O que um visitante sem conta pode ver?" (Só a página de apresentação / O catálogo ou a agenda livre / Tudo; só
   agir exige conta).
8. "Quando dá errado (cancelou, faltou, desistiu na metade), o que acontece?" (Pode remarcar sozinho / Precisa falar
   comigo / Perde o horário).
9. "Você já tem esses dados numa planilha?" (Sim, vou importar / Não, começo do zero).
10. "O que deixaria o app errado para você, mesmo bonito?" (aberta)
11. "O que pode ficar para depois?" Sugira o corte e peça confirmação.

Perguntas por modo de tela (seção 6 abaixo), só quando o modo existe no app:
- **Persuadir**: quem precisa agir, no que precisa acreditar, que prova real existe (fotos, números, avaliações).
- **Operar**: qual tarefa, que informação ela pede, com que frequência, que situações importam (atraso, falta).
- **Ler**: que dúvida o leitor traz, de onde vem o conteúdo, como ele se acha no texto.
- **Experiência**: o que aparece primeiro, como se explora, que interação é o ponto alto.

## 4. O que você disse e o que eu assumi

Antes do plano, escreva a nota que o dono consegue conferir. Ela separa o que ele falou do que você decidiu:

> **Entendi assim:** (a frase da seção 7)
> **Você disse:** 3 a 6 itens com as palavras dele.
> **Eu assumi (corrija se não for):** cada item no formato "Assumi X. Se não for, Y."

Regras:
- Nunca apresente uma suposição como coisa dita. Nunca repita na lista de suposições o que o dono disse.
- Suposição de **alto impacto** (quem usa, o que é pago, o que é público, o que é enviado a clientes) não fica
  escondida: ou vira pergunta na rodada, ou vai no topo da lista de suposições.
- A correção do dono é incorporada antes do plano valer: refaça a nota e o plano com a correção.
- **Carregue a intenção até o fim**: cada função e cada escolha do plano precisa servir a algo do "Entendi assim". O
  que não serve vira próximo passo.
- Quando o pedido já traz propósito e restrições, não pergunte de novo: reflita o que entendeu, curto.

## 5. A verdade do produto

Separe três listas e mantenha as três até o plano:

- **Fatos informados**: o que o dono deu, com a fonte (mensagem, anexo, site dele). Nome do negócio, serviços, preços
  que ele citou, endereço, horário, marca.
- **Fatos inferidos**: o que você deduziu (do nicho, da cidade, do tom). Cada um é marcado "inferido" e vira suposição
  ou pergunta; nunca aparece no app como afirmação.
- **Não informado, não inventar**: tudo que o app mostraria como fato e o dono não deu. Sempre confira esta lista:
  CNPJ, razão social, CRM, CRO, CRECI, OAB, CREA, CRP, CREF e outros registros; preços e condições de pagamento;
  depoimentos e avaliações; nota no Google; número de clientes, de atendimentos, anos de mercado; prêmios,
  certificações, selos; parceiros e logos de clientes; nomes e fotos da equipe; resultados, "antes e depois",
  garantias e promessas de resultado; endereço, horário, telefone e WhatsApp.

Como o app trata o que falta (decisão fechada, vale para o plano e para a construção):
1. Fato que muda com o tempo (preço, horário, serviços, depoimentos, equipe) vem de um modelo de dados que o dono
   preenche no app. A seção só aparece quando existe registro. Nada de depoimento de exemplo, nada de texto falso.
2. Fato fixo de identidade que falta (CNPJ, registro profissional, endereço) aparece como marcador visível no lugar
   certo, no formato "[preencher: CNPJ]", e entra nos avisos da entrega para o dono completar.
3. Dado de demonstração de tela só existe marcado como exemplo e removível. Números de painel saem dos dados do app,
   nunca do modelo. Nomes de exemplo são brasileiros, variados e realistas (nada de "Fulano", "João da Silva" em tudo,
   "Empresa X"); nada de número redondo de enfeite.
4. Nichos regulados (saúde, odontologia, psicologia, advocacia, imóveis, finanças, educação física): não prometer
   resultado, não mostrar "antes e depois" nem preço promocional sem o dono confirmar que o conselho dele permite.
5. Restrições silenciosas vencem o gosto: público infantil, idosos, acessibilidade, serviço público, área de confiança
   (saúde, dinheiro) pedem clareza e sobriedade antes de efeito.
6. Texto sem clichê: nada de "Eleve", "Transforme", "Revolucione", "Descubra o poder", "soluções inovadoras",
   "excelência em", "qualidade e compromisso", "Bem-vindo ao nosso site". Verbo concreto do negócio.

## 6. O modo de cada superfície

O modo diz como é o sucesso do visitante naquela tela. Escolha pela **tela**, não pelo negócio: a página de uma
ferramenta continua sendo persuadir; o painel de uma marca de moda continua sendo operar.

| Modo | Sucesso do visitante | Telas típicas | O que manda na tela |
|---|---|---|---|
| **Persuadir** | Decide e age | Página inicial pública, serviços, preços, campanha | A oferta clara e a ação principal visíveis na primeira tela; prova real |
| **Operar** | Termina uma tarefa | Agenda, lista de pedidos, cadastro, painel, configurações | Achar e agir rápido; consistência; estados completos; nada de herói com slogan |
| **Ler** | Entende algo | Ajuda, política, orientação de preparo, artigo | Estrutura, largura de leitura confortável, títulos que guiam |
| **Experiência** | Está dentro da obra | Portfólio, galeria, vitrine de trabalhos | A obra aparece primeiro; a interface some |

Três controles de 1 a 10 fecham o comportamento de cada tela, em palavras que o dono entende:

| Controle | 1 a 3 | 4 a 7 | 8 a 10 |
|---|---|---|---|
| **Sóbrio ↔ ousado** | Grade simétrica, alinhamento previsível | Deslocamentos, proporções variadas | Assimetria forte (no celular vira uma coluna) |
| **Parado ↔ animado** | Só resposta a toque e passagem do mouse | Entradas suaves ao rolar | Coreografia de rolagem (paralaxe, seção presa) |
| **Arejado ↔ completo** | Muito respiro | Espaçamento padrão de app | Denso: linhas finas separando dados, números alinhados |

| Caso | Sóbrio/ousado | Parado/animado | Arejado/completo |
|---|---|---|---|
| Persuadir, negócio local comum | 6 | 5 | 4 |
| Persuadir, marca premium ou estúdio criativo | 8 | 7 | 3 |
| Persuadir, confiança (saúde, jurídico, finanças, governo) | 3 | 2 | 5 |
| Operar, uso diário da equipe | 3 | 2 | 7 |
| Operar, cliente final no celular | 4 | 3 | 4 |
| Ler | 4 | 2 | 3 |
| Experiência | 8 | 7 | 3 |

Palavras do dono que mexem nos controles: "minimalista, limpo, calmo" puxam para 5/3/2; "chique, premium, luxo" para
7/6/3; "divertido, ousado, diferente" para 9/8/3; "sério, confiável, institucional" para 3/2/5. Refazer mantendo a
cara atual: iguale ao que existe e suba 1 em animado. Recomeçar o visual: ousado +2, animado +2.

## 7. "Entendi assim"

Antes de fechar, leia estes sinais: tipo de app ou página; palavras de clima que o dono usou; referências que citou
(sites, apps, concorrentes, prints); o público; a marca que já existe (logo, cor, fotos); restrições silenciosas.

Depois escreva uma linha, e só uma:

> **Entendi assim:** <tipo de app ou página> para <quem>, que precisa <ação principal>, com tom <tom>, puxando para
> <referência ou família visual>.

Exemplo: "Entendi assim: app de agendamento para uma barbearia de bairro, em que o cliente marca horário pelo celular
e a equipe vê a agenda do dia, com tom descontraído e direto, puxando para app de delivery, com o WhatsApp à mão."

- Diga a leitura logo depois de ouvir o pedido, junto com o tamanho: corrigir cedo é barato ("não, é barbearia").
  Repita a versão final no plano.
- Se a leitura se divide de verdade entre duas, faça **uma** pergunta com duas opções e a recomendada primeiro. Se dá
  para inferir com segurança, não pergunte.
- A leitura decide o tom; o padrão da categoria não decide nada. Tom de funerária não é tom de festa infantil.

**Refazer algo que já existe**: descubra se é recomeço total, refazer mantendo a cara ou repaginar o visual mantendo
conteúdo. Se não estiver claro, pergunte uma vez: "Quer manter a cara atual e melhorar, ou recomeçar o visual?"
(Manter e melhorar (Recomendado) / Recomeçar o visual). Em qualquer caso, nunca mude em silêncio rotas, rótulos do
menu, campos de formulário, logo, textos legais e textos que o dono escreveu (se a skill `fab-redesign-e-polimento`
estiver instalada, ela traz a lista completa);
melhorias pontuais que servem ao pedido entram, reforma sem relação com o pedido não.

## A conversa: da primeira mensagem ao plano

Ordem da conversa:
1. Ouça o pedido inteiro. Se veio uma frase só, peça em uma linha: o negócio, para quem é, o que as pessoas fazem no
   app e o que deve acontecer depois que ele existir.
2. Anuncie o tamanho e a leitura provisória ("Entendi assim: ...") numa resposta curta.
3. Dê a nota em silêncio. Depois de cada mensagem do dono, atualize para você o estado de cada tema (resolvido, em
   discussão, aberto): as dimensões da nota caem em quem usa, fluxo principal, dados, permissões, dinheiro, avisos,
   conteúdo, identidade e o que fica fora.
4. Faça as rodadas da seção 3 com a ferramenta de perguntas, respeitando a cadência da nota.
5. Mostre a nota "Você disse / Eu assumi" numa mensagem curta e escreva o plano em seguida. A aprovação do plano pelo
   dono é o botão de começar; se ele corrigir algo, refaça a nota e mostre o plano inteiro de novo.

O que a conversa entrega ao plano (antes, no Studio, eram os campos da entrega do briefing):
- **Visão geral** (200 a 450 palavras): abre com a linha "Entendi assim"; traz o que o dono disse como requisito;
  lista as telas com o modo e os três controles de cada uma (ex.: "Agenda da equipe: operar, sóbrio 3, parado 2,
  completo 7"); termina com duas linhas fixas: "Fatos informados: ..." e "Não informado, não inventar: ... (mostrar
  marcador '[preencher: X]' ou esconder a seção até o dono cadastrar)".
- **Suposições** (até 12, frases curtas): "Assumi X. Se não for, Y.", as de alto impacto primeiro.
- **Próximos passos**: as partes que ficaram fora da primeira versão, na ordem de menor retrabalho, cada uma dizendo o
  que não mudar.
- **Avisos**: os fatos a preencher ("O CNPJ e o CRO aparecem como '[preencher]' até você completar") e os limites
  reais que a sondagem encontrou.
- **Marca**: parte só do que o dono deu (cor, fonte, referência) ou do que decorre de uma referência que ele nomeou.
  Pelo terminal, a paleta, o par de fontes e o raio que vão para `apps/<slug>/fab.config.json → theme` são propostos
  por você no plano, a partir disso e do tom, e aprovados junto com ele (chaves em `references/fabapp-cli.md`). Não é
  pergunta desta leitura.

## O plano: o que a leitura vira no plano

O plano é um texto que você escreve e mostra ao dono antes de codar. Se o pedido chegou direto como "faz o plano", faça
a leitura antes mesmo assim: tamanho, nota, leitura "Entendi assim" e verdade do produto, com as perguntas nas mesmas
regras de lote e de resposta sugerida.

O plano traz:
- **Visão geral** abre com a linha "Entendi assim" e um parágrafo curto "Fatos do negócio" com as listas informados e
  "não informado, não inventar".
- **Telas**: cada tela com o modo e os três controles, e o que manda nela (ex.: "Início: persuadir, 6/5/4, oferta e
  botão Agendar na primeira tela").
- Cada tela com um propósito só; se uma tela faz duas coisas, são duas telas ou duas abas.
- **O que NÃO vamos construir**: as partes deixadas para depois (decomposição e "Por quê?"), com o motivo e por que é
  seguro somar depois.
- Pedido que se revelou maior no plano: diga isso na sua resposta e trate a parte nova como próximo passo ou como área
  própria do plano.

Em **Suposições**: só o que você decidiu, cada uma com o impacto (alto quando muda quem usa, o que é pago, o que é
público ou o que é enviado a clientes) e a alternativa escrita como pergunta que o dono pode escolher.

Em **Marca**: o tom sempre escrito, a partir da leitura (nunca do padrão da categoria). Cor e referência como fato só
quando o dono disse; o resto é a sua proposta de `theme`, marcada como proposta.

Na **lista de conferência** (sem teto de itens), inclua estes, adaptados ao app (além dos do fluxo principal), cada um
marcado com como se confere: no código (leitura e `grep`) ou na tela (pré-visualização do `fabapp dev`):
1. (no código) "Nenhum texto do app afirma CNPJ, registro profissional, preço, depoimento, nota, número de clientes ou anos
   de mercado que o dono não informou; onde falta, aparece '[preencher: X]' ou a seção não aparece."
2. (no código) "Depoimentos, preços e horários vêm dos modelos de dados; a seção some quando não há registro."
3. (na tela) "Telas de operar abrem direto na lista ou na ação, sem herói com slogan."
4. (na tela) "Na tela inicial de persuadir, a oferta e o botão da ação principal aparecem na primeira tela, no celular."
5. (no código) "A ação principal do 'Entendi assim' está a no máximo um toque da tela inicial."
6. (no código) "Os nomes que o dono usa ('atendimento', 'paciente', 'OS') aparecem iguais em menus, títulos e botões."
7. Uma linha por suposição de alto impacto, dizendo o que o app faz, para o dono ver a escolha no plano.

Antes de mostrar o plano, releia com olhos novos e corrija na hora, sem nova rodada:
1. **Marcador vazio**: "a definir", "etc.", seção pela metade, requisito vago. Troque por decisão.
2. **Coerência**: uma seção contradiz outra? As telas batem com as funcionalidades e com o modelo de dados?
3. **Escopo**: cabe numa primeira versão ou precisa quebrar em partes?
4. **Ambiguidade**: algum requisito pode ser lido de dois jeitos? Escolha um e escreva.

Corrija só o que faria o app sair errado; estilo de frase não é problema. Se o dono pedir mudança, aplique exatamente o
pedido, explique na sua resposta, refaça estas quatro conferências e mostre o plano de novo. Só a aprovação explícita
do dono libera a construção.

Com o plano aprovado, anote em `DECISOES.md` a Identidade (o que é, para quem, idioma, moeda), a Marca, as Decisões,
o que fica Fora do escopo e as Pendências do dono no Studio. Nunca guarde segredo nem dado pessoal de cliente ali.

## Exemplos

Aplique os exemplos de `references/exemplos.md`: um pedido arquitetural (clínica odontológica) do começo à entrega, uma
sondagem (lembrete automático no WhatsApp) e um pedido limitado.
