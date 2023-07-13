cmake_minimum_required(VERSION 3.25)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_OSX_ARCHITECTURES x86_64)

# JNI env vars, requires JAVA_HOME be set
set(JAVA_INCLUDE_PATH "$ENV{JAVA_HOME}/include")
set(JAVA_INCLUDE_PATH2 "$ENV{JAVA_HOME}/include/darwin")
set(JAVA_AWT_INCLUDE_PATH "$ENV{JAVA_HOME}/include")
set(JAVA_AWT_INCLUDE_PATH "$ENV{JAVA_HOME}/include")

project(chromeobserver)

# enable ARC
set_property (GLOBAL APPEND_STRING PROPERTY COMPILE_FLAGS "-fobjc-arc")

# specify where the headers are
include_directories(${CMAKE_SOURCE_DIR}/include)

# specify where the Objective-C++ source files are
file(GLOB_RECURSE SOURCES "src/*.m" "src/*.mm" "src/*.cpp")

# specify where the JNI headers are
find_package(JNI REQUIRED)
include_directories(${JNI_INCLUDE_DIRS} )

# specify the output library
add_library(${PROJECT_NAME} SHARED ${SOURCES} src/ApplicationObserver.m include/ApplicationObserverWrapper.h src/ApplicationObserverWrapper.mm)

# specify linking flags
target_link_libraries(${PROJECT_NAME} "-framework Cocoa" "-framework AppKit" "-framework JavaNativeFoundation")

# specify where to install the dylib
install(TARGETS ${PROJECT_NAME} LIBRARY DESTINATION ${CMAKE_SOURCE_DIR}/lib)