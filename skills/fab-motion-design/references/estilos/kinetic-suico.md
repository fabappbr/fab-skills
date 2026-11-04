# Estilo: kinetic suíço

Tipografia suíça em movimento: grade modular, UMA fonte, uma cor de sinal; as palavras são a imagem. Serve para lançamento, aviso, evento, produto digital e marca sem foto.

Referência: `references/examples/launch.md` (o lançamento do Fabapp Motion).

## Regras contáveis

- Paleta: `background` e `text` carregam a peça; `accent` é o sinal, em no máximo **uma palavra ou barra por cena**. Sem marca: fundo `#f2f0eb`, texto `#111111`, sinal `#ff3b2f`.
- Tipo: **uma família** (`heading`) para tudo, peso **700 a 900**, caixa alta ou frase na peça inteira (nunca misturado); herói de **150 a 340 px** com `<Kinetic fit>`, apoio de 60 a 80 px, alinhado à esquerda, `tracking` -0,02em.
- Tempo (30 qps): entradas de **8 a 12 quadros**, `outExpo` ou `snap`; `<WordSwap>` a cada 15 quadros na batida; pausas de 20 quadros ou mais.
- Composição: grade de **12 colunas**, margens de **64 px** em 1080 de largura; todo elemento encosta numa coluna; uma palavra sangra a borda em pelo menos **2 cenas**; números enormes e cortados.
- Transições: `cut`, `push-*`, `whip-*`, `match` sobre uma palavra; nenhuma `shape-*` além de uma `shape-rect`.
- Textura: nenhuma, ou `<Grid>` com `alpha` até 0,08; nada de `<Grain>`, `<Glow>` nem `<Burst>`.
- Evite: uma segunda fonte, parágrafo centralizado, gradiente, sombra, ícone como enfeite.
