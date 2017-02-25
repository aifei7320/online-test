#ifndef NETWORK_H
#define NETWORK_H

#include <QTcpSocket>
#include <QTcpServer>
#include <QDebug>
#include <QObject>
#include <QDataStream>
#include <QHostInfo>
#include <QRegExp>

struct boardInfo{
    quint32 magicNum;//魔数默认123456,用来匹配数据
    char* serialNum;//序列号
    quint16 length;//长度信息
    quint16 width;//宽度信息
    quint32 total;//总数信息
    quint32 ngcount;//有缺陷板数量
    quint32 okcount;//完美板数量
    quint8 lengthMatch;//指示板长是否匹配 匹配为0, 不匹配为除零外任意数
    quint8 widthMatch;//指示板宽是否匹配 匹配为0, 不匹配为除零外任意数
    quint8 boardPerfect;//指示是否有缺陷 完美0, 不不完美为除零外任意数

};

Q_DECLARE_METATYPE(boardInfo)

class Network : public QObject
{
    Q_OBJECT
    Q_ENUMS(networkState)
public:
    Network(QObject *parent=0);
    ~Network();

    Q_INVOKABLE quint32 getBoardOK() const;
    Q_INVOKABLE quint32 getBoardNG() const;
    Q_INVOKABLE quint32 getBoardTotal() const;
    Q_INVOKABLE QString getSerialNum()const ;
    Q_INVOKABLE quint32 getBoardWidth() const ;
    Q_INVOKABLE quint32 getBoardLength() const;
    Q_INVOKABLE void reConnect() const;
    Q_INVOKABLE void setServerIP(const QString ip);
    Q_INVOKABLE void setServerPort(const quint32 port);
    Q_INVOKABLE void setDevice(const QString dev);
    Q_INVOKABLE void connToHost();
    Q_INVOKABLE quint8 state() const;
    Q_INVOKABLE void disconn();

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
    quint32 boardWidth, boardLength;
    QString serialNumber;
    QTcpSocket *tcpSocket;
    QTcpSocket *dataSocket;
    QTcpServer *server;
    QString serverIP;
    quint32 serverPort;
    QString deviceNumber;
    quint8 st;

Q_SIGNALS:
    void refresh();
    void networkStateChanged(QAbstractSocket::SocketState );
    void ipError();

private Q_SLOTS:
    void getInfoFromHost();
    void errorOccur(QAbstractSocket::SocketError e);
    void networkDisconnected();
    void currentStateChanged(QAbstractSocket::SocketState);
    void dataSocketStateChanged(QAbstractSocket::SocketState);
    void establishNewConnection();
    void deleteTcpSocket();
    void deleteDataSocket();
};

inline QDataStream &operator>>(QDataStream &in, struct boardInfo &board)
{
    in.setVersion(QDataStream::Qt_5_0);
    in>> board.magicNum;
    if (board.magicNum != 123456){
        board.magicNum = 0;
        return in;
    }
    in>>board.serialNum>> board.length>> board.width>>
        board.total>> board.ngcount>> board.okcount>>
            board.lengthMatch>> board.widthMatch>> board.boardPerfect;
    return in;
}


#endif // NETWORK_H
