# MiniC
First TinyC, then MiniC

## Progress
- [x] ch1-7
- [ ] ch8-16

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
$ python3 pysim.py factor.asm -a
$ python3 pysim.py factor.asm -da
```

## ch7
```shell
$ python3 scan.py
```

## ch8
```shell
$ sudo apt-get install flex
```
 - hide-digits：不停从标准输入（键盘）中读入字符，将其中的数字串替换成 ? 后再输出到标准输出（终端），当遇到 # 后程序退出
 - flex：当在命令行中运行 flex 时，第二个命令行参数（此处是 hide-digits.l ）是提供给 flex 的分词模式文件， 此模式文件中主要是用户用正则表达式写的分词匹配模式，用flex 会将这些正则表达式翻译成 C 代码格式的函数 yylex ，并输出到 lex.yy.c 文件中，该函数可以看成一个有限状态自动机。
```shell
$ flex hide-digits.l
$ gcc -o hide-digits lex.yy.c
$ ./hide-digits
```
```shell
$ flex word-spliter.l
$ gcc -o word-spliter lex.yy.c
$ ./word-spliter < word-spliter.l
```