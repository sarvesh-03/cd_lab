%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    int yyerror(const char *s);
    int yylex(void);
    int yywrap();

    int ic_idx=0;
    int label=0;
	int temp_var=0;
    int is_for=0;
    char icg[50][100];
    

    // void printtree(struct node*);
    // void printInorder(struct node *);
    struct node* mknode(struct node *left, struct node *right, char *token);
    void printBT(struct node*);

    // int success = 1;
    struct node *head;
    struct node { 
        struct node *left; 
        struct node *right; 
        char *token; 
    };
%}


%union { 
	struct var_name { 
		char name[100]; 
		struct node* nd;
	} nd_obj; 

    struct var_name2 { 
			char name[100]; 
			struct node* nd;
			char type[10];
		} nd_obj2; 


    struct var_name3 {
			char name[100];
			struct node* nd;
			char if_body[5];
			char else_body[5];
		} nd_obj3;
}

%token <nd_obj> DECLARE CHARACTER PRINTFF SCANFF INT BOOL FLOAT CHAR WHILE IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULT DIV SUB RETURN LOG POW 

%type <nd_obj> program entry datatype body block else statement term factor base exponent mulops addops relop return 

%type <nd_obj2> init value expression
%type <nd_obj3> condition
/* %define parse.error verbose */
%%

program: entry '(' ')' '{' body return '}' { struct node *main = mknode($5.nd, $6.nd, "main"); $$.nd = mknode($1.nd, main, "program"); head = $$.nd; } 
;

entry: datatype ID
;

datatype: INT 
| FLOAT 
| CHAR
;
// To be handled
body: block body {$$.nd = mknode($1.nd, $2.nd, "body");}
| { $$.nd = NULL; }
;

block: WHILE {is_for=1;}'(' condition ')' ':' '{' body '}' { $$.nd = mknode($4.nd, $8.nd, $1.name); 
    sprintf(icg[ic_idx++], "JUMP to %s\n", $4.if_body);
	sprintf(icg[ic_idx++], "\nLABEL %s:\n", $4.else_body); }
| IF {is_for=0;} '(' condition ')' { sprintf(icg[ic_idx++], "\nLABEL %s:\n", $4.if_body); } ':' '{' body '}' { sprintf(icg[ic_idx++], "LABEL %s:\n", $4.else_body); } else { struct node *iff = mknode($4.nd, $9.nd, $1.name); 	$$.nd = mknode(iff, $12.nd, "if-else"); sprintf(icg[ic_idx++], "GOTO next\n"); }
| statement '.' { $$.nd = $1.nd; }
| PRINTFF '(' STR ')' '.' { $$.nd = mknode(NULL, NULL, "printf"); }
| SCANFF '(' STR ',' '&' ID ')' '.' { $$.nd = mknode(NULL, NULL, "scanf"); }// To be handled
;

else: ELSE ':' '{' body '}' { $$.nd = mknode(NULL, $4.nd, $1.name); }
| { $$.nd = NULL; }
;

condition: value relop value { 
    $$.nd = mknode($1.nd, $3.nd, $2.name);
    if(is_for) {
		sprintf($$.if_body, "L%d", label++);
		sprintf(icg[ic_idx++], "\nLABEL %s:", $$.if_body);
		sprintf(icg[ic_idx++], "\nif NOT (%s %s %s) GOTO L%d\n", $1.name, $2.name, $3.name, label);
		sprintf($$.else_body, "L%d", label++);
	} else {
		sprintf(icg[ic_idx++], "\nif (%s %s %s) GOTO L%d else GOTO L%d\n", $1.name, $2.name, $3.name, label, label+1);
		sprintf($$.if_body, "L%d", label++);
		sprintf($$.else_body, "L%d", label++);
	}
}
| TRUE {$$.nd = NULL; }
| FALSE {$$.nd = NULL; }
;

statement: DECLARE ID datatype init {$2.nd = mknode(NULL, NULL, $2.name); $1.nd = mknode($2.nd, $3.nd, $1.name); $$.nd = mknode($1.nd, $4.nd, "DECLARE"); sprintf(icg[ic_idx++], "%s = %s\n", $2.name, $4.name);} //
| ID '=' expression { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, "="); sprintf(icg[ic_idx++], "%s = %s\n", $1.name, $3.name); }
| ID relop expression { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, $2.name ); }
;

init: '=' value { $$.nd = $2.nd; sprintf($$.type, $2.type);strcpy($$.name, $2.name);}
| { $$.nd = NULL; }
;


expression : expression addops term { $$.nd = mknode($1.nd, $3.nd, $2.name); sprintf($$.name, "t%d", temp_var);
	temp_var++;
	sprintf(icg[ic_idx++], "%s = %s %s %s\n",  $$.name, $1.name, $2.name, $3.name);}
| term { $$.nd = $1.nd;}
;

term : term mulops factor { $$.nd = mknode($1.nd, $3.nd, $2.name); sprintf($$.name, "t%d", temp_var);
	temp_var++;
	sprintf(icg[ic_idx++], "%s = %s %s %s\n",  $$.name, $1.name, $2.name, $3.name); }
| factor {$$.nd = $1.nd;}
; 

factor : base exponent base { $$.nd = mknode($1.nd, $3.nd, $2.name); }
| LOG '(' value ',' value ')' {$$.nd = mknode($3.nd, $5.nd, $1.name); }
| base {$$.nd = $1.nd;}
;

base : value {$$.nd = $1.nd;}
| '(' expression ')' {$$.nd = $2.nd;}
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

value: NUMBER {strcpy($$.name, $1.name);$$.nd = mknode(NULL, NULL, $1.name);  sprintf($$.type, "int"); }
| FLOAT_NUM {strcpy($$.name, $1.name);$$.nd = mknode(NULL, NULL, $1.name);  sprintf($$.type, "float");} 
| ID {strcpy($$.name, $1.name);$$.nd = mknode(NULL, NULL, $1.name);  sprintf($$.type, "Var");}
;

return: RETURN value '.'  { $1.nd = mknode(NULL, NULL, "return"); $$.nd = mknode($1.nd, $2.nd, "RETURN"); }
| { $$.nd = NULL; } 
;

%%

int main() {
    extern FILE *yyin, *yyout;
   
    int p = -1;
    p = yyparse();
    /* if(success)
        printf("Parsing Successful\n"); */
    if(p)
        printf("Parsing Successful\n");

    printf("\n\n");
    printf("PARSE TREE");
    printf("\n\n");
	printBT(head);

	printf("\n\n");
    printf("THREE ADDRESS CODE");
    printf("\n\n");
    for(int i=0; i<ic_idx; i++){
		printf("%s", icg[i]);
	}
    printf("\n\n");
    return p;
}

int yyerror(const char *msg)
{
    extern int yylineno;
    printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
    /* success = 0; */
    return 0;
}

void printBTHelper(char* prefix, struct node* ptr, int isLeft) {
    if( ptr != NULL ) {
        printf("%s",prefix);
        if(isLeft) { printf("├──"); } 
		else { printf("└──"); }
        printf("%s",ptr->token);
		printf("\n");
		char* addon = isLeft ? "│   " : "    ";
    	int len2 = strlen(addon);
    	int len1 = strlen(prefix);
    	char* result = (char*)malloc(len1 + len2 + 1);
    	strcpy(result, prefix);
    	strcpy(result + len1, addon);
		printBTHelper(result, ptr->left, 1);
		printBTHelper(result, ptr->right, 0);
    	free(result);
    }
}

void printBT(struct node* ptr) {
	printf("\n");
    printBTHelper("", ptr, 0);    
}

struct node* mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
	char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return(newnode);
}

