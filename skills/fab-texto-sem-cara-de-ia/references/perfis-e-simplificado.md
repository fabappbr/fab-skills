# Perfis de voz e português simplificado

O perfil orienta ritmo e registro; nunca autoriza conteúdo novo. Os exemplos são fictícios.

## Escolha do perfil

| Sinal no texto ou no pedido | Perfil |
|---|---|
| Página de venda, sobre, serviço | Voz do negócio (da conversa com o dono e de `DECISOES.md`); sem sinal, neutro |
| Ajuda, onboarding, FAQ, instrução, erro, "simplificar", público amplo | Português simplificado |
| Mensagem de WhatsApp, lembrete, confirmação | WhatsApp de negócio |
| Painel do dono, resposta a decisão | Assertivo |
| Confirmação de ação, instrução curta, texto de ferramenta | Enxuto |
| Resumo do dia, status, relatório | Resumo |
| E-mail interno de equipe | Corporativo informal |
| Artigo, blog, notícia do negócio | Jornalístico ou didático; crônica e post só se o dono pedir |
| Petição, contrato, termos, laudo | Jurídico: protegido |
| Nenhum sinal | Neutro: mantém o registro e só tira os padrões |

Decisão: perfil explícito do dono manda; dentro dele, a amostra de texto do dono controla os detalhes; sem os dois, o perfil detectado; texto com vários registros tem um perfil principal e ajusta só os trechos de outro gênero.

## Perfis

**Neutro.** Clareza, ritmo natural, transições discretas. Evita: primeira pessoa, opinião, humor, mudança de registro.

**WhatsApp de negócio.** Oral e curto, uma ideia por mensagem, frase incompleta aceitável, "a gente" no lugar de "nós", sem "Olá!" com exclamação, sem emoji de enfeite (um emoji de função, como 📍 antes do endereço, só se o dono já usa), sem abreviação de gíria ("vc", "tb") em mensagem de empresa. Nunca muda compromisso, data, destinatário ou certeza.
Exemplo de lembrete: "Oi, Maria. Seu horário de corte é amanhã, 15h, com o Rafa. Se precisar remarcar, é só responder aqui."

**Jornalístico.** Sujeito, verbo, complemento; números e datas da fonte; atribuição só a fontes existentes; sem adjetivo avaliativo; sem primeira pessoa. "A padaria abriu a segunda unidade em maio, na Rua do Carmo. São 12 funcionários."

**Didático.** Pergunta, explicação, exemplo que já está na fonte, reforço; transições explícitas ("Então", "Na prática"). Sinais de IA aqui: exemplo genérico e artificial, tom de enciclopédia, "Neste capítulo abordaremos X, Y e Z".

**Corporativo informal.** Frases curtas, "a gente", verbos de ação, estrangeirismo natural do ramo. Não cria status, prazo, promessa ou experiência.

**Crônica e post (só se o dono pedir).** Ritmo irregular, ironia e posição do autor quando já existem na fonte; gancho na primeira linha no post. Nunca inventar lembrança, sentimento ou opinião.

**Acadêmico.** Termo preciso, qualificação legítima, autores exatos da fonte; sem "faz-se necessário", "cumpre salientar", "no âmbito de".

**Jurídico (protegido).** Mantém estrutura do gênero (fatos, fundamentos, pedidos), seções em maiúsculas, numeração, citação de artigo com número. Corta só repetição mecânica ("cumpre salientar" em série). Atribuição vaga ("conforme entendimento consolidado") sem artigo ou súmula na fonte: aponte a lacuna, nunca crie a referência.

## Perfis de leitura rápida (Assertivo, Enxuto, Resumo)

Servem a quem está no meio de outra coisa. Quatro limites desse leitor explicam as regras: o que não está na tela foi esquecido; entender não é executar; começar é o passo caro; prazo vago não registra.

**Assertivo.** Primeira frase é a resposta completa. Parágrafos de 1 a 3 frases. Negrito em termo-chave, número e decisão, de modo que quem lê só o negrito entende. Sem preâmbulo, sem repetir a pergunta, sem resumo no fim. Aviso em linha própria. Instrução começa pelo verbo e pelo alvo.
Exemplo no painel: "**Reponha o fermento hoje.** Sobram 2 kg e a média de uso é 1,5 kg por dia."

**Enxuto.** Linha 1 é a resposta. Sem calor, sem ressalva genérica, imperativo quando cabe, números exatos. Sinais de IA aqui: explicação não pedida, "espero que ajude", narrar a própria ação ("Vou verificar..."), dramatizar erro ("Ops", "Infelizmente", "Parece que algo deu errado"), expressão idiomática no lugar da ação ("alinhar expectativas", "dar um norte").
Exemplo: "Falta o telefone do cliente. Preencha para enviar o lembrete."

**Resumo.** Abre com uma linha que se sustenta sozinha (resultado e bloqueio principal); estado em lista com cinco valores fixos: feito, em andamento, não iniciado, desconhecido, bloqueio; um item por linha com o assunto em negrito; bloqueio em linha própria; "Sua vez:" com opções numeradas; prazo em unidade concreta só se a fonte der. Nunca inventar status: o que não se sabe é "desconhecido". No app, cada estado aparece como texto acompanhado de um ícone do `lucide-react` (`CheckCircle2`, `Clock`, `Circle`, `HelpCircle`, `AlertCircle`) na cor de token (`text-success`, `text-muted-foreground`, `text-destructive`), nunca emoji e nunca só cor; os números vêm dos dados (soma no cliente, `count()`), nunca do modelo.

Regras comuns aos três: passo a passo com 2 ou mais ações vira lista numerada, uma ação por item; o fecho é uma ação concreta se algo ficou em aberto, ou nada; assunto secundário vai em bloco próprio depois do principal; se o leitor pede profundidade, a compressão desliga, o registro continua.

O que nunca se corta nesses perfis: aviso, número exato, condição de escopo ("só para pedidos até 14h"), grau de certeza, fonte, exceção. Se omitir faz o leitor agir errado, fica.

Checagem de brevidade: toda proposição do original continua? Nenhum aviso sumiu? Nenhuma condição foi generalizada? "Pode" continua "pode"? Números exatos? Passos numerados, fecho em ação?

## Português simplificado

Base: operações do PorSimples (NILC/USP), Lei 15.263/2025 (Política Nacional de Linguagem Simples) e métricas do NILC-Metrix. Simplificar a forma, nunca o raciocínio.

**Operações:**
1. Dividir período composto: frase com mais de 25 palavras e "que", "o qual", "onde" ou subordinada vira duas ou três frases.
2. Passiva para ativa quando o agente é conhecido. "O pedido foi aprovado pela loja" vira "A loja aprovou o pedido". Agente desconhecido: a passiva fica.
3. Ordem direta: "Preocupa o dono a demora" vira "A demora preocupa o dono".
4. Conectivo simples: "não obstante" (mas), "em que pese" (apesar de), "haja vista" (porque), "no que tange a" (sobre), "à medida que" (conforme), "conquanto" (embora), "porquanto" (porque), "por intermédio de" (por meio de), "com vistas a" (para), "em virtude de" (por causa de).
5. Aposto com mais de 5 palavras vira frase nova; aposto curto fica.
6. Palavra rara por comum sem perder precisão: implementar (fazer, colocar em prática), viabilizar (permitir), otimizar (melhorar), aferir (medir), pleitear (pedir), ensejar (causar), dirimir (resolver), prospectar (buscar), protocolar (registrar), deliberar (decidir). Termo técnico do leitor fica e é explicado na primeira vez: "O sinal (valor pago na reserva) é descontado da conta".
7. Sujeito explícito quando o oculto deixa dúvida: "A médica falou com a recepcionista. Disse que o horário mudou." vira "A médica disse que o horário mudou."

**Metas:** média de palavras por frase entre 13 e 18 (público geral e saúde até 15; FAQ e onboarding até 13; ferramenta para profissional até 18); máximo 25. Repetição deliberada ajuda (não force sinônimo). Poucas orações por frase; verbo principal cedo; pouca subordinada e pouca passiva.

**15 regras:**
- Sempre: uma ideia por frase; ordem direta; voz ativa; palavra comum; frase curta (meta 13 a 18, máximo 25); conectivo simples ("porque", "por isso", "então", "mas").
- Quando possível: explicar termo técnico na primeira vez; sem dupla negação ("não é impossível" vira "é possível" só se não mudar a certeza); subjuntivo simples ("Caso haja necessidade" vira "Se precisar"); lista para 3 ou mais itens; sujeito explícito se houver dúvida; aposto longo vira frase.
- Conforme o gênero: estrangeirismo só do ramo do leitor; repetir o substantivo quando o referente está longe; estrutura visual (subtítulos, listas) sem transformar toda prosa em tópicos.

**Exemplo de aplicativo:**
Antes: "Para efetuar o cancelamento do agendamento, o usuário deverá acessar a área de agendamentos e selecionar a opção correspondente, observando que cancelamentos com menos de 24 horas de antecedência estão sujeitos à cobrança de taxa."
Depois:
"Para cancelar:
1. Abra Meus agendamentos.
2. Toque no horário e em Cancelar agendamento.
Cancelamento com menos de 24 horas de antecedência tem taxa." (regra das 24h só se o dono deu)

**Quando não simplificar:** se muda a relação de causa, tira uma ressalva necessária ("possivelmente eficaz" não vira "eficaz"), apaga uma exceção, troca o nome oficial de um termo, ou separa um número do contexto que lhe dá sentido. Citação direta nunca se simplifica. Número fica todo; sigla fica e é explicada na primeira vez.

**Checagem:** frases com até 25 palavras; maioria em ordem direta; passiva só onde se justifica; termo técnico explicado; conectivos simples; listas para 3 ou mais; apostos longos separados; sujeito claro; nada acrescentado nem tirado; grau de certeza igual; citação intacta; números completos no contexto certo.

## Relatório e controle de versões (na edição)

Faça uma versão, confira a trava factual, dê a nota de 0 a 50; se ficar abaixo de 35 e houver rodada, mexa na dimensão mais baixa; no máximo 2 rodadas; fique sempre com a melhor versão que passou na trava. Se nenhuma passar, devolva o texto original e diga por quê. Dimensões de apoio para o relatório: remoção de padrões, naturalidade, consistência de voz e legibilidade.

## Não é objetivo

Não usar nota de detector de IA como prova ou critério: essas ferramentas erram muito e penalizam mais quem é neurodivergente ou não é falante nativo.
