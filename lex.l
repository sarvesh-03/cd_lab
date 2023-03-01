%{    
     #include "y.tab.h"
     int line_no=0;
%}

%option yylineno
alphabet          [a-zA-Z]
digit          [0-9]

%%

"output"		{ return PRINTFF; }
"input"			{ return SCANFF; }

"if"                    { return IF; }
"otherwise"		{ return ELSE; }
"asLongAs"		{ return WHILE; }
"return" 		{ return RETURN; }

"declare"	{ return DECLARE; }
"+"		{ return ADD; }
"-"		{ return SUB; }
"*"		{ return MULT; }
"/"		{ return DIV; }
"log"		{ return LOG; }
"exp"		{ return POW; }


">="		{ return GE; }
"<="		{ return LE; }
">"		{ return GT; }
"<"		{ return LT; }
"=="		{ return EQ; }
"=!="		{ return NE; }

"TRUE"		{ return TRUE; }
"FALSE"		{ return FALSE; }
"&&"		{ return AND; }
"||"		{ return OR; }


"number"		{ return INT; }
"decimal"		{ return FLOAT; }
"letter"		{ return CHAR; }
"boolean"		{ return BOOL; }

\#.*			{ ; }
[ \t]*			{ ; }
[\n]			{ line_no++; }

.         { yyerror("Unrecognized Input! "); return *yytext;}


[-]?{digit}+                		{ return NUMBER; }
[-]?{digit}+\.{digit}{1,6}  		{ return FLOAT_NUM; }
{alphabet}({alphabet}|{digit})*   	{ return ID; }



["].*["]                    { return STR; }
['].[']                     { return CHARACTER; }


%%

int yywrap(void) {
return 1;
}

int yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
   return 1;
}
