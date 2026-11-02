# Receita de cena: pedido digitado (demonstração de interface)

```tsx
/* Pedido digitado. 3 s = 6 batidas. O ÚNICO lugar de mode="type": uma cena que demonstra um pedido, nunca o gancho.
 * Plano: a caixa do pedido É o herói: 960 px de largura (89%), mais de 30% da altura, texto dentro de 68 px, folga em em.
 * Batidas: 0 a caixa sobe; 6 a digitação começa (cerca de 1 s); 60 o botão afunda 4 quadros (antecipação) e cresce; 76 ele
 * cresce até cobrir o quadro e vira o fundo da cena seguinte (carry "the button grows into the next frame", corte seco).
 */
function P2Ask({ children }: { children: string }) {
  const { frame } = useShot();
  const { c } = usePalette();
  const rise = spring(frame, 0, "snappy");
  return (
    <div style={{ width: 960, minHeight: 600, padding: "0.4em 0.6em", fontSize: 68, borderRadius: 56,
                  background: c("primary"), transform: `translateY(${(1 - rise) * 80}px)`, opacity: rise }}>
      <Kinetic mode="type" at={6} step={1} size={68} color="background" leading={1.15}>{children}</Kinetic>
      <Move keys={[{ at: 60, scale: 1 }, { at: 64, scale: 0.94 }, { at: 76, scale: 1, ease: "outBack" }, { at: 90, scale: 9, ease: "inExpo" }]}>
        <div style={{ marginTop: "0.4em", padding: "0.3em 0.8em", borderRadius: 999, background: c("accent"), width: "fit-content" }}>
          <Kinetic mode="fade" size={64} color="primary">Gerar</Kinetic>
        </div>
      </Move>
    </div>
  );
}
```
