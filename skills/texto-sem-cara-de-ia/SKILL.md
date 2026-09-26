---
name: texto-sem-cara-de-ia
description: "Tira a cara de texto de IA do texto longo do site e do app: títulos e textos das páginas, e-mails, notificações, mensagens de WhatsApp, o que a IA do próprio app escreve para o cliente e a revisão de texto que já existe (botão, erro e toast são de textos-de-interface). Aplica uma lista dura em português (zero travessão, zero 'não é apenas X, é Y', zero 'mergulhar', 'jornada', 'potencializar', gerundismo, exclamação em aviso, 'com sucesso', 'Olá!' e 'Ops!'), os 25 padrões de escrita de IA reescritos para o PT-BR, perfis de voz e uma nota de 0 a 50, sem mudar fato e sem 'humanizar' texto jurídico, de saúde ou de LGPD. Use quando o dono disser: 'o texto parece de robô', 'parece ChatGPT', 'tira a cara de IA', 'humaniza o texto', 'está artificial', 'parece traduzido', 'tem muito travessão', 'soa como propaganda', 'deixa mais natural'. Vale também em app com muito texto ou que usa IA para escrever ao cliente. Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli)."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Texto sem Cara de IA
  edition: terminal
---

# Texto sem Cara de IA

Esta skill é um filtro de saída sobre todo texto visível do app ou site: páginas, botões, avisos, e-mails, notificações, modelos de mensagem, descrições de SEO e o que a IA do próprio app escreve para o cliente. O objetivo é texto claro, específico e com cara de gente do negócio. Não é enganar detector: nenhuma reescrita garante que uma ferramenta classifique o texto como humano, e isso não importa. Importa o cliente do dono não desconfiar.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`https://api.fabapp.ai/llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Por que texto de IA soa assim

Um modelo escreve o que é mais provável vir em seguida, então escolhe o que serve para o maior número de leitores e assuntos. Uma pessoa escolhe para um leitor e um assunto, e por isso suas escolhas são irregulares e específicas. Todo padrão abaixo é uma forma da escolha padrão:
- **Encenar em vez de dizer:** a frase anuncia importância em vez de dar um fato (contraste que só pesa, frase de efeito no fim).
- **Ritmo por regra:** trios e travessões em todo lugar, frases do mesmo tamanho.
- **Inflação:** fato comum vestido de marco histórico ou de opinião de especialista.
- **Formatação por regra:** negrito e maiúsculas em todo item, emoji como enfeite.
- **Sobras:** frases de chat e de rascunho que nunca eram para o leitor.

Duas consequências: toda frase que fica tem de dar ao leitor algo que ele não tinha; e um tique pesa tanto quanto é raro um escritor cuidadoso fazê-lo de propósito.

## Hierarquia de evidência

| Grupo | O que é | O que fazer |
|---|---|---|
| Forte | Medido em estudo grande ou conferível mecanicamente, ou uma das formas de "encenar" | Corrigir na primeira ocorrência |
| Médio | Recorrente, mas depende do contexto | Corrigir quando houver acúmulo no mesmo trecho |
| Fraco | Já foi bom indício, hoje dá falso positivo | Nunca prova sozinho; só conta junto de fortes |

Fortes: contraste "não X, mas Y"; frase de efeito no fim; ditado com cara de profundo; preâmbulo antes do ponto; discutir com ninguém; sobras de chatbot; aviso de limite de conhecimento; pontuação escassa (orações longas coladas com "e", sem vírgula, parêntese ou ponto e vírgula); frases todas do mesmo tamanho; palavra difícil onde cabia a simples; tom 100% positivo sem nenhuma ressalva; aspas curvas misturadas com retas; markdown vazando (asteriscos visíveis).
Médios: trio forçado; paralelismo negativo em PT; fuga do "é" e do "tem"; gerúndio de análise no fim; atribuição vaga; editorialização ("vale ressaltar"); conclusão genérica; importância inflada; falsa faixa ("do X ao Y"); variação forçada de sinônimos; enchimento; Title Case; negrito em excesso; lista com rótulo em negrito repetido; emoji como marcador; mudança brusca de estilo.
Fracos: travessão sozinho; uma palavra isolada da lista de vocabulário; aspas curvas sozinhas; conectivo isolado.

**Decisão de produto da Fabapp:** a hierarquia serve para diagnosticar. A lista dura abaixo vale sempre, em qualquer quantidade, porque o público de pequeno negócio associa esses sinais a texto de robô, independentemente do que dizem os estudos. O travessão é fraco como detector e mesmo assim está banido.

## Lista dura (zero tolerância em texto visível)

| Proibido | Troque por |
|---|---|
| Travessão (o traço longo) e meia-risca como pontuação, e também hífen com espaços ou dois hífens fazendo papel de travessão | Tabela do travessão abaixo |
| "Não é apenas X, é Y", "não se trata de X, trata-se de Y", "mais do que X, é Y", "vai muito além de", "não é sobre X, é sobre Y", "X, não Y" como bordão | A afirmação positiva direta |
| mergulhar (figurado), jornada (figurado), potencializar, alavancar, elevar, desbloquear, transformar sua experiência, no cenário atual, em um mundo cada vez mais, ecossistema (abstrato), sinergia, robusto, disruptivo, tapeçaria, testemunho de, navegar complexidades | O verbo comum ("usar", "melhorar", "aumentar", "lidar com") ou o fato |
| Gerundismo: "vou estar enviando", "estaremos realizando", "vai estar recebendo" | "vou enviar", "vamos fazer", "vai receber" |
| Gerúndio conclusivo: "..., garantindo sua satisfação", "..., reforçando nosso compromisso", "..., consolidando a posição" | Corte, ou frase nova com sujeito ("Isso garante...") se a ideia for fato |
| Trio automático de adjetivos: "rápido, simples e seguro" | Um ou dois atributos, o que importa aqui, com prova |
| Exclamação em toast, aviso e mensagem de sucesso | Ponto final |
| "com sucesso" ("salvo com sucesso") | "Salvo." |
| "Olá!" e "Ops!" (e "Opa!", "Eita!") abrindo erro ou aviso | Comece pelo fato |
| Emoji decorativo (🚀💡✨🎯🎉) | Nada; ícone de status só com função |
| Title Case ("Nossos Serviços De Limpeza") | Só a primeira palavra e nomes próprios maiúsculos. Caixa alta aplicada por CSS (`uppercase`) por uma skill de estilo não é Title Case e é permitida; a string no código continua em caixa de frase |

## Tabela do travessão

| O que o traço longo fazia | Use |
|---|---|
| Aparte ou interrupção | Vírgulas ou parênteses |
| Anunciar uma explicação ou lista | Dois-pontos |
| Virada, ênfase, mudança brusca | Ponto final e frase nova |
| Ligar duas orações que andam juntas | Ponto e vírgula, ou duas frases |
| Intervalo (9h a 18h, 2019 a 2024) | "a" ou "até" |

Não troque todos por vírgula: se a frase acumular mais de duas ou três vírgulas, reestruture (tire um conectivo, divida, use dois-pontos ou parênteses). Hífen de palavra composta (bem-vindo, pré-venda) é normal. Travessão de fala em diálogo de ficção é norma da língua e fica.

## Os 25 padrões (resumo; detalhe e exemplos em `references/catalogo-25-padroes.md`)

A. Encenar em vez de dizer (fortes, uma ocorrência basta): 1 não X mas Y; 2 frase de efeito no fim e fragmentos dramáticos; 3 ditado com cara de profundo ("no fundo", "a verdadeira questão", "X é a linguagem de Y"); 4 preâmbulo antes do ponto ("Vamos lá", "Eis a questão", "Sinceramente?"); 5 discutir com ninguém ("Não estou dizendo que...", "Uma opção tentadora seria...").
B. Ritmo por regra (precisam de companhia): 6 trio forçado; 7 frases que começam igual; 8 travessão como conector universal (na Fabapp, sempre corrigido); 9 ressalvas empilhadas; 10 hífen em tudo; 11 passiva e sujeito sumido.
C. Inflação: 12 vocabulário de IA; 13 importância inflada ("marco", "papel fundamental", "o futuro é promissor"); 14 ligação vaga ("associado a", "ligado a"); 15 gerúndio raso no fim; 16 linguagem de propaganda ("localizado no coração de", "experiência única", "de tirar o fôlego"); 17 autoridade emprestada ("especialistas dizem", lista de veículos); 18 fuga do "é" e do "tem" ("configura-se como", "dispõe de").
D. Formatação por regra: 19 negrito de enfeite e lista com rótulo em negrito; 20 títulos decorados (Title Case, emoji, seta, linha entre toda seção); 21 aspas curvas no meio de retas.
E. Sobras: 22 resíduo de chatbot ("Espero ter ajudado", "Ótima pergunta", "Fique à vontade"); 23 aviso de limite e palpite ("até onde sei", "provavelmente cresceu em..."); 24 título repetido na primeira frase; 25 falar da versão anterior em vez do que é hoje.

Os padrões exclusivos do português (gerundismo, gerúndio conclusivo, latinismo fora do lugar, abertura estilo redação do ENEM, ressalva burocrática, oficialês, formalidade deslocada, evitar "é/tem", expressões infladas, transições mecânicas, purismo que traduz "feedback" e "delivery", ênclise e mesóclise artificiais, passiva analítica, decalque do inglês, "O resultado? Um X.") estão em `references/padroes-pt-br.md`.

## Trava factual (vale acima de tudo)

Trate o texto de origem como imutável em conteúdo: nomes, números, datas, preços, prazos, citações, fontes, relações de causa, grau de certeza ("pode" não vira "vai"), tempo verbal, argumento e intenção. Pode condensar, reordenar e reformular; não pode acrescentar, tirar ou trocar esses elementos. Nunca invente vivência, depoimento, estatística, fonte, exemplo ou prazo para dar concretude. Faltou o dado que deixaria a frase concreta: escreva a frase mais simples que continua verdadeira e registre a lacuna para o dono (no texto do app, a lacuna segue a regra do marcador em "A construção"). Fonte específica que parece inventada (autor, ano, página) não se conserta: sinalize ao dono. Brevidade comprime a forma, nunca o aviso: se cortar um trecho faz o leitor agir errado, o trecho fica.

## Texto protegido (nunca "humanizar" em silêncio)

Termos de uso, política de privacidade, consentimento LGPD, contratos, cláusulas, bula, orientação de saúde e de segurança, aviso legal, condições de preço e juros, citação literal, nome de produto e termo oficial do ramo. Nesses trechos: não mude o sentido; corrija só pontuação e maiúsculas se o dono pedir; ofereça a versão simples ao lado, como sugestão para ele aprovar com quem cuida disso, e diga isso na mensagem final ao dono. Texto de ramo formal (petição, laudo) mantém a estrutura do gênero; o que se corta é só a repetição mecânica.

## Guarda de falso positivo

Não é sinal de IA: gramática correta e estilo constante; texto seco sem as marcas específicas; palavra formal isolada; impessoalidade exigida pelo gênero; conectivo isolado; uma frase curta de ênfase; repetição proposital ("Cheguei. Vi. Venci."); "olha", "sinceramente" dentro da frase; ressalva com função (escopo, aviso, correção real, pergunta frequente); alternativa real que o leitor pesaria; falta de citação; formatação correta de template; expressão citada ou discutida em vez de usada; texto de antes de 30/11/2022. Preserve as marcas humanas: contração ("pra", "tá") em registro informal, regionalismo ("uai", "oxe", "bah", "massa"), detalhe específico e estranho, sentimento misto, gíria datada, aparte e autocorreção, primeira pessoa que o autor sabe justificar. Estrangeirismo do ramo fica (delivery, feedback, check-in, pet shop, combo, voucher): traduzir à força é outro tique.

## Pontuação de 0 a 50

Dê nota de 1 a 10 em cada dimensão, sempre em relação ao perfil de voz do texto:

| Dimensão | Pergunta |
|---|---|
| Direto | Afirma, ou anuncia que vai afirmar? |
| Ritmo | Tamanhos variados, ou metrônomo? |
| Confiança | Respeita a inteligência do leitor, sem amaciar nem explicar demais? |
| Autenticidade | Soa como gente do negócio? |
| Densidade | Sobrou algo para cortar? |

Abaixo de 35: reescreva a dimensão mais baixa e dê a nota de novo (no máximo 2 rodadas; com menos de 25, mude a abordagem, não só as palavras). Se a trava factual falhar, a versão é descartada, qualquer que seja a nota. Regras que acompanham a nota: corte enchimento e advérbio de muleta; quebre estruturas de fórmula; sujeito de verdade fazendo a ação (nada de "a solução entrega", "o sistema cuida de você"); específico no lugar do vago e de "sempre", "nunca", "todos"; o leitor dentro da cena ("você", não "as pessoas"); dois itens valem mais que três; parágrafos que terminam de jeitos diferentes; corte a frase que parece citação de pôster.

## O plano: perfil de voz e lista de conferência

O plano é um texto que você escreve e mostra ao dono antes de codar. Ele aprova antes da construção. Escolha, por tipo de texto, o perfil de voz (detalhes em `references/perfis-e-simplificado.md`) e registre no texto do plano:

| Texto do app | Perfil |
|---|---|
| Página de venda, sobre, serviço | Voz do negócio que o dono contou ou que está em `DECISOES.md` (neutra se nada foi dito), com a lista dura |
| Ajuda, onboarding, erro, instrução, e-mail de sistema | Português simplificado (13 a 18 palavras por frase, ordem direta, uma ideia por frase) |
| Mensagem pronta de WhatsApp, lembrete, confirmação | WhatsApp de negócio (oral, curto, sem "Olá!", sem emoji de enfeite) |
| Painel do dono, resumo do dia, relatório | Enxuto ou Resumo (resposta na primeira linha, números exatos, status como texto com ícone do `lucide-react`, nunca emoji) |
| Blog, artigo, post dentro do app | Perfil do gênero (crônica, jornalístico, didático) só se o dono pedir; senão neutro |
| Termos, privacidade, consentimento, saúde | Protegido: não reescrever o sentido |

Lista de conferência (entra inteira no plano):
- Código: "Nenhum texto visível em `src/` contém travessão ou meia-risca usados como pontuação."
- Código: "Nenhum texto visível contém 'não é apenas', 'não se trata de', 'mergulh', 'jornada', 'potencializ', 'alavanc', 'desbloque', 'com sucesso', 'Ops', 'vou estar' ou 'estaremos'."
- Código: "Nenhum toast ou mensagem de sucesso termina em exclamação; nenhum título, botão ou aba usa Title Case; nenhum emoji decorativo."
- Código: "Todo prompt de sistema de `invokeLLM` que gera texto para o cliente final inclui a lista dura desta skill em português."
- Visual: "Os textos longos alternam frases curtas e longas e não abrem parágrafos seguidos com 'Além disso', 'Dessa forma' ou 'Nesse sentido'."

## A construção: escrever direto, depois filtrar

1. **Escreva direto**, com o material do plano e do dono, no perfil escolhido. Não fique desviando de padrões enquanto escreve: isso trava a frase. Formas fixas que valem em qualquer app (as mesmas das skills `textos-de-interface` e `copy-que-vende`, se estiverem instaladas): botão dentro do app logado = verbo no infinitivo + objeto ("Salvar alterações"); botão de chamada em página pública de venda = imperativo com "seu/sua" ("Agende seu horário"); toast = resultado no passado, ponto final, sem "com sucesso"; erro = o que houve e como resolver, sem "Ops"; só a primeira letra maiúscula em título, botão e aba.
2. **Passe o filtro no próprio rascunho** antes de salvar o arquivo. Primeiro os cinco escorregões mais frequentes em texto novo: travessão de aparte; "não apenas X, mas também Y"; conectivo abrindo parágrafo ("Além disso", "Dessa forma", "Por fim"); trio forçado; fecho otimista genérico. Depois a lista dura inteira, depois os 25 padrões e os padrões do português.
3. **Marcador em vez de fato inventado.** O que falta não vira número plausível. No texto do app, a frase fica verdadeira sem o dado; se o dado for essencial, ele vem de um campo que o dono preenche e o administrador vê um cartão "Falta: {o quê}"; a pergunta vai para a mensagem final ao dono. O marcador `[DADO OU EXEMPLO REAL NECESSÁRIO]` nunca aparece para o visitante.
4. **IA dentro do app.** Toda chamada `invokeLLM({ prompt, system, schema?, tier: 'fast' | 'smart' })` (de `@/lib/fab-client`, devolve `{ text, data }`, exige login, 402 quando acaba o crédito) que escreve para o cliente final (resposta de atendimento, descrição de produto, resumo) leva no `system` a lista dura em português, o tratamento "você", o perfil de voz e "não invente dado que não esteja no contexto". Nos agentes de `fab.agents.json`, o mesmo texto vai no campo `instructions`. Se a chamada falhar (402 ou rede), a tela mostra o texto fixo escrito pelo código, sem mensagem de erro para o cliente final.

## Conferir antes de dizer pronto

1. **Varredura final** por busca no código (`grep`) em `src/`, `fab.automations.json`, `fab.agents.json` e textos de e-mail: procure o traço longo e a meia-risca (caracteres U+2014 e U+2013), " -- ", "com sucesso", "Ops", "Olá!", "não é apenas", "vou estar", as palavras da lista dura e `!` em toasts. Confira também que todo `system` de `invokeLLM` e todo `instructions` de agente que escreve ao cliente leva a lista dura. Corrija e busque de novo até zerar.
2. **Compile e veja:** com `fabapp dev` rodando, abra as telas com texto longo e percorra os itens visuais da lista de conferência. Depois `fabapp push` (automações) e `fabapp deploy`; trate `build_failed` (422) consertando e `account_builds_busy` (409) esperando e repetindo.
3. **Nota de 0 a 50** nos textos longos (home, sobre, página de serviço, e-mails). Na mensagem final ao dono, relate só o que conferiu; não anuncie que "passou pela lista" sem ter passado.

## Mudanças depois: revisar o que já existe

- **Pedido "tira a cara de IA", "está artificial":** leia o texto inteiro antes de mexer; escolha o perfil pelo tipo de texto; marque os fortes (corrija todos), os médios (corrija onde acumulam) e ignore os fracos isolados, sem esquecer que a lista dura vale sempre. Reescreva pelo ponto principal do parágrafo, não remendando frase por frase. Varie o tamanho das frases e devolva a pontuação que faltava.
- **Releia procurando o que a própria revisão introduziu:** revisão automática tende a uniformizar as frases, apagar hesitação e deixar tudo redondo demais.
- **Texto que o dono escreveu e colou:** é amostra da voz dele. Mantenha palavras, ritmo, regionalismo e opinião; corrija só a lista dura e o que atrapalha a leitura, e diga na mensagem final o que mudou em cada tela ("troquei 3 travessões por vírgula e dois-pontos no texto Sobre"). Se ele pedir para manter um recurso, mantenha. Nunca esconda mudança.
- **Relatório na mensagem final**, em português simples: o que foi corrigido (padrão e onde), o que não foi mexido e por quê (escolha legítima do autor, texto protegido), a nota de 0 a 50 antes e depois quando o texto for longo, e as lacunas de dado.
- Grave o perfil de voz e as escolhas do dono ("pode usar 'a gente'", "mantenha o 'uai'") em `DECISOES.md`, na seção **Preferências**.
