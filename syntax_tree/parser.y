%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    int yyerror(const char *s);
    int yylex(void);
    int yywrap();
    

    void printtree(struct node*);
    void printInorder(struct node *);
    struct node* mknode(struct node *left, struct node *right, char *token);

    int success = 1;
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
}

%token <nd_obj> DECLARE CHARACTER PRINTFF SCANFF INT BOOL FLOAT CHAR WHILE IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULT DIV SUB RETURN LOG POW 

%type <nd_obj> program entry datatype body block else condition statement init expression term factor base exponent mulops addops relop value return 

%define parse.error verbose
%%

program: entry '(' ')' '{' body return '}' { struct node *main = mknode($5.nd, $6.nd, "main"); $$.nd = mknode($1.nd, main, "program"); head = $$.nd; } 
;

entry: datatype ID
;

datatype: INT 
| FLOAT 
| CHAR
;

body: block body
| { $$.nd = NULL; }
;

block: WHILE '(' condition ')' ':' '{' body '}' { $$.nd = mknode($3.nd, $7.nd, $1.name); } //
| IF '(' condition ')' ':' '{' body '}' else { struct node *iff = mknode($3.nd, $7.nd, $1.name); 	$$.nd = mknode(iff, $9.nd, "if-else"); }
| statement '.' { $$.nd = $1.nd; }
| PRINTFF '(' STR ')' '.' { $$.nd = mknode(NULL, NULL, "printf"); }
| SCANFF '(' STR ',' '&' ID ')' '.' { $$.nd = mknode(NULL, NULL, "scanf"); }
;

else: ELSE ':' '{' body '}' { $$.nd = mknode(NULL, $4.nd, $1.name); }
| { $$.nd = NULL; }
;

condition: value relop value { $$.nd = mknode($1.nd, $3.nd, $2.name);}
| TRUE {$$.nd = NULL; }
| FALSE {$$.nd = NULL; }
;

statement: DECLARE ID datatype init {$1.nd = mknode($2.nd, $3.nd, $1.name); $$.nd = mknode($1.nd, $4.nd, "DECLARE");} //
| ID '=' expression { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, "="); }
| ID relop expression { $1.nd = mknode(NULL, NULL, $1.name); $$.nd = mknode($1.nd, $3.nd, $2.name ); }
;

init: '=' value { $$.nd = $2.nd;}
| { $$.nd = NULL; }
;


expression : expression addops term { $$.nd = mknode($1.nd, $3.nd, $2.name); }
| term { $$.nd = $1.nd;}
;

term : term mulops factor { $$.nd = mknode($1.nd, $3.nd, $2.name); }
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

value: NUMBER {$$.nd = mknode(NULL, NULL, $1.name);}
| FLOAT_NUM {$$.nd = mknode(NULL, NULL, $1.name);}
| ID {$$.nd = mknode(NULL, NULL, $1.name);}
;

return: RETURN value '.'  { $1.nd = mknode(NULL, NULL, "return"); $$.nd = mknode($1.nd, $2.nd, "RETURN"); }
| { $$.nd = NULL; } 
;

%%

struct node* mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
	char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return(newnode);
}

void printtree(struct node* tree) {
	printf("\n\n Inorder traversal of the Parse Tree: \n\n");
	printInorder(tree);
	printf("\n\n");
}

void printInorder(struct node *tree) {
	int i;
	if (tree->left) {
		printInorder(tree->left);
	}
	printf("%s, ", tree->token);
	if (tree->right) {
		printInorder(tree->right);
	}
}

int main() {
    extern FILE *yyin, *yyout;
   
    yyparse();
    if(success)
        printf("Parsing Successful\n");


    printf("\n\n");
	printf("\t\t\t\t\t\t PHASE 2: PARSE TREE: \n\n");
    // printf(head->token);
	printtree(head); 
	printf("\n\n");

    return 0;
}

int yyerror(const char *msg)
{
    extern int yylineno;
    printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
    success = 0;
    return 0;
}
