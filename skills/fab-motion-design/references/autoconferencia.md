# Autoconferência

Rode esta lista contra o seu código antes de devolver. Qualquer "não" nas eliminatórias: corrija e confira de novo. Depois do render, a plataforma faz a revisão visual com a mesma lista sobre 5 quadros.

## Eliminatórias

- [ ] Só imports de `@fab/motion`.
- [ ] Nenhum preço, número, nota ou porcentagem escrito à mão em componente de texto.
- [ ] Nenhum depoimento fora de `reviews`.
- [ ] Nenhuma vaga de mídia gerada imita um produto que tem foto, pede pessoa realista ou pede texto legível.
- [ ] A soma das durações fecha com a duração pedida (diferença máxima de 0,2 s).
- [ ] Toda cena dura pelo menos `0,6 s + 0,3 s × palavras` e nunca menos de 1,2 s.

## Ofício

- [ ] A primeira cena É o valor ou a oferta: até 4 palavras inteiras na tela até o quadro 15 (o kit garante o quadro), sem digitação.
- [ ] A quantidade de cenas segue a duração (`references/direcao.md`): 6 a 10 s, 3 a 5; 15 s, 5 a 7; 30 s, 9 a 13.
- [ ] Nenhum título com mais de 7 palavras; nenhuma lista com mais de 5 linhas.
- [ ] As cenas têm durações diferentes; existe um pico e uma pausa antes dele.
- [ ] Nenhuma transição repetida mais de 2 vezes seguidas.
- [ ] Todo elemento entra com 2 ou 3 propriedades e escalonado.
- [ ] Nenhuma cena com tudo parado por mais de 0,8 s (fora da pausa planejada).
- [ ] A última cena tem uma `<CallToAction>` com um verbo (as palavras do dono inteiras) e fica tempo de leitura + 1 s.
- [ ] Ramo com regra própria respeitado (`references/marca-e-dados.md`).

## Composição e tipos (contando no código)

- [ ] Cada cena nova põe o conteúdo num `<Layout>` (um bloco só: rótulo, no máximo dois níveis de texto, ou uma interface, ou a chamada); cena com foto é `place="split"`.
- [ ] Nenhum `justify="flex-start"` nem `top`/`left` absoluto grudando palavras ou foto numa borda.
- [ ] Nenhuma `<Shape>`, `<Morph>` ou bolha com `x`/`y` como decoração perto de texto: decoração é `<Ornament>` ou `<Numeral>` dentro do `<Layout>`, no máximo 2 por cena, opacidade de 0,1 a 0,25.
- [ ] O título é `<Headline>` (ou um `<Kinetic fit>` de 1 a 3 palavras) sem `weight`, `tracking` nem `leading` escritos.

## Motion design (contando no código)

- [ ] Nenhum hook com memória (`useState`, `useEffect`, `useRef`...), nada de `Math.random`, `Date` ou CSS que anima.
- [ ] `blur` até 24 px; um `<Grain>` por cena com `amount` até 0,12; `<Burst count>` até 60 e no máximo dois por cena.
- [ ] Nenhum hex, `rgb()` ou nome de fonte; todo texto da tela num componente do kit (ou num seu, por `children` ou `label`).
- [ ] Pelo menos um `transition="match"`.
- [ ] Pelo menos uma `shape-<forma>` ou um `<Reveal shape>`.
- [ ] Pelo menos um `<Morph>` com 2 chaves ou um `<PathDraw>`.
- [ ] 3 tipos de transição ou mais (peça de 5 cenas ou mais); nenhum tipo em duas trocas seguidas.
- [ ] `<Camera>` em pelo menos metade das cenas; `<Layer depth>` em pelo menos 2.
- [ ] O visual principal ocupa pelo menos 60% da largura; numa cena com foto, ela é a imagem de um `<Layout place="split">` (inteira nas margens ou sangrando com `bleed`), nunca uma forma solta estacionada.
- [ ] Um esquema só (claro ou escuro) em todas as cenas; nenhum `bg="text"` sem o pedido pedir.
- [ ] Todo objeto nomeado no pedido (coração, curtida, post, botão, cursor) é `<Icon>`, `<SocialPost>`, `<Picture>` ou foto, nunca `<Shape>`; `<SocialPost>` como imagem de um `split`, sem decoração sobre as curtidas.
- [ ] Texto digitado é `<Kinetic mode="type">` (ou o `<PromptBox>`, que digita por dentro); um eixo de alinhamento por cena.
- [ ] Cena de interface: `<PromptBox>` ou `<Checklist>` do kit, texto 80 px+, caixa 92%+ ou vazando; nunca div à mão.
- [ ] Cada `sfx` e cada `hits` cai no quadro em que a coisa acontece (entrada em `at` assenta em `at + 20`); no máximo 3 `hits` por cena, um `impact` na peça, pelo menos uma cena em silêncio. `<Soundtrack sfx={false} />` do dono fica como está.
- [ ] Cada troca de cena cai na grade de batidas (120 bpm: múltiplos de 0,5 s) e pelo menos 1 em cada 3 cortes leva algo (`carry`).
- [ ] No máximo uma camada de decoração (`<Grid>`, `<Dots>`, `<Lines>`, `<Rings>`, `<Glow>`) por cena e pelo menos 30% das cenas sem nenhuma.
- [ ] Um momento marcante, marcado na folha de ritmo.
- [ ] Herói com 150 px ou mais (`<Kinetic fit>` sem faixa; numa cena de interface, a interface é o herói), apoio com 60 ou mais, rótulo com 48 ou mais; `<CallToAction>` nunca com `size` abaixo de 64, parado no último segundo.
- [ ] Nunca duas cenas seguidas com uma linha só sobre cor lisa.
- [ ] As regras contáveis do estilo escolhido (`references/estilos/`).

## A nota das baterias (10 pontos)

A bateria local e a revisão visual pontuam cada peça assim:

| Critério | Pontos |
|---|---|
| Preço e nome corretos | eliminatório (peça com erro vale 0) |
| Texto legível: tamanho, contraste, tempo de leitura | 2 |
| Dentro da zona segura | 1 |
| Gancho no primeiro 1,5 s | 2 |
| Uma ideia por cena | 1 |
| Marca aplicada: cores, fontes, logo, forma | 1 |
| Ritmo: variação, pico, calma antes do pico, cortes na batida | 2 |
| Chamada final clara | 1 |

Barra para lançar: média 8 ou mais nas 36 peças da bateria, sem nenhum erro de preço ou nome.

## Cara de IA (a revisão visual recusa)

- Abertura fraca: logo, "Conheça", "Você sabia", tela de título vazia.
- Transição de apresentação de slides em toda cena.
- Ritmo chapado, sem pico.
- Material igual do começo ao fim.
- Brilho, partícula ou explosão sem motivo.
- Forma genérica no lugar de objeto, cena clara e escura misturadas, texto fora do eixo.
- Frase genérica ("qualidade que você merece", "venha conferir").
