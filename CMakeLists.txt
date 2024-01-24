cmake_minimum_required(VERSION 3.2)
project(ode_solver)

set(CMAKE_CXX_STANDARD 17)

enable_language(Fortran)

add_library(ode_solver
        ${CMAKE_SOURCE_DIR}/f90/src/parameters.f90
        ${CMAKE_SOURCE_DIR}/f90/src/equations.f90
        ${CMAKE_SOURCE_DIR}/f90/src/observer.f90
)
set_target_properties(
        ode_solver
        PROPERTIES
        LINKER_LANGUAGE Fortran
)

add_executable(
        main
        ${CMAKE_SOURCE_DIR}/f90/mains/main.f90
)
target_link_libraries(main ode_solver)
