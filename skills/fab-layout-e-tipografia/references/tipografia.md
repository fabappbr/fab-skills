# Tipografia de tela

Regras de tipografia prática (Matthew Butterick, *Practical Typography*) adaptadas ao app da Fabapp e ao português do Brasil. Elas valem sempre: aplique ao escrever qualquer tela, sem anunciar; ao revisar uma tela existente, aponte a violação e corrija.

## Corpo primeiro
O texto de corpo define todo o resto. Quatro decisões: fonte (da marca: `bodyFont` no `theme`), tamanho (16 ou 18px), entrelinha (1,5; 1,4 a 1,6) e medida (45 a 75 caracteres, `max-w-prose`). Títulos, rótulos e espaçamentos se calibram a partir dele. A medida longa demais é o defeito número um de layouts responsivos: limite toda caixa de texto.

## Tamanho e escala
- Tela: corpo entre 16 e 18px; secundário 14px; nada abaixo de 12px. Diferenças pequenas importam: use o menor degrau que resolve a ênfase.
- Escala perto de 1,2 (12, 14, 16, 18, 20, 24, 30, 36). Em telas de operar, escala fixa e contida (1,125 a 1,2 entre degraus): muito contraste de tamanho vira ruído onde há muitos tipos de texto.
- Em página de venda, o título pode crescer por quebra a partir da base obrigatória (`text-3xl sm:text-4xl lg:text-6xl`, nunca um tamanho de computador na base); o corpo sobe junto com a largura (`text-base sm:text-lg`). Escale tamanho e largura do contêiner juntos.
- As regras não mudam com o tamanho da tela: mesma medida, mesma entrelinha, mesma hierarquia no celular.

## Títulos
1. No máximo 3 níveis (`h1`, `h2`, `h3`), em ordem, sem pular.
2. Ênfase por espaço acima e abaixo; mais espaço ACIMA que abaixo (o título pertence ao texto que vem depois): ex. `mt-12 mb-4` numa página de leitura.
3. Negrito, não itálico.
4. O menor aumento de tamanho que resolve; peso e espaço fazem o resto. Tracking que vale para todos os títulos do app vai em `theme.titleTracking` (ex.: `"-0.02em"`); entrelinha e caixa alta que valem para todos vão em `src/app-typography.css` (`@layer base`, sem nome de fonte); o que é de uma tela só fica na classe.
5. Sem caixa alta (exceto título muito curto, com espaçamento entre letras).
6. Sem sublinhado.
7. Sem centralizar (exceto título curto de topo de página de venda e estado vazio).
8. `text-balance` para quebrar bonito; sem hifenização em título.
9. Título nunca sozinho no pé de um bloco: fica junto do parágrafo seguinte.
10. Numeração, quando existir de verdade, em níveis (1, 1.1, 2), nunca romanos encadeados.

## Ênfase e formatação
- Negrito OU itálico, nunca os dois juntos. O mínimo possível: se tudo é destaque, nada é. Em fonte sem serifa, prefira negrito (itálico quase não aparece).
- Nunca negrito em parágrafo inteiro; nunca aspas para enfatizar.
- Sublinhado só em link, fino e afastado: `underline decoration-1 underline-offset-2` (ou link sem sublinhado com `text-primary-text` e sublinhado no hover, quando o contexto deixa claro que é link).
- Caixa alta só em rótulo, legenda ou título curto de menos de uma linha, SEMPRE com espaçamento: `uppercase tracking-wider text-xs font-medium`. Nunca parágrafo em caixa alta.
- Versalete só se a fonte tiver de verdade; não imite com caixa alta reduzida.
- Espaçamento entre letras: nada em minúsculas de corpo; positivo em caixa alta; negativo leve em título grande (`tracking-tight`, nunca mais apertado que `-0.04em`; vale também para `theme.titleTracking`).
- Números: `tabular-nums` em tabela, total, horário e qualquer coluna de números; algarismos padrão no resto (algarismos de estilo antigo, `[font-variant-numeric:oldstyle-nums]`, só em texto longo de leitura e se a fonte tiver).
- Fontes: nada de fonte engraçadinha, manuscrita ou de circo em negócio profissional; nada de monoespaçada em corpo (`font-mono` é fixo na plataforma e serve só para código, dado técnico ou medida). No máximo duas famílias com papéis fixos. Se a fonte da marca estiver ruim para ler, proponha ao dono o par sugerido; com o sim, grave `titleFont` e `bodyFont` no `theme` (nome exato do catálogo do Google Fonts; nome inexistente não dá erro, cai na fonte do sistema), rode `fabapp push` e anote em `DECISOES.md`. O código nunca define família.

## Parágrafos, listas, citações
- Separe parágrafos por espaço OU por recuo da primeira linha, nunca os dois. Na tela, espaço: `space-y-4` (50 a 100% do tamanho da letra). Um `<p>` por parágrafo; nunca `<br><br>` para dar espaço.
- Justificado não (o navegador hifeniza mal); centralizado só em título curto.
- Listas com `<ul>`/`<ol>` de verdade (`list-disc pl-5 space-y-1`), nunca marcador digitado; sem recuo exagerado.
- Citação em bloco: um pouco menor, recuada (`pl-6`), sem aspas (o recuo já diz que é citação), sem borda colorida lateral grossa. Use pouco.
- Linha de separação só depois de tentar espaço; 1px `border-border`, nada de padrão tracejado ou linha grossa.
- Palavra sozinha na última linha: `text-pretty` em parágrafo, `text-balance` em título.

## Pontuação e espaços
- Um espaço depois de pontuação, nunca dois.
- Exclamação: no máximo uma numa página longa; nunca em mensagem de sucesso da interface.
- "&" só em nome próprio ("Silva & Filhos"); no texto, "e".
- Emoji nunca em texto profissional de interface (chat e mensagem informal podem).
- Ponto e vírgula junta frases independentes; dois-pontos introduz o que completa.
- Pergunta é subaproveitada: um título em forma de pergunta ("Quanto custa?") abre o assunto melhor que uma frase de efeito.

## Caracteres certos no português
Em JSX, digite o caractere real no texto. Sequência de escape como `’` escrita direto entre tags aparece literalmente na tela; se precisar de escape, use dentro de chaves como string: `{' '}`. Entidades HTML (`&rdquo;`) não funcionam em JSX.

| Uso | Certo | Errado |
|---|---|---|
| Aspas | “assim” e ‘assim’ | "assim" retas no texto visível |
| Apóstrofo | caixa-d’água, Sant’Ana | apóstrofo reto |
| Reticências | … (um caractere) | ... três pontos |
| Intervalo | "10 a 20", "das 9h às 18h", "seg. a sex." | traço longo ou meia-risca entre os números |
| Pausa na frase | vírgula, dois-pontos, ponto, parênteses | travessão de efeito |
| Multiplicação e medida | 2 × 3 m | 2 x 3 m |
| Menos | −5 °C | hífen como sinal de menos em conta |
| Hífen | só em palavra composta (guarda-chuva, bem-vindo) | hífen fazendo papel de pausa ou de intervalo |
| Símbolos | © 2026 Nome, ® e ™ encostados, § 1º | (c), (R), (TM) |
| Ordinais | 1º, 2ª | 1o, 2a |
| Hora | 14h30 ou 14:30 (24h) | 2:30 PM |
| Data | 26/09/2026, "26 de setembro de 2026" (mês e dia da semana em minúscula) | 09/26/2026 |
| Dinheiro | R$ 1.234,56 via `formatMoney` (espaço que não quebra) | R$1234.56 |
| Unidade | 10 km, 5 kg, 12% | 10km |
| Telefone | (11) 91234-5678 | 11912345678 |

- Espaço que não quebra (` `) entre número e unidade, depois de "Dr." e "Sra.", depois de © e §, e entre "R$" e o valor.
- Acentos são obrigatórios em nomes próprios (Conceição, João, Luís); nunca remover acento para "caber".
- Títulos com maiúscula só na primeira palavra e em nomes próprios ("Horários de funcionamento", não "Horários De Funcionamento").
- Travessão e meia-risca (os traços longos) não entram em texto do app: além de marcar texto de IA, quebram a leitura no celular.

## Máximas de página
1. Corpo primeiro: as quatro decisões dele definem tudo.
2. Primeiro plano e fundo: a moldura (cabeçalho, menu, enfeite) não pode chamar mais atenção que o conteúdo.
3. Menor diferença visível: meio degrau resolve mais do que parece.
4. Na dúvida, faça as duas e compare; não teorize.
5. Consistência: coisas iguais com a mesma aparência.
6. O novo se relaciona com o que já existe: cada elemento limita o próximo.
7. Simples: três cores e cinco fontes? Pense de novo.
8. Imite o que é bom: tipografia bem feita de produtos que funcionam.

## Impressão
Página feita para imprimir (recibo, orçamento, ficha): `print:hidden` na navegação e nos botões, corpo um pouco menor, largura cheia, título sem ficar sozinho no pé da página (`break-after-avoid`), tabela sem cortar linha (`break-inside-avoid`).

## Tela e fundo escuro
Serifa funciona bem em tela moderna; a antiga regra "sem serifa na tela" ficou para trás. Texto claro sobre fundo escuro (seção `bg-primary`, `bg-foreground` ou modo escuro do tema) parece mais pesado e mais apertado: um pouco mais de entrelinha, às vezes um peso a menos em corpo.
