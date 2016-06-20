%{
   /* ABAP Version downgrader - ABAP 7.40 to ABAP 7.00 
  
	To execute: flex abapDowngrade.l
		    bison -y -d abapDowngrade.y
		    gcc y.tab.c lex.yy.c -o parser
                    ./parser abap74.txt 


   */
#include <stdio.h>
#include "string.h"

%}

%error-verbose

%union {
	 double dval;
       int    ival;
       char   cval;
	 char   *sval;
}

%token <cval> ASSIGNMENT 
%token <sval> DIGSEQ
%token <cval> DOT 
%token <cval> LPAREN 
%token <cval> MINUS 
%token <cval> PLUS 
%token <sval> REALNUMBER 
%token <cval> RPAREN 
%token <sval> IDENTIFIER 
%token <sval> KW_METHOD
%token <sval> KW_ENDMETHOD
%token <sval> KW_REPORT
%token <sval> KW_DATA
%token <sval> KW_TYPE
%token <sval> KW_LOOP
%token <sval> KW_AT
%token <sval> KW_INTO
%token <sval> KW_ENDLOOP
%token <sval> KW_FIND;
%token <sval> KW_IN;
%token <sval> KW_RESULT;
%token <sval> KW_TRANSFORMATION;
%token <sval> KW_XML;
%token <sval> KW_CALL;
%token <sval> KW_IMPORTING;
%token <sval> KW_EXPORTING;
%token <sval> KW_MATCH;
%token <sval> KW_COUNT;
%token <sval> KW_METHSIGN;
%token <sval> KW_TABLE;
%token <sval> KW_READ;
%token <sval> KW_INDEX;
%token <sval> KW_VALUE;
%token <sval> LCOLCH;
%token <sval> RCOLCH;
%token <cval> ILLEGAL

%start code_start

%type <sval> start_heading
%type <sval> method_declaration
%type <sval> report_declaration
%type <sval> identifier
%type <sval> block
%type <sval> value
%type <sval> statement
%type <sval> assignment_statement
%type <sval> unsigned_number 
%type <sval> unsigned_integer
%type <sval> unsigned_real
%type <sval> variable_declaration 
%type <sval> expression
%type <cval> sign
%%

code_start : start_heading{} ;

start_heading: start_heading start_heading | method_declaration method_declaration | report_declaration | ;

method_declaration : KW_METHOD identifier DOT block KW_ENDMETHOD DOT{printf("Declaracao METHOD %s\n", $2);};
report_declaration : KW_REPORT identifier DOT block {printf("Declaracao REPORT %s\n", $2);};

block : variable_declaration block { }
      | statement block { } 
      | ;

variable_declaration : KW_DATA identifier KW_TYPE identifier DOT {printf("DECLARACAO V: %s TYPE %s\n", $2, $4);} 
		     | KW_DATA LPAREN identifier RPAREN ASSIGNMENT expression DOT {printf("DECLARACAO V: %s TYPE %s\n", $3, $6);};

in_line_declaration: KW_DATA LPAREN identifier RPAREN {printf("DATA %s TYPE any.", $3);};

statement : assignment_statement{printf("assign");}
          | loop_statement{printf("loop");}
          | find_statement{printf("find");}
          | transformation_statement {printf("transformation");}
          | method_call {printf("method call");}
          | read_table_statement {printf("read table");};

assignment_statement : identifier ASSIGNMENT expression DOT
    {
// printf("ATRIBUI para <%s> o valor %s\n",$1,$3); 
} ;

loop_statement: KW_LOOP KW_AT identifier KW_INTO variable_identifier DOT loop_block { };

variable_identifier: identifier { }
                   | in_line_declaration { printf("transform setense"); };

loop_block: block KW_ENDLOOP DOT { };            

find_statement: KW_FIND identifier KW_IN identifier KW_MATCH KW_COUNT variable_identifier DOT { };

transformation_statement: KW_CALL KW_TRANSFORMATION identifier KW_RESULT KW_XML variable_identifier DOT { };

method_call: identifier KW_METHSIGN identifier LPAREN method_params RPAREN DOT { };

method_params: parameter_type identifier ASSIGNMENT variable_identifier method_params { }
             | ;

parameter_type: KW_EXPORTING
              | KW_IMPORTING
              |;

read_table_statement: KW_READ KW_TABLE identifier KW_INTO variable_identifier KW_INDEX DIGSEQ DOT { };

read_table_in_line: identifier LCOLCH DIGSEQ RCOLCH {printf("READ TABLE %s INTO AFF INDEX %s", $1, $3);};

table_declaration: KW_VALUE identifier LPAREN fields_filled RPAREN{ };

fields_filled: LPAREN identifier RPAREN fields_filled {printf("APPEND %s TO table?.", $2);}
             | ; 

expression : value
           | method_call
           | read_table_in_line 
           | table_declaration;

value : value sign value {
                            $$ = strcat($1, (char[4]) { ' ', (char) $2, ' ','\0' });
                            $$ = strcat($$, $3);
                         }
      | unsigned_number { $$=$1; };
      | identifier;

unsigned_number : unsigned_integer 
                | unsigned_real ;

unsigned_integer : DIGSEQ { $$=$1; };

unsigned_real : REALNUMBER { $$=$1; } ;

sign : PLUS 
     | MINUS ;

identifier : IDENTIFIER { $$ = $1; } ;

%%

#include <stdio.h>

extern FILE *yyin;

int yywrap()
{
	return 0;
}

void yyerror(char *s)
{
  fprintf(stderr,"ERROR: %s\n",s);
}

main ()
{
  do { yyparse(); }
  while (!feof(yyin));
}

char* concat(char *s1, char *s2)
{
    char *result = malloc(strlen(s1)+strlen(s2)+1);//+1 for the zero-terminator
    //in real code you would check for errors in malloc here
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}