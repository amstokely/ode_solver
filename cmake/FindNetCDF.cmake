# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Try to find NetCDF includes and library, only shared libraries are supported!
#
# This module defines
#
#   - NetCDF_FOUND                - System has NetCDF
#   - NetCDF_INCLUDE_DIRS         - the NetCDF include directories
#   - NetCDF_LIBRARIES            - the libraries needed to use NetCDF
#   - NetCDF_VERSION              - the version of NetCDF
#
# Following components are available:
#
#   - C                           - C interface to NetCDF          (netcdf)
#   - CXX                         - CXX4 interface to NetCDF       (netcdf_c++4)
#   - Fortran                     - Fortran interface to NetCDF    (netcdff)
#   - CXX_LEGACY                  - Legacy C++ interface to NetCDF (netcdf_c++)
#
# For each component the following are defined:
#
#   - NetCDF_<comp>_FOUND         - whether the component is found
#   - NetCDF_<comp>_LIBRARIES     - the libraries for the component
#   - NetCDF_<comp>_INCLUDE_DIRS  - the include directories for specfied component
#   - NetCDF::NetCDF_<comp>       - target of component to be used with target_link_libraries()
#
# The following paths will be searched in order if set in CMake (first priority) or environment (second priority)
#
#   - NETCDF_ROOT                 - root of NetCDF installation
#   - NETCDF_DIR                  - root of NetCDF installation
#   - NETCDF_PATH                 - root of NetCDF installation
#   - NETCDF4_DIR                 - root of NetCDF installation
#   - NetCDF_ROOT                 - root of NetCDF installation
#   - NetCDF_DIR                  - root of NetCDF installation
#   - NetCDF_PATH                 - root of NetCDF installation
#   - NetCDF4_DIR                 - root of NetCDF installation
#
# Notes:
#
#   - Each variable is also available in fully uppercased version
#   - In each variable (not in targets), the "NetCDF" prefix may be interchanged with
#        * NetCDF4
#        * NETCDF
#        * NETCDF4
#        * The part "<xxx>" in current filename Find<xxx>.cmake
#   - Capitalisation of COMPONENT arguments does not matter: The <comp> part of variables will be defined with
#        * capitalisation as defined above
#        * Uppercase capitalisation
#        * capitalisation as used in find_package() arguments
#   - If no components are defined, all components will be searched without guarantee that the required component is available.
#

LIST(APPEND _possible_components C CXX Fortran CXX_LEGACY)

## Library names for each component
SET(NetCDF_C_LIBRARY_NAME netcdf)
SET(NetCDF_CXX_LIBRARY_NAME netcdf_c++4)
SET(NetCDF_CXX_LEGACY_LIBRARY_NAME netcdf_c++)
SET(NetCDF_Fortran_LIBRARY_NAME netcdff)

FOREACH (_comp ${_possible_components})
    STRING(TOUPPER "${_comp}" _COMP)
    SET(_arg_${_COMP} ${_comp})
    SET(_name_${_COMP} ${_comp})
ENDFOREACH ()

UNSET(_search_components)
FOREACH (_comp ${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS})
    STRING(TOUPPER "${_comp}" _COMP)
    SET(_arg_${_COMP} ${_comp})
    LIST(APPEND _search_components ${_name_${_COMP}})
    IF (NOT _name_${_COMP})
        ECBUILD_ERROR("Find${CMAKE_FIND_PACKAGE_NAME}: COMPONENT ${_comp} is not a valid component. Valid components: ${_possible_components}")
    ENDIF ()
ENDFOREACH ()
IF (NOT _search_components)
    SET(_search_components C)
ENDIF ()

## Search hints for finding include directories and libraries
SET(_search_hints
    ${NETCDF_ROOT} ${NETCDF_DIR} ${NETCDF_PATH} ${NETCDF4_DIR}
    ${NetCDF_ROOT} ${NetCDF_DIR} ${NetCDF_PATH} ${NetCDF4_DIR}
    ENV NETCDF_ROOT ENV NETCDF_DIR ENV NETCDF_PATH ENV NETCDF4_DIR
    ENV NetCDF_ROOT ENV NetCDF_DIR ENV NetCDF_PATH ENV NetCDF4_DIR
    )

## Find include directories
FIND_PATH(NetCDF_INCLUDE_DIRS
          NAMES netcdf.h
          DOC "netcdf include directories"
          HINTS ${_search_hints}
          PATH_SUFFIXES include ../../include
          )
MARK_AS_ADVANCED(NetCDF_INCLUDE_DIRS)

## Find libraries for each component
FOREACH (_comp ${_search_components})
    STRING(TOUPPER "${_comp}" _COMP)

    FIND_LIBRARY(NetCDF_${_comp}_LIBRARY
                 NAMES ${NetCDF_${_comp}_LIBRARY_NAME}
                 DOC "netcdf ${_comp} library"
                 HINTS ${_search_hints}
                 PATH_SUFFIXES lib ../../lib
                 )
    MARK_AS_ADVANCED(NetCDF_${_comp}_LIBRARY)
    IF (NetCDF_${_comp}_LIBRARY AND NOT (NetCDF_${_comp}_LIBRARY MATCHES ".a$"))
        SET(NetCDF_${_comp}_LIBRARY_SHARED TRUE)
    ENDIF ()
    IF (NetCDF_${_comp}_LIBRARY_SHARED AND NetCDF_INCLUDE_DIRS)
        SET(${CMAKE_FIND_PACKAGE_NAME}_${_arg_${_COMP}}_FOUND TRUE)
        LIST(APPEND NetCDF_LIBRARIES ${NetCDF_${_comp}_LIBRARY})
        LIST(APPEND NetCDF_${_comp}_LIBRARIES ${NetCDF_${_comp}_LIBRARY})

        IF (NOT TARGET NetCDF::NetCDF_${_comp})
            ADD_LIBRARY(NetCDF::NetCDF_${_comp} UNKNOWN IMPORTED)
            SET_TARGET_PROPERTIES(NetCDF::NetCDF_${_comp} PROPERTIES
                                  IMPORTED_LOCATION "${NetCDF_${_comp}_LIBRARY}"
                                  INTERFACE_INCLUDE_DIRECTORIES "${NetCDF_INCLUDE_DIRS}")
        ENDIF ()
    ENDIF ()
ENDFOREACH ()

## Find version
IF (NetCDF_INCLUDE_DIRS)
    FIND_PROGRAM(NETCDF_CONFIG_EXECUTABLE
                 NAMES nc-config
                 HINTS ${_search_hints}
                 PATH_SUFFIXES bin Bin ../../bin
                 DOC "NetCDF nc-config helper")
    MARK_AS_ADVANCED(NETCDF_CONFIG_EXECUTABLE)

    IF (NETCDF_CONFIG_EXECUTABLE)
        EXECUTE_PROCESS(COMMAND ${NETCDF_CONFIG_EXECUTABLE} --version
                        RESULT_VARIABLE _netcdf_config_result
                        OUTPUT_VARIABLE _netcdf_config_version)

        IF (_netcdf_config_result EQUAL 0)
            STRING(REGEX REPLACE ".* ((([0-9]+)\\.)+([0-9]+)).*" "\\1" NetCDF_VERSION "${_netcdf_config_version}")
        ENDIF ()

    ELSEIF (EXISTS "${NetCDF_INCLUDE_DIRS}/netcdf_meta.h")

        FILE(STRINGS "${NetCDF_INCLUDE_DIRS}/netcdf_meta.h" _netcdf_version_lines
             REGEX "#define[ \t]+NC_VERSION_(MAJOR|MINOR|PATCH|NOTE)")
        STRING(REGEX REPLACE ".*NC_VERSION_MAJOR *\([0-9]*\).*" "\\1" _netcdf_version_major "${_netcdf_version_lines}")
        STRING(REGEX REPLACE ".*NC_VERSION_MINOR *\([0-9]*\).*" "\\1" _netcdf_version_minor "${_netcdf_version_lines}")
        STRING(REGEX REPLACE ".*NC_VERSION_PATCH *\([0-9]*\).*" "\\1" _netcdf_version_patch "${_netcdf_version_lines}")
        STRING(REGEX REPLACE ".*NC_VERSION_NOTE *\"\([^\"]*\)\".*" "\\1" _netcdf_version_note "${_netcdf_version_lines}")
        SET(NetCDF_VERSION "${_netcdf_version_major}.${_netcdf_version_minor}.${_netcdf_version_patch}${_netcdf_version_note}")
        UNSET(_netcdf_version_major)
        UNSET(_netcdf_version_minor)
        UNSET(_netcdf_version_patch)
        UNSET(_netcdf_version_note)
        UNSET(_netcdf_version_lines)
    ENDIF ()
ENDIF ()

## Finalize find_package
INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(${CMAKE_FIND_PACKAGE_NAME}
                                  REQUIRED_VARS NetCDF_INCLUDE_DIRS NetCDF_LIBRARIES
                                  VERSION_VAR NetCDF_VERSION
                                  HANDLE_COMPONENTS)

IF (${CMAKE_FIND_PACKAGE_NAME}_FOUND AND NOT ${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
    MESSAGE(STATUS "Find${CMAKE_FIND_PACKAGE_NAME} defines targets:")
    FOREACH (_comp ${_search_components})
        STRING(TOUPPER "${_comp}" _COMP)

        IF (${CMAKE_FIND_PACKAGE_NAME}_${_arg_${_COMP}}_FOUND)
            MESSAGE(STATUS "  - NetCDF::NetCDF_${_comp} [${NetCDF_${_comp}_LIBRARY}]")
        ENDIF ()
    ENDFOREACH ()
ENDIF ()

FOREACH (_prefix NetCDF NetCDF4 NETCDF NETCDF4 ${CMAKE_FIND_PACKAGE_NAME})
    SET(${_prefix}_INCLUDE_DIRS ${NetCDF_INCLUDE_DIRS})
    SET(${_prefix}_LIBRARIES ${NetCDF_LIBRARIES})
    SET(${_prefix}_VERSION ${NetCDF_VERSION})
    SET(${_prefix}_FOUND ${${CMAKE_FIND_PACKAGE_NAME}_FOUND})

    FOREACH (_comp ${_search_components})
        STRING(TOUPPER "${_comp}" _COMP)
        SET(_arg_comp ${_arg_${_COMP}})
        SET(${_prefix}_${_comp}_FOUND ${${CMAKE_FIND_PACKAGE_NAME}_${_arg_comp}_FOUND})
        SET(${_prefix}_${_COMP}_FOUND ${${CMAKE_FIND_PACKAGE_NAME}_${_arg_comp}_FOUND})
        SET(${_prefix}_${_arg_comp}_FOUND ${${CMAKE_FIND_PACKAGE_NAME}_${_arg_comp}_FOUND})

        SET(${_prefix}_${_comp}_LIBRARIES ${NetCDF_${_comp}_LIBRARIES})
        SET(${_prefix}_${_COMP}_LIBRARIES ${NetCDF_${_comp}_LIBRARIES})
        SET(${_prefix}_${_arg_comp}_LIBRARIES ${NetCDF_${_comp}_LIBRARIES})

        SET(${_prefix}_${_comp}_INCLUDE_DIRS ${NetCDF_INCLUDE_DIRS})
        SET(${_prefix}_${_COMP}_INCLUDE_DIRS ${NetCDF_INCLUDE_DIRS})
        SET(${_prefix}_${_arg_comp}_INCLUDE_DIRS ${NetCDF_INCLUDE_DIRS})
    ENDFOREACH ()
ENDFOREACH ()