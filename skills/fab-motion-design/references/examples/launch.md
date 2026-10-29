# Peça de referência: launch (tipografia cinética)

Cópia exata de `studio/src/motion/references/launch.tsx`. Medida de acabamento do estilo, não modelo de texto.

```tsx
/* Fabapp Motion launch, kinetic typography, 9:16, 15 s.
 * 1 hook      2.0 s  "Sem tempo / designer / câmera"  camera push, word slot-swaps on the beat   impact
 * 2 prompt    2.0 s  a sentence typed into a pill       whip in, camera dives into the pill        whoosh
 * 3 payoff    2.3 s  "Vira vídeo."                       zoom-through, outline-fill, morphing star  pop
 * 4 brand     2.3 s  "Com a sua marca/cor/fonte"         squircle wipe, palette swatches spring in  click
 * 5 sound     2.2 s  "Trilha e efeitos no ritmo"         push up, equalizer + rings on the beat     whoosh
 * 6 formats   1.8 s  "Pronto para Reels/Stories/Status"  whip up, the frame morphs its aspect       pop
 * 7 end       2.4 s  logo, "Fabapp Motion", CTA          stack, marker draws, confetti              shimmer
 */
import { Sequence, Scene, Soundtrack, CallToAction, sec, Safe, Camera, Layer, Move, Kinetic, WordSwap, Morph,
         Shape, PathDraw, Grid, Dots, Rings, Burst, Grain, Glow, LightLeak, Logo, Marquee, interpolate, spring,
         useShot, usePalette } from "@fab/motion";

const PROMPT = "Promoção de sábado, pão de queijo, chama no WhatsApp";

function TypedPrompt() {
  const { frame } = useShot();
  const { c, alpha, body } = usePalette();
  const n = Math.floor(interpolate(frame, [6, 40], [0, PROMPT.length]));
  const caret = Math.floor(frame / 8) % 2 === 0 || n < PROMPT.length;
  const pop = spring(frame, 0, "snappy");
  return (
    <div style={{ width: 900, padding: "44px 48px", borderRadius: 48, background: c("background"), fontFamily: body,
                  boxShadow: `0 40px 120px ${alpha("text", 0.45)}`, transform: `scale(${0.85 + 0.15 * pop})`, opacity: pop }}>
      <div style={{ fontSize: 30, fontWeight: 700, letterSpacing: "0.14em", textTransform: "uppercase", color: c("primary"), marginBottom: 18 }}>
        Você escreve
      </div>
      <div style={{ fontSize: 58, fontWeight: 600, lineHeight: 1.2, color: c("text"), minHeight: 210 }}>
        {PROMPT.slice(0, n)}
        <span style={{ display: "inline-block", width: 6, height: 62, marginLeft: 4, verticalAlign: "-8px", background: c("primary"), opacity: caret ? 1 : 0 }} />
      </div>
    </div>
  );
}

function Equalizer() {
  const { frame } = useShot();
  const { c } = usePalette();
  const bars = 15;
  return (
    <div style={{ display: "flex", gap: 14, alignItems: "center", height: 260 }}>
      {Array.from({ length: bars }, (_, i) => {
        const beat = Math.exp(-((frame % 14) / 4));
        const h = 40 + 180 * Math.abs(Math.sin(frame / 5 + i * 0.7)) * (0.5 + 0.5 * beat) * Math.sin((Math.PI * (i + 1)) / (bars + 1));
        const grow = spring(frame, i * 1.5, "snappy");
        return <div key={i} style={{ width: 34, height: h * grow, borderRadius: 17, background: i % 4 === 0 ? c("accent") : c("background") }} />;
      })}
    </div>
  );
}

function FormatFrame() {
  const { frame } = useShot();
  const { c } = usePalette();
  // 9:16 → 1:1 → 9:16 tall again: the frame itself changes shape on each word swap
  const w = interpolate(frame, [0, 14, 18, 32, 36], [300, 300, 420, 420, 340], { ease: "snap" });
  const h = interpolate(frame, [0, 14, 18, 32, 36], [533, 533, 420, 420, 425], { ease: "snap" });
  // the frame holds a miniature of the piece itself: the star from scene 3, turning
  return (
    <div style={{ width: w, height: h, borderRadius: 36, overflow: "hidden", position: "relative", display: "flex",
                  alignItems: "center", justifyContent: "center", background: `linear-gradient(165deg, ${c("primary")}, ${c("text")})`,
                  boxShadow: `0 30px 80px ${c("primary")}55` }}>
      <Shape shape="star" size={90} color="accent" spin={40} />
    </div>
  );
}

export default function Piece() {
  const { c } = usePalette();     // hooks are fine in the root: the stage renders it as a component
  return (
    <Sequence soundtrack="track">
      <Soundtrack volume={0.55} />
      {/* 1. hook: dark, a slow push in; the second word swaps on the beat */}
      <Scene canvas duration={sec(2)} bg="text" sfx="impact" hits={[{ at: 14, kind: "click" }, { at: 28, kind: "click" }]}>
        <Camera keys={[{ at: 0, zoom: 1.18, rotate: -3 }, { at: 60, zoom: 1, rotate: 0, ease: "outQuint" }]}>
          <Layer depth={1.5}><Grid color="background" alpha={0.07} size={135} drift={[0, -40]} /></Layer>
          <Glow color="primary" x={0.5} y={0.42} size={0.9} intensity={0.55} />
          <Safe align="flex-start">
            <Kinetic mode="mask-up" size={190} color="background" at={2}>Sem</Kinetic>
            <WordSwap words={["tempo.", "designer.", "câmera."]} at={4} every={14} mode="mask" size={190} color="accent" />
          </Safe>
        </Camera>
        <Grain amount={0.07} />
      </Scene>

      {/* 2. the prompt: whip in, type, then the camera dives into the pill */}
      <Scene canvas duration={sec(2)} bg={["primary", "text"]} transition="whip-left" sfx="whoosh">
        <Camera keys={[{ at: 0, zoom: 1 }, { at: 44, zoom: 1.04 }, { at: 60, zoom: 3.2, y: -40, ease: "inExpo" }]}>
          <Layer depth={2}><Dots color="background" alpha={0.14} size={54} line={3} drift={[20, 0]} /></Layer>
          <Safe><TypedPrompt /></Safe>
        </Camera>
      </Scene>

      {/* 3. the payoff: a star morphs behind two huge words that draw then fill */}
      <Scene canvas duration={sec(2.3)} bg="background" transition="zoom-through" sfx="pop">
        <Camera keys={[{ at: 0, zoom: 1.08, tiltX: 12 }, { at: 50, zoom: 1, tiltX: 0, ease: "outExpo" }]}>
          <Layer depth={0.6}>
            <Safe>
              <Move keys={[{ at: 0, scale: 0 }, { at: 14, scale: 1, ease: "outBack" }]}>
                <Morph keys={[{ at: 0, shape: "circle" }, { at: 22, shape: "burst" }, { at: 44, shape: "star" }]} size={380}
                       color="accent" spin={18} />
              </Move>
            </Safe>
          </Layer>
          <Safe>
            <Move keys={[{ at: 0, scale: 0.8 }, { at: 16, scale: 1, ease: "outBack" }]}>
              <Kinetic mode="outline-fill" size={250} color="primary" align="center" leading={1.02} tracking="-0.01em" step={8} dur={14} upper>{"Vira\nvídeo."}</Kinetic>
            </Move>
          </Safe>
        </Camera>
        <Burst at={20} seed={4} x={0.5} y={0.45} count={36} colors={["primary", "accent", "text"]} power={1300} />
      </Scene>

      {/* 4. brand: wipe through the brand's rounded square; the palette springs in */}
      <Scene canvas duration={sec(2.3)} bg="text" transition="shape-squircle" sfx="click" hits={[{ at: 24, kind: "pop" }, { at: 36, kind: "pop" }]}>
        <Layer><Rings color="primary" alpha={0.25} size={180} line={2} x={0.5} y={0.5} /></Layer>
        <Safe align="flex-start" gap={56}>
          <div>
            <Kinetic mode="mask-up" size={150} color="background" at={6}>Com a sua</Kinetic>
            <WordSwap words={["marca.", "cor.", "fonte.", "logo."]} at={10} every={13} mode="slot" size={150} color="accent" />
          </div>
          <div style={{ display: "flex", gap: 28 }}>
            {(["primary", "accent", "background"] as const).map((role, i) => (
              <Move key={role} keys={[{ at: 18 + i * 5, scale: 0, rotate: -90 }, { at: 32 + i * 5, scale: 1, rotate: 0, ease: "outBack" }]}>
                <Shape shape={i === 1 ? "star" : i === 2 ? "squircle" : "circle"} size={70} color={role} />
              </Move>
            ))}
          </div>
        </Safe>
        <Grain amount={0.06} />
      </Scene>

      {/* 5. sound: the equalizer pumps on the beat, rings radiate */}
      <Scene canvas duration={sec(2.2)} bg="primary" transition="push-up" sfx="whoosh">
        <Rings color="background" alpha={0.12} size={160} line={4} drift={[0, 90]} />
        <Safe gap={60}>
          <Equalizer />
          <Kinetic mode="mask-up" size={120} color="background" align="center" at={8} step={3} marks={{ ritmo: "underline" }} markColor="accent">
            {"Trilha e efeitos\nno ritmo."}
          </Kinetic>
        </Safe>
        <LightLeak color="accent" second="background" intensity={0.25} />
      </Scene>

      {/* 6. formats: the frame itself changes aspect as the word swaps */}
      <Scene canvas duration={sec(1.8)} bg="background" transition="whip-up" sfx="pop" hits={[{ at: 16, kind: "click" }, { at: 34, kind: "click" }]}>
        <Marquee size={220} color="primary" alpha={0.08} y={0.7} speed={320}>REELS · STORIES · STATUS ·</Marquee>
        <Safe gap={50}>
          <FormatFrame />
          <div style={{ textAlign: "center" }}>
            <Kinetic mode="mask-up" size={96} color="text" align="center" at={0}>Pronto para</Kinetic>
            <WordSwap words={["Reels.", "Stories.", "Status."]} at={0} every={17} mode="mask" size={130} color="primary" />
          </div>
        </Safe>
      </Scene>

      {/* 7. end: stacks over, the name lands, the marker draws, the CTA */}
      <Scene canvas duration={sec(2.4)} bg="text" transition="stack" sfx="shimmer">
        <Camera keys={[{ at: 0, zoom: 1.06 }, { at: 72, zoom: 1 }]}>
          <Glow color="primary" x={0.5} y={0.38} size={1.1} intensity={0.7} pulse={1} />
          <Layer depth={1}><Grid color="background" alpha={0.05} size={135} drift={[0, -30]} /></Layer>
          <Safe gap={44}>
            <Move keys={[{ at: 0, opacity: 0, scale: 0.6 }, { at: 12, opacity: 1, scale: 1, ease: "outBack" }]}>
              <div style={{ background: c("white"), borderRadius: 40, padding: 22 }}><Logo height={110} /></div>
            </Move>
            <Kinetic mode="mask-up" size={150} color="background" align="center" at={6} marks={{ motion: "marker" }} markColor="primary" markAt={26}>
              {"Fabapp\nMotion"}
            </Kinetic>
            <PathDraw path="swoosh" width={420} height={60} color="accent" stroke={10} at={30} dur={16} />
            <CallToAction action="link-in-bio" text="Crie seu primeiro vídeo" delay={34} />
          </Safe>
        </Camera>
        <Burst at={30} seed={9} x={0.5} y={0.32} count={44} colors={["accent", "primary", "background"]} power={1500} spread={140} />
        <Grain amount={0.06} />
      </Scene>
    </Sequence>
  );
}
```
