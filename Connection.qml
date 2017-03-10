import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import com.shelly 1.0

    Rectangle{
        id:root
        width: Screen.desktopAvailableWidth
        height: Screen.desktopAvailableHeight

        property int okCount;
        property int ngCount;
        property int totalCount;
        property string serialNum;
        property real rate;
        property int statenum

        signal showIpError();
        signal connect(string ip, string dev);
        signal disconnect();

        onShowIpError: {
            ipErrorHint.visible=true
        }

        onOkCountChanged: dispOKCount.text = okCount;
        onNgCountChanged: dispNgCount.text = ngCount;
        onTotalCountChanged: dispTotalCount.text = totalCount;
        onRateChanged: dispRate.text = rate;
        onStatenumChanged: networkStatus.stateNum = statenum

        MessageDialog{
            id:ipErrorHint
            title:"Error"
            text:"ip地址配置不正确\n请重新尝试"
            icon:StandardIcon.Critical;
            onAccepted: {
                ipdisp.text="";
                ipdisp.placeholderText="192.168.0.123";
            }
        }

        gradient: Gradient {
            GradientStop{position:0.0; color: "white"}
            GradientStop{position:1.0; color: "cyan"}
        }
        ColumnLayout{

            GroupBox{
                Layout.minimumWidth: root.width - 20
                Layout.margins:10
                Layout.alignment: Qt.AlignHCenter

                GridLayout{
                    width: parent.width
                    height: 129
                    rows: 5
                    columns: 3
                    Layout.fillWidth: true
                    columnSpacing: 10

                    Label {id:boardDetection; text:"封边检测";
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font{pixelSize:20;bold:true; family:"Ubuntu" } color:"brown";
                        Layout.columnSpan:3; horizontalAlignment: Text.AlignHCenter}

                    Label {id: okLabel; text:"完好数量:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispOKCount; Layout.fillWidth:true; color:"black"; text:"0"; horizontalAlignment: Text.AlignRight}
                    Label {id:dispOKUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

                    Label {id: ngLabel; text:"缺陷数量:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispNgCount; Layout.fillWidth:true; color:"black"; text:"0"; horizontalAlignment: Qt.AlignRight}
                    Label {id:dispNgUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

                    Label {id: totalLabel; text:"总数量:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id: dispTotalCount; Layout.fillWidth:true; color:"black"; text:"0";  horizontalAlignment: Qt.AlignRight}
                    Label {id:dispTotalUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

                    Label {id: rateLabel; text:"缺陷率:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispRate; Layout.fillWidth:true; color:"black"; text:"0" ;horizontalAlignment: Text.AlignRight}
                    Label {id:dispRateUnit; Layout.minimumWidth:30; color:"black"; text:"%"; horizontalAlignment:Text.AlignRight}
                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin:5

                Label{id:ip; text:"IP  地址:   "; Layout.leftMargin:10}
                TextField{
                    id:ipdisp
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true
                    Layout.rightMargin: 10
                    placeholderText: "请输入服务器ip地址"

                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin:5

                Label{id:dev; text:"设备编号: ";width:ip.width;  Layout.leftMargin:10}
                TextField{id:devdisp;Layout.rightMargin:10; Layout.fillWidth:true; Layout.alignment: Qt.AlignRight; placeholderText:"设备编号" }
            }

            RowLayout{
                id:layout
                spacing:20
                Layout.topMargin:5
                Layout.alignment: Qt.AlignHCenter
                Button{
                    id:connect
                    height:ip.height
                    text:"连接"
                    background: Rectangle {
                              implicitWidth: 140
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: connect.down ? "#d0d0d0" : "#e0e0e0"
                              radius: 20
                      }
                    onPressed: {
                        console.log("pressed")
                        root.connect(ipdisp.text, devdisp.text)
                    }
                }
                Button{
                    id:disconnect
                    height:ip.height
                    text:"断开"
                    background: Rectangle {
                              implicitWidth: 140
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: disconnect.down ? "#d0d0d0" : "#e0e0e0"
                              radius: 20
                          }
                    onPressed:{
                        root.disconnect();
                    }
                }
            }
            NetworkStatus{
                id:networkStatus
                width:parent.width;
                anchors.top:layout.bottom
                run:true
            }

            function checkIP(ipaddr){
                if (ipaddr == "")
                    return

            }
        }

    }
