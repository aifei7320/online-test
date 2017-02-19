import QtQuick 2.0
import QtQuick 2.7
import QtQuick.Controls 2.1

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
            Row{ spacing: 2; Label { text:"IP Addresss:" } TextEdit { id: ipaddr; text:"please input server IP"} }
            Row{  Label { text:"Port:" } TextEdit { id: portNum; text:"server port"} }
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
