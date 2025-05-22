#import "resources/report.typ" as report

#show: report.styling.with(
    hasFooter: false
)

#report.index()

#import "@preview/diagraph:0.3.1" as dgraph

= Introdução
#v(10pt)
No âmbito da unidade curricular de Investigação Operacional, foi-nos proposto este trabalho prático, que tem como objetivo a resolução de um problema de empacotamento a uma dimensão com contentores de diferentes capacidades, utilizando o modelo de fluxo de arcos. 

Com este trabalho pretendemos conhecer e perceber o modelo em questão, de modo a que consigamos aplica-lo na resolução do problema proposto.

Neste relatório será apresentado de forma detalhada o modelo utilizado, bem como a sua aplicação no nosso caso concreto, juntamente com uma formulação do problema e respetiva resolução.

#pagebreak()

= Formulação do Problema
== Questão 0 - Dados
De acordo com o enunciado, os dados deste problema são determinados em função do maior número de inscrição entre os elementos do grupo, que corresponde ao *106936*, pelo que as quantidades de contentores e itens de cada comprimento são:
#v(15pt)
#figure(
  table(
  columns: 2,
    [*Comprimento*], [*Q. disponível*],
    [11], [_ilimitada_],
    [10], [7],
    [7], [4],
  ),
  caption: [Quantidades de contentores de cada comprimento disponíveis],
)
<qnt_disp_table>

#figure(
  table(
  columns: 2,
    [*Comprimento*], [*Quantidade*],
    [1], [0],
    [2], [17],
    [3], [10],
    [4], [8],
    [5], [5],
  ),
  caption: [Quantidade de itens de cada comprimento],
)
<qnt_table>
#v(15pt)
E a soma dos comprimentos dos itens a empacotar é dada por:
#v(15pt)
$ 1 × 0 + 2 × 17 + 3 × 10 + 4 × 8 + 5 × 5 = 121 $
#v(15pt)


== Questão 1 - Formulação do problema
O problema consiste no empacotamento, a uma dimensão, de itens de diferentes comprimentos em contentores de diferentes capacidades de forma que cada item seja colocado em exatamente um contentor, que a soma dos comprimentos dos itens dentro cada contentor não ultrapasse a sua capacidade e que não se utilize mais contentores do que os que se encontram disponíveis. 

Pretende-se distribuir:
- 17 itens de comprimento 2
- 10 itens de comprimento 3
- 8 itens de comprimento 4
- 5 itens de comprimento 5

Como consta na @qnt_table, os contentores de comprimento 7, 10 e 11, estão disponíveis nas  quantidades 4, 7 e _ilimitada_, respetivamente (@qnt_disp_table). 

O objetivo é distribuir os itens de forma a *minimizar a soma dos comprimentos dos contentores utilizados*.

=== Modelo de fluxos em arcos
Nas formulações indexadas por posição, as variáveis que correspondem a itens de um determinado tipo são indexadas pela posição que ocupam nos contentores. Isto acontece na formulação de fluxos em arcos. 

Dada uma lista de contentores, os contentores são agrupados em K classes de diferentes capacidades $W_k, k = 1,...,K$, sendo $B_k, k = 1,...,K$, o número de contentores disponíveis de cada classe. Os itens são também agrupados em $m$ classes de diferentes tamanhos de itens $w_i, i = 1,...,m$, sendo $b_i, i = 1,...,m$, o número de itens em cada classe. Após o agrupamento, assumimos que as classes de contentores e as classes de itens são indexadas por ordem decrescente de valores de capacidade e tamanho, respetivamente.

Seja  $W_max = max_k W_k = W_1$.

Considere um gráfico $G = (V, A)$ com um conjunto de vértices $V = {0, 1, ...,W_max}$ e um conjunto de arcos $A = {(d, e): 0 <= d < e <= W_max and e - d <= w_i, 1 <= i <= m}$, o que significa que existe um arco entre dois vértices se existir um item do tamanho correspondente. Considere também arcos adicionais entre $(d, d+1), d = 0,1,...,W_max-1$, correspondente às porções livres do contentor. O número de arcos é $O(m W_max)$.

Existe um empacotamento num único contentor de capacidade $W_k$ se e só se existir um caminho entre os vértices 0 e $W_k$ . O comprimento dos arcos que constituem o caminho define os tamanhos dos artigos a embalar.

Utilizando estas variáveis, existem muitas soluções alternativas com exatamente os mesmos itens em cada contentor. Podemos reduzir tanto a simetria do espaço de soluções como o tamanho do modelo, usando critérios de redução para chegar a um subconjunto de arcos de _A_.

_*Critério 1*_: Sejam $w_i_1$ e $w_i_2$ os tamanhos de dois itens quaisquer tais que $w_i_1 >= w_i_2$. Um arco de tamanho $w_i_2$, designado por $(d,d+w_i_2)$, só pode ter a sua cauda num nó _d_ que é a cabeça de um outro arco de tamanho $w_i_1, (d-w_i_1,d)$, ou, então, do nó 0.

_*Critério 2*_: Todas as variáveis de arco de perda $x_(d,d+1)$ podem ser definidas como zero para $d < w_m$. 

_*Critério 3*_: Sejam $i_1$ e $i_2$ dois tamanhos quaisquer de itens tais que $w_i_1 > w_i_2$ . Dado um qualquer nó $d$ que seja a cabeça de um outro arco de tamanho $w_i_1$ ou $d = 0$, os únicos arcos válidos para o tamanho $w_i_2$ são os que começam nos nós $d + s w_i_2, s = 0,1,...,b_i_2 -1$ e $d + s w_i_2 <= W_max$, em que $b_i_2$ é o número de itens de tamanho $w_i_2$ . 

Seja $A' subset A$ o conjunto de arcos que permanecem após a aplicação dos critérios acima.

#pagebreak()

== Questão 2 - Modelo de Programação Linear
#v(10pt)
$ min: sum_(k=1)^K W_k z_k $ <func_obj>

Suj. a:  
$ - sum_((d,e) in A')x_(d e) + sum_((e,f) in A')x_(e f) = cases(
  sum_(k=1)^K z_k space "se" e=0, 
  -z_k space "para" e=W_k ", k = 1,..., K",
  0 space  "caso contrário",
) $
$ sum_((d,d+w_i) in A') x_(d,d+w_i) >= b_i, space i = 1,...,m $
$ z_k <= B_k, space k = 1,...,K $
$ x_(d e) >= 0 and x_(d e) in ZZ^+_0, space  forall(d,e) in A' $
$ z_k >= 0 and x_(d e) in ZZ^+_0, space k = 1, ..., K $

=== Implementação do modelo no nosso problema
Para os parâmetros do nosso problema consideramos, $K = 3$ e $W_k = {7,10,11}$, como sendo as capacidades dos nossos contentores e consideramos 12 vértices $(0,...,11)$ que estão conectados por arcos como veremos no grafo mais à frente.

*Variáveis de decisão:*
#align(center)[
$z_k ,space  k in {7,10,11} : "número de contentores de tamanho k utilizados"$

$x_(i, j), space i, j in {0,...,11} :  "número de arcos de i para j"$

$z_k and x_(i, j) >= 0 space "e" space z_k and x_(i j) in ZZ^+_0$
]
*Função objetivo:*
#align(center)[$min: sum_(k=1)^K W_k z_k$]

*Restrições:*

As restrições seguintes visam garantir um bom fluxo dos arcos, garantindo uma correta entrada e saída dos mesmos em cada um dos vértices. Advêm da expansão dos somatórios apresentados no modelo em $(3)$.
#v(10pt)

$e_0: x_(0,2) + x_(0,3) + x_(0,4) + x_(0,5) = z_7 + z_10 + z_11$

$e_7: - x_(4,7) - x_(5,7) + x_(7,10) + x_(7,9) = - z_7$

$e_10: x_(5,10) + x_(7,10) + x_(8,10) = z_10$

$e_11: x_(8,11) + x_(9,11) = z_11$

$e_2: - x_(0,2) + x_(2,4) = 0$

$e_3: - x_(0,3) + x_(3,5) + x_(3,6) = 0$

$e_4: - x_(0,4) - x_(2,4) + x_(4,6) + x_(4,7) + x_(4,8) = 0$

$e_5: - x_(0,5) - x_(3,5) + x_(5,10) + x_(5,7) + x_(5,8) + x_(5,9) = 0$

$e_6: - x_(3,6) - x_(4,6) + x_(6,8) + x_(6,9) = 0$

$e_8: - x_(4,8) - x_(5,8) - x_(6,8) + x_(8,10) + x_(8,11) = 0$

$e_9: - x_(5,9) - x_(6,9) - x_(7,9) + x_(9,11) = 0$

#v(10pt)
As restrições seguintes garantem que todos os itens são empacotados (cada arco do tipo $x_(i,j)$ representa um item de comprimento $j-i$). Advêm da expansão do somatório apresentado no modelo em $(4).$
#v(10pt)

$T_2 : x_(0,2) + x_(2,4) + x_(4,6) + x_(6,8) + x_(8,10) + x_(3,5) + x_(5,7) + x_(7,9) + x_(9,11) >=17$

$T_3 : x_(0,3) + x_(3,6) + x_(6,9) + x_(4,7) + x_(7,10) + x_(5,8) + x_(8,11) >= 10$

$T_4 : x_(0,4) + x_(4,8) + x_(5,9) >=  8$

$T_5 : x_(0,5) + x_(5,10) >=  5$

#v(10pt)
As restrições seguintes pretendem garantir que o número de contentores de um determinado comprimento, não ultrapassa o número de contentores disponíveis desse mesmo comprimento. Advêm da expressão apresentada no modelo em $(5).$
#v(10pt)
$z_10 <= 7$

$z_7 <= 4$

#v(10pt)
Para além de todas estas restrições também foi necessário garantir que todas as variáveis utilizadas eram positivas e inteiras, como se pode verificar no modelo em $(6)$ e $(7).$

== Questão 3 - Apresentação do ficheiro de input
#v(5pt)
```py
// Função objetivo
min: 11 z11 + 10 z10 + 7 z7;

// Conservação do fluxo
E0: x0_2 + x0_3 + x0_4 + x0_5 = z7 + z10 + z11;
E7: -1 x4_7 -1 x5_7 + x7_10 + x7_9 = -1 z7;
E10: x5_10 + x7_10 + x8_10 = z10;
E11: x8_11 + x9_11 = z11;
E2: -1 x0_2 + x2_4 = 0;
E3: -1 x0_3 + x3_5 + x3_6 = 0;
E4: -1 x0_4 -1 x2_4 + x4_6 + x4_7 + x4_8 = 0;
E5: -1 x0_5 -1 x3_5 + x5_10 + x5_7 + x5_8 + x5_9 = 0;
E6: -1 x3_6 -1 x4_6 + x6_8 + x6_9 = 0;
E8: -1 x4_8 -1 x5_8 -1 x6_8 + x8_10 + x8_11 = 0;
E9: -1 x5_9 -1 x6_9 -1 x7_9 + x9_11 = 0;

// Satisfação da demanda
T2: x0_2 + x2_4 + x4_6 + x6_8 + x8_10 + x3_5 + x5_7 + x7_9 + x9_11 >= 17;
T3: x0_3 + x3_6 + x6_9 + x4_7 + x7_10 + x5_8 + x8_11 >= 10;
T4: x0_4 + x4_8 + x5_9 >= 8;
T5: x0_5 + x5_10 >= 5;

// Capacidade dos contentores
z10 <= 7;
z7  <= 4;

// Definição de variáveis inteiras
int z11, z10, z7, x0_2, x2_4, x4_6, x6_8, x8_10, x3_5, x5_7, x7_9, x9_11,
    x0_3, x3_6, x6_9, x4_7, x7_10, x5_8, x8_11,
    x0_4, x4_8, x5_9, x0_5, x5_10;
```
 
== Questão 4 - Apresentação do ficheiro de output
#figure(
  image("images/resultado.png", width: 26%),
  caption: [Solução ótima do problema],
)
<resultado>

== Questão 5 - Apresentação da solução

=== Solução ótima
A solução ótima do problema como podemos constar na tabela de resultados (@resultado) é 121.

$ 2 × 7 + 3 × 10 + 7 × 11 = 121 $



=== Grafo 


#figure(
  image("images/grafo.png", width: 100%),
  caption: [Grafo de Fluxo de Arcos],
)


=== Plano de Empacotamento
#figure(
  image("images/contentores2.png", width: 90%),
  caption: [Exemplo de uma distribuição dos itens pelos contentores segundo a nossa solução],
)



== Questão 6 - Validação do modelo
#v(10pt)
Após termos calculado o valor da solução ótima, procedemos à validação do modelo. Começamos por verificar se a solução obtida fazia sentido, e não violava nenhum pressuposto que pudesse ter sido esquecido quando desenvolvemos o código para o _LPSolve_. Verificou-se que:

1. Os itens foram todos empacotados, 17 de comprimento 2, 10 de comprimento 3, 8 de comprimento 4 e 5 de comprimento 5;

2. A capacidade dos contentores não foi ultrapassada;

3. Os contentores utilizados não ultrapassaram as quantidades disponíveis, 2 contentores de comprimento 7 (4 disponíveis), 3 contentores de comprimento 10 (7 disponíveis) e 7 contentores de comprimento 11 (quantidade ilimitada).

Como a nossa solução ótima era igual ao comprimento total dos itens (121), concluímos que não houve nenhuma perda na organização dos itens nos contentores, logo não poderia haver nenhuma solução melhor.

Para reforçar ainda mais que a nossa solução estava correta, recorremos à utilização de outro modelo de empacotamento que nos deu exatamente a mesma solução ótima.

#pagebreak()

= Conclusão
#v(10pt)
Ao longo do desenvolvimento deste trabalho, não apenas conseguimos resolver o problema de forma correta, com também ficamos a compreender melhor um dos  modelo de resolução de problemas de empacotamento a uma dimensão.A construção do grafo de fluxo de arcos do problema foi um dos passos cruciais para um melhor entendimento do modelo sendo um elemento chave para uma correta implementação do código no _LPSolve_ que nos deu a solução ótima.

#pagebreak()
= Bibliografia
#v(10pt)
[1] J. Valério de Carvalho. Exact solution of bin-packing problems using column generation and
branch-and-bound. Annals of Operations Research, 86: 629–659, 1999.

[2] J. Valério de Carvalho. LP models for bin packing and cutting stock problems. European Journal
of Operational Research, 141: 253–273, 2002.

