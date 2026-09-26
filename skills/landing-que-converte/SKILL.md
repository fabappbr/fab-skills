---
name: landing-que-converte
description: "Monta, na Fabapp AI pelo terminal (CLI @fabappai/cli), a página única de campanha ou anúncio que transforma visita em cliente, com método baseado nas dúvidas reais de quem compra: mapa do funil, as cinco objeções (confiança, preço, se serve para mim, por que agora, dá trabalho), a tabela de objeção e resposta que decide os blocos e a ordem, prova no ponto em que o cliente trava, um botão com um verbo claro, formulário que cai no painel do dono e teste A/B com resultado honesto. Use quando o dono pedir landing page, página de captura, página para anúncio, página de campanha, página de orçamento, funil do site, 'minha página não converte', 'ninguém chama no WhatsApp', 'muita visita e pouco cliente', 'quero testar dois títulos', 'o que colocar na página para vender mais'. Esta skill decide estrutura, ordem dos blocos, prova, medição e teste; as palavras finas são da copy-que-vende, se instalada. Serve para serviço, produto, curso, evento, lançamento ou campanha de qualquer negócio."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Landing que Converte
  edition: terminal
---

# Landing que Converte

Todo visitante que não vira cliente tem um motivo. **Não adivinhe, descubra:** as respostas estão nas perguntas que os clientes já mandam no WhatsApp, nas conversas no balcão e nas avaliações. A landing existe para responder a esses motivos com prova, na ordem e no lugar em que o visitante trava, e levar a **uma** ação.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Esta skill decide o conteúdo, a ordem dos blocos, a ação, a medição e o teste. Cor e fonte vêm da marca do app (o `theme` do `fab.config.json`, combinado com o dono; se ainda não existe, proponha paleta e par de fontes e peça aprovação antes). Aplique `references/objecoes-e-provas.md` para montar a tabela de objeções e `references/titulos-cta-e-testes.md` para títulos, botões, funil e teste. Leia as duas inteiras antes da conversa.

## Nota de 0 a 10 (use no plano, nas mudanças depois e na mensagem final)

Sete perguntas; cada "sim" vale 1,4 ponto (teto 10). Reporte a nota e as linhas que falham.

| Pergunta | Se não |
|---|---|
| 1. Existe UMA ação que o visitante deve fazer? | Definir a ação; tirar os botões que competem |
| 2. As objeções vieram do dono e dos clientes, não de palpite? | Fazer as perguntas da conversa |
| 3. Existe a tabela de objeção e resposta? | Montar; pôr cada resposta no ponto de atrito |
| 4. Em 5 segundos dá para entender o que é, para quem e o próximo passo? | Reescrever o título com as palavras do cliente |
| 5. As provas estão visíveis (avaliações, garantia, registro, fotos reais)? | Levantar as provas que o dono tem e mostrar |
| 6. O funil está mapeado e medido? | Registrar cada passo (veja "Medição") |
| 7. O caminho está livre de atrito (celular, velocidade, formulário curto)? | Cortar campos, corrigir o celular primeiro |

Faixas: 9 a 10 = ação única, tabela vinda de pesquisa, proposta clara em 5 segundos, prova em cada atrito, funil medido. 5 a 6 = objeções chutadas, texto de "boas práticas", prova escondida no FAQ. 3 ou menos = botões competindo, sem funil, promessa sem prova.

## Regra ética (não negociável)

Nada inventado: depoimento, nome ou foto de cliente, nota, número de clientes, prêmio, logo de imprensa, selo, garantia que o dono não dá. Específico da landing: nenhuma escassez falsa (contador que reinicia, "vendidos hoje", "últimas vagas" sem limite real, "Fulano acabou de comprar" inventado). Toda prova é verdadeira e conferível. Uma resposta a objeção resolve a preocupação com evidência; nunca trata uma dúvida legítima como bobagem. Onde falta prova, o bloco não aparece e o plano registra a prova como "a conseguir", com o jeito de conseguir.

## Antes de começar

- Rode o primeiro movimento de `references/fabapp-cli.md`, leia `DECISOES.md` e rode `fabapp pull` para ter `fab.schema.json`, `fab.automations.json` e `apps/<slug>/fab.config.json` atuais no disco. Se o schema já tem `business_profile`, `testimonial`, `faq_item`, `lead` ou um contato de CRM com `lead_status`, use esses modelos em vez de criar outros.
- Leia `references/objecoes-e-provas.md` e `references/titulos-cta-e-testes.md`.

## A conversa: pesquisar com o dono (a voz do cliente)

O dono é a sua pesquisa de saída, seu histórico de chat e seu atendimento. Pergunte com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Até 6 perguntas; pule as que o pedido já respondeu. Escolha as que faltam:

1. **"O que você quer que a pessoa faça ao chegar na página?"** "Chamar no WhatsApp (Recomendado)" / "Preencher um formulário de orçamento" / "Agendar um horário" / "Comprar direto na página". Para serviço local, WhatsApp é o recomendado; para produto com preço fechado, compra.
2. **"Quais dúvidas os clientes mais mandam no WhatsApp antes de fechar?"** (várias escolhas, com espaço para outra): "É confiável? Vocês existem mesmo?" / "Quanto custa? Tem parcelamento ou Pix?" / "Serve para o meu caso?" / "Quanto tempo demora? Atende no meu bairro?" / "Dá muito trabalho? O que eu preciso fazer?".
3. **"O que já fez um cliente quase desistir?"** (aberta). Esta é a pergunta que mais revela; a resposta vira bloco da página.
4. **"Que provas você já tem?"** (várias escolhas): "Avaliações no Google (vou dizer a nota e quantas são)" / "Depoimentos de clientes com autorização para publicar" / "Fotos reais de trabalhos, antes e depois quando permitido" / "Anos de mercado, número de clientes atendidos" / "Garantia ou devolução" / "Registro profissional ou certificado" / "Nenhuma ainda".
5. **"Como um cliente descreveria você para um amigo?"** ou **"Cole 2 ou 3 mensagens reais de clientes (pode apagar os nomes)"** (aberta). As palavras do cliente viram título e subtítulo.
6. **"Quer comparar duas versões da página para ver qual traz mais clientes?"** "Agora não, primeiro publicar uma versão bem feita (Recomendado)" / "Sim, quero testar dois títulos ou duas ofertas". Só recomende o teste quando já existe uma versão rodando com tráfego.

Se a ação principal for compra, pergunte também o preço e as formas de pagamento se a ideia não disse. Não pergunte sobre cor de botão, fonte ou layout.

Anote em `DECISOES.md`: a ação única, as objeções na ordem de importância com as palavras do cliente (sem nome nem dado pessoal de cliente), as provas que existem e as que faltam, e a oferta (preço, prazo, garantia real).

## O plano: funil, tabela de objeções e a ordem dos blocos

Escreva o plano e mostre ao dono antes de codar:

1. **Funil em uma linha**, com os passos que o app mede (modelos em `references/titulos-cta-e-testes.md`). Ex.: Anúncio → Landing → Clique no WhatsApp → Conversa → Orçamento → Fechou. Aponte o passo que mais vaza (a "artéria entupida": muito volume, pouca passagem) e o elo que falta (lembrete, pedido de avaliação, follow-up), com o conserto real na plataforma.
2. **Tabela Objeção / Contra-objeção**, 5 a 8 linhas (0 a 2 parece bom demais para ser verdade; 15 ou mais parece defensivo): Objeção (categoria) | Pergunta do cliente (palavras dele) | Contra-objeção com a prova REAL disponível | Onde entra (bloco e posição) | Formato (texto, prova, garantia, FAQ, tabela, passo a passo). A objeção principal é respondida **acima da dobra**. Cada resposta fica **no ponto de atrito** (a dúvida de pagamento embaixo do botão de pagar; a de prazo junto da oferta), não só no FAQ, e pode repetir em outro formato. Objeção implícita (que o cliente não admite, como preguiça ou medo de não conseguir) é respondida sem ser dita ("Você só escolhe o horário; o resto é com a gente"), nunca "Está com preguiça de...?".
3. **Ordem dos blocos** decidida pela tabela, partindo das 7 seções:
   1. **Herói** (3 a 5 segundos): título = a promessa, com resultado e palavras do cliente; subtítulo = o mecanismo (como entrega) ou o público exato; **um** botão. Nada de "Bem-vindo", nome da marca sozinho, pilha de adjetivos ou frase poética.
   2. **Prova logo abaixo do herói**, antes de pedir mais leitura: nota com contagem, anos, número de atendidos, um depoimento forte com nome e contexto.
   3. **Problema**: 1 a 3 parágrafos com a situação do cliente nas palavras dele. Ressoe antes de vender. Teste: o cliente leria em voz alta e concordaria?
   4. **Solução**: um título e 3 a 5 benefícios, cada um em 1 ou 2 frases, traduzindo recurso em resultado ("Você recebe o laudo no WhatsApp no mesmo dia", não "Laudo digital"), com foto ou imagem real.
   5. **Prova detalhada**: casos com cliente, resultado e número (reais), depoimentos com nome, dados, registro, certificações.
   6. **Objeções**: FAQ com as perguntas do WhatsApp, tabela comparativa (versus alternativa ou concorrente), garantia, e o esforço dito em tempo ("Você resolve em 10 minutos").
   7. **Chamada final**: repete a mesma ação do herói, na situação do cliente, com o redutor de atrito verdadeiro. Nenhuma oferta nova no fim.
   Negócio simples (a maioria dos serviços locais): versão curta em 4 blocos, herói com prova, solução, objeções com FAQ, chamada final. Os elementos continuam; eles se fundem.
4. **Provas**: as que existem, onde entram (hierarquia em `references/objecoes-e-provas.md`), e a lista "a conseguir" com o jeito de conseguir.
5. **Medição** (seção abaixo) e, se o dono quis, a **hipótese do teste**.
6. **Textos-chave escritos**: 3 títulos alternativos de fórmulas diferentes, o escolhido e por quê (os 5 critérios da referência), o rótulo do botão, o redutor de atrito.
7. **Modelo de dados e automação**: `lead` (ou o contato do CRM), `testimonial`, `testimonial_submission`, `faq_item`, `conversion_event`, `business_profile`, com `access`, e a automação de aviso de lead.
8. **SEO da página**: título e descrição (seção "A construção").
9. **Suposições**, cada uma com a alternativa: as objeções que você inferiu sem o dono confirmar.
10. **A nota de 0 a 10** esperada, com as linhas que ainda falham e por quê.

**Lista de conferência** (além dos itens de sempre), com todos estes:
- No celular, a primeira dobra mostra título, subtítulo e um único botão; em 5 segundos dá para dizer o que é e o que fazer (visual).
- A ação principal usa um único componente e o mesmo rótulo no herói, depois das seções grandes, na chamada final e na barra fixa do celular.
- Cada linha da tabela de objeções tem um bloco correspondente na posição prevista.
- Depoimentos vêm do modelo `testimonial` e só aparecem com `authorized: true`; sem registro, a seção não é renderizada.
- O formulário tem no máximo nome, WhatsApp e uma pergunta aberta, valida com `zod` e mostra para que o dado é usado com link para `/privacidade`.
- Cada clique no botão grava um `conversion_event` e chama `trackEvent` com a versão e a posição do botão.
- A automação de lead novo avisa `"admin"` (nunca `"owner"`).
- A página tem título e descrição próprios no `seo` do `fab.config.json` (ou `<FabHead>`, se a rota for dinâmica).

O dono aprova o plano antes da construção.

## A construção: página, botão, formulário e medição

Ordem: `fab.schema.json` e `fab.automations.json` primeiro (`pull` antes, porque o arquivo de automações substitui o conjunto inteiro), depois `seo` (e `theme`, se ainda não houver marca) no `fab.config.json`, `fabapp push`, e só então o código.

**Estrutura.** Casca de site com cabeçalho enxuto (logo e o botão; numa landing de anúncio, sem menu que tire a pessoa da página). Rodapé mínimo: logo, ©, `/privacidade`, contato, CNPJ ou registro quando o dono informar. Texto para quem escaneia: subtítulos que contam a história sozinhos, parágrafos de 2 a 4 frases, listas, "você" mais que "nós", voz ativa, fato no lugar de adjetivo ("entrega em até 2 horas", não "entrega super-rápida"), jargão explicado, e corte metade das palavras de boas-vindas.

**O botão (regras fechadas).**
- Uma intenção por página, **um rótulo** por ação, idêntico em todo lugar.
- Verbo específico e resultado: "Agende sua avaliação", "Quero meu orçamento no WhatsApp", "Garantir minha vaga". Imperativo com "seu/sua" ou primeira pessoa ("Quero...", "Me mostre") no CTA de página pública. Nunca "Enviar", "Clique aqui", "Saiba mais", "Começar", "Fale conosco". Botões de ação dentro do app (salvar, excluir, o painel do dono) ficam no infinitivo ("Salvar", "Excluir"). Se as skills `copy-que-vende` e `textos-de-interface` estiverem instaladas, elas detalham essas duas regras.
- O botão rima com o título: se o título promete orçamento em 1 hora, o botão pede o orçamento, não "Conheça".
- Embaixo, uma linha de redução de atrito **verdadeira** ("Sem compromisso", "Resposta em até 1 hora no horário comercial", "Pix ou 3x no cartão").
- Aparece no herói, depois de cada seção grande, na chamada final e numa barra fixa no celular (`fixed inset-x-0 bottom-0 md:hidden` com `pb-[env(safe-area-inset-bottom)]`; `<main>` com `pb-20 md:pb-0`).
- Um componente só (ex.: `PrimaryCta`) recebendo `position` ("hero", "after_solution", "final", "sticky").

**WhatsApp.** Link `https://wa.me/55DDDNUMERO?text=...` (só dígitos, com 55 e DDD, texto com `encodeURIComponent`; se a skill `padroes-brasil` estiver instalada, ela manda no formato) com uma mensagem que diz a origem e a oferta ("Oi, vim pela página da limpeza de pele e quero agendar"). Número vindo de `business_profile.whatsapp`.

**Formulário de lead.** Se o app tem CRM (contato com `lead_status`, da skill `crm-de-vendas`), o formulário grava nesse contato com `source` preenchido; o modelo `lead` só existe sem CRM. Modelo `lead` com `access` `{"read":"role:admin","create":"public","update":"role:admin","delete":"role:admin"}` e campos `name` (text, obrigatório), `whatsapp` (phone, obrigatório), `message` (text), `status` (enum: `new`, `contacted`, `proposal`, `won`, `lost`; o formulário grava `new`), `variant` (text), `cta_position` (text), `source` (text, com `utm_source` e `utm_campaign` lidos da URL). Validação com `zod`; campos só nome, WhatsApp e uma pergunta aberta (cada campo a mais custa conversão). Junto do botão: "Usamos seu contato só para responder este pedido" e link para `/privacidade`. Sucesso honesto: o que acontece agora e em quanto tempo, com o botão de WhatsApp como atalho. Automação em `fab.automations.json`: gatilho `{"type":"data","model":"lead","event":"created"}` com ação `notify` para `"admin"` (canal `email` ou `push`) com `{{name}}` e `{{whatsapp}}`; nunca `"owner"`, que é quem criou o registro (aqui, o visitante sem conta). Erro: mostre `e.message` e mantenha o que a pessoa digitou.

**Provas como dados.** Depoimentos moram em `testimonial` (read `public`, escrita `role:admin`; é o mesmo esquema da skill `reputacao-e-avaliacoes`, se instalada): `author_display` (nome como "Mariana S."), `author_detail` (bairro, profissão ou cidade), `photo` (image), `body` (a frase literal), `result` (o número ou fato específico), `objection` (enum `trust`, `price`, `fit`, `timing`, `effort`), `authorized` (consentimento do cliente), `active`. `review` é outra coisa: a avaliação por item de cliente logado (peça `<Rating/>`). A página filtra `authorized: true` e `active: true` e põe cada depoimento perto da objeção que ele responde. Para colher depoimentos novos, uma página `/depoimento` grava em `testimonial_submission` (`access` de visitante: read `role:admin`, create `public`, update e delete `role:admin`) com caixa de autorização; o dono aprova e copia para `testimonial` no painel. `faq_item` (read `public`, escrita `role:admin`): `question`, `answer`, `objection`, `order`. Números (nota, contagem, anos, clientes, garantia) vêm do registro único `business_profile` (read `public`, escrita `role:admin`); bloco com campo vazio não aparece.

**Você não grava os registros.** O CLI escreve definição e código, nunca registros (ver "Registros" em `references/fabapp-cli.md`). Depoimentos, perguntas do FAQ e os números do `business_profile` que o dono passou na conversa, ele cadastra no CMS do Studio (aba de dados, que também importa planilha) ou no painel de admin do próprio app. Nunca diga "cadastrei"; entregue a lista do que cadastrar, com os textos que ele já deu prontos para copiar.

**Medição.** Modelo `conversion_event` com `access` de visitante (read `role:admin`, create `public`, update e delete `role:admin`): `kind` (enum `whatsapp_click`, `phone_click`, `form_submit`, `checkout_start`), `variant`, `cta_position`, `page`, `source`. Cada clique no botão grava um evento e chama `trackEvent('Contact', { variant, position })` (ou `'Lead'` no envio do formulário, `'InitiateCheckout'` na compra); o `trackEvent` alimenta o Meta Pixel quando o dono liga o Pixel no Studio, e GA4 e os demais a plataforma injeta sozinha: nunca escreva snippet. Página de admin **"Resultados da página"**: contagens por `kind`, `variant` e `cta_position` com `collection('conversion_event').count({ kind: 'whatsapp_click', variant: 'a' })` (o `count` recebe o filtro direto), e o funil de `lead.status` (ou do `lead_status` do CRM) (novos, contatados, proposta, fechados), com a passagem entre passos em %. Nada de número inventado: tudo sai de `count()`.

**SEO da página.** Escreva em `apps/<slug>/fab.config.json → seo` e envie com `fabapp push`: se a landing é a home, `title` (15 a 60 caracteres) e `description` (50 a 160) com a promessa e o lugar; se é uma rota própria (`/dia-das-maes`), uma entrada em `pages` com título e descrição dela. `"/depoimento"` e as rotas de admin ("Resultados da página") com `"index": false`. `ogImage` como URL absoluta `https://` de PNG ou JPEG 1200x630, porque a página vai ser compartilhada no WhatsApp (SVG é ignorado); sem imagem pronta, fica na lista do dono. Rota dinâmica usa `<FabHead title description image/>`. Nunca escreva `<title>`.

**Teste A/B, quando o dono quis.** Aplique a receita de `references/titulos-cta-e-testes.md`: as duas versões no mesmo componente com a variação por prop, a versão sorteada 50/50 na primeira visita e guardada no navegador, a data de fim fixada antes de começar, e a tela de resultado que só declara vencedora depois da data e com a conta de significância da referência. A configuração do teste (`ab_active`, `ab_hypothesis`, `ab_start`, `ab_end`) mora no registro `business_profile`: quem liga o teste e grava as datas é o dono, no painel de admin do app ou no CMS; entregue a ele os valores combinados.

## Conferir antes de dizer pronto

1. Rode `fabapp dev` e abra a pré-visualização, primeiro em 375px e depois no desktop. Percorra cada item da lista de conferência: a primeira dobra, cada posição do botão, o formulário com envio, sucesso e erro, a página `/depoimento` e a "Resultados da página" logado como admin (um clique de teste precisa aparecer na contagem).
2. Por busca no código (`grep` em `.fabapp/workspace/src`): um só componente de ação e um só rótulo; nenhum número de prova escrito direto no código; nenhum contador ou "últimas vagas" sem dado real; nenhum snippet de analytics; e as regras que o `deploy` não confere (nenhum hex nem `font-family`, nenhum `window.confirm`/`alert`/`prompt`, nenhum `animation-timeline`, nenhum `<img>` com URL externa, nenhum `await import(`).
3. `fabapp push` e leia a saída (400 ou 422 com o caminho exato; "The platform added" pede um `pull`). Depois `fabapp deploy`. `account_builds_busy` (409): espere e repita. `build_failed` (422): conserte pelo arquivo, linha e coluna antes de tentar de novo.
4. No ar: status 200, head com o título e a descrição certos, um lead de teste que aparece no CMS do Studio e cujo aviso chega ao dono. Apague o teste.

Na mensagem final ao dono: a nota de 0 a 10 com as linhas que falham, o que foi conferido, o link, as provas a conseguir e o que ele faz no Studio (cadastrar depoimentos, FAQ e os números de "Dados do negócio"; trocar as imagens dos slots; ligar Pixel, analytics ou Clarity se quiser medir fora do app).

## Mudanças depois: diagnóstico antes de mexer

- **"Não está convertendo" ou "ninguém chama"**: você não lê registros pelo CLI; peça ao dono os números da tela "Resultados da página" do app (ele abre logado como admin) ou do CMS do Studio (eventos, leads por status). Dê a nota de 0 a 10, aponte o passo do funil que mais vaza e pergunte ao dono, com opções, qual dúvida os clientes trazem agora. Conserte a causa (objeção sem resposta, prova escondida, botão genérico, formulário longo, celular quebrado) antes de trocar cor de botão.
- **Mudança grande, não ajuste tímido.** Com pouco tráfego, mudança pequena (cor, tamanho de fonte, trocar foto) nunca mostra diferença. Mude a oferta, o título a partir da fala do cliente, a ordem das provas, a garantia.
- **"Quero testar"**: escreva a hipótese no formato "Se mudarmos X, então Y melhora porque Z (a dúvida real)" e dê a nota ICE da referência; teste só o que passa na pergunta "isso poderia dobrar o resultado?". Depois do fim do teste, a vencedora vira a página única e a perdedora sai do código; registre o aprendizado em `DECISOES.md` (Decisões), inclusive quando deu empate.
- **Depoimento ou número novo que o dono mandar**: vai para os modelos (`testimonial`, `business_profile`), cadastrado por ele, nunca escrito no código.
- Pedido para "colocar mais urgência": só com prazo ou limite real; sem isso, use o custo de esperar ("cada mês sem X custa Y" com números do dono).

## Erros comuns que você deve recusar

| Erro | Por que falha | O que fazer |
|---|---|---|
| Copiar a página do concorrente | Ninguém sabe se funciona para ele | Partir das dúvidas dos clientes deste dono |
| Testar cor de botão antes de entender objeções | Efeito pequeno, amostra desperdiçada | Pesquisa primeiro, mudanças grandes depois |
| Achar que sabe por que o visitante sai | O palpite da equipe quase sempre erra | Perguntar ao dono e aos clientes |
| Aplicar "boas práticas" como lei | Podem não servir a este público | Tratar como hipótese |
| Decidir pela opinião de quem manda | Opinião não é dado | Decidir pelo teste ou pela pesquisa |
| Mexer numa página sem ver o funil | O problema só muda de lugar | Achar o passo que mais vaza |
| Título que explica em vez de vender | "Somos uma empresa de X" não move ninguém | "Tenha X sem Y" |
| Lista de recursos sem resultado | Parece manual técnico | Responder "e daí?" em cada item |
| Depoimento genérico ("Ótimo serviço!") | Vale menos que nada | Depoimento com resultado específico |
| Vários botões disputando | O visitante trava | Uma ação principal |
| Paredão de texto | Ninguém lê no celular | Blocos curtos e escaneáveis |
| Página sem prova | Confiança é a primeira barreira | Prova logo abaixo do herói |
| Escrever para todo mundo | Não fala com ninguém | Nomear o público |
| Ignorar o celular | A maioria chega pelo celular | Conferir primeiro em 375px |
| Desistir depois de um teste sem vencedor | A oportunidade continua lá | Voltar à pesquisa, testar algo mais ousado |
