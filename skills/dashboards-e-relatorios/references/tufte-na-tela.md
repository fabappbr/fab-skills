# Tufte na tela do celular: o que tirar, o que manter, como escrever

## Os dez princípios aplicados ao painel

1. **Mostre o dado.** Tudo que não é dado (grade, borda, legenda, fundo, ícone) compete com ele. Na dúvida, tire.
2. **Razão dado-tinta alta.** Tinta de dado é o que mudaria se o número mudasse. Para cada elemento, pergunte: se o
   dado mudar, isto muda? Se não, é candidato a sair.
3. **Apague a tinta que não é dado.** Borda em volta do gráfico, grade forte, marca de eixo em cada unidade.
4. **Apague a tinta de dado repetida.** Barra com o valor escrito, mais grade, mais eixo, mais cor diferente dizem a
   mesma coisa quatro vezes. Escolha: valor escrito ao lado da barra e eixo escondido, por exemplo.
5. **Integridade.** O tamanho visual segue o tamanho do número (fator de mentira entre 0,95 e 1,05). Barra começa em
   zero. Área não representa número de uma dimensão. Escalas iguais quando os gráficos vão ser comparados.
6. **Small multiples para qualquer recorte.** "Comparado com o quê?" é a pergunta central. Seis grupos viram seis
   gráficos pequenos na mesma escala, não seis linhas emboladas.
7. **Camadas.** Dado por cima, rótulo em seguida, estrutura (eixo, grade) o mais apagada possível. Dois elementos
   pesados juntos criam um terceiro ruído (o efeito 1+1=3).
8. **Leitura de longe e de perto.** De longe, uma forma e uma história; de perto, cada valor legível.
9. **Menor diferença eficaz.** Cinza claro contra cinza escuro basta para separar contexto e foco; cor forte fica
   para o um ou dois valores que o dono precisa ver.
10. **Palavra e dado juntos.** Número ao lado do seu desenho; sparkline dentro da tabela e do cartão; gráfico dentro
    da frase que o explica.

Resumo do próprio Tufte: mostre o dado, maximize a tinta de dado, apague o que não é dado, apague o dado repetido,
revise e edite.

## Lista do que tirar (a menos que o dono peça explicitamente)

| Tirar | Por quê | No lugar |
|---|---|---|
| Pizza e rosca | ângulo e área se comparam mal; 28% e 32% parecem iguais | barra horizontal ordenada |
| 3D em qualquer coisa | perspectiva distorce o tamanho | plano |
| Eixo duplo | inventa correlação | dois gráficos empilhados, mesmo eixo de tempo |
| Velocímetro, gauge | ocupa muito espaço para um número, sem tendência | número + sparkline + comparação, ou `GoalBar` |
| Radar, aranha | a área não significa nada | barras ou small multiples |
| Nuvem de palavras | tamanho de fonte não se lê | barra ordenada |
| Funil com afunilamento desenhado | exagera a perda | barras horizontais por etapa |
| Legenda longe do dado | faz o olho ir e voltar | rótulo direto na linha ou na barra |
| Grade forte | vira gaiola em volta do dado | nenhuma, ou horizontal bem clara |
| Borda e caixa em volta do gráfico | não informa | espaço em branco |
| Degradê, sombra, brilho, relevo | sugerem variação que não existe | cor sólida |
| Rótulo de eixo inclinado | difícil de ler | barra horizontal, ou abreviar |
| Eixo de barra cortado sem aviso | exagera a diferença | começar em zero |
| Marcador em cada ponto de uma linha longa | vira confete | só no último ponto, no máximo e no mínimo |
| Zebra em tabela | as listras ficam mais altas que os números | espaço e linha fina a cada 3 a 5 linhas |
| Animação de entrada | atrasa a leitura | nada; transição só quando o dado muda (200 a 500 ms) |
| Arco-íris de cores | sem ordem, inacessível a daltônicos | neutro + uma cor de destaque |
| Mais de 4 cores num gráfico | memória não guarda | agrupar em "Outros" ou small multiples |
| Cartão de KPI gigante sem contexto | número sozinho não diz nada | valor + variação + referencial + tendência |
| Bolinha vermelha, amarela, verde sozinha | leitura grosseira e depende de cor | texto do estado + limite + ícone |
| Grade de gráficos iguais com escalas diferentes | o dono acha que são comparáveis | mesma escala, ou avisar |
| Informação só no passar do mouse | no celular não existe mouse | toque e foco também |

Se o dono pedir algo da lista, atenda e diga em uma frase a alternativa melhor.

## Cor no painel (dentro das regras da plataforma)

A cor vem da marca, gravada em `apps/<slug>/fab.config.json → theme`, e o código só usa tokens (`bg-primary`, `text-muted-foreground`, `bg-destructive`,
`var(--success)`...). Dentro disso:
- Neutro é a cor padrão do dado; a cor primária marca o foco (o KPI principal, a série atual, o item do achado).
- Vermelho (`destructive`) só para exceção fora do limite, e sempre com texto ("abaixo da meta") e ícone.
- Verde (`success`) só para variação boa, e com sinal no texto.
- Uma cor, um significado, na tela inteira. Período anterior sempre no mesmo neutro.
- Contraste mínimo 3:1 para marcas do gráfico e 4,5:1 para texto; os tokens do tema já cumprem no claro e no escuro.
- O gráfico tem de continuar legível em tons de cinza: rótulo direto, sinal e posição carregam o sentido.

## Acessibilidade e tela

- Cada gráfico tem `role="img"` e `aria-label` com o achado ("Vendas subiram 23% de janeiro a abril, pico em março"),
  não "gráfico de linha".
- Nada só no hover: `Tooltip` abre no toque e no foco.
- Respeite `prefers-reduced-motion` (`useReducedMotion` do kit de motion).
- Modo escuro vem dos tokens; não inverta cores à mão.
- Texto do gráfico nunca menor que o do eixo; valores focais com 16 px ou mais; eixo com 12 px ou mais.

## Voz do texto em volta dos números

- Primeiro o número, depois o que significa, depois o que fazer. Nada além disso.
- Uma afirmação por frase. Frase sem número e sem decisão sai.
- Nomes reais do negócio, nunca "Métrica A", "os dados mostram".
- Um número, sem rodeio: "R$ 4,2 mil", nunca "aproximadamente cerca de 4,2 mil".
- Sem travessão, sem drama ("um salto impressionante"), sem verbo de propaganda (alavancar, potencializar,
  desbloquear, revolucionar), sem "insights acionáveis".
- "Subiu 3 pontos percentuais" (p.p.) é diferente de "subiu 3%"; nunca misture.
- Título de gráfico e de relatório afirma o achado: "Vendas subiram 12% em agosto", não "Vendas por mês". Fórmula
  de manchete: número específico + impacto no negócio + contexto para agir. Uma proposição por manchete: uma resposta
  ou uma tensão, nunca duas afirmações ligadas por "e".
- Incerteza dita com honestidade: "com 12 vendas no período, a comparação ainda é frágil".
- Teste: se parece post de rede social ou release, reescreva. Se o dono leria e diria "tá, qual é o número?", está
  perto.

## Checklist do gráfico pronto

Dado: ordenado pelo valor que importa; nenhum ponto escondido atrás de média; "Outros" pequeno o bastante para não
enganar. Honestidade: barra em zero; linha com base cortada tem o menor valor rotulado; sem área para número simples.
Tinta: grade clara ou nenhuma; sem caixa em volta; sem dado repetido; uma cor de destaque, aplicada de fato ao ponto
focal (tudo cinza também é erro: o dono não sabe para onde olhar). Rótulos: diretos, números formatados em BR.
Leitura: tamanho de texto legível num relance. Layout: nada cortado, largura 100%, sem rolagem lateral. Texto: sem
travessão, sem jargão, nomes do caso real.
