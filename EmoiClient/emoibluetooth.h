#ifndef EMOIBLUETOOTH_H
#define EMOIBLUETOOTH_H
#include <QObject>
#include <QBluetoothSocket>
#include <QBluetoothServiceInfo>
#include <QBluetoothServiceDiscoveryAgent>
#include <QString>
#include <QByteArray>
#include <QColor>

class EmoiBluetooth : public QObject
{
    Q_OBJECT
public:
    EmoiBluetooth(QObject* parent = 0);
    Q_INVOKABLE void startServiceDiscovery();
    Q_INVOKABLE void setColor(QColor);
public slots:
    void serviceDiscovered(const QBluetoothServiceInfo &service);
    void serviceConnected();
    void setColor();

private:
    QBluetoothServiceDiscoveryAgent *discoveryAgent;
    QBluetoothSocket* socket;

    QString generateColor();
signals:
    void emoiFinded(QString deviceName);
    void emoiConnected();
    void emoiGenColor(QColor color);
};

#endif // EMOIBLUETOOTH_H
