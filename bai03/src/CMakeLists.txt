# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(bai03_library VERSION 0.0.1 LANGUAGES C)

add_library(bai03 SHARED
  "bai03.c"
  "extends.c"
)

set_target_properties(bai03 PROPERTIES
  PUBLIC_HEADER bai03.h
  OUTPUT_NAME "bai03"
)

target_compile_definitions(bai03 PUBLIC DART_SHARED_LIB)
