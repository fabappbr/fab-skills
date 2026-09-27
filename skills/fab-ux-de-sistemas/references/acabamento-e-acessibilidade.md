# Acabamento, princípios e acessibilidade

## Hierarquia visual

- **Um ponto focal por tela.** Nomeie o elemento principal antes de escrever a tela e faça-o vencer por tamanho, peso, contraste ou espaço em volta. O resto é rebaixado de propósito. Se tudo compete, a tela vira um estacionamento.
- **Peso e cor fazem mais que tamanho.** Três camadas no mesmo tamanho: valor `font-semibold text-foreground`, rótulo `font-medium text-muted-foreground`, metadado `text-xs text-muted-foreground`. Exemplo de número: rótulo "FATURAMENTO" `text-xs font-medium uppercase tracking-wide text-muted-foreground`; valor `text-3xl font-semibold tabular-nums text-foreground`; variação `text-xs font-medium text-success`. Se, olhando embaçado, título, texto e rótulo parecem iguais, a hierarquia está fraca.
- **Escala tipográfica com razão.** Base de 14 a 16 px e degraus visivelmente diferentes (legenda 12, corpo 14, subtítulo 16, título de seção 18, título de área 22, h1 da tela `text-3xl sm:text-4xl`). Nada de 15, 16 e 17 misturados. Título grande com `tracking-tight`; corpo com entrelinha ~1,5; `text-balance` em títulos e `text-pretty` em parágrafos.
- **Quatro níveis de texto**: principal (`text-foreground`), apoio (`text-foreground/80`), metadado (`text-muted-foreground`), desabilitado (`text-muted-foreground/60`).
- **Densidade é número.** Decida no plano e repita em todo o app: ferramenta de balcão com 12 a 16 px de respiro interno e linhas de 40 px; painel de acompanhamento com 24 px e linhas de 52 px.
- **Ritmo desigual.** Coisas relacionadas bem juntas, grupos separados por espaço real. Tudo com o mesmo espaçamento e cards do mesmo tamanho é sinal de que ninguém decidiu.
- **Proporção diz relação.** Barra lateral de 240 a 280 px ao lado do conteúdo: a navegação serve o conteúdo. Painel de detalhe de 360 a 480 px: é par da lista.
- **60/30/10.** Superfície neutra dominante, tom secundário, cerca de 10% de cor de destaque. Uma cor de destaque usada com intenção (ação, status, identidade). Cor sem motivo é ruído.
- **Estrutura por espaço e tom antes de linhas.** Use espaço em branco e mudança leve de superfície antes de bordas e divisórias.

## Superfícies, bordas e profundidade

- Superfícies empilham com diferença quase imperceptível: `bg-background` (página), `bg-card` (cartão), popover um nível acima do que o abriu. Barra lateral com o mesmo fundo da página e uma borda sutil, não outra cor.
- Campo de formulário levemente "afundado" (fundo do input do kit), não mais claro que o entorno.
- Bordas que só se notam quando se procura: `border-border` ou `border-border/60`. Se a borda é a primeira coisa que se vê, está forte demais.
- **Uma estratégia de profundidade para o app inteiro**: só bordas (ferramentas densas e técnicas), sombras suaves (telas acessíveis e arejadas) ou mudança de tom de superfície. Não misture.
- Raio em escala: controles `rounded-md`, cartões `rounded-xl`, janelas `rounded-2xl`. Raio grande em elemento pequeno fica infantil. Aninhado: raio de fora = raio de dentro + espaçamento.
- Números que mudam (contadores, preços, colunas) com `tabular-nums` para não pular.
- Imagem de dado com contorno interno sutil (`ring-1 ring-inset ring-border`).
- Evite: bordas grossas decorativas, sombras dramáticas, saltos bruscos de superfície, gradiente e cor como enfeite, várias cores de destaque, superfícies de matizes diferentes, margens negativas e posicionamento absoluto para contornar o layout.

## Movimento

- Deve animar? Ação repetida dezenas de vezes por dia (atalho, paleta de comandos, trocar de aba): não. Janelas, painéis e toasts: animação padrão. Primeiro uso e conquistas raras: pode ter um toque especial.
- Duração: toque no botão 100 a 160 ms; tooltip e popover 125 a 200 ms; menu 150 a 250 ms; janela e painel lateral 200 a 300 ms (até 500 ms só para movimento grande).
- Entrada com saída suave (`ease-out` forte); nunca `ease-in` em algo que aparece. Pressionar com `active:scale-[0.97]`; nada nasce de `scale-0` (comece em 0,95 e opacidade 0). Popover cresce a partir do gatilho; janela fica centralizada.
- Anime só `transform` e `opacity`; nunca `transition-all`. Entradas em sequência com 30 a 80 ms entre itens (`<Reveal delay>` até `Math.min(i,6)*60`); saídas mais rápidas que entradas.
- `useReducedMotion`: mantém mudança de cor e opacidade, remove deslocamento.

## Princípios que a revisão cobra

Heurísticas de Nielsen, aplicadas:
1. Status visível: carregando, salvo, onde estou, etapa atual.
2. Mundo real: palavras do dono, ordem natural (data, alfabética), calendário como calendário.
3. Controle e liberdade: cancelar, voltar, desfazer (toast "Desfazer"), sair de qualquer fluxo.
4. Consistência: mesma palavra, mesmo componente, mesmo lugar para a mesma função.
5. Prevenção de erro: restrições no campo, padrão sensato, confirmação no destrutivo, opções indisponíveis explicadas.
6. Reconhecer em vez de lembrar: recentes à mão, rótulos em vez de códigos, breadcrumb.
7. Eficiência: atalhos (Ctrl+K), ações em massa, lembrar preferências (filtro, colunas).
8. Estética minimalista: só o que a tarefa precisa; o resto em "Mais opções".
9. Recuperar de erro: mensagem clara com saída, perto do campo.
10. Ajuda: dica curta no contexto (`hint` do `Field`, `Tooltip`), voltada à tarefa.

Leis úteis:
- **Fitts**: alvo importante grande e perto; ação primária na zona do polegar no celular; 8 px entre alvos.
- **Hick**: menos opções por decisão; agrupe; destaque a recomendada.
- **Jakob**: faça como os sistemas que a pessoa já usa (busca no topo, lixeira que desfaz, ação primária à direita no rodapé do formulário).
- **Tesler**: a complexidade que não some fica com o sistema (padrões preenchidos, cálculo automático), não com a pessoa.
- **Doherty**: resposta em menos de 400 ms mantém o ritmo; acima disso, mostre progresso.
- **Pico e fim**: capriche no momento de maior esforço e no fim (confirmação clara ao concluir).
- **Zeigarnik**: tarefa incompleta é lembrada; checklist com progresso puxa para terminar.
- **Posição serial e Von Restorff**: o primeiro e o último itens são lembrados; o diferente se destaca (use só para o que importa).
- **Gestalt**: proximidade e região comum agrupam; semelhança diz "mesma função".
- Memória de trabalho é de ~4 blocos: agrupe informação; isso não limita tamanho de menu (menu se lê, não se decora).

## Acessibilidade (WCAG 2.2 AA é a meta)

- Contraste de texto 4,5:1 (3:1 para texto grande, 24 px ou 18,66 px em negrito); bordas de controles, ícones e anel de foco 3:1 (1.4.3, 1.4.11). Os tokens do tema já seguem isso: não clareie texto com opacidade abaixo de `text-muted-foreground`.
- Cor nunca é o único sinal: status com texto, erro com ícone e mensagem (1.4.1).
- Tudo por teclado, ordem de foco lógica, foco visível (2.1.1, 2.4.7) e nunca escondido por barra fixa ou rodapé (2.4.11).
- Alvo mínimo de 24×24 px (2.5.8); no toque, 44 px.
- Arrastar sempre com alternativa de clique (2.5.7): quadro kanban tem "Mover para ▾".
- Não pedir de novo o que a pessoa já informou no mesmo fluxo (3.3.7); login sem teste de memória obrigatório, com colar senha e gerenciador permitido (3.3.8).
- Todo controle com nome e função acessíveis; rótulo associado ao campo; imagem de dado com `alt`, decorativa com `alt=""`.
- Erros identificados em texto e anunciados (3.3.1, `aria-live`); mensagens de status ("3 selecionados", "Salvo") anunciadas sem mover o foco (4.1.3).
- Reflow a 320 px sem rolagem lateral e zoom de 200% sem cortar (1.4.10); espaçamento de texto ajustável (1.4.12).
- Sem vídeo com som automático; nada piscando mais de 3 vezes por segundo; respeitar movimento reduzido.
- Texto no mínimo 16 px em campos no celular (evita zoom automático); corpo 14 a 16 px, 50 a 75 caracteres por linha em textos corridos.

## Ética de interface

Aceitar e recusar com o mesmo peso; nada de frase que envergonha quem recusa; opcionais desmarcados; cancelar tão fácil quanto assinar; preço total visível cedo, sem taxa surpresa; nada de item pré-marcado no carrinho; convidar contatos nunca com "selecionar todos" por padrão.

## Dados na tela inicial

Faixa de 3 a 5 indicadores com comparação (período anterior ou meta) e definição num ícone de ajuda; 1 ou 2 gráficos principais; a tabela de trabalho logo abaixo. Linha para tendência, barra para comparar, barra horizontal ordenada para ranking, número grande para valor único; pizza só com até 6 fatias; nada de 3D, eixo que não começa em zero para barras, dois eixos verticais ou arco-íris. "Para cima" nem sempre é bom (inadimplência subindo é vermelho). Números sempre dos dados do app.
