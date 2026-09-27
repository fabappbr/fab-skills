# Wireframe em blocos

O wireframe separa estrutura de estilo. Primeiro se decide o que vai onde e em que ordem; cor, foto e efeito só depois, sobre uma estrutura que já funciona. Quando a estrutura está escolhida, ela fica travada: a fase de estilo muda cor, peso, sombra e movimento, nunca a ordem nem o conteúdo.

## As opções
- **Opção 1, segura**: estende o que já existe. Num app novo, a convenção do nicho (o que o cliente desse tipo de negócio espera encontrar); numa mudança depois, os padrões das telas que o app já tem. Nenhum paradigma novo. É a base de baixo risco.
- **Opções 2 e 3, exploratórias**: cada uma com uma filosofia de interação realmente diferente, tirada da lista abaixo (ou criada), nunca a mesma ideia com outra cor.
- Dê a cada opção um nome curto de 1 a 3 palavras ("Vitrine por categoria", "Agenda primeiro") e uma frase de filosofia.

## Filosofias de disposição

| Filosofia | Quando serve |
|---|---|
| Revelação progressiva | começa simples, o complexo aparece sob demanda |
| Painel primeiro | tudo visível de relance, densidade de dados |
| Passo a passo | fluxo em etapas guiadas (cadastro, pedido, agendamento) |
| Central e raios | uma visão geral com entrada para os detalhes |
| Lado a lado | lista e detalhe, ou comparação |
| Cards | módulos escaneáveis de mesmo tipo |
| Conversa | perguntas e respostas, estilo chat |
| Colunas (kanban) | itens por etapa ou status |
| Linha do tempo | ordem cronológica |
| Busca primeiro | a busca é a navegação principal |
| Edição na linha | editar onde o dado aparece, sem abrir tela |
| Ações no contexto | a ação aparece junto do item |
| Feed | rolagem contínua de novidades |
| Mapa no centro | o lugar é o assunto (use link para o Google Maps ou pacote de mapa sem chave) |
| Gestos | deslizar para agir, no celular |
| Paleta de comandos | busca de ações para quem usa todo dia (`cmdk`) |
| Guiado por avisos | o app chama a pessoa quando há algo a fazer |
| Botão flutuante | uma ação muito frequente sempre à mão |
| Tabela comparativa | escolher entre planos ou produtos |
| Arrastar e soltar | reordenar, mover entre colunas (`@dnd-kit`) |
| Sanfona | muitas seções, uma aberta por vez (`Accordion`) |
| Progresso com metas | etapas marcadas, sensação de avanço |

## O objetivo decide a escolha
Leia o objetivo no pedido ("mais contatos", "menos gente desistindo", "tá confuso"). Se o pedido não tem direção, use o objetivo natural da tela:
- **Mais contato ou venda**: ação clara, menos atrito, disposição que convence.
- **Menos desistência**: simplicidade, progresso visível, prevenção de erro.
- **Mais tempo na página**: profundidade de conteúdo, caminhos para explorar.
- **Achar fácil**: navegação, busca, pistas claras de onde está cada coisa.

Dê a cada opção uma nota de 1 a 5 estrelas contra esse objetivo e recomende a vencedora em 1 ou 2 frases.

## Formato no plano
Escreva a escolhida em blocos, de cima para baixo, com o peso de cada um. Notas numeradas explicam decisões de UX. Exemplo (página inicial de uma barbearia, tipo Vender, objetivo mais agendamentos):

```
Opção escolhida: "Agenda primeiro" (4/5 contra mais agendamentos)
Por que: quem chega quer saber se tem horário hoje; a foto vem depois.
[Cabeçalho] logo + nome | Serviços | Onde estamos | botão Agendar (1)
[Topo] h1 "Corte e barba no Centro, sem fila" + próximos 3 horários livres (dominante) (2)
[Serviços] lista com nome, duração e preço, 1 coluna no celular, 2 no computador
[Fotos] ScrollRow com 6 fotos do espaço
[Onde estamos] endereço, horário de funcionamento, link para o mapa
[Rodapé] WhatsApp, Instagram, privacidade
(1) a única ação cheia da página
(2) vazio: "Sem horário hoje. Ver amanhã" ; carregando: Skeleton de 3 linhas
Descartadas: "Vitrine de fotos" (2/5, bonita mas afasta do agendar); "Busca primeiro" (1/5, poucos serviços)
```

Regras do conteúdo do wireframe: texto de exemplo realista na língua do app (nunca lorem ipsum), quantidades reais de itens, e os estados que importam (vazio, carregando, erro) anotados. Rótulos de botão e menu já com as palavras finais.

## Testes de qualidade da estrutura e do estilo
- **Troca**: cubra o nome da marca. Se pudesse ser de qualquer negócio, falta personalidade.
- **Borrão**: com a vista embaçada ainda se veem a ação principal, a navegação, o conteúdo principal e a hierarquia.
- **Assinatura**: pelo menos um elemento próprio (um detalhe de composição, um uso inesperado da cor da marca, um cuidado no estado vazio).
- **Consistência**: um conjunto só de densidade e raio na tela; nada de misturar o acolhedor com o preciso.

## Vícios de aparência genérica
- Fonte neutra com gradiente roxo sobre branco (o visual padrão de IA).
- Vidro fosco por toda parte, sem motivo.
- Gradiente arco-íris em selos, bordas, tudo.
- Três cards iguais lado a lado com ícone, título e texto, mesma altura.
- Topo gigante, tudo centralizado: título, subtítulo e botão no meio de muito espaço vazio.
- Formas e manchas decorativas no fundo que não dizem nada.
- Pílula em tudo (raio máximo em cards e caixas deixa o app com cara de brinquedo; pílula é para botão em app de consumo, selo e chip).
- Texto pastel de baixo contraste que parece suave e falha na leitura.
- Sombras em direções diferentes na mesma página.

## Acabamento (fundamentos do estilo)
- **Bordas são último recurso**: separe primeiro por espaço, fundo ou sombra leve. Quando precisar, 1px `border-border`. Nunca empilhe bordas (card com borda dentro de contêiner com borda). Divisória de lista com `border-b` nos itens (`divide-y` no pai), nunca `border-top`, para não dobrar a linha na ponta.
- **Superfícies**: diferença de tom quase imperceptível separa zonas (`bg-background` e `bg-card`, `bg-muted/50`). Elevação forte só no que flutua.
- **Cor com trabalho**: ação principal, sucesso, aviso, erro ou destaque da marca. Cor decorativa sai. Página com seis cores em todo lugar não tem hierarquia de cor. Fundo com tom da marca: `bg-primary/5`.
- **Pesos**: na maior parte da interface, dois (400 no texto, 600 em títulos e ênfase), com 700 no elemento principal.
- **Estados de todo clicável**: padrão, passar o mouse (mudança leve de fundo ou sombra), pressionado (`active:scale-[0.98]` ou fundo mais escuro), foco visível (`focus-visible:ring-2 ring-ring ring-offset-2`), desabilitado (`disabled:opacity-50 disabled:cursor-not-allowed disabled:pointer-events-none`).
- **Transições**: `duration-150 ease-out` no hover, `duration-200` em mudança de layout; entrada de lista com `Reveal` (deslocamento curto, escalonado); sempre respeitando `useReducedMotion`.

## Dois níveis de acabamento
Sobre a mesma estrutura travada:
- **Limpo**: a cor da marca aplicada à estrutura, cores chapadas, sem gradiente, sem sombra além do teto, sem efeito. Padrão das telas de operar.
- **Caprichado**: a MESMA paleta e o mesmo fundo claro (caprichar nunca troca claro por escuro); o que muda é o ofício: fundo do topo com gradiente sutil do tom da marca (`from-primary/10`), sombra macia no card que se destaca, entrada escalonada com `Reveal`, elevação leve no hover de cards e botões, foco com anel da marca, detalhe de acento (um selo, uma linha fina) onde tem função. Padrão das páginas de venda.

## Armadilhas do acabamento
- Borda decorativa encostando no conteúdo: quem ganha `border-t-2` ganha `pt-4` do mesmo lado.
- Seção de fundo cheio cortada pelo contêiner: o fundo vai na `section` de ponta a ponta e o contêiner vai dentro (`<section className="bg-muted"><div className="mx-auto max-w-6xl px-6 py-16">`).
- Gradiente tão sutil que parece chapado: ou se percebe de relance, ou não use.
- Nada escapa da tela: margem negativa, posição absoluta e transformação que empurram conteúdo para fora criam rolagem lateral no celular.

## Mudança com escolha do dono
Nas mudanças depois, quando o dono pede outra disposição, pergunte com a ferramenta de perguntas de opção da sua ferramenta (no Claude Code, AskUserQuestion; sem ela, opções numeradas): as opções são as deste método descritas em palavras simples, a segura primeiro. Preferência duradoura que ele revelar ("sempre mais compacto", "nunca carrossel") vai para `DECISOES.md`, seção Preferências, para as próximas telas seguirem.
