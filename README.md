# Fab Skills

30 skills da Equipe Fabapp para construir e editar apps e sites na [Fabapp AI](https://fabapp.ai) com o seu agente de
IA no terminal: Claude Code, Codex, OpenCode, Cursor, Gemini CLI, GitHub Copilot e qualquer ferramenta que leia
skills no formato aberto (uma pasta com `SKILL.md` e `references/`).

Cada skill ensina o agente a fazer uma coisa do jeito certo na Fabapp: o modelo de dados de um CRM, as regras
brasileiras de CPF e Pix, um painel que responde uma pergunta, um site com as convenções do ramo, textos que não
parecem de robô. Todas falam com a plataforma pelo CLI [`@fabappai/cli`](https://www.npmjs.com/package/@fabappai/cli)
e trazem em `references/fabapp-cli.md` o contrato da plataforma pelo terminal.

Para sites premium com direção de arte de agência, veja também a
[Fab Agência](https://github.com/fabappbr/skills-fab-agencia).

---

## As skills

**Antes e depois de construir**

| Skill | O que faz |
|---|---|
| `leitura-do-pedido` | Transforma um pedido vago em entendimento firme: nota de clareza, perguntas com opções, o que foi dito e o que foi suposto, e a lista do que não se inventa. |
| `spec-de-sistema` | Sistemas de várias telas completos e coerentes: o que cada tela contém, campos, filtros, ações, papéis e status. |
| `verificar-antes-de-entregar` | O agente só diz "pronto" depois de conferir: compilação, busca no código, pré-visualização e deploy. |
| `corrigir-bug` | Causa antes de conserto, uma hipótese por vez, e a regra das três tentativas. |

**Base técnica**

| Skill | O que faz |
|---|---|
| `padroes-brasil` | CPF, CNPJ (inclusive o alfanumérico), telefone e WhatsApp, CEP, dinheiro, datas, LGPD, Pix e nota fiscal. |
| `modelo-de-dados` | A linguagem do negócio vira o modelo: glossário, entidades, relações, estados e dados prontos para relatório. |
| `dados-seguros` | Quem pode ler e mudar o quê, ações em massa com prévia, importação sem duplicar, pagamento confirmado só pela plataforma. |
| `codigo-react` | Regras de React para o app gerado, com impacto e exemplo errado e certo. |

**Sistemas e apps**

| Skill | O que faz |
|---|---|
| `ux-de-sistemas` | Painéis e sistemas internos com cara de software bem feito: tabelas de trabalho, estados, filtros e navegação. |
| `formularios-e-onboarding` | Formulários longos em etapas e primeiros passos que levam o cliente ao primeiro resultado. |
| `app-mobile` | App com cara de app no celular: abas, zona do polegar, toque de 44px, áreas seguras e recursos do aparelho. |
| `dashboards-e-relatorios` | Painéis que ajudam a decidir: KPI com comparação, gráfico certo para cada pergunta, números que não enganam. |

**Visual**

| Skill | O que faz |
|---|---|
| `direcao-de-arte` | Uma identidade própria para o app ou site, com paleta, fontes e um momento assinatura, sem cara de template. |
| `layout-e-tipografia` | Estrutura antes do estilo: wireframe, hierarquia, escala de espaçamento e tipografia legível. |
| `redesign-e-polimento` | Eleva um app que já existe sem quebrar nada: auditoria, nota de usabilidade e correção por ordem de risco. |
| `estilo-minimalista` | Estilo editorial: monocromático quente, contraste tipográfico e grade limpa. |
| `estilo-brutalista` | Estilo cru e industrial: grade rígida, tipografia extrema, cara de terminal. |
| `estilo-premium-suave` | Estilo de agência cara: profundidade suave, vidro, movimento com mola. |
| `da-imagem-ao-codigo` | Reproduz no app a imagem, print ou export de design que o dono mandar. |

**Sites e textos**

| Skill | O que faz |
|---|---|
| `sites-por-segmento` | O site com as convenções do ramo (salão, clínica, restaurante, loja, imobiliária...) e o mapa de páginas. |
| `landing-que-converte` | Página de campanha feita a partir das objeções do cliente, com prova no lugar certo e teste A/B. |
| `copy-que-vende` | Posicionamento, estrutura de história e títulos com revisão em sete passadas. |
| `textos-de-interface` | Regra fixa para cada texto do app: botão, erro, estado vazio, confirmação e aviso. |
| `texto-sem-cara-de-ia` | Tira os tiques de texto de IA em português, sem mudar fato e sem mexer em texto jurídico. |

**Negócio**

| Skill | O que faz |
|---|---|
| `crm-de-vendas` | CRM de PME: funil, contatos, "o que falta para fechar", lista de ligações do dia, higiene de dados e relatórios. |
| `financeiro-e-cobranca` | Orçamento que vira venda, contas a receber, régua de cobrança no tom certo e Pix. |
| `estoque-e-compras` | Quando repor e quanto comprar, pedido ao fornecedor e recebimento que bate com a conta. |
| `atendimento-e-chamados` | Central de chamados com prioridade, prazo, fila e respostas ao cliente. |
| `reputacao-e-avaliacoes` | Pede avaliação na hora certa, rascunha respostas e mostra o que os clientes estão dizendo. |
| `retencao-de-clientes` | Mostra quem está sumindo e por quê, acompanha o cliente novo e reativa quem parou. |

---

## Instalação

### Pela sua IA (o jeito mais fácil)

Abra a sua ferramenta (Claude Code, Codex, OpenCode, Cursor ou outra com acesso ao terminal) e cole:

> Instale as skills do repositório https://github.com/fabappbr/fab-skills na pasta de skills pessoais da ferramenta
> que você está usando. Cada pasta dentro de `skills/` é uma skill. Me avise quando terminar e me diga como chamar
> uma skill.

Para instalar só algumas, diga quais (por exemplo: "só `crm-de-vendas` e `padroes-brasil`").

### Com o instalador de skills (várias ferramentas de uma vez)

```bash
npx skills add fabappbr/fab-skills                     # escolhe as skills e as ferramentas numa lista
npx skills add fabappbr/fab-skills --list              # só lista as skills
npx skills add fabappbr/fab-skills -g -a claude-code codex opencode cursor gemini-cli -y   # todas, nas ferramentas indicadas
npx skills add fabappbr/fab-skills -s crm-de-vendas padroes-brasil -g                      # só estas
```

`-g` instala para o seu usuário (vale em todos os projetos); sem ele, instala só no projeto atual.

### Claude Code (marketplace de plugins)

Dentro do Claude Code:

```
/plugin marketplace add fabappbr/fab-skills
/plugin install fab-skills@fab-skills
```

As skills ficam disponíveis como `/fab-skills:<nome>` (por exemplo `/fab-skills:crm-de-vendas`) e também são
usadas sozinhas quando o pedido combina. Para atualizar: `/plugin update fab-skills@fab-skills`.

### GitHub CLI

```bash
gh skill install fabappbr/fab-skills crm-de-vendas --agent claude-code
```

### Manual

Copie a pasta da skill (inteira, com `references/`) para a pasta de skills da sua ferramenta. O `SKILL.md` precisa
ficar direto dentro da pasta com o nome da skill, por exemplo `~/.claude/skills/crm-de-vendas/SKILL.md`.

| Ferramenta | Pasta do usuário | Pasta do projeto |
|---|---|---|
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `~/.agents/skills/` (versões antigas: `~/.codex/skills/`) | `.agents/skills/` |
| OpenCode | `~/.config/opencode/skills/` (também lê `~/.claude/skills/`) | `.opencode/skills/` |
| Cursor | `~/.cursor/skills/` | `.cursor/skills/` |
| Gemini CLI | `~/.gemini/skills/` | `.gemini/skills/` |
| GitHub Copilot | `~/.copilot/skills/` | `.github/skills/` |
| Windsurf | `~/.codeium/windsurf/skills/` | `.windsurf/skills/` |
| Cline | `~/.cline/skills/` | `.cline/skills/` |
| Outras | `~/.agents/skills/` (pasta padrão entre ferramentas) | `.agents/skills/` |

Mac e Linux, todas as skills para o Claude Code:

```bash
git clone https://github.com/fabappbr/fab-skills.git /tmp/fab-skills
mkdir -p ~/.claude/skills && cp -R /tmp/fab-skills/skills/* ~/.claude/skills/
```

Windows (PowerShell):

```powershell
git clone https://github.com/fabappbr/fab-skills.git "$env:TEMP\fab-skills"
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Copy-Item -Recurse "$env:TEMP\fab-skills\skills\*" "$HOME\.claude\skills\"
```

**Claude.ai e app de desktop do Claude:** compacte a pasta de uma skill (a pasta inteira) em ZIP e envie na área de
Skills das configurações.

Ferramenta sem suporte a skills: copie a pasta da skill para o projeto e peça à IA para seguir o `SKILL.md` como
instruções.

---

## Usar

Abra a ferramenta na pasta do seu projeto e peça o que precisa, do seu jeito: "quero um CRM para minha equipe de
vendas", "o site da minha clínica ficou genérico", "o painel não mostra nada útil". A skill certa entra sozinha. Para
chamar uma específica: `/nome-da-skill` no Claude Code e no Cursor, `$nome-da-skill` no Codex.

Na primeira vez, a skill confere a configuração: Node, o CLI da Fabapp, o login e o projeto vinculado. Siga o que ela
pedir. Decisões que valem para o projeto inteiro ficam em `DECISOES.md`, na raiz da pasta, e são lidas no começo de
cada sessão.

Enquanto o agente constrói pelo terminal, não peça mudanças no mesmo app pela IA do Studio da Fabapp: as duas mãos no
mesmo código geram edições cruzadas. O Studio continua sendo o lugar de imagens, integrações, domínio, dados e
publicação.

## Requisitos

- Node.js 20 ou mais novo
- Uma conta na Fabapp AI num plano que autoriza o CLI (Builder ou maior)
- Opcional: o servidor MCP da Fabapp no seu agente (`claude mcp add fabapp -- npx -y @fabappai/cli mcp` no Claude Code;
  nas outras ferramentas, o mesmo comando no bloco `mcpServers`)

## Atualizar

- `npx skills update` (se instalou com o instalador)
- `/plugin update fab-skills@fab-skills` (Claude Code, marketplace)
- Instalou à mão: apague as pastas e copie de novo, ou peça à sua IA: "Atualize as skills do fabappbr/fab-skills."

---

## Para quem mantém este repositório

- Cada skill fica em `skills/<nome>/`: `SKILL.md`, `references/` e um `README.md` com a origem, as licenças e o mapa de
  cobertura (o que veio de cada skill de referência e onde ficou).
- `docs/fabapp-cli.md` é a fonte única do contrato da plataforma pelo terminal. Depois de editá-lo, rode
  `./scripts/sync-cli-reference.sh` para copiá-lo para `references/fabapp-cli.md` de todas as skills.
- Regras do formato, para funcionar em todas as ferramentas: `name` igual ao nome da pasta (minúsculas, números e
  hífen, até 64 caracteres); `description` até 1024 caracteres; no topo do frontmatter só `name`, `description`,
  `license` e `metadata` (texto para texto).
- Antes de publicar uma mudança: `claude plugin validate .` e `npx skills add . --list`.
- Estas skills também existem numa edição para o Studio da Fabapp AI, mantida pela equipe dentro da plataforma. O
  conhecimento é o mesmo; muda só a forma de falar com a plataforma.

## Créditos e licenças

O texto destas skills é da Fabapp AI, escrito a partir de técnicas de skills de código aberto (licenças MIT e
Apache 2.0). O `README.md` de cada skill diz de quais fontes ela veio, com a licença e o aviso de copyright de cada
uma. As fontes:

[anthropics/skills](https://github.com/anthropics/skills),
[anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins),
[obra/superpowers](https://github.com/obra/superpowers),
[vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills),
[supabase/agent-skills](https://github.com/supabase/agent-skills),
[stripe/ai](https://github.com/stripe/ai),
[pbakaus/impeccable](https://github.com/pbakaus/impeccable),
[Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill),
[nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill),
[HubSpot/agent-cli-skills](https://github.com/HubSpot/agent-cli-skills),
[LeadMagic/gtm-skills](https://github.com/LeadMagic/gtm-skills),
[wondelai/skills](https://github.com/wondelai/skills),
[softaworks/agent-toolkit](https://github.com/softaworks/agent-toolkit),
[alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills),
[rampstackco/claude-skills](https://github.com/rampstackco/claude-skills),
[szilu/ux-designer-skill](https://github.com/szilu/ux-designer-skill),
[Dammyjay93/interface-design](https://github.com/Dammyjay93/interface-design),
[julianoczkowski/designer-skills](https://github.com/julianoczkowski/designer-skills),
[ehmo/platform-design-skills](https://github.com/ehmo/platform-design-skills),
[ThomasPraun/ux-flow-designer](https://github.com/ThomasPraun/ux-flow-designer),
[Magdoub/claude-wireframe-skill](https://github.com/Magdoub/claude-wireframe-skill),
[bencium/bencium-claude-code-design-skill](https://github.com/bencium/bencium-claude-code-design-skill),
[coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills),
[humbleteam/ux-writing](https://github.com/humbleteam/ux-writing),
[content-designer/ux-writing-skill](https://github.com/content-designer/ux-writing-skill),
[blader/humanizer](https://github.com/blader/humanizer),
[msigor/humanizer-br](https://github.com/msigor/humanizer-br),
[fabricioctelles/skills](https://github.com/fabricioctelles/skills),
[alexconner-79/ill-communication](https://github.com/alexconner-79/ill-communication),
[dastoyan/skills](https://github.com/dastoyan/skills),
[NickCrew/claude-cortex](https://github.com/NickCrew/claude-cortex),
[wshobson/agents](https://github.com/wshobson/agents),
[caylent/tufte-data-viz](https://github.com/caylent/tufte-data-viz),
[aref-vc/tufte-claude-skill](https://github.com/aref-vc/tufte-claude-skill),
[kgraph57/mckinsey-style-visualization-skill](https://github.com/kgraph57/mckinsey-style-visualization-skill),
[takechanman1228/claude-ecom](https://github.com/takechanman1228/claude-ecom),
[PostHog/skills](https://github.com/PostHog/skills).
