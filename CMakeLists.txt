CMAKE_MINIMUM_REQUIRED(VERSION 3.2)
PROJECT(ode_solver)

SET(CMAKE_CXX_STANDARD 17)

ENABLE_LANGUAGE(Fortran)

FIND_PACKAGE(netCDF REQUIRED)

SET(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath -Wl,${netCDF_LIB_DIR}")

SET(OUTPUT_DIR CACHE PATH "")
IF (OUTPUT_DIR STREQUAL "")
    SET(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/output)
ENDIF ()
IF (NOT EXISTS ${OUTPUT_DIR})
    FILE(MAKE_DIRECTORY ${OUTPUT_DIR})
ENDIF ()

INCLUDE_DIRECTORIES(${netCDF_INCLUDE_DIR})

set(CMAKE_Fortran_FLAGS "-L${netCDF_LIB_DIR} -lnetcdff")

ADD_LIBRARY(ode_solver
            ${CMAKE_SOURCE_DIR}/src/equations.f90
            ${CMAKE_SOURCE_DIR}/src/integrator.f90
            ${CMAKE_SOURCE_DIR}/src/euler_integrator.f90
            ${CMAKE_SOURCE_DIR}/src/rk_integrator.f90
            ${CMAKE_SOURCE_DIR}/src/observer.f90
            ${CMAKE_SOURCE_DIR}/src/system.f90
            ${CMAKE_SOURCE_DIR}/src/lorenz_system.f90
            ${CMAKE_SOURCE_DIR}/src/solver.f90
            ${CMAKE_SOURCE_DIR}/src/settings.f90
            ${CMAKE_SOURCE_DIR}/src/shallow_water_system.f90
            ${CMAKE_SOURCE_DIR}/src/netcdf_utils.f90
            )
SET_TARGET_PROPERTIES(
        ode_solver
        PROPERTIES
        LINKER_LANGUAGE Fortran
        )

SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)

ADD_EXECUTABLE(
        lorenz
        ${CMAKE_SOURCE_DIR}/src/mains/ode_solver.f90
        )
TARGET_LINK_LIBRARIES(lorenz ode_solver)
ADD_CUSTOM_TARGET(
        configure_namelist
        COMMAND sed -i -e 's|OUTPUT_DIR|'${OUTPUT_DIR}'|g' ${CMAKE_SOURCE_DIR}/ode_solver.cfg
        )
ADD_CUSTOM_TARGET(
        restore_namelist
        COMMAND sed -i -e 's|'${OUTPUT_DIR}'|OUTPUT_DIR|g' ${CMAKE_SOURCE_DIR}/ode_solver.cfg
        )

