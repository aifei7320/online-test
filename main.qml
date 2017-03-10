import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import com.shelly 1.0

ApplicationWindow {
    id:root
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableWidth
    title: qsTr("online-test")

    ListView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        focus: true
        Network{
            id:network
        }

        Connections{
            target:network
            onNetworkStateChanged:{
                page1.statenum = network.state()
                page2.statenum = network.state()
            }
        }
        Connections{
            target: network
            onRefresh:{
                page1.okCount = network.getBoardOK()
                page1.realLength = network.getRealBoardLength();
                page1.realWidth = network.getRealBoardWidth();
                page1.mwidth = network.getBoardWidth();
                page1.mlength = network.getBoardLength();
                page1.serialNumber = network.getSerialNum();
                page1.boardLengthMatch = network.getBoardLengthMatch()
                page1.boardWidthMatch = network.getBoardWidthMatch()
            }
        }
        Connections{
            target:network
            onBoardRefresh:{
                page2.okCount = network.getBoardOK();
                page2.ngCount = network.getBoardNG();
                page2.totalCount = network.getBoardTotal();
                page2.rate = page2.totalCount == 0 ? 0 : (page2.ngCount / page2.totalCount * 100).toFixed(2);
            }
        }

        Page1 {
            id: page1
            x: 0
            y: 0
            antialiasing: true
            scale: 1
            z: 1
            rotation: 0
            onConnect: {
                network.setDevice(dev)
                network.setServerIP(ip)
            }
            onDisconnect: {
                network.disconn();
            }
        }
        Connection{
            id:page2
            antialiasing: true
            x:root.width
            y:0
            onConnect:{
                network.setDevice(dev)
                network.setServerIP(ip)
            }
            onDisconnect: {
                network.disconn()
            }
        }
        Keys.onEscapePressed: {
            Qt.quit();
        }

        Keys.onPressed:{
            if ((event.key == Qt.Key_Q) && (event.modifiers & Qt.ControlModifier)){
                Qt.quit();
            }
            Keys.forwardTo[tabBar]
        }
        states:[
            State{
                name:"firstPage"; when:swipeView.currentIndex == 2;
                PropertyChanges{target:page2; x:root.width}
                PropertyChanges{target:page1; x:0}
            },
            State{
                name:"secondPage"; when:swipeView.currentIndex == 1;
                PropertyChanges{target:page2; x:0}
                PropertyChanges{target:page1; x:-root.width}
            }
        ]

        transitions: Transition {
            NumberAnimation{
                property: "x"
                easing.type: Easing.OutBack;
                duration:1000
            }
        }

    }
    //MouseArea{
    //    property int oldx
    //    anchors.fill:parent
    //    onPressed:{
    //        oldx = mouseX
    //    }

    //    onReleased: {
    //        if((mouseX - oldx) > 100){
    //            swipeView.currentIndex=2
    //            indicator.currentIndex=2
    //            tabBar.currentIndex=2
    //        }
    //        else if ((mouseX - oldx) < -100){
    //            swipeView.currentIndex=1
    //            indicator.currentIndex=2
    //            tabBar.currentIndex=2
    //        }
    //    }
    //}
    header:
        Label{
        id:title
        width:parent.width
        horizontalAlignment:Text.AlignHCenter
        text:"Online-test System"
        font{pixelSize:20; family:"Ubuntu"}
        color:"red"
        background: Rectangle{
            gradient:Gradient{
                GradientStop{position:0.0; color:"cyan"}
                GradientStop{position:1.0; color:"white"}
            }
        }
    }
    PageIndicator {
         id: indicator

         count: swipeView.count
         currentIndex: swipeView.currentIndex

         anchors.bottom: swipeView.bottom
         anchors.horizontalCenter: parent.horizontalCenter
     }

    footer: TabBar {
        id: tabBar
        visible:true
        height:40

        currentIndex: swipeView.currentIndex
        TabButton {
            height:40
            text: qsTr("First")
            background:Item{
                Rectangle{
                    anchors.fill:parent; color:"cyan"
                    gradient:Gradient{
                        GradientStop{position:0.0; color:"white"}
                        GradientStop{position:0.3; color:"cyan"}
                        GradientStop{position:0.7; color:"cyan"}
                        GradientStop{position:1.0; color:"white"}
                    }
                }
            }
        }
        TabButton {
            height:40
            background:Item{
                Rectangle{
                    anchors.fill:parent; color:"cyan"
                    gradient:Gradient{
                        GradientStop{position:0.0; color:"white"}
                        GradientStop{position:0.3; color:"cyan"}
                        GradientStop{position:0.7; color:"cyan"}
                        GradientStop{position:1.0; color:"white"}
                    }
                }
            }
            text: qsTr("Charts")
        }
        Keys.onPressed:{
            switch(event.key){
            case Qt.Key_Right:
                swipeView.page.x = -root.width
                swipeView.rect.x = 0
                break;
            case Qt.Key_Left:
                swipeView.rect.x = root.width
                swipeView.page.x = 0
                break;
            }
        }

        Keys.onEscapePressed: {
            Qt.quit();
        }
    }

}
