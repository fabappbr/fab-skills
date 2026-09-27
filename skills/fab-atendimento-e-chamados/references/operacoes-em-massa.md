# Operações em massa com segurança (mover, reatribuir, fechar, apagar)

Vale para toda ação que grava em mais de um chamado de uma vez. É a regra de segurança do app: o dono nunca é
surpreendido pelo que um clique mudou.

## 1 a 5. O protocolo de operações em massa

Grupo, prévia, confirmação, gravação em lotes e registro seguem o protocolo de operações em massa e o modelo
`audit_log` (os mesmos da skill `fab-dados-seguros`, que manda neles se estiver instalada): seleção por caixa ou "todos os que batem com o filtro" (ids buscados página a página até
voltar menos que 200), prévia com contagem exata antes de qualquer escrita, botão "Confirmar" até 20 registros e
número digitado acima de 20, `updateMany` em lotes de 200 com progresso e relatório por registro, "Tentar de novo só
os que falharam", 429 tenta uma vez e para, entrada no `audit_log` com esperado e afetado.

O que é específico de chamado:
- A prévia mostra os 20 primeiros (protocolo, assunto, etapa atual, responsável atual) e "e mais N", e diz se dá para
  desfazer: mover e reatribuir dão (o log guarda o valor anterior em `before`); fechar dá (reabrir); apagar é exclusão
  lógica, só o suporte da plataforma recupera.
- Apagar, em qualquer quantidade: número digitado e só `admin`.
- A prévia vale por 5 minutos; depois disso o app refaz a busca e mostra a contagem nova antes de gravar.
- A tela "Histórico de alterações" (só admin) lista as operações e, para mover e reatribuir, oferece "Desfazer" que
  devolve cada registro ao valor de `before` (com a mesma prévia e confirmação). O log não ressuscita registro apagado.

## 6. Regras por ação

- **Mover de etapa**: para etapa do tipo `closed`, abre o diálogo de resolução uma vez e aplica a todos
  (`resolution`, `resolution_note`, `closed_at`, `resolved_by`). Sem resolução, o botão fica desabilitado.
- **Reatribuir** (alguém saiu da equipe ou está de férias): filtro "responsável = fulano, em aberto", escolhe o novo
  responsável, prévia, confirma. Chamados fechados não mudam de dono.
- **Mudar prioridade em massa**: recalcula `first_response_due_at` e `due_at` de cada um a partir de `opened_at`;
  a prévia avisa quantos passam a ficar atrasados.
- **Apagar**: só admin, sempre individual ou por filtro com número digitado; prefira fechar com resolução "Duplicado"
  ou "Não procede".

## 7. Quem pode

Ações em massa: `admin` ou `perm:tickets.bulk` (papel Supervisor). Atendente vê as caixas de seleção só para
"Atribuir a mim". Esconder o botão não basta: a regra de acesso de `update` do modelo continua valendo, e a tela
confere o papel antes de abrir a prévia.

## 8. Importar chamados antigos de planilha

`<CsvImport model="ticket" fields={...}/>` (assunto, descrição, prioridade, categoria, e-mail do solicitante, data).
Antes, o app normaliza a chave natural (e-mail em minúsculas e sem espaços) e confere duplicidade por
e-mail + assunto; o relatório por linha diz criado, pulado (duplicado) ou erro, e permite baixar só as linhas com
erro para corrigir e reenviar. Importar em lote só com a mesma prévia e contagem.
