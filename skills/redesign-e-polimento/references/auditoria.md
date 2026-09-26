# Auditoria: a varredura antes de mexer

Leia os arquivos da tela (em `.fabapp/workspace/src/`) e o `theme` de `apps/<slug>/fab.config.json`, e marque cada item que aparece. Cada achado vira uma linha: **[gravidade] o quê, onde (arquivo e trecho), por que atrapalha, conserto**. A gravidade segue a escala P0 a P3 de `critica-e-heuristicas.md`. Nenhum achado sem dizer o impacto; nenhum achado não conferido no código.

## 1. Tipografia
- Hierarquia plana: título, subtítulo, rótulo e corpo com tamanhos ou pesos quase iguais. Conserto: degraus claros (ex.: `text-3xl sm:text-4xl font-bold` / `text-xl font-semibold` / `text-base` / `text-sm text-muted-foreground`).
- Só 400 e 700: faltam os pesos intermediários (`font-medium` 500, `font-semibold` 600) que fazem hierarquia sutil.
- Corpo largo demais: parágrafo sem limite ocupa a tela toda. Conserto: `max-w-prose` (cerca de 65 caracteres) ou `max-w-2xl`.
- Entrelinha apertada no corpo (`leading-tight` em parágrafo) ou frouxa em título. Corpo `leading-relaxed`/`leading-7`, título `leading-tight`.
- Corpo abaixo de 16px no celular (`text-sm` como texto principal). Só texto secundário pode ser 14px; menos que 12px nunca.
- Números em colunas sem `tabular-nums` (preços, totais, horários um embaixo do outro).
- Títulos grandes sem ajuste: `tracking-tight` em títulos grandes, nunca mais apertado que `-0.04em`; tamanho de exibição até `text-6xl` só quando a tela merece.
- Caixa alta em todo subtítulo ou parágrafo. Caixa alta só em rótulo curto, sempre com `tracking-wide`.
- Palavra sozinha na última linha do título. Conserto: `text-balance` em títulos, `text-pretty` em parágrafos.
- Texto justificado, texto centralizado em bloco de várias linhas.
- Fonte padrão sem personalidade num site de "Vender": não se conserta no código; vira proposta ao dono de um par tipográfico (`titleFont` e `bodyFont` no `theme`, nomes exatos do Google Fonts), gravado só com o sim e enviado com `fabapp push`.

## 2. Cor e superfícies
- Cor fixa no código (ache com `grep`): hex, `bg-white`, `bg-gray-50`, `text-gray-900`, `border-stone-200`. Troque pelo token equivalente (`bg-card`, `bg-background`, `text-foreground`, `text-muted-foreground`, `border-border`).
- Cor da marca gasta em decoração (ícone, borda, fundo de card) enquanto a ação principal não se destaca. A cor forte fica com a ação, a seleção e o estado.
- Mais de uma cor de destaque competindo; destaque saturado demais em estado inativo.
- Texto cinza sobre fundo colorido (lavado). Sobre `bg-primary`, use `text-primary-foreground` com opacidade (`/80`), nunca cinza.
- Estética de "gradiente roxo e azul de IA", texto em gradiente, brilho, halo sem motivo.
- Seção escura aleatória no meio de uma página clara (parece colagem). Contraste vem de um tom do mesmo tema (`bg-muted`, `bg-primary/5`).
- Sombra genérica em tudo; sombra dura deslocada (`4px 4px 0`) sem um estilo que a peça; sombras que sugerem luz de direções diferentes.
- Seção vazia, só texto em fundo liso, onde a página precisava de presença: considere uma `<AppImage slot prompt>` com véu, ou um fundo de tom da marca. Nunca imagem de banco externo ou URL solta.
- Informação que depende só da cor (vermelho = erro sem ícone nem texto).

## 3. Layout
- Tudo centralizado e simétrico. Alinhar à esquerda por padrão; centralizar só título curto de herói, estado vazio e ação única.
- Três cards iguais lado a lado como vitrine (o layout mais genérico de IA) e o herói de duas colunas com selo, slogan, dois botões e imagem. Troque por composição que nasce do conteúdo: lista com destaque, grade de tamanhos variados, rolagem lateral com `ScrollRow`, zigue-zague de no máximo duas seções seguidas.
- `h-screen`/`100vh` em seção cheia. Use `min-h-dvh` (a barra do navegador do celular pula).
- Conteúdo sem contêiner (`mx-auto max-w-* px-6` é obrigatório) ou largura fixa em px.
- Grade com mais de 2 colunas na base (celular); filho de grade ou flex sem `min-w-0` com linha larga dentro (empurra a página para o lado).
- Cards forçados à mesma altura quando o conteúdo varia; botões de cards vizinhos em alturas diferentes (fixe o botão no pé do card com `flex flex-col` + `mt-auto`); listas de itens de planos começando em alturas diferentes; títulos, preços e botões desalinhados entre colunas.
- Mesmo raio em tudo, ou raios misturados. Um conjunto só no app todo; elemento interno com raio menor que o contêiner.
- Espaço igual em todo lugar (sem ritmo): entre grupos tem de ser maior que dentro do grupo. Seções com `py-12` a `py-16`.
- Falta de respiro em página de "Vender"; densidade é certa em tabela e painel, não em vitrine.
- Painel sempre com barra lateral: no celular, app usa abas embaixo (3 a 5, com rótulo).
- Alinhamento matemático que parece torto: ícone ao lado de texto e ícone de play dentro de círculo pedem ajuste de 1 ou 2px.

## 4. Componentes
- Card em volta de tudo, card dentro de card. Card só quando a elevação diz algo; o resto se separa por espaço ou fundo.
- Sempre um botão cheio mais um botão fantasma. Hierarquia: principal (cheio), secundário (contorno ou suave), terciário (texto).
- Selo pílula "Novo"/"Beta" em tudo; eyebrow ou kicker acima de título (proibido: o título carrega o próprio peso); números de seção 01/02/03 sem sequência real.
- Borda colorida lateral com mais de 1px em card, item de lista ou alerta.
- Modal para tarefa que não precisa interromper. Prefira edição na própria linha, `Sheet` lateral ou seção que expande.
- Carrossel de depoimentos com bolinhas; tabela de planos com três torres iguais (destaque o recomendado com cor e peso, não só altura).
- Métrica gigante de herói com número inventado; brilho, anel de progresso ou retângulo com sombra no lugar de conteúdo.
- Rodapé com quatro colunas de links; simplifique para os caminhos reais e os links legais.
- Emoji ou caractere especial no lugar de ícone. Ícones do `lucide-react`, mesmo traço e tamanho (16px com texto de 12 a 14px, 20px com 16px, 24px com 18 a 20px). Metáfora gasta (foguete para "lançar", escudo para "segurança").
- Formulário com `Label` colado no `Input` em vez de `Field`/`FieldGroup`; placeholder fazendo papel de rótulo; `<input type=date>` em vez de `DatePicker`.

## 5. Interação e estados
- Botão sem estado de passar o mouse, de pressionado (`active:scale-[0.98]`), de foco visível (`focus-visible:ring-2`) ou desabilitado.
- Transição instantânea: interativos com `transition-colors duration-150` ou `duration-200`.
- Carregamento com spinner no meio do conteúdo: prefira `Skeleton` com a forma do conteúdo.
- Lista sem estado vazio (ícone, frase do que vai aparecer aqui, botão para criar o primeiro).
- Formulário sem erro na linha do campo; erro em `window.alert` (proibido, trava na pré-visualização em iframe: use `sonner` e `AlertDialog`).
- Link ou botão para `#` ou sem ação. Ou leva a um destino real, ou sai.
- Navegação sem indicar a página atual.
- Âncora que pula seco: `scroll-smooth` no contêiner que rola.
- Animação de `top`, `left`, `width`, `height`: troque por `transform` e `opacity`.
- Clique duplo salva duas vezes (sem `LoadingButton`).

## 6. Textos
- Nomes genéricos ("João da Silva", "Fulano", "Maria Souza" em toda lista), empresa "Acme", números redondos falsos (99,9%, R$ 100,00). Dado de exemplo vem marcado como exemplo; número de painel sai dos dados.
- Clichês de IA: "Eleve", "Transforme", "Revolucione", "Descubra o poder", "Sua jornada começa aqui", "soluções inovadoras", "de forma simples e rápida", "excelência em", "qualidade e compromisso", "Bem-vindo ao nosso site". Escreva o fato específico.
- Travessão usado como pausa de efeito: troque por ponto, vírgula ou dois-pontos.
- Exclamação em mensagem de sucesso; "Ops!" em erro. Direto: "Não conseguimos salvar. Tente de novo."
- Voz passiva ("Alterações foram salvas") onde a ativa é mais clara ("Salvamos suas alterações").
- Lorem ipsum. Maiúscula Em Toda Palavra do título (em português, só a primeira e nomes próprios).
- Mesma foto de avatar para pessoas diferentes: use iniciais como alternativa.

## 7. Código
- `div` para tudo: use `header`, `nav`, `main`, `section`, `article`, `footer`, `button` (não `div` clicável).
- Estilo inline misturado com classe; `z-[9999]` arbitrário (use a escala do Tailwind: `z-10`, `z-20`, `z-50`).
- Imagem com dado sem `alt` útil; `alt="imagem"`. Decorativa com `alt=""`.
- Código comentado morto, `console.log`, import de pacote que não foi instalado no workspace (`npm install` dentro de `.fabapp/workspace`) nem é fornecido pela plataforma.
- `<title>` escrito à mão (proibido: título e descrição vêm do `seo` do `fab.config.json`; rota dinâmica usa `<FabHead>` ou `useSeo`).

## 8. O que a IA costuma esquecer
- Página 404 própria (rota `*`) com caminho de volta para o início.
- Caminho de volta em toda tela de detalhe e em todo fluxo (nenhum beco sem saída).
- Validação no formulário com `zod` (e-mail, obrigatório, formato de telefone e CEP) antes de enviar.
- Link "Pular para o conteúdo" no topo de páginas longas com cabeçalho grande.
- Links de privacidade e termos no rodapé de site público. Texto legal nunca é inventado: marcador para o dono preencher.

## Nota técnica (0 a 4 por dimensão, total em 20)

| Dimensão | 0 | 2 | 4 |
|---|---|---|---|
| Acessibilidade | falha o básico (sem foco, sem rótulo, contraste ruim) | parte feita, lacunas grandes | contraste AA, teclado, rótulos, alt, movimento reduzido |
| Desempenho | lista inteira sem paginação, imagens sem tamanho | parte otimizada | paginação no servidor, imagens com proporção reservada, sem trabalho repetido |
| Celular | quebra a 375px | funciona com arestas | uma coluna limpa, toque de 44px, nada de rolagem lateral |
| Tema | cor fixa por todo lado | tokens com exceções | só tokens, claro e escuro funcionam |
| Integridade | cada tela de um jeito, genérico | alguns desvios | sistema coerente e com cara do negócio |

Faixas: 18 a 20 excelente, 14 a 17 bom, 10 a 13 aceitável, 6 a 9 ruim, 0 a 5 crítico. Diga os padrões repetidos ("cor fixa em 15 componentes") separados dos casos isolados, e diga também o que está bom e deve ficar.

## Checklist de verificação (a passada final)
Confira na pré-visualização do `fabapp dev` e lendo o código de cada arquivo alterado.
- Tarefa principal de cada tela alterada funciona do começo ao fim, com volta.
- Estados: carregando, vazio, erro, sucesso, desabilitado, texto longo, dado faltando.
- Celular (375px e 320px), tablet e computador: nada vaza, nada rola de lado.
- Foco visível, ordem de tabulação lógica, rótulos e nomes acessíveis, contraste.
- Mesma função com o mesmo visual e o mesmo nome em todas as telas.
- Nada da lista "O que nunca muda em silêncio" foi alterado sem o sim.
- Nenhum resto: código morto, import órfão, classe duplicada criada no polimento.
- Busca no código sem ocorrência: hex, `bg-white`, `text-gray-`, `font-family`, `window.confirm`, `alert(`, `animation-timeline`, `<img>` com URL externa, `await import(`, `<title>` escrito à mão.
