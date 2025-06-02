# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(bai04_library VERSION 0.0.1 LANGUAGES C)

add_library(bai04 SHARED
  "bai04.c"
)

set_target_properties(bai04 PROPERTIES
  PUBLIC_HEADER bai04.h
  OUTPUT_NAME "bai04"
)

target_compile_definitions(bai04 PUBLIC DART_SHARED_LIB)
