## 嵌入式系统导论实验报告

------

|  姓名  |    学号    |  班级  |     电话      |        邮箱        |
| :--: | :------: | :--: | :---------: | :--------------: |
|  陈潇  | 15352048 | 15M1 | 13727022947 | 616131435@qq.com |

------

### 1.实验题目

#####	1.Exercise 2 MOC-stateChart。

#####	

### 2.实验结果

#####1.Advantages of StateCharts：What are the most important extensions of the StateChart model in comparison to an ordinary Finite state machine (FSM)?

相比于状态机的转换，状态图可以表示并行（多个同时执行）的状态，功能更强大。

#####2.Disadvantages of StateCharts：What are the disadvantages of the StateChart formalism?

相比于状态机，状态图不够直观，且状态转换的事件和动作比较复杂。

#####3.Tree of states for StateChart

Given the StateChart in Figure 1. Draw the state space of the StateChart as a tree, which shows the hierarchy of states and
denotes the state types (basic state, sequential states, and parallel states).

状态图的树状表达如下：

![](https://github.com/uio1324/Embedded-system/raw/master/lab4/StateChartTree.png)

#####4.Formal computation of state space

How would you formally compute the set of states? Compute the set of states for the hierarchical automata which is defined by
the StateChart from Fig.1

ZA = ZB X ZC

= (Z1 ∪ Z2) X (ZG ∪ ZD)

=(Z1 ∪ Z2) X (ZG ∪ (ZD1 ∪ ZD2) )

=(Z1, ZG) ∪ (Z1, ZD1) ∪ (Z1, ZD2) ∪(Z2 , ZG) ∪ (Z2, ZD1) ∪ (Z2 , ZD2)



##### 5.Analysis

The automaton defined by the StateChart from Fig. 1 passes through a number of states, when external events are applied.
Show the sequence of state that are passed through, starting from the initial state, for the following sequence of events:
a,b,e,b,d,b. Use a table notation.

| event | state  | action | stage change    |
| ----- | ------ | ------ | --------------- |
| a     | 1,G,D1 | c      | 1->2, G->D1, D1 |
| b     | 2, D1  | b      | 2, D1           |
| e     | 2, D1  |        | 2, D1->D2       |
| b     | 2, D2  |        | 2->1, D2        |
| d     | 1, D2  |        | 1, D2->G        |
| b     | 1, G   |        | 1, G            |



### 3.实验心得

​	本次实验是更加直观和从代码上对进程和通道、连接进行了理解。