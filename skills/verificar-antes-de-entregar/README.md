# Verificar Antes de Entregar (`verificar-antes-de-entregar`)

## Edição terminal

Esta é a edição para agentes que constroem apps da Fabapp AI pelo terminal (Claude Code, Codex, OpenCode, Cursor,
Gemini CLI) com o CLI `@fabappai/cli`. O conhecimento é o mesmo da edição Studio; o que mudou:

- Pelo terminal a plataforma não roda o QA do gerador: o `fabapp deploy` só compila. Por isso "Onde a verificação
  acontece" virou a cadeia do terminal, e a seção nova "Conferir antes de dizer pronto" traz o passo a passo real:
  busca no código (`grep`) pelas regras que o QA do Studio pegava sozinho, manifestos que o deploy não confere,
  `npx tsc -b` e `npx vite build`, a pré-visualização do `fabapp dev`, `fabapp push`, `fabapp deploy` (com
  `account_builds_busy` e `build_failed`) e a conferência no ar.
- Os critérios de aceite do plano (até 8, `kind` code/visual) viraram a **lista de conferência** do plano, sem teto,
  com cada item marcado "no código" ou "na tela".
- A compilação do Studio (limitada por construção) virou compilação local, de graça; o que custa é o deploy que falha.
- O "build em leque sem ferramentas" virou "arquivos escritos em paralelo" (subagentes).
- Dados de exemplo e correção de registros: o token do CLI não grava registros; o dono faz no CMS do Studio ou pela
  tela de administração do app.
- Cor, fonte e raio: definidos no `fab.config.json → theme`, enviados com `fabapp push`.
- O resumo final virou a mensagem final ao dono (conferido, link, o que ele faz no Studio, o que faltou), e a memória do
  app virou `DECISOES.md`.
- Acrescentados: primeiro movimento, contrato ao vivo e a regra das duas mãos. `references/fabapp-cli.md` é copiado
  pelo script de montagem.

Faz a IA da Fabapp só declarar pronto o que conferiu, entregar completo o que o plano prometeu (sem link morto, botão vazio, TODO ou lorem) e escrever critérios de aceite que a própria plataforma consegue conferir depois do build.

- **Categoria:** other
- **Etapas:** plan, build, edit
- **Tamanho:** corpo ~4.320 tokens (plan 3.009, build 3.384, edit 2.649), sem referências (validador em 26/09/2026).

## Origem

| Skill de referência | Repositório | Licença |
|---|---|---|
| `verification-before-completion` | https://github.com/obra/superpowers (commit 5bf4e78) | MIT, Copyright (c) 2025 Jesse Vincent |
| `output-skill` (full-output-enforcement) | https://github.com/Leonxlnx/taste-skill (commit c184364) | MIT, Copyright (c) 2026 Leonxlnx |
| `webapp-testing` (SKILL.md, `examples/`, `scripts/with_server.py`) | https://github.com/anthropics/skills (commit 3337550) | Apache 2.0 (LICENSE.txt da skill) |

Análise usada: `fabapp-skills-referencia/analise/02-codigo-e-processo.md` §3 (verification-before-completion), §4 (webapp-testing) e §5 (como escrever skill: combinar a forma com a falha, tabela de racionalizações, descrição como gatilho).

Avisos de licença: as licenças MIT exigem manter o aviso de copyright e a permissão em cópias substanciais; esta é uma obra derivada reescrita em português, e os avisos acima ficam neste README. A Apache 2.0 pede indicar que houve modificação: o método de "reconhecimento antes da ação" do webapp-testing foi reescrito e trocado por critérios de aceite da plataforma; nenhum código da skill foi copiado.

## Mapa de cobertura

| Função/técnica da original | Onde está na versão Fabapp | Adaptação |
|---|---|---|
| Iron Law "no completion claims without fresh verification evidence" | "A lei de ferro" | "Evidência conferida nesta rodada" |
| "Violating the letter is violating the spirit" | Lei de ferro + racionalização "Mudei as palavras" | |
| Gate Function (identify, run, read, verify, only then) | "A função portão" | Comandos trocados por `check_build`, `read_file`, rotas e schema |
| Tabela Claim / Requires / Not Sufficient | "Afirmação, o que exige, o que não basta" | Reescrita para os claims de um app Fabapp: compila, tela existe, todas as telas, login, lista carrega, B não vê dado do A, formulário salva, botão faz X, dados de exemplo, marca, notificação, pagamento, bug corrigido, plano cumprido, contrato entre arquivos |
| Linha "Tests pass / Linter clean / Build succeeds" | Linha "O app compila" (+ racionalização "Compilou, então funciona") | Linter ≠ compilador vira compilar ≠ renderizar |
| Linha "Agent completed: VCS diff" e padrão "Agent delegation" | Linha "A outra parte já exporta X", sinal "confia no que outra etapa disse", seção "Sem ferramentas (build em leque)" | Subagente vira arquivo escrito em paralelo / etapa anterior |
| Linha "Requirements met: line-by-line checklist" e padrão "Requirements" | Linha "O plano foi cumprido" + contagem travada | |
| Red Flags (should, probably, seems to, satisfação antecipada, "just this once", cansaço, verificação parcial) | "Sinais de alerta" | Em português; "cansado" vira "o dono tem pressa" |
| Tabela de racionalizações | "Racionalizações e a realidade" | Mais linhas próprias da plataforma ("a plataforma confere depois", "é só texto") |
| Padrão Regression test red-green | Seção de edição (critério descreve o sintoma original) e linha "O bug foi corrigido" | Não há suíte de testes; o critério de aceite da edição faz o papel do teste que falhava |
| When To Apply (toda afirmação, sinônimos, implicações) | Lei de ferro + descrição | |
| output-skill: "partial output is broken output" | "Na construção: completo, sem marcador" | |
| output-skill: padrões proibidos em código (`// ...`, `// TODO`, `// rest of code`, "similar to above") | "Proibido no código entregue" | Somados os do app: `href="#"`, botão sem ação, `catch {}` vazio, lorem, lista fixa no lugar do banco |
| output-skill: padrões proibidos em prosa ("for brevity", "the rest follows the same pattern") | Racionalização "O resto segue o mesmo padrão" e regras do `finish` | |
| output-skill: atalhos estruturais (esqueleto, primeira e última seção) | "Proibido no código entregue", últimos itens | |
| output-skill: Scope → Build → Cross-check (contar entregáveis) | "Antes de escrever: conte os entregáveis" e fim do `finish` | Contagem de telas, modelos, critérios, automações |
| output-skill: Handling Long Outputs ("PAUSED X of Y") | "Escreva cada arquivo completo. Não existe continuo depois"; `finish` item 3 e `next_steps` | Na Fabapp não há "continue": o que faltou é declarado no laudo |
| output-skill: Quick Check | Contagem travada antes do `finish` | |
| (Fabapp) risco de `write_file` com trecho omitido apagar o arquivo | "Proibido no código entregue" | Armadilha real da ferramenta |
| webapp-testing: decision tree (estático x dinâmico) | Plano: `kind:'code'` x `kind:'visual'` | O que se confere no código x na tela |
| webapp-testing: Reconnaissance-then-action | "Como escrever um critério conferível" (rota, elemento real, estado depois da ação) | A plataforma abre o app no navegador e confere os critérios |
| webapp-testing: armadilha "wait for networkidle" | "Estados que o navegador da plataforma confere": Skeleton antes, vazio só depois da carga | Invertido para o lado de quem constrói |
| webapp-testing: `console_logging.py` | "Nenhum erro no console na abertura normal" | A plataforma captura o console; o dono vê "[Preview errors]" |
| webapp-testing: `element_discovery.py` (botões, links, inputs) | Critérios citam rótulos reais; "cada link aponta para rota que existe" | |
| webapp-testing: `static_html_automation.py` (preencher e enviar formulário) | Linha "O formulário salva" | |
| webapp-testing: `with_server.py` (sobe servidor, espera porta, roda, derruba) | "Onde a verificação acontece", item 3 | A plataforma sobe e abre o app sozinha; a skill não manda rodar nada |
| webapp-testing: `wait_for_timeout` | "Espere pela condição, nunca por tempo" | A análise aponta a espera arbitrária como fraqueza; seguimos condition-based-waiting |
| Análise §3: mensagem final cita o que foi verificado | "No `finish`: o resumo é um laudo" | Três blocos: conferido, depende de você, não feito |

Ficou de fora: comandos de terminal, git, commit e PR (não existem no fluxo da Fabapp); screenshots e scripts Playwright (a plataforma faz a abertura no navegador); o "[PAUSED]" literal (a Fabapp não tem "continue" dentro de uma construção).
