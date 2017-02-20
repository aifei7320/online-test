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
        height: Screen.desktopAvailableWidth > 600 ? 400 : Screen.desktopAvailableHeight

        property int okCount;
        property int ngCount;
        property int totalCount;
        property real boardWidth;
        property real boardHeight;
        property string serialNum;
        property real rate;

        Network{
            id:network
        }

        gradient: Gradient {
            GradientStop{position:0.0; color: "white"}
            GradientStop{position:1.0; color: "cyan"}
        }
        Column{
            spacing:10
            leftPadding:10
            rightPadding:10
            topPadding:10
            bottomPadding:10

            anchors.fill:parent
            RowLayout{
                spacing:25
                Layout.fillWidth: true

                Label {id:serialNum; text:"serialNum:"; horizontalAlignment: Qt.AlignCenter}
                Label {id:dispSerialNum; text:"21352132132";horizontalAlignment:Qt.AlignRight; background:Item{Rectangle {anchors.fill: parent; color: "gray"; }}}
            }

            GroupBox{
                spacing:5
                width:parent.width - 20

                GridLayout{
                    rows: 5
                    columns: 2
                    Layout.fillWidth: true

                    Label {text:qsTr("board detection"); font{pixelSize:20 }color:"brown"; width:300;background:Item{Rectangle{anchors.fill:parent; color:"gray"}} Layout.columnSpan:2;}

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
               width: parent.width - 20

                GridLayout{
                    rows: 3
                    columns: 3
                    columnSpacing: 10
                    Layout.fillWidth:true

                    Label {id:boardSize; text:"board Size"; font{pixelSize:20; family:"Ubuntu"} Layout.columnSpan: 3}

                    Label {id:boardWidth; text:"boardWidth:"; Layout.alignment: Qt.AlignLeft}
                    Label {id:dispBoardWidth; text:"100.000"; Layout.fillWidth:true; Layout.alignment: Qt.AlignHCenter}
                    Label {id:widthUnit; text:"mm"; Layout.alignment: Qt.AlignRight}

                    Label {id:boardHeight; text:"boardHeight:"}
                    Label {id:dispBoardHeight; text:"0.0"}
                    Label {id:heightUnit; text:"mm"}
                }
            }
            NetworkStatus{
                id:networkStatus
                width:parent.width;
                anchors.top:widthAndHeight.bottom
                run:true
            }
        }


        Connections{
            target:network
            onRefresh:{
                root.okCount=network.getBoardOK();
                root.ngCount=network.getBoardNG();
                root.totalCount=network.getBoardTotal();
                serialNum=network.getSerialNum();
                boardWidth=network.getBoardWidth();
                dispOKCount.text=root.okCount;
                dispNgCount.text=root.ngCount;
                dispTotalCount.text=root.totalCount;
                dispRate.text=(root.okCount / root.totalCount).toFixed(2);
                console.log("actived");
            }
        }

        Connections{
            target:network
            onNetworkStateChanged:{

            }
        }

        MouseArea{
            anchors.fill:parent
            onClicked:{
                network.setServerIP("192.168.0.76");
            }
        }

    }
}
