# Estilo: minimal luxo

Pouco elemento, movimento lento, contraste alto, muito espaço vazio. Serve para joalheria, moda, perfumaria, hotel, arquitetura, estética de alto padrão.

Referência: `references/examples/aurea-opus.md` é a mais próxima (tire os padrões e a partícula); a cena 6 dela é o fecho deste estilo.

## Regras contáveis

- **No máximo 3 elementos** por cena (contando texto, forma e linha; fundo e grão não contam).
- Paleta de **2 papéis** na peça inteira (por exemplo `text` e `background`), mais `accent` em **um detalhe** só.
- Título peso **300 a 400**, de **120 a 190 px**, com `tracking` aberto em caixa alta ou itálico; nunca peso acima de 500.
- Entradas lentas: `dur` de **22 a 30 quadros**, `ease` `smooth`, `outCubic` ou `inOutCubic`; nada de mola com sobra.
- Cenas de **2,6 a 3,6 s**; no máximo **5 cenas** em 15 s.
- Pelo menos **uma linha que se desenha** e **uma revelação** (`<Reveal>` ou `shape-circle`); nenhum `<Burst>`, `<Marquee>`, `<Grid>` nem `<Dots>`.
- Transições: `fade`, `match` e `shape-circle`; no máximo 1 `push-*`.
- Efeitos sonoros: no máximo **2** na peça, só `shimmer` e `click`.
