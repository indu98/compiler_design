%{
int count=0;
%}

alpha [A-Za-z]
digit [0-9]
sign [+-]


%%
[ \t] ;
\n	{yylineno++;}
"{"	{open1(); count++; return '{';}
"}"	{close1(); count--; return '}';}
int	{yylval.ival = INT; return INT;}
float	{yylval.ival = FLOAT; return FLOAT;}
void	{yylval.ival = VOID; return VOID;}
else	{return ELSE;}
do	return DO;
if	return IF;
struct 	return STRUCT;
^"#include ".+	return PREPROC;
while	return WHILE;
return 	return RETURN;
printf	return PRINT;
{alpha}({alpha}|{digit})* {yylval.str=strdup(yytext); return ID;}
{sign}?{digit}+	{yylval.str=strdup(yytext);return NUM;}
{digit}+\.{digit}+ 	{yylval.str=strdup(yytext); return REAL;}
"<="		return LE;
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
\".*\"	return STRING;
.	return yytext[0];
%%
