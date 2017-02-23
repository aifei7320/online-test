import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import com.shelly 1.0

Item {

    Rectangle{
        id:root
        width: Screen.desktopAvailableWidth > 600 ? 300 : Screen.desktopAvailableWidth
        height: Screen.desktopAvailableWidth > 600 ? 500 : Screen.desktopAvailableHeight

        property int okCount;
        property int ngCount;
        property int totalCount;
        property var boardWidth;
        property var boardHeight;
        property string serialNum;
        property real rate;

        Network{
            id:network
        }

        gradient: Gradient {
            GradientStop{position:0.0; color: "white"}
            GradientStop{position:1.0; color: "cyan"}
        }
        ColumnLayout{

            RowLayout{
                Layout.alignment: Qt.AlignCenter

                Label {id:serialNum; text:"serialNum:"; horizontalAlignment: Qt.AlignCenter}
                Label {id:dispSerialNum; text:"21352132132";horizontalAlignment:Qt.AlignRight; background:Item{Rectangle {anchors.fill: parent; color: "gray"; }}}
            }

            GroupBox{
                Layout.minimumWidth: root.width - 20
                Layout.margins:10
                Layout.alignment: Qt.AlignHCenter

                GridLayout{
                    rows: 5
                    columns: 2
                    Layout.fillWidth: true

                    Label {text:qsTr("board detection"); Layout.alignment: Qt.AlignHCenter;
                        font{pixelSize:20 } color:"brown"; width:300;Layout.columnSpan:2;}

                    Label {id: okLabel; text:"OKCount:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispOKCount; color:"gray"; text:"0"; horizontalAlignment: Qt.AlignRight}

                    Label {id: ngLabel; text:"NGCount:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispNgCount; color:"gray"; text:"0"; horizontalAlignment: Qt.AlignRight}

                    Label {id: totalLabel; text:"TotalCount:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id: dispTotalCount; color:"gray"; text:"1"; horizontalAlignment: Qt.AlignRight}

                    Label {id: rateLabel; text:"Rate:"; horizontalAlignment: Qt.AlignCenter}
                    Label {id:dispRate; color:"gray"; text:"0.0" ;horizontalAlignment: Qt.AlignRight}
                }
            }

            GroupBox{
                id:widthAndHeight
               Layout.minimumWidth: root.width - 20
               Layout.alignment: Qt.AlignHCenter
               Layout.leftMargin:10
               Layout.rightMargin:10

                GridLayout{
                    rows: 3
                    columns: 3
                    columnSpacing: 10
                    Layout.fillWidth:true

                    Label {id:boardSize; Layout.alignment: Qt.AlignHCenter; text:"board Size"; font{pixelSize:20; family:"Ubuntu"} Layout.columnSpan: 3}

                    Label {id:boardWidth; text:"boardWidth:"; Layout.alignment: Qt.AlignLeft}
                    Label {id:dispBoardWidth; text:"100.000"; Layout.fillWidth:true; Layout.alignment: Qt.AlignHCenter}
                    Label {id:widthUnit; text:"mm"; Layout.alignment: Qt.AlignRight}

                    Label {id:boardHeight; text:"boardHeight:"}
                    Label {id:dispBoardHeight; text:"0.0"}
                    Label {id:heightUnit; text:"mm"}
                }
            }
            RowLayout{
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin:5

                Label{id:ip; text:"IP Addr:"}
                TextField{
                    id:ipdisp
                    placeholderText: "please input server ip"

                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin:5

                Label{id:dev; text:"device:"}
                ComboBox{
                    id:devdisp
                    model:{1, 2, 3, 4, 5, 6}
                }
            }

            RowLayout{
                spacing:20
                Layout.alignment: Qt.AlignHCenter
                Button{
                    id:connectBtn
                    text:"connect"
                    onPressed: {
                        network.connToHost();
                        console.log(devdisp.currentIndex)
                    }
                }
                Button{
                    id:disconnectBtn
                    text:"disconnect"
                }
            }
            NetworkStatus{
                id:networkStatus
                width:parent.width;
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
                root.boardHeight=network.getBoardHeight();
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
            onNetworkStateChanged:{
                networkStatus.stateNum=network.state()
            }
        }


    }
}
