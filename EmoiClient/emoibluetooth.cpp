#include "emoibluetooth.h"
#include <QDebug>
#include <QtMath>

EmoiBluetooth::EmoiBluetooth(QObject* parent):QObject(parent)
{
    socket = new QBluetoothSocket(this);
    discoveryAgent = new QBluetoothServiceDiscoveryAgent(this);
    connect(discoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)),this, SLOT(serviceDiscovered(QBluetoothServiceInfo)));
    connect(socket, SIGNAL(connected()), this, SLOT(serviceConnected()));
}

void EmoiBluetooth::startServiceDiscovery()
{
    discoveryAgent->start();
}

void EmoiBluetooth::serviceDiscovered(const QBluetoothServiceInfo &service)
{
    qDebug() << "Found new service:" << service.device().name() << ' ' <<service.serviceName() << ' ' << service.device().address().toString();
    if(service.device().name().contains("emoi", Qt::CaseInsensitive) && service.serviceName().contains("Serial Port Profile", Qt::CaseInsensitive))
    {
        qDebug()<< "emoi connecting";
        emit emoiFinded(service.device().name());
        socket->connectToService(service);
    }
}

void EmoiBluetooth::serviceConnected()
{
    qDebug()<< "emoi connected";
    emit emoiConnected();
}

void EmoiBluetooth::setColor(QColor color)
{
    int r = color.red();
    int g = color.green();
    int b = color.blue();
    int n = qCeil((r+g+b+59)/256.0f)+2;
    int m = (r + g + b) - ((n-3)*256 - 59);
    QString colorAPI = "02010014001000440023ff170101060035";
    QString red =  QString("%1").arg(r, 2, 16,QLatin1Char('0'));
    QString green =  QString("%1").arg(g, 2, 16,QLatin1Char('0'));
    QString blue =  QString("%1").arg(b, 2, 16,QLatin1Char('0'));
    QString argM =  QString("%1").arg(m, 2, 16,QLatin1Char('0'));
    QString argN =  QString("%1").arg(n, 2, 16,QLatin1Char('0'));
    colorAPI = colorAPI + red+green+blue+argM+"03"+argN+"0246";
    QString byteString = colorAPI;
    QByteArray hex(byteString.toLatin1());
    QByteArray byteArray = QByteArray::fromHex(hex);
    socket->write(byteArray);
}

void EmoiBluetooth::setColor()
{
    QString byteString = this->generateColor();
    QByteArray hex(byteString.toLatin1());
    QByteArray byteArray = QByteArray::fromHex(hex);
    socket->write(byteArray);
}

QString EmoiBluetooth::generateColor()
{
    int r = qrand()%255;
    int g = qrand()%255;
    int b = qrand()%255;
    int n = qCeil((r+g+b+59)/256.0f)+2;
    int m = (r + g + b) - ((n-3)*256 - 59);
    QString colorAPI = "02010014001000440023ff170101060035";
    QString red =  QString("%1").arg(r, 2, 16,QLatin1Char('0'));
    QString green =  QString("%1").arg(g, 2, 16,QLatin1Char('0'));
    QString blue =  QString("%1").arg(b, 2, 16,QLatin1Char('0'));
    QString argM =  QString("%1").arg(m, 2, 16,QLatin1Char('0'));
    QString argN =  QString("%1").arg(n, 2, 16,QLatin1Char('0'));
    colorAPI = colorAPI + red+green+blue+argM+"03"+argN+"0246";

    QColor color(r, g, b);
    emit emoiGenColor(color);

    return colorAPI;
}
