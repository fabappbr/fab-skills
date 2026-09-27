# Autoteste e Publicação

Prove, não presuma. Leia antes do autoteste (Fase 9) e antes de publicar (Fase 10).

## As três formas de ver o site

| Forma | Como | Serve para |
|---|---|---|
| **Desenvolvimento** | `fabapp dev` (Vite local, normalmente `http://localhost:5173`) | Construir e iterar. Código sem minificar: nunca meça desempenho aqui |
| **Build local** | `npm run build && npm run preview` dentro de `.fabapp/workspace` | Autoteste com o código de produção, Lighthouse local, checar que o build passa antes de gastar um build na plataforma |
| **No ar** | a URL que o `fabapp deploy` imprime | A verificação final e os recibos |

Diga ao usuário qual das três ele está olhando. Se o painel de pré-visualização lateral do app abrir sozinho, direcione para o navegador: o painel embutido sofre com páginas de muito movimento, e o navegador é a pré-visualização verdadeira.

## O checklist de autoteste (antes de mostrar a alguém)

Rode no build local. Audite de forma adversarial.

1. **Capturas** em 1440x900, 1280x800, 768x1024, 390x844 e 375x667. Cada seção composta de propósito em cada tamanho, nada empilhado por acidente.
2. **Cada botão e link** funciona; âncoras rolam para o lugar certo; a 404 aparece numa rota inventada.
3. **O formulário:** envio vazio mostra erros legíveis; envio válido mostra o estado de sucesso; o campo isca bloqueia robô. O envio real é testado no ar.
4. **O movimento no topo, meio e fim**, rolando devagar e dando flicks rápidos (passos de roda de 120, 240 e 360px). Nada engasga, nada fica preso num estado intermediário, nenhuma seção fixada prende o visitante.
5. **Cada entrada realmente toca** (a cascata pode matá-las em silêncio) e aposenta os atrasos de escalonamento depois: passe o mouse no segundo e terceiro itens de uma grade.
6. **Movimento reduzido:** carregue com ele ligado (tudo no estado final, nenhum motor rodando); depois vire a preferência COM a página aberta, nas duas direções.
7. **Sem os plugins:** bloqueie o JavaScript de GSAP, Lenis ou WebGL (ou simule a falha do import) e confirme que a página continua completa e legível.
8. **Rolagem lateral:** tente forçar a página para o lado em 375px, com links de âncora e decorações largas.
9. **Legibilidade:** a auditoria do pior pixel em cada texto sobre imagem (em `construcao-react.md`).
10. **Teclado:** percorra a página inteira só com Tab; o foco é sempre visível e segue a ordem de leitura; o momento interativo funciona pelo teclado.
11. **Console** limpo em desktop e celular: zero erros, zero avisos de React.
12. **Rabos das letras** (g, y, p) em todo texto mascarado, a 100% de zoom.
13. **Lighthouse no build local:** acessibilidade, boas práticas e SEO em 100. Desempenho é medido de verdade no ar.
14. **O passe de olhos frescos, por último.** Largue o checklist e olhe como um visitante de primeira vez. Cada elemento tem motivo de estar ali? Algum elemento paralelo está desigual? A página lê como feita sob medida para esta marca, ou algum trecho lê como enchimento? A assinatura se destaca? Conserte antes de o usuário ver.

Se o ambiente permitir outro agente revisor, aponte-o para o build pronto: o checklist prova o que você pensou em checar; um par de olhos independente acha o resto.

Reporte o que encontrou e o que consertou.

## A rota de Chrome headless

Para checagens que precisam de um navegador real controlável (emulação de toque de verdade, virar movimento reduzido ao vivo, bloquear um script, capturar a página composta):

1. Lance o Chrome com `--headless=new --disable-gpu --remote-debugging-port=9222 --user-data-dir=<pasta temporária> --hide-scrollbars`.
2. Do Node 22 ou mais novo (WebSocket global, zero dependências): GET em `http://127.0.0.1:9222/json/list`, pegue o `webSocketDebuggerUrl` e conecte.
3. Comande pelo protocolo DevTools: `Page.navigate`, `Page.captureScreenshot`, `Runtime.evaluate`, `Emulation.setDeviceMetricsOverride`, `Emulation.setTouchEmulationEnabled` (sempre com `maxTouchPoints: 5`; zero é rejeitado), `Emulation.setEmulatedMedia` (para `prefers-reduced-motion`), `Network.setBlockedURLs` (para simular plugin que falhou), `Input.dispatchMouseEvent` e `Input.dispatchKeyEvent`.

Com Node abaixo de 22, use `npx -y puppeteer` ou o Lighthouse para o que der.

## Lighthouse

```bash
npx -y lighthouse <URL> --output=json --output-path=./lighthouse.json --chrome-flags="--headless=new" --quiet
node -e "const r=require('./lighthouse.json');for(const[k,v]of Object.entries(r.categories))console.log(k,Math.round(v.score*100));const a=r.audits;console.log('LCP',a['largest-contentful-paint'].displayValue,'CLS',a['cumulative-layout-shift'].displayValue,'TBT',a['total-blocking-time'].displayValue)"
```

O padrão do Lighthouse é o perfil de celular (dispositivo de gama média, rede lenta). Rode três vezes no ar e reporte a mediana. Sem Chrome na máquina, a API do PageSpeed Insights mede o mesmo pela web: `https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=<URL>&strategy=mobile`.

Nota abaixo da meta: leia as oportunidades do relatório, conserte a maior primeiro, meça de novo. Nunca apresente estimativa como recibo.

## Publicação

1. **Definição primeiro:** `fabapp pull` (para não sobrescrever o que o dono mudou no Studio), aplique suas mudanças em `fab.schema.json`, `fab.automations.json` e `apps/<slug>/fab.config.json`, e `fabapp push`. Leia a saída: a plataforma pode normalizar ou adicionar algo ("The platform added: ..."); rode `pull` de novo quando disser.
2. **Tipos e build local:** `npx tsc --noEmit` e `npm run build` no workspace. Um build que falha aqui falharia na plataforma e custaria um build.
3. **Código:** `fabapp deploy`. Leia a saída inteira:
   - `~ src/...` arquivos enviados e `+ pacote@versão` dependências enviadas;
   - `! ...` o que a plataforma ignora (config de build, `@plugin`, arquivo da plataforma): se algo que você precisava está nessa lista, o site no ar não vai ter aquilo;
   - arquivos que sumiram do workspace (reportados, nunca apagados do app);
   - `✓ Live: <url>` e o aviso de template, se houver.
4. **Se der `account_builds_busy`:** espere um minuto e repita. **Se der `build_failed`:** leia arquivo, linha e coluna, conserte e só então repita.

## Verificação no ar (antes de dizer ao usuário que está pronto)

```bash
URL=https://<slug>.fabapp.app
curl -sSI "$URL" | head -1                                   # 200
curl -s "$URL" | grep -oE '<title>[^<]*</title>|<meta name="description"[^>]*>|<meta property="og:image"[^>]*>|<link rel="canonical"[^>]*>'
curl -s "$URL/sobre" | grep -o '<title>[^<]*</title>'       # cada rota estática tem o próprio head
curl -sS "$URL/robots.txt"; curl -sSI "$URL/sitemap.xml" | head -1; curl -sSI "$URL/llms.txt" | head -1
```

- O console do navegador está limpo na URL do ar.
- O movimento funciona no ar como funcionava local (confira os plugins: se o `deploy` não listou a dependência, o build falhou ou ela não foi enviada).
- **Lead de teste:** envie o formulário no ar, confirme que o registro aparece no CMS do Studio e que o e-mail chegou ao dono. Peça para ele confirmar o e-mail e apague o registro de teste.
- **WhatsApp:** o link abre a conversa certa com a mensagem pronta, no celular e no desktop.
- Um cache velho pode mostrar a versão anterior: recarregue forçado ou confira uma frase que você sabe que mudou.

## Depois do primeiro deploy: imagens, domínio, integrações

- **Imagens:** liste para o usuário os slots, com o que cada um espera. Guie-o a abrir a pré-visualização da surface no Studio e usar o botão de trocar imagem em cada slot: enviar a foto dele, ou gerar a partir do prompt já escrito (o Studio mostra o custo em créditos antes). Peça para ele avisar quando terminar, e NÃO edite o site enquanto isso. Quando ele avisar: confirme que todas as suas edições já estão publicadas, rode `fabapp dev --reset` para trazer o código com os `src` escolhidos, e inspecione cada imagem no ar (marca registrada, anatomia, cor da marca, composição) e refaça a auditoria de legibilidade.
- **Imagem de compartilhamento:** escolha uma das imagens escolhidas (a URL está no `src` da `<AppImage>` depois do `--reset`) ou uma que o dono enviar, em 1200x630, coloque no `seo.ogImage`, `fabapp push` e `fabapp deploy` para o cartão mudar.
- **Domínio próprio:** pergunte, clicável, se ele quer agora. Ele configura no Studio (recurso de plano) e segue as instruções de DNS que o Studio mostra. Depois do domínio ativo, o `sitemap.xml` passa a ser escrito no próximo build.
- **Integrações:** recomende os cards que fazem sentido (Google Analytics ou Tag Manager, Meta Pixel, consentimento de cookies, chat, e-mail com domínio próprio) e o que cada um pede. O dono conecta; o próximo build injeta.

## Os recibos

Logo após a verificação, meça e apresente:

- Lighthouse mobile no ar: desempenho, acessibilidade, boas práticas, SEO, mais LCP, CLS e TBT.
- A nota de SEO da tela de Marketing do Studio (peça ao usuário para abrir, ou leia os itens que ela checa pelo head servido).
- O peso da página inicial (HTML, CSS, JS e a imagem do hero).

Apresente junto com o argumento estrutural: o site é pré-renderizado e servido na borda, as imagens são otimizadas e carregadas sob demanda, e o movimento só usa propriedades que o navegador anima sem custo. Registre os números para o usuário citar ao próprio cliente.

## O teste do usuário

Peça para o usuário abrir o site no ar no desktop E no celular, na rede real, e rolar a página inteira. Os olhos e o aparelho dele pegam o que auditorias não pegam.

## Iterar é barato

Mude, `fabapp deploy`, verifique no ar. Mudanças de tema ou SEO: `fabapp push` e depois `fabapp deploy` (o tema e o SEO só entram num build novo).
