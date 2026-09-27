# A Plataforma Fabapp: tudo que o site precisa saber sobre onde vive

A Fabapp AI hospeda, constrói e serve o site. Você escreve o código no disco pelo CLI, e a plataforma faz o build num sandbox isolado, aplica tema e SEO, e publica na borda da Cloudflare em `<slug>.fabapp.app` ou no domínio próprio do dono. Não existe servidor, FTP, cPanel ou hospedagem para configurar.

**Este arquivo resume o contrato; a fonte da verdade é a documentação ao vivo** em `https://api.fabapp.ai/llms-full.txt` (ou a ferramenta MCP `fabapp_docs`). Leia a documentação uma vez por sessão. Se ela disser algo diferente daqui, ela vence.

## Vocabulário

| Termo | Significa |
|---|---|
| **Studio** | O painel web da Fabapp, onde o dono trabalha |
| **Projeto** | O backend compartilhado: schema, registros, usuários, integrações |
| **Surface** (app) | Um frontend do projeto, com domínio, tema e SEO próprios. O site é uma surface |
| **Workspace** | A cópia local do código da surface, em `.fabapp/workspace`, montada pelo `fabapp dev` |
| **Definição** | Os arquivos `fab.*.json` do projeto e o `apps/<slug>/fab.config.json` da surface |
| **Template** | A base da plataforma (shell, SDK, componentes shadcn, dependências), copiada a cada build |

## O stack da surface

React 19, Vite 6, React Router 7 (SPA, lado do cliente), Tailwind CSS v4 (pelo plugin do Vite, sem `tailwind.config`), shadcn/ui sobre Radix, `tw-animate-css`, `lucide-react`. Alvo de navegador do Tailwind v4: Safari 16.4+, Chrome 111+, Firefox 128+.

A plataforma pré-renderiza cada rota estática como HTML próprio depois do build, então o head (título, descrição, og, canonical, JSON-LD) existe sem JavaScript. O conteúdo da página continua sendo renderizado pelo React no navegador.

## O CLI (`@fabappai/cli`, versão 0.1.6 ou mais nova)

Requer Node 20+ e o plano Builder ou maior. Zero dependências; o token vai para o chaveiro do sistema.

| Comando | O que faz |
|---|---|
| `fabapp login` | Autoriza a máquina pelo fluxo de dispositivo: mostra um código, o dono aprova no Studio |
| `fabapp status` | Conta autorizada, escopo, e a qual projeto a pasta está vinculada |
| `fabapp create "<nome>"` | Cria projeto e primeira surface e vincula a pasta. `--app <nome>` nomeia a surface |
| `fabapp link <id>` | Vincula a pasta a um projeto existente (verifica o acesso antes de escrever) |
| `fabapp pull` | Traz a definição: `fab.schema.json`, `fab.automations.json`, `fab.settings.json`, `fab.connectors.json`, `apps/<slug>/fab.config.json` |
| `fabapp push` | Envia a definição que está no disco |
| `fabapp dev` | Monta `.fabapp/workspace` (uma vez) e roda o Vite local no template da plataforma. `--app <slug>`, `--port`, `--reset` |
| `fabapp deploy` | Envia o código que VOCÊ mudou no workspace (e as dependências que você adicionou) e publica. `--no-publish` só salva |
| `fabapp mcp` | Servidor MCP por stdio, com a mesma credencial |

Chame sempre por `npx -y @fabappai/cli@latest <comando>` até o `fabapp` estar no PATH; assim a versão nunca fica velha.

**O que ele não faz, de propósito:** nunca apaga (um arquivo que sumiu do workspace é reportado, não removido do app), nunca sobrescreve suas edições no `dev` (compara a assinatura do template e avisa), e nunca envia arquivo da plataforma (um arquivo que o app não pode sobrescrever é nomeado como ignorado).

## As três portas: qual arquivo vai por onde

Esta é a distinção que mais custa tempo quando é adivinhada.

| Porta | Arquivos | Como viaja |
|---|---|---|
| **Definição** | `fab.schema.json`, `fab.automations.json`, `fab.settings.json`, `apps/<slug>/fab.config.json` (tema e SEO) | `fabapp pull` / `fabapp push`, ou `fabapp_write_definition` no MCP |
| **Código** | tudo em `src/`, `functions/<nome>.ts`, `fab.functions.json`, `fab.agents.json`, e as dependências do `package.json` | `fabapp deploy` |
| **Só leitura** | `fab.connectors.json`, `fab.integrations.json` | dizem o que o dono conectou, nunca a credencial |

`fabapp_deploy` (ferramenta MCP) publica o que JÁ está salvo no servidor; não envia código local. Só o COMANDO `fabapp deploy` envia.

A ordem certa numa construção: schema e automações primeiro (o código é escrito contra eles), depois tema e SEO, depois código.

## O que é seu no workspace, e o que é da plataforma

- **Seu:** `src/routes.tsx` (o entrypoint, exporta `AppRoutes` com `<Routes>/<Route>`), `src/pages/*`, `src/components/*` (fora de `ui/`), `src/lib/*` de domínio, qualquer CSS seu em `src/`, `src/app-typography.css`, e no modo padrão (`app-owned`) também os componentes `src/components/ui/*` e as peças `fab-*.tsx`, que você pode editar.
- **Da plataforma, sempre:** `src/lib/fab-client.tsx`, `fab-sdk.tsx`, `fab-i18n.ts`, `utils.ts`, os arquivos de rich text, `src/index.css`, `src/fab-theme.css`, `index.html`, `vite.config.ts`, `tsconfig*.json`, `lazy-routes.ts`. Editar localmente não chega ao build; o `deploy` avisa.
- **`package.json`:** o único arquivo da raiz que o app escreve, e só `dependencies`/`devDependencies` são lidos.

O build divide as rotas sozinho: cada página vira um pedaço carregado sob demanda, e a rota `/` fica no pacote inicial de propósito (medido: dividir a home piora LCP). Escreva `routes.tsx` com imports simples; não use `React.lazy` nas páginas.

## Dependências npm e plugins de build

- **Adicionar um pacote:** `npm install <pacote>` dentro de `.fabapp/workspace`, importe, e `fabapp deploy`. O deploy envia os pacotes que você ADICIONOU, mesclados no `package.json` do app no servidor, e lista cada um (`+ gsap@3.x`). Declare com a versão que você testou.
- **Já fornecidos (nunca declare nem re-fixe):** React, React DOM, React Router, `lucide-react`, `clsx`, `tailwind-merge`, `class-variance-authority`, `cmdk`, `sonner`, `react-day-picker`, os pacotes Radix, `zod`, `date-fns`, `recharts`, `qrcode`, `react-pdf`, `hls.js`, TipTap, Vite, Tailwind, `tw-animate-css`, TypeScript. Uma versão diferente é ignorada.
- **Plugins de build, lista fechada:** declarar o pacote no `package.json` liga o plugin com as opções da plataforma. Os úteis para sites: `@tailwindcss/typography` (classe `prose` para textos longos, blog, termos), `tailwindcss-motion` (presets de entrada: `motion-preset-fade`, `motion-preset-slide-up`), `tailwind-scrollbar`, `vite-plugin-svgr` (`import Logo from "./logo.svg?react"`), `@mdx-js/rollup` com `remark-gfm` (posts em MDX), `vite-plugin-glsl` (shaders para three.js), `vite-plugin-wasm`. Confira a lista atual na documentação ao vivo.
- **O que o build ignora:** `vite.config.*`, `postcss.config.*`, `tailwind.config.*`, `babel.config.*` em qualquer pasta; linhas `@plugin` e `@config` em CSS; scripts de instalação (pacotes com binário nativo, como `sharp`, não funcionam); pacotes que só rodam em Node. O `deploy` avisa antes de enviar.
- **Workspace montado por CLI antigo:** o `deploy` avisa que não registra dependências. `fabapp dev --reset` resolve, mas APAGA as edições do workspace: faça o deploy das edições antes, ou copie `src/` para fora e traga de volta depois do reset.

## O tema (`apps/<slug>/fab.config.json` → `theme`)

A plataforma escreve o tema como variáveis CSS em cada build e garante contraste AA derivando as cores de texto. Chaves:

```json
{
  "theme": {
    "mode": "light",
    "primary": "#1f4d3a", "primaryFg": "#f6f1e7",
    "bg": "#f3eee4", "card": "#fbf8f2", "text": "#1b1a17",
    "accent": "#e7dfcf", "destructive": "#b3261e",
    "radius": 6,
    "titleFont": "Fraunces", "bodyFont": "Inter Tight", "titleTracking": "-0.02em",
    "dark": { "bg": "#12110f", "card": "#1b1a17", "text": "#f3eee4", "primary": "#8fc7a8" }
  }
}
```

- `mode`: `light`, `dark` (sempre escuro) ou `system` (segue o aparelho). `dark` carrega a paleta do modo escuro.
- As fontes vêm do **catálogo do Google Fonts por nome exato** (cerca de 1.900 famílias, todas de licença aberta). Um nome fora do catálogo não dá erro: o site sai na fonte do sistema. Confira o nome em fonts.google.com.
- No Tailwind: `font-display` é a `titleFont` (e todos os `h1` a `h6` usam ela), `font-sans` é a `bodyFont`, `font-mono` é sempre JetBrains Mono. Cores: `bg-background`, `text-foreground`, `bg-primary`, `text-primary-foreground`, `bg-card`, `text-muted-foreground`, `border-border`, `bg-accent`.
- As fontes são carregadas com preconnect e preload sem bloquear a renderização. Nunca adicione `@import url(fonts.googleapis...)` num CSS: bloqueia a primeira pintura e o bundler mantém só o primeiro import remoto.
- Uma face fora do Google Fonts (uma fonte de fundição licenciada) entra como pacote npm auto-hospedado (por exemplo `@fontsource-variable/<familia>`, importado no `main` do site), aplicada pelo CSS do site. Confira a licença antes.

Envie com `fabapp push`. O tema só aparece no ar no próximo build (`fabapp deploy`).

## Imagens (`<AppImage>`)

O layout usa `<AppImage slot="hero-atelier" prompt="..." alt="..." className="..." />` do kit (`@/components/ui/app-image`):

- `slot`: id único em kebab-case, estável; é a âncora da troca.
- `prompt`: a descrição da cena EM INGLÊS, escrita pelas regras de `direcao-de-arte.md`. Vira o contexto da geração.
- Sem imagem escolhida, o slot mostra um placeholder no tema, sem rede, e a página nunca exibe imagem quebrada.
- A primeira `AppImage` da página ganha prioridade de LCP sozinha (`fetchpriority=high`, `loading=eager`). Passe `width`/`height` quando souber, para reservar o espaço e zerar CLS.
- **A imagem real entra pelo Studio, e o CLI não gera imagem.** O gerador de imagens da plataforma só aceita a sessão do Studio (o token do CLI é recusado), então nem você nem o MCP conseguem gerar daqui. Na pré-visualização do Studio, cada slot tem o botão de trocar imagem: o dono envia a foto dele ou gera a imagem a partir do prompt (gasta créditos de criação; o Studio mostra o custo antes).
- **A troca do Studio grava no CÓDIGO.** Ela escreve `src="<url>"` na própria tag `<AppImage>`, localizando a tag pela linha do arquivo. Duas consequências que você precisa respeitar desde a construção:
  1. **Uma `<AppImage>` por linha, nunca dentro de `.map()`.** Numa lista, todos os itens dividem a mesma linha e a troca é recusada. Desenrole: um componente de cartão que recebe a imagem como prop (`image={<AppImage slot="..." ... />}`), uma linha por item.
  2. **Depois das trocas, o código do servidor está à frente do seu.** Antes de editar o site de novo: garanta que todas as suas edições locais já foram publicadas, e rode `fabapp dev --reset` para trazer o código do servidor (com os `src`) para o workspace. Editar e publicar o arquivo antigo apaga as imagens escolhidas.
- Um `src` fixo só com URL absoluta `https://` (por exemplo, uma imagem já no armazenamento do app). Nome de arquivo solto quebra.
- **Nunca coloque binário no workspace** (`png`, `jpg`, `webp`, `avif`, `woff2`, `mp4`, `.riv`, `.lottie`): o `deploy` envia texto, e binário chega corrompido. SVG é texto e pode viver em `src/`. JSON de Lottie também.
- Depois do `--reset`, as URLs das imagens escolhidas estão nos `src` do código. É daí que você tira uma para o `ogImage`. (O mapa `window.__FAB_IMAGES__` no head só guarda imagens que a IA do Studio gerou no build dela, não as trocas.)

## O SDK que um site usa

Importe de `@/lib/fab-sdk` (ou `@/lib/fab-client`):

- `collection("<model>")`: `list`, `get`, `create`, `update`, `remove`, com as regras de acesso do schema. É como o site grava um lead ou lê conteúdo do CMS.
- `trackEvent(name, params?)`: evento de conversão (dispara no Meta Pixel quando o dono conectou).
- `useSeo({ title, description, image })` e `<FabHead />`: head por página, obrigatório em rota dinâmica (`/cases/:slug`).
- `formatMoney`, `formatDate`, `useLocale`, `<Logo />`.
- Peças prontas úteis a sites: `<SlotPicker/>` e `<AvailabilityManager/>` (agendamento), `<Rating/>`, `<VideoPlayer/>`, `<QRCode/>`.
- `callFunction(name, payload)` chama uma função de backend (`functions/<nome>.ts`) quando o site precisa de lógica no servidor.

## Leads: o formulário sem serviço de terceiro

1. **O model**, no `fab.schema.json` (confira os tipos e a gramática de acesso na documentação ao vivo; a lista de tipos é fechada):

```json
{ "id": "lead", "name": "Lead", "labelField": "name",
  "fields": [
    { "id": "name", "type": "text", "label": "Name" },
    { "id": "email", "type": "email", "label": "E-mail" },
    { "id": "phone", "type": "phone", "label": "Phone" },
    { "id": "message", "type": "text", "label": "Message" },
    { "id": "source", "type": "text", "label": "Source" }
  ],
  "access": { "read": "role:admin", "create": "public", "update": "role:admin", "delete": "role:admin" } }
```

   O acesso padrão é FECHADO: sem `"create": "public"`, um visitante anônimo não consegue enviar. E nunca deixe `read` público num model de leads.
2. **A automação**, no `fab.automations.json` (pull antes, porque o arquivo substitui o conjunto inteiro):

```json
{ "name": "Novo lead", "trigger": { "type": "data", "model": "lead", "event": "created" },
  "action": { "type": "notify", "channel": "email", "to": "admin",
              "title": "Novo contato: {{name}}", "body": "{{name}} ({{phone}}, {{email}}) escreveu: {{message}}" } }
```

3. **No site:** `await collection("lead").create({ ... , source: "home-cta" })`, com validação no cliente, um campo isca escondido contra robôs (se vier preenchido, finja sucesso e não grave), estado de envio, estado de sucesso honesto e erro legível. Dispare `trackEvent("Lead")` no sucesso.
4. **Verifique no ar:** envie um lead de teste, confirme que aparece no CMS do Studio e que o e-mail chegou ao dono. Apague o teste depois.

Quando a validação precisa ser no servidor (limite por IP, checagem de domínio de e-mail, campos calculados), use uma função pública (`functions/contact.ts` com `"auth": "public"` no `fab.functions.json`) que valida e faz um único insert, e feche o `create` do model. As regras de segurança de funções estão na documentação ao vivo.

## Integrações (conectadas pelo dono, nunca pelo código)

- **Analytics e marketing:** Google Analytics, Google Tag Manager, Meta Pixel, Microsoft Clarity, Hotjar. A plataforma injeta os scripts no build. Nunca cole snippet nem ID no código.
- **Consentimento de cookies:** o card `cookie_consent` exibe o banner e liga o Consent Mode v2. Obrigatório na prática quando há analytics ou pixel (LGPD).
- **Chat ao vivo:** Crisp, Tawk.to, Baseportal Chat.
- **Comunicação:** e-mail pelo domínio do dono (precisa verificar o domínio no DNS), Mailchimp, WhatsApp Cloud API.
- **Mapas:** Google Maps (campo `geo`).
- **Pagamentos:** Stripe, Mercado Pago, Pagar.me, Hotmart, pelos hooks do SDK.

Uma integração que o dono não conectou não é erro para contornar: a função fica desligada. Liste para o usuário quais cards valem a pena para o site dele, e o que cada um pede.

## SEO (`apps/<slug>/fab.config.json` → `seo`)

```json
{ "seo": { "enabled": true,
    "title": "Ateliê Moura: marcenaria sob medida em Curitiba",
    "description": "Móveis sob medida desenhados com você e feitos à mão em Curitiba. Orçamento em 48 horas pelo WhatsApp.",
    "ogImage": "https://.../share.jpg",
    "robots": true, "sitemap": true, "structured": true, "breadcrumbs": true, "ai": true,
    "pages": { "/": { "title": "..." }, "/projetos": { "title": "...", "description": "..." } } } }
```

- `title` de 15 a 60 caracteres e `description` de 50 a 160, no idioma do site, dizendo o que é oferecido e onde. Valem só para a home: cada rota importante ganha a própria entrada em `pages`.
- `ogImage`: URL absoluta de PNG ou JPG em 1200x630. SVG é ignorado por WhatsApp, Facebook e LinkedIn; sem `ogImage`, o site quase sempre sai sem cartão de compartilhamento.
- `sitemap` só é escrito quando a surface tem domínio.
- `index: false` numa rota só tira de indexação; não protege nada, e aparece no `robots.txt` público.
- A pré-visualização é `noindex` de propósito. O cartão de compartilhamento só muda no próximo build.
- A tela de Marketing do Studio dá uma nota de 0 a 100 lendo o head servido. A meta é 100.

## Publicação, domínio e selo

- `fabapp deploy` envia e publica; a última linha é `✓ Live: <url>`. Dois erros parecidos e opostos: `account_builds_busy` (409, dois builds já rodando na conta: espere e repita) e `build_failed` (422, o código não compila, a mensagem traz arquivo, linha e coluna: conserte, não repita, porque cada tentativa paga um build).
- `fabapp_app_status` (MCP) mostra se a surface está publicada, a URL e quando foi o último deploy.
- Aviso de template: se a plataforma construiu com um template diferente do workspace, o `deploy` diz. O que você viu no `dev` pode diferir do ar; `fabapp dev --reset` realinha (e apaga as edições locais, então faça deploy antes).
- **Domínio próprio e remoção do selo da plataforma** são recursos de plano, configurados pelo dono no Studio. O endereço padrão é `<slug>.fabapp.app`.

## Limites e custos que o usuário precisa ouvir

- O CLI exige plano Builder ou maior.
- Escrever o código aqui não gasta créditos da plataforma; gerar imagem no Studio gasta créditos de criação; e-mail, SMS e outros canais pagos gastam créditos de integração.
- Confira planos e preços atuais no site da Fabapp em vez de repetir número escrito aqui.
