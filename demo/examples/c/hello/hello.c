#include <stdio.h>

int main(int argc, char** argv) {
    const char* name = (argc > 1) ? argv[1] : "WasmEdge";
    printf("Hello, %s! 🚀 Running in WasmEdge (WASI).\n", name);
    return 0;
}
