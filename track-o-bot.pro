TARGET = Track-o-Bot
VERSION = 0.2.2

CONFIG += qt precompile_header debug_and_release
QT += network

DESTDIR = build
OBJECTS_DIR = tmp
MOC_DIR = tmp
RCC_DIR = tmp
UI_DIR = tmp

PRECOMPILED_HEADER = src/local.h
HEADERS = src/local.h \
          src/window.h \
          src/core.h \
          src/logger.h \
          src/tracker.h \
          src/hearthstone_log_watcher.h \
          src/hearthstone_log_analyzer.h \
          src/scenes/ingame_scene.h

SOURCES = src/main.cpp \
          src/hearthstone.cpp \
          src/dhash.cpp \
          src/phash.cpp \
          src/scene_manager.cpp \
          src/tracker.cpp \
          src/window.cpp \
          src/core.cpp \
          src/logger.cpp \
          src/json.cpp \
          src/autostart.cpp \
          src/hearthstone_log_watcher.cpp \
          src/hearthstone_log_analyzer.cpp

FORMS   = src/window.ui \
          src/settings_widget.ui \
          src/log_widget.ui \
          src/about_widget.ui

DEFINES += VERSION=\\\"$$VERSION\\\"

RESOURCES += app.qrc
RESOURCES += markers.qrc

CONFIG(debug, debug|release): DEFINES += _DEBUG

mac {
  DEFINES += PLATFORM=\\\"mac\\\"

  HEADERS += src/osx_window_capture.h
  SOURCES += src/osx_window_capture.cpp

  LIBS += -framework ApplicationServices -framework Sparkle -framework AppKit

  OBJECTIVE_SOURCES += \
    src/sparkle_updater.mm \
    src/cocoa_initializer.mm

  ICON = icons/logo.icns

  QMAKE_INFO_PLIST = Info.plist.app

  QMAKE_POST_LINK += /usr/libexec/PlistBuddy -c \"Set :CFBundleShortVersionString $${VERSION}\" $${DESTDIR}/$${TARGET}.app/Contents/Info.plist;
  QMAKE_POST_LINK += /usr/libexec/PlistBuddy -c \"Set :CFBundleVersion $${VERSION}\" $${DESTDIR}/$${TARGET}.app/Contents/Info.plist;
}

win32 {
  CONFIG += embed_manifest_exe

  DEFINES += PLATFORM=\\\"win32\\\"

  INCLUDEPATH += . \
                 ../WinSparkle/include

  SOURCES += src/win_window_capture.cpp \
             src/win_sparkle_updater.cpp

  DEFINES += _CRT_SECURE_NO_WARNINGS

  LIBS += user32.lib Gdi32.lib shell32.lib
  LIBS += -L../WinSparkle/Release

  QMAKE_PRE_LINK = ruby dist/win/patch_rc.rb
}
