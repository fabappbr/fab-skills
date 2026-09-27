---
name: fab-corrigir-bug
description: "Para editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli): conserta o que está quebrado achando a causa antes de mexer no código, uma hipótese por vez, reproduzindo na pré-visualização do fabapp dev, e explica ao dono em português simples o que acontecia e o que mudou. Use SEMPRE que o dono relatar defeito: 'o botão não funciona', 'não salva', 'clico e nada acontece', 'a lista está vazia', 'sumiram os dados', 'deu erro', 'apareceu uma mensagem vermelha', 'sem permissão', 'a tela ficou branca', 'não carrega', 'fica rodando', 'o login não entra', 'a data está errada', 'o valor está errado', 'o e-mail não chega', 'a notificação não chega', 'o pagamento não confirma', 'funcionava e parou', 'quebrou depois da última mudança', 'o deploy falhou'. Use com mais força quando o dono disser 'de novo', 'continua igual', 'você disse que tinha arrumado', 'já é a terceira vez' ou 'para de chutar', e quando aparecer erro no console. Na dúvida entre reescrever a tela e investigar, use esta skill."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Corrigir Bug
  edition: terminal
---

# Corrigir Bug

Conserta defeito relatado pelo dono achando a causa antes de mexer no código, e explica em português simples.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
`references/fabapp-cli.md` (Node, `status`, login, `create` ou `link`, `pull`, `dev`, contrato ao vivo) e só então
comece. Leia `DECISOES.md` na raiz do projeto, se existir: ele diz o que já foi tentado.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) discordarem
sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você conserta pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio. Se ele já
pediu, o seu workspace está velho: publique o que é seu e rode `fabapp dev --reset` antes de investigar, ou você vai
investigar um código que não é o que está no ar.

## A lei de ferro

**Nenhum conserto sem achar a causa primeiro.**

Se você ainda não sabe POR QUE o defeito acontece, não pode propor conserto. Reescrever a tela inteira, trocar o
componente ou "melhorar" o código até o sintoma sumir é tratar o sintoma: o defeito volta, ou aparece em outro lugar, e
o dono paga mais uma rodada. Pular o processo "porque é simples" viola o processo: defeito simples também tem causa, e
para ele o processo é rápido.

Use o processo principalmente quando: o dono tem pressa, o conserto "óbvio" parece evidente, já houve outra tentativa,
a tentativa anterior não resolveu, ou você não entende bem o problema.

## Antes de começar: o código que você lê é o que está no ar?

O defeito que o dono vê está no app publicado. O que você lê está em `.fabapp/workspace`. Confira que os dois são o
mesmo antes da Fase 1:

- O último `fabapp deploy` terminou em `✓ Live: <url>`? Com o MCP ligado, `fabapp_app_status` mostra o último deploy.
  Um deploy que deu `build_failed` deixou no ar a versão anterior.
- O dono mexeu no app pela IA do Studio ou trocou imagens no Studio depois do seu último deploy? Então o servidor tem
  código que o workspace não tem: publique o que é seu e rode `fabapp dev --reset`.
- `fabapp pull` traz a definição atual (schema, automações, tema), que o dono pode ter mudado no Studio.

## As 4 fases

Cumpra cada fase antes da próxima.

### Fase 1: investigar a causa

1. **Leia a mensagem de erro inteira.** A mensagem do toast que o dono citou, o console do navegador (na
   pré-visualização local ou no app no ar), o texto do `ApiError`, a saída do `fabapp deploy` (`build_failed` traz
   arquivo, linha e coluna), a saída do `fabapp push` (400 ou 422 com o caminho). Anote o código (401, 402, 403, 404,
   409, 422, 429), o arquivo, a linha, o campo citado. Muitas vezes a solução está escrita ali.
2. **Reproduza.** Pelo terminal você pode reproduzir de verdade: com `fabapp dev` rodando, abra a tela na
   pré-visualização com a ferramenta de navegador que a sua ferramenta tiver, entre com o mesmo papel da pessoa que
   viu o defeito e faça o mesmo clique, com o console aberto. Sem navegador, siga o caminho que o clique percorre no
   código: rota em `src/routes.tsx` → página → componente → handler → chamada ao SDK → modelo em `fab.schema.json` →
   regra `access`. Abra cada arquivo. Qual é o passo exato em que o comportamento diverge do esperado? Se não dá para
   dizer, a investigação não acabou: junte mais evidência (item 4), não chute.
3. **O que mudou por último?** A última mudança pedida pelo dono é a primeira suspeita de "funcionava e parou".
   Olhe `DECISOES.md`, a conversa e, se a pasta do projeto está no git, `git log` e `git diff`. Compare o que ela tocou
   (campo renomeado, modelo novo, regra de acesso mais fechada, rota trocada) com o que agora falha.
4. **Junte evidência em cada fronteira.** Um app Fabapp tem quatro fronteiras. Confira o que entra e o que sai de cada
   uma antes de decidir onde está o defeito:

| Fronteira | O que conferir | Como, no terminal |
|---|---|---|
| **Tela** | A rota existe? O botão tem `onClick` ou `type="submit"` dentro do `<form>` certo? O estado é atualizado depois do `await`? A lista recarrega depois de criar? O `catch` mostra o erro ou engole? | ler o arquivo; reproduzir na pré-visualização |
| **Chamada ao SDK** | O id do modelo em `collection('...')` é igual ao do schema? Os ids de campo no `create`/`update`/`filter` existem? O valor tem o tipo certo? O filtro usa o valor guardado (id do `ref`, `value` do `enum`, dígitos sem máscara)? | ler o arquivo + `fab.schema.json`; na pré-visualização, a aba de rede do navegador mostra a requisição e a resposta |
| **Regra de acesso** | O `access` do modelo deixa ESSA pessoa (papel, dono, visitante) ler/criar/alterar? O campo de dono existe e é preenchido? | `fab.schema.json` (ou `fabapp_read_definition`, que traz o `access`) |
| **Dados** | Os registros existem? Têm o dono, o status e o formato que a tela espera? | o CLI não lê registros: entre na pré-visualização como owner ou admin (que veem tudo) e olhe a tela, ou peça ao dono para abrir o registro no CMS do Studio e dizer o que está em cada campo |

   Quando as quatro fronteiras não mostram a falha (defeito só na mão do dono, intermitente), a evidência que falta vem
   do app: faça o erro aparecer. Troque o `catch` mudo por `toast.error(e.message)`, mostre o estado vazio com o
   motivo, publique, e peça ao dono: "Tente de novo e me conte a mensagem que aparecer." Esse é o registro na
   fronteira: sem ele, a próxima rodada chuta de novo.
5. **Rastreie para trás até a origem.** Onde nasce o valor errado? Quem chamou com ele? Suba até a fonte e conserte lá,
   não onde o erro aparece. Método completo em `references/rastrear-e-blindar.md`.

Antes de consertar, confira o sintoma na tabela de `references/armadilhas-da-plataforma.md`. As três mais comuns:

- **Lista vazia sem erro:** quase sempre é regra de acesso (a pessoa não é dona dos registros; os registros de exemplo
  são do administrador) ou filtro com valor diferente do guardado. Confirme que os registros existem (entrando como
  admin na pré-visualização, ou pelo dono no CMS): se existem, o problema não é "salvar".
- **422:** campo desconhecido (id no código que não existe no schema, muitas vezes renomeado), obrigatório faltando no
  envio, ou tipo errado (dinheiro como texto "12,50", data com hora num campo `date`, `enum` fora das opções, rótulo no
  lugar do id do `ref`). A mensagem diz o campo.
- **403 "e-mail não verificado" logo depois do cadastro:** o app está com a confirmação de e-mail no modo obrigatório,
  e a pessoa ainda não confirmou; até confirmar, o servidor recusa toda chamada dela aos dados. Não é conserto de
  permissão: o dado extra do cadastro vai no `profile` do `signup()` (gravado junto com a conta), o resto espera
  `user.email_verified`, e a tela mostra o aviso "Confirme seu e-mail" com o botão de reenviar
  (`resendVerification()`).

### Fase 2: comparar com o que funciona

1. **Ache um exemplo que funciona** no mesmo app: outra tela que salva, outra lista que carrega, outro modelo com regra
   parecida.
2. **Leia a referência inteira.** Se está seguindo um padrão (documentação da plataforma via `fabapp_docs` ou
   `llms-full.txt`, componente do kit em `src/components/ui/`), leia tudo, linha por linha. Entendimento parcial
   garante defeito novo.
3. **Liste todas as diferenças** entre o que funciona e o que falha, por menores que sejam. Não descarte nenhuma com
   "isso não pode importar".
4. **Entenda as dependências:** que papel a pessoa tem, que plano do dono libera o recurso, que integração precisa estar
   ligada no Studio (`fab.integrations.json` e `fab.connectors.json` dizem o que o dono conectou).

### Fase 3: uma hipótese por vez

1. **Escreva a hipótese:** "Acho que a causa é X porque Y." Específica. "Algo no formulário" não é hipótese.
2. **Teste com a menor mudança possível.** Uma variável por vez. Nada de consertar três coisas juntas.
3. **Confira antes de seguir**, na pré-visualização local, antes de gastar um deploy. Confirmou? Fase 4. Não
   confirmou? Nova hipótese, desfazendo a mudança anterior. Não empilhe consertos.
4. **Quando você não sabe:** diga que não sabe. Ao dono: "Ainda não achei a causa. Fiz a tela mostrar a mensagem do
   erro; tente de novo e me diga o que aparece." Fingir saber gera o próximo chute.

### Fase 4: consertar a causa

1. **Escreva o teste que falha, em forma de item de conferência.** O app não tem suíte de testes: o equivalente é uma
   checagem concreta que hoje FALHA e que o conserto faz PASSAR. Exemplo: "Hoje o `onSubmit` de NovoCliente não envia
   `phone`, que é obrigatório no schema (por isso o 422). Depois do conserto, o envio tem `phone` e o cliente aparece
   na lista." Diga qual mudança no código faria a checagem falhar de novo: se você não consegue dizer, a checagem não
   prova nada. Quando der, veja a checagem falhar na pré-visualização antes do conserto.
2. **Um conserto, na causa.** Sem "já que estou aqui", sem refatorar junto, sem trocar o visual.
3. **Proteja as camadas** que o valor ruim atravessou (validação `zod` no formulário, guarda no handler, regra de
   acesso certa, erro visível), para o defeito ficar impossível e não só consertado. Ver
   `references/rastrear-e-blindar.md`.
4. **Confira o conserto:**
   - a checagem do item 1 passa agora, na pré-visualização;
   - `npx tsc -b` e `npx vite build` passam em `.fabapp/workspace` depois da última alteração;
   - se mexeu em schema ou automação, `fabapp push` sem erro;
   - `fabapp deploy` termina em `✓ Live: <url>` (`build_failed`: leia arquivo, linha e coluna e conserte antes de
     repetir; `account_builds_busy`: espere e repita);
   - o sintoma ORIGINAL que o dono descreveu está resolvido no app no ar, pelo mesmo caminho que ele fez;
   - nada que dependia do trecho alterado quebrou (`grep` pelo nome alterado).
5. **Se não resolveu:** pare e conte as tentativas. Menos de 3: volte à Fase 1 com o que aprendeu. 3 ou mais: regra
   dos três.

## A regra dos três

Se este é o terceiro conserto do MESMO sintoma (veja a conversa e `DECISOES.md`), não faça o quarto. Três consertos que
falham mostram que a estrutura está errada, não que falta mais um ajuste. Sinais: cada conserto revela um problema novo
em outro lugar; o conserto exigiria mexer em muita coisa; cada mudança cria sintoma novo.

Então: pare de remendar e repense a base (o modelo de dados está certo? a regra de acesso reflete quem usa? a tela
deveria ser outra?). Explique ao dono em linguagem simples o que foi tentado, por que não resolveu e as 2 ou 3 saídas
possíveis, com a recomendada primeiro, com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code,
AskUserQuestion; sem ela, uma mensagem curta com as opções numeradas), marcando a recomendada com "(Recomendado)".
Registre as tentativas em `DECISOES.md`, na seção Decisões, para a próxima sessão não repetir o mesmo caminho.

## Sinais de que você está chutando

**Seus pensamentos:** "conserto rápido agora, investigo depois"; "vou só mudar X e ver"; "faço várias mudanças e
confiro"; "deve ser X, vou arrumar"; "não entendi direito, mas isso pode funcionar"; "o padrão diz X, mas vou adaptar";
lista de problemas sem ter investigado; propor solução antes de seguir o caminho dos dados; "mais uma tentativa"
depois de 2; "faço o deploy e vejo se passa".

**Frases do dono:** "de novo?", "continua igual", "você disse que tinha arrumado", "piorou", "agora quebrou outra
coisa", "não era isso", "para de chutar", "já é a terceira vez", "ficamos presos nisso?".

Qualquer um deles: pare e volte à Fase 1.

## Racionalizações e a realidade

| Desculpa | Realidade |
|---|---|
| "É simples, não precisa de processo" | Defeito simples tem causa. Para ele, o processo leva um minuto. |
| "O dono tem pressa, cliente dele esperando" | Investigar é mais rápido do que tentar e errar três vezes. |
| "Tento isso primeiro, depois investigo" | O primeiro conserto define o caminho. Comece certo. |
| "Reescrevo a tela inteira que resolve" | Reescrever esconde a causa, que volta. E apaga o que funcionava. |
| "Mudo várias coisas de uma vez, economiza rodada" | Não dá para saber o que resolveu, e cria defeito novo. |
| "Abro a permissão para todo mundo e resolve" | Proibido: abrir leitura e escrita a todos expõe os dados dos clientes do dono. Ache a regra certa. |
| "Ponho um atraso de 1 segundo antes de carregar" | Esperar tempo é chute. Espere a resposta (`await`) ou use `useLive`. |
| "O dono sugeriu o conserto, é só fazer" | O objetivo do dono vale; o conserto sugerido é uma hipótese. Confira antes. Se for inofensivo e ele insistir, faça e explique. |
| "Eu vejo o problema, vou consertar" | Ver o sintoma não é entender a causa. |
| "Mais uma tentativa" (depois de 2) | 3 falhas = estrutura errada. Repense e explique. |
| "O deploy falhou, repito que passa" | `build_failed` não muda sozinho e cada tentativa paga um build. Leia arquivo, linha e coluna. |
| "Não achei causa, deve ser a plataforma" | Em quase todo "não tem causa" a investigação ficou incompleta. |

## Quando a causa está fora do app

Se a investigação completa mostra que a causa é externa (gateway de pagamento não conectado, integração desligada no
Studio, recurso que o plano do dono não libera, limite diário de e-mail, site externo que o navegador bloqueia), você
terminou o processo: diga ao dono o que investigou, faça a tela tratar o caso com mensagem clara e opção de tentar de
novo, e diga o que ele precisa fazer e onde.

## A mensagem final ao dono

Português simples, frases curtas, sem código de erro nem termo técnico ("permissão", não "403"; "campos do cadastro",
não "schema"):

1. **O que acontecia:** "Quando você clicava em Salvar, o cadastro não era criado porque o celular não estava sendo
   enviado."
2. **Por quê:** a causa, em uma frase.
3. **O que mudei:** só o que mudou.
4. **Como conferir:** "Abra Clientes, clique em Novo cliente, preencha e salve. O cliente aparece no topo da lista." E
   o link do app no ar.
5. **O que depende de você**, se houver (ligar uma integração no Studio, cadastrar ou corrigir um dado no CMS do
   Studio).

Não diga "corrigido" sem ter conferido o sintoma original no app no ar, depois de `npx tsc -b`, `npx vite build` e
`fabapp deploy` limpos depois da última alteração. Se ainda não achou a causa, diga isso e o que fez para achar na
próxima. Anote em `DECISOES.md` a causa e o conserto quando forem uma regra que a próxima mudança não pode quebrar.
