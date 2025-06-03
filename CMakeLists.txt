cmake_minimum_required(VERSION 3.16)
project(lunaos VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable Qt meta build system features
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find required Qt modules
find_package(Qt5 REQUIRED COMPONENTS Core Gui Quick Qml)

# List lunaos source files
set(SOURCES
    main.cpp
    linux_authenticator.cpp
    linux_authenticator.h
    system/viewmanager/ViewManager.cpp
    system/viewmanager/ViewManager.h
    system/desktop/systemactions.cpp
    system/desktop/systemactions.h
    audio/audio.qrc
    resources.qrc
    system/context-menu/contextmenu.qrc
    system/powermenu/powermenu.qrc
    apps/terminal/terminal.qrc
    apps/terminal/TerminalBackend.cpp
    apps/terminal/TerminalBackend.h
    apps/filemanager/filemanager.qrc
    apps/filemanager/FileManagerBackend.cpp
    apps/filemanager/FileManagerBackend.h
    apps/texteditor/texteditor.qrc
    apps/texteditor/TextEditorBackend.cpp
    apps/texteditor/TextEditorBackend.h
    apps/browser/browser.qrc
    system/applications/SystemApplications.cpp
    system/applications/SystemApplications.h
    system/applications/systemwindow.qrc
)

# Add the main executable
add_executable(lunaos ${SOURCES})

# Link against Qt libraries and terminal component and PAM
target_link_libraries(lunaos
    Qt5::Core
    Qt5::Gui
    Qt5::Quick
    Qt5::Qml
    pam
)

# Optional: ensure install path is defined
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/usr" CACHE PATH "Install path prefix" FORCE)
endif()

# Install the binary
install(TARGETS lunaos DESTINATION bin)
