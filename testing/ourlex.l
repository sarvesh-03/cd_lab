%{    
     #include "y.tab.h"   
     int line_no=0;
     int v[33]={0};
     
%}

%option yylineno
alphabet          [a-zA-Z]
digit          [0-9]

%%

"output"		{ v[0]++; }
"input"		    { v[1]++; }

"if"            { v[2]++; }
"otherwise"	    { v[3]++; }
"asLongAs"	    { v[4]++; }
"return" 		{ v[5]++; }

"declare"	    { v[6]++; }
"+"		        { v[7]++; }
"-"		        { v[8]++; }
"*"		        { v[9]++; }
"/"		        { v[10]++; }
"log"		    { v[11]++; }
"exp"		    { v[12]++; }


">="		    { v[13]++; }
"<="		    { v[14]++; }
">"		        { v[15]++; }
"<"		        { v[16]++; }
"=="		    { v[17]++; }
"=!="		    { v[18]++; }

"TRUE"		    { v[19]++; }
"FALSE"		    { v[20]++; }
"&&"		    { v[21]++; }
"||"		    { v[22]++; }


"number"		{ v[23]++; }
"decimal"		{ v[24]++; }
"letter"		{ v[25]++; }
"boolean"		{ v[26]++; }

\#.*			{ ; }
[ \t]*		    { ; }
[\n]			{ v[27]++; }


[-]?{digit}+                		{ v[28]++; }
[-]?{digit}+\.{digit}{1,6}  		{ v[29]++; }
{alphabet}({alphabet}|{digit})*   	{ v[30]++; }



["].*["]                    { v[31]++; }
['].[']                     { v[32]++; }

.               { }

%%

int yywrap(void) {
return 1;
}

int yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
   return 1;
}


int main() 
  
{ 
    extern FILE *yyin, *yyout;
   
    yyin = fopen("input.txt", "r");
      
    yylex();
      
    // printf("\ntotal no. of token = %d\n\n", line_no);

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
    printf("int value   : %d\n",v[28]);
    printf("float value : %d\n",v[29]);
    printf("id          : %d\n",v[30]);
    printf("string      : %d\n",v[31]);
    printf("character   : %d\n",v[32]);

}
