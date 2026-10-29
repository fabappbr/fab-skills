# Estilo: tipografia cinética

O texto é o herói. Palavras enormes entram por máscara, trocam no lugar e marcam o ritmo. Serve para lançamento, produto digital, evento, aviso forte e marca sem foto.

Referência: `references/examples/launch.md` (o lançamento do Fabapp Motion).

## Regras contáveis

- Texto principal de **150 a 250 px** em 9:16; nenhuma cena com o texto principal abaixo de 96 px.
- **No máximo 4 palavras** na tela ao mesmo tempo no texto principal; frase maior vira `<WordSwap>` ou duas cenas.
- Pelo menos **3 modos diferentes** de `<Kinetic>` na peça (por exemplo `mask-up`, `outline-fill`, `scale-punch`), e nenhum modo em mais de metade das cenas.
- Pelo menos **um `<WordSwap>`** trocando na batida (`every` de 12 a 17 quadros), com `hits` de `click` nas trocas.
- Fundo: no máximo **2 cenas seguidas** com o mesmo `bg`; alterne escuro (`text`) e cor (`primary`, `accent`).
- Câmera em **toda cena** (empurrar lento, ou um mergulho no fim que leva à próxima).
- Um padrão leve (`<Grid>`, `<Dots>`, `<Rings>`) em `<Layer depth>` em pelo menos **metade das cenas**, com `alpha` até 0,15.
- Transições rápidas: `whip-*`, `push-*`, `zoom-through`, `stack`; pelo menos **uma `shape-<forma>`**.
- O momento marcante é tipográfico: a palavra que se desenha e se preenche, a marca que se desenha sob o nome.
