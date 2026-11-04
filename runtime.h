#ifndef RUNTIME_H
#define RUNTIME_H

typedef enum {
    CMP_EQUAL,
    CMP_NOT_EQUAL,
    CMP_LESS,
    CMP_LESS_EQUAL,
    CMP_GREATER,
    CMP_GREATER_EQUAL
} Comparison;

extern int runtime_error;

void sensor_set(const char *name, double value);
int sensor_compare(const char *name, Comparison comparison, double value);
void actuator_set(const char *name, int enabled);
void runtime_cleanup(void);

#endif
