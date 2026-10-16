---
name: fab-app-mobile
description: "Deixa o app da Fabapp AI, construído ou editado pelo terminal (CLI @fabappai/cli), com cara e jeito de aplicativo de celular, seguindo as regras da Apple e do Google (Material 3): abas embaixo só nas telas principais, detalhes em camadas com cabeçalho de voltar e título, botão principal ao alcance do polegar, áreas de toque grandes, áreas seguras do iPhone e do Android, texto que aumenta com a configuração do aparelho, modo escuro, folhas que sobem de baixo, carregamento com esqueleto, permissões pedidas na hora certa, câmera, localização, compartilhar, biometria e notificação pelo SDK nativo. Também desenha o fluxo antes de construir: casos de uso, mapa de telas, estados de cada tela e rascunho de cada tela. Use quando o dono pedir 'app', 'aplicativo', 'app de celular', 'quero que pareça app', 'vai para a loja', 'Play Store ou App Store', 'app para meus clientes', 'PWA', 'instalar no celular', ou quando o app estiver 'com cara de site', difícil de usar no celular, com botões pequenos ou menu escondido."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.3.0
  title: App com Cara de App
  edition: terminal
---

# App com Cara de App

Faz o app da Fabapp se comportar como aplicativo de celular, com as regras da Apple e do Material 3 traduzidas para a web, e desenha o fluxo de telas antes do código.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create` ou `link`, `pull`, `dev`, contrato ao vivo) e só então comece. Leia `DECISOES.md` na raiz do projeto, se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs` (ou `https://api.fabapp.ai/llms-full.txt`) discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio. Se ele já pediu, publique o que é seu e rode `fabapp dev --reset` antes de continuar.

O app é React no navegador. No celular ele roda de três jeitos: no navegador, instalado como PWA (`<InstallPrompt/>`) e dentro da casca nativa Expo, que o dono configura depois na aba "App para celular" do Studio. É **o mesmo código** nos três. Por isso: nada de React Native, nada de pergunta ao dono sobre loja de aplicativos, nada de prometer publicação na loja. O que esta skill garante é que o app, em qualquer um dos três, se comporte como aplicativo: as regras de interface da Apple (HIG) e do Material 3 do Google, traduzidas para a web, e um fluxo de telas pensado antes do código.

A casca de navegação de app (barra de abas embaixo no celular, cabeçalho ou lateral no computador, área segura) é padrão da plataforma: use a dela, não invente outra. Esta skill decide o que vai nela e como cada tela se comporta.

O modelo de navegação é o de um app nativo, em camadas: cada aba tem uma tela raiz, e tudo abaixo dela (detalhe, edição, configuração) abre como uma camada que entra da direita por cima da tela anterior e sai deslizando de volta ao voltar. A camada tem o cabeçalho de app (botão voltar à esquerda, título curto, até duas ações à direita) e não tem a barra de abas. Na plataforma isso é `<AppShell tabs="roots">` mais `<Screen>` e `useLayerNav` (`@/components/ui/screen`).

Aplique as regras numeradas de `references/regras-nativas.md` e os modelos de `references/fluxo-de-ux.md`. Leia os dois inteiros antes do plano.

## As regras que mais quebram (valem em todas as etapas)

1. **Toque mínimo de 44 px** em tudo que é clicável (Apple 44 pt, Google 48 dp); botão principal e linha de lista com 48 px (`h-12` / `min-h-12`). Ícone pequeno ganha área com padding, nunca encolhe o alvo.
2. **Polegar:** a ação principal da tela fica embaixo (barra de ação fixa, acima das abas numa raiz e em `bottom-0` numa camada, ou botão flutuante no canto inferior direito), nunca no topo. Topo é para título, voltar e ações secundárias.
3. **Abas embaixo, 3 a 5, sempre com rótulo de uma palavra**, escolhidas por frequência de uso. Nunca menu hambúrguer como navegação principal do app; nunca ícone sem nome; nunca seis abas (a quinta vira "Mais" ou "Perfil" com o resto dentro). A barra aparece SÓ nas telas raiz de cada aba (as rotas da `NAV`); ao entrar num detalhe, a tela abre como uma camada por cima, sem a barra, e a barra volta ao voltar.
4. **Área segura:** nada interativo ou essencial sob a barra de status, o recorte da câmera ou o indicador de início. Borda fixa em cima leva `pt-[env(safe-area-inset-top)]`, embaixo `pb-[env(safe-area-inset-bottom)]`.
5. **Texto que cresce:** tamanhos em `rem` (as classes do Tailwind), corpo `text-base` (16 px), nada abaixo de 11 px, entrelinha de 1,2 a 1,5; a tela aguenta o texto em 200% sem cortar informação essencial.
6. **Cor só por token da marca**, que já tem modo claro e escuro; nunca informação só por cor (erro tem ícone e texto); contraste 4,5:1 (texto na cor da marca usa `text-primary-text`).
7. **Nunca tela travada:** carregamento com `Skeleton` no formato do conteúdo, botão que responde no toque (`LoadingButton`), nada de spinner de tela inteira.
8. **Permissão na hora da ação, com explicação antes**, e caminho alternativo se a pessoa negar.
9. **Toda tela tem saída** (voltar, abas ou ação). Nenhum beco sem saída.

## Antes de começar

- Leia `references/regras-nativas.md` e `references/fluxo-de-ux.md` inteiros, e `DECISOES.md` se existir.
- Rode `fabapp pull` e olhe o que já existe: `fab.schema.json` (modelos que as telas vão usar), `apps/<slug>/fab.config.json` (o `theme`, com `mode` e paleta `dark`) e, no workspace, `src/routes.tsx` e a casca atual (a `NAV` e a barra de abas). `AppShell tabs="roots"`, `Screen`, `LayerLink` e `useLayerNav` existem no template desde 14/10/2026: num workspace mais antigo, rode `fabapp dev --reset` para receber a cópia nova de `src/components/ui/`.
- Para o que a plataforma oferece (SDK, kit, `@/lib/fab-native`), consulte `references/fabapp-cli.md` e o contrato ao vivo (`fabapp_docs` ou `https://api.fabapp.ai/llms-full.txt`).

## A conversa

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas.

- Não pergunte sobre loja de aplicativos: o app de loja é o mesmo app, e o dono o configura no Studio.
- **Marca e modo:** se o `theme` do `fab.config.json` ainda não tem a marca, proponha paleta (com a paleta `dark`), par de fontes do Google Fonts e raio, e pergunte o modo: "Seguir o celular (Recomendado)" (`system`), "Sempre claro" (`light`), "Sempre escuro" (`dark`). Peça aprovação antes de gravar. Esta skill não traz outras perguntas próprias: o resto do fluxo vai para o plano, que o dono aprova.

## O plano: o fluxo antes da tela

Escreva o plano como texto e mostre ao dono antes de codar, com estas partes nos modelos de `references/fluxo-de-ux.md`. O dono aprova o plano; ele é o seu "de acordo" antes do código.

1. **Casos de uso** (UC-001, UC-002...): nome, quem faz, o que precisa ser verdade antes, passos do caminho principal numerados, caminhos alternativos (erro, vazio, sem permissão, desistência) e o que fica verdade depois. Só os casos do MVP.
2. **Mapa de telas** com todas as telas e caminhos: as abas (3 a 5, com rótulo e ícone `lucide`), as telas empilhadas dentro de cada aba (lista → detalhe → edição, cada uma abrindo como camada sem a barra de abas), e as telas **fora da casca** (entrar, criar conta, recuperar senha, onboarding, checkout), que abrem sem barra de abas. Diga qual é a tela de entrada e para onde vai quem já está logado. Rotas públicas, se existirem, seguem a porta de entrada da plataforma (`/` pública mostrando conteúdo de verdade, login como ação).
3. **Fluxo de cada caso de uso** em texto: Tela → ação → decisão → tela, com no máximo 15 a 20 passos por fluxo (se passar, divida em subfluxos).
4. **Estados de cada tela**, em tabela: Carregando | Vazio | Erro | Sucesso | Sem permissão (403) | Deslogado (401) | Conflito ou dado inválido (409, 422), com o que aparece em cada um. Formulários: vazio → preenchendo → validando → inválido → enviando → sucesso ou erro do servidor → tentar de novo.
5. **Dados de cada caso** (a "sequência"): que chamadas do SDK cada passo faz (`collection('x').list/get/create/update`, `callFunction`, `uploadFile`) e que erro cada uma pode dar.
6. **Rascunho de cada tela principal**, de cima para baixo: título, conteúdo, e a ação principal embaixo; marque onde entram abas, folha, botão flutuante.

Inclua também, como o plano de toda construção: o modelo de dados, a marca proposta (se for o caso), as suposições com a alternativa de cada uma, o que não entra e a **lista de conferência**. A lista traz TODOS os itens que se aplicam a este app, sem teto: os abaixo e os da "Lista de conferência" de `references/regras-nativas.md`.

- Por código: a casca é `<AppShell tabs="roots">` com 3 a 5 itens na `NAV`, cada um com ícone e rótulo; a barra aparece só nas rotas da `NAV`.
- Por código: toda tela que não é raiz de aba é um `<Screen>` com título e voltar, aberta por `LayerLink` ou `useLayerNav().push`; nenhuma tela de detalhe mostra a barra de abas.
- Por código: todo botão e link tem altura mínima de 44 px; botão principal e linhas de lista, 48 px.
- Por código: toda lista tem estados de carregando (Skeleton), vazio (EmptyState com ação) e erro (mensagem e "Tentar de novo").
- Por código: câmera, localização e notificação são pedidas só no toque do botão que precisa delas, depois de uma explicação, e há alternativa se a pessoa negar.
- Na tela: em 375 px de largura, a ação principal de cada tela está na metade de baixo e nada fica escondido atrás da barra de abas.
- Na tela: em 1280 px, cada tela usa a largura para mostrar mais (colunas, detalhe ao lado da lista, painel de apoio); nenhuma é a coluna do celular esticada.
- Por código: toda tela fora da casca (login, checkout, onboarding) tem botão de voltar; nenhuma tela sem saída.

## A construção: implementar como app

Ordem: schema e automações primeiro (`fab.schema.json`, `fab.automations.json`, com `pull` antes e `fabapp push` depois), depois o `theme` no `fab.config.json` e `fabapp push`, depois o código no workspace.

- **Marca e modo:** grave a marca aprovada em `apps/<slug>/fab.config.json → theme` com as chaves reais: `mode` (`light`, `dark` ou `system`), `primary`, `primaryFg`, `bg`, `card`, `text`, `accent`, `destructive`, `radius` (NÚMERO em px; 100 ou mais vira pílula), `titleFont`, `bodyFont` (nome exato do Google Fonts; nome inexistente cai na fonte do sistema sem erro), `titleTracking`, e `dark: { bg, card, text, primary }` (o modo escuro precisa dela). Não escreva `primaryText` (é derivado). Envie com `fabapp push`; o tema só aparece no ar no próximo `fabapp deploy`. Anote em `DECISOES.md`, seção Marca, com o porquê. No código continuam SÓ tokens e classes: nada de hex, nada de `font-family`, nunca editar `index.css` nem `fab-theme.css`; estilo de títulos vai em `src/app-typography.css`, em `@layer base`, sem nome de fonte. O logo o dono sobe no Studio.
- **Casca:** a de app da plataforma, com a barra só nas raízes: em `src/components/Layout.tsx`, `const NAV` único e `return <AppShell nav={NAV} tabs="roots" desktop="top" actions={…}/>` (`desktop="sidebar"` só em painel, área administrativa ou ferramenta interna). Ela já traz a barra com área segura, a aba ativa pela rota (cor da marca em texto, pílula atrás do ícone), o "Mais" quando há mais de 5 destinos e, no computador, a mesma `NAV` no topo ou na lateral. Nunca escreva a barra à mão.
- **Camadas:** toda tela abaixo de uma raiz é um `<Screen title="…" backTo="/raiz-da-aba" actions={…}>` de `@/components/ui/screen`: cabeçalho compacto com voltar e título, sem a barra de abas. Abra a camada com `<LayerLink to="/pedidos/42">` (no lugar de `<Link>`) ou `const { push, back } = useLayerNav()`: ela entra da direita e sai ao voltar, como num app nativo; o voltar leva à tela anterior, ou à raiz da aba quando a pessoa chegou por link ou notificação. Tarefa curta (filtro, escolher opção, formulário rápido) continua numa `Sheet` de baixo, não numa camada.
- **Exemplo de camada** (toda página fora da `NAV` começa assim; sem o `<Screen>` a casca até esconde a barra, mas a tela fica sem o cabeçalho de voltar e sem a transição, e um cabeçalho de voltar feito à mão é defeito):
  ```tsx
  import { useParams } from "react-router-dom";
  import { Screen } from "@/components/ui/screen";
  export default function PedidoDetalhe() {
    const { id } = useParams();
    return (
      <Screen title="Pedido" backTo="/pedidos">
        {/* conteúdo da tela: estados carregando, vazio e erro */}
      </Screen>
    );
  }
  ```
- **Título grande** nas telas raiz (`PageHeader` ou h1 `text-3xl sm:text-4xl`); nas camadas, o cabeçalho é o do `<Screen>` (voltar, título curto, até 2 ações; o resto num `DropdownMenu` de "Mais"). Nunca a marca no título de uma camada, nunca uma camada sem voltar.
- **Ação principal:** barra fixa embaixo com um botão largo de 48 px, ou um botão flutuante com rótulo ("+ Novo pedido") no canto inferior direito. Numa raiz ela fica acima das abas (`fixed inset-x-0 bottom-16 md:bottom-0`); numa camada não há abas, então fica em `bottom-0` com `pb-[env(safe-area-inset-bottom)]`. Um por tela, no máximo.
- **Folhas:** tarefa curta e independente (filtros, escolher opção, formulário rápido) abre numa `Sheet` de baixo (`side="bottom"`) com alça visual no topo, título, botão de fechar e conteúdo que rola. Uma folha nunca abre outra. Confirmação de ação destrutiva usa `AlertDialog` com 2 botões ("Cancelar" e "Excluir"); diálogo só para decisão crítica.
- **Retorno rápido:** aviso curto com `toast` (sonner). Exclusão reversível: some da lista na hora e mostra toast "Excluído" com "Desfazer" por 5 s; só então chama `remove`.
- **Listas:** linhas de 48 px ou mais; estados de lista com `Skeleton`, `EmptyState` com uma ação, erro com `e.message` e "Tentar de novo" (se a skill `fab-ux-de-sistemas` estiver instalada, ela manda no detalhe desses estados). Atualização com `useLive`, nunca `setInterval`. Filtro, ordem e busca no servidor, busca com espera de ~300 ms. Chips de filtro numa `ScrollRow` na horizontal, nunca empilhados.
- **Guardar o lugar:** filtros, aba interna e busca ficam nos parâmetros da URL (`useSearchParams`), para voltar e encontrar tudo como estava; rascunho de formulário longo guardado no navegador (dentro de `try/catch`) e apagado ao enviar.
- **Formulários:** rótulo acima do campo, erro embaixo em texto (não só borda vermelha), `zod`, campos com o teclado certo (`inputMode="numeric"`, `type="email"`, `PhoneInput`, `CurrencyInput`, `DatePicker`); campos com fonte de 16 px (menor que isso o iPhone dá zoom).
- **Aparelho** (`@/lib/fab-native`), sempre com a alternativa da web já embutida: `takePhoto()` e `pickImage()` devolvem `File` para `uploadFile`; `getLocation()` só no toque de "Usar minha localização", com campo de endereço (`AddressInput`) como alternativa; `share({ title, text, url })` em conteúdo compartilhável com link da própria rota; `registerPush()` só depois de uma ação que justifica ("Avisar quando meu pedido sair?"), com tela de explicação antes; `authBiometric()` só quando `can('biometrics')` e só como desbloqueio opcional depois do login normal, nunca no lugar dele.
- **Movimento:** respeite `useReducedMotion` (sem parallax ou animação decorativa quando a pessoa pediu menos movimento); gesto customizado (arrastar para apagar, pressionar e segurar) sempre tem botão ou menu equivalente; nada de arrastar horizontal colado nas bordas da tela (ali é o voltar do sistema).
- **Acessibilidade:** botão só de ícone com `aria-label` que diz a ação ("Adicionar aos favoritos", não "coração"); ícone decorativo com `aria-hidden`; ordem de leitura igual à visual; foco volta ao lugar lógico ao fechar folha ou diálogo (o kit já faz); tudo operável por teclado.
- **Entrada do app:** sem tela de abertura com logo nem animação de apresentação; onboarding, se houver, com 3 a 5 passos até o primeiro resultado real e "Pular" visível (se a skill `fab-formularios-e-onboarding` estiver instalada, ela manda no onboarding); cadastro só quando a pessoa precisa de algo que exige conta.
- **Imagens:** foto do próprio dono não entra pelo terminal (binário nunca vai para o workspace). Cada imagem é um `<AppImage slot prompt alt />`, uma por linha, nunca dentro de `.map()`, e o dono troca o slot pela foto dele no Studio. Depois das trocas, faça deploy do que é seu e `fabapp dev --reset` antes de editar de novo.

## Conferir antes de dizer pronto

1. Com `fabapp dev` rodando, abra a pré-visualização em 375 px e no computador, console aberto. Percorra cada item da lista de conferência do plano e cada item da "Lista de conferência" de `references/regras-nativas.md`: rota, elemento, estado (carregando, vazio, erro, sucesso), voltar em cada tela fora das abas, nada atrás da barra de abas, nenhuma rolagem lateral.
2. Confira por busca no código (`grep` em `.fabapp/workspace/src`), e zere cada ocorrência:
   - hex e neutro fixo (`#[0-9a-fA-F]{3,8}`, `bg-white`, `text-gray-`), `font-family`;
   - `window.confirm`, `alert(`, `prompt(`;
   - `animation-timeline`;
   - `<img` com URL externa;
   - `import(` dinâmico;
   - `setInterval` em lista, `overflow-x-auto` (use `ScrollRow`), `<input type="date"` (use `DatePicker`).
3. Rode `npx tsc -b` e `npx vite build` dentro de `.fabapp/workspace` quando puder.
4. `fabapp push` (definição e tema) e confira a saída. Depois `fabapp deploy` e leia a saída inteira até `✓ Live: <url>`. `account_builds_busy` (409): espere e repita. `build_failed` (422): não repita; conserte o arquivo, linha e coluna que a mensagem aponta e só então publique de novo.
5. Mensagem final ao dono: os itens da lista de conferência que você conferiu (só o que conferiu), o link, e a lista do que ele faz no Studio:
   - trocar os slots de imagem pelas fotos dele e subir o logo;
   - configurar o app de loja na aba "App para celular" (exige plano pago);
   - ligar "Entrar com Apple" no painel, se o app oferece entrar com Google e vai para a App Store;
   - integrações, domínio e cadastro de dados no CMS, se o app precisar.

Anote em `DECISOES.md` o que foi decidido (abas, modo, marca, fora do escopo, pendências do dono no Studio).

## Mudanças depois: não desmontar o jeito de app

- Pedido de nova seção principal com 5 abas já ocupadas: não crie a sexta. Proponha ao dono, com opções, trocar uma aba de pouco uso ou pôr a nova dentro de "Perfil" ou "Mais".
- "Põe um menu lateral" ou "hambúrguer": no celular a navegação principal continua nas abas; um menu pode reunir itens raros dentro de "Mais". Explique em uma frase: aba à vista é achada, menu escondido não.
- Tela nova: entra no mapa de telas com os estados (carregando, vazio, erro), a saída e o lugar na pilha da aba certa; se não é raiz, abre como camada (`<Screen>` com voltar e título, aberta por `LayerLink`), nunca com a barra de abas.
- "Botão muito pequeno", "difícil de apertar", "fica atrás da barra": confira 44/48 px, a área segura e, nas raízes, o espaço acima das abas (o `AppShell` já reserva; numa camada não há barra).
- "Quero modo escuro" ou "seguir o celular": grave `mode` `dark` ou `system` no `theme` do `apps/<slug>/fab.config.json`, mantendo a paleta e completando a paleta `dark` se faltar (a mudança de modo não troca a marca); `fabapp push` e `fabapp deploy`; anote em `DECISOES.md`, seção Marca. Nunca cor fixa no código.
- "Quero no celular / na loja": explique que o app já funciona instalado no celular pelo navegador e que a versão de loja é configurada na aba "App para celular" do Studio (exige plano pago), sem mudar o código.
