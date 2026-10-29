# Animação em partes

A animação recebe o roteiro de planos da direção e escreve **uma parte** dele: as cenas de cerca de 15 s. A plataforma junta as partes num arquivo só, com os imports, a `<Sequence>`, a trilha e a folha de ritmo. Por isso a resposta de uma parte é curta e tem formato fixo.

## O formato da resposta

Um único bloco ```tsx com, nesta ordem:

1. os componentes auxiliares que as suas cenas usam, declarados no topo (`function P2Selo(...)`), sem `import` e sem `export`;
2. a linha `// SCENES`;
3. as `<Scene>` da sua parte (ou os `<Slide>` de um carrossel), na ordem do roteiro.

```tsx
function P2Selo({ at = 0, children }: { at?: number; children: string }) {
  return (
    <Move keys={[{ at, scale: 0 }, { at: at + 14, scale: 1, ease: "outBack" }]}>
      <Kinetic mode="fade" size={40} color="background" upper>{children}</Kinetic>
    </Move>
  );
}

// SCENES
<Scene canvas duration={sec(2.6)} bg="primary" transition="push-up" sfx="whoosh">
  <Safe>
    <Kinetic mode="mask-up" size={140} color="background">{items[1]?.name ?? ""}</Kinetic>
    <PriceTag item={items[1]} size={300} role="accent" at={12} entrance="punch" />
  </Safe>
</Scene>
```

## Regras da parte

- **Uma `<Scene>` por plano**, com `duration={sec(n)}` igual aos segundos do plano. A soma da parte fecha com o que a plataforma pediu.
- **Nada de `<Sequence>`, `<Soundtrack>`, `export default` nem folha de ritmo:** a plataforma escreve.
- **Só `brand`, `items`, o kit e os seus auxiliares** dentro das cenas. Não existe corpo de `Piece` com variáveis: escreva `items[0]` direto, e `items[0]?.name ?? ""` para o nome.
- **O prefixo da parte** (`P2`, `P3`) em todo auxiliar que você declarar, para duas partes nunca terem o mesmo nome.
- **A primeira cena da parte** continua a cena anterior do roteiro: use a transição do plano e mantenha o motivo visual da peça.
- **Só a última parte fecha a peça** com `<CallToAction>` ou `<EndCard>`.
- O estilo e a peça de referência valem para toda parte: a peça tem que parecer escrita por uma pessoa só.

## Ajuste de cenas (peça longa)

No ajuste por conversa de uma peça longa, a plataforma manda só as cenas que mudam e os auxiliares que elas usam. A resposta tem o mesmo formato: auxiliares novos (com o prefixo pedido), `// SCENES` e as cenas no lugar das antigas, com as mesmas durações, salvo se o dono pedir outra coisa.
