# Crítica: heurísticas, gravidade e nota

Quem usa um app não lê, passa o olho; não escolhe a melhor opção, escolhe a primeira que parece servir; não aprende como funciona, vai tentando. A crítica mede o quanto a tela respeita isso.

## Ordem da crítica
1. **Especificidade** (antes de tudo): a composição, o texto e o visual nasceram deste negócio ou serviriam para qualquer outro? Teste da troca: cubra o nome e a logo; se pudesse ser outro app, falta personalidade.
2. **As 10 heurísticas de Nielsen**, nota 0 a 4 cada.
3. **Carga cognitiva** (checklist de 8).
4. **Teste do porta-malas** e leis de Krug.
5. **Personas**: 2 ou 3 da tabela, andando pela ação principal.
6. **Achados priorizados** P0 a P3: os 3 a 5 que mais importam, o que está funcionando (2 ou 3 coisas, com o motivo) e observações menores.

Seja direto e específico: "o botão Salvar da tela Clientes", nunca "alguns elementos". Diga o que está errado e por que atrapalha o cliente. Conserto concreto; nada de "considere explorar".

## As 10 heurísticas (0 a 4)

Escala comum: **0** ausente, o usuário fica perdido; **1** raro, quase tudo falha; **2** parcial, o principal funciona e sobram buracos; **3** bom, falhas pequenas; **4** excelente, de verdade. A maioria dos apps reais fica entre 20 e 32 de 40.

| # | Heurística | O que conferir no código |
|---|---|---|
| 1 | Status visível | carregando em toda busca; confirmação ao salvar, enviar, excluir (`toast`); progresso em fluxo de etapas (`Stepper`); aba atual marcada; validação na linha. 4 = toda ação confirma. Envio que não mostra nada e o cliente reenvia = P0 |
| 2 | Linguagem do mundo real | palavras do cliente ("Entrar", não "Autenticar"; "Buscar", não "Consultar registros"); ordem natural (rua, número, bairro, cidade, CEP); ícones reconhecíveis |
| 3 | Controle e liberdade | cancelar em todo formulário e diálogo; voltar em toda tela de detalhe; limpar filtro e busca; sair de fluxo longo no meio |
| 4 | Consistência | um termo por conceito ("Agendamentos" em todo lugar, nunca misturado com "Reservas"); mesmo botão, mesma cara; convenções (logo leva ao início, ação principal à direita ou embaixo) |
| 5 | Prevenção de erro | `ConfirmDialog` antes de excluir; `DatePicker`, `Select`, `PhoneInput`, `CurrencyInput` em vez de texto livre; padrões sensatos; aviso de alterações não salvas em formulário longo |
| 6 | Reconhecer em vez de lembrar | opções visíveis; ícone com rótulo; valores decodificados (o nome do cliente, não o id); contexto repetido onde a decisão acontece |
| 7 | Flexibilidade e eficiência | busca, filtros salvos na URL, ações em lote (`updateMany`), atalhos para quem usa todo dia; nada disso atrapalhando o iniciante |
| 8 | Estética e minimalismo | só o necessário em cada passo; UMA ação principal por tela; nada de enfeite competindo |
| 9 | Recuperar de erros | mensagem com o que houve, por que (se ajuda) e como resolver; perto do campo; o formulário mantém o que foi digitado; nada de código de erro para o cliente |
| 10 | Ajuda | dica curta no ponto de dúvida (`Tooltip`, texto de ajuda do `Field`), ajuda organizada por tarefa ("Como remarcar") |

Em telas de "Vender" e "Mostrar", as heurísticas 7 e 10 podem receber "n/a" com uma linha de motivo. Aí o máximo cai (32 com duas n/a) e a faixa sai do percentual.

**Faixas**: 90% ou mais excelente (só polimento); 70% bom (base sólida, pontos fracos); 50% aceitável (melhoria significativa antes de o cliente ficar feliz); 30% ruim (a experiência principal está quebrada); abaixo disso crítico (refazer).

## Gravidade

| P | Nielsen | Nome | Significa | Ação |
|---|---|---|---|---|
| P0 | 4 | Bloqueia | impede terminar a tarefa | corrigir agora |
| P1 | 3 | Grave | dificuldade ou confusão grande; falha de acessibilidade AA | corrigir nesta edição |
| P2 | 2 | Menor | incomoda, mas tem saída | próxima passada |
| P3 | 1 | Polimento | sem impacto real | se sobrar tempo |
| (ignorar) | 0 | Não é problema | gosto pessoal, discordância | não entra |

Pese três fatores: frequência (quantas vezes acontece), impacto (quão ruim quando acontece), persistência (uma vez só ou sempre). Na dúvida entre dois níveis: **"o cliente mandaria mensagem para o dono reclamando disso?"** Se sim, é pelo menos P1. Muitos P3 viram ruído: reporte os que importam.

## Carga cognitiva

Checklist (conte as falhas: 0 a 1 baixa; 2 a 3 moderada, tratar logo; 4 ou mais alta, crítico):
1. Foco único: dá para fazer a tarefa principal sem distração?
2. Blocos: a informação vem em grupos de até 4 itens?
3. Agrupamento: o que é relacionado está junto (proximidade, fundo)?
4. Hierarquia: fica óbvio o que é mais importante?
5. Uma coisa por vez: uma decisão antes da próxima?
6. Poucas escolhas: até 4 opções visíveis em cada ponto de decisão?
7. Memória: precisa lembrar algo da tela anterior para agir nesta?
8. Revelação progressiva: o complexo só aparece quando precisa?

Regra da memória de trabalho: cabem cerca de 4 coisas de cada vez. Até 4 opções, tranquilo; 5 a 7, agrupe ou esconda; 8 ou mais, o cliente pula, erra ou desiste. Botões: 1 principal, 1 ou 2 secundários, o resto num menu. Navegação principal: até 5 itens.

Vícios nomeados: **parede de opções** (10 escolhas sem hierarquia: agrupe e destaque a recomendada); **ponte de memória** (etapa 3 exige lembrar a 1: repita o contexto); **navegação escondida** (sem "você está aqui": marque a aba, use `Breadcrumb`); **barreira de jargão**; **chão de ruído** (tudo com o mesmo peso: 1 principal, 2 ou 3 secundários, o resto quieto); **padrão inconsistente**; **tarefa múltipla** (ler, decidir e navegar ao mesmo tempo: sequencie); **troca de contexto** (pular entre telas para decidir uma coisa: junte a informação).

## Krug

- **Não me faça pensar.** Todo "hein?" é problema. Nome claro vence nome criativo sempre: menu com "Agendar", "Cardápio", "Onde estamos", nunca "Experiências" ou "Soluções". Se um rótulo precisa de explicação, troque o rótulo. Botão com verbo e objeto ("Criar conta", "Baixar recibo").
- **Cliques não importam; confiança importa.** Três cliques óbvios valem mais que um clique que faz pensar. Etapas com rótulo ("Etapa 2 de 4: Endereço").
- **Corte metade das palavras, depois metade do resto.** Fora: boas-vindas vazias ("Bem-vindo ao nosso site! Estamos felizes..."), instruções que ninguém lê, "por favor" e "gentilmente" de enfeite. Antes: "Por favor, informe sua senha para prosseguir para a próxima etapa." Depois: "Digite sua senha para continuar." Nunca cortar informação que o cliente precisa para decidir (preço, prazo, condição).
- **Reservatório de boa vontade.** Esvazia: esconder telefone ou preço, punir por não fazer do seu jeito, pedir dado desnecessário, fazer repetir, erro amador (link quebrado, erro de digitação). Enche: responder a dúvida antes de ser feita, poupar passos, pedir desculpa quando algo falha.
- **Página inicial em 3 a 4 segundos**: o que é isto, o que posso fazer aqui, por que aqui e não em outro lugar. Frase de apresentação de 6 a 8 palavras, específica ("Corte e barba no Centro, sem fila"), nunca "O futuro do seu cabelo".
- **Teste do porta-malas.** Solte o cliente em qualquer página: ele precisa responder em segundos.

| Pergunta | O que responde |
|---|---|
| Que site ou app é este? | logo e nome no cabeçalho, levando ao início |
| Em que página estou? | título da página igual ao link que trouxe até ela |
| Quais são as seções? | navegação principal sempre no mesmo lugar |
| O que posso fazer aqui? | ações da página visíveis |
| Onde estou na estrutura? | aba ou item marcado, `Breadcrumb` em detalhe |
| Como busco? | busca visível onde há mais de uma tela de itens |

**Teste de uso de custo zero (sugestão ao dono, nos próximos passos da mensagem final)**: 3 ou 4 pessoas pegam a maioria dos problemas; melhor testar com 3, consertar e testar com outras 3. Peça à pessoa uma tarefa real ("marque um corte para sábado"), diga "estou testando o app, não você" e "pense em voz alta", e não ajude nem explique: só observe e anote. O que o comportamento quer dizer: clicou no lugar errado = rótulo confuso; hesitou = decisão pouco óbvia; ficou olhando em volta = falta "você está aqui"; leu tudo = a tela não se explica sozinha; foi direto para a busca = a navegação falhou. Avaliação por heurística (esta crítica) vem antes do teste com pessoas; ela acha as violações grandes, o teste acha o comportamento real.

## Personas (escolha 2 ou 3)

- **Rafa, o apressado experiente**: pula instrução, quer lote e atalho, larga se parecer lento. Sinais: tutorial obrigatório, confirmação em ação de baixo risco, um item por vez onde lote seria natural, animação que não dá para pular.
- **Dona Cida, primeira vez**: lê tudo, hesita, entende o rótulo ao pé da letra. Sinais: navegação só com ícone, jargão, sem confirmação de que deu certo, próximo passo ambíguo, sem "voltar".
- **Samuel, teclado e leitor de tela**: percorre com Tab, depende de títulos e rótulos, precisa de contraste 4,5:1 e zoom de 200%. Sinais: ação só com clique, foco invisível, significado só pela cor, campo sem rótulo, mudança de estado que o leitor não anuncia.
- **Bia, a que testa limites**: nome enorme, emoji, colar da planilha, voltar no meio, abrir duas abas. Sinais: função que parece funcionar e falha em silêncio, erro que mostra detalhe técnico, vazio que não orienta, dado perdido ao atualizar.
- **Léo, no celular com uma mão, no ônibus**: polegar, interrompido o tempo todo, internet fraca. Sinais: ação importante no topo, progresso perdido ao sair, digitar onde escolher bastaria, alvo de toque pequeno ou colado no outro, imagem pesada em toda tela.

| Tipo de tela | Personas |
|---|---|
| landing, site público | Dona Cida, Bia, Léo |
| painel, admin | Rafa, Samuel |
| loja, pagamento | Léo, Bia, Dona Cida |
| primeiro uso | Dona Cida, Léo |
| muitos dados | Rafa, Samuel |
| formulário longo | Dona Cida, Samuel, Léo |

Para cada uma, diga exatamente o elemento que falhou ("a aba Financeiro só tem ícone: Dona Cida não acha"). Se `DECISOES.md` (Identidade) descreve o público do dono, crie 1 persona a mais a partir dele; nunca invente público.

## Diagnóstico rápido (nota 0 a 10)
Comece em 10 e desconte por linha que falha: 2 pontos se a falha é P0 ou P1, 1 ponto se é P2 ou P3.

| Pergunta | Se não |
|---|---|
| Dá para saber que app e que página é na hora? | logo, título da página, marcação da aba |
| A ação principal é óbvia? | uma ação principal por tela |
| A navegação é clara? | teste do porta-malas |
| Dá para achar a busca? | busca visível |
| Mostra o que está acontecendo? | carregando, confirmação, progresso |
| As mensagens de erro ajudam? | o que houve e como resolver |
| Dá para desfazer ou voltar? | cancelar, voltar, confirmar exclusão |
| Funciona sem passar o mouse? | nada importante só no hover |
| Todo interativo tem rótulo? | texto junto do ícone |
| Algo faz parar e pensar "hein?" | simplificar |

Faixas: 9 a 10 sem P1 e no máximo uma falha; 6 a 8 alguns problemas graves; 3 a 5 um problema que bloqueia ou muitas falhas; 2 ou menos a tarefa principal não acontece. Sempre diga a nota, os achados mais graves e o que falta para chegar a 10.

## Quando duas heurísticas brigam

| Conflito | Saída que atende as duas |
|---|---|
| Simples x poderoso | revelação progressiva (o básico visível, o avançado em `Accordion`, `Tabs`, `Sheet`) |
| Eficiente x seguro | desfazer em vez de confirmar; confirmar só o irreversível ou caro (dinheiro, exclusão) |
| Limpo x fácil de achar | ação principal visível, secundárias em menu |
| Consistente x contextual | mesmo padrão, destaque diferente conforme o caso |
| Guiar x deixar livre | aviso que não bloqueia; validar ao sair do campo, não a cada tecla; mostrar todos os erros no envio |

Contexto decide: dado crítico e irreversível → prevenção vence eficiência; ação frequente e barata → eficiência vence; cliente novo → orientação vence; tela pequena e tarefa focada → limpeza vence. Onboarding: deixar pular e ensinar no momento de uso. Navegação no celular: abas embaixo para 3 a 5 itens, nunca menu hambúrguer como navegação principal. Padrões: sensatos para 80% dos casos, fáceis de mudar. Quando você escolher violar uma heurística, diga qual e por quê.

## Padrões enganosos (nunca construir, e apontar se existirem)
Cancelar difícil e assinar fácil; entrar fácil e sair impossível; compartilhar tudo por padrão; botão que faz outra coisa ("X" que compra); "Não, prefiro perder dinheiro" para recusar; taxa que aparece só no fim; informação importante em cinza miúdo; opção paga pré-marcada; dupla negação em caixa de marcar; item colocado no carrinho sem pedido; urgência ou escassez falsa ("só 2!" que nunca acaba, contador que reinicia). O certo: cancelar tão fácil quanto assinar, total com taxas antes do último passo, recusa neutra ("Agora não") com o mesmo peso, escassez só se for real. Teste do espelho: o dono ficaria confortável se um jornalista contasse como funciona? A LGPD pede consentimento livre, recusar tão fácil quanto aceitar, sem caixa pré-marcada.

## Acessibilidade mínima (WCAG 2.1 AA)
Contraste 4,5:1 no texto, 3:1 em texto grande (18px ou mais, ou 14px negrito) e em ícones, bordas de campo e foco; nada de significado só pela cor; zoom de 200% sem perder conteúdo; nada rola de lado a 320px; tudo operável por teclado, sem armadilha de foco, foco visível; ordem de tabulação igual à visual; links com texto que faz sentido sozinho ("Ver horários do sábado", não "Clique aqui"); títulos em ordem (h1, h2, h3, sem pular); campo com rótulo visível e `autoComplete` certo (`name`, `email`, `tel`, `postal-code`); erro descrito em texto com sugestão; mensagem de status anunciada (`aria-live="polite"`); diálogo devolve o foco ao botão que o abriu; nada pisca mais de 3 vezes por segundo; animação automática pode parar; gesto de arrastar ou pinçar tem alternativa de toque.

## Formato do relatório de crítica (modo Crítica)
Nota de uso (tabela das 10, total e faixa), veredito de especificidade, impressão geral (o que funciona, o que não, a maior oportunidade), o que está funcionando, os achados P0 a P3 com o conserto e o pedido que resolve ("Endurecer", "Clarear"...), sinais por persona, observações menores e 1 a 3 perguntas ao dono com opções tiradas dos achados (na ferramenta de perguntas de opção da sua ferramenta; no Claude Code, AskUserQuestion; sem ela, opções numeradas): por onde começar ("Arrumar a navegação primeiro" / "Arrumar os textos primeiro"), tom ("O app parece frio e técnico. Quer mais acolhedor ou está bom assim?") e alcance ("Os 3 mais graves" / "Tudo"). A pergunta vem por último. Com menos de 3 achados, pode pular a pergunta e dizer por quê.
