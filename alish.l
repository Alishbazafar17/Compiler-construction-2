%{
#include <stdio.h>
#include "par.tab.h"
void yyerror(const char *s);
%}

%option yylineno

%%

"//".* { /* Ignore Comments */ }
^#.* { /* Ignore Preprocessor directives */ }
"using".* { /* Ignore using namespace */ }

"gino"                  { return GINO; }
"taro"                  { return TARO; }
"harf"                  { return HARF; }
"je"                    { return JE; }
"nahin"                 { return NAHIN; }
"tak"                   { return TAK; }
"ruk"                   { return RUK; }
"challo"                { return CHALLO; }
"wapsi"                 { return WAPSI; }
"dekha"                 { return DEKHA; }
"sir"                   { return SIR; }
"khali"                 { return KHALI; }
"dora"                  { return DORA; }
"theek"                 { return THEEK; }
"ghalat"                { return GHALAT; }

"=="                    { return EQ; }
"="                     { return '='; }
"+"                     { return '+'; }
"<"                     { return '<'; }
">"                     { return '>'; }
"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
";"                     { return ';'; }
","                     { return ','; }

[a-zA-Z]+[a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }
[0-9]+(\.[0-9]+)?       { yylval.sval = strdup(yytext); return NUMBER; }
\"[^\"]*\"              { yylval.sval = strdup(yytext); return STRING; }
\'[^\']*\'              { yylval.sval = strdup(yytext); return CHAR_LIT; }

[ \t\n\r]+              { /* Ignore whitespace */ }

.                       { printf("Unknown character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
