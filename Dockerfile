FROM debian:bookworm-slim AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends bison flex gcc make libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .
RUN make clean all && make test

FROM debian:bookworm-slim

WORKDIR /app
COPY --from=build /src/interprete ./interprete
COPY examples ./examples

ENTRYPOINT ["./interprete"]
CMD ["examples/casa_inteligente.iot"]
