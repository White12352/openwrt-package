if(WOLFSSL_PREFER_STATIC_LIB)
    set(WOLFSSL_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(WIN32)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a .lib ${CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()
endif()

if(UNIX)
    find_package(PkgConfig QUIET)
    pkg_check_modules(_WOLFSSL QUIET wolfssl)
endif()

find_path(WOLFSSL_INCLUDE_DIR NAMES wolfssl/version.h HINTS ${_WOLFSSL_INCLUDEDIR})
find_library(WOLFSSL_LIBRARY NAMES wolfssl HINTS ${_WOLFSSL_LIBDIR})
if(WOLFSSL_INCLUDE_DIR AND WOLFSSL_LIBRARY)
    set(WOLFSSL_INCLUDE_DIR ${WOLFSSL_INCLUDE_DIR})
    set(WOLFSSL_LIBRARY ${WOLFSSL_LIBRARY})
    set(WOLFSSL_VERSION ${_WOLFSSL_VERSION})
    set(WOLFSSL_IS_WOLFSSL ON)
else()
    if(UNIX)
        pkg_check_modules(_WOLFSSL QUIET WOLFSSL)
    endif()

    find_path(WOLFSSL_INCLUDE_DIR NAMES WOLFSSL/version.h HINTS ${_WOLFSSL_INCLUDEDIR})
    find_library(WOLFSSL_LIBRARY NAMES WOLFSSL HINTS ${_WOLFSSL_LIBDIR})
    set(WOLFSSL_VERSION ${_WOLFSSL_VERSION})
    set(WOLFSSL_IS_WOLFSSL OFF)
endif()

if(NOT WOLFSSL_VERSION AND WOLFSSL_INCLUDE_DIR)
    if(WOLFSSL_IS_WOLFSSL)
        file(STRINGS "${WOLFSSL_INCLUDE_DIR}/wolfssl/version.h" WOLFSSL_VERSION_STR REGEX "^#define[\t ]+LIBWOLFSSL_VERSION_STRING[\t ]+\"[^\"]+\"")
    else()
        file(STRINGS "${WOLFSSL_INCLUDE_DIR}/WOLFSSL/version.h" WOLFSSL_VERSION_STR REGEX "^#define[\t ]+LIBWOLFSSL_VERSION_STRING[\t ]+\"[^\"]+\"")
    endif()
    if(WOLFSSL_VERSION_STR MATCHES "\"([^\"]+)\"")
        set(WOLFSSL_VERSION "${CMAKE_MATCH_1}")
    endif()
endif()

set(WOLFSSL_INCLUDE_DIRS ${WOLFSSL_INCLUDE_DIR})
set(WOLFSSL_LIBRARIES ${WOLFSSL_LIBRARY})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(WolfSSL
    REQUIRED_VARS
        WOLFSSL_LIBRARY
        WOLFSSL_INCLUDE_DIR
    VERSION_VAR
        WOLFSSL_VERSION
)

mark_as_advanced(WOLFSSL_INCLUDE_DIR WOLFSSL_LIBRARY WOLFSSL_INCLUDE_DIR WOLFSSL_LIBRARY)

if(WOLFSSL_PREFER_STATIC_LIB)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${WOLFSSL_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
    unset(WOLFSSL_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES)
endif()