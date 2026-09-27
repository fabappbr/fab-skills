---
name: fab-verificar-antes-de-entregar
description: "Para construir ou editar apps da Fabapp AI pelo terminal (CLI @fabappai/cli): o agente só diz que o app está pronto depois de conferir, e entrega tudo o que o plano prometeu, sem tela pela metade, botão que não faz nada, link morto ou texto de exemplo esquecido. Lista de conferência no plano, compilação local, busca no código pelas regras do QA, pré-visualização, deploy conferido e uma mensagem final que conta só o que foi verificado e o que depende do dono. Use em TODO app novo e em toda edição, principalmente quando o dono reclamar: 'disse que fez e não fez', 'falou que estava pronto', 'faltou a página', 'metade não funciona', 'tem link que não abre', 'apareceu lorem ipsum', 'sumiu o que eu pedi' (defeito que precisa de causa, como 'o botão não faz nada', fica com fab-corrigir-bug). Use também em pedidos grandes, quando o dono tiver pressa e quando uma edição mexer em login, acesso aos dados, formulário ou pagamento. Na dúvida, use."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Verificar Antes de Entregar
  edition: terminal
---

# Verificar Antes de Entregar

Faz você só dizer "pronto" sobre o que conferiu nesta sessão, e entregar completo o que o plano prometeu.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de
`references/fabapp-cli.md` (Node, `status`, login, `create` ou `link`, `pull`, `dev`, contrato ao vivo) e só então
comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) discordarem
sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio.

## A lei de ferro

**Nenhuma afirmação de pronto sem evidência conferida nesta rodada.**

Se você não conferiu agora, não pode dizer que funciona. Isso vale para a frase exata e para qualquer variação: "feito",
"pronto", "tudo certo", "corrigido", "já está funcionando", "agora salva", um "Perfeito!" antes de conferir, ou um
resumo que dá a entender que tudo foi entregue. Trocar as palavras para escapar da regra é violar a regra.

O dono da Fabapp é leigo: ele não abre o código. Quando você diz "pronto" e não está, ele descobre na frente do cliente
dele, perde uma rodada e perde a confiança. Por isso a mensagem final é tratada como um laudo, não como propaganda.

## Onde a verificação acontece no terminal

No Studio, a plataforma roda um QA depois de cada build. Pelo terminal, não: o `fabapp deploy` só confere o básico e
compila. **Quem confere é você**, com o que o terminal oferece. A cadeia é esta, e cada etapa tem a sua parte:

1. **O plano:** traz a lista de conferência, com itens que dá para conferir (seção "O plano" abaixo).
2. **A construção e as mudanças:** implementam cada item ao pé da letra e conferem com as ferramentas reais: as
   ferramentas de arquivo da sua ferramenta (reler o que foi escrito), `grep` no código, `npx tsc -b` e
   `npx vite build` dentro de `.fabapp/workspace`, a saída do `fabapp push`.
3. **A pré-visualização local:** `fabapp dev` sobe o app; você percorre cada rota e cada item da lista, com o console
   aberto, no celular e no desktop.
4. **O deploy e o ar:** `fabapp deploy`, a saída lida inteira, e requisições reais à URL publicada.
5. **A mensagem final:** relata só o que foi conferido, separa o que depende do dono e não esconde o que faltou.

O que você não tem, não finja ter. Se a sua ferramenta não abre navegador, diga isso ao dono e diga como aquela parte
foi conferida (por ele, ou não foi). Nunca escreva que "testou" algo que só leu.

## A função portão (antes de qualquer afirmação)

Antes de afirmar qualquer estado do app:

1. **IDENTIFICAR:** que evidência prova esta frase? (tabela abaixo)
2. **EXECUTAR:** obter a evidência agora, inteira: rodar `npx tsc -b`, abrir o arquivo, conferir a rota em
   `src/routes.tsx`, conferir o modelo em `fab.schema.json`, abrir a rota na pré-visualização.
3. **LER:** a saída inteira. Quantos erros? Em que arquivo? O arquivo tem o que você achava que tinha?
4. **CONFERIR:** a evidência confirma a frase?
   - Não: diga o estado real, com o que viu.
   - Sim: diga a frase junto com a evidência.
5. **SÓ ENTÃO** afirme.

Pular um passo é chutar, e chute apresentado como fato é mentira para o dono.

## Afirmação, o que exige, o que não basta

| Afirmação | Exige | Não basta |
|---|---|---|
| "O app compila" | `npx tsc -b` e `npx vite build` sem erro em `.fabapp/workspace`, rodados DEPOIS da última alteração, e o `fabapp deploy` terminando em `✓ Live: <url>` | compilação de antes da última edição; "os imports estão certos" |
| "A tela X existe" | rota em `src/routes.tsx` + arquivo da página escrito e com conteúdo real, aberto na pré-visualização | "está no plano"; arquivo com só o título |
| "Todas as telas do plano existem" | contagem: telas do plano = rotas = arquivos de página, conferida item a item | "fiz as principais" |
| "O login funciona" | páginas de login e cadastro fora da casca, usando o componente de autenticação do kit ou `useAuth`; rota privada manda para o login quem não entrou (conferido abrindo a rota sem sessão); `fab.settings.json → auth` conferido quando o plano muda o login | "o componente de login existe" |
| "A lista carrega" | a tela chama `collection('<id>').list({ filter, sort, limit })` com o id exato do schema, tem `Skeleton` enquanto carrega, estado de erro com `e.message` e estado vazio com uma ação; a regra `read` do modelo permite quem abre a tela; na pré-visualização, a lista abre sem erro no console | "aparece com dados de exemplo"; "o modelo existe" |
| "O usuário B não vê os dados do A" | `access` do modelo com `owner`, `{owner_field}` ou `{owner_via}` na leitura, e o campo de dono existe no modelo | "filtrei na tela pelo id do usuário" (filtro na tela não protege nada) |
| "O formulário salva" | o envio chama `create`/`update` com os ids de campo iguais aos do schema, todos os `required` preenchidos, tipos certos (`money` número, `date` aaaa-mm-dd), validação `zod`, botão com carregamento, toast de sucesso e tratamento de 422 e 403; na pré-visualização, um envio real cria o registro (depois apagado) | "o botão Salvar existe" |
| "O botão faz X" | o `onClick` chama a função que faz X, e ela existe no arquivo | botão com `onClick={() => {}}`, `console.log` ou `toast('Em breve')` |
| "Os dados de exemplo foram criados" | nunca é você quem cria: o token do CLI não grava registros. O dono cadastra ou importa no CMS do Studio, ou pela tela de administração do app; isso vai na lista do que ele faz | "criei", "importei", "cadastrei" |
| "Troquei as cores / a fonte" | `apps/<slug>/fab.config.json → theme` com a cor, a fonte (nome exato do Google Fonts) ou o raio, `fabapp push` sem erro e `fabapp deploy` depois (o tema só aparece no ar no próximo deploy); nenhum hex nem `font-family` no código | CSS editado à mão; `index.css` ou `fab-theme.css` alterados (são da plataforma) |
| "O app avisa por e-mail/WhatsApp/push" | `fab.automations.json` com gatilho válido e ação `notify` com canal existente, `fabapp push` sem 400, modelo e campos citados existindo no schema (modelo ou campo inexistente é aceito e nunca dispara); integração que depende do dono listada como pendência dele | "a automação está no plano" |
| "O pagamento funciona" | `useCheckout`/`useSubscribe` chamados, a tela lê o status gravado pela plataforma; "conectar o gateway no Studio" listado como pendência do dono | "o botão Pagar existe" |
| "O bug foi corrigido" | a causa encontrada e o sintoma original conferido: o item que descrevia a falha passa agora | "mudei o código"; "reescrevi o componente" |
| "O plano foi cumprido" | reler o plano, lista linha a linha, cada item com a sua evidência | "compilou" |
| "A outra parte já exporta X" | abrir o arquivo que exporta ou usar o nome exato do contrato do plano | supor o nome |
| "Está no ar" | a última linha do `fabapp deploy` com `✓ Live: <url>`, `fabapp_app_status` (se o MCP estiver ligado) e a URL respondendo 200 | "o deploy rodou" |

## Sinais de alerta: pare e confira

- Você escreveu ou pensou "deve funcionar", "provavelmente", "parece que", "acho que", "em tese", "deve estar ok".
- Você está comemorando antes de conferir: "Pronto!", "Perfeito!", "Tudo certo!", "Feito com sucesso".
- Você vai escrever a mensagem final sem ter conferido a lista do plano.
- Você confia no que outra parte "disse" que fez (o plano, um arquivo escrito por um subagente, a sessão anterior) sem ver.
- Conferência parcial: compilou, então "funciona".
- "Só desta vez", "é uma mudança pequena", "o dono tem pressa".
- Qualquer frase que dá a entender que está pronto sem ter passado pela função portão.

## Racionalizações e a realidade

| Desculpa | Realidade |
|---|---|
| "Agora deve funcionar" | Confira. "Deve" não é evidência. |
| "Tenho certeza" | Certeza não é evidência. |
| "Só desta vez" | Sem exceção. |
| "Compilou, então funciona" | Compilar não prova que a tela renderiza, que a lista traz dados nem que o acesso protege. |
| "A plataforma confere depois" | Pelo terminal, não confere: o `deploy` só compila. O que você não conferiu, ninguém confere, e o dono descobre. |
| "O dono tem pressa" | Entregar quebrado custa mais uma rodada. Conferir é mais rápido do que refazer. |
| "Conferir uma parte basta" | Parte conferida prova só aquela parte. Diga qual parte. |
| "Mudei as palavras, então a regra não vale" | Vale o espírito: nada que soe como pronto sem evidência. |
| "É só uma mudança de texto" | Mudança pequena também quebra import e rota. Um `npx tsc -b` resolve. |
| "O resto segue o mesmo padrão" | Então escreva o resto. Padrão descrito não é código. |
| "Faço o deploy e vejo se passa" | Cada `deploy` que falha paga um build inteiro. Compile local primeiro: erro local é de graça. |

## O plano: a lista de conferência

O plano é um texto que você mostra ao dono antes de codar, e ele aprova. Ele termina com a **lista de conferência**:
todos os itens que você vai conferir antes de dizer pronto, sem teto de quantidade. Item vago passa sem provar nada, e
o que não está na lista não é conferido.

**Como escrever um item conferível** (o método de "reconhecer antes de agir": dizer onde olhar, o que estará visível e
o que muda depois da ação):

- Nomeie a **rota** e o **elemento real**: "Em /clientes, o botão 'Novo cliente' abre um formulário com Nome, Celular
  e CPF."
- Diga o **estado depois da ação**, não o tempo: "Depois de salvar, o cliente novo aparece no topo da lista sem
  recarregar a página." Nunca "depois de 2 segundos".
- Uma coisa por item. Se tem "e" juntando duas funcionalidades, separe em dois itens.
- Cubra os pontos que mais quebram na mão do dono, nesta ordem: (1) cada tela principal existe na rota certa; (2) a
  lista principal vem do banco com estados de carregando, vazio e erro; (3) o formulário principal salva com
  validação; (4) quem pode ver o quê (regra de acesso do modelo com dado pessoal); (5) login e rota protegida, se o app
  tem login; (6) o fluxo que o dono pediu pelo nome (agendar, pagar, enviar orçamento); (7) efeito visual pedido pelo
  nome; (8) o texto e o formato brasileiro das telas.
- Marque cada item com **como** será conferido: **no código** (leitura do arquivo, `grep`, schema) ou **na tela**
  (pré-visualização, no celular em 375px e no desktop). "Na tela" só para o que só se vê na tela (a grade não quebra no
  celular, não sobra faixa vazia). O resto é "no código", e o que der para ver também na tela, veja.

Exemplos bons:
- "A rota /agenda lista os agendamentos do dia do banco, ordenados por horário, com Skeleton enquanto carrega e
  'Nenhum horário marcado hoje' + botão 'Agendar' quando vazio." (no código e na tela)
- "O modelo `booking` tem leitura `{owner_field: 'customer'}` para clientes e `role:staff` para a equipe." (no código)
- "O formulário de agendamento não deixa salvar sem serviço, data e horário, e mostra o erro abaixo do campo." (na tela)

Exemplos ruins (reescreva): "O app funciona bem", "A interface é moderna", "Os dados carregam rápido", "Tudo
responsivo".

No texto do plano, liste as telas numeradas. Esse número é a contagem que você confere no fim.

## A construção: completo, sem marcador, conferido

### Antes de escrever: conte os entregáveis

Releia o plano e anote a contagem: N telas, M modelos, K itens da lista de conferência, as automações e funções
prometidas. Essa contagem fica travada. No fim, confira a mesma contagem contra o que existe.

### Proibido no código entregue

- `href="#"`, `to="#"`, link para rota que não está em `src/routes.tsx`.
- Botão sem ação: `onClick={() => {}}`, `onClick` com só `console.log`, `toast('Em breve')` ou "funcionalidade em
  desenvolvimento" no lugar de uma função do plano.
- Comentários que substituem código: `// TODO`, `// ...`, `// resto igual`, `// resto do código`, `/* implementar */`,
  `// igual ao de cima`, `// adicionar mais conforme necessário`, `...` solto no lugar do que foi omitido.
- **Escrever o arquivo inteiro com trecho omitido.** A ferramenta que escreve o arquivo inteiro troca o arquivo todo:
  um "// resto igual" apaga o resto do arquivo de verdade. Para mudar parte de um arquivo, use a ferramenta de edição
  por trecho; para reescrever, escreva o arquivo inteiro.
- Lorem ipsum, "Texto aqui", "Nome do produto", "Lorem", "exemplo@exemplo.com" na tela.
- Lista escrita à mão no código onde o plano diz que vem do banco.
- `catch {}` vazio ou `catch (e) { console.error(e) }` sem mostrar nada à pessoa: todo erro de salvar ou carregar vira
  toast ou mensagem com `e.message`.
- Tela com só o título, ou esqueleto de componente no lugar da implementação.
- Fazer a primeira e a última tela e resumir as do meio.

Marcador para o dono preencher é permitido e desejado quando o dado é dele e não foi informado (telefone do negócio,
CNPJ, preço, depoimento): texto visível e claro, por exemplo `[Preencher: telefone da loja]`. Isso é honestidade, não
placeholder de código. Nunca invente o dado.

### Conferir enquanto constrói

- `npx tsc -b` dentro de `.fabapp/workspace` depois de ligar as rotas e as primeiras telas, e de novo depois do último
  arquivo. Aqui é de graça: rode quantas vezes precisar. Leia todos os erros e corrija todos antes de seguir.
  "Compilou" só vale para o estado em que foi rodado.
- Antes de importar algo de um arquivo que você não escreveu nesta sessão, abra o arquivo e use o nome exato que ele
  exporta. De `@/lib/fab-client`, não de `@/lib/fab-sdk` (fachada parcial: veja `references/fabapp-cli.md`).
- Antes da mensagem final, abra `src/routes.tsx` e confira: cada tela do plano tem rota, cada rota tem arquivo, cada
  link da navegação aponta para uma rota que existe.
- Para cada item da lista de conferência, ache no código a linha que o cumpre. Se não achar, implemente.

### Arquivos escritos em paralelo

Se você divide a construção entre subagentes ou escreve vários arquivos sem reler os outros:
- Use os nomes de modelo, campo, rota e componente exatamente como o plano e o schema definem. Não invente variação
  ("customer" num arquivo, "client" no outro).
- Importe só do que existe: o kit de `src/components/ui/` e as exportações de `@/lib/fab-client`. Nada de componente
  "que outro arquivo vai criar" sem estar no plano.
- Escreva cada arquivo completo. Não existe "continuo depois".
- O que um subagente diz que fez é afirmação dele: abra os arquivos e confira antes de repetir ao dono.

### Estados que a pré-visualização mostra

Você (e o dono) abre a tela, espera terminar de carregar e olha o que ficou. Para a tela mostrar a verdade:
- Enquanto carrega, `Skeleton`. O estado "vazio" só aparece DEPOIS que a carga terminou sem registros; mostrar "Nenhum
  item" antes de a resposta chegar engana quem confere e quem usa.
- Nenhum erro no console na abertura normal da tela: sem `console.error` de depuração, sem aviso de `key` faltando em
  lista.
- Espere pela condição, nunca por tempo: nada de `setTimeout` para "esperar os dados"; use o `await` da chamada ou
  `useLive`.
- Rotas com `:id` funcionam com um id real e mostram "não encontrado" com um botão de voltar quando o id não existe.

## Conferir antes de dizer pronto

Rode nesta ordem. Cada passo tem de terminar limpo antes do próximo.

### 1. Busca no código pelas regras do QA

O QA automático do Studio pega estas regras sozinho; o `fabapp deploy` não. Rode dentro de `.fabapp/workspace` e
revise CADA ocorrência (algumas são legítimas, e a regra diz qual):

```bash
cd .fabapp/workspace
# Cor fixa: hex e cor de paleta do Tailwind. index.css e fab-theme.css são da plataforma e ficam fora.
grep -rnE "#[0-9a-fA-F]{3,8}\b" src functions --include='*.ts' --include='*.tsx' --include='*.css' | grep -vE "src/(index|fab-theme)\.css"
grep -rnE "\b(bg|text|border|ring|fill|stroke|from|via|to)-(white|black|(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-[0-9]{2,3})\b" src --include='*.tsx'
#   (véu com opacidade, como bg-black/40 sobre foto, vale; o resto vira token: bg-background, text-foreground, text-primary-text...)
# Fonte fora do tema
grep -rnE "font-family|fontFamily|font-\[" src
# Diálogos do navegador (travam no iframe da pré-visualização)
grep -rnE "window\.(confirm|alert|prompt)|\balert\(|\bconfirm\(|\bprompt\(" src
# Animação que o Safari ignora
grep -rn "animation-timeline" src
# Imagem externa ou de banco de imagens
grep -rnE "<img[^>]*src=[\"'{]*https?://|unsplash|pexels|picsum|placehold" src
# Proibidos no app e nas funções
grep -rnE "await import\(|import\(['\"]node:|\beval\(|dangerouslySetInnerHTML|<script[^>]*src=|process\.env|child_process" src
grep -rnE "import\(|\beval\(|process\.env|child_process" functions   # nas funções, nenhum import() dinâmico
grep -rn "import\.meta\.env\." src | grep -v "VITE_"
grep -rnE "import \* as [A-Za-z_]+ from ['\"]@/lib/fab-" src
# Layout e datas
grep -rnE "overflow-x-auto|type=\"date\"|toISOString\(\)|w-\[[0-9]+px\]" src
# Marcadores, links mortos e botões vazios
grep -rnE "href=\"#\"|to=\"#\"|TODO|FIXME|// \.\.\.|resto igual|resto do código|[Ll]orem|Texto aqui|exemplo@exemplo|[Ee]m breve|em desenvolvimento" src
grep -rnE "onClick=\{\(\) => \{\}\}|catch \{[[:space:]]*\}|catch \([a-z]+\) \{[[:space:]]*\}|console\.(log|error)" src
# Espera por tempo e lista com setInterval
grep -rnE "setTimeout|setInterval" src
# Rota de API inventada (o app não tem servidor próprio)
grep -rn "\"/api/" src
# AppImage: uma por linha, nunca dentro de .map()
grep -rn "AppImage" src
```

Depois compare as rotas declaradas com os links usados:

```bash
grep -oE "path=\"[^\"]+\"" src/routes.tsx | sort -u
grep -rhoE "(to|href)=\"/[^\"]*\"" src | sort -u
```

Cada link precisa de uma rota. Cada tela do plano precisa de uma rota.

### 2. Manifestos que o deploy não confere

- `fab.functions.json`: JSON válido e uma entrada para cada arquivo de `functions/`. Entrada faltando ou JSON quebrado
  vira `"user"` em silêncio.
- `fab.agents.json`, se existir: JSON válido.

```bash
node -e 'const f=JSON.parse(require("fs").readFileSync("fab.functions.json","utf8")).functions;const s=require("fs").readdirSync("functions").map(n=>n.replace(/\.ts$/,""));console.log("sem entrada:",s.filter(n=>!f[n]));'
```

### 3. Compilação local

Dentro de `.fabapp/workspace`: `npx tsc -b` e `npx vite build`. Zero erro nos dois, depois da última alteração. Erro
local é de graça; no servidor, custa um build.

### 4. A pré-visualização

Com `fabapp dev` rodando, abra a URL que o Vite imprimiu, com a ferramenta de navegador que a sua ferramenta tiver
(Playwright, Chrome headless pelo protocolo DevTools, extensão de navegador).

- Percorra cada rota do plano (as `:param` com um id real e com um id que não existe), em 375px e no desktop, com o
  console aberto: zero erro, nenhuma rolagem lateral.
- Percorra cada item da lista de conferência marcado "na tela" e diga, item a item, o que viu.
- Formulários: envio vazio mostra os erros; envio válido cria o registro e mostra o sucesso. Apague o registro de teste
  depois.
- Rotas privadas: abra sem sessão e confira que vão para o login.
- Quando o acesso depende de papel, entre com uma conta de cada papel (o dono atribui papéis no Studio).

Sem navegador na sua ferramenta: `curl` na URL local só prova que o servidor responde (o app é SPA; o HTML não traz as
telas). Diga isso ao dono, peça que ele abra a URL e percorra os itens "na tela" com você, e relate como conferido por
ele o que ele conferiu.

### 5. Definição e deploy

1. `fabapp push` (schema, automações, tema, SEO) e leia a saída: avisos, "The platform added" (rode `fabapp pull`),
   400 ou 422 com o caminho exato.
2. `fabapp deploy` e leia a saída inteira: arquivos enviados, dependências (`+ pacote@versão`), avisos do que a
   plataforma ignora (se algo que você precisava está nessa lista, o app no ar não tem aquilo), e a última linha
   `✓ Live: <url>`.
   - `account_builds_busy` (409): a conta já tem 2 builds rodando. Não é erro: espere e repita.
   - `build_failed` (422): o código não compila; a mensagem traz arquivo, linha e coluna. **Não repita:** conserte,
     rode `npx tsc -b` e `npx vite build` de novo, e só então faça outro deploy. Cada tentativa paga um build inteiro
     e a resposta não muda.
   - Aviso de template: o `dev` pode diferir do ar. `fabapp dev --reset` realinha e APAGA as edições locais: faça
     deploy antes.

### 6. No ar

- `fabapp_app_status` (publicado, URL, último deploy), se o MCP estiver ligado.
- `curl -sSI <url>` responde 200; o head de cada rota estática tem título e descrição
  (`curl -s <url>/<rota> | grep -o "<title>[^<]*</title>"`).
- Na URL do ar, com navegador: imagens carregando, console limpo, e um registro de teste que aparece no CMS do Studio e
  cuja notificação chega (peça ao dono para confirmar o que só ele vê). Apague o teste.
- Cache velho pode mostrar a versão anterior: recarregue forçado ou confira uma frase que você sabe que mudou.

## Mudanças depois: conferir a mudança, não o app inteiro de memória

- Cada mudança pedida ganha 1 a 3 itens de conferência antes de você mexer. Cada um tem de estar no código e conferido
  quando você terminar.
- Antes de mudar um arquivo, leia o arquivo. Depois de mudar, confira que a mudança não quebrou o que dependia dele
  (imports, props, rotas): `grep` pelo nome alterado.
- Rode `npx tsc -b` depois da última alteração e abra na pré-visualização a tela tocada. Sem isso, não diga que "está
  funcionando".
- Se a mudança mexe em acesso aos dados, confira a regra `access` do modelo e o campo de dono. Se mexe em schema,
  confira que os formulários e listas usam os ids novos.
- Mudança pedida para "consertar" algo: o item de conferência descreve o sintoma que o dono viu, e o sintoma original é
  o que você confere no fim ("o botão Salvar da tela Clientes cria o registro"), não apenas "o código mudou".
- Mudança em dados (apagar exemplo, corrigir registro): você não grava registros pelo terminal. Diga ao dono o que
  apagar ou corrigir e onde (CMS do Studio, ou a tela de administração do app). Nunca "apaguei" ou "corrigi os dados".
- Se o dono usou a IA do Studio no mesmo app, publique o que é seu e rode `fabapp dev --reset` antes de mexer.

## A mensagem final: um laudo

Português simples, frases curtas, sem jargão, sem "com sucesso", sem exclamação:

1. **O que ficou pronto e foi conferido**, uma linha por item, dizendo como: "Tela de clientes com busca e cadastro
   (compilação conferida, aberta na pré-visualização no celular e no computador)." O que você só leu no código, diga
   que conferiu no código; não diga que testou.
2. **O link** do app no ar, da linha `✓ Live:`.
3. **O que depende de você**, com o caminho no Studio: "Conectar o Mercado Pago no Studio para o Pix funcionar."
   "Preencher o telefone da loja na página Contato." "Cadastrar os serviços na aba de dados do Studio."
4. **O que não foi feito ou não deu para conferir**, com o motivo, sem esconder. Se faltou algo do plano, diga qual. O
   que ficou para depois vai como próximos passos.

Nunca: "Seu app está 100% pronto", "Tudo funcionando perfeitamente", lista de adjetivos, promessa sobre o que não foi
conferido, ou dizer que criou dados.

Antes de escrever a mensagem final, refaça a contagem travada no início (telas, modelos, itens da lista, automações).
Se o número não bate, termine o que falta antes. Anote em `DECISOES.md` o que foi decidido e as pendências do dono no
Studio.
