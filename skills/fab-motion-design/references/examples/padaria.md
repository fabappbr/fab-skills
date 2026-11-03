# Peça de referência: padaria (gráfico ousado e produto herói)

Cópia exata de `studio/src/motion/references/padaria.tsx`. Medida de acabamento do estilo, não modelo de texto.

```tsx
/* Padaria Pão Quente: Saturday pão de queijo until noon. Bold graphic / product hero, 9:16, 15 s. pt-ok
 * The items have no photo, so the product is drawn from brand-coloured shapes (never generated, never a photo).
 * 1 hook     2.2 s  "Sábado tem pão de queijo."      marquees slide, the bread drops and squashes, crumbs   impact
 * 2 hero     2.2 s  "Douradinho por fora."            burst wipe; camera pulls back from the crust, orbits  whoosh
 * 3 price    2.8 s  item name + price rolls in        match cut on the bread; starburst badge spins         cha-ching
 * 4 deadline 2.2 s  "Só até meio-dia."                whip; clock hands sweep and land on 12               impact
 * 5 pairing  2.4 s  "E pra acompanhar" café + price   push up; the cup slides in, steam draws               pop
 * 6 end      3.2 s  name, CTA WhatsApp                circle wipe; breads bounce in a row, confetti        shimmer
 */
import { Sequence, Scene, Soundtrack, CallToAction, sec, Safe, Camera, Layer, Move, At, Kinetic, WordSwap,
         Morph, Shape, PathDraw, Lines, Dots, Marquee, Burst, Grain, Glow, PriceTag, usePalette, useShot,
         spring, interpolate, hash01 } from "@fab/motion";

/** The pão de queijo, drawn: a golden ball lit from the top left, darker crust below, cheese specks. */
function CheeseBread({ size = 300, seed = 1, squash = 0, spin = 0 }: { size?: number; seed?: number; squash?: number; spin?: number }) {
  const { c, mix, alpha } = usePalette();
  const sx = 1 + squash * 0.25, sy = 1 - squash * 0.22;
  return (
    <div style={{ position: "relative", width: size, height: size }}>
      <div style={{ position: "absolute", left: "8%", right: "8%", bottom: -size * 0.06, height: size * 0.14, borderRadius: "50%",
                    background: alpha("text", 0.22), filter: `blur(${size * 0.04}px)`, transform: `scaleX(${sx})` }} />
      <div style={{ position: "absolute", inset: 0, borderRadius: "48% 52% 47% 53% / 52% 50% 50% 48%",
                    transform: `scale(${sx}, ${sy}) rotate(${spin}deg)`, transformOrigin: "50% 100%", overflow: "hidden",
                    background: `radial-gradient(circle at 34% 28%, ${mix("accent", "background", 0.75)} 0, ${c("accent")} 30%, ${mix("accent", "primary", 0.55)} 72%, ${mix("primary", "text", 0.35)} 100%)` }}>
        {Array.from({ length: 16 }, (_, i) => {
          const a = hash01(seed, i) * Math.PI * 2, r = 0.15 + 0.3 * hash01(seed + 3, i);
          const s = size * (0.03 + 0.04 * hash01(seed + 5, i));
          return <div key={i} style={{ position: "absolute", left: `${50 + Math.cos(a) * r * 100}%`, top: `${50 + Math.sin(a) * r * 100}%`,
                                       width: s, height: s * 0.8, borderRadius: "50%", background: alpha("background", 0.35) }} />;
        })}
      </div>
    </div>
  );
}

/** The bread dropping in: falls, squashes on the floor, settles. */
function DroppingBread({ at = 0, size = 360, seed = 1 }: { at?: number; size?: number; seed?: number }) {
  const { frame } = useShot();
  const fall = interpolate(frame, [at, at + 12], [-1400, 0], { ease: "inQuad" });
  const impact = frame - (at + 12);
  const squash = impact >= 0 ? Math.exp(-impact / 4) * Math.cos(impact / 1.6) : 0;
  return <div style={{ transform: `translateY(${fall}px)` }}><CheeseBread size={size} seed={seed} squash={squash} /></div>;
}

/** A clock face whose hands sweep and land on twelve. */
function NoonClock({ at = 0, size = 360 }: { at?: number; size?: number }) {
  const { frame } = useShot();
  const { c } = usePalette();
  const hour = interpolate(frame, [at, at + 30], [-200, 360], { ease: "outBack" });
  const minute = interpolate(frame, [at, at + 30], [-1440, 720], { ease: "outBack" });
  const hand = (len: number, w: number, deg: number, role: "background" | "accent") => (
    <div style={{ position: "absolute", left: "50%", bottom: "50%", width: w, height: len, marginLeft: -w / 2, borderRadius: w,
                  background: c(role), transformOrigin: "50% 100%", transform: `rotate(${deg}deg)` }} />
  );
  return (
    <div style={{ position: "relative", width: size, height: size }}>
      <PathDraw d="M50 2 C 76.5 2, 98 23.5, 98 50 C 98 76.5, 76.5 98, 50 98 C 23.5 98, 2 76.5, 2 50 C 2 23.5, 23.5 2, 50 2" width={size} height={size} color="background" stroke={14} at={at - 6} dur={20} />
      {Array.from({ length: 12 }, (_, i) => (
        <div key={i} style={{ position: "absolute", left: "50%", top: "50%", width: 8, height: i % 3 === 0 ? 34 : 18, marginLeft: -4,
                              background: c("background"), opacity: interpolate(frame, [at + i, at + i + 6], [0, 1]),
                              transform: `rotate(${i * 30}deg) translateY(${-size / 2 + 30}px)`, transformOrigin: "50% 0" }} />
      ))}
      {hand(size * 0.27, 18, hour, "background")}
      {hand(size * 0.38, 12, minute, "accent")}
      <div style={{ position: "absolute", left: "50%", top: "50%", width: 30, height: 30, margin: -15, borderRadius: 15, background: c("accent") }} />
    </div>
  );
}

/** A coffee cup in flat shapes, with steam that draws and fades. */
function CoffeeCup({ size = 300, at = 0 }: { size?: number; at?: number }) {
  const { c, mix } = usePalette();
  return (
    <div style={{ position: "relative", width: size * 1.3, height: size * 1.25 }}>
      {[0, 1, 2].map((i) => (
        <PathDraw key={i} d="M50 100 C 20 80, 80 60, 50 40 S 30 10, 50 0" width={size * 0.18} height={size * 0.42}
                  color="background" stroke={10} at={at + 8 + i * 5} dur={18} tail={6}
                  style={{ position: "absolute", left: size * (0.26 + i * 0.22), top: 0, opacity: 0.85 }} />
      ))}
      <div style={{ position: "absolute", right: 0, top: size * 0.55, width: size * 0.42, height: size * 0.42, borderRadius: "50%",
                    border: `${size * 0.075}px solid ${c("background")}` }} />
      <div style={{ position: "absolute", left: size * 0.05, top: size * 0.45, width: size, height: size * 0.8,
                    borderRadius: `${size * 0.06}px ${size * 0.06}px ${size * 0.34}px ${size * 0.34}px`, background: c("background"),
                    overflow: "hidden" }}>
        <div style={{ position: "absolute", left: 0, right: 0, top: 0, height: size * 0.12, background: mix("text", "primary", 0.35) }} />
        <div style={{ position: "absolute", left: 0, right: 0, top: size * 0.3, height: size * 0.12, background: c("accent") }} />
      </div>
    </div>
  );
}

export default function Piece({ brand, items }) {
  const bread = items[0];
  const coffee = items[1];
  return (
    <Sequence soundtrack="track">
      <Soundtrack volume={0.55} />
      {/* 1. hook: two marquees slide against each other; the bread drops on the beat */}
      <Scene canvas duration={sec(2.2)} bg="accent" sfx="whoosh" hits={[{ at: 12, kind: "impact" }]}>
        <Camera keys={[{ at: 0, zoom: 1.05 }, { at: 60, zoom: 1 }]} shake={0}>
          <Layer depth={1.5}>
            <div style={{ position: "absolute", inset: 0, transform: "rotate(-8deg)" }}>
              <Marquee size={230} color="primary" y={0.08} speed={420} outline>SÁBADO · SÁBADO ·</Marquee>
              <Marquee size={230} color="primary" y={0.78} speed={-420} outline>SÁBADO · SÁBADO ·</Marquee>
            </div>
          </Layer>
          <At x={0.5} y={0.6}><DroppingBread at={0} size={520} /></At>
          <Burst at={12} seed={3} x={0.5} y={0.72} count={26} kind="dots" colors={["primary", "background"]} power={1100}
                 spread={160} angle={-90} gravity={2600} life={30} size={16} />
          <Safe justify="flex-start" align="center">
            <Kinetic mode="scale-punch" size={92} color="text" align="center" at={14} step={3} upper tracking="-0.01em">
              {"Sábado tem"}
            </Kinetic>
            <Kinetic mode="mask-up" size={168} color="primary" align="center" at={20} step={4} weight={800} tracking="-0.045em">
              {"pão de queijo."}
            </Kinetic>
          </Safe>
        </Camera>
        <Grain amount={0.08} />
      </Scene>

      {/* 2. hero: a burst-shaped wipe; the camera starts on the crust and pulls back, orbiting a little */}
      <Scene canvas duration={sec(2.2)} bg="primary" transition="shape-burst" sfx="whoosh">
        <Lines color="accent" alpha={0.18} size={90} line={22} angle={-30} drift={[60, 0]} />
        <Camera keys={[{ at: 0, zoom: 2.8, y: 120, rotate: 12 }, { at: 40, zoom: 1, y: 0, rotate: 0, ease: "outExpo" }]}>
          <Glow color="accent" x={0.5} y={0.52} size={0.8} intensity={0.55} />
          <At x={0.5} y={0.52}><CheeseBread size={560} seed={2} spin={0} /></At>
        </Camera>
        <Safe justify="flex-start" align="flex-start">
          <Kinetic mode="mask-up" size={130} color="background" at={24} step={5} tracking="-0.04em">{"Douradinho\npor fora."}</Kinetic>
        </Safe>
        <Grain amount={0.07} />
      </Scene>

      {/* 3. price: match cut on the bread, which slides left; the price rolls in under the badge */}
      <Scene canvas duration={sec(2.8)} bg="background" transition="match" sfx="pop" hits={[{ at: 26, kind: "cha-ching" }]}>
        <Dots color="primary" alpha={0.12} size={46} line={4} drift={[0, -20]} />
        <Move keys={[{ at: 0, x: 0, y: 0, scale: 1 }, { at: 16, x: 250, y: 560, scale: 0.9, ease: "snap" }]}>
          <At x={0.5} y={0.52}><CheeseBread size={560} seed={2} /></At>
        </Move>
        <At x={0.74} y={0.24}>
          <Move keys={[{ at: 10, scale: 0, rotate: -120 }, { at: 26, scale: 1, rotate: 0, ease: "outBack" }]}>
            <div style={{ position: "relative", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <Morph keys={[{ at: 0, shape: "burst" }]} size={150} color="primary" spin={30} />
              <Kinetic mode="fade" at={20} size={40} color="background" align="center" upper weight={800} leading={1}
                       style={{ position: "absolute" }}>{"Promo\nde sábado"}</Kinetic>
            </div>
          </Move>
        </At>
        <Safe justify="center" align="flex-start" gap={0} style={{ paddingTop: 120 }}>
          <Kinetic mode="mask-up" size={84} color="text" at={12} upper tracking="0">{bread?.name ?? ""}</Kinetic>
          <PriceTag item={bread} size={430} role="primary" at={18} entrance="punch" />
        </Safe>
        <Grain amount={0.05} />
      </Scene>

      {/* 4. deadline: whip to dark; the clock hands race and land on twelve */}
      <Scene canvas duration={sec(2.2)} bg="text" transition="whip-left" sfx="whoosh" hits={[{ at: 36, kind: "impact" }]}>
        <Camera keys={[{ at: 0, zoom: 1.1 }, { at: 36, zoom: 1, ease: "outBack" }, { at: 66, zoom: 1.03 }]}>
          <Safe gap={60}>
            <NoonClock at={4} size={400} />
            <div style={{ textAlign: "center" }}>
              <Kinetic mode="mask-up" size={110} color="background" align="center" at={10} upper tracking="-0.02em">Só até</Kinetic>
              <Kinetic mode="stretch" size={170} color="accent" align="center" at={34} step={3} tracking="-0.04em">meio-dia.</Kinetic>
            </div>
          </Safe>
        </Camera>
        <Burst at={36} seed={6} x={0.5} y={0.33} count={18} kind="rays" colors={["accent"]} power={900} life={20} size={20} />
        <Grain amount={0.07} />
      </Scene>

      {/* 5. pairing: push up into terracotta; the cup slides in with its steam and its own price */}
      <Scene canvas duration={sec(2.4)} bg="primary" transition="push-up" sfx="pop">
        <Lines color="text" alpha={0.08} size={120} line={40} angle={60} drift={[30, 0]} />
        <Safe gap={30}>
          <div style={{ textAlign: "center" }}>
            <Kinetic mode="mask-up" size={64} color="background" align="center" at={4} upper tracking="0.06em">E pra acompanhar</Kinetic>
            <WordSwap words={[coffee?.name ?? ""]} at={8} size={140} color="accent" />
          </div>
          <Move keys={[{ at: 6, x: 700, rotate: 18 }, { at: 24, x: 0, rotate: 0, ease: "outBack" }]}>
            <CoffeeCup size={400} at={14} />
          </Move>
          <PriceTag item={coffee} size={230} role="background" at={26} entrance="punch" />
        </Safe>
        <Grain amount={0.07} />
      </Scene>

      {/* 6. end: circle wipe into the brand colour; three breads bounce in, the call to action */}
      <Scene canvas duration={sec(3.2)} bg="accent" transition="shape-circle" sfx="shimmer">
        <div style={{ position: "absolute", inset: 0, transform: "rotate(-8deg)" }}>
          <Marquee size={130} color="primary" alpha={0.9} y={0.05} speed={300} style={{ textTransform: "uppercase" }}>
            {items.map((it) => it.name + " · ").join("")}
          </Marquee>
        </div>
        <Safe gap={40}>
          <Kinetic mode="mask-up" size={150} color="text" align="center" at={8} step={4} tracking="-0.045em" leading={0.95}>{brand.name}</Kinetic>
          <CallToAction action="whatsapp" text="Peça pelo WhatsApp" delay={30} />
        </Safe>
        {[0, 1, 2, 3].map((i) => (
          <At key={i} x={0.12 + i * 0.26} y={0.9 - (i % 2) * 0.05}>
            <Move keys={[{ at: 2 + i * 4, y: 900 }, { at: 16 + i * 4, y: 0, ease: "outBack" }]}>
              <CheeseBread size={i % 2 ? 330 : 280} seed={i + 4} />
            </Move>
          </At>
        ))}
        <Burst at={30} seed={11} x={0.5} y={0.62} count={40} colors={["primary", "background", "text"]} power={1400} spread={120} />
        <Grain amount={0.07} />
      </Scene>
    </Sequence>
  );
}
```
