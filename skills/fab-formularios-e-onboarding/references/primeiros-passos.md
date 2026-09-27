# Primeiros passos e onboarding

## As duas falhas e o acerto

- **Tutorial demais**: doze telas explicando funcionalidades antes de a pessoa tocar no app. Quem pode, pula; quem não pode, desiste. Terminar o tutorial não é ativar.
- **Pular e cair no vazio**: "Pular" tão fácil e sem consequência que todos pulam e caem num app sem nada, sem saber o que fazer, e não voltam.
- **Revelação na hora certa**: cada passo aproxima a pessoa de um resultado real; o que pode esperar, espera; pular existe, mas deixa um caminho de volta visível.

Teste: a pessoa viu o app fazer algo útil para ela no primeiro uso? Se terminou tudo e não viu, foi tutorial demais. Se pulou e não voltou, foi vazio.

## Assistente ou não (as cinco condições)

1. Há configuração real antes do valor (serviços e horários, dados da empresa, equipe, conectar algo).
2. O momento "entendi" pede várias ações em sequência.
3. O público aceita ser guiado (gestão, configuração de negócio).
4. Alguém vai manter o assistente quando o app mudar (em app gerado: cada edição que muda a configuração revisa o assistente).
5. Há como medir (eventos e ativação definidos).
Com as cinco, assistente. Com duas ou menos, checklist e estados vazios bastam. Não faça assistente quando o app já entrega valor na primeira ação (anotar, consultar, pedir), quando uma dica no lugar resolve ou quando a configuração se entende melhor depois de usar.

## O momento "entendi"

Uma ação da própria pessoa, que produz um resultado visível, real (dados dela, não demonstração) e único (um momento, não uma lista). Aconteça no primeiro uso, idealmente em 5 a 10 minutos, no máximo no passo 3 a 5 do assistente.

| Ramo | Momento "entendi" |
|---|---|
| Salão, clínica, estúdio | cadastrou um serviço e viu o horário livre na agenda / o primeiro agendamento marcado |
| Oficina, assistência | abriu a primeira OS e mandou o orçamento pelo WhatsApp |
| Loja, delivery | cadastrou um produto e viu a vitrine com ele |
| Escola, curso | criou a turma, matriculou o primeiro aluno e viu a lista de chamada |
| Financeiro | lançou uma conta a receber e viu o saldo previsto do mês |
| CRM, vendas | cadastrou um negócio e o viu no quadro de etapas |
| Funcionário convidado | viu as tarefas do dia dele e concluiu a primeira |

Se o resultado real demora (aprovação, primeiro cliente), crie um resultado intermediário no primeiro uso ("veja como seu cliente vai receber o orçamento"). Evite: tutorial como ativação, demonstração com dados falsos como ativação, vários momentos, momento só na segunda visita, momento suposto sem conferir depois (se quem chega nele não volta, o momento está errado).

## Passos do assistente

| Passo | Para quê | Pode pular? |
|---|---|---|
| Boas-vindas | uma frase do que vai acontecer ("Em 3 passos seu salão fica pronto para receber agendamentos") | sim; corte se o propósito já é óbvio |
| Quem é você | só se os próximos passos mudam com a resposta (ramo, tamanho da equipe) | sim, com padrão |
| Configuração essencial | a coisa sem a qual o app fica vazio (serviços, horários, produtos) | com aviso honesto do efeito |
| Primeira ação | a ação que leva ao momento "entendi" | não recomendado |
| Adiáveis | convidar equipe, ligar avisos, importar planilha | sim, viram itens do checklist |
| Pronto | o que foi feito e o próximo passo; leva à tela dos 80% | não se aplica |

Regras: cada passo aproxima do momento "entendi" ou sai; 3 a 5 campos por passo (1 ou 2 é excesso de etapas, 6 ou mais pesa); passo com processamento mostra progresso; "Continuar" principal e "Fazer depois" como link secundário; voltar preserva respostas. Exemplos: agenda (boas-vindas → serviços → horários → primeiro agendamento → convidar equipe, adiável → pronto); loja (boas-vindas → dados da loja → primeiro produto → ver a vitrine → pronto).

## Mostrar só o necessário

| Padrão | Como | Quando |
|---|---|---|
| Padrões sensatos | campos já preenchidos com o caso comum (horário comercial 9h a 18h, duração 60 min), editáveis | quase sempre |
| Obrigatório agora, opcional depois | o assistente só pede o essencial; o resto vira dica no lugar certo depois | assistente inchado |
| Abrir sob demanda | "Mais opções" recolhido | quando poucos precisam de profundidade |
| Ramificação | primeira resposta muda os passos | só com necessidades bem diferentes; 2 ou 3 caminhos no máximo |

Padrão honesto reflete o caso típico e aparece para ser mudado; nunca opção paga ou consentimento pré-marcado. Texto de ajuda: uma frase por passo e dica só em campo não óbvio. No celular: padrões importam mais (digitar é difícil), uma pergunta por tela em passos longos.

## Pular e retomar

| Pular | Como | Quando |
|---|---|---|
| Com contexto | "Fazer depois. Vamos lembrar você na tela inicial." | a maioria dos passos |
| Adiar para o checklist | o passo pulado vira item de "Primeiros passos" | quando o assistente ficaria longo |
| Com aviso | "Sem horários, seus clientes não conseguem agendar. Pular mesmo assim?" | só em passo essencial; aviso em todo passo cansa |
| Sem pular | obrigatório | raro (aceite de termos exigido, por exemplo) |

Peso visual: "Continuar" principal e "Fazer depois" secundário na maioria dos passos; nunca pular mais chamativo que continuar; nunca pular escondido.

| Retomar | Como |
|---|---|
| No próximo login | `appUser.fields.onboarding_step` leva de volta ao passo em que parou |
| Pelo app | item "Primeiros passos" no menu da conta reabre o checklist ou o assistente |
| Natural | o item se marca sozinho quando a pessoa faz a ação por outro caminho (o checklist lê os dados reais) |

Lembretes: no máximo um por sessão, no momento em que faz sentido (ao abrir a agenda vazia: "Cadastre seus horários para receber agendamentos. Leva 2 minutos."), com "Não mostrar de novo". Tom de ajuda, nunca de bronca: "Faltam 2 passos para seu salão receber agendamentos", não "Você não terminou a configuração".

## Tipos de pessoa

| Quem | O que precisa | Momento "entendi" |
|---|---|---|
| Admin ou dono | configurar, convidar, ver o negócio andando | "está pronto e a equipe pode usar" |
| Funcionário convidado | saber o que fazer hoje | "fiz minha primeira tarefa" |
| Cliente final (app com área do cliente) | fazer o que veio fazer | "agendei", "acompanhei meu pedido" |

Comece com um fluxo; separe só quando os caminhos diferem em 3 ou mais passos. No máximo 3 variações. Admin que também trabalha no balcão vê as duas coisas.

## Checklist de primeiros passos

- 4 a 6 itens, ordenados pelo valor que entregam, não pela facilidade.
- Itens já feitos aparecem marcados (inclusive "Criar sua conta"): começar com progresso anima.
- Cada item: verbo + objeto, uma linha de benefício, botão que leva direto à ação.
- Estado calculado dos dados (`count(service) > 0`), nunca de cliques; assim se marca sozinho.
- Progresso "2 de 5" com `Progress`.
- Pode ser ocultado e recuperado no menu da conta.
- Conclusão com uma mensagem curta e o checklist some; nada de festa para ação trivial.

Itens típicos: cadastrar o primeiro [serviço/produto]; configurar [horários/dados da empresa]; [primeira ação do momento "entendi"]; importar clientes de uma planilha (`CsvImport`); convidar alguém da equipe (`admin.invite` ou `<Members/>`); ativar avisos no celular (`EnablePushButton`, depois do momento "entendi").

## Estados vazios que ensinam

| Tela | Em vez de "Nenhum dado" |
|---|---|
| Painel inicial | checklist de primeiros passos e o atalho para a primeira ação |
| Lista de clientes | "Seus clientes aparecem aqui." + Cadastrar cliente + Importar planilha |
| Agenda | "Nenhum horário marcado hoje." + Novo agendamento + Compartilhar link de agendamento |
| Relatórios | "Os números aparecem quando houver vendas." + prévia de como vai ficar |

## Dados de exemplo

Marcados (`is_sample: true`, selo "Exemplo"), realistas (nomes brasileiros de várias regiões, valores plausíveis, um nome longo, um registro em cada etapa), úteis para mostrar o app funcionando e removíveis num clique ("Apagar exemplos" com confirmação). Nunca misturados sem marca aos dados reais; nunca apresentados como fatos do negócio. Pelo terminal você não grava registros (o CLI escreve definição e código, nunca dados): os exemplos nascem pelo próprio app, num botão "Carregar exemplos" que o dono logado como admin clica (os registros vêm de uma lista em `src/lib/exemplos.ts`, gravados com `bulkCreate` e `is_sample: true`), ou o dono os cadastra ou importa no CMS do Studio.

## Medição

Eventos: `onboarding_start`, `onboarding_step_view`, `onboarding_step_done`, `onboarding_skip`, `onboarding_complete`, `activation` (com `{ step }` ou `{ action }`). Pular e desistir são coisas diferentes: pular é escolha; desistir é o app não ter segurado a pessoa. Métricas: conclusão por passo, taxa de pulo por passo, retomada de quem pulou, tempo por passo e total, ativação de quem concluiu versus de quem pulou. Ativação é a métrica; conclusão do assistente é só um sinal. No app, dá para conferir ativação pelos próprios dados (quantas contas têm o primeiro pedido nos 7 primeiros dias).

| Sintoma | Diagnóstico | Correção |
|---|---|---|
| Muita gente conclui e pouca ativa | o assistente não leva ao momento "entendi" | redesenhar em volta da ação real; cortar passos de explicação |
| Mais da metade pula | assistente não se paga ou pular está chamativo demais | cortar passos; rebalancear o peso dos botões |
| Conclui e some em 24 h | valor demora demais | trazer o momento "entendi" para o primeiro uso |
| Pula e não volta | falta caminho de volta | checklist com os pulados e lembrete no lugar certo |
| Grupos com resultados muito diferentes | um fluxo para públicos diferentes | variação por tipo de pessoa |
| Colocamos mais passos e piorou | tutorial demais | cortar |
| Quem usa muito conclui e abandona | assistente lento para quem já sabe | pular fácil e configuração avançada acessível depois |

Anti-padrões: tutorial demais; pular que leva ao vazio; passos decorativos; tutorial ou demonstração como ativação; variações demais ou de menos; pular escondido; validação rígida; quebrado no celular; assistente desatualizado depois de uma edição; interrogatório (perguntas de marketing disfarçadas de configuração); popup no meio; perder respostas em erro; medir só conclusão.
