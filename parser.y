%{
	#include <stdio.h>
	#include <stdlib.h>
        int index1=0;
        int function=0;
	#include "symbol.c"
int i=1;
int j=8;
int stack[100];
int end[100];
int arr[10];
int gl1,gl2,ct=0,c=0,b;
%}

%token<ival> INT FLOAT VOID
%token<str> ID NUM REAL
%token WHILE IF RETURN PREPROC LE STRING PRINT FUNCTION DO ARRAY ELSE STRUCT  
%right '='

%type<str> assignment1 consttype assignment2 
%type<ival> Type 

%union {
		int ival;
		char *str;
	}

%%

start : Function start 
	| PREPROC start 
	| Declaration start
        | Function1 start
	| 
	;

Function1 : Type ID '(' ')' ';' {
            insert($2,FUNCTION,0,nesting());
            insert($2,$1,0,nesting());
            }
            | Type ID '(' Argument ')' ';' {
            insert($2,FUNCTION,0,nesting());
            insert($2,$1,0,nesting());
            } ;

Function : Type ID '('')' CompoundStmt {
	if ($1!=returntype_func(ct))
	{
		printf("\nError : Type mismatch : Line %d\n",printline());
	}

	if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar"))) 
		printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
	else 
	{       
                if(!lookup($2))
                {
		st[location($2)].flag=1;
                }
                else
                {
		insert($2,FUNCTION,1,nesting()); 
		insert($2,$1,1,nesting()); 
                }
	}
	}
        | Type ID '(' Argument ')' CompoundStmt {
	if ($1!=returntype_func(ct))
	{
		printf("\nError : Type mismatch : Line %d\n",printline());
	}

	if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar"))) 
		printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
	else 
	{  
                if(!lookup($2))
                {
                function++;
		st[location($2)].flag=1;
                }
                else
                {
                insert_func_name(function,$2);
                function++;
		insert($2,FUNCTION,1,nesting()); 
		insert($2,$1,1,nesting()); 
                }
                
	}
	}
	;

Argument : Type ID ',' Argument {insert_func_param(function,$1);int scope=stack[index1-1]+1;  
			insert($2,$1,0,nesting()+1); 
			insertscope($2,scope);}
           | Type ID {insert_func_param(function,$1);int scope=stack[index1-1]+1;  
			insert($2,$1,0,nesting()+1); 
			insertscope($2,scope);};

Type : INT
	| FLOAT
	| VOID
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt
	| CompoundStmt
	|
	;

stmt : Declaration
	| if
	| while
	| dowhile
	| RETURN consttype ';' {
					if(!(strspn($2,"0123456789")==strlen($2))) 
						storereturn(ct,FLOAT); 
					else 
						storereturn(ct,INT); ct++;
				} 
	| RETURN ';' {storereturn(ct,VOID); ct++;}
	| ';'
	| PRINT '(' STRING ')' ';' 
	| CompoundStmt
	;

dowhile : DO CompoundStmt WHILE '(' expr1 ')' ';'
	;

if : IF '(' expr1 ')' CompoundStmt
	| IF '(' expr1 ')' CompoundStmt ELSE CompoundStmt
	;

while : WHILE '(' expr1 ')' CompoundStmt
	;

expr1 : expr1 LE expr1
	| assignment1
	;

assignment1 : ID '=' assignment1 
	{
		int sct=returnscope($1,stack[index1-1]); 
		int type=returntype($1,sct); 
		if((!(strspn($3,"0123456789")==strlen($3))) && type==258) 
			printf("\nError : Type Mismatch : Line %d\n",printline()); 
		if(!lookup($1)) 
		{ 
			int currscope=stack[index1-1]; 
			int scope=returnscope($1,currscope); 
			if((scope<=currscope && end[scope]==0) && !(scope==0)) 
				check_scope_update($1,$3,currscope);
		} 
		}

	| ID ',' assignment1    {
					if(lookup($1)) 
						printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
				}
	| assignment2
	| consttype ',' assignment1   
	| ID  {
		if(lookup($1)) 
			printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
		}
	| consttype
	;

assignment2 : ID '=' exp {c=0;}
		| ID '=' '(' exp ')'
		;

exp : ID {
	if(c==0) 
	{
		c=1;
		int sct=returnscope($1,stack[index1-1]); 
		b=returntype($1,sct);
	} 
	else 
	{ 
		int sct1=returnscope($1,stack[index1-1]); 
		if(b!=returntype($1,sct1)) 
			printf("\nError : Type Mismatch : Line %d\n",printline());
	} 
	}
	| exp '+' exp   
	| exp '-' exp  
	| exp '*' exp   
	| exp '/' exp    
	| '(' exp '+' exp ')' 
	| '(' exp '-' exp ')'  
	| '(' exp '*' exp ')'  
	| '(' exp '/' exp ')'  
	| consttype 
	;

consttype : NUM
	| REAL
	;

Declaration : Type ID ';'
              {  if(!lookup($2)) 
		{
			int currscope=stack[index1-1]; 
			int previous_scope=returnscope($2,currscope); 
			if(currscope==previous_scope) 
				printf("\nError : Redeclaration of %s : Line %d\n",$2,printline()); 
			else 
			{
				insert_dup($2,$1,currscope,nesting()); 
			}
		} 
		else 
		{ 
			int scope=stack[index1-1];  
			insert($2,$1,0,nesting()); 
			insertscope($2,scope); 
		}
              }
        | Type ID '=' consttype ';' 
	{
		if( (!(strspn($4,"0123456789")==strlen($4))) && $1==258) 
			printf("\nError : Type Mismatch : Line %d\n",printline()); 
		if(!lookup($2)) 
		{
			int currscope=stack[index1-1]; 
			int previous_scope=returnscope($2,currscope); 
			if(currscope==previous_scope) 
				printf("\nError : Redeclaration of %s : Line %d\n",$2,printline()); 
			else 
			{
				insert_dup($2,$1,currscope,nesting());
				check_scope_update($2,$4,stack[index1-1]); 
			}
		} 
		else 
		{ 
			int scope=stack[index1-1];  
			insert($2,$1,0,nesting()); 
			insertscope($2,scope); 
			check_scope_update($2,$4,stack[index1-1]); 
		}
	}
	| assignment1 ';'  {
				if(!lookup($1)) 
				{ 
					int currscope=stack[index1-1]; 
					int scope=returnscope($1,currscope); 
					if(!(scope<=currscope && end[scope]==0) || scope==0) 
						printf("\nError : Variable %s out of scope : Line %d\n",$1,printline());
				} 
				else 
					printf("\nError : Undeclared Variable %s : Line %d\n",$1,printline()); 
				}

	| Type ID '[' NUM ']' ';' {
						insert($2,ARRAY,0,nesting());
                                                int scope=stack[index1-1]; 
                                                insertscope($2,scope); 
						insert($2,$1,0,nesting()); 
                                                if((int)(atof($4))<1)
                                                {
                                                printf("\nError : Array of size less than 1 : Line %d\n",printline());
                                                } 
                                                else
                                                storevalue($2,$4,stack[index1-1]);
			 	       }

	| STRUCT ID '{' Declaration '}' ';' {
						insert($2,STRUCT,0,nesting()); 
					    }
	| error
	;



%%

#include "lex.yy.c"
#include<ctype.h>
int main(int argc, char *argv[])
{
	yyin =fopen(argv[1],"r");
	if(!yyparse())
	{
		printf("Parsing done\n");
		print();
	}
	else
	{
		printf("Error\n");
	}
	fclose(yyin);
	return 0;
}

yyerror(char *s)
{
	printf("\nLine %d : %s %s\n",yylineno,s,yytext);
}

int nesting()
{
return count;
}

int printline()
{
	return yylineno;
}
void open1()
{
	stack[index1]=i;
	i++;
	index1++;
	return;
}
void close1()
{
	index1--;
	end[stack[index1]]=1;
	stack[index1]=0;
	return;
}
