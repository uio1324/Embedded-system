## 嵌入式系统导论实验报告

------

|  姓名  |    学号    |  班级  |     电话      |        邮箱        |
| :--: | :------: | :--: | :---------: | :--------------: |
|  陈潇  | 15352048 | 15M1 | 13727022947 | 616131435@qq.com |

------

### 1.实验题目

#####	1.修改程序改变按键对应的驱动灯颜色并对比，做调试分析。

#####	2.修改NOT gate项目并作分析。

### 2.实验结果

​	1.

​	程序代码部分：

``` c
void PortF_Init(void){ volatile uint32_t delay;
  SYSCTL_RCGCGPIO_R |= 0x00000020;  // 1) activate clock for Port F
  delay = SYSCTL_RCGCGPIO_R;        // allow time for clock to start
  GPIO_PORTF_LOCK_R = 0x4C4F434B;   // 2) unlock GPIO Port F
  GPIO_PORTF_CR_R = 0x1F;           // allow changes to PF4-0
  // only PF0 needs to be unlocked, other bits can't be locked
  GPIO_PORTF_AMSEL_R = 0x00;        // 3) disable analog on PF
  GPIO_PORTF_PCTL_R = 0x00000000;   // 4) PCTL GPIO on PF4-0
  GPIO_PORTF_DIR_R = 0x0E;          // 5) PF4,PF0 in, PF3-1 out
  GPIO_PORTF_AFSEL_R = 0x00;        // 6) disable alt funct on PF7-0
  GPIO_PORTF_PUR_R = 0x11;          // enable pull-up on PF0 and PF4
  GPIO_PORTF_DEN_R = 0x1F;          // 7) enable digital I/O on PF4-0
}

int main(void){ uint32_t status;
  PortF_Init();              // initialize PF0 and PF4 and make them inputs
                             // make PF3-1 out (PF3-1 built-in LEDs)
  while(1){
    status = PortF_Input();
    switch(status){                    // switches are negative logic on PF0 and PF4
      case 0x01: PortF_Output(YELLOW); break;   // SW1 pressed
      case 0x10: PortF_Output(SKY_BLUE); break;    // SW2 pressed
      case 0x00: PortF_Output(PINK); break;  // both switches pressed
      case 0x11: PortF_Output(0); break;      // neither switch pressed
    }
  }
}
```

​	可以在注释代码中看到驱动灯所对应的颜色是以16进制存储。在main函数中首先进行端口F的初始化（代码第一段），关键部分是GPIO_PORTF_DIR_R（=0x0E=01110）即设定1-3为输出灯，0和4位两个管脚是输入信号。GPIO_PORTF_PUR_R（=0x11=10001）即设定两个输出管脚上拉电阻。在while反复循环中反复读取PF4和PF0的状态，根据这二者的电平状态决定GPIO_PORTF_DATA_R的输出状态，因为只有第1-3位是输出位，因此该输出只会对1-3位产生影响。











​	对于example1，修改其square.c文件，



```c
int square_fire(DOLProcess *p) {
    float i;

    if (p->local->index < p->local->len) {
        DOL_read((void*)PORT_IN, &i, sizeof(float), p);
        i = i*i*i;
        DOL_write((void*)PORT_OUT, &i, sizeof(float), p);
        p->local->index++;
    }

    if (p->local->index >= p->local->len) {
        DOL_detach(p);
        return -1;
    }

    return 0;
}
```

​	可以看到该函数是开火，执行二次方的操作，在DOL_read和DOL_write 之间进行数据的计算，所以在这个地方把读入的i改为乘三次即可实现。



       	1. 实验截图：



![](https://github.com/uio1324/Embedded-system/raw/master/example2.png)





![](https://github.com/uio1324/Embedded-system/raw/master/example1-run.png)

![](https://github.com/uio1324/Embedded-system/raw/master/example1.png)





​	2.执行sudo ant -f runexample.xml -Dnumber=1的指令后，操作系统到底干了什么？。

​	首先，runexample执行了运行操作，把编译成功之后的文件开始执行，也就是执行example1。所以要去xml看一下代码的整体流程。

```xml
  <process name="generator"> 
    <port type="output" name="1"/>
    <source type="c" location="generator.c"/>
  </process>

  <process name="consumer"> 
    <port type="input" name="1"/> 
    <source type="c" location="consumer.c"/>
  </process>

  <process name="square"> 
    <port type="input" name="1"/>
    <port type="output" name="2"/>
    <source type="c" location="square.c"/>
  </process>
```

​	以上三个process是声明进程的代码。三个代码块声明了四个进程分别为generator\consumer\square1\square2，并且定义了他们的几口类型和接口名称。

```xml
  <sw_channel type="fifo" size="10" name="C1">
    <port type="input" name="0"/>
    <port type="output" name="1"/>
  </sw_channel>

  <sw_channel type="fifo" size="10" name="C2">
    <port type="input" name="0"/>
    <port type="output" name="1"/>
  </sw_channel>
```

​	接着是声明了两个通道，id分别为C1\C2，类型为FIFO，指明数据流经过通道时采用的是先进先出的处理方式。

```xml
  <connection name="g-c">
    <origin name="generator">
      <port name="1"/>
    </origin>
    <target name="C1">
      <port name="0"/>
    </target>
  </connection>

  <connection name="c-c">
    <origin name="C2">
      <port name="1"/>
    </origin>
    <target name="consumer">
      <port name="1"/>
    </target>
  </connection>

  <connection name="s-c">
    <origin name="square">
      <port name="2"/>
    </origin>
    <target name="C2">
      <port name="0"/>
    </target>
  </connection>

  <connection name="c-s">
    <origin name="C1">
      <port name="1"/>
    </origin>
    <target name="square">
      <port name="1"/>
    </target>
  </connection>
```

​	最后是四个连接，分别对应了四个进程和和三个通道的连接方式，所以一共有四个，注意对于每一个进程来说都需要声明他们的连接。origin是接入口，target是输出口。

​	因此，编译后开始执行时，以上的xml文件就定义了其规定的接口输入输出模型。

```c
int generator_fire(DOLProcess *p) {

    if (p->local->index < p->local->len) {
        float x = (float)p->local->index;
        DOL_write((void*)PORT_OUT, &(x), sizeof(float), p);
        p->local->index++;
    }

    if (p->local->index >= p->local->len) {
        DOL_detach(p);
        return -1;
    }

    return 0;
}
```

​	再看一下对应的发生器文件，fire函数时一直在执行的，在init初始化执行之后，根据index的长度（LENGTH）判断是否需要执行DOL_write函数，当超过规定长度时，就结束并返回。同理，consumer是执行DOL_read函数，并输出到命令窗口中就停止。



### 3.实验心得

​	本次实验是更加直观和从代码上对进程和通道、连接进行了理解。