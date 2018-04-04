%{
	#include <stdio.h>
	#include <stdlib.h>
        int function=0;
	#include "symbol.c"

int i=1,label1[20];
int stack[100],index1=0,end[100],arr[10],dom,roo,top=0,label[20],name=0,ltop=0;
char st1[100][10];
char ig[2]="0";
char temp[2]="t";
void yyerror(char *s);
int printline();


void for3()
{
	printf("goto L%d\n",label[ltop-3]);
	printf("L%d:\n",label[ltop-1]);
}

void flow_1()			
{
	name++;
	strcpy(temp,"t");
	strcat(temp,ig);
	printf("%s = not %s\n",temp,st1[top]);
 	printf("if %s goto L%d\n",temp,name);
	ig[0]++;
	label[++ltop]=name;	
	
}

void flow_2()
{
	name++;
	printf("goto L%d\n",name);
	printf("L%d: \n",label[ltop--]);
	label[++ltop]=name;
}

void flow_3()
{
	printf("L%d:\n",label[ltop--]);
}

void while1()				
{
	name++;
	label[++ltop]=name;
	printf("L%d:\n",name);
}

void while2()
{
	name++;
	strcpy(temp,"t");
	strcat(temp,ig);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,name);
	ig[0]++;
	label[++ltop]=name;
}

void while3()
{
	int y=label[ltop--];
	printf("goto L%d\n",label[ltop--]);
	printf("L%d:\n",y);
}

void dowhile1()
{
	name++;
	label[++ltop]=name;
	printf("L%d:\n",name);
}

void dowhile2()
{
 	printf("if %s goto L%d\n",st1[top--],label[ltop--]);
}

void close1()
{
	index1--;
	end[stack[index1]]=1;
	stack[index1]=0;
	return;
}

void for1()
{
	name++;
	label[++ltop]=name;
	printf("L%d:\n",name);
}

void for2()
{
	name++;
	strcpy(temp,"t");
	strcat(temp,ig);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,name);
	ig[0]++;
	label[++ltop]=name;
	name++;
	printf("goto L%d\n",name);
	label[++ltop]=name;
	name++;
	printf("L%d:\n",name);	
	label[++ltop]=name;
}

void for4()
{
	printf("goto L%d\n",label[ltop]);
	printf("L%d:\n",label[ltop-2]);
	ltop-=4;
}

void push(char *a)
{
	strcpy(st1[++top],a);
}

void icg()
{
	strcpy(temp,"t");
	strcat(temp,ig);
	printf("%s = %s %s %s\n",temp,st1[top-2],st1[top-1],st1[top]);
	top-=2;
	strcpy(st1[top],temp);
	ig[0]++;
}

void open1()
{
	stack[index1]=i;
	i++;
	index1++;
	return;
}

void icg_1()
{
	printf("%s = %s\n",st1[top-2],st1[top]);
	top-=2;
}

%}

%token<ival> INT FLOAT VOID
%token<str> ID NUM REAL LE GE EQ NEQ AND OR
%token WHILE IF RETURN PREPROC STRING PRINT FUNCTION DO ARRAY ELSE FOR
%left LE GE EQ NEQ AND OR '<' '>'
%right '=' 
%left '+' '-'
%left '*' '/' 
%type<str> assignment1 val '=' '+' '-' '*' '/' E T F 
%type<ival> Type
%union {
		int ival;
		char *str;
	}
%%

start : Function start 
	| PREPROC start 
	| Declaration start
	| 
	;

function_call : ID '(' ')' ';' {
	int k=lookup_func($1);
	if(k==-1) 
		printf(" \nUndefined function : Line %d\n",printline());
	else
	{
		if(number_param(k)!=0)
      	 		printf("\nNumber of parameters is invalid : Line %d\n",printline());
		else
		{
			printf("goto F%d\n",k);
			printf("M%d:\n",k);
		}
	}
	}
	| ID '(' constant_list ')' ';' {
	int k=lookup_func($1);
	if(k==-1) 
		printf(" \nUndefined function : Line %d\n",printline());
	else
	{
		if(number_param(k)!=2)
			printf("\nNumber of parameters is invalid : Line %d\n",printline());
		else
		{
			printf("goto F%d\n",k);
			printf("M%d:\n",k);
		}
	}
	} 
	| ID '(' constant_list2 ')' ';' {
	int k=lookup_func($1);
	if(k==-1) 
		printf(" \nUndefined function : Line %d\n",printline());
	else
	{
		if(number_param(k)!=3)
			printf("\nNumber of parameters is invalid : Line %d\n",printline());
		else
		{	
			printf("goto F%d\n",k);
			printf("M%d:\n",k);
		}
	}
	}
	| ID '(' argument ')' ';' {
	int k=lookup_func($1);
	if(k==-1) 
		printf(" \nUndefined function : Line %d\n",printline());
	else
	{
		if(number_param(k)!=1)
			printf("\nNumber of parameters is invalid : Line %d\n",printline());
		else
		{
			printf("goto F%d\n",k);
			printf("M%d:\n",k);
		}
	} 
}
;

argument: val | ID ;

constant_list: argument ',' argument ;

constant_list2: argument ',' argument ',' argument ;

Function : Type ID '('')' {if(strcmp($2,"main")!=0) {printf("F%d:\n",function);function++;} else printf("M:\n");} CompoundStmt {
		if(strcmp($2,"main")!=0)
		{
	    		insert_func($2,function-1,0);
	    		printf("goto M%d\n",function-1);
		}
		if ($1!=returntype_func(dom))
		{
			printf("\nError : Type not matching : Line %d\n",printline());
		}

		if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp($2,"puts") && strcmp($2,"putchar"))) 
			printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
		else 
		{ 
			insert($2,FUNCTION,nesting()); 
			insert($2,$1,nesting()); 
		}
		}
	| Type ID '(' Type ID ')' {if(strcmp($2,"main")!=0) {printf("F%d:\n",function);function++;} else printf("M:\n");} CompoundStmt {
		if(strcmp($2,"main")!=0)
		{
			insert_func($2,function-1,1);
		        printf("goto M%d\n",function-1);
		}
		if ($1!=returntype_func(dom))
		{
			printf("\nError : Type not matching : Line %d\n",printline());
		}

		if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar"))) 
			printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
		else 
		{ 
			insert($2,FUNCTION,nesting()); 
			insert($2,$1,nesting()); 
		}
	}
	| Type ID '(' Type ID ',' Type ID ')' {if(strcmp($2,"main")!=0) {printf("F%d:\n",function);function++;} else printf("M:\n");}CompoundStmt {
		if(strcmp($2,"main")!=0)
		{
			insert_func($2,function-1,2);
		        printf("goto M%d\n",function-1);
		}
		if ($1!=returntype_func(dom))
		{
			printf("\nError : Type not matching : Line %d\n",printline());
		}

		if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar"))) 
			printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
		else 
		{ 
			insert($2,FUNCTION,nesting()); 
			insert($2,$1,nesting()); 
		}
		}
	| Type ID '(' Type ID ',' Type ID ',' Type ID ')' {if(strcmp($2,"main")!=0) {printf("F%d:\n",function);function++;} else printf("M:\n");} CompoundStmt {
		if(strcmp($2,"main")!=0)
		{
		        insert_func($2,function-1,3);
		        printf("goto M%d\n",function-1);
		}
		if ($1!=returntype_func(dom))
		{
			printf("\nError : Type not matching : Line %d\n",printline());
		}

		if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar"))) 
			printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,printline()); 
		else 
		{ 
			insert($2,FUNCTION,nesting()); 
			insert($2,$1,nesting()); 
		}
		}
	;

Type : INT
	| FLOAT
	| VOID
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt 
	| 
	;

stmt : Declaration
	| if 
	| while 
	| dowhile 
	| for 
        | function_call
	| RETURN val ';' {
				if(!(strspn($2,"0123456789")==strlen($2))) 
					storereturn(dom,FLOAT); 
				else 
					storereturn(dom,INT); dom++;
			 } 
	| RETURN ';' {storereturn(dom,VOID); dom++;} 
	| ';'
	| PRINT '(' STRING ')' ';' 
	| CompoundStmt 
	;

dowhile : DO {dowhile1();} CompoundStmt WHILE '(' E ')' {dowhile2();} ';'
	;

for	: FOR '(' E {for1();} ';' E {for2();}';' E {for3();} ')' CompoundStmt {for4();}
	;

if : 	 IF '(' E ')' {flow_1();} CompoundStmt {flow_2();} else
	;

else : ELSE CompoundStmt {flow_3();}
	| 
	;

while : WHILE {while1();}'(' E ')' {while2();} CompoundStmt {while3();}
	;

assignment1 : ID {push($1);} '=' {strcpy(st1[++top],"=");} E {icg_1();}  
	{
		int sct=returnscope($1,stack[index1-1]); 
		int type=returntype($1,sct); 
		if((!(strspn($5,"0123456789")==strlen($5))) && type==258 && roo==0) 
			printf("\nError : Type not matching : Line %d\n",printline()); 
		if(!lookup($1)) 
		{ 
			int currscope=stack[index1-1]; 
			int scope=returnscope($1,currscope); 
			if((scope<=currscope && end[scope]==0) && !(scope==0)) 
			{
				check_scope_update($1,$5,currscope);
				
			}
		} 
        }

	| ID ',' assignment1    {
					if(lookup($1)) 
						printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
				}
	| val ',' assignment1   
	| ID  {
		if(lookup($1)) 
			printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
		}
	| val
	;

val : NUM
      | REAL
	;

E : E '+'{strcpy(st1[++top],"+");} T{icg();}
   | E '-'{strcpy(st1[++top],"-");} T{icg();}
   | T
   | ID {push($1);} EQ {strcpy(st1[++top],"==");} E {icg();}
   | ID {push($1);} AND {strcpy(st1[++top],"&&");} E {icg();}
   | ID {push($1);} OR {strcpy(st1[++top],"||");} E {icg();}
   | ID {push($1);} '<' {strcpy(st1[++top],"<");} E {icg();}
   | ID {push($1);} '>' {strcpy(st1[++top],">");} E {icg();}
   | ID {push($1);} '=' {strcpy(st1[++top],"||");} E {icg_1();}
   ;

T : T '*'{strcpy(st1[++top],"*");} F {icg();}
   | T '/'{strcpy(st1[++top],"/");} F {icg();}
   | F
   ;

F :'(' E ')' {$$=$2;} 
   | ID {push($1);roo=1;}
   | val {push($1);}
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
			insert($2,$1,nesting()); 
			insertscope($2,scope); 
		}
              }

             | Type ID {push($2);} '=' {strcpy(st1[++top],"=");} E {icg_1();} ';'  
	{
		if( (!(strspn($6,"0123456789")==strlen($6))) && $1==258 && (roo==0)) 
		{
			printf("\nError : Type not matching : Line %d\n",printline());
			roo=1;
		} 
		if(!lookup($2)) 
		{
			int currscope=stack[index1-1]; 
			int previous_scope=returnscope($2,currscope); 
			if(currscope==previous_scope) 
				printf("\nError : Redeclaration of %s : Line %d\n",$2,printline()); 
			else 
			{
				insert_dup($2,$1,currscope,nesting());
				int currscope=stack[index1-1]; 
			        int scope=returnscope($2,currscope); 
			if((scope<=currscope && end[scope]==0) && !(scope==0)) 
			{
				check_scope_update($2,$6,currscope);
				
			}
			}
		} 
		else 
		{ 
			int scope=stack[index1-1];  
			insert($2,$1,nesting()); 
			insertscope($2,scope); 
			check_scope_update($2,$6,stack[index1-1]);
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
						insert($2,ARRAY,nesting());
                                                int scope=stack[index1-1]; 
                                                insertscope($2,scope); 
						insert($2,$1,nesting()); 
                                                storevalue($2,$4,stack[index1-1]);
					}
	| error
	;


%%

#include "lex.yy.c"
#include<ctype.h>


int main(int argc, char *argv[])
{
	yyin =fopen(argv[1],"r");
        printf("goto M\n");
	yyparse();
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

void yyerror(char *s)
{
	printf("\nLine %d : %s %s\n",yylineno,s,yytext);
}

int printline()
{
	return yylineno;
}

int nesting()
{
return count;
}
