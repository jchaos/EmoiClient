#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "emoibluetooth.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Emoi Blink+");
    QGuiApplication::setOrganizationName("DjangoX");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    qmlRegisterType<EmoiBluetooth>("DjangoX.Emoi", 1, 0, "EmoiBluetooth");

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
