# Calibração dos vícios e piso de qualidade

## Os seis rostos do app feito por IA (com valores)

Cada um é legítimo quando o dono pede. Quando o eixo está livre e a direção cai num deles, você não decidiu, só
repetiu. Os valores em hex abaixo servem para reconhecer o vício ao fechar a marca na conversa com o dono; hex só entra
no `theme` do `apps/<slug>/fab.config.json`, nunca no código do app (lá só existem tokens do tema). A regra: se alguém adivinha a sua estética só pelo setor, ou pelo setor mais "o contrário do óbvio", refaça.

1. **Creme, serifa e terracota.** Fundo creme perto de #F4F1EA (família: #f5f1ea, #f7f5f1, #fbf8f1, #efeae0,
   #ece6db, #faf7f1, #e8dfcb), título em serifa de alto contraste muitas vezes em itálico (Fraunces, Playfair,
   Instrument Serif), destaque terracota ou argila perto de #D97757 (família: #b6553a, #bc7c3a, #b08947, #9c6e2a,
   #9a2436, #7d5621), texto quase preto quente (#1a1714, #1b1814). É o padrão de tudo que é "artesanal", "café",
   "cosmético natural", "premium". Alternativas que giram: verde floresta com osso e âmbar; preto de verdade com
   caramelo, sem bege; cobalto com um único neutro; ferrugem com ardósia; oliva com tijolo; monocromático com um
   único acento saturado.
2. **Quase preto com um neon.** Fundo #0B0B0B ou #111 com um único verde ácido (#c6ff00, #a3e635, #39ff14) ou
   vermelhão, bordas brilhando (glow), halo radial atrás do título. É o padrão de "tecnologia", "academia", "noite".
3. **Jornal de filetes.** Filetes finos em toda parte, raio zero, colunas densas de jornal, rótulos pequenos em mono
   com espaçamento largo, serifa itálica. Padrão de "editorial", "revista", "escritório sério".
4. **Kit de cards SaaS.** Tudo picado em cards arredondados idênticos, o mesmo raio em tudo sem hierarquia, a mesma
   sombra cinza rgba(0,0,0,.1) embaixo de cada um, gradientes lavados de decoração, três cards de ícone, título e
   texto, número gigante com legenda pequena no herói.
5. **Cromo de modelo pronto.** Rótulo em CAIXA ALTA com letras espaçadas acima de todo título; metadados unidos
   por ponto médio ("A · B · C"); rótulo "PALAVRA, fragmento" com travessão; quase preto tingido no lugar do preto;
   mono em rótulos pequenos; seta "→" colada no texto de todo botão e link; numeração 01 / 02 / 03; pílula acima do H1.
6. **Roxo de IA.** Gradiente de roxo para índigo (`from-purple` `to-indigo`, violeta), o próprio roxo padrão desta
   plataforma (#742fc2), brilho roxo em botão, blobs de gradiente flutuando.

Vieses específicos a vigiar: tema acolhedor, familiar, de livro ou infantil sai em creme, serifa itálica e luz de
abajur mesmo quando a direção não pediu (o mundo do livro tem pano de capa, linha de costura, guarda colorida; o
creme é o menor canto dele). Uma referência fixada pelo dono fixa o mundo, não a versão mais mole dele. Restrição
negativa ("sem gamificação", "sem exagero") tira o artifício, não a energia; adjetivo de comportamento ("apoio
calmo") não dita a energia da superfície.

## Clichês de texto em português (reescreva)

Verbos e frases vazias: "Eleve", "Transforme", "Revolucione", "Potencialize", "Descubra o poder", "Sua jornada
começa aqui", "soluções inovadoras", "de forma simples e rápida", "excelência em", "qualidade e compromisso",
"Bem-vindo ao nosso site", "o melhor da região", "atendimento diferenciado", "tudo o que você precisa em um só
lugar". Poesia de IA: trocadilho que não fecha, metáfora forçada, humildade encenada, rótulos de artesão fingido
("Do nosso ateliê", "Notas de campo", "Na bancada"). Texto fofo de IA é pior que texto sem graça: na dúvida, frase
funcional.

Efeito "João da Silva": nada de "Fulano", "João Silva", "Maria Souza" repetidos, nada de "Acme", "Nexus",
"SmartFlow". Dado de exemplo usa nomes brasileiros variados e plausíveis e fica marcado como exemplo. Número com
precisão falsa (92%, 4,1x, "mais de 3.000 clientes") só se vier dos dados do app ou do dono; caso contrário não
existe. Depoimento, prêmio, nota do Google, CNPJ e registro profissional nunca são inventados: o lugar fica marcado
para o dono preencher.

## Piso de qualidade: conferir (no app pronto)

- Contraste: corpo e placeholder 4,5:1; texto grande, ícone que informa, borda de controle e anel de foco 3:1. Em
  superfície colorida, o texto secundário sai da própria cor (`text-primary-foreground/80`), nunca cinza.
- Profundidade: sombra com deslocamento e desfoque suave; halo colorido sem deslocamento é enfeite.
- Espaço: grupos apertados, separação generosa, mais espaço acima de um título do que abaixo dele.
- Tipo: corpo com medida de 65 a 75 caracteres (`max-w-prose`), corpo nunca abaixo de 16px, título no máximo 6rem
  (`text-8xl`), espaçamento de letras nunca abaixo de -0.04em, títulos com `text-balance`, degraus de tamanho e peso
  óbvios. Rode o texto real em todos os tamanhos e corrija o que estoura.
- Movimento: um momento autoral, não a mesma entrada em toda seção; saída mais rápida que a entrada; sempre partindo
  de um estado já visível (conteúdo nunca escondido esperando animação).
- Estados: hover, foco visível, ativo, desabilitado, carregando (skeleton no formato final), erro, vazio. Conteúdo
  real, controles que funcionam, composição responsiva, teclado.
- Superfícies do navegador: seleção de texto (`selection:bg-primary selection:text-primary-foreground`), cursor de
  digitação (`caret-primary`), sublinhado de link com folga (`underline-offset-4`), números de preço e tabela em
  `tabular-nums`, anel de foco na cor da marca (`focus-visible:ring-ring`). É o sinal mais barato de que o app foi
  construído e não montado, e o que o modelo mais pula.
- Toque: alvos de 44px no mínimo, 8px entre alvos, retorno visual em até 150ms.
- Texto: a língua do negócio; controles dizem a ação; erros dizem o problema e a saída.
- Cobertura: todo requisito do pedido presente e achável em segundos.

## Piso de qualidade: recusar (padrões, não proibições cegas; o pedido do dono pode ganhar qualquer um de volta)

Estrutura de página:
- Cards do mesmo tamanho com ícone, título e texto como estrutura da página; cards dentro de cards (sempre errado).
- Número gigante com legenda pequena e estatísticas de apoio no herói.
- Rótulo pequeno acima de título (eyebrow): padrão zero; teto contável na regra da construção.
- Numeração 01 / 02 / 03 quando o conteúdo não é uma sequência de verdade; "Etapa 1 / Etapa 2" genérico (o verbo é
  o rótulo: "Escolha", "Agende", "Pague").
- Modal para tarefa que não precisa de interrupção nem de foco protegido.
- Três cards iguais lado a lado; cabeçalho dividido (título grande à esquerda e parágrafo pequeno solto à direita);
  mais de duas seções seguidas em zigue-zague de imagem e texto; a mesma família de layout duas vezes na página
  (página de 8 seções usa pelo menos 4 famílias); grade bento com célula vazia (N itens, N células).
- Lista longa em `ul` com linha em cada item; filete em cima e embaixo de toda linha. Mais de 5 itens pede grupos,
  abas, acordeão, `ScrollRow` ou grade com imagem.

Hábitos de superfície:
- Texto em gradiente (`bg-clip-text`); vidro e desfoque como decoração; borda colorida grossa na lateral de card,
  item ou alerta (`border-l-4`); sombra dura deslocada (4px 4px 0) fora de um mundo de fato neobrutalista.
- Mono como fantasia de "técnico"; emoji ou símbolo unicode no lugar de ícone (ícones do `lucide-react`, uma
  espessura só); máscara geométrica imitando contorno de foto; claro ou escuro escolhido pelo setor.
- `div` imitando captura de tela de produto; blobs e formas abstratas preenchendo espaço; herói com `h-screen`
  (use `min-h-[100dvh]`); cursor personalizado; escuta de rolagem na janela; `animation-timeline` (o Safari ignora
  e o efeito some; confira por `grep`).
- Pílula ou rótulo em cima de foto; legenda decorativa de crédito de foto; faixa decorativa no pé do herói ("MARCA.
  MOVIMENTO. ESPAÇO."); faixa de cidade, hora ou clima; aviso "role para baixo"; selo de versão ("BETA", "v2.0");
  bolinha colorida decorativa antes de item, link ou selo (só vale para estado real, uma por seção); barra de
  progresso com trilho como comparação em página de venda.
- Navegação em duas linhas no computador; cabeçalho de site acima de 80px (padrão de 64 a 72px).

## Checagem final da construção (cada item conferível)

- Direção declarada e dials escritos no plano e no `DECISOES.md`, não padrão silencioso.
- O `theme` gravado no `fab.config.json` é o aprovado pelo dono, com os pares de contraste conferidos, e chegou
  ao ar depois do `fabapp deploy`.
- Nenhum travessão nem meia-risca em texto visível; ponto médio no máximo um por linha.
- Um tema (claro ou escuro) no app inteiro, sem seção invertida no meio.
- Um acento: a mesma cor de ação em todas as seções, nenhum selo de outra cor inventado.
- Um sistema de raio, seguido em todo componente.
- Todo botão legível sobre o próprio fundo, inclusive botão fantasma sobre foto (com véu ou contorno).
- Texto de botão principal em uma linha no computador, idealmente 1 a 3 palavras.
- Formulário: rótulo acima do campo, erro abaixo, placeholder nunca como rótulo, contraste 4,5:1 em rótulo, ajuda e
  erro.
- Itálico em título com letra de descendente (g, j, p, q, y) com `leading-[1.1]` no mínimo e `pb-1` de folga.
- Herói cabe na primeira tela: título em até 2 linhas no computador, subtítulo até 20 palavras e 4 linhas, ação
  visível sem rolar, respiro de topo no máximo `pt-24`.
- Contagem de rótulos acima de título dentro do teto; nenhuma intenção de ação com dois textos diferentes.
- Citação de cliente real com no máximo 3 linhas, nome e papel; aspas tipográficas “ ” ou nenhuma.
- Movimento declarado igual a movimento entregue; cada animação justificada numa frase (hierarquia, narrativa,
  retorno de ação, mudança de estado); no máximo um letreiro rolando (`Marquee`) por página.
- Estados vazio, carregando e erro presentes em toda lista e formulário.
- Imagens: `AppImage` onde não há dado, campo `image` do registro onde há; nenhuma página pública sem imagem.
