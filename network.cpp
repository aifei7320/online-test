
#include "network.h"

Network::Network(QObject *parent):QObject(parent),
    ngCount(10), okCount(100), totalCount(110),
    boardHeight(1.0), boardWidth(1.0),
    serverIP("192.168.0.94"), serverPort(7320)
{
    tcpSocket = new QTcpSocket;
    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
    connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(errorOccur(QAbstractSocket::SocketError)));
    connect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SIGNAL(networkStateChanged(QAbstractSocket::SocketState)));
}

Network::~Network()
{
    delete tcpSocket;
}

quint8 Network::state() const
{
    return st;
}

quint32 Network::getBoardHeight() const
{
    return boardHeight;
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
    serverIP = ip;
    qDebug()<<serverIP<<endl;
    emit refresh();
}

void Network::setServerPort(const quint32 port)
{
    serverPort = port;
}

void Network::reConnect() const
{
    tcpSocket->disconnectFromHost();
    connect(tcpSocket, SIGNAL(disconnectFromHost()), this, SLOT(networkDisconnected()));
}

void Network::errorOccur(QAbstractSocket::SocketError e)
{
    qDebug()<<e;
}

void Network::getInfoFromHost()
{

}

void Network::connToHost()
{
    tcpSocket->connectToHost("192.168.0.96", 7320);

}

void Network::networkDisconnected()
{
    tcpSocket->connectToHost(serverIP, serverPort);

}

void Network::currentStateChanged(QAbstractSocket::SocketState s)
{
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
