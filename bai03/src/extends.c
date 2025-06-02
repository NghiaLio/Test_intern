#include "extends.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// FFI_PLUGIN_EXPORT int sum(int a, int b) { return a + b; }
FFI_PLUGIN_EXPORT int multiply(int a, int b) { return a * b; }


// Define FFI_PLUGIN_EXPORT for different platforms
#ifdef WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

/// Mảng global flatten: allSolutions_flatten[i * N + j]
static Position* allSolutions_flatten = NULL;
static int solutionCount = 0;
static int X[N + 1];
static bool colUsed[N + 1], diag1[2 * N], diag2[2 * N];
static void solve(int i) {
    if (i == N + 1) {
        if (solutionCount >= MAX_SOLUTIONS) return;
        // Lưu nghiệm thứ solutionCount vào vị trí (solutionCount * N) … (solutionCount * N + N-1)
        for (int k = 1; k <= N; k++) {
            allSolutions_flatten[solutionCount * N + (k - 1)].row = k;
            allSolutions_flatten[solutionCount * N + (k - 1)].col = X[k];
        }
        solutionCount++;
        return;
    }
    for (int j = 1; j <= N; j++) {
        int d1 = i - j + N;   // k1
        int d2 = i + j - 2;   // k2
        if (!colUsed[j] && !diag1[d1] && !diag2[d2]) {
            X[i] = j;
            colUsed[j] = diag1[d1] = diag2[d2] = true;
            solve(i + 1);
            colUsed[j] = diag1[d1] = diag2[d2] = false;
        }
    }
}
FFI_PLUGIN_EXPORT Position* get_solutions(int* out_count) {
    // Nếu chưa allocate thì cấp phát size = MAX_SOLUTIONS * N
    if (allSolutions_flatten == NULL) {
        allSolutions_flatten = (Position*)malloc(sizeof(Position) * MAX_SOLUTIONS * N);
    }
    solutionCount = 0;
    // Khởi các mảng đánh dấu
    for (int j = 1; j <= N; j++) colUsed[j] = false;
    for (int t = 0; t < 2 * N; t++) {
        diag1[t] = false;
        diag2[t] = false;
    }
    // Chạy giải
    solve(1);
    // Trả về con trỏ + số nghiệm
    *out_count = solutionCount;
    return allSolutions_flatten;
}






