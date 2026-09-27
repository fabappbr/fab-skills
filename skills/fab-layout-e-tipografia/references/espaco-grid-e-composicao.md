# Espaço, grade e composição

## Composição
- **Não centralize tudo.** Uma borda esquerda fixa dá ao olho um ponto de volta a cada linha; texto centralizado em várias linhas muda esse ponto a cada linha e cansa.
- Card não precisa conter tudo: imagem pode sangrar até a borda do card (`overflow-hidden` no card, imagem sem padding) ou sobrepor o contêiner (`-mt-8` de um card sobre a foto do topo).
- Varie o tratamento em listas e feeds: um item em destaque (o primeiro post grande, o resto em 2 colunas), os demais menores. Repetição idêntica só onde os itens são mesmo equivalentes.
- Use o alinhamento para relacionar elementos que não estão juntos (o título da seção alinhado com a primeira coluna do conteúdo).
- Topo de página de venda com título curto, apoio e UMA ação pode ser centralizado com espaço generoso; conteúdo de leitura fica em `max-w-prose` alinhado à esquerda.
- Grade de destaques: `grid gap-6 sm:grid-cols-2 lg:grid-cols-3` quando os itens são equivalentes; senão, tamanhos variados (`lg:col-span-2` no destaque).
- Contêiner de página `max-w-5xl` ou `max-w-6xl` (texto e formulário mais estreitos dentro dele).
- A grade guia, não garante: grade simples dá mais consistência que grade complicada, e alinhar uma tela feia à grade continua dando uma tela feia. Colunas de texto corrido lado a lado na web ficam estranhas (o fim da coluna é indefinido): texto longo em uma coluna só.

## Pontos de quebra (Tailwind)
`sm` 640px (celular deitado), `md` 768px (tablet), `lg` 1024px (notebook), `xl` 1280px, `2xl` 1536px. Escreva primeiro o celular e acrescente por quebra: empilhado no celular, lado a lado no computador; campos de largura cheia no celular e contidos no computador; alvos de toque de 44px no celular (`h-11`). Confira em 320px e 375px.

## Conjuntos de densidade (escolha um por app, ou um por tipo de tela)

| | Acolhedor (consumo, site, cliente final) | Preciso (painel, admin, cadastros) |
|---|---|---|
| Contêiner e card | `p-6` | `p-4` |
| Entre elementos | `gap-4` | `gap-2` |
| Entre seções | `py-12` a `py-16` | `space-y-6` (24px) entre blocos da tela |
| Raio | macio: card `rounded-xl` a `rounded-2xl`, botão `rounded-full` (pílula) ou `rounded-lg` | contido: card `rounded-md` a `rounded-lg` (4 a 8px), botão `rounded-md` |
| Sombra | leve (`shadow-sm`) em card que se destaca | quase nenhuma; separação por `border-border` |
| Corpo | 16px, `leading-relaxed` | 16px no texto, `text-sm` em tabela e metadado, `leading-normal` |
| Linhas de tabela e lista | confortáveis, `py-3` a `py-4` | 40 a 44px de altura (`h-10` no computador, `h-11` no toque) |
| Ícones | contorno arredondado, 20px | 16 a 20px, com rótulo |

Loja densa (muitos produtos) é Preciso até na vitrine: cartões mostram tudo o que decide a compra (preço, frete, parcelas, nota). Consumo com poucos itens é Acolhedor: poucos fatos grandes e legíveis por card (no máximo uns seis). Card que enfeita sem informar está sempre errado.

## Raio
O raio base é da marca: `theme.radius` em `apps/<slug>/fab.config.json`, NÚMERO em px (100 ou mais vira pílula); `rounded-md`, `rounded-lg` e `rounded-xl` do kit seguem ele. Num app novo, você propõe o raio junto com o conjunto de densidade e grava com o sim do dono (`fabapp push`, anotado em `DECISOES.md`). Num app existente, não troque o raio da marca sem propor e ouvir o sim; no código, só escolha os degraus nas classes. Um sistema só no app todo. Contido: 0, 2, 4, 6px e pílula. Macio: 4, 8, 12, 16px e pílula. Regras: elemento interno tem raio = raio externo menos o padding (card `rounded-2xl` com `p-2` → imagem dentro `rounded-xl`); elementos pequenos (selo, chip) com raio menor ou pílula; imagem dentro de card acompanha o raio do card ou fica com `overflow-hidden`. Misturar raios é o que faz a tela parecer inacabada.

## Formulários
- Uma coluna em formulário simples. Duas colunas só quando os campos são irmãos (Cidade e UF, Número e Complemento), e só a partir de `sm`.
- Cada campo dentro de `<Field label error required?>`, empilhados em `<FieldGroup>`; título de seção com `<FormSection>`; envio com `<LoadingButton>`.
- Rótulo sempre visível acima do campo; placeholder só como exemplo ("ex.: ana@email.com") ou formato ("00000-000"). Placeholder some ao digitar e não é rótulo.
- Largura do campo acompanha o conteúdo esperado a partir de `sm` (no celular, todos de largura cheia): e-mail, endereço e nome de largura cheia; telefone e cidade `sm:max-w-xs`; CEP, número e UF `sm:max-w-40`. Formulário inteiro `max-w-md` a `max-w-lg`.
- Estados de campo vêm do kit (foco com anel, erro com borda `destructive` e mensagem do `Field`, desabilitado apagado). Sucesso em verde só com moderação.
- Hierarquia de botões: UMA ação principal por vista (cheia); secundária `outline` ou `secondary`; terciária `ghost` ou link; perigosa com texto `text-destructive` no gatilho e botão `destructive` só na confirmação. Ação principal à direita (computador) ou embaixo de largura cheia (celular); Cancelar à esquerda dela.
- Datas com `DatePicker`, dinheiro com `CurrencyInput`, telefone com `PhoneInput`, endereço com `AddressInput`.

## Tabelas
- Tabela quando o valor exato importa, a pessoa procura um item específico, há vários atributos por item ou os dados serão copiados. Use `DataTable` ou `Table` do kit.
- Números alinhados à direita com `tabular-nums`; texto à esquerda; mesma precisão em toda a coluna (`formatMoney` sempre com centavos).
- Bordas mínimas: só linha horizontal fina entre linhas (`divide-y divide-border` ou `border-b border-border`), nenhuma vertical, uma linha sob o cabeçalho. Espaço generoso: `px-4 py-3` na célula.
- Cabeçalho menor e apagado (`text-xs font-medium text-muted-foreground uppercase tracking-wider`), dado em tamanho normal.
- Opcionais: listras `even:bg-muted/40`, destaque ao passar o mouse `hover:bg-muted/60`, cabeçalho fixo `sticky top-0 bg-background`, ordenar pelo cabeçalho com botão acessível ("Ordenar por valor").
- No celular, tabela vira lista de cards: cada linha um card com rótulo pequeno e valor.

## Painéis
- Ordem: números-chave no topo (`StatCard`, 2 por linha no celular, 4 no computador), depois o gráfico principal (a tendência mais importante), depois gráficos de apoio e a tabela de detalhe lado a lado no computador.
- Número-chave: rótulo pequeno e apagado, valor grande (`text-2xl` a `text-3xl font-semibold tabular-nums`), variação com seta e sinal (`+12,3%`), cor de variação sempre com o sinal e a seta (não só a cor). Todo número sai dos dados do app, nunca do modelo.
- Escolha do gráfico: comparação de poucos itens → barras; muitos itens ou rótulos longos → barras horizontais; mudança no tempo → linha ou área; parte do todo → barra empilhada ou rosca com no máximo 5 fatias (mais que isso, junte em "Outros"); distribuição → histograma; valor único → número grande, não gráfico; dois números → lado a lado com a variação em %. Pizza com 2 fatias vira frase ("73% concluíram o cadastro").
- Barras: começam no zero, ordenadas por valor ou por ordem lógica (tempo), 5 a 7 barras, vão entre barras de 50 a 100% da largura da barra, valor escrito na barra quando possível.
- Linhas: eixo no zero quando fizer sentido, no máximo 4 ou 5 séries, rótulo direto na linha, pontos só ao passar o mouse ou com poucos dados, marque eventos e metas com anotação.
- Cores: as do tema (o `Chart` do kit já usa); no máximo 5 a 7 categorias; nunca só vermelho e verde para distinguir; sequência de um tom só para baixo → alto. Nada de 3D, dois eixos Y, enfeite que não é dado.
- Acessível: `aria-label` descrevendo o gráfico ("Faturamento por mês, de janeiro a junho") e a tabela dos dados como alternativa (dentro de `Accordion` "Ver em tabela").

## Estados vazios
Ícone ou imagem (não genérica), frase do que vai aparecer aqui, ação principal para sair do vazio e, se couber, uma secundária. Tom do app: leve num app de tarefas, sóbrio num painel de empresa. "Nenhum item" sozinho nunca: "Nenhum cliente ainda. Cadastre o primeiro para começar a agendar." + botão "Cadastrar cliente". Use `EmptyState` do kit.

## Estados de interação
- Passar o mouse: mudança leve de fundo, sombra um degrau acima ou cor 10% mais escura.
- Pressionado: mais escuro que o hover, `active:scale-95` a `scale-[0.98]`, sombra menor.
- Foco: anel evidente só no teclado (`focus-visible:`), nunca só a cor.
- Carregando: interação desabilitada, `Spinner` ou `Skeleton`, mesmo tamanho do conteúdo (a tela não pula).

## Navegação
- **Site**: cabeçalho com logo à esquerda levando ao início, 4 a 7 itens, ação principal na ponta direita; no celular, menu recolhido. Fixo ao rolar é opcional. Página atual marcada.
- **App**: abas embaixo no celular (3 a 5, sempre com rótulo, `md:hidden`, `pb-20 md:pb-0`, área segura); no computador, lateral ou superior. Nunca menu hambúrguer como navegação principal de app.
- **Trilha (`Breadcrumb`)**: em telas de detalhe e aninhadas; clicável exceto a página atual; itens do meio encurtados se ficar longo.
- **Abas (`Tabs`)**: sublinhado ou pílula; muitas abas no celular dentro de `ScrollRow`; configurações podem usar abas verticais no computador.
- **Menus**: abaixo do gatilho, alinhados à esquerda, virando para cima se faltar espaço; itens com ícone, atalho ou descrição quando ajuda; destrutivo em `text-destructive`; desabilitado apagado.

## Diálogos
Confirmação `max-w-md` (400 a 500px), formulário `max-w-lg` (500 a 600px), conteúdo `max-w-2xl` com altura máxima de 70 a 80% da tela e rolagem dentro do `DialogBody`; em tela cheia só no celular quando o conteúdo pede. Estrutura: título e fechar no topo, conteúdo, rodapé com Cancelar e a ação principal. Fundo escurecido é do kit. Antes de abrir um diálogo, veja se edição na linha ou `Sheet` não resolve melhor.

## Cortar texto
- Corte (`truncate` com o texto inteiro em `title`, ou `line-clamp-2`) em item de navegação, célula de tabela e título de card.
- Nunca corte corpo de texto, informação importante, resultado de busca e mensagem de erro.
