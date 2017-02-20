#ifndef NETWORK_H
#define NETWORK_H

#include <QTcpSocket>
#include <QDebug>
#include <QObject>

class Network : public QObject
{
    Q_OBJECT
    Q_ENUMS(networkState)
    Q_PROPERTY(quint8 state READ state NOTIFY networkStateChanged)
public:
    Network(QObject *parent=0);
    ~Network();

    Q_INVOKABLE quint32 getBoardOK() const;
    Q_INVOKABLE quint32 getBoardNG() const;
    Q_INVOKABLE quint32 getBoardTotal() const;
    Q_INVOKABLE QString getSerialNum()const ;
    Q_INVOKABLE quint32 getBoardWidth() const ;
    Q_INVOKABLE quint32 getBoardHeight() const;
    Q_INVOKABLE void reConnect() const;
    Q_INVOKABLE void setServerIP(const QString ip);
    Q_INVOKABLE void setServerPort(const quint32 port);
    quint8 state() const;

    enum networkState{
        UnconnectedState = 0,
        HostLookupState,
        ConnectingState,
        ConnectedState,
        BoundState,
        ListeningState,
        ClosingState,
    };

private:
    quint32 totalCount, ngCount, okCount;
    qreal boardWidth, boardHeight;
    QString serialNumber;
    QTcpSocket *tcpSocket;
    QString serverIP;
    quint32 serverPort;
    quint8 st;

Q_SIGNALS:
    void refresh();
    void networkStateChanged(QAbstractSocket::SocketState );

private Q_SLOTS:
    void connToHost();
    void getInfoFromHost();
    void errorOccur(QAbstractSocket::SocketError e);
    void networkDisconnected();
    void currentStateChanged(QAbstractSocket::SocketState);
};

#endif // NETWORK_H