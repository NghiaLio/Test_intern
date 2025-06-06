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

FFI_PLUGIN_EXPORT int32_t** get_sort_steps(int32_t* array, int32_t length, int32_t* step_count) ;

FFI_PLUGIN_EXPORT void free_steps(int32_t** steps, int32_t step_count) ;
