TEMPLATE = app

QT += qml quick quickcontrols2 bluetooth
CONFIG += c++11

TARGET = "emoiSilly"

SOURCES += main.cpp \
    emoibluetooth.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    emoibluetooth.h
