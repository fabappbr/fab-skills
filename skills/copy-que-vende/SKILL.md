---
name: copy-que-vende
description: "Escreve os textos que vendem em qualquer página do site ou app: título da página inicial, subtítulo, botões de chamada, benefícios, 'como funciona', provas, perguntas frequentes, página de serviço, sobre, preços e e-mails de boas-vindas. Parte do posicionamento (contra o que o cliente compara você e o que só você tem), monta a mensagem no roteiro StoryBrand e revisa em sete passadas, sem inventar depoimento, número ou prêmio. Use quando o dono disser: 'quero um site que venda', 'escreve o texto da minha página', 'melhora a copy', 'não sei explicar o que eu faço', 'o título está fraco', 'ninguém clica no botão', 'reescreve o sobre', 'página de preços', 'e-mail para quem se cadastrou'. Serve para salão, clínica, academia, restaurante, loja, escritório, oficina, curso e qualquer pequeno negócio. Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli)."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Copy que Vende
  edition: terminal
---

# Copy que Vende

Esta skill decide O QUE o site ou app diz e em que ordem, para o visitante entender em 5 segundos o que o negócio faz, por que escolher ele e o que fazer agora. Aqui o assunto são as palavras; direção de arte e animação ficam com outras skills (a `fab-agencia`, se estiver instalada, cuida delas).

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`https://api.fabapp.ai/llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

Cliente não compra o melhor produto; compra o que ele entende mais rápido. E ele sempre entende comparando com alguma coisa. Por isso a ordem é fixa: primeiro o posicionamento (contra o que o cliente compara), depois a mensagem (o roteiro da página), depois as frases, por último a revisão.

## Regras que valem sempre

1. **Posicionamento antes de copy.** Nenhum título é escrito antes de o plano ter nomeada a alternativa real do cliente e o que só este negócio tem contra ela. Para pequeno negócio brasileiro a alternativa quase nunca é uma marca famosa: é a agenda de papel, o "chama no zap" sem resposta, o Instagram sem link para marcar, o concorrente da rua, a indicação boca a boca, fazer em casa ou deixar para depois.
2. **O cliente é o herói; o negócio é o guia.** Título fala do que o cliente quer, não do que a empresa é. Nenhuma seção abre com "Nós somos", "A empresa X é" ou "Bem-vindo ao site".
3. **Clareza vence esperteza.** Entre uma frase clara e uma espirituosa, fica a clara. Trocadilho só se o sentido continuar óbvio na primeira leitura.
4. **Concretude local contra hipérbole americana.** O consumidor de bairro desconfia de "o melhor", "revolucionário", "transforme sua vida", "experiência única", "excelência". Ele confia em endereço, bairro, horário, preço, nome e registro do profissional, foto real, prazo, forma de pagamento e "atendemos pelo WhatsApp". Cada adjetivo de propaganda é trocado pelo fato que ele fingia provar, ou cortado.
5. **Tratamento "você".** Sempre. "O senhor/a senhora" só se o dono escolher na conversa (nicho como clínica geriátrica ou escritório tradicional). Nunca "tu" genérico. O mesmo tratamento no site, no app, nos e-mails e nas mensagens de WhatsApp.
6. **Traduzir a função, não a frase.** Fórmula em inglês vira a construção que um brasileiro usaria: "Never {pain} again" vira "Chega de {dor}" ou "Sem {dor}", nunca "Nunca mais {dor} novamente". Nada de "Imagine..." de comercial de TV; troque por uma cena concreta: "Chegou às 19h e a academia estava lotada?".
7. **Nada inventado:** depoimento, número, prêmio, registro, preço, prazo e garantia só entram se vieram do dono; onde falta, a lacuna é nomeada (seção "A construção", regra das lacunas). Um número específico inventado é pior que uma frase genérica.
8. **Uma ação principal por página.** Um CTA direto (a conversão: agendar, pedir orçamento, chamar no WhatsApp, comprar), repetido no topo, depois do "como funciona" e no fim. No máximo um CTA de transição (compromisso menor: ver cardápio, ver preços, receber a tabela). O texto do botão promete exatamente o que acontece no clique: nada de "grátis" em ação paga.
9. **Sem tiques de texto de IA:** zero travessão ou meia-risca como pontuação, zero "não é apenas X, é Y", zero jargão de IA como "jornada" e "potencializar", zero gerundismo, zero trio automático de adjetivos, zero exclamação ou emoji decorativo, títulos e botões em caixa de frase. Se a skill `texto-sem-cara-de-ia` estiver instalada, a lista dura dela manda nisso.

## A conversa: o que perguntar ao dono

Pergunte só o que só o dono sabe e que muda o texto. O resto você decide e registra como suposição no plano. Até 6 perguntas desta skill, numa rodada; pule as que o pedido já respondeu. Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Em pergunta de gosto, a opção recomendada vem primeiro com "(Recomendado)". Em pergunta de fato do negócio não existe opção certa: a mais comum vem primeiro, sem rótulo, e sempre com a saída de responder com as próprias palavras.

Antes de perguntar, aproveite o que o dono já disse, o site ou Instagram que ele mandou (leia com a ferramenta de leitura de página da sua ferramenta) e uma busca na web do nome do negócio para descobrir bairro, horário e serviços. Não pergunte o que já está respondido.

**Perguntas principais (posicionamento e ação):**

1. "Se o seu negócio fechasse amanhã, o que seus clientes fariam?" (várias respostas, com resposta livre): "Iriam a outro lugar parecido aqui perto" / "Resolveriam por WhatsApp ou Instagram de alguém" / "Fariam sozinhos em casa" / "Deixariam para depois".
2. "O que você tem que esse outro caminho não tem?" (várias respostas, com resposta livre): "Atendimento feito por mim ou por um profissional com nome e registro" / "Horário, local ou entrega que os outros não oferecem" / "Uma especialidade ou técnica que poucos fazem" / "Preço ou forma de pagamento que facilita".
3. "Quem é o cliente que mais valoriza isso?" (uma resposta, com resposta livre): quatro perfis concretos escritos para o nicho, pela situação e não pelo gosto. Ex. para academia: "Quem trabalha o dia todo e só pode treinar cedo ou à noite" / "Quem vai começar do zero e tem vergonha de academia cheia" / "Quem treina para uma prova ou esporte" / "Quem precisa de acompanhamento por dor ou lesão".
4. "Qual é a ação principal que o visitante deve fazer?" (uma resposta): para serviço local, "Chamar no WhatsApp (Recomendado)" / "Agendar um horário direto no site" / "Pedir um orçamento" / "Comprar online". Para loja, "Comprar online" vira a recomendada.
5. "Que provas reais você tem para mostrar?" (várias respostas, com resposta livre): "Anos de experiência (vou dizer quantos)" / "Registro profissional, como CRM, CRO, OAB ou CRECI" / "Depoimentos ou avaliações de clientes que posso usar" / "Fotos reais do espaço e do trabalho" / "Ainda não tenho".
6. "Como o site deve falar com o cliente?" (uma resposta): "Próximo e simples, como no balcão (Recomendado)" / "Profissional e sóbrio" / "Animado e jovem". Para nicho tradicional acrescente "Formal, tratando por senhor e senhora".

**Perguntas extras (só se a resposta anterior deixar dúvida que muda o app):** números e compromissos que viram frase: "Quantos anos de experiência?" (aberta); "Qual o preço de entrada que posso mostrar?" com "Mostrar 'a partir de R$ ...'" / "Não mostrar preço no site"; "O que você garante ao cliente?" (várias respostas, com resposta livre): "Primeira avaliação sem custo" / "Troca ou devolução em alguns dias" / "Remarcação sem custo" / "Não ofereço garantia"; "Em quanto tempo você responde quem chama?" (aberta). Pergunte o registro profissional (número) quando o nicho for saúde, direito ou imóveis e o dono marcou que tem.

**O que sai da conversa:** anote em `DECISOES.md`, em frases curtas, o posicionamento mínimo (alternativa real, o que só ele tem, cliente ideal, categoria), a ação principal, as provas que existem e o tom. Cada coisa decidida sem perguntar vira suposição no plano. As lacunas viram aviso ao dono: "Depoimentos e número de anos ficam como espaço para você preencher depois; o site não inventa". Esta skill não decide cor nem fonte; a marca é decidida com o dono e gravada em `apps/<slug>/fab.config.json → theme` (chaves em `references/fabapp-cli.md`).

## O plano: posicionamento, roteiro e lista de conferência

O plano é um texto que você escreve e mostra ao dono antes de codar. Ele aprova antes da construção.

### 1. Canvas mínimo de posicionamento (vai no texto do plano)

Preencha estas linhas, uma frase cada, usando só o que veio da conversa. Aplique os testes de `references/posicionamento.md`.

| Campo | Pergunta |
|---|---|
| Alternativa real | O que o cliente usaria se este negócio não existisse? (inclua "não fazer nada") |
| Atributos únicos | O que só este negócio tem contra essa alternativa? Passa no teste "Só nós..." e é verdade conferível |
| Temas de valor (2 ou 3) | "E daí?" até chegar ao que o cliente sente no bolso, no tempo ou no medo |
| Cliente ideal | Situação reconhecível antes do contato (bairro, rotina, momento), nunca "todo mundo" |
| Categoria | Categoria que o cliente já entende, quase sempre com um modificador: "pilates para gestantes", "barbearia infantil" |
| Tendência (opcional) | Só se for real e ligada a um atributo |
| Declaração | "Para {cliente ideal}, {negócio} é {categoria} que {valor principal}, diferente de {alternativa}, que {limitação}." |
| Provas | O que existe de verdade para cada tema; o que falta vira lacuna |

Dê a nota de posicionamento de 0 a 10 (faixas em `references/posicionamento.md`) e escreva o que falta para 10.

### 2. Roteiro StoryBrand (SB7)

Escreva as sete peças em uma linha cada, com a nota: 1 ponto por item presente (personagem com UM desejo; problema externo, interno e filosófico com vilão concreto; guia com empatia E autoridade; plano de 3 passos mais acordo que tira o medo; CTA direto e de transição; fracasso evitado; sucesso), mais até 3 pontos pela frase-resumo que alguém repete depois de ouvir uma vez. Plano com nota abaixo de 8 volta a ser escrito antes da construção; o que não tem prova vira lacuna, não peça inventada. Detalhes e exemplos por nicho em `references/storybrand-e-paginas.md`.

Frase-resumo (one-liner): "Ajudamos {cliente} que {problema} a {solução} para {resultado}", reescrita no português do dono. Ela vira descrição do SEO, rodapé e mensagem pronta do botão de WhatsApp.

### 3. Estrutura da página inicial

Ordem fixa das seções da home de um site de negócio (a composição visual é livre):

1. Topo: título (desejo ou dor), subtítulo (como), CTA direto.
2. O que está em jogo: uma ou duas frases do custo de continuar como está. Leve, sem susto.
3. Benefícios: 3 no máximo, cada um resultado + fato.
4. Guia: empatia ("a gente sabe como é...") e autoridade real (anos, registro, fotos reais, avaliações).
5. Como funciona: 3 passos numerados, verbo + resultado, e o CTA direto de novo.
6. Provas: depoimentos reais, lidos do modelo `testimonial` (esquema na regra das lacunas).
7. Perguntas frequentes: as objeções do nicho respondidas com fato.
8. CTA de transição (opcional) e CTA final com o que tira o risco.
9. Rodapé: frase-resumo, endereço, horário, contato, CTA.

Home de app de produto (sistema que a pessoa usa logada) abre na tarefa, sem herói com slogan: a skill só age nas telas públicas de venda.

### 4. Títulos

Gere 3 candidatos para o título principal com as fórmulas de `references/titulos-cta-revisao.md`, passe cada um no teste "Agora você pode..." e no teste dos 5 segundos, e registre no plano o escolhido e o porquê em uma linha.

### 5. Lista de conferência (entra inteira no plano)

- Visual: "O título da página inicial fala do desejo ou da dor do cliente, e com 'Agora você pode...' na frente fica verdadeiro e concreto."
- Visual: "A página inicial tem, nesta ordem, topo com CTA, custo de não agir, até 3 benefícios, guia, 'como funciona' em 3 passos, provas, perguntas frequentes e CTA final."
- Código: "O CTA direto aparece pelo menos 3 vezes na home com o mesmo verbo e o mesmo destino."
- Código: "Nenhum depoimento, número de clientes, nota, prêmio ou registro profissional está escrito no código; provas vêm de registros do app ou de fatos que o dono informou na conversa."
- Código: "Seção de prova sem registro não aparece para o visitante; o dono logado vê um cartão dizendo o que falta preencher."
- Código: "Nenhum texto visível contém travessão ou meia-risca, 'não é apenas', 'mergulhe', 'jornada', 'potencialize', 'eleve', 'desbloqueie' ou 'com sucesso'."
- Visual: "Todo preço aparece como R$ 1.234,56, com 'a partir de' quando for piso."
- Definição: "A descrição de SEO da home (`fab.config.json → seo.description`) é a frase-resumo do plano."

Nas suposições do plano, registre o que foi decidido sem o dono (tom, categoria, ordem dos benefícios) com impacto e alternativa.

## A construção: escrever a página

Siga o roteiro do plano ao pé da letra. Cada seção abaixo tem a regra da frase; `references/storybrand-e-paginas.md` tem os moldes de página e `references/titulos-cta-revisao.md` as fórmulas.

**Topo.** O título tem até 10 palavras, fala do desejo ou da dor na língua do cliente e segue o modelo de ação humana: desconforto atual, visão melhor, caminho. O subtítulo (1 ou 2 frases) diz como e acrescenta um fato concreto (bairro, prazo, preço de entrada, nome do profissional). O CTA direto fica logo abaixo.

**CTA.** Na copy de página pública de venda, imperativo com "seu/sua" ou primeira pessoa: "Agende seu horário", "Peça seu orçamento pelo WhatsApp", "Quero meu orçamento". Fórmula: verbo + o que a pessoa recebe + qualificador verdadeiro ("sem compromisso" só se for). Proibidos como texto de botão: "Enviar", "Saiba mais", "Clique aqui", "Comece agora", "Cadastre-se", "Fale conosco", "Confira". Botões de ação dentro do app (salvar, excluir, agendar no fluxo logado e formulários) usam o infinitivo ("Agendar horário"; a skill `textos-de-interface`, se instalada, detalha). Botão de WhatsApp usa o link `https://wa.me/55DDDNUMERO?text=...` com a mensagem pronta escrita pelo cliente em primeira pessoa ("Oi, vi o site e quero agendar uma avaliação").

**Custo de não agir.** Uma ou duas frases, custo de oportunidade concreto ("mais um sábado perdido esperando o encanador que não aparece"). Nunca ameaça, nunca doença, nunca multa inventada.

**Benefícios.** Até 3. Cada um: título curto com o resultado, 1 ou 2 frases com o fato que o sustenta. Benefício sem fato vira lacuna ou sai.

**Guia.** Empatia primeiro, autoridade depois. A história de origem do dono cabe em duas frases e só se servir ao cliente; mais que isso é o negócio virando herói.

**Como funciona.** Exatamente 3 passos (4 no máximo), cada um com verbo + o que a pessoa ganha: "Escolha o horário. Confirme pelo celular. Apareça." Logo abaixo, o CTA direto e o acordo que tira o medo (o que o dono garante, dito na conversa).

**Perguntas frequentes.** De 5 a 8, cada uma uma objeção real do nicho (preço, tempo, dor, "e se eu não gostar", estacionamento, formas de pagamento). A resposta começa pelo fato. Pergunta cuja resposta você não sabe não entra; vai para a mensagem final como pergunta ao dono.

**Páginas internas.** Serviço: resultado no título, "para quem é", "o que está incluso", 3 passos, provas desse serviço, preço ou "a partir de", perguntas, CTA. Sobre: começa pelo que o negócio faz pelo cliente, depois a crença ("a gente acha que ninguém devia..."), equipe como guias, credenciais reais, CTA. Preços: ajuda a escolher, recomendado marcado, o que tira o risco perto do botão.

**Regra das lacunas (nada inventado, em código).**
- Fato que o dono deu na conversa: vai escrito no texto.
- Prova que vem em quantidade (depoimentos, fotos de trabalhos, avaliações): mora num modelo de dados em `fab.schema.json` com `access: {"read":"public","create":"role:admin","update":"role:admin","delete":"role:admin"}`. Depoimentos moram em `testimonial` com os campos `author_display`, `author_detail`, `photo`, `body`, `result`, `authorized` (o esquema da skill `reputacao-e-avaliacoes`, que manda nele se estiver instalada); `review` é a avaliação por item de cliente logado (peça `<Rating/>`), não depoimento. A seção lê com `collection('testimonial').list({ filter: { authorized: true, active: true }, limit: 6 })`; com zero registros, some para o visitante; para quem tem papel admin ou owner (`const { user } = useAuth(); user?.roles?.some(r => r === 'admin' || r === 'owner')`) aparece um cartão "Falta: depoimentos reais de clientes. Adicione aqui" com link para a tela de cadastro. Você nunca grava esses registros (o CLI não escreve registros): o dono cadastra no CMS do Studio ou pela tela de cadastro do app; para testar, crie um registro pela pré-visualização e apague depois.
- Fato único que falta (anos de casa, registro profissional, prazo de resposta): a frase que depende dele é reescrita para ficar verdadeira sem ele, ou a informação vai para um campo do registro único `business_profile` ("Dados do negócio", o mesmo da skill `sites-por-segmento`) preenchido pelo dono, com o mesmo cartão "Falta: ..." para o admin.
- Imagem de `<AppImage>` é ambiente, nunca "nossa equipe", "nosso espaço" ou "antes e depois". Foto que prova algo vem de upload do dono.
- Saúde, estética, direito e finanças: nenhuma promessa de resultado ("cura", "garantido", "sem dor", "aprovado em minutos"), nenhum antes e depois gerado. Texto de consentimento, termos e avisos legais não é copy de venda: não se reescreve para vender.

**SEO.** O título e a descrição de cada página pública vêm do plano. A home vai em `apps/<slug>/fab.config.json → seo.title` e `seo.description`; cada rota estática que importa ganha a própria entrada em `seo.pages`; rota dinâmica usa `<FabHead title description/>` (ou `useSeo`) na página. Nunca escreva `<title>` à mão. Envie com `fabapp push` (limites de tamanho em `references/fabapp-cli.md`). A descrição é a frase-resumo com bairro e cidade quando o negócio é local.

**E-mails e mensagens do app.** Boas-vindas e sequência para quem tem conta: automação só dispara sobre registro de um modelo, então declare em `fab.schema.json` o modelo `welcome_sequence` (campos `started_at` `datetime` e `user` `ref app_user`; acesso padrão) e, logo depois do `signup`, o próprio app da pessoa recém-cadastrada cria um registro com `started_at` = agora. Em `fab.automations.json` (sempre `fabapp pull` antes de editar, porque o `push` substitui o conjunto inteiro), cinco automações `{ "type": "relative", "model": "welcome_sequence", "field": "started_at", "offset_days": N }` com N = 0, 2, 4, 6 e 8, cada uma com `{ "type": "notify", "channel": "email", "to": "owner", "title": "<assunto>", "body": "<texto>", "link": "/<pagina>" }`. Atenção ao `to`: `"owner"` é quem CRIOU o registro (não o dono do app). Ele só está certo porque o registro é criado pela própria pessoa logo depois do signup; se o registro for criado por um admin (importação, cadastro pela equipe), `to` tem de ser o campo ref ao usuário (`"to": "user"`), senão o e-mail vai para o admin. A entrega é na hora da plataforma, não no minuto. Conteúdo: 1 entrega e o que esperar; 2 problema e empatia; 3 prova real; 4 os 3 passos; 5 o convite direto. O e-mail é texto puro, sem URL no corpo, com `link` para página do próprio app e limite diário (429); assunto com 40 a 50 caracteres. Visitante sem conta não recebe sequência automática: o lead cai num modelo com `create: public`, o dono é avisado por automação `data` com `to: "admin"` e a tela do lead tem as mensagens de WhatsApp prontas no mesmo roteiro. Moldes em `references/storybrand-e-paginas.md`.

**Revisão em sete passadas (antes de dizer pronto).** Releia todo texto de venda que escreveu, uma passada por vez, e depois de cada passada confira se não quebrou as anteriores:

1. **Clareza:** cada frase se entende na primeira leitura; uma ideia por seção; o texto fala com "você".
2. **Voz:** o tom escolhido do começo ao fim, sem virar corporativo no meio.
3. **E daí?:** toda característica ganha a consequência para o cliente ("o que significa que...").
4. **Prove:** toda afirmação tem prova por perto ou sai; "o melhor", "referência", "milhares de clientes" sem fonte são cortados.
5. **Especificidade:** vago vira número, prazo ou exemplo que o dono deu; o que não dá para especificar é enchimento e sai.
6. **Emoção:** o antes aparece como cena real do cliente; a emoção serve à mensagem, sem manipulação.
7. **Risco zero:** perto de cada CTA, a objeção principal está respondida (preço, garantia real, "responde em quanto tempo", "sem cartão" se for verdade) e o próximo passo está claro.

## Conferir antes de dizer pronto

1. Varra os tiques da regra 9 em todo `src/` por busca no código: os caracteres U+2014 e U+2013 (travessão e meia-risca) e as expressões "não é apenas", "mergulhe", "jornada", "potencialize", "eleve", "desbloqueie" e "com sucesso" (por exemplo `grep -rniE "não é apenas|mergulhe|jornada|potencialize|eleve|desbloqueie|com sucesso" src/`). Reescreva e busque de novo até zerar.
2. Confira por busca que nenhum depoimento, nota, número de clientes, prêmio ou registro profissional está escrito em `src/` (procure por aspas longas em seções de prova, "estrelas", "clientes satisfeitos", "CRM", "OAB").
3. Com `fabapp dev` rodando, abra a home e percorra cada item da lista de conferência do plano (ordem das seções, 3 CTAs com o mesmo verbo e destino, preços no formato R$). Veja a seção de provas vazia como visitante (some) e logado como admin (cartão "Falta: ...").
4. `fabapp push` (schema, automações, SEO) e `fabapp deploy`; trate `build_failed` (422) consertando, e `account_builds_busy` (409) esperando e repetindo. Confira no ar o título e a descrição no head.
5. A mensagem final ao dono lista, em português simples, só o que foi conferido, o link, o título escolhido e o que ele faz no Studio: preencher as lacunas (depoimentos, anos, registro) no CMS, subir fotos reais, ajustar o SEO na tela de Marketing se quiser. Nunca diga que conferiu o que não conferiu.

## Mudanças depois: melhorar texto que já existe

- **"Melhora o texto", "está fraco", "não converte":** rode as sete passadas sobre o texto atual, com o posicionamento do plano (leia `DECISOES.md`; se não houver, reconstrua o canvas mínimo pelo que o site já diz). Não mude o posicionamento sem perguntar: se ele parecer errado, diga ao dono em uma frase e ofereça as duas versões.
- **Preserve todo fato** (número, nome, preço, prazo, endereço) exatamente. Edição que melhora o tom e muda um fato é pior que o texto original.
- **Texto que o próprio dono escreveu:** mantenha a voz dele; corrija clareza, tiques e ordem, e diga na mensagem final o que mudou. Nunca esconda mudança.
- **Título novo:** 3 candidatos pelas fórmulas, teste "Agora você pode..." e troca só do escolhido.
- **Conteúdo desatualizado:** atualize preços, horários, serviços e provas com o que o dono informar; o que ele não informou fica como está e vira pergunta.
- Anote o posicionamento, a frase-resumo e o tom em `DECISOES.md` (em **Decisões** e **Preferências**) na primeira vez que eles existirem, para as próximas edições partirem deles.
