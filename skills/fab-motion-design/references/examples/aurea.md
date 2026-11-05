# Peça de referência: aurea (editorial)

Cópia exata de `studio/src/motion/references/aurea.tsx`. Medida de acabamento do estilo, não modelo de texto.

```tsx
/* Aurea Dermatologia: the skin assessment visit. Editorial, 9:16, 15 s. Serif, air, slow camera, lines that draw. pt-ok
 * 1 open     2.8 s  "A pele conta a sua história."     hairline frame draws, lines rise, slow drift
 * 2 listen   2.6 s  "Primeiro, a gente escuta."         match cut on the frame; circle draws round "escuta"   tick
 * 3 time     3.2 s  "Sem pressa." / tempo para entender  circle wipe to green; 3D tilt settles; rule draws     whoosh
 * 4 plan     2.8 s  "Um plano de cuidado feito para você" push; a blob morphs above the words; marker on "você"
 * 5 end      3.6 s  name, rule, "Agende sua avaliação"   fade to green; arrow draws to the WhatsApp call       resolve
 */
import { Sequence, Scene, Soundtrack, CallToAction, sec, Camera, Move, Kinetic, PathDraw, Grain, Layout, Headline,
         Eyebrow, Ornament, Numeral, Surface, useSafeBox } from "@fab/motion";

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

export default function Piece({ brand }) {
  return (
    <Sequence soundtrack="track">
      <Soundtrack volume={0.5} />
      {/* 1. the page opens: frame draws, a two-tone headline rises line by line on the optical centre; the brand's
          initial sits huge and faint in the zone above it */}
      <Scene canvas duration={sec(2.8)} bg="background">
        <Surface contour={false} grain={0.05} />
        <Camera keys={[{ at: 0, zoom: 1.06, y: 30 }, { at: 84, zoom: 1, y: 0, ease: "outCubic" }]}>
          <PageFrame at={0} />
          <Layout>
            <Eyebrow variant="rule">Avaliação da pele</Eyebrow>
            <Headline lead="A pele conta" accent={{ história: "primary" }}>a sua história.</Headline>
            <Numeral zone="top" side="end" color="primary" filled opacity={0.5}>{brand.name.slice(0, 1)}</Numeral>
          </Layout>
        </Camera>
      </Scene>

      {/* 2. match cut: the same frame, now the headline is about listening */}
      <Scene canvas duration={sec(2.6)} bg="background" transition="match" sfx="tick">
        <Surface contour={false} grain={0.05} />
        <Camera keys={[{ at: 0, x: 0 }, { at: 78, x: 24, ease: "linear" }]}>
          <PageFrame at={-100} />
          <Layout place="upper">
            <Eyebrow variant="rule">Como começa</Eyebrow>
            <Kinetic mode="blur-in" by="word" step={4} dur={18} at={4} size={150} leading={1.08}
                     marks={{ escuta: "circle" }} markColor="accent" markAt={34}>
              {"Primeiro,\na gente\nescuta."}
            </Kinetic>
            <Ornament shape="blob" zone="bottom" side="end" color="accent" opacity={0.16} spin={4} />
          </Layout>
        </Camera>
      </Scene>

      {/* 3. a circle opens into green; the camera settles from a tilt */}
      <Scene canvas duration={sec(3.2)} bg="primary" transition="shape-circle" transitionFrames={22} sfx="whoosh">
        <Camera keys={[{ at: 0, tiltX: 18, zoom: 1.1, y: 60 }, { at: 50, tiltX: 0, zoom: 1, y: 0, ease: "outExpo" }]} perspective={1400}>
          <Layout gap={44}>
            <Kinetic mode="mask-up" by="word" step={6} dur={24} at={6} size={190} font="heading" weight={300} italic color="background"
                     leading={0.98} tracking="-0.03em">
              {"Sem\npressa."}
            </Kinetic>
            <PathDraw path="underline" width={520} height={24} color="accent" stroke={4} at={28} dur={22} />
            <Kinetic mode="fade" by="line" at={36} dur={20} size={60} font="body" weight={400} color="background" leading={1.35}
                     tracking="0">
              {"Tempo para entender\na sua pele e a sua rotina."}
            </Kinetic>
          </Layout>
        </Camera>
        <Grain amount={0.06} />
      </Scene>

      {/* 4. the plan: push back to ivory, a slow organic shape at depth, the marker under "você" */}
      <Scene canvas duration={sec(2.8)} bg="background" transition="push-left">
        <Camera keys={[{ at: 0, zoom: 1, x: -20 }, { at: 84, zoom: 1.05, x: 20, ease: "linear" }]}>
          <Layout place="lower">
            <Eyebrow variant="rule" delay={4}>O que você leva</Eyebrow>
            <Kinetic mode="mask-up" by="line" step={6} dur={24} at={8} size={140} leading={1.08}
                     marks={{ você: "marker" }} markColor="accent" markAt={40}>
              {"Um plano de\ncuidado feito\npara você."}
            </Kinetic>
            <Ornament zone="top" side="start" color="primary" opacity={0.1} spin={-6}
                      keys={[{ at: 0, shape: "blob", seed: 3 }, { at: 40, shape: "blob", seed: 5 }, { at: 84, shape: "flower" }]} />
          </Layout>
        </Camera>
        <Grain amount={0.05} />
      </Scene>

      {/* 5. end: fade to green, the name set like a masthead, an arrow draws to the call */}
      <Scene canvas duration={sec(3.6)} bg="primary" transition="fade" transitionFrames={16} sfx="resolve">
        <Camera keys={[{ at: 0, zoom: 1.04 }, { at: 108, zoom: 1, ease: "outCubic" }]}>
          <PageFrame at={4} role="background" />
          <Layout place="center" align="center" gap={34}>
            <Eyebrow variant="rule" delay={6}>Dermatologia</Eyebrow>
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
            <CallToAction action="whatsapp" text="Agende pelo WhatsApp" delay={62} />
          </Layout>
        </Camera>
        <Grain amount={0.06} />
      </Scene>
    </Sequence>
  );
}
```
