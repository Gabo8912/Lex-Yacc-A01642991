%option noinput nounput noyywrap yylineno

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.h"
%}

DIGIT       [0-9]
NUMBER      -?{DIGIT}+(\.{DIGIT}+)?
IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*

%%

[ \t\r\n]+                ;
"#"[^\n]*                 ;
"sensor"                  return SENSOR;
"regla"                   return RULE;
"si"                      return IF;
"entonces"                return THEN;
"encendido"               return ON;
"apagado"                 return OFF;
"AND"                     return AND;
"OR"                      return OR;
">="                      return GE;
"<="                      return LE;
"=="                      return EQ;
"!="                      return NE;
{NUMBER}                  {
                              yylval.number = strtod(yytext, NULL);
                              return NUMBER;
                          }
{IDENTIFIER}              {
                              yylval.text = malloc((size_t)yyleng + 1);
                              if (yylval.text == NULL) {
                                  perror("No se pudo reservar memoria");
                                  exit(EXIT_FAILURE);
                              }
                              memcpy(yylval.text, yytext, (size_t)yyleng);
                              yylval.text[yyleng] = '\0';
                              return IDENT;
                          }
[{}=:;><()]               return yytext[0];
.                         {
                              fprintf(stderr,
                                      "Error lexico en linea %d: caracter inesperado '%s'.\n",
                                      yylineno, yytext);
                              return yytext[0];
                          }

%%
