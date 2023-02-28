%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    void yyerror(const char *s);
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

body: WHILE '(' condition ')' ':' '{' body '}'
| IF '(' condition ')' '{' body '}' else
| statement '.' 
| body body
| PRINTFF '(' STR ')' '.'
| SCANFF '(' STR ',' '&' ID ')' '.'
;

else: ELSE '{' body '}'
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

expression: expression arithmetic expression
| value
| LOG '(' expression ',' expression ')'
;

arithmetic: ADD 
| SUB 
| MULT
| DIV
| POW
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

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}