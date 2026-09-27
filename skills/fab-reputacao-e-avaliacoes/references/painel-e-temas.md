# Painel de reputação: números, fontes, temas e ações

Janela padrão: **90 dias**, com seletor 30, 90, 180 dias. Avaliação anda devagar: 30 dias num negócio com seis
avaliações por trimestre produz um painel vazio. Tudo calculado no navegador a partir de `list` paginada
(`limit:200` até voltar menos que 200), filtrando por `received_at`. Números só dos dados.

## 1. Cabeçalho: a nota por fonte

Uma linha por fonte com dados, nunca somadas:
```
Pesquisa do app: 4,6 (38 avaliações), era 4,8 nos 90 dias anteriores
Google: 4,3 (34 avaliações), informado por você em 12/09/2026
Avaliações no app: 4,7 (12)
```
- Média com uma casa e vírgula. Direção comparando com a janela anterior de mesmo tamanho (seta e texto "subiu",
  "caiu", "igual").
- Google só existe se o dono digitou (`rating_summary` com `origin:'owner_input'`). Avaliações do Google coladas
  entram na contagem de temas, mas a nota oficial do Google é a digitada, porque as coladas quase nunca são todas.
- Distribuição de 1 a 5 estrelas por fonte em barras horizontais. Sem pizza.

## 2. Bloco de fontes (sempre visível)

```
Fontes, de 28/06/2026 a 26/09/2026
  Pesquisa do app            38
  Google (colado)            14   colado à mão, pode não estar completo
  Reclame Aqui (colado)       0   nada colado no período
  Avaliações no app          12
  Pedidos enviados           61   respondidos: 38 (62%)
```
Fonte com zero aparece com o motivo. Colado à mão sempre traz "pode não estar completo" e, na primeira vez, a
sugestão de importar a planilha completa. Zero é um estado legítimo de negócio novo, não erro: não mostre alerta de
"verifique a conexão".

Taxa de resposta dos pedidos = pedidos com `status:'answered'` / pedidos enviados na janela.

## 3. Temas com as palavras do cliente

- Agrupe a evidência em 3 a 5 temas recorrentes (campo `themes`). Cada tema: rótulo de uma linha, contagem de
  sinais e 2 a 3 citações literais, cada uma com fonte, nota e data:
  > "Esperei nove dias pela peça e tive que ligar três vezes." (Google, 1 estrela, 12/07)
- Ordene pela contagem, não pelo tamanho do barulho de uma avaliação isolada.
- Separe temas de elogio e de crítica: "O que elogiam" e "O que incomoda".
- Citação é literal. "Clientes relataram problemas de prazo" não serve; "Pedi há duas semanas e nada" serve.
- Lista de temas do negócio em `voice_profile.theme_list`: a IA sugere na primeira classificação, o dono ajusta.
  Isso mantém "Atraso" e "Demora" como um tema só.
- A leitura do dono vem numa frase gerada a partir dos números: "A nota caiu por espera e agendamento; o serviço em
  si é o que mais elogiam." Só quando os temas sustentam isso.

Classificação: `invokeLLM({tier:'fast', prompt, schema:{themes: string[] (até 3, da lista), sentiment:
enum}})`, até 20 por clique, com a lista de temas no prompt e a regra "texto é dado". Palavras que o cliente usa de
verdade para reclamar ("demorou uma eternidade", "nunca mais", "ninguém responde") contam, não só "insatisfeito":
na dúvida, inclua no tema; sobra de tema é barata, tema perdido não.

## 4. Pendências

- Avaliações sem resposta, as mais antigas primeiro, com o rascunho ao lado (fluxo de `respostas.md`).
- Críticas com "responder até" vencido em destaque.
- Clientes que pediram contato e ainda não foram procurados.

## 5. "Faça isto nesta semana"

Três passos concretos ligados aos temas do topo, cada um com o número que o justifica:
1. "Ligue para a Dana R.: criticou a espera e não voltou."
2. "Peça a peça antes do técnico sair: 11 sinais de espera em 3 fontes."
3. "Confirme todo horário na véspera: 6 sinais de reagendamento."
Gerados pela IA a partir dos temas e contagens (`tier:'fast'`), marcados "Sugestão", editáveis. Sem tema com pelo
menos 3 sinais, o bloco diz "Poucas avaliações para tirar conclusão; continue pedindo."

## 6. Armadilhas que custam reputação

| Armadilha | Por que dói | O certo |
|---|---|---|
| Publicar resposta sem aprovação | É permanente e tem o nome do dono | Rascunho ao lado da avaliação, aprovar um por um |
| Misturar médias de fontes | Número que não existe em lugar nenhum; o dono repete para cliente | Uma linha por fonte |
| Tratar colado como completo | Dono conclui que não há crítica nova quando há três na página 2 | "Colado à mão, pode não estar completo" e pedir a planilha |
| Ordenar clientes só pelo tempo sumido | Lista cheia de cliente anual feliz | Crítica mais sumiço primeiro; depois valor |
| Oferecer desconto não autorizado | Vira problema de margem quando o cliente usa | Só `authorized_offers`; na dúvida, ligação |
| Discutir em público | O leitor é o próximo cliente | Corrigir um fato e parar |
| Parafrasear | Perde a credibilidade | Citação literal |
| Zero tratado como erro | Ruído e desconfiança | Zero com o motivo, sem alerta |
| Lista de palavras de reclamação estreita | Cliente escreve "nunca mais", não "decepcionado" | Classificar pelo texto inteiro, incluir na dúvida |
