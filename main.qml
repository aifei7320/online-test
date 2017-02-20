import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import com.shelly 1.0

ApplicationWindow {
    visible: true
    width: Screen.desktopAvailableWidth > 600 ? 300 : Screen.desktopAvailableWidth
    height: Screen.desktopAvailableWidth > 600 ? 400 : Screen.desktopAvailableHeight
    title: qsTr("online-test")

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1 {
            x: 0
            y: 0
        }
        Rectangle{
            x: 301
            y: 0
            Network{
                id:network
            }

            Text{id:ipedit; anchors.verticalCenter: parent.verticalCenter}
            Text{id:portedit; anchors.top:ipedit.bottom}
            Connection{
                id:ipconfig
                onSetIP:{ipedit.text=ip; portedit.text=port}
            }
        }

    }

    footer: TabBar {
        id: tabBar
        height:20

        currentIndex: swipeView.currentIndex
        TabButton {
            height:20
            background:Item{Rectangle{anchors.fill:parent; color:"cyan"}}
            text: qsTr("First")
            font{fontColor:"red"}
        }
        TabButton {
            height:20
            background:Item{Rectangle{anchors.fill:parent; color:"cyan"}}
            text: qsTr("Charts")
        }
    }
}
