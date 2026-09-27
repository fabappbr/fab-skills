---
name: fab-redesign-e-polimento
description: "Deixa um app ou site que já existe na Fabapp com cara profissional sem quebrar nada: audita cada tela antes de mexer, dá nota de usabilidade, corrige primeiro o que atrapalha o cliente e só depois o acabamento, e nunca troca em silêncio rota, menu, campo de formulário, logo, texto legal ou texto que o dono escreveu. Use quando o dono disser: \"deixa mais bonito\", \"tá com cara de amador\", \"parece feito por IA\", \"moderniza\", \"dá uma repaginada\", \"refaz o visual\", \"melhora o design\", \"dá um tapa\", \"polir\", \"acabamento\", \"tá confuso\", \"ninguém entende\", \"mais ousado\", \"mais chamativo\", \"mais calmo\", \"mais limpo\", \"mais simples\", \"tira o excesso\", \"deixa mais legível\", \"letra pequena\", \"melhora os textos\", \"quebra com nome grande\", \"fica feio no celular\", \"tá lento\", \"revisa meu app\", \"faz uma auditoria\", \"o que dá pra melhorar?\". Qualquer nicho (salão, clínica, loja, painel, CRM), e também o site antigo trazido para refazer. Para editar apps da Fabapp AI pelo terminal com o CLI @fabappai/cli."
license: MIT
metadata:
  author: Equipe Fabapp
  version: 1.0.0
  title: Redesign e Polimento
  edition: terminal
---

# Redesign e Polimento

Esta skill melhora o que já existe. O trabalho é achar o que está atrapalhando, provar com a leitura do código, consertar na ordem de menor risco e entregar o mesmo app, reconhecível, só que melhor. Ela complementa a `fab-agencia` (site novo com direção de arte e motion de agência): aqui o ponto de partida é o que o dono já tem.

**Primeiro movimento.** Se a pasta ainda não é um projeto Fabapp configurado, siga a seção "Primeiro movimento" de `references/fabapp-cli.md` (Node, `status`, login, `create`/`link`, `pull`, `dev`, contrato ao vivo) e só então comece. Num redesign o app quase sempre já existe: `fabapp link <id>`, `fabapp pull` e `fabapp dev`. Leia `DECISOES.md` se existir.

**O contrato ao vivo vence.** Onde esta skill e `fabapp_docs`/`https://api.fabapp.ai/llms-full.txt` discordarem sobre a plataforma, siga a documentação ao vivo e avise o dono em uma linha.

**Duas mãos.** Enquanto você constrói pelo CLI, o dono não pede mudanças no mesmo app pela IA do Studio. Se ele já usou a IA do Studio neste app, publique o que é seu e rode `fabapp dev --reset` antes de continuar.

## Regras que valem em todas as etapas

**1. Primeiro o modo, depois a mão.** Classificar errado o modo é a maior fonte de redesign ruim. São dois:

| Modo | Quando | O que preserva | O que muda |
|---|---|---|---|
| **Ajuste** (preserva) | "melhora", "dá um tapa", "polir", "tá confuso", "mais legível", pedido pontual | identidade visual (cores, fontes, logo), estrutura de páginas, textos, comportamento, tudo fora do alvo | hierarquia, espaço, estados, textos de interface quebrados, consistência |
| **Repaginação** (substitui o visual) | "refaz o visual", "muda tudo", "moderniza de verdade", "não gosto de nada", marca nova | o que o app faz, conteúdo, rotas, dados, regras de acesso, navegação | o visual inteiro: o visual antigo vira só evidência do que evitar |

Nunca misture: polir um visual que o dono quer descartar é dinheiro jogado fora, e repaginar quando ele pediu um tapa é mudança escondida. Se a marca inteira está mudando (nome, público, proposta), não é redesign: é um app novo, e você diz isso ao dono.

Árvore de decisão: estrutura de páginas, conteúdo e endereços estão bons → **ajuste** com as alavancas 1 a 4 abaixo (em geral 70% do ganho com 40% do risco). A dívida é estrutural (navegação quebrada, celular quebrado, cada tela de um jeito) → **repaginação** com conteúdo preservado.

**2. Auditar antes de mexer.** Nenhuma mudança sem antes ler os arquivos da tela e registrar o estado atual: marca (cores e fontes do tema atual, lidas no `theme` de `apps/<slug>/fab.config.json`), mapa de rotas e navegação, blocos de conteúdo (o que trabalha, o que é enchimento), padrões a preservar (o que é reconhecível do negócio), padrões a aposentar (vícios de IA, layout quebrado, link morto), nível atual de ousadia, movimento e densidade (esse é o ponto de partida, não o padrão da plataforma) e o que o Google já conhece (rotas públicas e títulos, no `seo` do `fab.config.json` e nos `<FabHead>`/`useSeo` das páginas). A varredura completa está em `references/auditoria.md`; aplique a tabela inteira.

**3. Alavancas em ordem de risco.** Aplique nesta ordem e pare quando o pedido estiver atendido:

1. **Tipografia**: tamanhos, pesos, entrelinha, medida da linha (por classes Tailwind; a família de fonte vem da marca, no `theme`).
2. **Espaçamento e ritmo**: escala fechada, grupos, respiro entre seções.
3. **Cor**: só pelo tema da marca (veja "Como mudar cor, fonte e marca"); no código, corrigir onde a cor da marca está sendo gasta em decoração.
4. **Movimento**: microinterações e estados, no nível que o app já tem.
5. **Recomposição** do topo da página ou de uma seção chave.
6. **Troca de bloco inteiro**, só quando o bloco não tem conserto.

**4. O que nunca muda em silêncio.** Sem pedido explícito do dono, você não altera:
- rotas e endereços (`path` em `src/routes.tsx`, slugs, âncoras `id` de seção): quebram links, favoritos e o Google;
- rótulos da navegação (abas, menu, cabeçalho) e a ordem deles;
- nomes e ordem dos campos de formulário, ids de modelo e de campo do `fab.schema.json`;
- logo e nome da marca;
- textos legais, de consentimento, de privacidade e termos;
- textos que o dono escreveu (os que vieram dele na conversa, em `DECISOES.md` ou que são fato do negócio: preço, endereço, horário, nome de serviço, depoimento, política);
- nomes de eventos `trackEvent` (relatórios dependem deles);
- a voz dos textos (tratamento por "você" ou "tu", tom formal ou descontraído);
- títulos e descrições de página que o Google já indexou (`<FabHead>`/`useSeo` e o `seo` do `fab.config.json`): mexer em página pública que já aparece na busca é o maior risco de um redesign.

Quando uma dessas mudanças melhoraria o app, você **propõe** na mensagem final com o motivo e espera o sim. O que já funciona em acessibilidade (foco visível, textos alternativos, contraste) nunca piora.

**5. O pedido do dono vence o seu gosto.** Se o dono fixou uma estética, uma cor, uma fonte ou um estilo (mesmo um que a lista de vícios de `references/auditoria.md` desaconselha), respeite. Redirecionar um pedido claro para o seu gosto é falha.

**6. Nada inventado.** Redesign não acrescenta depoimento, número de clientes, nota, prêmio, preço ou selo que o dono não deu. Onde a seção nova precisa de prova e ela não existe, a tela mostra um marcador claro ("Adicione aqui um depoimento real") ou a seção não entra.

**7. O tipo de tela muda o que é "melhor".** Decida por rota, não pelo app:

| Tipo de tela | Exemplos | "Melhor" significa |
|---|---|---|
| **Vender** | página inicial pública, landing, preços, vitrine | chamar atenção e levar a UMA ação; expressão permitida |
| **Operar** | painel, agenda, cadastro, admin, tudo depois do login | achar rápido, consistência, densidade certa; a marca vive nos detalhes; nada de slogan onde deveria estar o dado |
| **Ler** | blog, ajuda, política, aula em texto | compreensão: medida de 45 a 75 caracteres, títulos que guiam |
| **Mostrar** | portfólio, galeria | o trabalho do dono na frente; a interface some |

A landing de uma ferramenta continua sendo "Vender"; a área logada da mesma empresa é "Operar". Não levar o herói da landing para dentro do app.

**8. Verificar em passadas limitadas.** Construir tudo, conferir uma vez em lote (celular e computador juntos, na pré-visualização do `fabapp dev` e lendo o código de cada tela alterada), corrigir tudo o que a conferência mostrou numa leva só, confirmar com no máximo mais uma rodada e parar. Autoconferência sem fim gasta o tempo do dono sem melhorar o resultado. Lembre que o `fabapp deploy` não passa pelo QA do gerador da plataforma: a conferência em lote (render, responsivo, lista de conferência, busca no código) é sua.

## Como mudar cor, fonte e marca

No terminal, você DEFINE cor, fonte e raio. O único lugar é `apps/<slug>/fab.config.json → theme` (chaves reais em `references/fabapp-cli.md`, seção 4):

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

- **O caminho de toda mudança de marca**: proponha ao dono (valores e o porquê), peça aprovação, grave no `theme` (depois de `fabapp pull`), rode `fabapp push` e anote em `DECISOES.md`, seção Marca. O tema só aparece no ar no próximo `fabapp deploy`.
- **Cor**: a paleta é da marca do app. `mode` é `light`, `dark` (usa a paleta `dark`) ou `system`. `primaryFg` é o texto sobre o preenchimento da marca; a cor de texto AA da marca (`primaryText`) é derivada, não a escreva. Não existe preset no terminal: você escreve os valores (`primary`, `bg`, `card`, `text`, `accent`, `destructive` e o bloco `dark`). Nunca edite CSS para mudar cor. No código, só tokens: `bg-background`, `bg-card`, `bg-muted`, `text-foreground`, `text-muted-foreground`, `bg-primary`, `text-primary-foreground`, `text-primary-text`, `border-border`, `text-destructive`, com opacidade quando precisar (`bg-primary/10`).
- **Fonte e raio**: `titleFont` e `bodyFont` pelo nome exato do catálogo do Google Fonts (nome inexistente não dá erro: o app sai na fonte do sistema); `titleTracking` para o espaçamento dos títulos; `radius` é NÚMERO em px (100 ou mais vira pílula). Se a auditoria achar que a fonte ou o raio são o problema (fonte padrão sem personalidade num site de "Vender", fonte difícil de ler), diga ao dono qual par ou raio sugere e por quê, e grave com o sim.
- **Logo**: o dono sobe no Studio (entra na lista do que ele faz no Studio), e só quando ele pedir ou mandar a logo. O nome da marca no app muda só a pedido do dono.
- **O que a skill decide no código**: tamanho, peso, entrelinha, espaçamento entre letras e medida, por classes Tailwind nas páginas. Ajuste global de títulos (espaçamento entre letras, entrelinha, caixa alta) vai em `src/app-typography.css`, dentro de `@layer base`, famílias só por `var(--font-display)` e `var(--font-sans)`, nunca nome de fonte (se o `deploy` avisar que ignorou o arquivo, aplique pelas classes nas páginas). `font-mono` é fixo (JetBrains Mono) e só serve para código e dado técnico. Nada de hex, `font-family` nem edição de `src/index.css` ou `src/fab-theme.css`.
- **Mais calmo ou mais ousado pela cor**: em Ajuste, não mude a cor da marca por conta própria; proponha ("posso deixar o verde um pouco menos vivo?") e só grave no `theme` com o sim, ou quando o pedido já foi sobre a cor.

## O que o dono pode pedir (e o que cada pedido faz)

Cada pedido abaixo é um modo de trabalho. O detalhe de cada um está em `references/modos-do-dono.md`; aplique o modo inteiro.

| O dono diz | Modo | Resumo do que você faz |
|---|---|---|
| "revisa", "o que dá pra melhorar?", "auditoria" | Crítica | só audita e dá nota; lista achados P0 a P3 e sugere os pedidos seguintes; não muda nada sem o sim |
| "polir", "acabamento", "dá um tapa" | Polir | passada final: estados, consistência, alinhamento, textos de interface, limpeza |
| "mais ousado", "sem graça", "mais chamativo" | Ousado | sobe UMA parte para a força que o resto do app já tem, sem cor ou fonte nova |
| "mais calmo", "tá gritando", "poluído" | Calmo | menos peso, menos cor, mais respiro, movimento mais curto; sem ficar genérico |
| "mais simples", "destilar", "tira o excesso" | Destilar | um objetivo por tela, corta repetição e enfeite; funcionalidade some só com o sim |
| "mais legível", "letra pequena", "cansa ler" | Legível | corpo 16px ou mais, entrelinha 1,5, 45 a 75 caracteres, hierarquia por peso |
| "endurecer", "quebra com nome grande", "e se não tiver nada?" | Endurecer | textos longos, listas vazias, números grandes, formatos BR, erros e cliques duplos |
| "melhora os textos", "ninguém entende o botão" | Clarear | textos de interface: ação com verbo, erro que diz como resolver, vazio que orienta |
| "o cliente se perde na primeira vez" | Primeiro uso | estados vazios que ensinam, caminho curto até o primeiro resultado |
| "fica ruim no celular" | Adaptar | uma coluna, toque de 44px, ação na zona do polegar, nada que dependa de passar o mouse |
| "tá lento", "demora pra abrir" | Otimizar | paginação no servidor, imagens com tamanho reservado, menos trabalho por render |
| "sem cor", "tudo cinza" / "arruma o espaçamento" / "tá parado" / "sem personalidade" | Colorir / Layout / Movimento / Personalidade | cor com função (pela marca), ritmo e agrupamento, movimento que explica estado, um detalhe próprio do negócio |

Efeito de vitrine (parallax pesado, rolagem cinematográfica, texto que se monta) em site de "Vender": você pode sugerir ao dono a skill `fab-agencia`, que é feita para isso (se estiver instalada, ela manda nisso).

## Antes de começar

1. Primeiro movimento (acima): pasta vinculada ao app, `fabapp pull` feito, `fabapp dev` rodando, contrato ao vivo lido.
2. Leia `DECISOES.md`: o modo que o dono já escolheu, preferências ("nunca modal", "manter o verde da logo", "sempre tratar por você"), o público (Identidade) e a marca.
3. Leia o `theme` e o `seo` de `apps/<slug>/fab.config.json` e `src/routes.tsx`: é a marca e o mapa de rotas que a auditoria registra.

## A conversa

Pergunte ao dono com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion); sem ela, uma mensagem curta com as opções numeradas. Opção recomendada primeiro.

### Quando o dono traz algo que já existe fora da Fabapp

Vale quando o dono quer refazer na Fabapp um site ou app que já tem (manda o endereço, um print ou descreve o atual). O objetivo é sair da conversa sabendo o modo e com o conteúdo a preservar anotado.

1. Se ele mandou um endereço, abra com a ferramenta de busca ou leitura web da sua ferramenta (sem ela, peça prints ou o texto das páginas) e anote em silêncio: páginas e menu (rótulos exatos), textos de fato do negócio (serviços, preços, horários, endereço, telefone, políticas), cores e fontes que aparecem, o que é reconhecível. Isso vira conteúdo a preservar, não inspiração vaga.
2. Pergunte só o que muda o app:

**"O que você quer do visual atual?"**
- Manter a cara, só deixar mais profissional (Recomendado quando o dono gosta da marca)
- Mudar o visual todo, mantendo o conteúdo
- Começar do zero, marca nova

**"O que mais incomoda hoje?"** (múltipla escolha)
- Está confuso, o cliente não acha as coisas
- Está com cara de amador ou de modelo pronto
- Fica ruim no celular
- Os textos estão longos ou confusos

**"Tem alguma parte que não pode mudar?"**
- Os textos e preços que estão lá hoje (Recomendado)
- O nome das páginas e do menu
- As cores e a logo
- Pode mexer em tudo

3. Registre em `DECISOES.md` o modo em uma frase ("Refazer mantendo a identidade" ou "Visual novo com o mesmo conteúdo"), os rótulos de menu e os textos de fato que ficam iguais, e o que incomoda. A marca vai para o `theme`: no modo **Ajuste**, repita as cores, as fontes (as mais próximas do Google Fonts) e o raio do site atual; na **Repaginação**, proponha novas e registre nas suposições do plano que a antiga foi descartada a pedido. Site atual de fundo escuro: escreva a cor exata (o preto-carvão do site) em `bg`, ou em `dark.bg` com `mode: "dark"`, com o bloco `dark` inteiro preenchido (armadilha: pedir só "escuro" sem escrever as cores do site faz o app sair num escuro que não é o dele). Tudo o que você deduziu sem o dono dizer vai nas suposições do plano.

### Quando o app já está na Fabapp: decidir o modo

Leia o pedido. "Refaz", "muda tudo", "não gosto de nada" = Repaginação. Pedido pontual ou "melhora" = Ajuste. Se não der para saber e a diferença muda o resultado, pergunte antes do plano, opção recomendada primeiro:

**"Como você quer que eu mexa?"**
- Manter a cara do app e caprichar no acabamento (Recomendado)
- Mudar o visual inteiro, mantendo o que o app faz e os textos
- Só a tela que você citou

Se o dono já escolheu antes (está em `DECISOES.md`), não pergunte de novo.

## O plano

Vale para o plano de um app que refaz um site existente e para o plano de uma edição de redesign. O plano é um texto que você escreve e mostra ao dono antes de codar; ele aprova antes da construção.

### Ler e auditar (antes de escrever o plano)

Leia `src/routes.tsx`, as páginas do alvo em `src/pages/`, os componentes delas em `src/components/` (não o kit `src/components/ui/`) e o que elas importam de `src/lib/`. Pedido vago ("melhora o app") = a rota inicial, a navegação e as 2 ou 3 telas mais usadas. Anote os `path` de `src/routes.tsx` e os rótulos da navegação como estão: é contra essa lista que você confere no fim.

Faça o julgamento de design (especificidade, hierarquia, se a tela serve ao cliente) ANTES da varredura mecânica: a lista de vícios ancora o olhar e faz a crítica virar caça a detalhe.

Faça a varredura por categoria de `references/auditoria.md` (tipografia, cor, layout, componentes, estados, textos, movimento, acessibilidade, desempenho, código e o que a IA costuma esquecer) e a crítica de `references/critica-e-heuristicas.md` (Nielsen 0 a 4, carga cognitiva, teste do porta-malas, personas). Antes de olhar os detalhes, responda: **esta tela poderia ser de outro negócio sem mudar nada?** Se sim, falta especificidade, e isso entra como achado.

### Triagem

Separe defeito funcional de cosmético e conserte nesta ordem:
1. tarefa quebrada ou bloqueada, dado que some, estado enganoso, caminho inacessível;
2. estados faltando: carregando, vazio, erro, sucesso, desabilitado, sem permissão;
3. fluxo, hierarquia, celular, inconsistência entre telas;
4. inconsistências de visual e de movimento;
5. limpeza de código.

Não deixe um canto perfeito e o resto abaixo da mesma barra. Com 3 ou mais achados P0/P1 e um pedido vago, corrija os P0/P1 e liste o resto como próximos passos.

### O que o plano traz

1. **Diga o modo e o tipo de cada tela** no início do plano ("Ajuste; Início = Vender, Agenda e Clientes = Operar").
2. **Liste as mudanças, cada uma com gravidade e alavanca**, na ordem P0 → P3 (no plano de uma edição, que é curto, agrupe em até 6 itens, os mais graves primeiro) (escala em `references/critica-e-heuristicas.md`): "P1, espaçamento: a lista de clientes junta nome, telefone e botões sem separação; agrupar com `gap-2` dentro do item e `gap-4` entre itens". Mudança de marca (valores do `theme`) entra aqui como item próprio, com os valores propostos.
3. **Escreva "O que NÃO vamos mudar"** com as rotas, rótulos de menu, campos, textos do dono e marca que ficam como estão. Isso protege o dono e a construção.
4. **Suposições**, cada uma com a alternativa (o que você deduziu sem o dono dizer).
5. **A lista de conferência**: cada mudança conferível vira um item, marcado como "código" (confere por leitura ou busca no código) ou "tela" (confere só na pré-visualização). Entram TODOS os que se aplicam, sem teto. Candidatos que valem quase sempre:
   - "Nenhuma rota de `src/routes.tsx` mudou de caminho; os rótulos das abas continuam iguais" (código; sempre)
   - "Toda lista tem estado vazio com uma ação, estado de carregamento com Skeleton e estado de erro com botão Tentar de novo" (código; se a skill `fab-ux-de-sistemas` estiver instalada, ela manda nos estados de lista)
   - "Todo botão que salva usa `LoadingButton` e fica desabilitado enquanto salva" (código)
   - "Nenhuma classe de cor fixa (hex, `bg-white`, `text-gray-*`); só tokens do tema" (código)
   - "Cada tela tem UMA ação principal com `bg-primary`; as outras são secundárias ou texto" (código)
   - "Valores em dinheiro com `formatMoney`, datas com `formatDate`, nada cortado de `toISOString()`" (código)
   - "Nomes de 60 caracteres e valores de R$ 1.234.567,89 não quebram o layout a 320px" (tela)
   - "Texto corrido com no máximo 75 caracteres por linha (`max-w-prose` ou `max-w-2xl`)" (código)
   - Mais os itens de marca, quando houver: "o `theme` tem os valores aprovados e o `fabapp push` passou" (código).
6. **Repaginação**: descreva a nova direção em três linhas (tom, densidade, o elemento que dá personalidade), com a paleta, o par tipográfico e o raio que vão para o `theme`, e diga que o visual antigo não volta em pedaços.
7. Nunca prometa no plano o que a plataforma não faz (cor ou fonte escrita no código ou em CSS em vez do `theme`, medir velocidade real).

## A construção

- **Cor, fonte e raio: só pela marca.** Com o plano aprovado, grave o `theme` (veja "Como mudar cor, fonte e marca") e rode `fabapp push` antes do código. Nada de hex, `bg-white`, `text-gray-*` ou `font-family` no código.
- **Todo o resto com as ferramentas de arquivo da sua ferramenta**, cirúrgico: só os arquivos do alvo, dentro de `.fabapp/workspace/src/`. Reaproveite o componente do kit que já resolve o padrão (`Field`/`FieldGroup`, `PageHeader`, `LoadingButton`, `ConfirmDialog`, `EmptyState`, `Skeleton`, `StatCard`, `ScrollRow`, `Sheet`) em vez de variar à mão.
- Nunca edite `src/index.css` nem `src/fab-theme.css`. Um componente de `src/components/ui/*` só é editado quando a mudança é de aparência de TODAS as telas (o mesmo botão, o mesmo card) e nunca para um caso isolado; o único CSS que você toca é `src/app-typography.css`. Se o `deploy` avisar que ignorou um desses dois (app do modo antigo), faça a mudança pelas páginas.
- Mesma função, mesmo visual: se o botão Salvar tem duas caras em duas telas, uma delas está errada. Corrija as duas para a mesma.
- Trabalhe com a pilha que existe: não troque biblioteca (ícones continuam `lucide-react`), não migre padrão de estilo; pacote novo só se a mudança precisar, com `npm install <pacote>` dentro de `.fabapp/workspace` (nunca declare os que a plataforma já fornece).
- Imagem nova de layout é `<AppImage slot prompt alt />`, uma por linha, nunca dentro de `.map()`. Foto do próprio dono: não entra pelo terminal (binário nunca vai para o workspace); vira um slot `AppImage` que o dono troca pela foto dele no Studio.
- Decisão duradoura do dono ("nunca modal", "manter o verde da logo", "sempre tratar por você") vai para `DECISOES.md` (Preferências ou Marca).

## Conferir antes de dizer pronto

Uma passada, no máximo mais uma.

1. **Compilação**: `npx tsc -b` e `npx vite build` dentro de `.fabapp/workspace` quando puder.
2. **Na tela**: com `fabapp dev` rodando, abra cada rota alterada no celular (375px e 320px) e no computador, console aberto, e percorra cada item "tela" da lista de conferência.
3. **No código**: releia uma vez cada arquivo alterado contra o checklist de verificação de `references/auditoria.md` e contra a lista "O que nunca muda em silêncio". Compare os `path` de `src/routes.tsx` e os rótulos da navegação com os anotados na auditoria. Busque (`grep`) nos arquivos alterados: hex (`#[0-9a-fA-F]{3,8}`), `bg-white`, `text-gray-`, `font-family`, `window.confirm`, `alert(`, `prompt(`, `animation-timeline`, `<img` com URL externa, `import(` dinâmico, `<title>`. Cada ocorrência é defeito, salvo `<img>` com `src` vindo de campo de registro.
4. Corrija tudo numa leva, confira de novo uma vez e pare.
5. **Publicar**: `fabapp push` se o `theme` ou o `seo` mudou, depois `fabapp deploy`. Leia a saída inteira. `account_builds_busy` (409): a conta já tem 2 builds rodando; espere e repita. `build_failed` (422): o código não compila, a mensagem traz arquivo, linha e coluna; não repita, conserte.

### A mensagem final ao dono

Em português simples, curto:
- o modo usado, numa frase;
- o que mudou, por tela, em linguagem de resultado ("a lista de clientes agora separa cada cliente e mostra o telefone em destaque");
- a nota de usabilidade antes e depois, dizendo que é estimada pela revisão do código ("de 22 para 31 em 40, estimada");
- o que ficou igual de propósito;
- o que você **propõe** mas não fez porque mexe em algo protegido (rota, menu, texto do dono), com o motivo;
- o link no ar;
- o que ele faz no Studio (logo, trocar os slots de imagem pelas fotos dele, domínio, dados), se houver;
- 2 ou 3 pedidos prontos que o dono pode mandar, tirados dos achados ("Deixar mais legível no celular", "Melhorar os textos dos botões", "Deixar mais ousado só a página inicial").

No modo Crítica, os achados P0 a P3 ficam escritos na mensagem final e resumidos em `DECISOES.md`: é deles que o próximo pedido ("polir", "endurecer") parte, e o polimento que resolver todos diz isso.

Só declare feito o que foi conferido. Nunca diga que mediu velocidade ou testou num aparelho real.

## Mudanças depois

- Cada novo pedido de redesign é o mesmo fluxo em escala menor: modo (sem repetir a pergunta se está em `DECISOES.md`), auditoria do alvo, plano curto (até 6 itens), construção, conferência.
- Se o dono trocou slots de imagem no Studio ou usou a IA do Studio, faça deploy do que é seu e rode `fabapp dev --reset` antes de editar de novo, ou o próximo deploy apaga as trocas.
- Mudança de cor, fonte ou raio pedida depois: mesmo caminho (proposta, sim, `theme`, `fabapp push`, `DECISOES.md`, `fabapp deploy`).
