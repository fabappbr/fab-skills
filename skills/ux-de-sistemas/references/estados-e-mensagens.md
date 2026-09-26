# Estados, avisos e textos da interface

## Catálogo de estados (toda tela com dados)

| Estado | Mostrar | Peça |
|---|---|---|
| Carregando (primeira vez) | forma do conteúdo, imediato (o atraso de ~300 ms vale só para recarga de área já desenhada) | `Skeleton` |
| Carregando (ação do usuário) | carregamento no próprio botão, texto "Salvando…" | `LoadingButton` |
| Vazio: sem dados ainda | para que serve a área, por que está vazia, como preencher | `EmptyState` com ação |
| Vazio: busca sem resultado | o termo buscado + sugestões + limpar busca | `EmptyState` |
| Vazio: filtro que zerou | filtros ativos + "Limpar filtros" | `EmptyState` |
| Erro ao carregar | o que houve (mensagem do servidor) + "Tentar de novo" | `Alert` ou `EmptyState` |
| Parcial | o que chegou aparece; a parte que falhou mostra seu próprio erro | por seção |
| Sem permissão (403) | o que a pessoa não pode ver e quem pode liberar | `EmptyState` sem ação de criar |
| Sessão expirada (401) | "Sua sessão expirou. Entre de novo." + volta à tela após login | redirecionar ao login |
| Não encontrado (404) | "Este pedido não existe ou foi excluído." + link para a lista | página |
| Texto longo | corta com reticências e mostra inteiro no `title`/detalhe | `truncate`, `min-w-0`, `break-words` |
| 0, 1, muitos | "Nenhum pedido", "1 pedido", "12 pedidos"; número grande "1.254" | plural correto |
| Dados antigos | "Atualizado há 5 min" + "Atualizar" em telas abertas por muito tempo | texto discreto |

Nunca tela em branco, nunca spinner cobrindo a página inteira: bloqueie só a região que carrega.

## Quanto tempo esperar antes de mostrar o quê

| Duração | Tratamento |
|---|---|
| até 100 ms | nada (parece instantâneo) |
| 100 a 300 ms | só a mudança de estado do botão |
| 300 ms a 1 s | indicador pequeno |
| 1 a 5 s | `Skeleton` ou barra de progresso |
| 5 a 10 s | progresso com estimativa e botão de cancelar |
| mais de 10 s | etapas visíveis e opção de continuar usando o app enquanto termina |

## Erros do servidor (`ApiError`)

| Status | Na tela |
|---|---|
| 422 | mensagem do servidor ao lado do campo; nada digitado se perde |
| 409 | conflito explicado ("Alguém alterou este pedido. Recarregue para ver a versão atual.") |
| 403 | estado sem permissão |
| 401 | sessão expirada |
| 402 | recurso pago sem crédito: aviso ao admin, nunca ao cliente final com jargão |
| 429 | "Muitas tentativas. Aguarde um minuto e tente de novo." |
| rede ou 5xx | "Não foi possível carregar. Verifique a internet e tente de novo." + "Tentar de novo" |

Sempre mostre `e.message` quando existir: a plataforma já escreve a razão para a pessoa. Nunca troque por uma frase fixa genérica.

## Textos modelo

Estrutura de erro: o que aconteceu + como resolver, sem culpar ("Não conseguimos salvar. Confira o telefone e tente de novo."). Evite "Erro", "Inválido", "Falha 422".

Vazio: "Nenhum cliente ainda. Os clientes que você cadastrar ou importar aparecem aqui. [Cadastrar cliente] [Importar planilha]".

Confirmação: título com a ação e o objeto, consequência, botões com verbo. "Excluir o pedido PED-0012? Ele sai das listas e dos relatórios. [Cancelar] [Excluir pedido]". Nunca "Tem certeza?" com "Sim/Não".

Sucesso: curto, com o próximo passo quando ajudar. "Pedido salvo." "Convite enviado para ana@exemplo.com."

Carregando com contexto: "Buscando horários livres…", "Salvando alterações…".

Botões: verbo + objeto ("Salvar cliente", "Enviar orçamento", "Aprovar pagamento"); nunca "Enviar" solto, "Clique aqui", "OK" em ação importante.

Voz: amigável sem ser informal demais, clara sem ser seca, direta sem ser mandona, humana sem ser robótica. A mesma voz em botão, erro, vazio, aviso e e-mail. Sem piada em erro de pagamento ou perda de dado.

## Avisos por gravidade

| Situação | Forma | Duração |
|---|---|---|
| Precisa decidir agora (excluir, sair sem salvar) | `AlertDialog`/`ConfirmDialog` | até decidir; nunca duas janelas empilhadas |
| Urgente, não bloqueia (pagamento recusado, integração desligada) | `Alert` fixo no topo da área | até resolver ou fechar; no máximo 1 ou 2 visíveis |
| Terminou bem (salvo, enviado) | toast de sucesso | 4 s |
| Toast com ação ("Desfazer") | toast | 6 a 8 s, ou até fechar |
| Erro | toast de erro ou `Alert` no local | 8 a 10 s ou até fechar; erro crítico nunca some sozinho |
| Evento em segundo plano na mesma tela | indicador na própria linha ou seção | até ver |
| Evento em outra área | badge no menu (`useNotifications`) e, se combinado, push | até abrir |
| Manutenção, conexão | `Alert` persistente | enquanto durar |

Toasts: sempre no mesmo lugar (embaixo, centro ou direita), no máximo 3 ao mesmo tempo, o mais novo em cima, todos fecháveis. Cor combina com a gravidade real (vermelho só para o que é grave) e nunca é o único sinal: ícone e texto também.

Badge: número de 1 a 99, depois "99+"; ponto quando só importa "tem novidade"; some ao abrir a área.

Central de avisos (sino): lidos e não lidos distintos, agrupados por Hoje, Ontem, Esta semana, Anteriores; "Marcar todos como lidos"; clicar leva ao registro; vazio diz "Tudo em dia".

Push: pedir permissão no contexto e depois de a pessoa ver valor (ex.: ao criar o primeiro agendamento, "Quer ser avisado quando o cliente confirmar?"), nunca no primeiro acesso. Tela própria antes do pedido do navegador explicando o ganho; "Agora não" respeitado por 30 dias; recusado, mostre como reativar e ofereça e-mail. `<EnablePushButton/>` no lugar em que faz sentido. Preferências por tipo e canal numa tela de configurações, com padrões sensatos (nem tudo ligado), guardadas em `appUser.fields` e respeitadas pelo código que envia.

Reprovado: pedir push no primeiro acesso; mandar todo evento como push; aviso sem preferência; janelas empilhadas; erro crítico que some sozinho; tudo com a mesma urgência; dez avisos para dez comentários do mesmo registro (agrupe); ação que só existe dentro de um aviso.

## Busca

- Campo visível (não escondido atrás de ícone no computador), lupa à esquerda, "✕" para limpar ao digitar, largura total no celular, rótulo acessível (`aria-label`) e `role="search"` no contêiner.
- Placeholder diz o escopo em até 40 caracteres: "Buscar por nome, telefone ou CPF".
- Debounce de 200 a 300 ms; indicador se demorar mais de 300 ms; a busca fica na URL e volta ao navegar.
- Busca global com Ctrl+K (`Command`) em sistemas com 4 ou mais áreas: resultados agrupados por tipo (Clientes, Pedidos), 7 a 10 visíveis, trecho buscado em negrito, setas navegam, Enter abre.
- Sem resultado: repete o termo, sugere conferir a grafia, buscar por outro campo e limpar filtros; nunca só "Nenhum resultado".
- Ordem padrão por relevância em busca de texto e por mais recente em listas; trocar a ordem não limpa filtros.
