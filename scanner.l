
alpha 			[A-Za-z_]
digit 			[0-9]
space 			[ ]

%{
int yylineno; 
#include <stdio.h>
struct symbol
{
char values[100];
char type[15];
};

int k=0, j=0, i=0;
typedef struct symbol s;
s ident[100];
s constant[100];

void insert(int a, char val[], char type[])
{
if(a==0)
{
for(k=0; k<j; k++)
{
if(strcmp(val, constant[k].values)==0)
return;
}
strcpy(constant[j].values, val);
strcpy(constant[j].type, type);
j++;
}
else if(a==1)
{
for(k=0; k<i; k++)
{
if(strcmp(val, ident[k].values)==0)
return;
}
strcpy(ident[i].values, val);
strcpy(ident[i].type, type);
i++;
}
} 
%}

%%	
\n   { yylineno++; }
"/*"					{ multicomment(); }
"//"					{ singlecomment(); }
"#include<"({alpha})*".h>" {}
"#define"({space})""({alpha})""({alpha}|{digit})*""({space})""({digit})+"" 			{ return DEF;}
{digit}+    				{  insert(0,yytext,"Integer"); return CONSTANT; }
({digit}+)\.({digit}+) 			{  insert(0,yytext,"Float"); return CONSTANT; }
{alpha}?\"(\\.|[^\\"])*\"		{  insert(0,yytext,"String Literal"); return STRING_LITERAL; } 
"sizeof"				{  return SIZEOF; }
"->"			{  return PTR_OP; }
"++"			{  return INC_OP; }
"--"			{  return DEC_OP; }
"<<"			{  return LEFT_OP; }
">>"			{  return RIGHT_OP; }
"<="			{  return LE_OP; }
">="			{  return GE_OP; }
"=="			{  return EQ_OP; }
"!="			{  return NE_OP; }
"&&"			{  return AND_OP; }
"||"			{  return OR_OP; }
"*="			{  return MUL_SHORT; }
"/="			{  return DIV_SHORT; }
"%="			{  return MOD_SHORT; }
"+="			{  return ADD_SHORT; }
"-="			{  return SUB_SHORT; }
"<<="			{  return LEFT_SHORT; }
">>="			{  return RIGHT_SHORT; }
"&="			{  return AND_SHORT; }
"^="			{  return XOR_SHORT; }
"|="			{  return OR_SHORT; }
"typedef"		{  return TYPEDEF; }
"extern"		{  return EXTERN; }
"static"		{  return STATIC; }
"auto"			{  return AUTO; }
"register"		{  return REGISTER; }
"char"			{  return CHAR; }
"int"			{  return INT; }
"float"			{  return FLOAT; }
"const"			{  return CONST; }
"volatile"		{  return VOLATILE; }
"void"			{  return VOID; }
"struct"		{  return STRUCT; }
"union"			{  return UNION; }
"enum"			{  return ENUM; }
"case"			{  return CASE; }
"default"		{  return DEFAULT; }
"if"			{  return IF; }
"else"			{  return ELSE; }
"switch"		{  return SWITCH; }
"while"			{  return WHILE; }
"do"			{  return DO; }
"for"			{  return FOR; }
"goto"			{  return GOTO; }
"continue"		{  return CONTINUE; }
"break"			{  return BREAK; }
"return"		{  return RETURN; }
";"			{  return(';'); }
("{"|"<%")		{  return('{'); }
("}"|"%>")		{  return('}'); }
","			{  return(','); }
":"			{  return(':'); }
"="			{  return('='); }
"("			{  return('('); }
")"			{  return(')'); }
("["|"<:")		{  return('['); }
("]"|":>")		{  return(']'); }
"."			{  return('.'); }
"&"			{  return('&'); }
"!"			{  return('!'); }
"~"			{  return('~'); }
"-"			{  return('-'); }
"+"			{  return('+'); }
"*"			{  return('*'); }
"/"			{  return('/'); }
"%"			{  return('%'); }
"<"			{  return('<'); }
">"			{  return('>'); }
"^"			{  return('^'); }
"|"			{  return('|'); }
"?"			{  return('?'); }
"printf"                {insert(1,yytext,"Function");return IDENTIFIER; }
"main"                  {insert(1,yytext,"Function");return IDENTIFIER; }
{alpha}({alpha}|{digit})*    {insert(1,yytext,"Identifier");return IDENTIFIER; }
[ \t\v\n\f]		{  }
.			{ /* ignore any other illegal characters */ }
%%
yywrap()
{
	return(1);
}
multicomment()
{
	char c, c1;
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*' && c1=='/')
	{
		c=0;
	}
	if (c != 0)
		putchar(c1);
}
singlecomment()
{
	char c;
	while(c=input()!='\n');
	if(c=='\n')
		c=0;
	if(c!=0)
		putchar(c);
}
