import QtQuick 2.0
import QtQuick 2.7
import com.shelly 1.0
import QtQuick.Controls 2.1

Item {
    id: root;

    property string state;
    property int stateNum;
    property bool run;

    function stateChange(s){
        switch (s){
        case Network.UnconnectedState:
            state = "链接已断开";
            stateText.color="red";
            run=false;
            break;
        case Network.BoundState:
            break;
        case Network.ListeningState:
            break;
        case Network.HostLookupState:
            break;
        case Network.ConnectingState:
            state = "正在连接";
            break;
        case Network.ConnectedState:
            state = "已连接";
            stateText.color="green";
            run=true;
            break;
        case Network.ClosingState:
            state = "正在关闭";
            break;

        }
        stateText.text=state;
        console.log("actvied change")
    }

    onStateNumChanged:{
        stateChange(stateNum)
    }

    Rectangle{
        id: container;

        width:parent.width;
        height:parent.height;
        anchors.top:parent.top
        anchors.bottom:parent.bottom

        Text{id:stateText; text:state; x:100}

        SequentialAnimation{
            id:first
            running:run
            loops:Animation.Infinite

            NumberAnimation {
                target: stateText
                property: "x"
                to: parent.width - 100
                duration: 4000
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: stateText
                property: "x"
                to: 30
                duration: 4000
                easing.type: Easing.InOutQuad
            }
        }
    }
}
