CMAKE_MINIMUM_REQUIRED(VERSION 3.2)
PROJECT(ode_solver)

SET(CMAKE_CXX_STANDARD 17)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

SET(NetCDF_Fortran_LIBRARIES CACHE PATH "")
SET(NetCDF_Fortran_INCLUDE_DIR CACHE PATH "")

ENABLE_LANGUAGE(Fortran)
message(STATUS ${NetCDF_Fortran_LIBRARIES})
if(NetCDF_Fortran_LIBRARIES STREQUAL "")
    FIND_PACKAGE(NetCDF REQUIRED COMPONENTS Fortran)
endif()


INCLUDE_DIRECTORIES(${NetCDF_Fortran_INCLUDE_DIR})

SET(OUTPUT_DIR CACHE PATH "")
IF (OUTPUT_DIR STREQUAL "")
    SET(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/output)
ENDIF ()
IF (NOT EXISTS ${OUTPUT_DIR})
    FILE(MAKE_DIRECTORY ${OUTPUT_DIR})
ENDIF ()

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
TARGET_LINK_LIBRARIES(ode_solver ${NetCDF_Fortran_LIBRARIES})
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

