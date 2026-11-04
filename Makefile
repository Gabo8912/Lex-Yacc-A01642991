CC = gcc
CFLAGS = -std=c11 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -Wpedantic -O2 -I.
BUILD_DIR = build
TARGET = interprete

.PHONY: all clean test

all: $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/parser.c $(BUILD_DIR)/parser.h &: parser.y | $(BUILD_DIR)
	bison -d -o $(BUILD_DIR)/parser.c parser.y

$(BUILD_DIR)/lexer.c: lexer.l $(BUILD_DIR)/parser.h | $(BUILD_DIR)
	flex -o $@ lexer.l

$(TARGET): main.c runtime.c runtime.h $(BUILD_DIR)/parser.c $(BUILD_DIR)/lexer.c
	$(CC) $(CFLAGS) -o $@ main.c runtime.c $(BUILD_DIR)/parser.c $(BUILD_DIR)/lexer.c -lfl

test: $(TARGET)
	sh tests/smoke.sh

clean:
	rm -rf $(BUILD_DIR) $(TARGET)
