%{
#include <stdio.h>
#include <stdlib.h>

#include "runtime.h"

int yylex(void);
extern int yylineno;
void yyerror(const char *message);
%}

%define parse.error detailed

%union {
    char *text;
    double number;
    int boolean;
}

%token SENSOR RULE IF THEN ON OFF
%token AND OR
%token <text> IDENT
%token <number> NUMBER
%token GE LE EQ NE
%type <boolean> condition actuator_state

%left OR
%left AND

%%

program:
    %empty
    | program statement
    ;

statement:
    SENSOR IDENT '=' NUMBER ';'
    {
        sensor_set($2, $4);
        free($2);
    }
    | RULE IDENT '{'
    {
        printf("Evaluando regla: %s\n", $2);
        free($2);
    }
    rule_body '}'
    ;

rule_body:
    %empty
    | rule_body rule
    ;

rule:
    IF condition THEN IDENT '=' actuator_state ';'
    {
        if ($2) {
            actuator_set($4, $6);
        } else {
            printf("  Condicion falsa; no se ejecuta la accion para %s.\n", $4);
        }
        free($4);
    }
    ;

condition:
    IDENT '>' NUMBER
    {
        $$ = sensor_compare($1, CMP_GREATER, $3);
        free($1);
    }
    | IDENT '<' NUMBER
    {
        $$ = sensor_compare($1, CMP_LESS, $3);
        free($1);
    }
    | IDENT GE NUMBER
    {
        $$ = sensor_compare($1, CMP_GREATER_EQUAL, $3);
        free($1);
    }
    | IDENT LE NUMBER
    {
        $$ = sensor_compare($1, CMP_LESS_EQUAL, $3);
        free($1);
    }
    | IDENT EQ NUMBER
    {
        $$ = sensor_compare($1, CMP_EQUAL, $3);
        free($1);
    }
    | IDENT NE NUMBER
    {
        $$ = sensor_compare($1, CMP_NOT_EQUAL, $3);
        free($1);
    }
    | condition AND condition
    {
        $$ = $1 && $3;
    }
    | condition OR condition
    {
        $$ = $1 || $3;
    }
    | '(' condition ')'
    {
        $$ = $2;
    }
    ;

actuator_state:
    ON
    {
        $$ = 1;
    }
    | OFF
    {
        $$ = 0;
    }
    ;

%%

void yyerror(const char *message)
{
    fprintf(stderr, "Error de sintaxis en linea %d: %s\n", yylineno, message);
}
