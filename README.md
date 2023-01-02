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

## ch8 用 flex 做词法分析
flex的作用是根据用户使用regex定义的分词匹配模式自动化构造一个lexer/scanner。C/C++使用flex，Java使用jflex。

### flex简介

#### flex的安装
```shell
$ sudo apt-get install flex
```
#### flex的测试
hide-digits.l：该文件的作用是不停从标准输入（键盘）中读入字符，将其中的数字串替换成 ? 后再输出到标准输出（终端），当遇到 # 后程序退出
```flex
%%
[0-9]+  printf("?");
#       return 0;
.       ECHO;
%%

int main(int argc, char* argv[]) {
    yylex();
    return 0;
}

int yywrap() { 
    return 1;
}
```
测试指令：用flex 会将这些正则表达式翻译成 C 代码格式的函数 yylex ，并输出到 lex.yy.c 文件中，该函数可以看成一个有限状态自动机
```shell
$ flex hide-digits.l
```
此时目录下多了一个 “lex.yy.c” 文件，把这个 C 文件编译并运行一遍。
```shell
$ gcc -o hide-digits lex.yy.c
$ ./hide-digits
```
然后在终端不停的敲入任意键并回车，可以发现，敲入的内容中，除数字外的字符都被原样的输出了，而每串数字字符都被替换成 ? 了。最后敲入 # 后程序退出了。如下：
```
eruiewdkfj
eruiewdkfj
1245
?
fdsaf4578
fdsaf?
...
#
```
##### 代码解释：hide-digits.l
hide-digits.l
```
%%
[0-9]+  printf("?");
#       return 0;
.       ECHO;
%%
```
flex 模式文件中，%% 和 %% 之间的内容被称为 规则（rules），本文件中每一行都是一条规则，每条规则由 匹配模式（pattern） 和 事件（action） 组成， 模式在前面，用正则表达式表示，事件在后面，即 C 代码。每当一个模式被匹配到时，后面的 C 代码被执行。

简单来说，flex 会将本段内容翻译成一个名为 yylex 的函数，该函数的作用就是扫描输入文件（默认情况下为标准输入），当扫描到一个完整的、最长的、可以和某条规则的正则表达式所匹配的字符串时，该函数会执行此规则后面的 C 代码。如果这些 C 代码中没有 return 语句，则执行完这些 C 代码后， yylex 函数会继续运行，开始下一轮的扫描和匹配。

当有多条规则的模式被匹配到时， yylex 会选择匹配长度最长的那条规则，如果有匹配长度相等的规则，则选择排在最前面的规则。

```
int main(int argc, char *argv[]) {
    yylex();
    return 0;
}

int yywrap() { return 1; }
```
第二段中的 main 函数是程序的入口， flex 会将这些代码原样的复制到 lex.yy.c 文件的最后面。最后一行的 yywrap 函数的作用后面再讲，总之就是 flex 要求有这么一个函数。

总结：因此，程序开始运行后，就开始执行 yylex 函数，然后开始扫描标准输入。当扫描出一串数字时，[0-9]+ 被匹配到，因此执行了 printf(”?”) ，当扫描到其他字符时，若不是 # ，则 . 被匹配，后面的 ECHO 被执行， ECHO 是 flex 提供的一个宏（#define），作用是将匹配到的字符串原样输出，当扫描到 # 后， # 被匹配， return 0 被执行， yylex 函数返回到 main 函数，之后程序结束。

##### 更复杂的代码解释：word-spliter.l
word-spliter.l：该程序是一个原始的分词器，它将输入文件分割成一个个的 WORD 再输出到终端，同时统计输入文件中的字符数、单词数和行数。此处的 WORD 指一串连续的非空格字符。
```
%{
#define T_WORD 1
int numChars = 0, numWords = 0, numLines = 0;
%}

WORD		([^ \t\n\r\a]+)

%%
\n			{ numLines++; numChars++; }
{WORD}		{ numWords++; numChars += yyleng; return T_WORD; }
<<EOF>>		{ return 0; }
.			{ numChars++; }
%%

int main() {
	int token_type;
	while (token_type = yylex()) {
		printf("WORD:\t%s\n", yytext);
	}
	printf("\nChars\tWords\tLines\n");
	printf("%d\t%d\t%d\n", numChars, numWords, numLines);
	return 0;
}

int yywrap() {
	return 1;
}
```
测试代码
```shell
$ flex word-spliter.l
$ gcc -o word-spliter lex.yy.c
$ ./word-spliter < word-spliter.l
```
输出结果
```
WORD:       %{
WORD:       #define
...
WORD:       }

Chars       Words   Lines
470 70      27
```
#### flex输入文件的格式详解
一个完整的flex输入文件的格式为：
```
%{
Declarations
%}
Definitions
%%
Rules
%%
User subroutines
```
