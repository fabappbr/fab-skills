# Peça de referência: aurea-opus (editorial (e base do minimal luxo))

Cópia exata de `studio/src/motion/references/aurea-opus.tsx`. Medida de acabamento do estilo, não modelo de texto.

```tsx
/* Aurea Dermatologia: a skin evaluation consultation told like an editorial page. Serif, air, lines that draw slowly, one strong moment.
 * 1 hook      2.2 s  "Sua pele merece / tempo."                     slow push-in, blur-in serif, italic word, underline draws   shimmer
 * 2 consulta  2.6 s  "Consulta de / avaliação da pele"              fade, arches reveal from bottom (rect mask), mask-up type    whoosh
 * 3 calma     2.0 s  "Atendimento / sem pressa."                    match cut on the circle, circle breathes into blob, wave    click
 * 4 plano     3.0 s  "Um plano de cuidado / feito para você."       shape-circle wipe, flower morph, outline-fill, circle mark  pop
 * 5 agenda    2.4 s  "Agendamento / pelo WhatsApp."                 push-up, chat bubble springs, dots breathe                   whoosh
 * 6 assinatura 2.8 s "Aurea / Dermatologia" + CTA                   fade, slow pull-back, swoosh draws, CTA                      shimmer
 */
import { Sequence, Scene, Soundtrack, CallToAction, sec, Safe, At, Camera, Layer, Move, Reveal, Kinetic, Morph,
         Shape, PathDraw, Lines, Rings, Dots, Burst, Glow, Grain, Vignette, LightLeak, interpolate, spring,
         useShot, usePalette } from "@fab/motion";

/* Concentric arches that draw themselves, an editorial nod to the skin's layers */
function Arches() {
  const { frame } = useShot();
  const { c, alpha } = usePalette();
  const arcs = [0, 1, 2, 3];
  return (
    <svg width={760} height={520} viewBox="0 0 760 520" style={{ overflow: "visible" }}>
      {arcs.map((i) => {
        const r = 340 - i * 70;
        const len = Math.PI * r + 2 * 140;
        const p = interpolate(frame, [6 + i * 6, 46 + i * 6], [0, 1], { ease: "inOutCubic" });
        const breathe = 1 + 0.01 * Math.sin(frame / 18 + i);
        return (
          <path key={i}
            d={`M ${380 - r} 520 L ${380 - r} ${380} A ${r} ${r} 0 0 1 ${380 + r} ${380} L ${380 + r} 520`}
            fill="none"
            stroke={i === 0 ? c("primary") : alpha("text", 0.35 - i * 0.06)}
            strokeWidth={i === 0 ? 4 : 2}
            strokeDasharray={len}
            strokeDashoffset={len * (1 - p)}
            transform={`translate(380 520) scale(${breathe}) translate(-380 -520)`}
          />
        );
      })}
    </svg>
  );
}

/* A quiet chat bubble with three breathing dots */
function ChatBubble() {
  const { frame } = useShot();
  const { c, alpha } = usePalette();
  const pop = spring(frame, 4, "gentle");
  return (
    <div style={{ position: "relative", width: 300, height: 190, transform: `scale(${0.7 + 0.3 * pop})`, opacity: pop }}>
      <div style={{ position: "absolute", inset: 0, borderRadius: 70, background: c("background"),
                    boxShadow: `0 30px 90px ${alpha("black", 0.35)}`, display: "flex", alignItems: "center",
                    justifyContent: "center", gap: 26 }}>
        {[0, 1, 2].map((i) => {
          const b = 0.5 + 0.5 * Math.sin(frame / 7 - i * 0.9);
          return <div key={i} style={{ width: 30, height: 30, borderRadius: 15, background: c("primary"),
                                       opacity: 0.35 + 0.65 * b, transform: `translateY(${-8 * b}px)` }} />;
        })}
      </div>
      <div style={{ position: "absolute", left: 50, bottom: -26, width: 60, height: 60, background: c("background"),
                    transform: "rotate(45deg)", borderRadius: 10 }} />
    </div>
  );
}

/* A thin rule with a small label, the masthead of an editorial page */
function Masthead({ label, at = 0 }: { label: string; at?: number }) {
  const { frame } = useShot();
  const { c, body } = usePalette();
  const p = interpolate(frame, [at, at + 30], [0, 1], { ease: "outCubic" });
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 24, opacity: p }}>
      <div style={{ width: 140 * p, height: 2, background: c("primary") }} />
      <div style={{ fontFamily: body, fontSize: 30, letterSpacing: "0.24em", textTransform: "uppercase", color: c("text") }}>
        {label}
      </div>
    </div>
  );
}

export default function Piece() {
  return (
    <Sequence soundtrack="track">
      <Soundtrack volume={0.5} />
      {/* 1. hook: a slow push, the italic word lands and is underlined */}
      <Scene canvas duration={sec(2.2)} bg="background" sfx="shimmer">
        <Camera keys={[{ at: 0, zoom: 1.1, y: 30 }, { at: 66, zoom: 1, y: 0, ease: "outQuint" }]}>
          <Layer depth={1.6}><Lines angle={90} color="text" alpha={0.05} size={120} drift={[-20, 0]} /></Layer>
          <Glow color="primary" x={0.3} y={0.35} size={0.9} intensity={0.25} />
          <Safe align="flex-start" gap={10}>
            <Kinetic mode="blur-in" by="word" size={150} color="text" at={2} step={6} dur={20} leading={1.02}>
              {"Sua pele\nmerece"}
            </Kinetic>
            <Kinetic mode="mask-up" size={190} color="primary" italic weight={400} at={20} dur={18}>tempo.</Kinetic>
            <PathDraw path="underline" width={460} height={40} color="accent" stroke={5} at={34} dur={24} />
          </Safe>
        </Camera>
      </Scene>

      {/* 2. the consultation: arches revealed from the bottom, ending on a circle at the top */}
      <Scene canvas duration={sec(2.6)} bg="background" transition="fade" sfx="whoosh">
        <Camera keys={[{ at: 0, zoom: 1.04, y: -20 }, { at: 78, zoom: 1, y: 0, ease: "smooth" }]}>
          <Layer depth={1.2}><Dots color="primary" alpha={0.08} size={70} line={3} drift={[0, -16]} /></Layer>
          <Safe gap={44}>
            <Masthead label="Avaliação" at={4} />
            <Reveal shape="rect" from="bottom" at={4} dur={34} ease="outCubic">
              <Arches />
            </Reveal>
            <Kinetic mode="mask-up" by="line" size={104} color="text" align="center" at={16} step={8} dur={20} leading={1.08}
                     accent={{ pele: "primary" }}>
              {"Consulta de\navaliação da pele"}
            </Kinetic>
          </Safe>
        </Camera>
        <At x={0.5} y={0.09}>
          <Move keys={[{ at: 30, scale: 0, opacity: 0 }, { at: 54, scale: 1, opacity: 1, ease: "outCubic" }]}>
            <Shape shape="circle" size={110} color="accent" />
          </Move>
        </At>
      </Scene>

      {/* 3. calm: match cut on the circle, which breathes slowly into an organic form */}
      <Scene canvas duration={sec(2)} bg="background" transition="match" sfx="click">
        <At x={0.5} y={0.09}>
          <Morph keys={[{ at: 0, shape: "circle" }, { at: 50, shape: "blob" }]} size={110} color="accent" spin={6} />
        </At>
        <Camera keys={[{ at: 0, zoom: 1, x: 0 }, { at: 60, zoom: 1.04, x: -20, ease: "smooth" }]}>
          <Layer depth={1.4}><Rings color="primary" alpha={0.08} size={200} line={2} x={0.5} y={0.5} /></Layer>
          <Safe align="flex-start" gap={30}>
            <Kinetic mode="fade" by="word" size={120} color="text" at={4} step={5} dur={18}>Atendimento</Kinetic>
            <Kinetic mode="blur-in" by="word" size={170} color="primary" italic weight={400} at={14} step={8} dur={22} accent={{ pressa: "accent" }}>
              {"sem pressa."}
            </Kinetic>
            <PathDraw path="wave" width={700} height={70} color="primary" stroke={3} at={18} dur={36} />
          </Safe>
        </Camera>
      </Scene>

      {/* 4. the strong moment: circular wipe, a flower blooms, the plan is written large */}
      <Scene canvas duration={sec(3)} bg="primary" transition="shape-circle" sfx="pop" hits={[{ at: 40, kind: "shimmer" }]}>
        <Camera keys={[{ at: 0, zoom: 1.12, tiltX: 8 }, { at: 54, zoom: 1, tiltX: 0, ease: "outExpo" }, { at: 90, zoom: 1.03 }]}
                perspective={1800}>
          <Layer depth={0.7}>
            <At x={0.5} y={0.44}>
              <Move keys={[{ at: 0, scale: 0.4, opacity: 0 }, { at: 24, scale: 1, opacity: 0.22, ease: "outCubic" }]}>
                <Morph keys={[{ at: 0, shape: "circle" }, { at: 30, shape: "flower" }]} size={820} color="background" spin={10} />
              </Move>
            </At>
          </Layer>
          <Safe gap={24}>
            <Kinetic mode="outline-fill" by="line" size={150} color="background" align="center" at={4} step={10} dur={18}
                     leading={1.02}>
              {"Um plano\nde cuidado"}
            </Kinetic>
            <Kinetic mode="mask-up" by="word" size={120} color="accent" italic weight={400} align="center" at={30} step={5} dur={16}
                     marks={{ você: "circle" }} markColor="background" markAt={52}>
              {"feito para você."}
            </Kinetic>
          </Safe>
        </Camera>
        <Burst at={42} seed={7} kind="sparks" x={0.5} y={0.45} count={22} colors={["background", "accent"]} power={700} life={40} size={6} />
        <LightLeak color="accent" second="background" intensity={0.18} />
      </Scene>

      {/* 5. booking: push up, a calm chat bubble */}
      <Scene canvas duration={sec(2.4)} bg="text" transition="push-up" sfx="whoosh">
        <Camera keys={[{ at: 0, y: 40, zoom: 1.02 }, { at: 72, y: 0, zoom: 1, ease: "outCubic" }]}>
          <Layer depth={1.5}><Lines angle={0} color="background" alpha={0.05} size={110} drift={[0, -24]} /></Layer>
          <Safe gap={60}>
            <ChatBubble />
            <Kinetic mode="mask-up" by="line" size={112} color="background" align="center" at={10} step={8} dur={18}
                     accent={{ whatsapp: "accent" }} leading={1.08}>
              {"Agendamento\npelo WhatsApp."}
            </Kinetic>
          </Safe>
        </Camera>
        <Grain amount={0.05} />
      </Scene>

      {/* 6. signature: the name, a drawn swoosh, the CTA, a slow pull-back */}
      <Scene canvas duration={sec(2.8)} bg="background" transition="fade" sfx="shimmer">
        <Camera keys={[{ at: 0, zoom: 1.08 }, { at: 84, zoom: 1, ease: "smooth" }]}>
          <Glow color="primary" x={0.5} y={0.4} size={1} intensity={0.3} pulse={0.5} />
          <Layer depth={1.3}><Rings color="primary" alpha={0.07} size={220} line={2} x={0.5} y={0.42} /></Layer>
          <Safe gap={36}>
            <Masthead label="Dermatologia" at={2} />
            <Kinetic mode="mask-up" by="line" size={170} color="text" align="center" italic weight={400} at={6} step={8} dur={22} leading={1}>
              Aurea
            </Kinetic>
            <PathDraw path="swoosh" width={440} height={60} color="primary" stroke={5} at={22} dur={26} />
            <Kinetic mode="fade" size={56} color="text" align="center" at={30} dur={18}>
              {"Consulta de avaliação da pele"}
            </Kinetic>
            <CallToAction action="whatsapp" text="Agende pelo WhatsApp" delay={40} />
          </Safe>
        </Camera>
        <Vignette strength={0.2} />
        <Grain amount={0.04} />
      </Scene>
    </Sequence>
  );
}
```
