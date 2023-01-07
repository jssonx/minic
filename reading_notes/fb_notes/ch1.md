# ch1

https://web.iitd.ac.in/~sumeet/flex__bison.pdf

## 我们的第一个Flex程序
```flex
%{
int chars = 0;
int words = 0;
int lines = 0;
%}

%%

[a-zA-Z]+	{ words++; chars += strlen(yytext); }
\n		{ chars++; lines++; }
.		{ chars++; }

%%

main()
{
  yylex();
  printf("%8d%8d%8d\n", lines, words, chars);
}
```

```shell
$ flex fb1-1.l
$ cc lex.yy.c -lfl
$ ./a.out
The boy stood on the burning deck
shelling peanuts by the peck
^D
2 12 63
$
```

有两种测试方法。一种是“echo "Hello, world!" | ./a.out”，一种是上述方法。

变量yytext被设为指向本次匹配的输入文本

函数yylex()负责调用flex提供的词法分析程序

## 让Flex与Bison协同工作
-lfl是flex库文件
```shell
$ flex fb1-3.l
$ cc lex.yy.c -lfl
$ ./a.out
12+34
NUMBER 12
PLUS
NUMBER 34
NEWLINE
5 6 / 7q
NUMBER 5
NUMBER 6
DIVIDE
NUMBER 7
Mystery character q
NEWLINE
^D
$
```

## 记号（token）编号和记号（token）值

token流中，每个token由两部分组成，分别是token number和token's value。

```shell
$ flex fb1-4.l
$ cc lex.yy.c -lfl
$ ./a.out
```

## 文法和语法分析

Bison uses a single colon rather than ::=, and since line boundaries are not significant, a semicolon marks the end of a rule. Again, like flex, the C action code goes in braces at the end of each rule.

bison会自动帮你分析语法，记住每条被匹配的规则。

## 联合编译Flex和Bison程序

创建一个Makefile文件。首先用-d标志运行bison文件.y。这回创建fb1-5.tab.c和fb1-5.tab.h。接着运行flex来创建lex.yy.c。然后它把两者和flex的库文件编译在一起。

```shell
$ make fb1-5
$ ./fb1-5
```