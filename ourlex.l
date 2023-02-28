%{    
     #include "y.tab.h"   
     int line_no=0;
     int v[33]={0};
     
%}

%option yylineno
alphabet          [a-zA-Z]
digit          [0-9]

%%

"output"		{ v[0]++;return PRINTFF; }
"input"		    { v[1]++;return SCANFF; }

"if"            { v[2]++;return IF; }
"otherwise"	    { v[3]++;return ELSE; }
"asLongAs"	    { v[4]++;return WHILE; }
"return" 		{ v[5]++;return RETURN; }

"declare"	    { v[6]++;return DECLARE; }
"+"		        { v[7]++;return ADD; }
"-"		        { v[8]++;return SUB; }
"*"		        { v[9]++;return MULT; }
"/"		        { v[10]++;return DIV; }
"log"		    { v[11]++;return LOG; }
"exp"		    { v[12]++;return POW; }


">="		    { v[13]++;return GE; }
"<="		    { v[14]++;return LE; }
">"		        { v[15]++;return GT; }
"<"		        { v[16]++;return LT; }
"=="		    { v[17]++;return EQ; }
"=!="		    { v[18]++;return NE; }

"TRUE"		    { v[19]++;return TRUE; }
"FALSE"		    { v[20]++;return FALSE; }
"&&"		    { v[21]++;return AND; }
"||"		    { v[22]++;return OR; }


"number"		{ v[23]++;return INT; }
"decimal"		{ v[24]++;return FLOAT; }
"letter"		{ v[25]++;return CHAR; }
"boolean"		{ v[26]++;return BOOL; }

\#.*			{ ; }
[ \t]*		    { ; }
[\n]			{ v[27]++;line_no++; }
.			    { return *yytext; }

[-]?{digit}+                		{ v[28]++;return NUMBER; }
[-]?{digit}+\.{digit}{1,6}  		{ v[29]++;return FLOAT_NUM; }
{alphabet}({alphabet}|{digit})*   	{ v[30]++;return ID; }



["].*["]                    { v[31]++;return STR; }
['].[']                     { v[32]++;return CHARACTER; }

%%

int yywrap(void) {
return 1;
}



int main() 
  
{ 
    extern FILE *yyin, *yyout;
   
    yyin = fopen("input.txt", "r");
      
    yylex();
      
    printf("\ntotal no. of token = %d\n\n", line_no);

    printf("output      : %d\n",v[0]);
    printf("input       : %d\n",v[1]);
    printf("if          : %d\n",v[2]);       
    printf("otherwise   : %d\n",v[3]);
    printf("asLongAs    : %d\n",v[4]);
    printf("return      : %d\n",v[5]);
    printf("declare     : %d\n",v[6]);
    printf("+           : %d\n",v[7]);
    printf("-           : %d\n",v[8]);
    printf("*           : %d\n",v[9]);
    printf("/           : %d\n",v[10]);
    printf("log         : %d\n",v[11]);
    printf("exp         : %d\n",v[12]);
    printf(">=          : %d\n",v[13]);
    printf("<=          : %d\n",v[14]);
    printf(">           : %d\n",v[15]);
    printf("<           : %d\n",v[16]);
    printf("==          : %d\n",v[17]);
    printf("=!=         : %d\n",v[18]);
    printf("TRUE        : %d\n",v[19]);
    printf("FALSE       : %d\n",v[20]);
    printf("&&          : %d\n",v[21]);
    printf("||          : %d\n",v[22]);
    printf("number      : %d\n",v[23]);
    printf("decimal     : %d\n",v[24]);
    printf("letter      : %d\n",v[25]);
    printf("boolean     : %d\n",v[26]);
    printf("new line    : %d\n",v[27]);
    printf("number      : %d\n",v[28]);
    printf("floatNumber : %d\n",v[29]);
    printf("id          : %d\n",v[30]);
    printf("string      : %d\n",v[31]);
    printf("character   : %d\n",v[32]);

}
