cmake_minimum_required(VERSION 3.2)
project(ode_solver)

set(CMAKE_CXX_STANDARD 17)

enable_language(Fortran)

add_library(ode_solver
        ${CMAKE_SOURCE_DIR}/f90/src/ode_system.f90
        ${CMAKE_SOURCE_DIR}/f90/src/equations.f90
        ${CMAKE_SOURCE_DIR}/f90/src/euler.f90
        ${CMAKE_SOURCE_DIR}/f90/src/rk.f90
        ${CMAKE_SOURCE_DIR}/f90/src/observer.f90
        ${CMAKE_SOURCE_DIR}/f90/src/lorenz_system.f90
)
set_target_properties(
        ode_solver
        PROPERTIES
        LINKER_LANGUAGE Fortran
)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)

add_executable(
        lorenz
        ${CMAKE_SOURCE_DIR}/f90/mains/ode_solver.f90
)
target_link_libraries(lorenz ode_solver)
