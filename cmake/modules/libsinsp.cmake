if(NOT HAVE_LIBSINSP)
set(HAVE_LIBSINSP On)

if(NOT LIBSINSP_DIR)
	get_filename_component(LIBSINSP_DIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
endif()

option(USE_BUNDLED_DEPS "Enable bundled dependencies instead of using the system ones" ON)

option(WITH_CHISEL "Include chisel implementation" OFF)

if(DEFINED LIBSINSP_USER_AGENT)
	add_definitions(-DLIBSINSP_USER_AGENT="${LIBSINSP_USER_AGENT}")
endif()

include(ExternalProject)
include(libscap)
if(NOT WIN32 AND NOT EMSCRIPTEN_BUILD)
	include(tbb)
endif()
if(NOT WIN32 AND NOT APPLE AND NOT EMSCRIPTEN_BUILD)
	include(b64)
	include(jq)
endif()
if(NOT WIN32 AND NOT APPLE AND NOT MINIMAL_BUILD)
	include(curl)
endif()
include(jsoncpp)
include(valijson)
include(re2)
if(NOT MINIMAL_BUILD)
	include(cares)
endif()

set(LIBSINSP_INCLUDE_DIRS ${LIBSINSP_DIR}/userspace/libsinsp ${LIBSINSP_DIR}/common ${LIBSCAP_INCLUDE_DIRS} ${DRIVER_CONFIG_DIR})
if(WITH_CHISEL)
	list(APPEND LIBSINSP_INCLUDE_DIRS ${LIBSINSP_DIR}/userspace/chisel)
endif()

if(NOT WIN32 AND NOT EMSCRIPTEN_BUILD)
	get_filename_component(TBB_ABSOLUTE_INCLUDE_DIR ${TBB_INCLUDE_DIR} ABSOLUTE)
	list(APPEND LIBSINSP_INCLUDE_DIRS ${TBB_ABSOLUTE_INCLUDE_DIR})
endif()

get_filename_component(JSONCPP_ABSOLUTE_INCLUDE_DIR ${JSONCPP_INCLUDE} ABSOLUTE)
list(APPEND LIBSINSP_INCLUDE_DIRS ${JSONCPP_ABSOLUTE_INCLUDE_DIR})

get_filename_component(VALIJSON_ABSOLUTE_INCLUDE_DIR ${VALIJSON_INCLUDE} ABSOLUTE)
list(APPEND LIBSINSP_INCLUDE_DIRS ${VALIJSON_ABSOLUTE_INCLUDE_DIR})

get_filename_component(RE2_ABSOLUTE_INCLUDE_DIR ${RE2_INCLUDE} ABSOLUTE)
list(APPEND LIBSINSP_INCLUDE_DIRS ${RE2_ABSOLUTE_INCLUDE_DIR})

if(NOT MINIMAL_BUILD)
	get_filename_component(CARES_ABSOLUTE_INCLUDE_DIR ${CARES_INCLUDE} ABSOLUTE)
	list(APPEND LIBSINSP_INCLUDE_DIRS ${CARES_ABSOLUTE_INCLUDE_DIR})
endif()

if(NOT WIN32 AND NOT APPLE AND NOT EMSCRIPTEN_BUILD)
	get_filename_component(B64_ABSOLUTE_INCLUDE_DIR ${B64_INCLUDE} ABSOLUTE)
	list(APPEND LIBSINSP_INCLUDE_DIRS ${B64_ABSOLUTE_INCLUDE_DIR})
	get_filename_component(JQ_ABSOLUTE_INCLUDE_DIR ${JQ_INCLUDE} ABSOLUTE)
	list(APPEND LIBSINSP_INCLUDE_DIRS ${JQ_ABSOLUTE_INCLUDE_DIR})
endif()

if(NOT WIN32 AND NOT APPLE AND NOT MINIMAL_BUILD)
	get_filename_component(CURL_ABSOLUTE_INCLUDE_DIR ${CURL_INCLUDE_DIRS} ABSOLUTE)
	list(APPEND LIBSINSP_INCLUDE_DIRS ${CURL_ABSOLUTE_INCLUDE_DIR})
endif()

add_subdirectory(${LIBSINSP_DIR}/userspace/libsinsp ${CMAKE_BINARY_DIR}/libsinsp)
set(LIBSINSP_LIB "${PROJECT_BINARY_DIR}/libsinsp/libsinsp.a")
install(FILES "${LIBSINSP_LIB}" DESTINATION "${CMAKE_INSTALL_LIBDIR}/${LIBS_PACKAGE_NAME}"
			COMPONENT "sinsp")
install(DIRECTORY "${LIBSINSP_DIR}/userspace/libsinsp" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBS_PACKAGE_NAME}/userspace"
			COMPONENT "sinsp"
			FILES_MATCHING PATTERN "*.h"
			PATTERN "*third_party*" EXCLUDE
			PATTERN "*examples*" EXCLUDE
			PATTERN "*doxygen*" EXCLUDE
			PATTERN "*scripts*" EXCLUDE
			PATTERN "*test*" EXCLUDE)
install(DIRECTORY "${LIBSINSP_DIR}/common" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBS_PACKAGE_NAME}"
			COMPONENT "sinsp"
			FILES_MATCHING PATTERN "*.h")
install(DIRECTORY "${LIBSINSP_DIR}/userspace/async" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBS_PACKAGE_NAME}/userspace"
			COMPONENT "sinsp"
			FILES_MATCHING PATTERN "*.h")
if(WITH_CHISEL)
	install(DIRECTORY "${LIBSINSP_DIR}/userspace/chisel" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${LIBS_PACKAGE_NAME}/userspace"
			COMPONENT "sinsp"
			FILES_MATCHING PATTERN "*.h")
endif()

endif()
