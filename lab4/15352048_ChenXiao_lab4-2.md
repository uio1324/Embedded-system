## 嵌入式系统导论实验报告

------

|  姓名  |    学号    |  班级  |     电话      |        邮箱        |
| :--: | :------: | :--: | :---------: | :--------------: |
|  陈潇  | 15352048 | 15M1 | 13727022947 | 616131435@qq.com |

------

### 1.实验题目

#####	1.Exercise 1。

#####	

### 2.实验结果

#####1.1.1

Algorithm 1是non-deterministic的，因为在该算法下，他无论是收到X还是Y都会直接输出，因此输出顺序受输入顺序影响，但是他是fair的，因为任何情况下只来一个X或Y都可以输出。

Algorithm 2是deterministic的，该算法需要接收到两个输入，然后根据两个输入的下表决定输出顺序。因此输出顺序不受输入顺序影响，但是他是unfair的，因为如果只来了一个输入的情况下，另一个输入没有来，永远都不会输出。

#####1.1.2.

A：完成加法操作

```
for (;;){
  a:=wait(in1);
  b:=wair(in2);
  send(a+b,out);
}
```

B:完成乘法操作，把上面的加号改为乘号即可

C:复制操作，将输入转为两个输出

```
for (;;){
  a:=wait(in);
  send(a,out1);
  send(a,out2);
}
```

D：连续

```
send(i,out)
for(;;){
  a:=wait(in);
  send(a,out);
}
```

E:

```
for(;;){
  wait(in);
}
```

![](https://github.com/uio1324/Embedded-system/raw/master/lab4/n(n+1).png)





#####1.2.1

topological matrix

![](https://github.com/uio1324/Embedded-system/raw/master/lab4/matrix.png)

#####1.2.2.

![](https://github.com/uio1324/Embedded-system/raw/master/lab4/matrx2.png)







n<rank，因此是consistent的（从第三行开始往下可以化简消除掉最后一行）。

Fire number: 

Ouelle: 77    DCT: 77     Q:77     RLC :77       C: 1       R: 1






