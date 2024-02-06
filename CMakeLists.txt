CMAKE_MINIMUM_REQUIRED(VERSION 3.2)
PROJECT(ode_solver)

SET(CMAKE_CXX_STANDARD 17)

ENABLE_LANGUAGE(Fortran)

SET(OUTPUT_DIR CACHE PATH "")
IF (OUTPUT_DIR STREQUAL "")
    SET(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/output)
ENDIF ()
IF (NOT EXISTS ${OUTPUT_DIR})
    FILE(MAKE_DIRECTORY ${OUTPUT_DIR})
ENDIF ()

INCLUDE_DIRECTORIES(
        /home/astokely/ne-fortran/include
        )

FILE(GLOB_RECURSE netcdff_libs
     /home/astokely/ne-fortran/lib64/*.so
     )

ADD_LIBRARY(ode_solver
            ${CMAKE_SOURCE_DIR}/f90/src/equations.f90
            ${CMAKE_SOURCE_DIR}/f90/src/integrator.f90
            ${CMAKE_SOURCE_DIR}/f90/src/observer.f90
            ${CMAKE_SOURCE_DIR}/f90/src/system.f90
            ${CMAKE_SOURCE_DIR}/f90/src/lorenz_system.f90
            ${CMAKE_SOURCE_DIR}/f90/src/solver.f90
            ${CMAKE_SOURCE_DIR}/f90/src/settings.f90
            ${CMAKE_SOURCE_DIR}/f90/src/shallow_water_system.f90
            )
TARGET_LINK_LIBRARIES(ode_solver ${netcdff_libs})
SET_TARGET_PROPERTIES(
        ode_solver
        PROPERTIES
        LINKER_LANGUAGE Fortran
        )

SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)

ADD_EXECUTABLE(
        lorenz
        ${CMAKE_SOURCE_DIR}/f90/mains/ode_solver.f90
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
