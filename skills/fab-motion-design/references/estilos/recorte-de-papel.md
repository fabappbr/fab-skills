# Estilo: recorte de papel

Formas de papel recortado em camadas, movendo em passos de stop-motion, com sombra marcada e um balanço feito à mão. Serve para infantil, escola, artesanato, confeitaria, causa social e marca afetiva.

Referência: ainda não há peça de referência deste estilo.

## Regras contáveis

- Paleta: `background` é a base (kraft ou creme), `primary` e `accent` são papéis coloridos, `text` o papel mais escuro. Sem marca: base `#f3e9d8`, verde `#2e5e52`, laranja `#f2a65a`, texto `#2b2118`.
- Tipo: serifada quente ou sem serifa arredondada (Fraunces, Nunito, Lora), peso **700 a 800**, caixa de frase, herói de **150 a 240 px**, sobre uma tira de papel (um cartão que é o herói) quando estiver sobre camada carregada.
- Tempo (30 qps): anime **em três**: cada pose fica 3 quadros (`Math.floor(frame / 3) * 3`), para o movimento andar em degraus; entradas de 9 a 15 quadros; balanço de rotação de **±1,5 grau** mudando a cada 6 quadros.
- Composição: de **3 a 5 camadas** (`<Layer depth>`), cada uma com sombra (`0 8px 0` com 20% de `text`); bordas irregulares; uma camada sangra a borda em toda cena; margens de 72 px.
- Transições: `push-*`, `stack`, `shape-blob`; uma camada de papel que entra deslizando e vira o fundo da cena seguinte.
- Textura: `<Grain>` de 0,04 a 0,07 como fibra do papel; sem desfoque, `<Glow>` ou `<LightLeak>`; `<Burst>` só como confete de papel, `count` até 24.
- Evite: deslize liso, gradiente, brilho de verniz, traço fino.
