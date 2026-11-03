# Estilo: tipografia cinética

O texto é o herói. Palavras enormes entram por máscara, trocam no lugar e marcam o ritmo. Serve para lançamento, produto digital, evento, aviso forte e marca sem foto.

Referência: `references/examples/launch.md` (o lançamento do Fabapp Motion).

## Regras contáveis

- Texto principal de **150 a 340 px** em 9:16, escrito com `<Kinetic fit>` sem faixa; nenhuma cena com o texto principal abaixo de 150 px. Apoio de 60 a 80 px.
- **No máximo 4 palavras** na tela ao mesmo tempo no texto principal; frase maior vira `<WordSwap>` ou duas cenas.
- Pelo menos **3 modos diferentes** de `<Kinetic>` na peça (por exemplo `mask-up`, `outline-fill`, `scale-punch`), e nenhum modo em mais de metade das cenas.
- Pelo menos **um `<WordSwap>`** trocando na batida (`every` de 15 ou 30 quadros a 120 bpm: a grade da trilha), com `hits` de `click` nas trocas só em peça sem trilha.
- Fundo: no máximo **2 cenas seguidas** com o mesmo `bg`; alterne `background`, `primary` e foto dentro do esquema da peça (claro ou escuro, `scheme` da marca). `text` ou `accent` como fundo só quando o tom deles for o do esquema (`tones`).
- Câmera em **toda cena** (empurrar lento, ou um mergulho no fim que leva à próxima).
- Padrão leve (`<Grid>`, `<Dots>`, `<Rings>`) em `<Layer depth>` é opcional: no máximo um por cena, com `alpha` até 0,15, e pelo menos **30% das cenas sem nenhum** (a textura delas é a própria tipografia: uma palavra gigante cortada pela borda, um campo de cor).
- Transições rápidas: `whip-*`, `push-*`, `zoom-through`, `stack`; pelo menos **uma `shape-<forma>`**.
- O momento marcante é tipográfico: a palavra que se desenha e se preenche, a marca que se desenha sob o nome.
