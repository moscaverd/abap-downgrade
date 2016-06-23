%option noyywrap case-insensitive

%{
   /* ABAP Version downgrader - ABAP 7.40 to ABAP 7.00 */

#include "y.tab.h"
#include "string.h"
%}

NQUOTE    [^']

%%

"DATA"      return(KW_DATA);
"TYPE"      return(KW_TYPE);
"METHOD"    return(KW_METHOD);
"ENDMETHOD" return(KW_ENDMETHOD);
"REPORT"    return(KW_REPORT);
"LOOP"      return(KW_LOOP);
"AT"        return(KW_AT);
"INTO"      return(KW_INTO);
"ENDLOOP"   return(KW_ENDLOOP);
"FIND"      return(KW_FIND);
"IN"        return(KW_IN);
"CALL"      return(KW_CALL);
"RESULT"    return(KW_RESULT);
"TRANSFORMATION"   return(KW_TRANSFORMATION);
"XML"       return(KW_XML);
"IMPORTING" return(KW_IMPORTING);
"EXPORTING" return(KW_EXPORTING);
"MATCH"     return(KW_MATCH);
"COUNT"     return(KW_COUNT);
"READ"      return(KW_READ);
"TABLE"     return(KW_TABLE);
"INDEX"     return(KW_INDEX);
"VALUE"     return(KW_VALUE);
"->"        return(KW_METHSIGN);
"["         return(LCOLCH);
"]"         return(RCOLCH);

  
[a-zA-Z]([a-zA-Z0-9\_])*  { 
                            yylval.sval=strdup(yytext);
                            return(IDENTIFIER);
                          };
"="			return(ASSIGNMENT);
[0-9]+		{ 
                    yylval.sval=strdup(yytext);
                    return(DIGSEQ);
                  }
"."			return(DOT);
"("			return(LPAREN);
"-"			{ yylval.cval='-'; return(MINUS); }
"+"			{ yylval.cval='+'; return(PLUS); }
[0-9]+"."[0-9]+	{
                    yylval.sval=strdup(yytext);
                    return(REALNUMBER);
                  }
")"			return(RPAREN);

"(*"[^"*)"]"*)"   |
"{"[^"}"]"}"	;
[ \n\t\f]		;

.			{printf("Illegal\n");  printf("%s\n",yytext);   return(ILLEGAL);}
