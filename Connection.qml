import QtQuick 2.0
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtCharts 2.2

Item {
    id: connection;

    property string ip;
    property string port;


    signal setIP(string ip, string port)
    Rectangle {
        width: 200 ;
        height: 100;
        color: "cyan";

        Column {
            spacing: 5
            Row{ spacing: 2; Label { text:"ip地址:" } TextEdit { id: ipaddr; text:"请输入服务器地址"} }
            Row{  Label { text:"端口:" } TextEdit { id: portNum; text:"请输入服务器端口"} }
            Button {
                id: conform;

                text:"Conform";
                onClicked:{
                    ip=ipaddr.text;
                    port=portNum.text;
                    connection.visible=false
                    connection.setIP(ip, port)
                }
            }

        }
    }

}
