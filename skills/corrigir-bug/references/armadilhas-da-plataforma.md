# Armadilhas da plataforma: sintoma, causa provável, como confirmar, conserto

Use a tabela para formar a PRIMEIRA hipótese, nunca para pular a confirmação. A coluna "Como confirmar" é obrigatória antes do conserto.

## Dados que não aparecem

| Sintoma | Causa provável | Como confirmar | Conserto na causa |
|---|---|---|---|
| Lista vazia, sem erro, para um usuário comum (para o dono aparece) | Leitura `owner`/`{owner_field}` e os registros são de outra pessoa (os de exemplo foram criados pelo administrador) | Entrando como admin na pré-visualização (ou pelo dono no CMS do Studio) os registros aparecem; `fab.schema.json` mostra `read` por dono | Decidir com o dono quem deve ver: regra por papel (`role:staff`), `{owner_via}` pela empresa/cliente, ou `authenticated` para dado que todos da equipe veem. Nunca `public` em dado pessoal |
| Lista vazia para todos, inclusive o dono | Filtro com valor diferente do guardado: rótulo do `enum` no lugar do `value`, nome no lugar do id do `ref`, CPF com máscara contra dígitos, data com hora contra `date` | Ler o `filter` no código e comparar com um registro real (aba de rede da pré-visualização, tela do admin ou o dono no CMS) | Filtrar pelo valor guardado (id, `value`, dígitos, aaaa-mm-dd) |
| Lista vazia, e o id do modelo no código difere do schema (`clients` x `client`) | Modelo inexistente | Comparar `collection('...')` com os ids do schema | Usar o id exato do schema |
| "Salvei e não aparece" (aparece ao recarregar) | A lista não recarrega depois do `create` | Ler o handler: não há novo `list()` nem inserção no estado | Inserir o registro devolvido pelo `create` no estado, ou recarregar, ou usar `useLive` |
| Aparece para o dono, some para o cliente logado no app | Mesma causa da primeira linha, vista do outro lado: dono e admin são superusuários e veem tudo | Perguntar-se "com que papel a pessoa entra?" e ler o `access` | Idem primeira linha |
| Registro criado mas sem dono (ninguém consegue alterar) | Regra `{owner_field: 'campo'}` com campo que a tela não preenche, ou caminho com ponto (`a.b`), que não casa ninguém | `fab.schema.json` + o registro visto pelo admin na pré-visualização ou pelo dono no CMS | Campo de dono direto no modelo, preenchido no `create`; nunca caminho com ponto |
| Campo `ref` mostra id em vez do nome | Tela usa `registro.campo` em vez de `registro.campo__label` | Ler o arquivo da tela | Mostrar `campo__label` |
| "Sumiram os dados" depois de uma edição | Campo renomeado no schema: os registros antigos têm o id antigo | O dono vê no CMS do Studio (ou a resposta da API na aba de rede mostra) o valor no id antigo | Voltar o id do campo no `fab.schema.json` e `fabapp push`. O CLI não grava registros: se o dado precisa ir para o campo novo, o dono copia no CMS do Studio (ou exporta e importa a planilha). Nunca dizer que "recuperou" sem o dono conferir |

## Erros com código

| Código | Significa | Causas comuns | Conserto |
|---|---|---|---|
| 401 | Não entrou (sessão ausente ou vencida) | Tela privada fora da guarda de login; chamada antes de o login carregar (`isLoading`) | Guarda: enquanto `isLoading`, Skeleton; sem login, `<Navigate to="/login" replace />`. Tela mostra "Entre para continuar" |
| 402 | Sem crédito (IA dentro do app, integrações) | `invokeLLM`, `generateImage`, `extractData`, integração paga | Mensagem clara ao usuário; dizer ao dono que é crédito, não defeito |
| 403 | Sem permissão | Regra `create` fechada para quem envia (formulário de visitante sem `create:'public'`); alterar/apagar registro de outra pessoa (padrão: só o dono altera); papel sem a permissão; `sendPush` por quem não é admin; pessoa que ainda não confirmou o e-mail | Achar QUAL regra recusa e ajustar só ela ao uso real. Formulário de visitante: `{"read":"role:admin","create":"public","update":"role:admin","delete":"role:admin"}` |
| 403 "e-mail não verificado" logo depois do cadastro | App com confirmação de e-mail no modo obrigatório: a pessoa existe mas não confirmou, e o servidor recusa toda chamada dela | Código grava `collection(...).create` logo após `signup()` | Dado extra do cadastro no `profile` do `signup()`; demais gravações esperam `user.email_verified`; tela "Confirme seu e-mail" + `resendVerification()`, com aviso de que o e-mail pode não ter chegado |
| 404 | Rota ou registro não existe | Link para rota fora de `src/routes.tsx`; chamada a `/api/<coisa>` inventada; id que não existe | Rota real; tela de "não encontrado" com voltar. App não tem servidor próprio: lógica de servidor é função de backend |
| 409 | Já existe | Cadastro duplicado, convite repetido | Mensagem "Já existe..." com link para o existente; conferir com `count` antes de criar |
| 422 | Campo desconhecido, obrigatório faltando ou tipo errado | Id renomeado; campo `required` fora do formulário; `money` como texto; `date` com hora; `enum` fora das opções; rótulo no lugar do id do `ref`; `list` que não é array | Alinhar o envio ao schema. Validar com `zod` antes de enviar, para o erro aparecer no campo |
| 429 | Limite diário (e-mail do app) | Muitos `notify('email')` | Avisar; não reenviar em laço |

## Tela e comportamento

| Sintoma | Causa provável | Conserto |
|---|---|---|
| Clico e nada acontece | `catch` vazio engolindo erro; botão fora do `<form>` ou `type="button"` num botão de enviar; `onClick` que não chama nada; `disabled` que nunca libera | Mostrar o erro (`toast.error(e.message)`), ligar o botão ao handler certo |
| Tela branca | Erro de execução: campo `undefined` acessado (`registro.cliente.nome` sem registro), import de algo que não existe | Ler o console do navegador (pré-visualização local ou app no ar); proteger o acesso (`?.`), mostrar Skeleton até o dado chegar |
| Tela pisca ou trava em laço | `navigate()` no corpo do componente; `useEffect` que altera a própria dependência | Redirecionar com `<Navigate replace />`; corrigir dependências |
| Fica rodando para sempre | `setLoading(false)` só no caminho de sucesso | `finally { setLoading(false) }` |
| Data um dia antes ou depois | `toISOString()` (UTC) cortado para data; `new Date('aaaa-mm-dd')` lido como UTC | `formatDate` do fab-client; "hoje" no fuso local; campo `date` guarda aaaa-mm-dd |
| Valor com centavo errado (0,30000000004) | Soma de float | Somar em centavos inteiros e formatar com `formatMoney` |
| Lista lenta ou incompleta | Busca tudo e filtra no navegador; sem paginação | `filter`, `sort`, `limit`, `offset` no servidor; busca com espera de ~300 ms |
| Lista não atualiza sozinha | Esperado: `list` é uma leitura. `setInterval` em lista é proibido | `useLive(model, { filter, sort, limit })` |
| Conteúdo externo não carrega (feed, API de terceiros) | O navegador bloqueia (CORS) | Função de backend (`functions/<nome>.ts`, com `fetch` para a URL pública); o plano que libera o CLI já libera funções |
| Imagem quebrada | `<img>` com URL externa | `AppImage` (decorativa) ou imagem do registro |

## Automação, notificação e pagamento

| Sintoma | Causa provável | Conserto |
|---|---|---|
| Automação não dispara | Malformada: gatilho fora dos tipos (`data`, `schedule` daily/hourly, `relative`, `webhook` do WhatsApp), ação que não é `notify`, condição (não existe); o `fabapp push` recusa com 400 e o índice. Ou modelo ou campo que não existe no schema: o `push` aceita e ela nunca dispara. Ou o `push` sobrescreveu o conjunto (o arquivo substitui tudo) sem `pull` antes | Reescrever no formato válido com modelo e campos do schema; `fabapp pull` antes de editar; lógica com condição vai numa função |
| E-mail não chega | Limite diário; texto com URL (proibido no corpo; o link vai em `link`); destinatário sem e-mail | Ajustar; avisar o dono do limite |
| WhatsApp/SMS/Slack não chega | Integração não ligada pelo dono no Studio | Dizer ao dono onde ligar; sem integração, WhatsApp vai por link `wa.me` |
| Push não chega | Ninguém ativou notificações (o resultado de `sendPush` volta com `devices: 0`) | Botão `<EnablePushButton/>` visível; avisar o dono |
| Pagamento não confirma | Gateway não conectado; tela marcando pago pelo retorno do navegador (errado) ou esperando status sem acompanhar | Dono conecta o gateway; tela lê o status gravado pela plataforma com `useLive`; nunca webhook próprio |
| Mudança não aparece no app publicado | Ver a seção abaixo | |

## Funciona na pré-visualização e não no ar (terminal)

| Sintoma | Causa provável | Conserto |
|---|---|---|
| Mudança não aparece no app no ar | Não houve `fabapp deploy` depois da mudança, ou ele deu `build_failed` (422) e o ar ficou na versão anterior | Ler a saída do último deploy; consertar arquivo, linha e coluna; `npx tsc -b` e `npx vite build` locais; deploy de novo até `✓ Live: <url>` |
| Tema ou SEO novos não aparecem | `fabapp push` feito sem `fabapp deploy` depois (o tema e o SEO só entram num build novo) | `fabapp deploy` |
| Pacote funciona local e o build diz `Could not resolve` | Instalado fora de `.fabapp/workspace`, ou o `deploy` não listou `+ pacote@versão` | `npm install` dentro de `.fabapp/workspace`, conferir a linha `+ pacote` na saída do deploy |
| Plugin, config de build ou CSS da plataforma funciona local e some no ar | O `deploy` avisa (`!`) o que a plataforma ignora: `vite.config.*`, `tailwind.config.*`, `@plugin`, `@config`, `index.css`, `fab-theme.css` | Plugin só da lista fechada (declarado no `package.json`); estilo em CSS próprio dentro de `src/` |
| Imagem ou fonte corrompida no ar | Arquivo binário no workspace (o `deploy` só leva texto) | Tirar o binário; imagem pelo Studio (slot de `AppImage`) ou URL, fonte pelo `theme` |
| Imagens escolhidas no Studio sumiram depois de um deploy | O Studio gravou o `src` no código do servidor e o deploy mandou por cima a versão antiga do arquivo | Depois de trocas no Studio, publicar o que é seu e rodar `fabapp dev --reset` ANTES de editar; para recuperar, o dono troca de novo ou restaura pelo histórico do Studio |
| O `dev` avisa que o template mudou | A plataforma atualizou o template desde que o workspace foi montado | Deploy das suas edições, depois `fabapp dev --reset` (apaga as edições locais) |
| Visitante sem login é recusado numa função que devia ser pública | Entrada faltando ou JSON quebrado em `fab.functions.json`: o `deploy` não confere e usa `"user"` em silêncio | Uma entrada por arquivo de `functions/`, JSON válido, deploy |
| `callFunction` responde 403 `feature_locked` | Recurso de plano | Dizer ao dono que funções exigem plano pago |
