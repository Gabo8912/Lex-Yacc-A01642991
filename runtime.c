#include "runtime.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Sensor {
    char *name;
    double value;
    struct Sensor *next;
} Sensor;

typedef struct Actuator {
    char *name;
    int enabled;
    struct Actuator *next;
} Actuator;

static Sensor *sensors;
static Actuator *actuators;
int runtime_error;

static char *copy_string(const char *value)
{
    size_t length = strlen(value) + 1;
    char *copy = malloc(length);

    if (copy == NULL) {
        perror("No se pudo reservar memoria");
        exit(EXIT_FAILURE);
    }

    memcpy(copy, value, length);
    return copy;
}

void sensor_set(const char *name, double value)
{
    Sensor *sensor;

    for (sensor = sensors; sensor != NULL; sensor = sensor->next) {
        if (strcmp(sensor->name, name) == 0) {
            sensor->value = value;
            return;
        }
    }

    sensor = malloc(sizeof(*sensor));
    if (sensor == NULL) {
        perror("No se pudo reservar memoria");
        exit(EXIT_FAILURE);
    }

    sensor->name = copy_string(name);
    sensor->value = value;
    sensor->next = sensors;
    sensors = sensor;
}

int sensor_compare(const char *name, Comparison comparison, double value)
{
    Sensor *sensor;

    for (sensor = sensors; sensor != NULL; sensor = sensor->next) {
        if (strcmp(sensor->name, name) == 0) {
            switch (comparison) {
            case CMP_EQUAL:
                return sensor->value == value;
            case CMP_NOT_EQUAL:
                return sensor->value != value;
            case CMP_LESS:
                return sensor->value < value;
            case CMP_LESS_EQUAL:
                return sensor->value <= value;
            case CMP_GREATER:
                return sensor->value > value;
            case CMP_GREATER_EQUAL:
                return sensor->value >= value;
            }
        }
    }

    fprintf(stderr, "Error semantico: el sensor '%s' no esta definido.\n", name);
    runtime_error = 1;
    return 0;
}

void actuator_set(const char *name, int enabled)
{
    Actuator *actuator;

    for (actuator = actuators; actuator != NULL; actuator = actuator->next) {
        if (strcmp(actuator->name, name) == 0) {
            actuator->enabled = enabled;
            printf("  Accion: %s = %s\n", name, enabled ? "encendido" : "apagado");
            return;
        }
    }

    actuator = malloc(sizeof(*actuator));
    if (actuator == NULL) {
        perror("No se pudo reservar memoria");
        exit(EXIT_FAILURE);
    }

    actuator->name = copy_string(name);
    actuator->enabled = enabled;
    actuator->next = actuators;
    actuators = actuator;
    printf("  Accion: %s = %s\n", name, enabled ? "encendido" : "apagado");
}

static void print_actuators(void)
{
    Actuator *actuator;

    printf("\nEstado final de actuadores:\n");
    if (actuators == NULL) {
        printf("  Ninguna accion fue ejecutada.\n");
        return;
    }

    for (actuator = actuators; actuator != NULL; actuator = actuator->next) {
        printf("  %s = %s\n", actuator->name,
               actuator->enabled ? "encendido" : "apagado");
    }
}

void runtime_cleanup(void)
{
    while (sensors != NULL) {
        Sensor *sensor = sensors;
        sensors = sensor->next;
        free(sensor->name);
        free(sensor);
    }

    while (actuators != NULL) {
        Actuator *actuator = actuators;
        actuators = actuator->next;
        free(actuator->name);
        free(actuator);
    }
}

void runtime_print_results(void)
{
    print_actuators();
}
