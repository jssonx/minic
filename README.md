# MiniC
First TinyC, then MiniC

## Progress
 - ch1-5: `done`
 - ch6
 - ch7
 - ch8
 - ch9
 - ch10
 - ch11
 - ch12
 - ch13
 - ch14
 - ch15
 - ch16

## 环境配置
Platform: Ubuntu 22.04

如果您的系统中没有 gcc ，则应先安装 gcc 。如果你使用的是 debian ，可以用 apt-get 命令来安装，如下：
```shell
$ sudo apt-get install build-essential
```
## ch2 TinyC Specification
TinyC 是 C 语言中非常小的子集，所有 C 语法的规则均适用于 TinyC 语法， TinyC 源程序可直接用 gcc 编译
```shell
$ gcc -o tinyc tinyc.c
$ ./tinyc
```
## ch4
```shell
$ python3 pysim.py pcode_1.asm
$ python3 pysim.py pcode_1.asm -d
```

## ch5

```shell
$ python pysim.py factor.asm -a
$ python pysim.py factor.asm -da
```