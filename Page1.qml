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
        property var mwidth;
        property var mlength;
        property var realWidth;
        property var realLength;
        property string serialNumber;
        property int boardWidthMatch;
        property int boardLengthMatch;
        property real rate;

        signal showIpError();
        signal connect(string ip, string dev);
        signal disconnect();

        onShowIpError: {
            ipErrorHint.visible=true
        }
        onOkCountChanged: dispOKCount.text=okCount;
        onNgCountChanged: dispNgCount.text=ngCount;
        onTotalCountChanged: dispTotalCount.text=totalCount;
        onRateChanged: dispRage.text=rate;
        onMlengthChanged: dispBoardLength.text = mlength;
        onMwidthChanged: dispBoardWidth.text=mwidth;
        onRealLengthChanged: dispRealBoardLength.text=realLength;
        onRealWidthChanged: dispRealBoardWidth.text=realWidth;
        onSerialNumberChanged: dispSerialNum.text=serialNumber;
        onBoardWidthMatchChanged: dispBoardWidth.color=boardWidthMatch ? "black" : "red"
        onBoardLengthMatchChanged: dispBoardLength.color=boardLengthMatch ? "black" : "red"

        //Network{
        //    id:network
        //}

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

            RowLayout{
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin:20
                Layout.leftMargin:10

                Label {id:serialNum; text:"条码:"; font{pixelSize:16; bold:true }Layout.alignment:Qt.AlignLeft}
                Label {id:dispSerialNum; text:"";horizontalAlignment:Qt.AlignRight; background:Item{Rectangle {anchors.fill: parent; color: "white"; }}}
            }

            //GroupBox{
            //    Layout.minimumWidth: root.width - 20
            //    Layout.margins:10
            //    Layout.alignment: Qt.AlignHCenter

            //    GridLayout{
            //        width: parent.width
            //        height: 129
            //        rows: 5
            //        columns: 3
            //        Layout.fillWidth: true
            //        columnSpacing: 10

            //        Label {id:boardDetection; text:"封边检测";
            //            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //            font{pixelSize:20;bold:true; family:"Ubuntu" } color:"brown";
            //            Layout.columnSpan:3; horizontalAlignment: Text.AlignHCenter}

            //        Label {id: okLabel; text:"完好数量:"; horizontalAlignment: Qt.AlignCenter}
            //        Label {id:dispOKCount; Layout.fillWidth:true; color:"black"; text:"0"; horizontalAlignment: Text.AlignRight}
            //        Label {id:dispOKUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

            //        Label {id: ngLabel; text:"缺陷数量:"; horizontalAlignment: Qt.AlignCenter}
            //        Label {id:dispNgCount; Layout.fillWidth:true; color:"black"; text:"0"; horizontalAlignment: Qt.AlignRight}
            //        Label {id:dispNgUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

            //        Label {id: totalLabel; text:"总数量:"; horizontalAlignment: Qt.AlignCenter}
            //        Label {id: dispTotalCount; Layout.fillWidth:true; color:"black"; text:"0";  horizontalAlignment: Qt.AlignRight}
            //        Label {id:dispTotalUnit; Layout.minimumWidth:30; color:"black"; text:"块";horizontalAlignment:Text.AlignRight}

            //        Label {id: rateLabel; text:"缺陷率:"; horizontalAlignment: Qt.AlignCenter}
            //        Label {id:dispRate; Layout.fillWidth:true; color:"black"; text:"0" ;horizontalAlignment: Text.AlignRight}
            //        Label {id:dispRateUnit; Layout.minimumWidth:30; color:"black"; text:"%"; horizontalAlignment:Text.AlignRight}
            //    }
            //}

            GroupBox{
                id:widthAndHeight
               Layout.minimumWidth: root.width - 20
               Layout.alignment: Qt.AlignHCenter
               Layout.leftMargin:10
               Layout.rightMargin:10

               GridLayout{
                   width: parent.width
                   height: 67
                    rows: 4
                    columns: 3
                    columnSpacing: 10
                    Layout.fillWidth:true

                    Label {id:boardSize; text:"木板尺寸测量"; Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter; color:"brown";
                        font{pixelSize:20;bold:true; family:"Ubuntu"} Layout.columnSpan: 3}

                    Label {id:realBoardWidth; text:"目标宽度:"; Layout.alignment: Qt.AlignLeft}
                    Label {id:dispRealBoardWidth; text:"0"; Layout.fillWidth:true; horizontalAlignment:Text.AlignRight}
                    Label {id:widthUnitReal; Layout.minimumWidth:30; text:"mm"; horizontalAlignment:Text.AlignRight}

                    Label {id:boardWidth; text:"木板宽度:"; Layout.alignment: Qt.AlignLeft}
                    Label {id:dispBoardWidth; text:"0"; Layout.fillWidth:true; horizontalAlignment:Text.AlignRight}
                    Label {id:widthUnit; Layout.minimumWidth:30; text:"mm"; horizontalAlignment:Text.AlignRight}

                    Label {id:realBoardLength; text:"目标长度:"}
                    Label {id:dispRealBoardLength; text:"0"; Layout.fillWidth: true; horizontalAlignment:Text.AlignRight}
                    Label {id:heightUnitReal; Layout.minimumWidth:30; text:"mm"; horizontalAlignment:Text.AlignRight}

                    Label {id:boardLength; text:"木板长度:"}
                    Label {id:dispBoardLength; text:"0"; Layout.fillWidth: true; horizontalAlignment:Text.AlignRight}
                    Label {id:heightUnit; Layout.minimumWidth:30; text:"mm"; horizontalAlignment:Text.AlignRight}
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
                id:btnlayout
                spacing:20
                Layout.topMargin:5
                Layout.alignment: Qt.AlignHCenter
                Button{
                    id:connectBtn
                    height:ip.height
                    text:"连接"
                    background: Rectangle {
                              implicitWidth: 140
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: connectBtn.down ? "#d0d0d0" : "#e0e0e0"
                              radius: 20
                      }
                    onPressed: {
                        //network.setServerIP(ipdisp.text);
                        //network.setDevice(devdisp.text);
                        root.connect(ipdisp.text, devdisp.text);
                    }
                }
                Button{
                    id:disconnectBtn
                    height:ip.height
                    text:"断开"
                    background: Rectangle {
                              implicitWidth: 140
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: disconnectBtn.down ? "#d0d0d0" : "#e0e0e0"
                              radius: 20
                          }
                    onClicked:{
                        //network.disconn();
                        root.disconnect();
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

        //Connections{
        //    target:network
        //    onRefresh:{
        //        root.okCount=network.getBoardOK();
        //        root.ngCount=network.getBoardNG();
        //        root.totalCount=network.getBoardTotal();
        //        root.serialNum=network.getSerialNum();
        //        root.boardWidth=network.getBoardWidth().toFixed(1);
        //        root.boardLength=network.getBoardLength().toFixed(1);
        //        root.realBoardWidth=network.getRealBoardWidth().toFixed(1);
        //        root.realBoardLength=network.getRealBoardLength().toFixed(1);
        //        root.boardLengthMatch = network.getBoardLengthMatch();
        //        root.boardWidthMatch = network.getBoardWidthMatch();
        //        dispOKCount.text=root.okCount;
        //        dispNgCount.text=root.ngCount;
        //        dispTotalCount.text=root.totalCount;
        //        dispRate.text=root.totalCount == 0 ? 0 : (root.okCount / root.totalCount * 100.0).toFixed(2);
        //        dispBoardLength.text=root.boardLength;
        //        dispBoardWidth.text=root.boardWidth;
        //        dispRealBoardLength.text=root.realBoardLength;
        //        dispRealBoardWidth.text=root.realBoardWidth;
        //        dispSerialNum.text=root.serialNum;
        //        dispBoardWidth.color=root.boardWidthMatch ? "black" : "red"
        //        dispBoardLength.color=root.boardLengthMatch ? "black" : "red"
        //    }
        //}

        //Connections{
        //    target:network
        //    onIpError:{
        //        root.showIpError();
        //    }
        //}

        //Connections{
        //    target:network
        //    onNetworkStateChanged:{
        //        networkStatus.stateNum=network.state()
        //    }
        //}


    }
