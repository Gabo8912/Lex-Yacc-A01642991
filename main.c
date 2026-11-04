#include <stdio.h>
#include <stdlib.h>

#include "runtime.h"

extern FILE *yyin;
int yyparse(void);
void runtime_print_results(void);

int main(int argc, char **argv)
{
    int parse_result;

    if (argc > 2) {
        fprintf(stderr, "Uso: %s [archivo.iot]\n", argv[0]);
        return EXIT_FAILURE;
    }

    if (argc == 2) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            perror(argv[1]);
            return EXIT_FAILURE;
        }
    }

    parse_result = yyparse();
    if (argc == 2) {
        fclose(yyin);
    }

    if (parse_result != 0 || runtime_error) {
        runtime_cleanup();
        return EXIT_FAILURE;
    }

    runtime_print_results();
    runtime_cleanup();
    return EXIT_SUCCESS;
}
