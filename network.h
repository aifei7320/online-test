#ifndef NETWORK_H
#define NETWORK_H

#include <QTcpSocket>
#include <QObject>

class network : public QObject
{
    Q_OBJECT
    Q_PROPERTY()
public:
    network();
    QVector<QString> info();
Q_SIGNALS:

private Q_SLOTS:
    void connToHost();
    void getInfoFromHost();
};

#endif // NETWORK_H
