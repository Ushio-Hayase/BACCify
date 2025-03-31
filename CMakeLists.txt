cmake_minimum_required(VERSION 3.20)
project(BAClass)

set(CMAKE_CXX_STANDARD 20)
set(OUTPUT_DIR ${CMAKE_CURRENT_LIST_DIR}/build)

add_subdirectory(src)

set_target_properties(BAClass PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR})
