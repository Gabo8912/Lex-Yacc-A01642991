# Interprete IoT con Lex y Yacc

Interprete de un lenguaje pequeno para simular reglas de automatizacion de una casa inteligente. Flex realiza el analisis lexico y GNU Bison (Yacc) el analisis sintactico; el programa evalua condiciones sobre sensores y actualiza actuadores.

## Requisitos

- GCC
- GNU Make
- Flex
- GNU Bison

En Debian o Ubuntu se pueden instalar con:

```sh
sudo apt-get update
sudo apt-get install -y gcc make flex bison
```

## Compilar y ejecutar

```sh
make
./interprete examples/casa_inteligente.iot
```

El programa tambien puede leer el codigo desde la entrada estandar:

```sh
printf 'sensor temperatura = 30;\nregla clima { si temperatura > 25 entonces ventilador = encendido; }\n' | ./interprete
```

Ejecuta las pruebas basicas con `make test`.

## Lenguaje

Los sensores se declaran con un valor numerico. Las reglas contienen una o mas acciones condicionales:

```text
sensor temperatura = 30;
sensor humo = 0;

regla seguridad {
    si humo == 1 OR temperatura >= 45 entonces alarma = encendido;
    si temperatura < 10 entonces calefaccion = apagado;
}
```

Elementos del lenguaje:

- Declaracion: `sensor IDENTIFICADOR = NUMERO;`
- Regla: `regla IDENTIFICADOR { ... }`
- Condicion: comparaciones `>`, `<`, `>=`, `<=`, `==`, `!=`, combinadas con `AND`, `OR` y parentesis.
- Accion: `si CONDICION entonces ACTUADOR = encendido|apagado;`
- Los comentarios comienzan con `#`.
- Un sensor debe declararse antes de usarse. Los errores lexicos, sintacticos y de sensores no declarados se informan y terminan con codigo distinto de cero.

Las reglas se evalúan en orden; una accion solo se aplica cuando su condicion es verdadera. Al final se muestran los actuadores que recibieron una accion y su estado final.

## Docker

Construye una imagen local (Flex y Bison se instalan solo en la etapa de construccion):

```sh
docker build -t interprete-iot .
docker run --rm interprete-iot
```

Para interpretar un archivo propio, montalo en el contenedor:

```sh
docker run --rm -v "$(pwd)/mi_programa.iot:/app/entrada.iot:ro" interprete-iot /app/entrada.iot
```

## Publicacion

Para publicar la imagen, autentica Docker con una cuenta de Docker Hub y etiqueta la imagen con tu usuario:

```sh
docker login
docker tag interprete-iot TU_USUARIO/interprete-iot:1.0
docker push TU_USUARIO/interprete-iot:1.0
```

Para entregar el codigo en un repositorio privado, crea un repositorio privado en GitHub y configura su URL como remoto antes de subir la rama principal:

```sh
git init
git add .
git commit -m "Implementa interprete IoT con Lex y Yacc"
git branch -M main
git remote add origin URL_DEL_REPOSITORIO_PRIVADO
git push -u origin main
```
