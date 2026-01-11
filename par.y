%{
#include <stdio.h>
#include <stdlib.h>

int error_found = 0; 
extern int yylineno;
extern int yylex();
extern char *yytext;
extern FILE *yyin;

/* Global file pointer for e.txt */
FILE *e_file;

void yyerror(const char *msg);
%}

%union {
    char *sval;
}

%token <sval> ID NUMBER STRING CHAR_LIT
%token GINO TARO HARF JE NAHIN TAK DORA RUK CHALLO WAPSI DEKHA SIR KHALI THEEK GHALAT
%token EQ

%left '+'
%left LT GT EQ

%%

program: KHALI SIR '(' ')' block ;

block: '{' stmt_list '}' ;

stmt_list: stmt stmt_list | ;

stmt: declaration | assignment | conditional | loop | io_stmt | jump_stmt | block | ';' | error ';' { yyerrok; } ;

declaration: type var_list ';' ;

type: GINO | TARO | HARF ;

var_list: var_init | var_init ',' var_list ;

var_init: ID | ID '=' expression ;

assignment: ID '=' expression ';' ;

conditional: JE '(' expression ')' stmt | JE '(' expression ')' stmt NAHIN stmt ;

loop: TAK '(' expression ')' stmt | DORA '(' dora_init expression ';' dora_inc ')' stmt ;

dora_init: type var_init ';' | ID '=' expression ';' ;

dora_inc: ID '=' expression ;

io_stmt: DEKHA '(' print_list ')' ';' ;

print_list: print_item | print_item ',' print_list ;

print_item: expression | STRING ;

jump_stmt: WAPSI ';' | RUK ';' | CHALLO ';' ;

expression: simple_expr | simple_expr rel_op simple_expr ;

simple_expr: term | term '+' term ;

term: ID | NUMBER | CHAR_LIT | THEEK | GHALAT ;

rel_op: EQ | '<' | '>' ;

%%

void yyerror(const char *msg) {
    error_found = 1;
    /* Print to terminal for immediate feedback */
    fprintf(stderr, "Error found (Line %d): %s. Unexpected token: '%s'\n", yylineno, msg, yytext);
    
    /* Print to e.txt if the file opened successfully */
    if (e_file) {
        fprintf(e_file, "Error found (Line %d): %s. Unexpected token: '%s'\n", yylineno, msg, yytext);
        fflush(e_file); // This forces the data out of memory and into the file
    }
}

int main(int argc, char **argv) {
    /* "w" mode creates e.txt if it doesn't exist, and overwrites it if it does */
    e_file = fopen("e.txt", "w");
    if (!e_file) {
        perror("Error creating e.txt");
        return 1;
    }

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            fclose(e_file);
            return 1;
        }
    }
    
    yyparse();

    if (error_found == 0) {
        printf("\nSyntax Analysis Successful!\n");
    } else {
        printf("\nSyntax Analysis Failed. Check e.txt for details.\n");
    }
    
    if (yyin) fclose(yyin);
    fclose(e_file); // Properly close the file to save all data
    return 0;
}
