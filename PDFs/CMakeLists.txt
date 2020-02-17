cmake_minimum_required (VERSION 2.6)
# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()

if (NOT DEFINED CMAKE_MACOSX_RPATH)
   set(CMAKE_MACOSX_RPATH 0)
endif()

# the project name
project(NNAD_INTERFACE)

# activating some global properties for the project
set(NNAD_INTERFACE_VERSION 1.0.0)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(PkgConfig REQUIRED)
pkg_search_module(YAML REQUIRED yaml-cpp)
pkg_search_module(EIGEN3 REQUIRED eigen3)
pkg_search_module(CERES REQUIRED ceres-solver)
pkg_search_module(GLOG REQUIRED libglog)
pkg_search_module(GFLAGS REQUIRED gflags)
pkg_search_module(SQLITE3 REQUIRED sqlite3)
pkg_search_module(GSL REQUIRED gsl)

# LHAPDF
find_program(LHAPDF_CONFIG lhapdf-config REQUIRED)
if (LHAPDF_CONFIG)
  exec_program(${LHAPDF_CONFIG}
    ARGS --cflags
    OUTPUT_VARIABLE LHAPDF_CXX_FLAGS
  )
  set(LHAPDF_CXX_FLAGS ${LHAPDF_CXX_FLAGS} CACHE STRING INTERNAL)
  exec_program(${LHAPDF_CONFIG}
    ARGS --libs
    OUTPUT_VARIABLE LHAPDF_LIBRARIES
  )
  set(LHAPDF_LIBRARIES ${LHAPDF_LIBRARIES} CACHE STRING INTERNAL)
  #This is to stop the LHAPDF specific warnings from spamming the output
  exec_program(${LHAPDF_CONFIG}
    ARGS --incdir
    OUTPUT_VARIABLE LHAPDF_INCLUDES
  )
  set(LHAPDF_INCLUDES ${LHAPDF_INCLUDES} CACHE STRING INTERNAL)
  include_directories(SYSTEM ${LHAPDF_INCLUDES})
endif(LHAPDF_CONFIG)

find_program(NNAD_CONFIG nnad-config REQUIRED)
if (NNAD_CONFIG)
  exec_program(${NNAD_CONFIG}
    ARGS --cflags
    OUTPUT_VARIABLE NNAD_CFLAGS
  )
endif(NNAD_CONFIG)

include_directories(${PROJECT_SOURCE_DIR}/inc)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${NNAD_CFLAGS} ${YAML_CFLAGS} ${EIGEN3_CFLAGS} ${CERES_CFLAGS} ${GLOG_CFLAGS} ${GFLAGS_CFLAGS} ${SQLITE3_CFLAGS} ${GSL_CFLAGS} -fsanitize=address ${DEFAULT_CXX_OPTIONS} ${LHAPDF_CXX_FLAGS} -I/usr/local/include -Wall -fPIC")

# build target library
add_subdirectory(src)
add_subdirectory(run)
