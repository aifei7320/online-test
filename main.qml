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

        focus: true

        Page1 {
            id: page
            x: 0
            y: 0
            antialiasing: true
            scale: 1
            z: 1
            rotation: 0
        }
        Rectangle{
            id: rect
            x: parent.width + 1
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
        Keys.onEscapePressed: {
            Qt.quit();
        }

        Keys.onPressed:{
            if ((event.key == Qt.Key_Q) && (event.modifiers & Qt.ControlModifier)){
                console.log("pressed");
                Qt.quit();
            }
            console.log("not in ")
        }
        states:[
            State{
                name:"firstPage"; when:swipeView.currentIndex == 2;
                PropertyChanges{target:rect; x:parent.width + 1}
                PropertyChanges{target:page; x:0}
            },
            State{
                name:"secondPage"; when:swipeView.currentIndex == 1;
                PropertyChanges{target:rect; x:0}
                PropertyChanges{target:page; x:0 - parent.width}
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


    footer: TabBar {
        id: tabBar
        height:20

        currentIndex: swipeView.currentIndex
        TabButton {
            height:20
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
            text: 'First'
        }
        TabButton {
            height:20
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
                currentIndex:currentIndex==1? 2: 1
                break;
            case Qt.Key_Left:
                currentIndex:currentIndex==1? 2: 1
                break;
            }
        }

        Keys.onEscapePressed: {
            Qt.quit();
        }
    }

}
