# A plataforma Fabapp pelo terminal: o contrato que toda skill segue

Contrato da Fabapp AI para o agente que constrói e edita apps pelo terminal (Claude Code, Codex, OpenCode, Cursor, Gemini CLI) com o CLI `@fabappai/cli` e o servidor MCP dele. A skill diz O QUE construir; este arquivo diz ONDE e COMO isso vive na plataforma.

**A documentação ao vivo vence este arquivo.** A Fabapp publica o contrato atual em `https://api.fabapp.ai/llms-full.txt` (a ferramenta MCP `fabapp_docs` devolve o mesmo texto). Leia uma vez por sessão, antes de escrever definição ou `package.json`. Em conflito, siga ela e avise o usuário em uma linha.

## Vocabulário

**Studio**: o painel web do dono (onde fica a IA própria da plataforma). **Projeto**: o backend compartilhado (schema, registros, papéis, usuários finais, integrações). **Surface** (app): um frontend do projeto, com domínio, tema, SEO e papéis próprios sobre o mesmo backend. **Definição**: os `fab.*.json` do projeto e o `apps/<slug>/fab.config.json` de cada surface. **Workspace**: a cópia local do código em `.fabapp/workspace`, montada pelo `fabapp dev`. **Template**: a base da plataforma (SDK, kit, build), copiada a cada build.

Pilha da surface: React 19, Vite 6, TypeScript, React Router 7 (SPA no navegador, sem SSR, sem `next/*`, sem `process.env`), Tailwind CSS v4 pelo plugin do Vite (sem `tailwind.config`), shadcn/ui sobre Radix, `tw-animate-css`, `lucide-react`. Cada rota estática é pré-renderizada com head próprio depois do build.

## 1. Primeiro movimento de toda sessão

Rode em silêncio, reporte como checklist (✓ ou ✗ por linha, com o plano para o que falta) e resolva um item por vez. Nada está pronto até VOCÊ verificar.

1. **Node 20 ou mais novo:** `node --version`.
2. **CLI e sessão:** `npx -y @fabappai/cli@latest status`. Mostra `host`, `session` e `directory`. Chame sempre por `npx -y @fabappai/cli@latest <comando>` até existir `fabapp` no PATH.
3. **Login:** `npx -y @fabappai/cli@latest login`. O terminal mostra um código e abre o navegador; o dono aprova no Studio (Configurações → CLI). Só o plano **Builder ou maior** autoriza o CLI; o gratuito e o Starter não. Sem navegador: `--no-open`. Verifique com `status`: a linha `session` precisa mostrar a conta e `scope read write`. `logout` esquece o token só nesta máquina; revogar é no Studio.
4. **Projeto:** app novo: `fabapp create "<Nome>"` (cria projeto e primeira surface e vincula a pasta; `--app <nome>` nomeia a surface). App que já existe: peça o id do projeto (fica na URL do Studio) e rode `fabapp link <id>`.
5. **Definição no disco:** `fabapp pull`.
6. **Pré-visualização local:** `fabapp dev` (o primeiro monta `.fabapp/workspace` e instala dependências; leva minutos). Opções: `--app <slug>`, `--port <n>`, `--reset`.
7. **Leia `DECISOES.md`** na raiz da pasta do projeto, se existir (seção 12).
8. **Leia o contrato ao vivo** (`fabapp_docs` ou `curl -sS https://api.fabapp.ai/llms-full.txt`) e declare o checklist todo em ✓.

### O servidor MCP (opcional, recomendado)

O mesmo pacote serve MCP por stdio com a credencial do `login`, sem URL nem segredo.

- **Claude Code:** `claude mcp add fabapp -- npx -y @fabappai/cli mcp`
- **Clientes com bloco `mcpServers`** (Claude desktop, Cursor em `.cursor/mcp.json`, Gemini CLI em `settings.json`, Windsurf, Cline):

```json
{ "mcpServers": { "fabapp": { "command": "npx", "args": ["-y", "@fabappai/cli", "mcp"] } } }
```

- **Codex CLI:** o mesmo comando declarado em TOML no `config.toml` dele (`[mcp_servers.fabapp]` com `command = "npx"` e `args = ["-y", "@fabappai/cli", "mcp"]`).
- **OpenCode:** bloco `mcp` do `opencode.json`, como servidor local rodando esse comando.

Quando a documentação do cliente discordar desta lista, o cliente está certo.

Ferramentas de leitura: `fabapp_docs` (o contrato; **chame primeiro**), `fabapp_list_projects`, `fabapp_list_apps`, `fabapp_read_definition` (a definição como arquivos, com o `access`), `fabapp_app_status` (publicado, URL, último deploy, template). De escrita: `fabapp_create_project` (nasce com schema VAZIO), `fabapp_write_definition` (**recusa até `fabapp_docs` ser chamado na sessão**), `fabapp_deploy` (publica o que JÁ está no servidor, **não sobe código local**). Token só de leitura nem vê as de escrita.

## 2. As três portas: qual arquivo vai por onde

| Porta | Arquivos | Como viaja |
|---|---|---|
| **Definição** | `fab.schema.json`, `fab.automations.json`, `fab.settings.json`, `apps/<slug>/fab.config.json` | `fabapp pull` / `fabapp push`, ou `fabapp_write_definition` |
| **Código** | tudo em `src/`, `functions/<nome>.ts`, `fab.functions.json`, `fab.agents.json`, dependências do `package.json` | `fabapp deploy` (a partir de `.fabapp/workspace`) |
| **Só leitura** | `fab.connectors.json`, `fab.integrations.json` | Dizem o que o dono conectou, nunca a credencial. Conectar é no Studio |

- `fab.settings.json` carrega só a chave `auth` (por exemplo `"email_code_login": true`, `"allow_signup": false`).
- `apps/<slug>/fab.config.json` carrega `theme`, `seo`, `kind`, `icon` e `allowed_roles`; `subdomain` aparece mas é só leitura (muda no Studio).
- `fab.automations.json` SUBSTITUI o conjunto inteiro: sempre `pull` antes de `push`.
- Se o `push` avisar "The platform added", rode `pull`.
- Ordem numa construção: schema e automações primeiro (o código é escrito contra eles), depois tema e SEO, depois código.

**O CLI nunca apaga:** arquivo ou dependência que sumiu do workspace é reportado, não removido do app (apagar é no Studio, aba Código). Arquivo da plataforma é nomeado como ignorado. O `deploy` coloca as suas edições por cima do estado atual do servidor.

## 3. O que é do app e o que é da plataforma no workspace

**Seu (viaja no `deploy`):**
- `src/routes.tsx`: o entrypoint, exporta `AppRoutes` com `<Routes>/<Route>` para cada página. Imports simples: o build divide as rotas sozinho (sem `React.lazy`).
- `src/pages/*`, `src/components/*`, `src/lib/*` do domínio, CSS seu dentro de `src/`, `src/app-typography.css` (estilo dos títulos, em `@layer base`, sem nome de fonte).
- No modo padrão (`app-owned`), também os componentes `src/components/ui/*` e as peças `src/lib/fab-*.tsx` que não são SDK: pode editar.
- `functions/<nome>.ts`, `fab.functions.json`, `fab.agents.json` na raiz do workspace.
- `package.json`: só `dependencies`/`devDependencies` são lidos.

**Da plataforma (editar localmente não chega ao build; o `deploy` avisa):**
- SDK e núcleo: `src/lib/fab-client.tsx`, `fab-sdk.tsx`, `fab-i18n.ts`, `fab-native.ts`, `fab-shell.ts`, `fab-cookie.ts`, `fab-video.ts`, `fab-inspector.tsx`, `utils.ts` e os arquivos `rich-text-*`.
- Fiação e build: `src/index.css`, `src/fab-theme.css` (escrito pelo tema a cada build), `src/main.tsx`, `src/App.tsx`, `index.html`, `vite.config.ts`, `tsconfig*.json`, `lazy-routes.ts`, `fab-plugins.ts`/`.json`, `public/sw.js`, `public/manifest.webmanifest`.
- Qualquer `vite.config.*`, `postcss.config.*`, `tailwind.config.*`, `babel.config.*` em qualquer pasta nunca roda; `@plugin` e `@config` em CSS são removidos.

**Nunca coloque binário no workspace** (`png`, `jpg`, `webp`, `woff2`, `mp4`...). O `deploy` só leva texto; mídia sobe pelo Studio e entra por URL. SVG e JSON de Lottie podem viver em `src/`.

### Dependências npm

- `npm install <pacote>` dentro de `.fabapp/workspace`, importe, `fabapp deploy`. O `deploy` envia os pacotes que você ADICIONOU e lista cada um (`+ pacote@versão`).
- Qualquer pacote que roda no navegador serve Não servem: pacotes só de Node (`express`, `pg`), com binário nativo ou script de instalação (`sharp`, `bcrypt`, `prisma`), SDK que exige chave secreta.
- **Já fornecidos, nunca declare nem re-fixe:** React 19, React Router 7, `lucide-react`, `clsx`, `tailwind-merge`, `cva`, `cmdk`, `sonner`, `react-day-picker`, Radix, `zod` 3, `date-fns` 4, `recharts` 3, `qrcode`, `react-pdf`, `hls.js`, TipTap, Vite, Tailwind, `tw-animate-css`, TypeScript.
- **Plugins de build, lista fechada:** declarar o pacote liga o plugin com as opções da plataforma, no build e no `dev`.

`@tailwindcss/typography` (`prose`), `tailwind-scrollbar`, `tailwindcss-safe-area` (`pb-safe`), `tailwindcss-motion` (`motion-preset-fade`), `vite-plugin-svgr` (`import Logo from "./logo.svg?react"`), `vite-plugin-node-polyfills`, `@mdx-js/rollup` com `remark-gfm`, `vite-plugin-wasm`, `vite-plugin-glsl`.

Fora da lista (nunca executam): `daisyui`, `@tailwindcss/forms`, `tailwindcss-animate`, `vite-plugin-pwa`, `@vitejs/plugin-legacy`.

## 4. Tema e SEO (`apps/<slug>/fab.config.json`)

**No terminal, a marca é decidida por você com o dono.** No Studio ela vem do briefing da IA da plataforma; aqui não há briefing: proponha paleta, par tipográfico e raio, peça aprovação e grave no `theme`, o único lugar de cor e fonte do app.

```json
{
  "theme": {
    "mode": "light",
    "primary": "#1f4d3a", "primaryFg": "#f6f1e7",
    "bg": "#f3eee4", "card": "#fbf8f2", "text": "#1b1a17",
    "accent": "#e7dfcf", "destructive": "#b3261e",
    "radius": 8,
    "titleFont": "Fraunces", "bodyFont": "Inter Tight", "titleTracking": "-0.02em",
    "dark": { "bg": "#12110f", "card": "#1b1a17", "text": "#f3eee4", "primary": "#8fc7a8" }
  }
}
```

- `mode`: `light`, `dark` (usa a paleta `dark`) ou `system`. Cores em hex; `primaryFg` é o texto sobre o preenchimento da marca; a cor de texto AA da marca (`primaryText`) é derivada, não a escreva. `radius` é NÚMERO em px (100 ou mais vira pílula).
- Fontes pelo **nome exato do catálogo do Google Fonts**. Nome inexistente não dá erro: o app sai na fonte do sistema. No Tailwind: `font-display` é a `titleFont` (e `h1` a `h6` usam ela), `font-sans` é a `bodyFont`, `font-mono` é sempre JetBrains Mono. Nunca `@import url(fonts.googleapis...)` em CSS.
- Envie com `fabapp push`. O tema só aparece no ar no próximo `fabapp deploy`.

```json
{ "seo": { "enabled": true,
    "title": "Barbearia Navalha: corte e barba no Centro",
    "description": "Agende corte, barba e combo em 30 segundos. Barbearia no Centro de Porto Alegre, de terça a sábado.",
    "ogImage": "https://.../share.png",
    "robots": true, "sitemap": true, "structured": true, "breadcrumbs": true, "ai": true,
    "pages": { "/servicos": { "title": "Serviços e preços", "description": "Corte, barba e combo, com preço e duração." },
               "/admin": { "index": false } } } }
```

- `title` (15 a 60 caracteres) e `description` (50 a 160) valem SÓ para a home, no idioma do app, dizendo o que é oferecido e onde. Cada rota que importa ganha a própria entrada em `pages`.
- `ogImage`: URL absoluta `https://` de PNG ou JPEG 1200x630. SVG é ignorado por WhatsApp, Facebook e LinkedIn.
- `sitemap` só é escrito quando a surface tem domínio. `index: false` só tira da indexação, não protege nada, e aparece no `robots.txt` público. A pré-visualização é `noindex` de propósito.
- Rota dinâmica (`/produto/:id`) não é pré-renderizada: use `<FabHead title description image />` ou `useSeo(...)` na página. Nunca escreva `<title>` à mão.
- A nota de SEO da tela de Marketing (0 a 100) lê o head servido; a meta é 100.

## 5. Dados (`fab.schema.json`)

Forma: `{"models":[...], "roles":[...], "appUser":{...}, "currency":"BRL", "locale":"pt-BR"}`. Cada modelo: `{id, name, labelField, access, fields:[{id, type, label?, required?, options?, to?, of?}]}`. Ids de modelo, campo e rota em inglês; texto visível no idioma do app.

**Tipos de campo, lista completa e fechada:** `text`, `richtext`, `number`, `money`, `boolean`, `date`, `datetime`, `time`, `image`, `file`, `video`, `audio`, `url`, `email`, `phone`, `color`, `icon`, `enum`, `ref`, `list`, `geo`, `json`, `autonumber`.
Não existem `select` (use `enum`), `multiselect` (`list`), `relation` (`ref`), `rating` (`number`), `longtext` (`richtext`), `int`, `timestamp`.

- `enum` exige `options` (strings ou `{value,label}`).
- `ref` exige `to: "<model_id>"`, guarda UM id e mora no FILHO (`order_item.order`), nunca como array de ids no pai. Chega expandido com `<campo>__label`. Filhos se listam por filtro: `collection("order_item").list({ filter: { order: id } })`.
- `list` com `of` (`of: "image"` é galeria); `list` sem `of` é texto ou tags.
- `money` é número na moeda do app (`currency`). `autonumber` é número legível gerado na criação: `start` e `format` com prefixo no idioma do app (`"PED-{0000}"`); nunca escreva nele.
- `json` só aceita OBJETO (lista dá 422). `geo` é endereço geocodificado quando o dono liga o Google Maps.
- `labelField` aponta para um campo legível (`name`, `title`, `code`), nunca `id`.

### `access`: a única porta dos dados

Não há segunda camada atrás dela. Uma regra por ação (`read`, `create`, `update`, `delete`) ou uma só (que vale só para `read`; as escritas caem no padrão fechado).

| Regra | Significa |
|---|---|
| `"public"` | qualquer um, logado ou não |
| `"authenticated"` | qualquer usuário final logado |
| `"owner"` | quem criou o registro |
| `"role:<slug>"` / `"perm:<nome>"` / `"plan:<nome>"` | papel, permissão de um papel, plano do usuário |
| `{"owner_field": "<campo>"}` | `registro[campo] == user.id` |
| `{"owner_in": "<campoLista>"}` | `user.id` está na lista |
| `{"owner_via": "<campoRef>"}` | dono do registro apontado (UM salto; o segundo não casa ninguém) |
| `{"any": [...]}` / `{"all": [...]}` | OU / E |

Sem `access`: ler e criar = `authenticated`, alterar e apagar = `owner`. Nunca é público por herança. Errar fecha (ninguém vê os próprios registros), não vaza. Owner e admin do app são superusuários. Nunca deixe um modelo legível E gravável por `public`.

```json
{ "models": [
  { "id": "task", "name": "Task", "labelField": "title",
    "fields": [ { "id": "title", "type": "text", "required": true },
                { "id": "status", "type": "enum", "options": ["open", "done"] } ],
    "access": { "read": "owner", "create": "authenticated", "update": "owner", "delete": "owner" } },

  { "id": "ticket", "name": "Ticket", "labelField": "code",
    "fields": [ { "id": "code", "type": "autonumber", "start": 1001, "format": "CH-{0000}" },
                { "id": "customer", "type": "ref", "to": "customer" } ],
    "access": { "read": { "any": ["role:admin", "role:staff"] }, "create": "role:staff",
                "update": { "any": ["role:admin", "role:staff"] }, "delete": "role:admin" } },

  { "id": "service", "name": "Service", "labelField": "name",
    "fields": [ { "id": "name", "type": "text" }, { "id": "price", "type": "money" },
                { "id": "photos", "type": "list", "of": "image" } ],
    "access": { "read": "public", "create": "role:admin", "update": "role:admin", "delete": "role:admin" } },

  { "id": "lead", "name": "Lead", "labelField": "name",
    "fields": [ { "id": "name", "type": "text", "required": true }, { "id": "email", "type": "email" } ],
    "access": { "read": "role:admin", "create": "public", "update": "role:admin", "delete": "role:admin" } }
],
  "roles": [ { "slug": "staff", "name": "Equipe", "description": "Atende chamados", "permissions": ["users.read"] } ],
  "appUser": { "fields": [ { "id": "phone", "type": "phone" } ] },
  "currency": "BRL", "locale": "pt-BR" }
```

Padrões: dono único (`task`), equipe por papel (`ticket`), público só leitura (`service`), formulário de visitante (`lead`).

- **Papéis:** `owner`, `admin`, `member` já existem. Permissões: `users.read`, `users.invite`, `users.roles`, `users.plan`.
- **Usuário final:** nunca `collection("app_user")` nem modelo "perfil" espelho. Dado extra da pessoa vai em `appUser.fields` e se grava com `useAuth().updateProfile(...)`.
- **Ids canônicos de blueprint** (as peças prontas só funcionam com o id exato): chat `conversation` + `message`; agendamento `service` + `availability` + `booking`; feed `post`, `comment`, `like`, `follow`; avaliações `review`; pagamentos `plan`, `subscription`, `product`, `order`; curso `course`, `module`, `lesson`, `lesson_content`, `lesson_progress`; multiempresa `organization` + `membership`. Não declare `notification` (a plataforma fornece) nem um modelo chamado `agents`.
- **Validação no servidor:** campo desconhecido, obrigatório faltando ou tipo errado dão 422. Sem índice, unicidade nem campo calculado: valide com `zod` e cheque duplicidade com `count({ email })`.
- **Filtro só em campo do schema**, mais os campos de dono carimbados (`created_by`, `owner_id`, `user_id`). Filtrar por `created_at`/`updated_at` dá 422 (ordenar pode). Para período, declare um campo de data próprio. Operadores: `eq, ne, gt, gte, lt, lte, in, nin, contains, starts, null`.
- **Agregação: só `count(filtro)`.** Soma e média são no cliente a partir de `list` paginado, ou numa função.

### Registros: você não semeia dados

O token do CLI escreve definição e código, nunca registros: as rotas de dados e de importação exigem a sessão do Studio, e o CLI e o MCP não têm ferramenta de registros (`propose_import`/`propose_data_fill` são da IA do Studio). Os caminhos reais:
- **O dono no CMS do Studio** (aba de dados): cria, edita e importa planilha.
- **O próprio app:** uma tela de administração com `<CsvImport/>` ou formulário, usada pelo dono logado como admin.
- Nunca diga ao dono "criei os dados". Diga o que ele precisa cadastrar e onde; para teste, crie um registro pela pré-visualização e apague depois.

## 6. SDK: como o código fala com a plataforma

Importe de **`@/lib/fab-client`**: ele exporta tudo. `@/lib/fab-sdk` é uma fachada PARCIAL (tem `collection`, `useAuth`, `useLive`, `FabHead`, `ApiError`, `invokeLLM`, pagamentos, push), mas NÃO exporta `formatMoney`, `formatDate`, `callFunction`, `agent`, `RequirePlan`, `QuotaGate` nem as peças prontas; importar esses de lá quebra o build.

```tsx
import { toast } from "sonner";
import { collection, useLive, formatMoney, ApiError } from "@/lib/fab-client";
import { Button } from "@/components/ui/button";
import { Reveal } from "@/components/ui/reveal";

type Service = { id: string; name: string; price: number };

export default function Services() {
  const { rows, loading } = useLive<Service>("service", { sort: "name", limit: 50 });
  async function add() {
    try { await collection<Service>("service").create({ name: "Corte", price: 45 }); toast.success("Criado"); }
    catch (e) { toast.error(e instanceof ApiError ? e.message : "Não deu para salvar"); }
  }

  return (
    <main className="mx-auto max-w-5xl px-6 py-10">
      <h1 className="text-3xl sm:text-4xl">Serviços</h1>
      {!loading && rows.map((s, i) => (
        <Reveal key={s.id} delay={Math.min(i, 6) * 60}>
          <p className="text-foreground">{s.name} <span className="text-primary-text">{formatMoney(s.price)}</span></p>
        </Reveal>
      ))}
      <Button onClick={add}>Adicionar</Button>
    </main>
  );
}
```

- `collection<T>(model)`: `list({ filter, sort: "campo" | "-campo", limit, offset, fields })`, `count(filtro)`, `get(id)`, `create`, `update`, `remove`, `updateMany(ids, dados)`, `bulkCreate(itens)` (até 200, atômico), `updateWhere(filtro, dados)`, `deleteMany(filtro)`. Filtro, ordem e paginação no servidor.
- `useLive(model, { filter, sort, limit })` devolve `{ rows, loading, error, refresh }`. Nunca `setInterval` em lista.
- `ApiError { status, message }`: mostre `e.message`; trate 401, 403, 409, 422, 402, 429.
- `useAuth()`: `user`, `login`, `logout`, `signup`, `updateProfile`, código por e-mail (`sendEmailCode`/`loginWithEmailCode`) quando ligado em `fab.settings.json`. As telas de login são suas.
- **Rotas privadas (desde 16/10/2026):** `<RequireAuth>` de `@/lib/fab-client` como rota de layout em volta de todas as rotas privadas (`<Route element={<RequireAuth/>}><Route element={<Layout/>}>…</Route></Route>`); `/login` e `/signup` ficam fora, em `<GuestOnly>`; depois de entrar, `nav(useReturnTo())` devolve a pessoa para onde ia. A guarda espera a sessão (sem piscar o login num F5) e redireciona ANTES de a tela aparecer. App inteiro privado: tudo, inclusive `/`, dentro da guarda; o `/login` é a única porta. Nunca uma tela que só mostra "entre na sua conta" com um botão: isso é o que a guarda evita. Papéis: `<RequireAuth roles={["admin"]} redirectTo="/">`.
- `formatMoney`, `formatDate`, `formatDateTime`, `<Logo/>`, `<InstallPrompt/>` (todo app é PWA).
- `admin.listUsers/updateUser/createUser(s)/invite`: exigem a permissão `users.*`.
- `trackEvent(nome, params)`: chega ao Meta Pixel e aos analytics que o dono conectou.
- APIs do aparelho em `@/lib/fab-native`: `isNativeApp`, `takePhoto`, `pickImage`, `getLocation`, `share`, `authBiometric`, `registerPush`, `openStoreSubscriptions`, todas com alternativa web. O app de loja é o mesmo app web numa casca que o dono configura no Studio.

## 7. Lado servidor

### Funções de backend (plano Builder ou maior)

- Uma por arquivo: `functions/<nome>.ts` na RAIZ do workspace (não em `src/`, sem subpasta). Nome com letras, dígitos, `_` e `-`.
- Manifesto obrigatório `fab.functions.json` na raiz: `{"functions": {"contact": {"auth": "public"}, "close-month": {"auth": "role:manager"}}}`. Valores: `"user"` (logado), `"public"`, `"role:<slug>"`. **O `fabapp deploy` não confere o manifesto:** entrada faltando ou JSON quebrado vira `"user"` em silêncio Confira antes.
- `export default async function (req: Request, ctx) { ... }` devolvendo `Response`. Recusa com status 4xx e corpo `{ "detail": "..." }` (é o que vira `ApiError.message`). Use `try/catch`: exceção que escapa manda a pilha ao navegador.
- `ctx`: `user` (`{id, email}` ou `null`), `collection()` (roda com privilégio da PLATAFORMA, ignora o `access`: a função é a fronteira de autorização, confira `ctx.user` contra o registro), `ai.invokeLLM/generateImage/extractData`, `notify(canal, { message, to, subject?, link? })` com canais `email`, `sms`, `slack`, `discord`, `discord_dm`, `sendPush`, `integrations.call`, `callConnector`, `google.*`, `orgs.*`, `callFunction`, `agent(nome).run`, `log`. Não há `ctx.secrets`, `ctx.env`, `ctx.admin`.
- 30 segundos por chamada. `fetch` para URL pública permitido. Proibidos: `process.env`, `eval`, `import()` dinâmico, `child_process`. Pacotes npm só se declarados no `package.json`.
- No app: `await callFunction<T>("nome", payload)` de `@/lib/fab-client`. Nunca importe `functions/*` de `src/`.
- Função `public` que grava: um único insert validado. É também o único endpoint de entrada (webhook com lógica).

### Automações (`fab.automations.json`, porta da definição)

```json
{ "automations": [
  { "name": "Novo lead", "trigger": { "type": "data", "model": "lead", "event": "created" },
    "action": { "type": "notify", "channel": "email", "to": "admin",
                "title": "Novo contato: {{name}}", "body": "{{name}} ({{phone}}) escreveu: {{message}}" } },
  { "name": "Fatura vence em 3 dias", "trigger": { "type": "relative", "model": "invoice", "field": "due_date", "offset_days": -3 },
    "action": { "type": "notify", "channel": "push", "to": "customer", "title": "Fatura {{number}} vence logo", "link": "/invoices/{{id}}" } }
] }
```

- **Gatilhos, lista fechada:** `data` (`event`: `created`, `updated`, `deleted`, exatamente assim), `schedule` (`every`: `hourly` ou `daily`, sem cron, sem hora escolhida; `to` só `admin` ou `role:<slug>`), `relative` (`field` de data, `offset_days` inteiro, uma vez por registro, na hora cheia), `webhook` (`provider: "whatsapp"`, `event: "message_received"`).
- **Única ação: `notify`.** Canais `inapp` e `push` (grátis), `email`, `sms`, `slack`, `discord`, `discord_dm` (gastam créditos de integração do dono). `to`: `admin`, `role:<slug>`, `owner` (quem CRIOU o registro) ou o nome de um campo `ref` que aponta para usuário do app.
- `{{campo}}` com campos do registro mais `{{id}}`, `{{created_at}}`, `{{created_by}}`; sem ponto, sem filtro. `link` é caminho do app, nunca URL completa.
- Sem condição nem filtro: lógica vai numa função. Sem ação de "atualizar registro", "chamar função" ou "webhook de saída". Máximo de 30 por destinatário por hora. Malformada dá 400 com o índice; modelo ou campo inexistente é aceito e nunca dispara.
- Sino dentro do app: `useNotifications()`.

### E-mail, push, IA, arquivos

- **E-mail do app:** `notify("email", { to, subject?, message, link? })`, texto puro até 1000 caracteres, sem URL no texto, `link` para página do próprio app, limite diário (429).
- **Push:** `usePush()`, `<EnablePushButton/>`. Enviar agora: `sendPush({ to: "all" | "admin" | "role:x" | [ids], title, body?, link? })`, só admin do app. Push com lógica: `ctx.sendPush` numa função restrita a `role:admin`.
- **IA no app** (exige login; gasta créditos de integração do dono; 402 = sem saldo): `invokeLLM({ prompt, system?, schema?, tier: "fast" | "smart" })` devolve `{ text, data }`; `generateImage(prompt)` devolve `{ url }`; `extractData({ fileId, schema?, prompt? })` lê nota, currículo, documento.
- **Agentes** (`fab.agents.json`, porta do código): `{"agents":[{"name":"support","instructions":"...","models":["order"],"tier":"fast","maxSteps":6}]}`. Ferramentas fixas: listar, ler, criar, atualizar (sem apagar, sem função, sem integração), sob o `access` de quem chama. `models: []` não libera nada; omita para liberar todos. No app: `const { answer } = await agent("support").run(texto)` de `@/lib/fab-client`. O `deploy` não valida o arquivo: confira o JSON.
- **Arquivos:** `uploadFile(file, { visibility })` devolve `{ id, url }`; guarde o `url` no campo. Prontos: `ImageUpload`, `FileUpload`.

### Pagamentos

- Gateways: Stripe, Pagar.me, Mercado Pago, conectados pelo dono no Studio. Não integrados: PayPal, PagSeguro, Asaas, Cielo. Sem emissão de nota fiscal.
- **Plano recorrente é sempre `useSubscribe()`** (única coisa que libera `plan:<nome>`; no app de loja usa a cobrança da loja). Envolva o que vende em `<SubscribeGate>`.
- **Compra avulsa de uma coisa:** `useCheckout()` com `items: [{ model_id, record_id }]`; o preço vem do registro. Nunca plano por `useCheckout`.
- `paymentMethods: ["credit_card", "pix"]`: Pix só na compra avulsa. Boleto não aparece como método do app.
- A confirmação é da plataforma (o webhook do gateway já é tratado). **Nunca libere conteúdo pago no cliente** e **nunca escreva webhook de pagamento próprio**. Portões: `useEntitlement`, `<RequirePlan>`, `useQuota` + `<QuotaGate>`, cartões salvos com `<PaymentMethods/>`.

### WhatsApp e integrações

- WhatsApp Cloud API: `integrations.call("whatsapp", "sendMessage" | "sendTemplate", params)` e o gatilho `webhook` de mensagem recebida. Sem a integração ligada, use o link `https://wa.me/55DDDNUMERO?text=...` (sempre funciona).
- Outros por `integrations.call`: `telegram`, `notion`, `airtable`, `mailchimp`, `webhook` (envio), `shopify` (leitura), `meta` (páginas e posts). Google: `google.sheetsAppend`, `google.calendarInsert`. OpenAPI: `callConnector`.
- Analytics, pixel, GTM, Clarity, Hotjar, chat ao vivo e o banner de cookies (Consent Mode v2) são cards que o DONO liga no Studio; a plataforma injeta no build. Nunca cole snippet nem ID no código.
- **Não existem:** Zapier, Firebase, Supabase, Google Meu Negócio, componente de mapa pronto (use `geo`, `AddressInput` ou link do Google Maps), modo offline, SSR.

## 8. Regras do build e do QA que valem para você

O `fabapp deploy` não passa pelo QA do gerador da plataforma (só confere o básico e compila): você é o QA. São as regras que a plataforma impõe ao próprio código.

- **Cor só por token.** Nada de hex (`bg-[#fff]`, `style={{ color: "#123" }}`) nem neutro fixo (`bg-white`, `text-gray-900`). Use `bg-background`, `bg-card`, `text-foreground`, `text-muted-foreground`, `bg-primary`, `text-primary-foreground`, `bg-accent`, `border-border`, `text-success`, `text-warning`, `text-info`, `text-destructive`. **Texto na cor da marca é `text-primary-text`** (contraste AA garantido). Véu com opacidade (`bg-black/40`) vale. Nunca edite `index.css` nem `fab-theme.css`.
- **Fonte só pelo tema**, nunca `font-family` no código.
- **Nunca `window.confirm`, `alert` ou `prompt`**: a pré-visualização roda em iframe e eles travam. Use `AlertDialog`/`ConfirmDialog` e `toast` do `sonner`.
- **Nunca `animation-timeline: view()/scroll()`**: o Safari ignora e o efeito some. Use o kit de motion.
- **Nunca `<img>` apontando para URL externa ou banco de imagens.** Imagem decorativa é `<AppImage slot prompt alt />`; imagem de dado vem do campo do registro. Texto sobre foto precisa de véu.
- **Nunca `await import(` (nem `import('node:...')`), `eval`, `dangerouslySetInnerHTML`, `<script src>` externo, `process.env`**, `import.meta.env` que não seja `VITE_*`, nem `import * as` de `@/lib/fab-*`. `React.lazy(() => import('./Pesado'))` para um componente pesado DENTRO de uma página é aceito; as rotas usam import simples, porque o build já divide cada página.
- **Layout:** container `mx-auto max-w-* px-6`; `h1` com `text-3xl sm:text-4xl`; no máximo 2 colunas no celular; `min-w-0`; sem largura fixa em px. Linha que rola de lado é `<ScrollRow>`, nunca `overflow-x-auto`. `<DatePicker>`, nunca `<input type="date">`; nunca corte `toISOString()` para data sem hora.
- **Casca única:** uma navegação só. App: `<AppShell nav={NAV} tabs="roots" desktop="top"|"sidebar">` (3 a 5 abas embaixo só nas raízes; com `tabs="roots"` a casca esconde a barra em toda rota fora da `NAV`, e cada uma dessas páginas TEM de ser um `<Screen title backTo>`, que traz o voltar com título e a transição; abertas por `LayerLink`; desde 14/10/2026, barra pelo caminho desde 16/10). Site: cabeçalho. Login fora da casca. Rota `/api/x` inventada não existe.

### O kit (`src/components/ui/*`)

accordion, address-input, alert, alert-dialog (`ConfirmDialog`), app-header, app-image, avatar, badge, breadcrumb, button, calendar, card, chart, checkbox, color-picker, combobox, command, currency-input, data-table, date-picker, description-list, dialog, dropdown-menu, empty-state, field, file-upload, icon, icon-picker, image-upload, input, label, loading-button, motion, otp-input, page-header (`PageHeader`, `FormSection`), pagination, phone-input, popover, progress, radio-group (`RadioCard`), reveal, scroll-area, scroll-row, select, separator, sheet, skeleton, slider, social-auth, sonner, spinner, stat-card, stepper, switch, table, tabs, tags-input, textarea, timeline, tooltip. Importe de `@/components/ui/<arquivo>`.

- **Motion** (`@/components/ui/motion`): `Counter` (`value`, `duration`, `prefix`, `suffix`), `Marquee` (`speed`), `Parallax` (`speed`), `Pin` (`height`), `ScrollScale` (`from`, `to`, `fade`), `TextReveal` (`by: "word"`, `stagger`, `as`), `useInView`, `useReducedMotion`, `useScrollProgress`. Entrada por scroll: `<Reveal delay={Math.min(i, 6) * 60}>`. Todos honram movimento reduzido.
- **`AppImage`:** `slot` (kebab-case único e estável), `prompt` (a cena EM INGLÊS), `alt`, `className`, `width`/`height`, `priority`. A primeira da página ganha prioridade de LCP sozinha. **O CLI não gera imagem:** o dono troca ou gera cada slot no Studio (gasta créditos de criação), e a troca grava `src` na própria tag, localizada pela LINHA. Por isso: uma `AppImage` por linha, nunca dentro de `.map()`. Depois das trocas, faça deploy do que é seu e `fabapp dev --reset` antes de editar de novo, ou o próximo deploy apaga as imagens.
- **Peças prontas** (de `@/lib/fab-client`): `Chat`, `SlotPicker`, `AvailabilityManager`, `AgendaBoard`, `Feed`, `Rating`, `Chart` (SVG leve; também há `Chart` do recharts em `@/components/ui/chart`), `PaymentMethods`, `RichTextEditor`/`RichText`, `VideoPlayer`, `OrgSwitcher`, `Members`, `PairingGate`, `InviteCode`, `CsvImport`, `CsvExport`, `DocTemplate`, `QRCode`, `QRScanner`, `PdfReader`, `TwoFactor`, `MagicLink`.

## 9. Verificar antes de dizer pronto

1. **Local:** com `fabapp dev` rodando, abra a URL que o Vite imprimiu. Percorra cada rota (as `:param` com um id real), no celular e no desktop, console aberto: zero erro, nenhuma rolagem lateral, formulários com envio, sucesso e erro.
2. **Compilação:** rode `npx tsc -b` e `npx vite build` dentro de `.fabapp/workspace` quando puder; erro local é de graça, no servidor custa um build.
3. **Definição:** `fabapp push` e confira a saída (avisos, "The platform added", 400 ou 422 com o caminho exato).
4. **Deploy:** `fabapp deploy`. Leia a saída inteira: arquivos enviados, dependências (`+ pacote@versão`), avisos do que a plataforma ignora, e a última linha `✓ Live: <url>`. `--no-publish` só salva.
   - `account_builds_busy` (409): a conta já tem 2 builds rodando. Não é erro: espere e repita.
   - `build_failed` (422): o código não compila; a mensagem traz arquivo, linha e coluna. **Não repita:** conserte, porque cada tentativa paga um build inteiro e a resposta não muda.
   - Aviso de template: o `dev` pode diferir do ar. `fabapp dev --reset` realinha e APAGA as edições locais: faça deploy antes.
5. **No ar:** `fabapp_app_status` (publicado, URL, último deploy) e requisições reais: status 200, head com título e descrição, imagens carregando, um registro de teste que aparece no CMS do Studio e cuja notificação chega. Apague o teste.
6. Relate só o que você conferiu. O que depende do dono vira lista de próximos passos no Studio.

## 10. A regra das duas mãos

Enquanto você constrói pelo CLI, **o dono não edita o mesmo app pela IA do Studio.** As duas mãos no mesmo código geram edições cruzadas: o workspace fica velho em relação ao servidor e o próximo deploy mistura versões. Se o dono já usou a IA do Studio, publique o que é seu e rode `fabapp dev --reset` antes de continuar.

O Studio continua sendo do dono para o que é dele: trocar e gerar imagens dos slots, conectar integrações (pagamento, e-mail, WhatsApp, analytics, cookies), domínio próprio e selo, cadastrar e importar registros no CMS, usuários e convites, app de loja, e acompanhar publicação e SEO.

## 11. Limites e custos que o dono precisa ouvir

- CLI e funções de backend: plano Builder ou maior (abaixo dele, `callFunction` responde 403 `feature_locked`). Domínio próprio e remoção do selo: recurso de plano, configurado no Studio.
- Escrever código aqui não gasta créditos da plataforma. Gerar imagem ou código pela IA do Studio gasta créditos de criação; IA no app e canais pagos gastam créditos de integração.
- Preços: confira no site da Fabapp, não repita número daqui.

## 12. Decisões duráveis: `DECISOES.md`

O Studio tem um "manual do app" onde a IA guarda o que foi decidido. No terminal, o equivalente é o arquivo **`DECISOES.md` na raiz da pasta do projeto** (fora de `.fabapp/`, não viaja no deploy). Leia no começo de toda sessão e atualize quando algo for decidido, em frases curtas:

**Identidade** (o que é, para quem, idioma, moeda), **Marca** (paleta, fontes, raio, modo, e o porquê), **Decisões** (quem vê o quê, pagamento, chamada para ação), **Fora do escopo**, **Preferências** (tom, o que nunca fazer), **Pendências do dono no Studio** (imagens, integrações, domínio, dados).

Nunca guarde segredo, token ou dado pessoal de cliente nesse arquivo.

## Divergências conferidas

- CLI: npm publica 0.1.6; o repositório tem 0.1.7 (o `deploy` recusa arquivo não texto). Use `@latest`.
- Plano: "Builder" (docs) e "Pro+" (contrato do Studio) são o mesmo plano (código `pro`, nome Builder), que liga `cli` e `functions`.
- `@/lib/fab-sdk` não exporta `formatMoney`, `formatDate`, `callFunction`, `agent`, `RequirePlan`, `QuotaGate` nem as peças, ao contrário do que a documentação sugere; `@/lib/fab-client` exporta tudo.
- `notify` no cliente aceita também `email` (a doc do SDK omite).
- `src/components/ui/*` e as peças `fab-*.tsx` são editáveis no modo padrão `app-owned`; só a camada do SDK é imutável.
- `text-primary`: o template atual o redireciona para a cor AA; o contrato do Studio o proíbe. Use `text-primary-text`.
- Plugins: o contrato do Studio lista 4; `fab-plugins.json` tem 9.
- `fab.config.json` aceita também `kind`, `icon`, `allowed_roles` (`subdomain` só leitura); `fab.settings.json` só `auth`.
- Registros: dados e importação exigem sessão do Studio; o CLI não grava registros.
- O QA estático só roda no código gerado pela plataforma, não no `fabapp deploy`.
- `codex mcp add` não foi confirmado (Codex ausente nesta máquina); a doc da Fabapp aponta o `config.toml`.
