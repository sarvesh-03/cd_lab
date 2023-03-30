%{    
     #include "y.tab.h"
     int line_no=0;
%}

%option yylineno
%option noinput nounput
alphabet          [a-zA-Z]
digit          [0-9]

%%

"output"		{ strcpy(yylval.nd_obj.name,(yytext)); return PRINTFF; }
"input"			{ strcpy(yylval.nd_obj.name,(yytext));  return SCANFF; }

"if"                    { strcpy(yylval.nd_obj.name,(yytext));  return IF; }
"otherwise"		{ strcpy(yylval.nd_obj.name,(yytext));  return ELSE; }
"asLongAs"		{ strcpy(yylval.nd_obj.name,(yytext));  return WHILE; }
"return" 		{ strcpy(yylval.nd_obj.name,(yytext));  return RETURN; }

"declare"	{ strcpy(yylval.nd_obj.name,(yytext));  return DECLARE; }
"+"		{ strcpy(yylval.nd_obj.name,(yytext));  return ADD; }
"-"		{ strcpy(yylval.nd_obj.name,(yytext));  return SUB; }
"*"		{ strcpy(yylval.nd_obj.name,(yytext));  return MULT; }
"/"		{ strcpy(yylval.nd_obj.name,(yytext));  return DIV; }
"log"		{ strcpy(yylval.nd_obj.name,(yytext));  return LOG; }
"exp"		{ strcpy(yylval.nd_obj.name,(yytext));  return POW; }


">="		{ strcpy(yylval.nd_obj.name,(yytext));  return GE; }
"<="		{ strcpy(yylval.nd_obj.name,(yytext));  return LE; }
">"		{ strcpy(yylval.nd_obj.name,(yytext));  return GT; }
"<"		{ strcpy(yylval.nd_obj.name,(yytext));  return LT; }
"=="		{ strcpy(yylval.nd_obj.name,(yytext));  return EQ; }
"=!="		{ strcpy(yylval.nd_obj.name,(yytext));  return NE; }

"TRUE"		{ strcpy(yylval.nd_obj.name,(yytext));  return TRUE; }
"FALSE"		{ strcpy(yylval.nd_obj.name,(yytext));  return FALSE; }
"&&"		{ strcpy(yylval.nd_obj.name,(yytext));  return AND; }
"||"		{ strcpy(yylval.nd_obj.name,(yytext));  return OR; }


"number"		{ strcpy(yylval.nd_obj.name,(yytext));  return INT; }
"decimal"		{ strcpy(yylval.nd_obj.name,(yytext));  return FLOAT; }
"letter"		{ strcpy(yylval.nd_obj.name,(yytext));  return CHAR; }
"boolean"		{ strcpy(yylval.nd_obj.name,(yytext));  return BOOL; }

\#.*			{ ; }
[ \t]*			{ ; }
[\n]			{ line_no++; }


[-]?{digit}+                		{ strcpy(yylval.nd_obj.name,(yytext));  return NUMBER; }
[-]?{digit}+\.{digit}{1,6}  		{ strcpy(yylval.nd_obj.name,(yytext));  return FLOAT_NUM; }
{alphabet}({alphabet}|{digit})*   	{ strcpy(yylval.nd_obj.name,(yytext));  return ID; }



["].*["]                    { strcpy(yylval.nd_obj.name,(yytext));  return STR; }
['].[']                     { strcpy(yylval.nd_obj.name,(yytext));  return CHARACTER; }

"."|"="|","|"{"|"}"|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">" { strcpy(yylval.nd_obj.name,(yytext));  return yytext[0];}


%%

int yywrap(void) {
   return 1;
}

