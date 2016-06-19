#!/bin/bash   
flex abapDowngrade.l
bison -y -d abapDowngrade.y
gcc y.tab.c lex.yy.c -o parser 