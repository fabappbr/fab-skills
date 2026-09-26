---
name: formularios-e-onboarding
description: "Formulários longos que as pessoas terminam e apps que nunca abrem vazios, em apps da Fabapp AI construídos ou editados pelo terminal (CLI @fabappai/cli): cadastro em etapas com nome, progresso honesto, validação por etapa, voltar sem perder nada, rascunho salvo, revisão antes de enviar, campos condicionais (pessoa física ou jurídica, CPF, CNPJ, CEP); e primeiros passos do app com checklist, dados de exemplo que se apagam num clique, estados vazios que ensinam e medição de onde as pessoas desistem. Use quando o dono pedir cadastro completo, ficha, anamnese, matrícula, inscrição, orçamento detalhado, proposta, pedido de crédito, formulário grande, passo a passo, assistente de configuração, 'as pessoas desistem no meio do cadastro', 'o formulário é muito grande', 'quero que o funcionário saiba por onde começar', 'o app abre vazio', 'tutorial', 'boas-vindas', 'primeiro acesso'. Use também ao criar ou mudar qualquer formulário com mais de 6 campos e a tela inicial de um app de gestão."
license: "Ver README.md (MIT e Apache-2.0 das fontes; texto próprio da Fabapp AI)"
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Formulários e Onboarding
  edition: terminal
---

# Formulários em etapas e primeiros passos

Duas coisas fazem uma pessoa desistir de um app: um formulário que parece não ter fim e uma primeira tela vazia sem saber o que fazer. Esta skill decide quando dividir um formulário, como cada etapa se sustenta, como salvar e retomar, e como o app leva cada pessoa ao primeiro resultado real. Leia `references/formularios-em-etapas.md` e `references/primeiros-passos.md` antes do plano e aplique-as.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## Antes de começar: decisões fixas

1. **Página única ou etapas.** Até 6 campos, formulário rápido (contato, pedido simples) ou público com pressa: página única. Mais de 8 a 10 campos que se agrupam naturalmente em 3 a 5 blocos: etapas. Sem agrupamento natural, não divida: corte campos. Alternativa híbrida: 3 a 5 campos para começar e um complemento opcional depois de enviar.
2. **Cada etapa é uma unidade de trabalho** que a pessoa descreve numa frase ("contei sobre minha empresa"), com 3 a 7 campos e um nome que diz o que é ("Sobre você", "Endereço de entrega", "Revisão"), nunca "Etapa 1". Etapa de 1 ou 2 campos é teatro de progresso; de 10 ou mais recria o formulário gigante.
3. **Ordem da menor para a maior exigência.** Identificação primeiro, contexto, necessidade, detalhes difíceis ou sensíveis (valores, documentos) por último, e uma etapa final de **revisão** com "Editar" em cada bloco.
4. **Progresso honesto.** `Stepper` com os nomes e, acima dele, o texto "Etapa 2 de 4: Endereço" (o `Stepper` esconde os nomes no celular). O total não muda no meio do caminho: se uma resposta tira ou põe etapa, o total já nasce do caminho da pessoa, ou diga "4 a 5 etapas" desde o início. Nada de "Quase lá" com metade pela frente.
5. **Validação por etapa com `zod`.** Ao sair do campo; ao clicar "Continuar", valida só os campos da etapa e leva o foco ao primeiro erro; ao enviar, valida tudo (regras entre campos inclusive). Mensagem ao lado do campo, específica e sem culpa.
6. **Nada se perde.** "Voltar" mantém tudo o que foi digitado; erro do servidor não limpa o formulário; recarregar a página ou voltar amanhã retoma de onde parou (rascunho).
7. **Brasil por padrão.** Rótulo acima do campo; pessoa física mostra CPF, pessoa jurídica mostra CNPJ, razão social e inscrição estadual; CPF, CNPJ, CEP, telefone e dinheiro com máscara na tela e valor limpo no banco, `PhoneInput` e `CurrencyInput` (se a skill `padroes-brasil` estiver instalada, ela manda nos detalhes); teclado numérico nos campos numéricos; nomes com acento e apóstrofo, e-mail com "+" aceitos.
8. **O app nunca abre vazio.** A tela inicial de quem administra tem "Primeiros passos" (4 a 6 itens com progresso, calculados dos dados reais), cada lista vazia diz o que fazer, e dados de exemplo aparecem marcados como exemplo, apagáveis num clique.
9. **Pular nunca deixa o app vazio.** Toda etapa de configuração pode ficar para depois, e o que foi pulado vira item do checklist com caminho de volta.
10. **Medir.** Cada etapa de formulário longo e cada passo de onboarding dispara `trackEvent`; formulários de quem está logado guardam `last_step` no rascunho, para contar onde as pessoas param.

## O plano

O plano é um texto que você escreve e mostra ao dono antes de codar; o dono aprova antes da construção.

**Formulários.** Para cada formulário com mais de 6 campos, uma tabela no plano:

| Formulário | Formato | Etapas (nome: campos) | Condicionais | Rascunho | Depois de enviar |
|---|---|---|---|---|---|
| Cadastro de cliente | etapas | Quem é: tipo, nome, CPF/CNPJ · Contato: WhatsApp, e-mail · Endereço: CEP, rua... · Revisão | PJ mostra razão social e IE | sim (logado) | abre a ficha do cliente |

Justifique o formato pelas regras 1 e 2 (contagem e agrupamento). Aplique o teste da frase em cada etapa. Liste cada campo e por que ele é necessário: campo que não muda o resultado sai.

**Onboarding.** Escreva:
- **Quem abre o app primeiro** e o que já existe para essa pessoa (admin configurando, funcionário convidado, cliente final).
- **O momento "entendi"** de cada tipo de pessoa (no máximo 2 ou 3 tipos): uma ação dela que produz um resultado visível e real no primeiro uso, não uma explicação. Ex.: salão, "cadastrou um serviço e viu o primeiro horário marcado na agenda"; oficina, "abriu a primeira OS e gerou o orçamento para o cliente"; loja, "cadastrou um produto e viu a vitrine".
- **Assistente ou só checklist.** Assistente de boas-vindas só quando há configuração real antes do valor (serviços e horários, dados da empresa, convite da equipe) e o momento "entendi" pede ações em sequência; senão, checklist e estados vazios bastam. Aplique os critérios de `references/primeiros-passos.md`.
- **Itens do checklist** (4 a 6) em ordem de valor, cada um com a condição que o marca como feito (ex.: "Cadastrar seu primeiro serviço: `count(service) > 0`").
- **Dados de exemplo**: quais modelos recebem exemplos marcados (`is_sample`) e como se apagam; nunca em modelo de leitura pública (depoimento, avaliação, vitrine).
- **Eventos medidos** e a definição de ativação (ex.: "criou o primeiro pedido em até 7 dias").

**Lista de conferência**, com todos os itens que o app usa ("(código)" quando se confere no código, "(tela)" na pré-visualização):
- "O formulário [X] tem as etapas [nomes], mostra 'Etapa N de T: nome' e o total não muda durante o preenchimento" (código)
- "'Continuar' valida só os campos da etapa atual; 'Voltar' preserva os valores; erro do servidor não apaga nada" (código)
- "Tipo Pessoa física mostra CPF; Pessoa jurídica mostra CNPJ, razão social e IE; CPF e CNPJ conferem o dígito verificador" (código)
- "Fechar no meio e abrir de novo mostra 'Continuar de onde parou' na etapa em que estava" (código)
- "A última etapa é uma revisão com 'Editar' em cada bloco e o botão diz a ação ('Enviar pedido de orçamento')" (tela)
- "A tela inicial do admin mostra 'Primeiros passos' com [itens], progresso 'N de M' e cada item leva à ação; itens feitos já aparecem marcados" (código)
- "Registros de exemplo aparecem com o selo 'Exemplo' e 'Apagar exemplos' os remove depois de confirmar" (código)
- "Nenhuma lista principal abre vazia sem uma ação para começar" (tela)

Nas suposições do plano, registre o formato escolhido para cada formulário e o momento "entendi" definido, com a alternativa.

## A construção: formulário em etapas

O schema vem antes do código: `fabapp pull`, edite `fab.schema.json` (status com `draft`, `last_step`, `is_sample`, os campos de `appUser.fields`) e `fabapp push`.

Siga a receita de `references/formularios-em-etapas.md`. O essencial:

- **Um estado só para o formulário inteiro** (`react-hook-form` com `zodResolver` de `@hookform/resolvers/zod`, os dois instalados com `npm install react-hook-form @hookform/resolvers` dentro de `.fabapp/workspace` e enviados pelo `fabapp deploy`, ou `useState` com um objeto), um schema `zod` por etapa e o schema completo como a junção deles. As etapas são uma lista `[{ id, title, fields, schema, when? }]`; `when(values)` decide etapas condicionais, e o total exibido vem da lista já filtrada.
- **Continuar**: `trigger(stepFields)` (ou `schema.safeParse` da etapa); se falhar, foco no primeiro campo com erro; se passar, avança, rola ao topo e leva o foco ao título da etapa. A etapa atual fica na URL (`?etapa=2`) para o voltar do navegador voltar uma etapa.
- **Campos**: `Field` com `label` acima, `hint` com exemplo de formato, `error` da validação; `FieldGroup` em volta; uma coluna (pares curtos como Cidade e UF lado a lado a partir de `md`). `PhoneInput` com Brasil padrão, `CurrencyInput` em BRL, `DatePicker` para data, `AddressInput` quando houver endereço com mapa, `RadioCard` para escolhas de 2 a 4 opções com descrição, `Select` acima disso. Atributos `autoComplete` (`name`, `email`, `tel`, `postal-code`, `address-line1`, `address-level2`, `address-level1`, `organization`) e `inputMode="numeric"` em CPF, CNPJ e CEP.
- **Máscaras e validadores brasileiros** (CPF, CNPJ, CEP com busca no ViaCEP que preenche o endereço e deixa editar se falhar, telefone) ficam em `src/lib/br.ts` (se a skill `padroes-brasil` estiver instalada, siga a receita dela); `AddressInput` quando o dono liga o Google Maps.
- **Condicional**: pessoa física ou jurídica muda os campos na hora, sem pular layout brusco; campo escondido não é validado nem enviado.
- **Rascunho**: logado, o registro nasce com `status: "draft"` e `last_step` (`number`) ao concluir a primeira etapa e é atualizado a cada "Continuar". Por isso o enum de status ganha a opção `{value:"draft",label:"Rascunho"}`, as listas escondem rascunhos por padrão e os campos das etapas seguintes não levam `required: true` no schema (o rascunho nasce incompleto): a obrigatoriedade fica no `zod` de cada etapa e no envio final; visitante, `localStorage` por 7 dias (sempre dentro de `try/catch`), sem guardar documento nem dado de saúde, com o aviso "Suas respostas ficam salvas só neste aparelho por 7 dias". Ao voltar: "Continuar de onde parou (Etapa 3: Endereço)" ou "Começar de novo".
- **Revisão**: `DescriptionList` por etapa com "Editar" que abre a etapa e volta direto para a revisão.
- **Enviar**: `LoadingButton` com verbo e objeto; 422 do servidor volta para a etapa do campo com a mensagem ao lado; sucesso abre uma tela que diz o que acontece agora e quando ("Recebemos seu pedido. Respondemos pelo WhatsApp em até 1 dia útil."). Nenhum popup, chat ou oferta aparece durante o preenchimento.
- **Medir**: `trackEvent("form_step_view", { form, step })`, `form_step_done`, `form_submit`, `form_resume`.

## A construção: primeiros passos

Siga `references/primeiros-passos.md`. O essencial:

- **Schema**: declare em `appUser.fields` o que o onboarding lembra por pessoa (`onboarding_hidden` boolean, `onboarding_step` number, `onboarding_done_at` datetime) e grave com `updateProfile`; os modelos principais ganham `is_sample` (boolean). Nada em `localStorage` para quem está logado: vale em qualquer aparelho.
- **Checklist na home do admin** (componente `FirstSteps`): 4 a 6 itens, cada um com título de ação, uma linha de por quê e o botão que leva à ação; estado calculado ao abrir com `count()` nos dados reais (itens já feitos aparecem marcados, inclusive "Criar sua conta"); barra `Progress` com "2 de 5"; "Ocultar" guarda `onboarding_hidden: true` em `appUser.fields` via `updateProfile` e o checklist continua acessível no menu da conta ("Primeiros passos"). Ao completar tudo, o toast "Primeiros passos concluídos." (no passado, sem exclamação) e o checklist sai sozinho. Comemoração só por conquista real, em texto.
- **Assistente de boas-vindas** (só se o plano decidiu): 3 a 5 etapas até o momento "entendi" (boas-vindas curta, configuração essencial, primeira ação real, convite da equipe adiável, pronto e próximo passo), com "Fazer depois" como link secundário ao lado do "Continuar" principal. Etapa pulada vira item do checklist. A etapa atual fica em `appUser.fields.onboarding_step` e o próximo login volta nela. Primeiro acesso de funcionário convidado recebe uma versão curta (o que ele faz no dia a dia), não a configuração do admin.
- **Estado vazio que ensina**: em cada lista principal, `EmptyState` com para que serve a área, a ação de criar o primeiro e, quando houver, "Importar planilha" (`CsvImport`).
- **Dados de exemplo**: os modelos principais têm `is_sample` (boolean), nunca um modelo de leitura pública (depoimento, avaliação, vitrine: exemplo ali é fato falso para o visitante). Você não grava registros pelo CLI. Escreva os exemplos em `src/lib/exemplos.ts`, realistas e do ramo (nomes brasileiros variados, valores plausíveis, um texto longo), e dê ao admin um botão "Carregar exemplos" no checklist ou no estado vazio, que os grava com `bulkCreate` marcando `is_sample: true` (confira antes com `count({ is_sample: true })` para não duplicar). Quem clica é o dono; ele também pode cadastrar ou importar no CMS do Studio. Registros de exemplo mostram o selo `Badge` "Exemplo"; enquanto existirem, um `Alert` discreto diz "Você está vendo dados de exemplo" com "Apagar exemplos" (`ConfirmDialog`, depois `deleteMany({ is_sample: true })` em cada modelo, repetido enquanto `count({ is_sample: true })` for maior que zero, porque cada chamada apaga até 200). Nunca diga ao dono que criou dados: você deixou o botão pronto.
- **Pedido de permissão de push** só depois do momento "entendi", no contexto ("Quer ser avisado quando um cliente agendar?"), com `EnablePushButton`.
- **Medir**: `trackEvent("onboarding_step_view" | "onboarding_step_done" | "onboarding_skip" | "onboarding_complete", { step })` e `trackEvent("activation", { action })` no momento "entendi". Esses eventos chegam às ferramentas de análise que o dono ligar no Studio.

## Mudanças depois

Comece lendo `DECISOES.md` e o `fab.schema.json` atual (`fabapp pull`).

- **"As pessoas desistem"**: diagnostique pelo ponto de parada, com a tabela de `references/formularios-em-etapas.md`. Parada no primeiro campo: valor pouco claro ou formulário que parece longo. No meio: etapa pesada, pergunta sensível, falta de progresso. No envio: botão vago, medo do que acontece depois, erro surpresa. Com rascunhos, conte `count({ status: "draft", last_step: n })` para achar a etapa.
- **Campo novo** entra na etapa cujo assunto ele compartilha; se a etapa passar de 7 campos, divida pelo assunto. Se o formulário cair para 6 campos ou menos, volte para página única.
- **Nova condição**: só se remove atrito real; mantenha o progresso honesto; mais de 5 regras condicionais num formulário é sinal de que são dois formulários.
- **Onboarding**: item novo no checklist só se leva ao momento "entendi"; funcionalidade nova não vira passo de tutorial, vira dica no próprio lugar.
- Anote em `DECISOES.md` (Decisões) o formato de cada formulário, o momento "entendi" e os itens do checklist, para as próximas sessões manterem.

## Conferir antes de dizer pronto

Com o `fabapp dev` rodando, percorra na pré-visualização cada item da lista de conferência do plano, no celular (320 px) e no desktop, e relate na mensagem final só o que conferiu. Preencha cada formulário de ponta a ponta com dados de teste (pessoa física e jurídica), feche no meio e reabra, provoque um erro do servidor, e apague os registros de teste no fim. Publique com `fabapp push` e `fabapp deploy` e leia a saída inteira (`build_failed` 422: conserte antes de repetir; `account_builds_busy` 409: espere).

Formulários: etapas coerentes (teste da frase); 3 a 7 campos por etapa; progresso honesto que não muda; condicionais só com ganho real; rascunho que retoma na etapa certa com os valores; validação por etapa e completa no envio; eventos por etapa; funciona a 320 px com teclado numérico onde deve; cada campo justificado; botão final claro e o que acontece depois dito; nenhum valor perdido em voltar ou em erro.

Primeiros passos: nenhuma lista principal vazia sem ação; checklist com dados reais e progresso; exemplos marcados e apagáveis; pular não esvazia o app; momento "entendi" alcançável no primeiro uso; eventos disparando; nenhum tutorial de funcionalidades no lugar de uma ação real.
