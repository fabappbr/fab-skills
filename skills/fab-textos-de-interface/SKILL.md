---
name: fab-textos-de-interface
description: "Escreve todos os textos de dentro do app com regra fixa por elemento: botões, mensagens de erro, estados vazios, confirmações de exclusão, avisos (toast), rótulos, placeholders, dicas, onboarding, notificações e e-mails automáticos. Gera a voz do negócio a partir do que o dono contou, usa a mesma palavra para a mesma ação no app inteiro, escreve em português simples e nunca inventa número ou regra do negócio. Use quando o dono disser: 'os textos do app estão estranhos', 'a mensagem de erro não explica nada', 'o botão diz Enviar', 'meus clientes não sabem o que fazer na tela', 'tela vazia sem nada', 'escreve as notificações', 'melhora o onboarding', 'aviso de confirmação', 'o que escrever no botão'. O foco é o elemento; texto longo e 'parece robô' ficam com fab-texto-sem-cara-de-ia. Serve para gestão, agenda, CRM, loja, delivery, portal do cliente, área de membros e qualquer app com formulário, lista ou cadastro. Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli)."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Textos de Interface
  edition: terminal
---

# Textos de Interface

Esta skill decide cada frase que a pessoa lê para usar o app: o botão, o erro, a tela vazia, a confirmação, o aviso.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`https://api.fabapp.ai/llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.
 Texto de interface é lido com pressa, no celular, muitas vezes em momento de tensão (um pagamento que falhou, um cadastro que sumiu). Por isso cada elemento tem uma forma fixa, e a mesma coisa se chama igual do começo ao fim.

Quatro qualidades valem para toda linha: **com propósito** (ajuda a pessoa a fazer o que veio fazer), **curta** (cada palavra tem trabalho), **de conversa** (soa como gente falando, não como sistema) e **clara** (um sentido só).

## Regras que valem sempre

1. **Maiúscula só na primeira palavra** e em nome próprio, em botão, rótulo, título e aba: "Salvar alterações", nunca "Salvar Alterações". Caixa alta aplicada por CSS (`uppercase`) por uma skill de estilo não é Title Case e é permitida; a string no código continua em caixa de frase.
2. **Botão de ação do app com verbo no infinitivo + objeto** (salvar, excluir, agendar dentro do fluxo logado e formulários): "Salvar alterações", "Agendar horário", "Excluir cliente". Nunca "OK", "Enviar", "Confirmar" sozinho, "Sim", "Clique aqui", "Saiba mais" quando dá para nomear o resultado. O CTA de página pública de venda segue outra regra (a da skill `fab-copy-que-vende`, se instalada): imperativo com "seu/sua" ou primeira pessoa: "Agende seu horário", "Quero meu orçamento"; nunca os dois estilos na mesma tela.
3. **Tratamento "você"**, o mesmo do site e das mensagens. Sem "o usuário" em texto visível.
4. **Mesma palavra para a mesma ação no fluxo inteiro.** Se a tela 1 diz "agendamento", a tela 3 não diz "reserva" nem "horário marcado". Se o botão diz "Excluir", o aviso diz "excluído", não "removido". Verbos diferentes para ações diferentes na mesma tela.
5. **Português simplificado:** ordem direta (quem, faz, o quê), uma ideia por frase, frases de 13 a 18 palavras (máximo 25; erro e instrução, até 14), palavra comum, voz ativa, termo técnico explicado na primeira vez.
6. **Nada inventado:** número, prazo, regra de cancelamento, taxa e capacidade que o app não tem não aparecem como fato; dado que o app conhece vem do registro na hora (`count()`, campo do modelo); regra do negócio que o dono não deu vira lacuna nomeada (seção "A construção").
7. **Sem tiques de IA** (a lista dura da skill `fab-texto-sem-cara-de-ia` manda nisso se estiver instalada): zero travessão ou meia-risca como pontuação, zero "com sucesso", zero "Ops!" ou "Olá!" abrindo aviso, zero exclamação em toast, zero emoji decorativo, zero "não é apenas X, é Y", zero adjetivo de propaganda no lugar do fato, zero gerundismo.
8. **Datas, horas e dinheiro no padrão do app:** `formatDate`, `formatDateTime`, `formatMoney` (R$ 1.234,56, dd/mm/aaaa, 24h). Telefone (11) 91234-5678.

## Regra por elemento

| Elemento | Regra | Forma |
|---|---|---|
| Botão e link | Verbo no infinitivo + resultado. Link diz o destino ("Ver histórico de pedidos"). Par de botões honesto: "Cancelar" / "Excluir cliente", nunca "Cancelar" / "OK". Opção de recusa neutra, sem culpa ("Continuar sem seguro", nunca "Não, prefiro correr risco"). | 2 a 4 palavras, até 6 |
| Mensagem de erro | O que aconteceu + como resolver, nessa ordem. Sem culpa, sem desculpa vazia, sem código como título. | "{O que houve}. {Como resolver}." |
| Estado vazio | O que vai aparecer ali + UMA ação que preenche. Nunca "Nada aqui" sem próximo passo. | "{O que falta}. {Benefício curto}." + um botão |
| Confirmação destrutiva | Nomeia o item, o que some junto, quanto, e se volta. Botão repete o verbo. Nunca só "Tem certeza?". | "Excluir {item}? {Consequência}. {Volta ou não}." |
| Toast / aviso rápido | Resultado no passado, sem exclamação, sem "com sucesso". | "{Coisa} {particípio}." ex. "Agendamento confirmado." |
| Rótulo de campo | Substantivo que diz o conteúdo, sem dois-pontos, sempre visível. Opcional marcado como "(opcional)". | "Telefone", "Data de nascimento" |
| Placeholder | Exemplo de valor, não instrução e nunca no lugar do rótulo. | "(11) 91234-5678", "nome@exemplo.com" |
| Texto de ajuda | Responde "por que pedem isso?" ou o formato exigido, antes de digitar. | "Usamos para lembrar do seu horário." |
| Dica (tooltip) | Uma frase: o que o controle faz ou por que está desativado. Nunca repete o próprio rótulo. | "Disponível depois de escolher o serviço." |
| Título de tela | Substantivo que diz onde a pessoa está, ou tarefa ("Novo agendamento"). 3 a 6 palavras. | "Seus agendamentos" |
| Notificação | Começa pela mudança; só é enviada se a pessoa puder agir ou precisar saber. | Título 35 a 45 caracteres + corpo curto |
| Pedido de permissão | Benefício primeiro, permissão depois. | "Receba o aviso quando o pedido sair. Ativar notificações." |
| Onboarding | Um conceito por passo, valor antes do esforço, sempre com "Pular". 3 a 5 passos até o primeiro resultado. | Título + até 20 palavras + ação |

Exemplos por nicho, variações de voz e moldes completos (estado vazio, erro, onboarding) em `references/padroes-por-elemento.md`.

## Tipos de erro

| Tipo | Quando | Forma | Exemplo |
|---|---|---|---|
| Validação (no campo) | Ao sair do campo ou ao enviar | "{Campo} {exigência}" junto do campo, some quando corrigido | "O e-mail precisa ter @" |
| Sistema (banner ou modal) | Falha ao salvar, pagar, enviar | "{Ação falhou}. {Causa provável}. {O que fazer}." | "O pagamento não passou. O cartão foi recusado. Tente outro cartão ou o Pix." |
| Bloqueio (tela inteira) | Não dá para seguir sem resolver | "{O que está bloqueado}. {Por quê}. {Ação}." | "Sua assinatura venceu. O acesso às aulas está pausado. Renove para voltar." |
| Permissão | Recurso do aparelho | "{Benefício}. {Permissão}." | "Tire a foto da nota direto pelo app. Permitir câmera." |

Erros da plataforma, sempre em português e com saída. Toda chamada do SDK (`collection`, `invokeLLM`, `notify`, `callFunction`) lança `ApiError` com `status` (número) e `message` (o `detail` do servidor, quase sempre já em português). Decida o texto por `e.status`; mostre `e.message` só quando ele faz sentido para a pessoa (o 422 de validação, o 429 de e-mail). Falha de rede não é `ApiError`: o `fetch` lança um erro sem `status`, então trate `!(e instanceof ApiError)` como conexão.

| Situação | Quando acontece de verdade | Texto |
|---|---|---|
| Sem `status` (rede) | conexão caiu, servidor não respondeu | "Não deu para salvar porque a conexão caiu. Confira a internet e tente de novo." |
| 401 | sessão expirada (o SDK já tentou renovar uma vez) ou recurso de IA sem login | "Sua sessão terminou. Entre de novo para continuar." + botão "Entrar" |
| 403 | sem permissão pela regra de acesso do modelo, ou função de backend fora do plano do app | "Você não tem acesso a esta área. Peça acesso ao administrador." |
| 409 | cadastro duplicado: e-mail ou telefone já usado em outra conta, espaço (organização) cheio. Não existe conflito de versão em registro: ninguém recebe 409 por editar o mesmo registro | "Já existe uma conta com este e-mail. Entre com ela ou use outro e-mail." |
| 422 | campo obrigatório faltando, tipo errado, campo desconhecido, filtro em campo fora do schema | Mensagem do campo que falhou, no formato de validação |
| 402 | IA sem crédito, ou limite do plano do app atingido (cota) | "Este recurso está pausado no momento. Avise o responsável pelo app." |
| 429 | muitas requisições em pouco tempo, ou limite diário de e-mails do `notify` | "Muitas tentativas em pouco tempo. Aguarde um instante e tente de novo." Para e-mail: "O limite de e-mails de hoje acabou. Tente de novo amanhã." |

Nunca "Algo deu errado" se o app sabe mais. Se não sabe nada, dê a ação de tentar de novo e um caminho de ajuda. Sem humor em erro de dinheiro, dado perdido ou segurança.

## Tom pelo momento

A voz do negócio é fixa; o tom muda com o estado da pessoa:
- **Frustrada** (erro, bloqueio): calma, sem culpa, solução primeiro.
- **Confusa** (primeiro uso): paciente, passo a passo, explica o porquê.
- **Confiante** (tarefa de rotina): direta, mínima ("Salvo.").
- **Cautelosa** (exclusão, pagamento, dado sensível): séria, consequência clara, saída fácil.
- **Satisfeita** (concluiu algo): positiva e proporcional; comemoração só em conquista real, em texto e sem exclamação ("Primeiros passos concluídos.").

## O plano: voz, glossário e lista de conferência

O plano é um texto que você escreve e mostra ao dono antes de codar. Ele aprova antes da construção.

**Quadro de voz (vai no texto do plano).** Gere a partir do que o dono contou e de `DECISOES.md` (tipo de negócio, público, tom escolhido); o que você decidir sem ele vira suposição no plano, com a alternativa. Três conceitos da marca, cada um com três adjetivos de voz, uma frase do que significa e dois pares "faça / não faça" em texto de interface real do app. Exemplo para clínica odontológica de bairro:

| Conceito | Adjetivos | Faça | Não faça |
|---|---|---|---|
| Cuidadosa | calma, clara, gentil | "Sua consulta é amanhã às 14h. Se precisar remarcar, é só tocar aqui." | "ATENÇÃO: não falte!" |
| Direta | curta, objetiva, escaneável | "Retorno em 6 meses." | "Informamos que o seu próximo retorno deverá ser agendado para daqui a aproximadamente seis meses." |
| Confiável | honesta, precisa, transparente | "O pagamento não passou. Nada foi cobrado. Tente outro cartão." | "Erro no pagamento. Tente mais tarde." |

Restaurante de bairro seria "acolhedor, rápido, do bairro"; loja jovem, "animada, direta, prática". Se o dono mandou um guia de voz ou um texto dele, esse material vence o quadro e as regras desta skill onde conflitar.

**Glossário (vai no plano).** Uma tabela com o nome único de cada coisa do app (o que o cliente chama, em português do dono: "cliente" ou "paciente" ou "aluno", nunca os dois) e o verbo único de cada ação (criar, editar, excluir, arquivar, confirmar, cancelar). Os ids do schema continuam em inglês; o glossário é do texto visível.

**Lista de conferência (entra inteira no plano):**
- Código: "Todo botão de ação do app (fluxo logado e formulários) começa com verbo no infinitivo e nenhum botão diz 'OK', 'Enviar', 'Sim' ou 'Clique aqui'; o CTA de página pública de venda segue a regra de copy de venda."
- Código: "Toda lista tem estado vazio com o que vai aparecer e um único botão que cria o primeiro item."
- Código: "Toda exclusão usa AlertDialog (ou ConfirmDialog) que nomeia o item, o que some junto (com a contagem vinda de `count`) e se dá para desfazer; o botão de confirmar repete o verbo."
- Código: "Todo toast está no passado, sem exclamação e sem 'com sucesso'."
- Código: "Toda chamada que pode falhar mostra erro com o que houve e o que fazer; falha de rede e os status 401, 402, 403, 409, 422 e 429 do `ApiError` têm texto próprio em português, vindo de um mapa único em `src/lib/copy.ts`."
- Código: "Todo campo de formulário tem rótulo visível; placeholder é só exemplo; mensagens de validação do zod estão em português no formato '{campo} {exigência}'."
- Código: "Os nomes e verbos do glossário são os mesmos em todas as telas; nenhuma string visível tem Title Case, travessão ou meia-risca (caixa alta por CSS `uppercase` de uma skill de estilo é permitida)."

## A construção: escrever e checar

**Onde os textos moram.** Crie `src/lib/copy.ts` com o glossário (nomes de entidade no singular e plural, verbos de ação) e uma função `errorText(e: unknown): string` que devolve o texto da tabela acima a partir de `e instanceof ApiError ? e.status : undefined` (`ApiError` vem de `@/lib/fab-client`). Telas usam essas constantes para que a mesma coisa se chame igual em todo lugar. Toast pelo `toast` do `sonner`, confirmação pelo `AlertDialog` ou `ConfirmDialog` de `@/components/ui/alert-dialog` (`title`, `description`, `confirmText` com o verbo repetido, `cancelText`, `destructive`, `onConfirm`), tela vazia pelo `EmptyState` de `@/components/ui/empty-state` (`title`, `description`, `action`, `icon`), campos com `Field` de `@/components/ui/field` e rótulo visível. Nunca `window.alert/confirm/prompt`.

**Fatos que a frase precisa.** Quase todo fato de interface o app sabe, porque foi ele que definiu o schema: o que um "cliente" carrega (agendamentos, pagamentos), quanto (conte com `collection('appointment').count({ customer: id })` antes de abrir a confirmação; `count` recebe o filtro direto e não traz linhas) e se a exclusão volta (`remove` é exclusão lógica; só diga "dá para desfazer" se o app tiver a tela de restaurar). Escreva com o dado real: "Excluir o cliente 'Maria Souza'? Os 12 atendimentos dela também saem da lista. Não dá para desfazer." Regra do negócio que só o dono sabe (prazo de cancelamento, reembolso, taxa de entrega) não vira número chutado: a frase fica verdadeira sem ela ("Veja a política de cancelamento com a clínica") e a pergunta vai para a mensagem final ao dono, uma por lacuna, dizendo em que tela ela aparece.

**Formulários.** Rótulo acima do campo, curto; placeholder só com exemplo de formato; ajuda para campo sensível ("Por que pedimos o CPF? Para emitir o recibo."); campos na ordem em que a pessoa costuma responder; opcional marcado como opcional; erro do zod junto do campo, no formato "{campo} {exigência}" ("A data precisa ser depois de hoje"); ao enviar, foco no primeiro erro.

**Notificações e e-mails automáticos.** Título começa pela mudança ("Seu pedido saiu para entrega"), corpo com o dado que importa (`{{campo}}` na automação `notify` de `fab.automations.json`, editado depois de `fabapp pull` e enviado com `fabapp push`; `link` é um caminho dentro do app, como `/orders/{{id}}`), e só se houver ação ou necessidade. E-mail enviado pelo código do app: `notify('email', { to, subject, message, link })`, `message` em texto puro até 1000 caracteres, sem URL no corpo (o servidor recusa com 422), link no campo `link` apontando para uma página deste app. Texto gerado pela IA do app (`invokeLLM({ prompt, system, schema?, tier: 'fast' })` devolve `{ text, data }`): o `system` leva o quadro de voz, o tratamento "você" e as regras 1 a 8 desta skill. Mensagem de WhatsApp pronta no tom do quadro de voz, sem "Olá!" com exclamação e sem emoji decorativo.

**Acessibilidade.** Botão e link fazem sentido fora do contexto (leitor de tela lista só os links); ícone sem texto recebe `aria-label` ("Fechar", "Buscar"); erro não depende só da cor (texto + ícone); nada de "o botão verde" ou "abaixo". Detalhes e metas em `references/acessibilidade-e-checklist.md`.

## Conferir antes de dizer pronto

**Checagem de cada linha (portão, não sugestão).** Leia cada linha nova contra estas oito perguntas. Um único "sim" manda a linha de volta para reescrever:
1. Abre com preâmbulo ("Aqui está seu...", "Isso vai...") em vez da mensagem?
2. Tem "não é só X, é Y" ou parecido?
3. Tem travessão ou meia-risca?
4. Tem adjetivo de propaganda ("fácil", "rápido", "intuitivo", "sem complicação") no lugar do fato?
5. Tem Title Case na string de botão, rótulo ou título? (`uppercase` por CSS de uma skill de estilo não conta.)
6. Tem enchimento ("para que você possa", "a fim de", "serve para", "realizar o")?
7. Tem fecho genérico ("Aproveite!", "Tudo certo!") ou exclamação sem informação?
8. Tem número, prazo, garantia ou capacidade que o app ou o dono não confirmou?

Depois, varra `src/` por busca no código: "com sucesso", "Ops", "OK\b" em botão, `!` em toasts, os caracteres U+2014 e U+2013 (travessão e meia-risca), e também `window.alert`, `window.confirm` e `prompt(`. Com `fabapp dev` rodando, percorra cada item da lista de conferência na pré-visualização: uma lista vazia de cada tipo, uma exclusão com a contagem real, um formulário enviado com erro e com sucesso, e uma falha simulada (sem internet) para ver o texto de conexão. Depois `fabapp push` (automações) e `fabapp deploy`; trate `build_failed` (422) consertando e `account_builds_busy` (409) esperando e repetindo. Na mensagem final ao dono, relate em português simples só o que conferiu, o link, e liste as lacunas de regra do negócio.

## Mudanças depois: limpar texto que já existe

Quando o dono aponta um texto ("esse erro não diz nada", "parece robô") ou pede para revisar as telas:

1. **Descubra o elemento.** Se o dono disse, use. Se não, deduza pela forma e pelo lugar no código (onde a string é usada decide: é `toast`, `Button`, `AlertDialog`, `EmptyState`, `title` de tooltip?). O código quase sempre resolve a dúvida que numa conversa seria pergunta. Se ainda assim a mesma frase passar numa regra e falhar em outra (ex. "Salvar alterações" como botão está certo, como dica do próprio botão está errado), pergunte qual é antes de mudar.
2. **Duas checagens, não uma.** (a) A tabela de 13 tiques de `references/acessibilidade-e-checklist.md` (o que tirar). (b) A regra do elemento na tabela acima (o que falta). "Nenhum resultado." passa na tabela e falha na regra do estado vazio; "Enviar" passa na tabela e falha na regra do botão. Um tique encontrado ou uma regra falhada: reescreva.
3. **Guarde os fatos.** Todo número, nome e regra do texto original fica exatamente igual. Mudar o tom e trocar um fato é um defeito pior que o tom.
4. **Nada a corrigir?** Diga que o texto está bom e não mude. Não invente mudança para parecer útil.
5. **Varra o fluxo inteiro** quando o pedido for "revisar as telas": inventário de termos (onde "agendamento" virou "reserva"), cada botão, cada erro, escaneabilidade, acessibilidade, tom por momento. Apresente o que mudou por tela na mensagem final.
6. **Texto regulado** (termos de uso, consentimento LGPD, aviso de saúde, contrato, preço com condição legal): não reescreva o sentido. Corrija só maiúsculas e pontuação se pedido, e sugira a versão simples ao dono como sugestão para ele aprovar com quem cuida disso. Opt-in e consentimento: opções neutras e paralelas, nada pré-marcado, recusar tão fácil quanto aceitar.
7. Anote o quadro de voz e o glossário em `DECISOES.md` (em **Preferências**) se ainda não estiverem lá.
