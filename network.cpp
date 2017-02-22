
#include "network.h"

Network::Network(QObject *parent):QObject(parent),
    ngCount(10), okCount(100), totalCount(110),
    boardHeight(1.0), boardWidth(1.0),
    serverIP("192.168.0.94"), serverPort(7320)
{
    tcpSocket = new QTcpSocket;
    server = new QTcpServer;
    server->listen(QHostAddress::Any, 7321);
    connect(server, SIGNAL(newConnection()), this, SLOT(establishNewConnection()));
    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
    connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(errorOccur(QAbstractSocket::SocketError)));
    connect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SIGNAL(networkStateChanged(QAbstractSocket::SocketState)));

    connect(tcpSocket, SIGNAL(disconnected()), this, SLOT(deleteTcpSocket()));
    connect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SLOT(currentStateChanged(QAbstractSocket::SocketState)));
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
    //return serialNumber;
    return localIP;
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
    connect(tcpSocket, SIGNAL(disconnected()), this, SLOT(networkDisconnected()));
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
    tcpSocket->connectToHost("192.168.0.94", 7320);

}

void Network::networkDisconnected()
{
    tcpSocket->connectToHost(serverIP, serverPort);

}

void Network::currentStateChanged(QAbstractSocket::SocketState s)
{
    QDataStream out(tcpSocket);
    QByteArray info;
    info += "192.168.0.121";
    info =info + ":" + "7321" + "@1";
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
        disconnect(tcpSocket, SIGNAL(disconnected()), this, SLOT(networkDisconnected()));
        disconnect(tcpSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
        disconnect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)),
                this, SLOT(errorOccur(QAbstractSocket::SocketError)));
        disconnect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
                this, SIGNAL(networkStateChanged(QAbstractSocket::SocketState)));

        disconnect(tcpSocket, SIGNAL(disconnected()), this, SLOT(deleteTcpSocket()));
        disconnect(tcpSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
                this, SLOT(currentStateChanged(QAbstractSocket::SocketState)));
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
   tcpSocket->deleteLater();
}

void Network::establishNewConnection()
{
    qDebug()<<"new connection";
    dataSocket = server->nextPendingConnection();
    connect(dataSocket, SIGNAL(readyRead()), this, SLOT(getInfoFromHost()));
    connect(dataSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SLOT(dataSocketStateChanged(QAbstractSocket::SocketState)));
}

void Network::dataSocketStateChanged(QAbstractSocket::SocketState s)
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
        qDebug()<<"kajsdlf";
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
