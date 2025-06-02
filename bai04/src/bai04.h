#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT int32_t** get_sort_steps(int32_t* array, int32_t length, int32_t* step_count) {
    int32_t** steps = malloc(sizeof(int32_t*) * length);
    *step_count = 0;

    int32_t* arr = malloc(sizeof(int32_t) * length);
    memcpy(arr, array, sizeof(int32_t) * length);

    for (int i = 0; i < length - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < length; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        if (minIdx != i) {
            int temp = arr[i];
            arr[i] = arr[minIdx];
            arr[minIdx] = temp;
        }

        // Lưu snapshot
        steps[*step_count] = malloc(sizeof(int32_t) * length);
        memcpy(steps[*step_count], arr, sizeof(int32_t) * length);
        (*step_count)++;
    }

    // Snapshot cuối (mảng đã sắp xếp)
    steps[*step_count] = malloc(sizeof(int32_t) * length);
    memcpy(steps[*step_count], arr, sizeof(int32_t) * length);
    (*step_count)++;

    free(arr);
    return steps;
}

FFI_PLUGIN_EXPORT void free_steps(int32_t** steps, int32_t step_count) {
    for (int i = 0; i < step_count; i++) {
        free(steps[i]);
    }
    free(steps);
}
