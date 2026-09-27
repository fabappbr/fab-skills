# Solução de Problemas: Sintoma, Causa, Conserto

Cheque aqui antes de inventar um diagnóstico. Para qualquer coisa da plataforma, a documentação ao vivo (`https://api.fabapp.ai/llms-full.txt`) tem a última palavra.

## CLI e configuração

| Sintoma | Causa | Conserto |
|---|---|---|
| `not authorised for https://api.fabapp.ai` | A máquina não fez login, ou o token foi revogado | `fabapp login` e aprovar no Studio; conferir com `fabapp status` |
| O login é recusado ou a aprovação não aparece | A conta está no plano gratuito; o CLI exige Builder ou maior | Diga ao usuário com clareza; o upgrade é no Studio |
| `this machine is authorised read-only` | O login foi feito com `--scopes "read"` | `fabapp login --scopes "read write"` |
| `this directory is not linked to a project` | A pasta não tem `.fabapp/config.json` | `fabapp link <id>` ou `fabapp create "<nome>"` na pasta certa |
| `project ... not found, or this account has no access` | Id errado, ou a conta autorizada não tem acesso | Confira o id na URL do Studio e a conta em `fabapp status` |
| `this project has N surfaces` (seguido de `pick one with --app`) | O projeto tem mais de uma surface | `fabapp dev --app <slug>` |
| Aviso de que o template mudou desde que o workspace foi montado | A plataforma atualizou o template | Faça deploy das suas edições primeiro, depois `fabapp dev --reset` (apaga as edições locais do workspace) |
| O `deploy` avisa que o workspace não registra dependências | Workspace montado por um CLI anterior à 0.1.6 | Deploy das edições, depois `fabapp dev --reset`, depois reinstale os pacotes com `npm install` |
| Comando do CLI se comporta como versão antiga | `fabapp` global antigo no PATH | Chame `npx -y @fabappai/cli@latest <comando>` |
| As ferramentas MCP da Fabapp não aparecem | O servidor não foi registrado, ou o cliente precisa recarregar | `claude mcp add fabapp -- npx -y @fabappai/cli mcp`; confira que o `login` foi feito na mesma máquina |
| `fabapp_write_definition` recusa | Ele exige `fabapp_docs` chamado antes na mesma sessão | Chame `fabapp_docs` e tente de novo |

## Definição (schema, automações, tema, SEO)

| Sintoma | Causa | Conserto |
|---|---|---|
| `push` responde 422 num campo | Tipo fora da lista fechada (`select`, `longtext`, `relation` não existem) | Use `enum`, `richtext`, `ref`; confira a lista na documentação |
| O formulário do site responde 401 ou 403 ao enviar | O `create` do model não é `public` (o padrão é fechado) | `"create": "public"` no `access` do model de leads |
| A automação de lead nunca dispara | Nome de model ou campo errado (o validador não confere), ou o dono não tem o canal conectado | Confira os nomes contra o schema; confira na documentação ao vivo o que o canal escolhido exige conectado, e peça ao dono para conectar; sempre prove com um lead de teste no ar |
| Automações antigas sumiram depois de um `push` | `fab.automations.json` substitui o conjunto inteiro | Sempre `pull` antes de `push`; recupere as regras perdidas no Studio |
| O site saiu na fonte do sistema | Nome de fonte fora do catálogo do Google Fonts, ou grafado diferente | Nome exato de fonts.google.com em `titleFont`/`bodyFont`, `push`, `deploy` |
| Mudei o tema ou o SEO e nada mudou no ar | Tema e SEO só entram num build novo | `fabapp push` e depois `fabapp deploy` |
| Link compartilhado sem imagem | `ogImage` ausente, em SVG, ou relativo | URL absoluta de PNG ou JPG 1200x630; `push` e `deploy` |
| `sitemap.xml` não existe | A surface ainda não tem domínio próprio | Normal; ele aparece no build depois do domínio ativo |
| `noindex` na pré-visualização | Rascunho é `noindex` de propósito | Não é bug; confira no site publicado |

## Build e deploy

| Sintoma | Causa | Conserto |
|---|---|---|
| `account_builds_busy` (409) | Dois builds já rodando na conta | Espere e repita; não é erro |
| `build_failed` (422) com arquivo, linha e coluna | O código não compila | Conserte o arquivo apontado; rode `npm run build` local antes; não repita sem mudar nada, cada tentativa paga um build |
| `Could not resolve "gsap"` (ou outro pacote) no build | A dependência não chegou ao `package.json` do app | Instale DENTRO de `.fabapp/workspace` e confira que o `deploy` listou `+ pacote@versão`; com workspace antigo, veja a linha de `--reset` acima |
| O `deploy` lista arquivos como ignorados pela plataforma | Edição num arquivo da plataforma (`index.css`, `vite.config.ts`, `index.html`, SDK) | Mova a mudança para o `site.css`, para `app-typography.css` ou para um componente seu |
| Aviso de `@plugin` ou `@config` num CSS | O build remove essas linhas | Declare o plugin permitido no `package.json` (lista em `plataforma-fabapp.md`); plugin fora da lista não roda |
| Um plugin do Vite ou `postcss.config` não tem efeito | Config de build nunca roda na plataforma | Use só plugins da lista fechada; o resto não existe no build |
| Pacote instala mas quebra no build ou no navegador | Precisa de binário nativo ou script de instalação, ou é só de Node | Procure alternativa em JS puro; lógica de servidor vai para `functions/` |
| Imagem ou fonte aparece corrompida no ar | Arquivo binário enviado pelo workspace (o deploy envia texto) | Tire o binário do workspace; imagem pelo Studio ou URL absoluta; fonte por pacote npm |
| Arquivo apagado localmente continua no app | O CLI nunca apaga | Apague no Studio (aba de código) |
| O Studio mostra código diferente do meu | Alguém editou pelo Studio (ou pela IA do Studio) no meio | O deploy aplica suas edições por cima do estado atual do servidor; combine com o usuário para não editar pelas duas mãos ao mesmo tempo |

## Imagens

| Sintoma | Causa | Conserto |
|---|---|---|
| Os slots mostram placeholders coloridos no ar | Nenhuma imagem foi escolhida ou gerada para o slot | Normal até o dono trocar no Studio; guie a troca slot por slot |
| O Studio recusa trocar a imagem de um item de lista ("edição manual indisponível") | A troca escreve `src` na tag pela linha do arquivo, e numa `.map()` todos os itens dividem a mesma linha | Uma `<AppImage>` por linha: desenrole a lista em componentes que recebem a imagem como prop, publique, e peça a troca de novo |
| As imagens escolhidas no Studio sumiram depois de um deploy | O Studio gravou os `src` no código do servidor e o deploy mandou por cima a versão antiga do arquivo | Depois de trocas no Studio, publique o que for seu e rode `fabapp dev --reset` ANTES de editar de novo; para recuperar, peça a troca outra vez ou restaure a versão pelo histórico do Studio |
| Tentar gerar imagem pelo CLI ou por uma chamada à API responde 401 | O gerador de imagens só aceita a sessão do Studio | Não há caminho pelo CLI hoje: as imagens são geradas pelo dono no Studio |
| Imagem quebrada | `src` com nome de arquivo solto ou caminho relativo | Sem `src` (deixe o slot resolver) ou URL absoluta `https://` |
| Imagem gerada traz logotipo ou texto | O modelo contrabandeou marca ou letras | Gere de novo reforçando "no text, no logos, no lettering, no watermarks"; nunca publique com marca de terceiro |
| Imagens do site não parecem da mesma sessão | Prompts sem a frase de tratamento compartilhado | Repita a mesma frase de luz, paleta e grão em todos os prompts e regenere as que destoam |
| Salto de layout quando a imagem carrega | Sem `width`/`height` ou `aspect-ratio` | Declare o tamanho na `AppImage` ou a proporção no contêiner |
| LCP alto por causa do hero | Imagem principal começando invisível, ou não é a primeira `AppImage` | Nunca anime a imagem principal a partir de opacidade zero; `priority` explícita se ela não for a primeira |

## Movimento

| Sintoma | Causa | Conserto |
|---|---|---|
| Animações dobradas ou ScrollTriggers duplicados em desenvolvimento | `StrictMode` monta efeitos duas vezes e o código não limpa | `useGSAP` com `scope` (reverte sozinho), ou limpeza no retorno do `useEffect` |
| Gatilhos de scroll disparam no lugar errado depois de trocar de página | Posições calculadas antes das imagens e fontes assentarem | `ScrollTrigger.refresh()` depois da montagem e do carregamento das fontes; `width`/`height` nas imagens |
| Linhas do SplitText quebram errado | Divisão feita na fonte de recuo | `autoSplit: true` com a animação criada no `onSplit` |
| Seção fixada treme ou pula no redimensionamento | Valores fixos calculados uma vez | Valores em função e `invalidateOnRefresh: true` |
| Rolagem suave briga com âncoras ou com um painel rolável | Lenis intercepta tudo | `lenis.scrollTo` nas âncoras, `data-lenis-prevent` no painel; ou tire o Lenis se o site não precisa |
| Scroll-driven animation não roda num navegador | Suporte ainda parcial | Está certo: o estado final é o padrão e a animação vive dentro de `@supports` |
| Uma animação de entrada nunca toca | Uma regra posterior venceu a cascata | Prefixe estados com a classe do contêiner e prove que toca |
| Hovers de itens de grade respondem atrasados para sempre | A regra que zera o atraso do escalonamento perde para `:nth-child` | Iguale a especificidade ou use `!important` no `0s` |
| Um estilo dinâmico para de responder depois da entrada | `animation-fill-mode: forwards` venceu | Entrada no pai, estilo dinâmico no filho |
| Loop de fundo pisca ao começar | Atraso positivo | Atraso negativo |
| Animações rodam com a aba escondida | Nada pausa | Classe `paused` no `body` com o seletor universal (em `motion-e-interacao.md`) |
| Rabos de g, y, p cortados | Máscara sem respiro | Padding em `em` com margem negativa casada |
| Página arrasta para o lado | Decoração passando da borda, `overflow-x: hidden` sozinho | `overflow-x: clip` em `html` e `body` |
| Elemento some da tela com movimento reduzido | `transform: none !important` apagou um transform posicional | Re-aplique os transforms de posição dentro do bloco de movimento reduzido |
| Transição de página não acontece | Navegador sem View Transitions, ou movimento reduzido ligado | Comportamento correto: navega sem transição |

## Pré-visualização e testes

| Sintoma | Causa | Conserto |
|---|---|---|
| Lighthouse ruim no `fabapp dev` | Servidor de desenvolvimento, código sem minificar | Meça no build local (`npm run build && npm run preview`) e no ar |
| Lighthouse acusa contraste baixo em texto que, na tela, está legível | Revelações guiadas por scroll deixam o texto abaixo da dobra no estado inicial (apagado) na página parada, e a auditoria mede esse estado | Arme as revelações só depois da primeira rolagem (classe no `html`, ver `motion-e-interacao.md`); antes disso, tudo fica no estado final |
| Um `favicon.ico` 404 no build local | O ícone é servido pela plataforma | Normal localmente; confira no ar |
| A página parece morta no painel de pré-visualização do app | Painel escondido para de compor e `requestAnimationFrame` não dispara | Use o navegador, ou a rota de Chrome headless |
| Capturas mostram a cena WebGL em branco | Canvas acelerado não compõe em algumas capturas headless | Verifique pelo estado (a cena montou, o canvas tem tamanho) ou num navegador real |

## Texto

| Sintoma | Causa | Conserto |
|---|---|---|
| Caracteres especiais viram lixo (mojibake) depois de um busca e troca | Um comando de shell leu UTF-8 com a codificação errada | Edite arquivos do site só pela ferramenta de edição. Recuperação: leia como UTF-8, codifique em Windows-1252, decodifique como UTF-8, salve, confira |

## A regra dos dois travamentos

Um segundo travamento seguido na mesma ferramenta ou subsistema significa que ele caiu. Pare, diga em voz alta, e reinicie aquilo. Nunca faça uma terceira chamada num subsistema travado. Um build que reporta progresso está trabalhando, por mais que demore; a regra cobre chamadas que não respondem nada.
