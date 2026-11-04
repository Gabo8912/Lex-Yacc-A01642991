#!/bin/sh
set -eu

output="$(./interprete examples/casa_inteligente.iot)"
printf '%s\n' "$output" | grep -q 'ventilador = encendido'
printf '%s\n' "$output" | grep -q 'Condicion falsa'
printf '%s\n' "$output" | grep -q 'Estado final de actuadores'

if printf '%s\n' 'regla prueba { si sensor_inexistente > 1 entonces alarma = encendido; }' \
    | ./interprete >/dev/null 2>&1; then
    printf '%s\n' 'Se esperaba un error para un sensor no declarado.' >&2
    exit 1
fi

printf '%s\n' 'Pruebas correctas.'
