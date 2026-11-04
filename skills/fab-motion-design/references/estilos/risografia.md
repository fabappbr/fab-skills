# Estilo: risografia

Duas ou três tintas especiais sobre papel, chapas um pouco fora de registro, retícula; ousado e feito à mão. Serve para evento cultural, café, livraria, moda de rua, cerveja artesanal e marca independente.

Referência: ainda não há peça de referência deste estilo.

## Regras contáveis

- Paleta: cada cor é uma tinta: `primary` e `accent` são as duas chapas, `background` é o papel (branco quente), `text` a tinta mais escura. Sobreposição com `mixBlendMode: "multiply"`. Sem marca: papel `#f4efe3`, azul `#1d3fbf`, rosa `#ff7ab6`, tinta `#1b1b3a`.
- Tipo: grotesca pesada ou condensada (Archivo, Oswald, Bebas Neue), peso **800 a 900**, CAIXA ALTA, herói de **180 a 340 px**.
- Tempo (30 qps): degraus, não deslize: movimento **em dois** (cada valor fica 2 quadros), entradas de 6 a 10 quadros; o tremor de registro é de **4 a 8 px**, mudando a cada 4 quadros.
- Composição: o herói duplicado na segunda tinta, deslocado **6 a 12 px** (o desregistro); retícula grande (`<Dots>` com 40 a 60% de opacidade) cortada por uma borda; margens de 56 px.
- Transições: `cut`, `push-*`, `stack`, `shape-rect`; nunca `fade` nem `zoom-through`.
- Textura: `<Grain>` de **0,08 a 0,12** em toda cena (o papel); sem desfoque, `<Glow>` ou `<LightLeak>`; `<Burst count>` até 30, como pontos de tinta.
- Evite: gradiente, sombra suave, mais de três tintas, mola macia, realismo fotográfico.
