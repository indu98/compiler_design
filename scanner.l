%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct symbol
{
char values[100];
int line_number;
char type[15];
};

int k=0, j=0, i=0;
typedef struct symbol s;
s ident[100];
s constant[100];
int line=1, comment=0, quote_error=0;

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
constant[j].line_number=line;
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

digit [0-9]
alpha [a-zA-Z]
alphanum [0-9a-zA-Z]
keyword auto|break|case|char|const|continue|default|do|else|double|enum|extern|float|for|goto|if|long|int|printf|scanf|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while
identi ({alpha}|_)({alpha}|{digit}|_)*
white [ \t]+
sign [\+\-]?
invalid_identifier {digit}+{alpha}({alpha}|{digit})*
%%

\n {line++;}

"//".* {
printf("Single line comment\n");
}

\/\* {
comment++;
printf("Multiline comment starts\n");
}

\*\/ {
if(comment>0)
{
comment--;
printf("Closing of multiline comment\n");
}
else
printf("Multiline comment doesn't have a start, Error occured at line %d\n",line);
}

#include<.*> { 
if(comment<=0) 
printf("Preprocessor directive:\t\t\t\t%s\n", yytext); 
}

{keyword} {
if(comment<=0)
{
insert(1, yytext, "keyword");
printf("Keyword:\t\t\t\t%s\n", yytext);
}
}

{white} {;}

"\\t"|"\\n"|"\\b"|"\\a" { 
if(comment<=0)
printf("Escape character:\t\t\t\t%s\n", yytext);
}

{identi} {
if(comment<=0)
{
insert(1, yytext, "identifier");
printf("Identifier:\t\t\t\t%s\n", yytext);
}
}

"*"|"+"|"-"|"++"|"--"|"!"|"~"|"<<"|">>"|"<="|"<"|">"|"=="|"!="|"&"|"^"|"|"|"&&"|"\||"|"*="|"+="|"-="|"="|"&="|"^="|","|">>="|"<<="|"="|"%"|"=" {
if(comment<=0) 
printf("Operator is found:\t\t\t\t%s\n", yytext);
}

"."|"'""|"\"|"#"|"("|")"|"["|"]"|"$"|";"|":"|"{"|"}" {
if(comment<=0)
printf("Special character:\t\t\t\t%s\n", yytext);
} 

{sign}?{digit}*\.{digit}+ { 
if(comment<=0)
{
insert(0, yytext, "float");
printf("Floating point constant:\t\t\t\t%s\n", yytext);
}
}

{sign}?{digit}+ {
if(comment<=0)
{
insert(0, yytext, "integer");
printf("Integer constant:\t\t\t\t%s\n", yytext);
}
}


\"(\\.|[^"\\])*\" {
if(comment<=0)
printf("String literal:\t\t\t\t%s\n", yytext);
}

{identi}\(({alphanum}|{white})*\) {
if(comment<=0)
printf("Function:\t\t\t\t%s\n", yytext);
}

\" {
if(comment<=0)
{
if(quote_error==0)
quote_error=1;
else
quote_error=0;
}
}

{invalid_identifier} {
if(comment<=0)
printf("Invalid identifier name %s at line number %d\n", yytext, line);
}


%%
int main()
{
FILE *file;
file=fopen("abc.txt", "r");
yyin=file;
yylex();
if(comment!=0)
printf("Nested comment error found\n");
if(quote_error==1)
printf("String literal is not ending until EOF\n");
printf("\n___________CONSTANTS TABLE____________\n");
printf("\nName\t\t\tType\t\t\tLine\n");
for(k=0; k<j; k++)
printf("%s\t\t\t%s\t\t\t%d\n", constant[k].values, constant[k].type, constant[k].line_number);
printf("\n");
printf("\n___________SYMBOLS TABLE_____________\n");
printf("\nName\t\t\tType\n");
for(k=0; k<i; k++)
printf("%s\t\t\t%s\n", ident[k].values, ident[k].type);
printf("\n");
}
int yywrap()
{
return(1);
}
