# Install script for directory: D:/miniproject/80%/Mentora/mentora/windows

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "$<TARGET_FILE_DIR:mentora>")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/flutter/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/desktop_drop/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/file_selector_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/flutter_secure_storage_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/printing/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/share_plus/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/syncfusion_pdfviewer_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/url_launcher_windows/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/window_size/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/mentora.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug" TYPE EXECUTABLE FILES "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/mentora.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/mentora.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile" TYPE EXECUTABLE FILES "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/mentora.exe")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/mentora.exe")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release" TYPE EXECUTABLE FILES "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/mentora.exe")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/data" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/icudtl.dat")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/icudtl.dat")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data/icudtl.dat")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/icudtl.dat")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/flutter_windows.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/flutter_windows.dll")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/flutter_windows.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/flutter_windows.dll")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/desktop_drop_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/file_selector_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/flutter_secure_storage_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/printing_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/pdfium.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/share_plus_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/syncfusion_pdfviewer_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/pdfium.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/url_launcher_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/window_size_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug" TYPE FILE FILES
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/desktop_drop/Debug/desktop_drop_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/file_selector_windows/Debug/file_selector_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/flutter_secure_storage_windows/Debug/flutter_secure_storage_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/printing/Debug/printing_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/.plugin_symlinks/syncfusion_pdfviewer_windows/windows/include/pdfium/x64/bin/pdfium.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/share_plus/Debug/share_plus_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/syncfusion_pdfviewer_windows/Debug/syncfusion_pdfviewer_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/.plugin_symlinks/syncfusion_pdfviewer_windows/windows/include/pdfium/x64/bin/pdfium.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/url_launcher_windows/Debug/url_launcher_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/window_size/Debug/window_size_plugin.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/desktop_drop_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/file_selector_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/flutter_secure_storage_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/printing_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/pdfium.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/share_plus_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/syncfusion_pdfviewer_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/pdfium.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/url_launcher_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/window_size_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile" TYPE FILE FILES
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/desktop_drop/Profile/desktop_drop_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/file_selector_windows/Profile/file_selector_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/flutter_secure_storage_windows/Profile/flutter_secure_storage_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/printing/Profile/printing_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/.plugin_symlinks/syncfusion_pdfviewer_windows/windows/include/pdfium/x64/bin/pdfium.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/share_plus/Profile/share_plus_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/syncfusion_pdfviewer_windows/Profile/syncfusion_pdfviewer_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/.plugin_symlinks/syncfusion_pdfviewer_windows/windows/include/pdfium/x64/bin/pdfium.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/url_launcher_windows/Profile/url_launcher_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/window_size/Profile/window_size_plugin.dll"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/desktop_drop_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/file_selector_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/flutter_secure_storage_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/printing_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/pdfium.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/share_plus_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/syncfusion_pdfviewer_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/pdfium.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/url_launcher_windows_plugin.dll;D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/window_size_plugin.dll")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release" TYPE FILE FILES
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/desktop_drop/Release/desktop_drop_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/file_selector_windows/Release/file_selector_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/flutter_secure_storage_windows/Release/flutter_secure_storage_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/printing/Release/printing_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/.plugin_symlinks/syncfusion_pdfviewer_windows/windows/include/pdfium/x64/bin/pdfium.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/share_plus/Release/share_plus_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/syncfusion_pdfviewer_windows/Release/syncfusion_pdfviewer_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/windows/flutter/ephemeral/.plugin_symlinks/syncfusion_pdfviewer_windows/windows/include/pdfium/x64/bin/pdfium.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/url_launcher_windows/Release/url_launcher_windows_plugin.dll"
      "D:/miniproject/80%/Mentora/mentora/build/windows/x64/plugins/window_size/Release/window_size_plugin.dll"
      )
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug" TYPE DIRECTORY FILES "D:/miniproject/80%/Mentora/mentora/build/native_assets/windows/")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile" TYPE DIRECTORY FILES "D:/miniproject/80%/Mentora/mentora/build/native_assets/windows/")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release" TYPE DIRECTORY FILES "D:/miniproject/80%/Mentora/mentora/build/native_assets/windows/")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    
  file(REMOVE_RECURSE "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/data/flutter_assets")
  
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    
  file(REMOVE_RECURSE "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data/flutter_assets")
  
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    
  file(REMOVE_RECURSE "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data/flutter_assets")
  
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Debug/data" TYPE DIRECTORY FILES "D:/miniproject/80%/Mentora/mentora/build//flutter_assets")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data" TYPE DIRECTORY FILES "D:/miniproject/80%/Mentora/mentora/build//flutter_assets")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data/flutter_assets")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data" TYPE DIRECTORY FILES "D:/miniproject/80%/Mentora/mentora/build//flutter_assets")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Pp][Rr][Oo][Ff][Ii][Ll][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Profile/data" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/build/windows/app.so")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
     "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data/app.so")
    if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
      message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
    endif()
    file(INSTALL DESTINATION "D:/miniproject/80%/Mentora/mentora/build/windows/x64/runner/Release/data" TYPE FILE FILES "D:/miniproject/80%/Mentora/mentora/build/windows/app.so")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
  file(WRITE "D:/miniproject/80%/Mentora/mentora/build/windows/x64/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
