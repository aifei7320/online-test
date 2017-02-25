
#include "network.h"

Network::Network(QObject *parent):QObject(parent),
    ngCount(10), okCount(100), totalCount(110),
    boardLength(1.0), boardWidth(1.0),
    serverIP("192.168.0.94"), serverPort(7320)
{
    tcpSocket = new QTcpSocket;
    server = new QTcpServer;
    server->listen(QHostAddress::Any, 7321);
    connect(server, SIGNAL(newConnection()), this, SLOT(establishNewConnection()));
    //connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
    connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(errorOccur(QAbstractSocket::SocketError)));
    connect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState s)),
            this, SIGNAL(networkStateChanged(QAbstractSocket::SocketState s)));

    connect(tcpSocket, SIGNAL(disconnected()), this, SLOT(deleteTcpSocket()));
    connect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SLOT(currentStateChanged(QAbstractSocket::SocketState)));
}

Network::~Network()
{
    delete tcpSocket;
}

void Network::disconn()
{
    if(dataSocket != NULL)
        dataSocket->disconnectFromHost();
    qDebug()<<"disconnect";
}

quint8 Network::state() const
{
    return st;
}

quint32 Network::getBoardLength() const
{
    return boardLength;
}

quint32 Network::getBoardWidth() const
{
    return boardWidth;
}

quint32 Network::getBoardNG() const
{
    return ngCount;
}

quint32 Network::getBoardOK() const
{
    return okCount;
}

quint32 Network::getBoardTotal() const
{
    return totalCount;
}

QString Network::getSerialNum() const
{
    return serialNumber;
}

void Network::setServerIP(const QString ip)
{
    QRegExp re("((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))");
    qDebug()<<ip;
    if (ip.contains(re)){
        serverIP = ip;
        connToHost();
    } else {
        emit ipError();
    }
}

void Network::setDevice(const QString dev)
{
    deviceNumber = dev;
}

void Network::setServerPort(const quint32 port)
{
    serverPort = port;
}

void Network::reConnect() const
{
    tcpSocket->disconnectFromHost();
    connect(tcpSocket, SIGNAL(disconnected()), this, SLOT(networkDisconnected()));
}

void Network::errorOccur(QAbstractSocket::SocketError e)
{
    qDebug()<<e;
}

void Network::getInfoFromHost()
{
    QByteArray temp;
    QDataStream in(dataSocket);
    //struct boardInfo m;

    //if(m.magicNum ==0)
    //    return;
    //qDebug()<<m.serialNum<<m.length<<m.total<<m.width<<m.okcount<<m.ngcount;
    while(dataSocket->bytesAvailable() < 25);
    temp = dataSocket->read(25);
    serialNumber = temp.left(temp.indexOf("s"));
    boardLength = temp.mid(temp.lastIndexOf("s") + 1, temp.indexOf("l") - temp.lastIndexOf("s") - 1).toInt();
    boardWidth = temp.mid(temp.lastIndexOf("l") + 1, temp.indexOf("w") - temp.lastIndexOf("l") - 1).toInt();
    qDebug()<<temp<<" "<<serialNumber<<" "<<boardLength<<" "<<boardWidth;
    emit refresh();
}

void Network::connToHost()
{
    tcpSocket->connectToHost(serverIP, 7320);
    qDebug()<<serverIP;
}

void Network::networkDisconnected()
{
    tcpSocket->connectToHost(serverIP, serverPort);
}

void Network::currentStateChanged(QAbstractSocket::SocketState s)
{
    QDataStream out(tcpSocket);
    QByteArray info;
    info =info + "7321" + "@" + QByteArray(deviceNumber.toLocal8Bit());
    qDebug()<<info;
    quint8 length = info.size();
    switch(s){
        case QAbstractSocket::UnconnectedState:{
        st = this->UnconnectedState;

        break;
        }
    case QAbstractSocket::HostLookupState:{
        st = HostLookupState;
        break;
        }
    case QAbstractSocket::ConnectedState:{
        st = ConnectedState;
        out<<length;
        tcpSocket->write(info.data());
        break;
        }
    case QAbstractSocket::ConnectingState:{
        st = ConnectingState;
        break;
        }
    case QAbstractSocket::BoundState:{
        st = BoundState;
        break;
        }
    case QAbstractSocket::ClosingState:{
        //disconnect(tcpSocket, SIGNAL(disconnected()), this, SLOT(networkDisconnected()));
        ////disconnect(tcpSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
        //disconnect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)),
        //        this, SLOT(errorOccur(QAbstractSocket::SocketError)));
        //disconnect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
        //        this, SIGNAL(networkStateChanged(QAbstractSocket::SocketState)));

        //disconnect(tcpSocket, SIGNAL(disconnected()), this, SLOT(deleteTcpSocket()));
        //disconnect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
        //        this, SLOT(currentStateChanged(QAbstractSocket::SocketState)));
        st = ClosingState;
        break;
        }
    case QAbstractSocket::ListeningState:{
        st = ListeningState;
        break;
        }
    default: break;

    }
}

void Network::deleteTcpSocket()
{
   //tcpSocket->deleteLater();
}

void Network::establishNewConnection()
{
    dataSocket = server->nextPendingConnection();
    connect(dataSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
    connect(dataSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SLOT(dataSocketStateChanged(QAbstractSocket::SocketState)));
    connect(dataSocket, SIGNAL(disconnected()), this, SLOT(deleteDataSocket()));
    st = ConnectedState;
    emit networkStateChanged(QAbstractSocket::ConnectedState);
}

void Network::dataSocketStateChanged(QAbstractSocket::SocketState s)
{
    qDebug()<<"Am i in";
    switch(s){
        case QAbstractSocket::UnconnectedState:{
        st = this->UnconnectedState;
        emit networkStateChanged(QAbstractSocket::UnconnectedState);
        break;
        }
    case QAbstractSocket::HostLookupState:{
        st = HostLookupState;
        emit networkStateChanged(QAbstractSocket::HostLookupState);
        break;
        }
    case QAbstractSocket::ConnectedState:{
        st = ConnectedState;
        emit networkStateChanged(QAbstractSocket::ConnectedState);
        qDebug()<<"ConnectedState";
        break;
        }
    case QAbstractSocket::ConnectingState:{
        emit networkStateChanged(QAbstractSocket::ConnectingState);
        st = ConnectingState;
        break;
        }
    case QAbstractSocket::BoundState:{
        emit networkStateChanged(QAbstractSocket::BoundState);
        st = BoundState;
        break;
        }
    case QAbstractSocket::ClosingState:{
        emit networkStateChanged(QAbstractSocket::ClosingState);
        disconnect(dataSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
        disconnect(dataSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
                this, SLOT(dataSocketStateChanged(QAbstractSocket::SocketState)));
        st = ClosingState;
        break;
        }
    case QAbstractSocket::ListeningState:{
        emit networkStateChanged(QAbstractSocket::ListeningState);
        st = ListeningState;
        break;
        }
    default: break;

    }

}

void Network::deleteDataSocket()
{
    disconnect(dataSocket, SIGNAL(disconnected()), this, SLOT(deleteDataSocket()));
    //dataSocket->deleteLater();
    st = QAbstractSocket::UnconnectedState;
    emit networkStateChanged(QAbstractSocket::UnconnectedState);
}
