import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import com.shelly 1.0

Item {
    property alias boardSize: boardSize

    Rectangle{
        id:root
        width: Screen.desktopAvailableWidth > 600 ? 300 : Screen.desktopAvailableWidth
        height: Screen.desktopAvailableWidth > 600 ? 500 : Screen.desktopAvailableHeight

        property int okCount;
        property int ngCount;
        property int totalCount;
        property int boardWidth;
        property int boardHeight;
        property string serialNum;
        property real rate;

        signal showIpError();

        onShowIpError: {
            ipErrorHint.visible=true
        }

        Network{
            id:network
        }

        MessageDialog{
            id:ipErrorHint
            title:"Error"
            text:"ip address not correct\n please try again"
            icon:StandardIcon.Critical;
            onAccepted: {
                ipdisp.text="";
                ipdisp.placeholderText="like this:192.168.0.123";
            }
        }

        gradient: Gradient {
            GradientStop{position:0.0; color: "white"}
            GradientStop{position:1.0; color: "cyan"}
        }
        ColumnLayout{

            RowLayout{
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin:20
                Layout.leftMargin:10

                Label {id:serialNum; text:"serialNum:"; font{pixelSize:16; bold:true }Layout.alignment:Qt.AlignLeft}
                Label {id:dispSerialNum; text:"";horizontalAlignment:Qt.AlignRight; background:Item{Rectangle {anchors.fill: parent; color: "gray"; }}}
            }

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

                    Label {id:boardDetection; text:"board detection";
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font{pixelSize:20;bold:true; family:"Ubuntu" } color:"brown";
                        Layout.columnSpan:3; horizontalAlignment: Text.AlignHCenter}

                    Label {id: okLabel; text:"OKCount:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispOKCount; Layout.fillWidth:true; color:"black"; text:"0"; horizontalAlignment: Text.AlignRight}
                    Label {id:dispOKUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

                    Label {id: ngLabel; text:"NGCount:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispNgCount; Layout.fillWidth:true; color:"black"; text:"0"; horizontalAlignment: Qt.AlignRight}
                    Label {id:dispNgUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

                    Label {id: totalLabel; text:"TotalCount:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id: dispTotalCount; Layout.fillWidth:true; color:"black"; text:"1";  horizontalAlignment: Qt.AlignRight}
                    Label {id:dispTotalUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

                    Label {id: rateLabel; text:"Rate:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispRate; Layout.fillWidth:true; color:"black"; text:"0" ;horizontalAlignment: Text.AlignRight}
                    Label {id:dispRateUnit; Layout.minimumWidth:30; color:"black"; text:"%"; horizontalAlignment:Text.AlignRight}
                }
            }

            GroupBox{
                id:widthAndHeight
               Layout.minimumWidth: root.width - 20
               Layout.alignment: Qt.AlignHCenter
               Layout.leftMargin:10
               Layout.rightMargin:10

               GridLayout{
                   width: parent.width
                   height: 67
                    rows: 3
                    columns: 3
                    columnSpacing: 10
                    Layout.fillWidth:true

                    Label {id:boardSize; text:"board Size"; Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter; color:"brown";
                        font{pixelSize:20;bold:true; family:"Ubuntu"} Layout.columnSpan: 3}

                    Label {id:boardWidth; text:"boardWidth:"; Layout.alignment: Qt.AlignLeft}
                    Label {id:dispBoardWidth; text:"0"; Layout.fillWidth:true; horizontalAlignment:Text.AlignRight}
                    Label {id:widthUnit; Layout.minimumWidth:30; text:"mm"; horizontalAlignment:Text.AlignRight}

                    Label {id:boardHeight; text:"boardHeight:"}
                    Label {id:dispBoardHeight; text:"0"; Layout.fillWidth: true; horizontalAlignment:Text.AlignRight}
                    Label {id:heightUnit; Layout.minimumWidth:30; text:"mm"; horizontalAlignment:Text.AlignRight}
                }
            }
            RowLayout{
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin:5

                Label{id:ip; text:"IP Addr:"; Layout.leftMargin:10}
                TextField{
                    id:ipdisp
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true
                    Layout.rightMargin: 10
                    placeholderText: "please input server ip"

                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin:5

                Label{id:dev; text:"Device: ";width:ip.width;  Layout.leftMargin:10}
                TextField{id:devdisp;Layout.rightMargin:10; Layout.fillWidth:true; Layout.alignment: Qt.AlignRight; placeholderText:"device id" }
            }

            RowLayout{
                id:btnlayout
                spacing:20
                Layout.alignment: Qt.AlignHCenter
                Button{
                    id:connectBtn
                    height:ip.height
                    text:"connect"
                    background: Rectangle {
                              implicitWidth: 100
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: connectBtn.down ? "#d0d0d0" : "#e0e0e0"
                              radius: 20
                      }
                    onPressed: {
                        network.setServerIP(ipdisp.text);
                        network.setDevice(devdisp.text);
                    }
                }
                Button{
                    id:disconnectBtn
                    height:ip.height
                    text:"disconnect"
                    background: Rectangle {
                              implicitWidth: 100
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: disconnectBtn.down ? "#d0d0d0" : "#e0e0e0"
                              radius: 20
                          }
                    onClicked:{
                        network.disconn();
                    }
                }
            }
            NetworkStatus{
                id:networkStatus
                width:parent.width;
                anchors.top:btnlayout.bottom
                run:true
            }

            function checkIP(ipaddr){
                if (ipaddr == "")
                    return

            }
        }


        Connections{
            target:network
            onRefresh:{
                root.okCount=network.getBoardOK();
                root.ngCount=network.getBoardNG();
                root.totalCount=network.getBoardTotal();
                root.serialNum=network.getSerialNum();
                root.boardWidth=network.getBoardWidth();
                root.boardHeight=network.getBoardLength();
                dispOKCount.text=root.okCount;
                dispNgCount.text=root.ngCount;
                dispTotalCount.text=root.totalCount;
                dispRate.text=(root.okCount / root.totalCount).toFixed(2);
                dispBoardHeight.text=root.boardHeight;
                dispBoardWidth.text=root.boardWidth;
                dispSerialNum.text=root.serialNum;
                console.log("actived refresh");
            }
        }

        Connections{
            target:network
            onIpError:{
                ipdisp.color="red"
                root.showIpError();
            }
        }

        Connections{
            target:network
            onNetworkStateChanged:{
                networkStatus.stateNum=network.state()
                console.log("state changed")
                console.log(networkStatus.stateNum)
            }
        }


    }
}
