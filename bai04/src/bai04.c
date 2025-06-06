#include "bai04.h"

// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
FFI_PLUGIN_EXPORT int32_t** get_sort_steps(int32_t* array, int32_t length, int32_t* step_count){
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
};

// A longer-lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
FFI_PLUGIN_EXPORT void free_steps(int32_t** steps, int32_t step_count){
    for (int i = 0; i < step_count; i++) {
        free(steps[i]);
    }
    free(steps);
};
