# Peça de referência: aurea (editorial)

Cópia exata de `studio/src/motion/references/aurea.tsx`. Medida de acabamento do estilo, não modelo de texto.

```tsx
/* Aurea Dermatologia: the skin assessment visit. Editorial, 9:16, 15 s. Serif, air, slow camera, lines that draw. pt-ok
 * 1 open     2.8 s  "A pele conta a sua história."     hairline frame draws, lines rise, slow drift
 * 2 listen   2.6 s  "Primeiro, a gente escuta."         match cut on the frame; circle draws round "escuta"   click
 * 3 time     3.2 s  "Sem pressa." / tempo para entender  circle wipe to green; 3D tilt settles; rule draws     whoosh
 * 4 plan     2.8 s  "Um plano de cuidado feito para você" push; a blob turns at depth; marker on "você"
 * 5 end      3.6 s  name, rule, "Agende sua avaliação"   fade to green; arrow draws to the WhatsApp call       shimmer
 */
import { Sequence, Scene, Soundtrack, CallToAction, sec, Safe, Camera, Layer, Move, Kinetic, PathDraw, Morph, Grain,
         Vignette, Glow, useShot, usePalette, interpolate, useSafeBox } from "@fab/motion";

/** A thin frame inset into the safe area that draws itself, the editorial "page". */
function PageFrame({ at = 0, role = "text" as const }: { at?: number; role?: "text" | "background" }) {
  // the page sits outside the text-safe area on purpose: only a hairline lives there, never text
  const box = useSafeBox();
  const left = box.left - 25, top = Math.round(box.top * 0.55);
  return (
    <div style={{ position: "absolute", left, top, opacity: 0.45 }}>
      <PathDraw path="frame" width={box.frameWidth - 2 * left} height={Math.round(box.frameHeight * 0.8) - top} color={role} stroke={2}
                at={at} dur={40} ease="inOutCubic" />
    </div>
  );
}

function Eyebrow({ children, at = 0, role = "text" as const }: { children: string; at?: number; role?: "text" | "background" | "accent" }) {
  const { frame } = useShot();
  const { c, body } = usePalette();
  const o = interpolate(frame, [at, at + 20], [0, 1], { ease: "outCubic" });
  const ls = interpolate(frame, [at, at + 40], [0.5, 0.28], { ease: "outExpo" });
  return <div style={{ fontFamily: body, fontSize: 30, fontWeight: 500, letterSpacing: `${ls}em`, textTransform: "uppercase",
                       color: c(role), opacity: o }}>{children}</div>;
}

/** The brand's initial, huge and faint, on a far plane. */
function Watermark({ letter }: { letter: string }) {
  const { alpha, heading } = usePalette();
  return <div style={{ position: "absolute", right: -140, top: 360, fontFamily: heading, fontSize: 900, lineHeight: 1,
                       fontStyle: "italic", color: alpha("primary", 0.08) }}>{letter}</div>;
}

export default function Piece({ brand }) {
  return (
    <Sequence soundtrack="track">
      <Soundtrack volume={0.5} />
      {/* 1. the page opens: frame draws, the headline rises line by line */}
      <Scene canvas duration={sec(2.8)} bg="background">
        <Camera keys={[{ at: 0, zoom: 1.06, y: 30 }, { at: 84, zoom: 1, y: 0, ease: "outCubic" }]}>
          <Layer depth={2}>
            <Watermark letter={brand.name.slice(0, 1)} />
          </Layer>
          <PageFrame at={0} />
          <Safe align="flex-start" justify="flex-end" gap={40} style={{ paddingBottom: 40 }}>
            <Eyebrow at={10}>Dermatologia · Avaliação</Eyebrow>
            <Kinetic mode="mask-up" by="line" step={7} dur={26} at={14} size={118} font="heading" weight={400} leading={1.04}
                     tracking="-0.02em" accent={{ história: "primary" }}>
              {"A pele conta\na sua história."}
            </Kinetic>
          </Safe>
        </Camera>
        <Grain amount={0.05} />
      </Scene>

      {/* 2. match cut: the same frame, now the headline is about listening */}
      <Scene canvas duration={sec(2.6)} bg="background" transition="match" sfx="click">
        <Camera keys={[{ at: 0, x: 0 }, { at: 78, x: 24, ease: "linear" }]}>
          <Layer depth={1.5}>
            <Morph keys={[{ at: 0, shape: "blob", seed: 2 }]} size={420} color="accent" x={0.76} y={0.615} spin={4}
                   style={{ opacity: 0.16 }} />
          </Layer>
          <PageFrame at={-100} />
          <Safe align="flex-start" justify="center" gap={36}>
            <Eyebrow at={0}>Como começa</Eyebrow>
            <Kinetic mode="blur-in" by="word" step={4} dur={18} at={4} size={124} font="heading" weight={400} leading={1.04}
                     marks={{ escuta: "circle" }} markColor="accent" markAt={34}>
              {"Primeiro,\na gente\nescuta."}
            </Kinetic>
          </Safe>
        </Camera>
        <Grain amount={0.05} />
      </Scene>

      {/* 3. a circle opens into green; the camera settles from a tilt */}
      <Scene canvas duration={sec(3.2)} bg="primary" transition="shape-circle" transitionFrames={22} sfx="whoosh">
        <Camera keys={[{ at: 0, tiltX: 18, zoom: 1.1, y: 60 }, { at: 50, tiltX: 0, zoom: 1, y: 0, ease: "outExpo" }]} perspective={1400}>
          <Glow color="accent" x={0.3} y={0.35} size={0.9} intensity={0.22} />
          <Safe align="flex-start" gap={44}>
            <Kinetic mode="mask-up" by="word" step={6} dur={24} at={6} size={190} font="heading" weight={300} italic color="background"
                     leading={0.98} tracking="-0.03em">
              {"Sem\npressa."}
            </Kinetic>
            <PathDraw path="underline" width={520} height={24} color="accent" stroke={4} at={28} dur={22} />
            <Kinetic mode="fade" by="line" at={36} dur={20} size={46} font="body" weight={400} color="background" leading={1.35}
                     tracking="0">
              {"Tempo para entender\na sua pele e a sua rotina."}
            </Kinetic>
          </Safe>
        </Camera>
        <Grain amount={0.06} />
        <Vignette strength={0.25} />
      </Scene>

      {/* 4. the plan: push back to ivory, a slow organic shape at depth, the marker under "você" */}
      <Scene canvas duration={sec(2.8)} bg="background" transition="push-left">
        <Camera keys={[{ at: 0, zoom: 1, x: -20 }, { at: 84, zoom: 1.05, x: 20, ease: "linear" }]}>
          <Layer depth={2.5}>
            <Morph keys={[{ at: 0, shape: "blob", seed: 3 }, { at: 40, shape: "blob", seed: 5 }, { at: 84, shape: "flower" }]}
                   size={520} color="primary" x={0.28} y={0.4} spin={-6} style={{ opacity: 0.1 }} />
          </Layer>
          <Layer depth={-0.3}>
            <Morph keys={[{ at: 0, shape: "circle" }]} size={34} color="accent" x={0.815} y={0.22} />
          </Layer>
          <Safe align="flex-start" gap={40}>
            <Eyebrow at={4}>O que você leva</Eyebrow>
            <Kinetic mode="mask-up" by="line" step={6} dur={24} at={8} size={112} font="heading" weight={400} leading={1.06}
                     tracking="-0.02em" marks={{ você: "marker" }} markColor="accent" markAt={40}>
              {"Um plano de\ncuidado feito\npara você."}
            </Kinetic>
          </Safe>
        </Camera>
        <Grain amount={0.05} />
      </Scene>

      {/* 5. end: fade to green, the name set like a masthead, an arrow draws to the call */}
      <Scene canvas duration={sec(3.6)} bg="primary" transition="fade" transitionFrames={16} sfx="shimmer">
        <Camera keys={[{ at: 0, zoom: 1.04 }, { at: 108, zoom: 1, ease: "outCubic" }]}>
          <Glow color="accent" x={0.5} y={0.4} size={1} intensity={0.18} />
          <PageFrame at={4} role="background" />
          <Safe align="center" gap={34}>
            <Eyebrow at={6} role="accent">Dermatologia</Eyebrow>
            <Kinetic mode="blur-in" by="letter" step={1.2} dur={20} at={8} size={190} font="heading" weight={400} color="background"
                     align="center" tracking="-0.01em">
              {brand.name.split(" ")[0]}
            </Kinetic>
            <PathDraw path="underline" width={300} height={18} color="accent" stroke={3} at={30} dur={20} />
            <Move keys={[{ at: 40, opacity: 0, y: 20 }, { at: 62, opacity: 1, y: 0, ease: "outCubic" }]}>
              <div style={{ display: "flex", alignItems: "center", gap: 22 }}>
                <Kinetic mode="fade" at={40} dur={18} size={66} font="heading" weight={400} italic color="background">
                  Agende sua avaliação
                </Kinetic>
                <PathDraw path="arrow" width={70} height={40} color="accent" stroke={4} at={56} dur={16} />
              </div>
            </Move>
            <div style={{ display: "flex", justifyContent: "center" }}>
              <CallToAction action="whatsapp" text="Agende pelo WhatsApp" delay={62} />
            </div>
          </Safe>
        </Camera>
        <Grain amount={0.06} />
      </Scene>
    </Sequence>
  );
}
```
