# O Pacote de Design

A entrega única da Fase 5. Um documento que segura cada decisão, escrito completo ANTES de construir e consumido pela construção na Fase 7. Quem pegar este documento não deve precisar de mais nada para construir o site certo.

Três regras:
- **Cada linha de texto do pacote embarca ao pé da letra.** O pacote é onde a escrita acontece; a construção é onde a fiação acontece.
- **Números são pontos de partida.** Tamanhos, durações e intervalos se movem se o autoteste mandar.
- **O Nível 1 ganha o mesmo pacote, enxuto:** menos seções, mesmos capítulos.

Salve o pacote como `pacote-de-design.md` na pasta do projeto, fora de `.fabapp/workspace`.

## 1. A premissa

Um parágrafo curto construído sobre UMA palavra, gesto ou material real do mundo do assunto. O site inteiro ensina e vende essa ideia. Termine com a frase da ideia em uma linha ("A página é uma bancada de marcenaria: tudo chega no lugar com precisão e peso."). Se uma seção não serve a premissa, ela não pertence à página.

## 2. O elemento assinatura

O que é, onde aparece, e o teste de volume: o que a página perderia sem ele.

## 3. O tema (pronto para o `fab.config.json`)

```json
{
  "theme": {
    "mode": "light",
    "primary": "#______", "primaryFg": "#______",
    "bg": "#______", "card": "#______", "text": "#______", "accent": "#______",
    "radius": 0,
    "titleFont": "Nome exato no Google Fonts", "bodyFont": "Nome exato no Google Fonts",
    "titleTracking": "-0.02em"
  }
}
```

Com uma linha por cor dizendo de onde ela vem no mundo da marca. Nunca `#000` ou `#fff` puros no fundo.

## 4. O sistema tipográfico

A display, a de texto, a mono (sempre JetBrains Mono pela plataforma, ou uma auto-hospedada), os pesos em uso, a escala (os passos `--step-*` ajustados à fonte), tracking e entrelinha por tamanho, e o tratamento dos rótulos.

## 5. O grid e a composição

Colunas, margens, a largura máxima do conteúdo, e onde o grid é quebrado de propósito. Como cada seção se recompõe em 375px.

## 6. O mapa de seções

Uma tabela, uma linha por seção, na ordem da página:

| # | Seção | Objetivo | Texto (ao pé da letra) | Imagem (slot) | Entrada / motion | Esqueleto |
|---|---|---|---|---|---|---|
| 1 | Hero | dizer o que é e para quem | Título: "..." Sub: "..." CTA: "..." | `hero-bancada` | linhas sobem da máscara, 1,1s | título gigante à esquerda, imagem 4:5 à direita |
| 2 | ... | ... | ... | ... | ... | ... |

- **Esqueleto:** uma frase do layout, para garantir que duas vizinhas nunca repetem o molde.
- **Entrada:** nomeada, ecoando o conteúdo (o princípio do eco em `motion-e-interacao.md`).

Para o Nível 2, uma tabela por rota, mais os models de CMS que alimentam as rotas dinâmicas.

## 7. O plano de movimento

- A personalidade em três palavras, os tokens de easing e as durações.
- As camadas em uso (CSS nativo, `tailwindcss-motion`, GSAP, Motion, Lenis, WebGL) e as dependências com versão.
- O momento interativo único: onde vive, o que o visitante faz, o que ganha, e o recuo de teclado, toque e movimento reduzido.
- Transições de página, se houver.
- O que acontece com cada efeito no celular e com movimento reduzido.

## 8. Os slots de imagem

| Slot | Papel e proporção | Prompt (inglês) | Fonte |
|---|---|---|---|
| `hero-bancada` | hero, 4:5 | "..." | gerar no Studio / foto do dono |

Mais a frase de tratamento compartilhado que se repete em todo prompt. Marque quais slots o dono vai preencher com fotos próprias.

## 9. A camada vetorial

Os SVG que você vai desenhar (logotipo, motivos, divisórias, linhas que se desenham, ícones da marca), onde cada um vive, e o comportamento com movimento reduzido.

## 10. Dados e conversão

- A chamada para ação principal e o destino (WhatsApp, lead, agendamento, compra, ligação), com número ou e-mail do dono.
- O model `lead` (ou outro) e a automação, em JSON, prontos para o `fab.schema.json` e o `fab.automations.json`.
- O microtexto do formulário: rótulos, placeholders, botão, sucesso, erro, a linha de privacidade.
- Os cards de integração recomendados ao dono (analytics, consentimento de cookies, chat) e o que cada um pede.
- Eventos de conversão (`trackEvent`).
- Para o Nível 2, os models de CMS (cases, posts, serviços, cardápio) com tipos da lista fechada.

## 11. SEO

O bloco `seo` pronto para o `fab.config.json`: título e descrição da home e de cada rota, dentro dos limites (15 a 60 e 50 a 160 caracteres), e o plano da imagem de compartilhamento.

## 12. O texto do rodapé e das páginas legais

Rodapé ao pé da letra, a política de privacidade (quando houver formulário ou analytics), e a página 404 na voz da marca. A declaração de marca fictícia quando for o caso. Os cuidados de nicho regulado, quando houver.

## 13. A linha do gate

Termine o pacote declarando o gate para a construção herdar: cada linha acima embarca ao pé da letra, e o site construído passa o gate de texto da Fase 9 (zero travessões, zero palavras de estoque, varredura de sinais de IA) antes de alguém ver. Dispositivos de marca deliberados deste pacote (um trio, um staccato planejado) são ofício e ficam.
