# Acessibilidade, metas de leitura, tiques e checklist

## Os 13 tiques de texto gerado em interface

| Tique | Ruim | Bom |
|---|---|---|
| Importância inflada | "Parabéns! Você acaba de desbloquear um novo jeito de gerenciar sua agenda." | "Agenda criada." |
| Adjetivo de propaganda | "Aproveite um pagamento rápido, fácil e sem complicação." | "O pagamento leva cerca de 2 minutos." (se for verdade) |
| Paralelismo negativo | "Não é só um botão de excluir. É tranquilidade." | "Excluir apaga o arquivo. Não dá para desfazer." |
| Atribuição vaga | "Estudos mostram que clientes adoram lembretes." | "Os lembretes saem um dia antes do horário." |
| Enchimento | "Para que você possa salvar suas alterações, clique no botão abaixo." | "Para salvar, toque em Salvar." |
| Fuga do "é" | "Este botão serve como forma de ativar o modo escuro." | "Este botão ativa o modo escuro." |
| Trio forçado | "Agenda rápida, simples e poderosa." | "Marque horários sem sair do WhatsApp." |
| Travessão | frase com o traço longo ligando duas partes | "Sua planilha está pronta. Baixe antes de o link expirar." |
| Title Case | "Salvar Alterações" | "Salvar alterações" |
| Fecho genérico | "Tudo pronto! Aproveite o app!" | "Tudo pronto. Próximo passo: cadastrar seus serviços." |
| Emoji decorativo | "Upload concluído! 🎉" | "Arquivo enviado." |
| Desculpa sem fato | "Ops! Algo deu errado. Tente mais tarde." | "Suas alterações não foram salvas porque a conexão caiu. Reconecte e salve de novo." |
| Consequência sem nome | "Tem certeza?" | "Excluir o projeto 'Reforma Loja 2'? As 14 tarefas dele também saem. Não dá para desfazer." |

Onze tiques se consertam cortando algo. Dois (desculpa sem fato e consequência sem nome) só se consertam acrescentando o fato: use o dado do app; se for regra do dono, frase verdadeira sem ele + pergunta ao dono na mensagem final.

Frases que não têm tique nenhum e ainda falham na regra do elemento: "Nenhum resultado." (estado vazio sem ação), "Enviar" (botão sem resultado), "Salvar alterações" como dica do botão "Salvar alterações" (repete o rótulo), "Seu projeto será excluído." como toast depois da exclusão (tempo errado).

Texto dentro de citação exata (cláusula legal, nome de produto de terceiro, texto que o dono digitou) mantém a pontuação original; diga que manteve de propósito.

## Metas de tamanho

| Elemento | Meta |
|---|---|
| Botão | 2 a 4 palavras (máx. 6), 15 a 25 caracteres |
| Título de tela | 3 a 6 palavras, até 40 caracteres |
| Erro | 12 a 18 palavras com a solução |
| Instrução | ideal 14 palavras, máx. 20 |
| Corpo | 13 a 18 palavras por frase em português simplificado |
| Notificação | título 35 a 45 caracteres; título + corpo 10 a 15 palavras |
| Linha de texto | 40 a 60 caracteres (limite a largura com `max-w-prose` ou similar) |

Compreensão: frase de até 8 palavras é entendida por quase todos; até 14, por 9 em cada 10; acima de 25, a compreensão cai muito.

Português simplificado (inspirado no projeto PorSimples, NILC/USP, e na Lei 15.263/2025, Política Nacional de Linguagem Simples): público geral e saúde, média de até 15 palavras por frase; ajuda e onboarding, até 13; ferramenta de profissional, até 18. Para o público geral, texto que um aluno do fim do ensino fundamental entende; em ferramenta de profissional, termos do ramo podem ficar, explicados na primeira vez.

## Acessibilidade

**Leitor de tela:** anuncia tipo do elemento, texto e estado. Botão com contexto ("Excluir endereço", não só "Excluir" repetido 5 vezes na lista; use `aria-label` com o nome do item quando o texto visível for curto). Link descreve o destino ("Ler a política de privacidade", não "Clique aqui" nem "Leia mais"). Erro lido junto do rótulo ("Telefone, precisa ter DDD") e ligado ao campo. Ícone só com imagem: `aria-label` ("Fechar", "Buscar", "Abrir menu"). Imagem com texto alternativo que diz a função; imagem decorativa com `alt=""`.

**Cognitiva:** frases curtas; blocos escaneáveis; títulos claros em hierarquia; padrões previsíveis (mesma palavra, mesmo lugar); não fazer a pessoa lembrar do que viu na tela anterior; repetir a informação crítica no ponto da ação; revelar o complexo aos poucos.

**Vários sentidos:** nunca só a cor ("Erro: o e-mail precisa ter @" com ícone, não só borda vermelha); campo obrigatório com mais do que cor; status com texto além do ícone. Contraste mínimo 4,5:1 no texto comum e 3:1 no texto grande: a paleta vem da marca, então use os tokens do tema (`text-foreground`, `text-muted-foreground`) e nunca texto claro sobre foto sem véu.

**Sem referência de posição ou sensorial:** nada de "o botão abaixo", "o ícone verde"; diga o nome do controle.

**Linguagem simples:** palavra comum ("usar", não "utilizar"; "comprar", não "adquirir"; "encerrar", não "finalizar a operação"); voz ativa na maior parte ("Vamos processar seu pagamento" é melhor que "Seu pagamento será processado"); verbo concreto ("Escolha", não "Faça uma seleção"); dizer o que fazer ("Para continuar, confirme o e-mail"), mais do que o que não fazer; sem expressão idiomática e metáfora em texto de sistema ("dar um norte", "bater o martelo").

**Linguagem inclusiva:** sem gênero presumido ("Boas-vindas" ou "Que bom ter você aqui" em vez de "Bem-vindo" quando não se sabe quem lê, ou use o dado de perfil); exemplos e nomes variados; sem expressão capacitista ("fingir demência", "dar uma de cego").

**Espaço para texto maior:** se o app tiver outro idioma, texto traduzido ocupa até 40% mais; não concatene frases que dependem da ordem das palavras ("Você tem " + n + " pedidos"): escreva a frase inteira com plural tratado ("1 pedido", "3 pedidos", "Nenhum pedido").

**Momentos de tensão:** erro claro de primeira, uma ação de recuperação, sem culpa, calmo. Prazo concreto ("faltam 5 minutos"), não "em breve". Decisão séria: consequência transparente, se dá para desfazer, saída óbvia ("Cancelar", "Voltar").

## Texto regulado e padrões enganosos

Termos, consentimento, privacidade (LGPD), avisos de saúde, contratos, condições de preço e juros: não reescrever o sentido em silêncio. Sugira a versão simples ao lado da original, como sugestão para o dono aprovar com quem cuida disso. Consentimento: afirmativo, claro, nada pré-marcado, recusar tão fácil quanto aceitar, botões de mesmo peso. Denuncie e não escreva: recusa com culpa ("Não, não quero economizar"), custo escondido, botão de aceitar gigante e recusar escondido, caixa pré-marcada. Não prometa resultado não verificado ("aprovado em minutos").

## Nota das quatro qualidades (0 a 10 cada)

Use para comparar versões e decidir onde mexer primeiro.
- **Curta:** cada palavra tem trabalho; sem "basicamente", "na verdade", "só"; linhas de 40 a 60 caracteres; parágrafos de até 3 ou 4 linhas; o importante primeiro; ideias por prioridade.
- **Com propósito:** ajuda a tarefa; atende o objetivo do negócio; reflete a voz; o benefício aparece antes do pedido; fala com "você"; convida sem empurrar.
- **De conversa:** soa falado; voz ativa; tem preposições e artigos (não telegráfico); palavras que o cliente usa; personalidade só onde cabe.
- **Clara:** verbo exato ("Excluir" para apagar de vez, "Arquivar" para guardar); imperativo e infinitivo no lugar certo; linguagem simples; título que orienta; termos consistentes.

Faixas: 9 a 10 excelente; 7 a 8 bom; 5 a 6 aceitável com problemas; 3 a 4 precisa de trabalho; 0 a 2 refazer.

Exemplo: "Ocorreu um erro ao processar sua solicitação. Tente novamente." Curta 6, propósito 4, conversa 5, clara 5: nota 5. Melhor: "Não conseguimos salvar suas alterações. Confira a internet e tente de novo." Curta 9, propósito 8, conversa 9, clara 9: nota 9.

## Antes e depois

| Antes | Depois | Por quê |
|---|---|---|
| "Ocorreu um erro ao processar seu pagamento. Tente mais tarde ou contate o suporte." | "Não conseguimos processar seu pagamento. Confira os dados do cartão e tente de novo." | Diz o que falhou, causa provável e ação |
| "Nenhum dado disponível." | "Nenhuma venda ainda. Registre a primeira para ver o resumo do mês." | "Ainda" diz que é temporário; ação clara |
| "O app gostaria de acessar sua localização" | "Ative a localização para ver as unidades perto de você" [Permitir] [Agora não] | Benefício antes da permissão |
| "Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita. Todos os seus dados serão permanentemente excluídos." | "Excluir sua conta? Você perde todos os dados e não dá para desfazer." | Menos redundância, consequência clara |
| "A senha deve conter no mínimo 8 caracteres incluindo letras maiúsculas, minúsculas, números e caracteres especiais." | "Crie uma senha forte (8 ou mais caracteres). Misture letras, números e símbolos." | Duas linhas escaneáveis, voz ativa |
| "Você foi descadastrado com sucesso da nossa lista. Não receberá mais e-mails. Agradecemos sua participação." | "Pronto, você saiu da lista. Se mudar de ideia, é só voltar em Configurações." | Respeita a decisão e dá saída |
| "Enviando arquivo... Aguarde." | "Enviando nota_fiscal.pdf... quase lá" | Nome do arquivo confirma o certo |

Padrões comuns: específico antes do genérico; benefício antes do pedido; frases curtas em linhas escaneáveis; sem redundância ("excluído permanentemente" vira "não dá para desfazer"); voz ativa; sempre um caminho; respeitar quem desiste.

Autoavaliação rápida: dá para tirar palavras sem perder sentido? Diz o que a pessoa precisa saber agora? Eu diria isso em voz alta? Existe verbo mais exato? Mostro o valor antes de pedir algo?

## Revisão de um fluxo inteiro (ordem)

1. Termos iguais em todas as telas (monte o inventário).
2. Cada botão: verbo primeiro, específico, par honesto.
3. Cada erro: o que houve, por quê, o que fazer, sem culpa.
4. Escaneável: palavra-chave no começo, uma ideia por frase.
5. Acessibilidade: texto de link, títulos, nada só por cor ou posição.
6. Tom de cada momento.
7. Formatos brasileiros (datas, dinheiro, telefone).
8. Texto regulado sinalizado, não reescrito.
9. Varredura final: traço longo, tiques, Title Case, exclamação em toast.

Apresente por ordem de gravidade: tela, texto atual, texto sugerido, motivo em uma linha.
