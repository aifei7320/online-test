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
            state = "Unconnected";
            break;
        case Network.BoundState:
            break;
        case Network.ListeningState:
            break;
        case Network.HostLookupState:
            break;
        case Network.ConnectingState:
            state = "Connecting";
            break;
        case Network.ConnectedState:
            state = "Connected";
            break;
        case Network.ClosingState:
            state = "Closing";
            break;

        }
        stateText.text=state;
    }

    onStateNumChanged:{
        console.log("actvied")
        stateChange(stateNum)
    }

    Rectangle{
        id: container;

        width:parent.width;
        height:parent.height;

        Text{id:stateText; text:"Nothing"; x:100}

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
