# Estilo: interface viva

A interface do produto é a protagonista, demonstrada: um pedido digitado, passos que se completam, um resultado que aparece. Serve para app, software, serviço online, automação e qualquer "veja como funciona".

Referência: `references/examples/launch.md` (o pedido digitado).

## Regras contáveis

- Paleta: fundo claro e calmo; `primary` é a cor da interface (botões, progresso, checks); `accent` marca o resultado. Sem marca: fundo `#f6f7fb`, `primary` `#4b2ee6`, `accent` `#7ef0b5`, texto `#14161f`.
- Tipo: a sem serifa do corpo (Inter, Plus Jakarta Sans, DM Sans), peso 600 a 700 nos títulos, 500 dentro da interface; texto da interface com **72 px ou mais**, herói de 150 a 220 px.
- Tempo (30 qps): digitação de **1 a 2 letras por quadro** (`<PromptBox step>` 1 ou 2), um check a cada **10 a 14 quadros** (`<Checklist>`), o resultado entra com mola `snappy` em até 12 quadros; a câmera mergulha na caixa no envio.
- Composição: `<PromptBox>` ou `<Checklist>` com 92% da coluna segura ou sangrando além dela; nas cenas com `ui`, a interface fica no centro e o título acima, com até 4 palavras.
- Transições: `match` da caixa para o resultado, `push-up`, `zoom-through` para dentro do botão; nenhuma `shape-*`.
- Textura: nenhuma; sombra suave só sob o cartão da interface; sem `<Grain>`, `<Burst>` nem `<Grid>`.
- Evite: moldura falsa de app (barra de status, bolinhas de janela), texto abaixo de 72 px na interface, digitação no gancho.
