# Sazonalidade e armadilhas

## Quando ajustar pela temporada

- **Com 400 dias ou mais de histórico no app** (um ano mais sobra para comparar as mesmas semanas): o app calcula o fator.
- **Com menos**: o app não calcula. Pergunta ao dono e usa o número dele com a etiqueta "estimativa sua". Um fator tirado de nove meses parece número de verdade e compra estoque de verdade.

Cálculo com histórico:
```
fator = vendido(mesma janela do ano passado) ÷ vendido(28 dias antes dessa janela, no ano passado)
```
Aplicar o fator na `v_compra` e, dentro da temporada, na `v_ruptura`. Fator acima de 3 ou abaixo de 0,3 não é aplicado sozinho: aparece para o dono ("No ano passado junho vendeu 4,2 vezes mais. Foi temporada ou uma promoção?"). Item com pouco histórico usa o fator da categoria (`category`), que é menos ruidoso. Se o item ficou sem estoque na janela do ano passado, o fator subestima: a tela diz isso e não aplica.

Pergunta ao dono sem histórico (tela Temporadas e aviso em Repor agora quando o dono respondeu na conversa inicial que tem época forte):
> "Tenho 120 dias de vendas, então ainda não vejo sua temporada. Em que meses vende mais, e mais ou menos quanto a mais? Se preferir, sigo no ritmo atual e ajustamos no caminho."

Cada linha ajustada mostra os dois números:
```
Compressor 3 TR                  CMP-3T
  Velocidade   0,4/dia (28 dias)
  Temporada    1,9 vez (junho vendeu 1,9 vez a primavera no ano passado)
  Compra no    ritmo de 0,76/dia
  Saldo        11 un, 14 dias no ritmo da temporada
  Situação     PEDIR AGORA
```
Com número do dono: "Calculado com 1,8 vez o ritmo atual, estimativa sua, não do histórico." Essa etiqueta deixa o dono recalibrar depois.

## Fim da temporada limita a compra

Com `ends_on` preenchido:
```
dias_restantes = ends_on − data prevista de chegada
alvo_sem_limite = (60 + prazo) × v_compra
alvo_com_limite = dias_restantes × v_compra
```
Mostre os dois e diga qual está sendo pedido:
> "A temporada acaba no fim de agosto, 47 dias depois de o pedido chegar. No ritmo de 7/dia com 20 no estoque, são 309 un, 8 caixas: R$ 1.184,00. Sem o limite seriam 11 caixas, R$ 1.628,00; as 3 a mais ficariam paradas até maio."

O dono pode passar por cima (item que não estraga e só sobe de preço vale carregar). Se a temporada acaba antes de o pedido chegar, não pedir: o item vai para Em observação com a data de decisão da próxima temporada.

## Em observação (item de temporada parado)

Item com velocidade zero dentro de temporada que o dono informou não vai para Parados. Fica com: nome, início da temporada, e `decide_by = starts_on − prazo` gravado na temporada. A automação `relative` em `decide_by` avisa o dono. Duas regras: a temporada é sempre informada pelo dono, nunca deduzida de um mês fraco ou do nome do item; e toda observação tem data. Chegou a data sem venda nenhuma: perguntar, não dimensionar compra de uma temporada que ainda não começou.

## Eventos conhecidos (registrar como ajuste pontual, com a etiqueta "informado por você")

Uma obra, contrato ou evento grande que vai puxar estoque; promoção planejada; aumento de preço anunciado pelo fornecedor (às vezes vale comprar antes); férias coletivas do fornecedor (o prazo costuma dobrar perto delas). Tela Temporadas tem "Evento pontual" com item, datas e quantidade extra.

## Armadilhas (o app se protege de cada uma)

| Armadilha | Errado | Certo no app |
|---|---|---|
| Falta contada como falta de procura | "12 vendidos em 28 dias = 0,43/dia, item lento" com a prateleira vazia 20 dias | "12 em 8 dias com estoque = 1,5/dia. Ficou sem estoque 20 dos últimos 28 dias; é procura reprimida" |
| Comprar no pico de uma semana | 7 dias a 5,8/dia contra 28 dias a 0,4; compra 60 dias a 5,8 | "O ritmo da semana é 14 vezes o de 28 dias por uma venda de 40 un no dia 9. Foi um serviço, não tendência. Compro no ritmo de 28 dias" e oferece "Marcar como atacado pontual" |
| Repor item parado por um ponto de pedido antigo | "Ponto de pedido 24, saldo 6, comprar 18" | "Nenhuma venda em 28 dias. Não é compra. 6 un, R$ 340,00 parados, vale liquidar" |
| Esquecer o que está a caminho | "Saldo 38, alvo 258, comprar 240" | "Saldo 38 e 160 a caminho do pedido PC-0031; faltam 60, 2 caixas de 40 = 80 un. Se o que está a caminho estiver errado, me avise" |
| Contagem sem data | Usar a contagem como se fosse de hoje | Mostrar "contado em dd/mm" e pedir recontagem dos que mais saem quando passou de 14 dias |
| Temporada inventada com pouco histórico | "Fator de junho 1,6 (calculado)" com 120 dias sem nenhum junho | "Sem junho no histórico. Quanto a mais vende em junho?" |
| Velocidade pelo produto e não pela variação | "Filtro 20x25: 4,1/dia, saudável" | Por variação: "A de 1 polegada acaba em 4 dias; a de 4 polegadas tem 9 meses de estoque" |
| Unidades sem reais | Lista de quantidades | Cada linha com custo, subtotal por fornecedor e total antes da pergunta |
| Aceitar troca de peça do fornecedor calado | Pedido atualizado sem avisar | Substituição registrada com os dois códigos e o efeito na cobertura se recusar; o dono decide |
| Kit que consome componentes | Vender o kit sem baixar as partes | Se há kits, perguntar ao dono na conversa inicial como são controlados antes de confiar nos números; baixar as partes pelo kit é pedido à parte, registrado em "o que NÃO vamos construir" |
