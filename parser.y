%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    int yyerror(const char *s);
    int yylex();
    int yywrap();
%}

%token DECLARE CHARACTER PRINTFF SCANFF INT BOOL FLOAT CHAR WHILE IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULT DIV SUB RETURN LOG POW 

%%

program: entry '(' ')' '{' body return '}'
;


entry: datatype ID
;

datatype: INT 
| FLOAT 
| CHAR
;

body: block body
| 
;

block: WHILE '(' condition ')' ':' '{' body '}'
| IF '(' condition ')' ':' '{' body '}' else
| statement '.' 
| PRINTFF '(' STR ')' '.'
| SCANFF '(' STR ',' '&' ID ')' '.'
;

else: ELSE ':' '{' body '}'
|
;

condition: value relop value 
| TRUE 
| FALSE
;

statement: DECLARE ID datatype init 
| ID '=' expression 
| ID relop expression 
;

init: '=' value 
|
;


expression : expression addops term 
| term 
;

term : term mulops factor 
| factor 
; 

factor : base exponent base 
| LOG '(' value ',' value ')' 
| base
;

base : value 
| '(' expression ')' 
;


exponent: POW
;

mulops: MULT
| DIV
;

addops: ADD 
| SUB 
;

relop: LT
| GT
| LE
| GE
| EQ
| NE
;

value: NUMBER
| FLOAT_NUM
| ID
;

return: RETURN value '.' 
|
;

%%

int main() {
    yyparse();
}
