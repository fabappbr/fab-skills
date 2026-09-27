# Modos que o dono pode pedir

Cada modo parte da auditoria e termina com a verificação limitada do corpo da skill (uma passada no `fabapp dev` e no código, no máximo mais uma). Todos respeitam "O que nunca muda em silêncio". Se o dono pedir dois modos ao mesmo tempo e eles puxarem para lados opostos, pergunte qual vem primeiro.

## Polir (passada final)
Polimento é refino, nunca redesign disfarçado. Se o conceito da tela está errado, diga e proponha Repaginação ou Ousado em vez de contrabandear outro visual.
- **Classifique cada desvio antes de corrigir**: valor solto que devia ser do sistema (use o token ou a classe da escala); implementação avulsa que devia ser o componente do kit; desencontro de conceito (fluxo ou hierarquia diferente das telas parecidas); defeito local (incompleto). Corrija na causa, no nível mais estreito correto.
- Ordem: tarefas quebradas, dado perdido, estado enganoso e caminho inacessível; estados faltando; fluxo, hierarquia, celular e desvios do sistema; visual e movimento; limpeza.
- **Fluxo e hierarquia**: mesmos termos, mesmo jeito de salvar, mesma revelação progressiva das telas vizinhas; tarefa principal e estado atual óbvios sem achatar tudo no mesmo peso; chegada, transição, vazio e recuperação ligados entre si.
- **Layout e tipo**: tudo na escala de espaço; alinhamento ótico além do matemático; mesmo papel, mesmo tamanho em todas as telas; texto longo, nome longo e zoom testados.
- **Cor, imagem e ícone**: tokens com o mesmo significado no claro e no escuro; contraste em todo estado; um só conjunto de ícones, mesmo traço; imagem com proporção reservada (`aspect-[4/3]`, `aspect-video`) e `alt` útil.
- **Interação**: todo controle com padrão, passar o mouse, foco, pressionado, desabilitado, carregando, erro e sucesso; alvo de toque de 44px; movimento que pode ser interrompido. Não acrescente animação só para o polimento aparecer.
- **Conteúdo e código**: termos, maiúsculas e pontuação consistentes; tirar código morto, import sem uso e duplicação criada no polimento; trocar implementação avulsa pelo componente do kit; não criar abstração nova para uma exceção.

## Ousado ("mais ousado", "sem graça", "mais chamativo")
Quase sempre é sobre UMA parte (a página inicial, o topo, uma seção). O resto é dado.
- **O escopo é soberano**: mexa só no alvo. Não reestilize vizinhos, não traga cor, fonte, raio ou sombra que o app não tem. Se o sistema atual não consegue expressar a direção, pare e pergunte, nomeando o acréscimo exato e o trabalho que ele faria ("posso usar a cor de destaque da marca como fundo desta seção?").
- **Por que está sem graça**: em geral a seção deixa de usar o que as vizinhas já usam (o tamanho de título no máximo, o elemento que se repete na marca, o ritmo). Traga a seção para a força que o resto já tem, no vocabulário do próprio app.
- **Um gesto decidido, o resto quieto**: faça UM movimento por completo (título em `text-3xl sm:text-4xl lg:text-6xl font-extrabold`, sempre partindo da base da plataforma; foto de ponta a ponta com véu, número em destaque, fundo `bg-primary` com `text-primary-foreground`) e acalme o que está em volta. Se tudo ficou mais alto, a seção ficou mais plana.
- **Ritmo próprio**: a seção vira um pico na rolagem, mudança de densidade ou de passo.
- **Teste do esqueleto**: tire o texto e olhe só a estrutura. Ela ainda diz o que a seção é e por que importa? Se só funciona com as palavras, a ousadia está no tamanho da letra, não no desenho.
- Recursos do kit que servem aqui: `Reveal` (entrada com atraso em lista, `Math.min(i,6)*60` ms), `TextReveal`, `Counter` (número que conta, só com número real), `Parallax` leve, `ScrollScale`, `Marquee`. Um por seção, nunca todos.
- Conteúdo continua verdadeiro: nada de prova que o dono não deu.
- Fim: fora do alvo, nada mudou; nenhuma cor ou fonte nova apareceu sem pedido; o que leva à ação funciona igual; é a mesma marca, só mais segura de si.

## Calmo ("mais calmo", "tá gritando", "poluído")
Calmo não é genérico nem sem graça: é refinado.
- Em "Vender" e "Mostrar": paleta mais contida, mais espaço, mais ar na tipografia; o drama diminui, não some. Em "Operar" e "Ler": menos fundos de destaque, cards mais planos, menos cor, menos movimento; a ferramenta some dentro da tarefa.
- **Cor**: a saturação é da marca; proponha ao dono uma primária menos viva (novo `primary`, e `dark.primary` se o app tem escuro) e grave no `theme` do `fab.config.json` só com o sim, seguido de `fabapp push`. No código: neutros fazem mais trabalho, cor só no destaque (regra dos 10%), contraste alto só onde importa, nunca cinza sobre cor.
- **Peso**: 800 → 600, 700 → 500 onde não é o elemento principal; hierarquia por peso, tamanho e espaço em vez de cor e negrito; bordas mais finas ou fora.
- **Simplificar**: tirar gradiente, sombra, padrão e textura sem função; raios extremos mais contidos; menos camadas; sem brilho, desfoque e sombras múltiplas.
- **Movimento**: distâncias menores (10 a 20px, não 40px), curva de saída suave, sem quique nem elástico; tirar animação que não explica nada.
- **Composição**: saltos de tamanho menores, tudo de volta ao alinhamento, ritmo de espaço uniforme.
- Nunca: tudo do mesmo tamanho, remover toda a cor, apagar a personalidade, perder o que indica "clique aqui".

## Destilar ("mais simples", "tira o excesso")
Simplicidade é tirar obstáculos entre o cliente e o objetivo, não tirar funções.
- Ache o objetivo único da tela e os 20% que entregam 80% do valor. Se não der para saber pelo código e por `DECISOES.md`, pergunte ao dono antes de cortar.
- **Estrutura**: menos ações secundárias; revelação progressiva (`Accordion`, `Tabs`, `Sheet`, etapas); juntar botões e formulários parecidos; UMA ação principal; não repetir o que já foi dito.
- **Visual**: 1 ou 2 cores mais neutros; 3 a 4 tamanhos de letra e 2 a 3 pesos; tirar borda, sombra e fundo sem função; nunca card dentro de card; card não é layout (use espaço e alinhamento).
- **Layout**: fluxo vertical simples; conteúdo lateral para dentro do fluxo; um alinhamento só.
- **Interação**: menos escolhas, padrões inteligentes, edição na linha em vez de modal, uma etapa a menos.
- **Texto**: corte cada frase pela metade e de novo; voz ativa ("Salvar alterações"); sem jargão; parágrafos curtos.
- **Código**: tirar o que ficou sem uso; variantes demais de um componente viram 2 ou 3.
- Nunca remova uma função, um campo ou uma tela sem o sim do dono: liste o que sairia, com o motivo, e se precisar de outro caminho de acesso. Nunca sacrifique rótulo e acessibilidade; nunca simplifique a ponto de ficar misterioso.

## Legível ("letra pequena", "cansa ler", "tipografia")
- Papéis claros: título, subtítulo, corpo, rótulo, metadado, número. Papéis vizinhos com diferença visível (tamanho E peso), nunca só 1px.
- Corpo de 16px (`text-base`) ou 18px (`text-lg`) em texto corrido; 14px só em secundário; nada abaixo de 12px. Campo de formulário com 16px no celular (o iPhone dá zoom em campo menor).
- Entrelinha do corpo 1,5 a 1,75 (`leading-relaxed`); título 1,1 a 1,25; linha mais larga pede mais entrelinha.
- Medida de 45 a 75 caracteres (`max-w-prose`).
- Texto claro sobre fundo escuro: um pouco mais de entrelinha, um pouco de espaçamento, às vezes um peso a mais.
- Números com `tabular-nums` quando empilham.
- Separar parágrafos com espaço OU recuo, nunca os dois.
- A família vem da marca: se ela for o problema, sugira ao dono o par (`titleFont` e `bodyFont`, nomes exatos do Google Fonts) e, com o sim, grave no `theme` e rode `fabapp push`.

## Endurecer ("quebra com nome grande", "e se não tiver nada?")
Um app que só funciona com dado perfeito não está pronto. Teste com o que o cliente real digita:
- **Texto extremo**: "Maria Aparecida dos Santos Oliveira de Albuquerque", nome de produto com 80 caracteres, um caractere só, campo vazio, acentos e ç, emoji no nome. Conserto: `truncate` em uma linha com o texto inteiro no `title`, `line-clamp-2`/`line-clamp-3` em cards, `break-words` em textos do usuário, `min-w-0` em filhos de flex e grid, botão sem largura fixa (português ocupa 20 a 30% a mais que inglês).
- **Número extremo**: R$ 1.234.567,89, 0, negativo, 10 mil itens. Sempre `formatMoney`, `formatDate`, `formatDateTime`; datas dd/mm/aaaa, hora 24h ("14h30"); telefone (11) 91234-5678 com `PhoneInput`; CEP 01310-100; CPF 123.456.789-09 e CNPJ 12.345.678/0001-90 com máscara e validação `zod`. Nunca cortar `toISOString()` para data sem hora.
- **Quantidade**: 0, 1 e muitos itens em toda lista; paginação no servidor (`limit`/`offset` com `Pagination`), nunca carregar tudo; busca com espera de ~300ms; plural certo ("1 cliente", "2 clientes").
- **Erros da API** (`ApiError`, mostrar `e.message`): 401 volta ao login; 403 explica que a pessoa não tem acesso e a quem pedir; 404 estado "não encontrado" com volta; 409 conflito ("alguém alterou antes, recarregue"); 422 erro no campo; 402 IA sem crédito, explicado sem jargão; 429 limite, tentar mais tarde; 500 mensagem genérica com Tentar de novo. Sem internet: mensagem e botão Tentar de novo (o app não funciona offline; não prometa).
- **Formulário**: erro na linha do campo, específico, com sugestão; o que foi digitado continua lá; `LoadingButton` impede envio duplo; validação `zod` antes de enviar.
- **Estados**: vazio (primeiro uso, limpo pelo usuário, busca sem resultado, sem permissão, falha ao carregar), carregando (inicial, próxima página, atualizando), sem permissão (explica por quê).
- **Um componente com erro não derruba a tela inteira.** Arrastar (`@dnd-kit`): segundo dedo, rolagem no meio, soltar fora; o próximo toque tem de funcionar.
- Na verificação, diga o que foi conferido no código e o que não dá para testar daqui (aparelho real, rede lenta).

## Clarear ("melhora os textos", "ninguém entende")
Preserve o sentido, os termos do negócio e a voz do dono. Pergunte antes de mudar fato, sentido legal ou termo que pode ser do ramo.
- Para cada estado decida: o fato que a pessoa precisa agora, a ação seguinte, o contexto que muda a decisão, o tom do momento. Diga cada coisa uma vez; se o título já explica, a introdução acrescenta algo ou sai.
- **Botões e links**: verbo e objeto ("Remarcar horário", "Baixar recibo"); o resultado, não o gesto ("Enviar pedido", não "Clique aqui"); mesmo verbo e mesmo substantivo para o mesmo conceito no app todo.
- **Excluir**: nomeie o objeto e a consequência ("Excluir o agendamento de Ana às 14h30? Ela não será avisada."); botão com a ação ("Excluir agendamento"), nunca "Sim"/"OK".
- **Formulário**: rótulo sempre visível; placeholder é exemplo, não rótulo; exigência de formato antes do envio; obrigatório e opcional marcados do mesmo jeito em todo o app (quando quase tudo é obrigatório, marque só o opcional).
- **Erro**: o que falhou, por que (se ajuda) e como resolver. Sem código técnico; sem prometer causa que o sistema não sabe; dinheiro, privacidade, exclusão e acesso com seriedade, sem piada.
- **Carregando**: nomeie a operação ("Buscando seus horários..."). **Vazio**: diferencie primeiro uso, sem resultado, filtro e sem permissão, com a próxima ação. **Sucesso**: curto, sem exclamação.
- **Ajuda**: responde a pergunta implícita, não repete o controle; link que faz sentido fora do contexto; ícone sozinho com nome acessível (`aria-label`).
- Frases completas (não pedaços concatenados), números e variáveis no lugar certo da frase, espaço para o texto crescer, `alt` que diz a informação da imagem.
- Se o mesmo conceito tem nomes diferentes pelo app, monte um glossário curto em `DECISOES.md` (Preferências) e unifique. O texto final é o mais curto possível sem perder sentido nem a saída.

## Primeiro uso ("o cliente se perde na primeira vez")
O trabalho não é ensinar o produto: é levar a pessoa rápido ao primeiro resultado que prova que vale a pena.
- Defina o momento "entendi" (o primeiro agendamento feito, o primeiro produto cadastrado) e o mínimo para chegar lá.
- **Mostrar em vez de explicar**; opcional quando der (botão "Pular"); ensinar no momento de uso, não antes; não tratar a pessoa como boba.
- **Estado vazio é onboarding**: o que vai aparecer aqui, por que importa, botão para criar o primeiro e, se fizer sentido, "Começar com um exemplo". Ícone ou `AppImage` leve, nunca só texto numa página em branco.
- Cadastro com o mínimo de dados (o resto depois), dizendo por que pede cada coisa; 1 a 3 conceitos centrais, não tudo; progresso ("1 de 3").
- Lista de primeiros passos (3 a 5 itens, marcados conforme a pessoa faz, calculados pelos dados do app) quando o app tem configuração inicial.
- Tour guiado só se o dono pedir: 3 a 7 passos, pulável, reabrível, apontando botões reais. O "já vi" fica em `localStorage`; nunca mostrar de novo o que foi dispensado.
- Nunca: onboarding longo antes de usar, "Pular" escondido, modo tutorial separado do produto real, mostrar o onboarding inicial para quem volta.

## Adaptar ("fica ruim no celular")
Adaptar é repensar para o contexto, não encolher pixels.
- Celular: uma coluna, empilhado, componentes de largura cheia, abas embaixo (3 a 5, com rótulo, `pb-20 md:pb-0`, área segura), ação principal na zona do polegar (embaixo), `Sheet` de baixo em vez de menu suspenso longo, alvo de 44px (`h-11`) com espaço entre alvos, texto de 16px, revelação progressiva, texto mais curto.
- Tablet: duas colunas, lista e detalhe lado a lado; toque e mouse.
- Computador: usa a largura com contêiner máximo (nunca esticar até 4K), mais informação à vista, tabelas com mais colunas, passar o mouse só como extra.
- Tabela no celular vira lista de cards (cada linha um card com rótulo e valor). Linha que rola de lado usa `ScrollRow`, nunca `overflow-x-auto`.
- Nada importante só no hover (toque não tem hover). A mesma estrutura de navegação em todos os tamanhos. Não esconder função principal no celular.
- Confira a 320px, 375px, 768px e 1280px, retrato e paisagem. Arrastar e deslizar: a rolagem da página não pode ativar o controle, e o controle precisa funcionar ao toque; diga que o gesto não foi testado em aparelho real.

## Otimizar ("tá lento")
Ache o gargalo real desta tela antes de mexer; não otimize o que não é lento.
- Lista: filtro, ordem e paginação no servidor (`list({filter, sort, limit, offset, fields})`), `fields` para trazer só o que a tela mostra, `count()` em vez de trazer tudo para contar; painel com totais somados de `list` paginado ou de um modelo de resumo.
- Tempo real com `useLive`, nunca `setInterval` em lista; busca com espera de ~300ms; limpar ouvintes e timers ao desmontar.
- Imagens: proporção reservada (evita a página pular), `loading="lazy"` em imagem de dado abaixo da dobra, nunca na primeira dobra; decorativas via `AppImage`.
- Animação só em `transform` e `opacity`; `will-change` só durante animação conhecida; desfoque e sombra em área pequena.
- Tela pesada (gráfico grande, editor): o build já divide o código por rota sozinho; dentro da página, o componente pesado entra com `React.lazy(() => import('./Pesado'))` e `Suspense` com `Skeleton` (aceito; o proibido é `await import(`). `useMemo` para cálculo caro sobre listas.
- Metas de referência: maior conteúdo visível em até 2,5s, resposta ao toque em até 200ms, página sem pulo de layout (menos de 0,1). Daqui não se mede: diga ao dono o que mudou e que a medição real é no aparelho dele.

## Colorir ("tudo cinza", "sem cor")
Cor como hierarquia, significado e clima, sem trocar a identidade.
- Papéis, não amostras soltas: fundo e superfície elevada, texto principal e secundário, ação, foco e seleção, bordas, sucesso, aviso, erro e informação.
- A cor mais forte é dona de uma região ou de um papel, não espalhada em pingos; a ação principal fácil de achar; cor sem relação com hierarquia, estado ou conteúdo não é estratégia.
- Em "Operar", cor codifica ação, seleção, status e navegação; a raridade dá força ao destaque. Em "Vender", a cor pode ocupar regiões grandes (`bg-primary` numa seção inteira, `bg-primary/5` como fundo de tom).
- Contraste: texto 4,5:1, texto grande 3:1, controles e foco 3:1; conferir em todo estado, sobre imagem e no escuro. Informação por cor tem também texto, forma ou ícone. Gráfico: diferença de luminosidade e rótulo, não só matiz.
- A paleta nova (se o dono quer outra cor) vai no `theme` do `fab.config.json`, com o sim: `primary`, `primaryFg`, `bg`, `card`, `text`, `accent` e o bloco `dark` escrito com as cores do escuro, nunca invertido à mão no código.

## Layout ("espaçamento estranho", "apertado", "bagunçado")
- Teste do borrão: com os detalhes desfocados, ainda se vê o elemento principal, o secundário e os grupos em ordem?
- Agrupar pelo sentido: proximidade antes de caixa; espaço entre grupos maior que dentro (`gap-2` dentro, `gap-6` entre); ritmo com contraste entre intervalos curtos e generosos, não um valor repetido.
- Escala com base 4 (4, 8, 12, 16, 24, 32, 48, 64 px = `1, 2, 3, 4, 6, 8, 12, 16` no Tailwind), `gap` para irmãos.
- A topologia combina com o conteúdo? Cards e colunas repetidos são mesmo equivalentes, ou é padrão de framework?
- Densidade conforme frequência de uso e tipo de tela. Profundidade só quando explica estado ou hierarquia. Variação não é objetivo: repetição ajuda a reconhecer.

## Movimento ("tá parado", "sem vida")
Movimento explica estado, relação e hierarquia, ou cria UM momento que a tela mereceu.
- Durações: 100 a 150ms retorno imediato (toque, hover); 150 a 300ms mudança de estado; 300 a 500ms diálogo, painel, troca de tela; 500 a 800ms uma entrada principal autoral. Saída mais rápida que entrada.
- Curva de chegada `ease-[cubic-bezier(0.16,1,0.3,1)]` ou `ease-out`; nunca quique nem elástico por reflexo. Retorno longo parece lentidão.
- Em "Operar": 150 a 250ms, sem coreografia de abertura de página. Em "Vender": uma sequência principal ensaiada vale mais que a mesma entrada em toda seção.
- Lista que aparece como lista: `Reveal` com atraso escalonado (teto de 6 passos). Nunca transformar toda seção em lista escalonada.
- Sempre com `useReducedMotion`: reduzir deslocamento, manter a mudança de opacidade e cor que carrega sentido. Conteúdo visível por padrão (se o script falhar, nada some). Nada de `animation-timeline` (o Safari ignora e o efeito some; confira por `grep`). Laço decorativo para quando sai da tela.

## Personalidade ("sem personalidade", "sem alma")
Um detalhe que só este negócio teria, num momento que merece.
- Uma tese: em uma frase, o que o cliente deve sentir e por que isso é deste negócio. Depois o menor recurso que entrega isso: uma resposta caprichada a uma ação importante, texto na língua do ramo, um estado vazio ilustrado com `AppImage`, uma transição reconhecível.
- Proporcional: marco importante pode comemorar; salvar rotina só precisa parecer certo. Espera mostra progresso verdadeiro, nunca trabalho fingido. Erro começa pelo problema e pela saída; nada de piada com dinheiro, privacidade ou dado perdido.
- Continua bom na centésima vez; não atrasa, não bloqueia, não é obrigatório, sem som sem consentimento, sem dependência pesada. Genérico e fofinho é pior que neutro e claro.
