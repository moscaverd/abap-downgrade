%{
   /* ABAP Version downgrader - ABAP 7.40 to ABAP 7.00 
  
	To execute: flex abapDowngrade.l
		    bison -y -d abapDowngrade.y
		    gcc y.tab.c lex.yy.c -o parser
                    ./parser abap74.txt 


   */
#include <stdio.h>
#include "string.h"
//#include "abapDowngrade.h"
#define eos(s) ((s)+strlen(s))
char preinst[4096];
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
%type <sval> variable_identifier
%type <sval> in_line_declaration
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
%type <sval> loop_statement
%type <sval> find_statement
%type <sval> transformation_statement
%type <sval> method_call
%type <sval> read_table_statement
%type <sval> loop_block
%type <sval> fields_filled
%type <sval> table_declaration
%type <sval> method_params
%type <sval> parameter_type
%%

code_start : start_heading{ printf("%s", $1); } ;

start_heading: start_heading start_heading {
                                                char *output = malloc(4096);
                                                sprintf(output, "%s %s", $1, $2);
                                                $$ = output;
                                           };
            | abap_statement ;

abap_statement: method_declaration | report_declaration | variable_declaration | in_line_declaration | statement;

method_declaration : KW_METHOD identifier DOT block KW_ENDMETHOD DOT{ };

report_declaration : KW_REPORT identifier DOT block { };

block : variable_declaration block {
                                        char *output = malloc(4096);
                                        sprintf(output, "%s\n%s", $1, $2);
                                        $$ = output;  
                                   }
      | statement block {   
                            char *output = malloc(4096);
                            sprintf(output, "%s\n%s", $1, $2);
                            $$ = output;      
                        } 
      | { $$ = ""; };

variable_declaration : KW_DATA identifier KW_TYPE identifier DOT { 
                                                                    char *output = malloc(4096);
                                                                    sprintf(output, "DATA %s TYPE %s.", $2, $4);
                                                                    $$ = output;
                                                                 }
		     | KW_DATA LPAREN identifier RPAREN ASSIGNMENT expression DOT { 
                                                                    char *output = malloc(4096);
                                                                    sprintf(output, "DATA %s TYPE any.\n%s = %s.\n", $3, $3, $6);
                                                                    $$ = output;
                                                                 }

in_line_declaration: KW_DATA LPAREN identifier RPAREN{ 
                                                        sprintf(preinst, "%sDATA %s TYPE any.\n", preinst, $3);
                                                        char *output = malloc(4096);
                                                        sprintf(output, "%s", $3);
                                                        $$ = output;
                                                     } 

statement : assignment_statement
          | loop_statement
          | find_statement
          | transformation_statement 
          | method_call
          | read_table_statement;

assignment_statement : identifier ASSIGNMENT expression DOT {} ;

loop_statement: KW_LOOP KW_AT identifier KW_INTO variable_identifier DOT loop_block 
{
    char *output = malloc(4096);
    sprintf( output, "%sLOOP AT %s INTO %s.\n%s", preinst, $3, $5, $7);
    $$ = output;
    preinst[0] = 0;
};

variable_identifier: identifier 
                   | in_line_declaration;

loop_block: block KW_ENDLOOP DOT 
{
    char *output = malloc(4096);
    sprintf( output, "%s\nENDLOOP.\n", $1);
    $$ = output;
};            

find_statement: KW_FIND identifier KW_IN identifier KW_MATCH KW_COUNT variable_identifier DOT {

    char *output = malloc(4096);
    sprintf(output, "%sFIND %s IN %s MATCH COUNT %s.\n", preinst, $2, $4, $7);
    $$ = output;    
    preinst[0] = 0;
};

transformation_statement: KW_CALL KW_TRANSFORMATION identifier KW_RESULT KW_XML variable_identifier DOT {printf("CALL TRANSFORMATION %s RESULT XML %s.", $3, $6);};

method_call: identifier KW_METHSIGN identifier LPAREN method_params RPAREN DOT { 
    char *output = malloc(4096);
    sprintf(output, "%s%s->%s(\n%s).\n", preinst, $1, $3, $5);
    $$ = output;    
    preinst[0] = 0;
};

method_params: parameter_type identifier ASSIGNMENT variable_identifier method_params 
{
    char *output = malloc(4096);
    sprintf(output, "%s %s = %s\n%s", $1, $2, $4, $5);
    $$ = output;    
    
}
             | { $$ = ""; } ;

parameter_type: KW_EXPORTING { $$ = "EXPORTING"; }
              | KW_IMPORTING { $$ = "IMPORTING"; }
              |;

read_table_statement: KW_READ KW_TABLE identifier KW_INTO variable_identifier KW_INDEX DIGSEQ DOT {printf("READ TABLE %s INTO %s INDEX %s.", $3, $5, $7); };

read_table_in_line: identifier LCOLCH DIGSEQ RCOLCH {};

table_declaration: KW_VALUE identifier LPAREN fields_filled RPAREN {
                                                                        char *output = malloc(4096);
                                                                        sprintf(output, "VALUE %s(%s).", $2, $4);
                                                                        $$ = output;
                                                                   };

fields_filled: LPAREN identifier RPAREN fields_filled {
                                                        char *output = malloc(4096);
                                                        sprintf(output, "APPEND %s TO %s.", $4, $2);
                                                        $$ = output; 
                                                      }
             | ; 

expression : value
           | method_call
           | read_table_in_line 
           | table_declaration;

value : value sign value {
                            char *output = malloc(4096);
                            sprintf(output, "%s %s %s", $1, $2, $3);
                            $$ = output;  
                         }
      | unsigned_number;
      | identifier;

unsigned_number : unsigned_integer 
                | unsigned_real ;

unsigned_integer : DIGSEQ;

unsigned_real : REALNUMBER;

sign : PLUS 
     | MINUS ;

identifier : IDENTIFIER;

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

