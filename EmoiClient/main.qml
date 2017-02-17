import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import DjangoX.Emoi 1.0
import QtQuick.Layouts 1.3

Window {
    visible: true
    width: 340
    height: 680
    title: qsTr("emoi silly")
    id: root
    Component.onCompleted: {
        emoi.startServiceDiscovery();
    }

    Rectangle{
        id: loadingRect
        width: parent.width
        height:parent.height
        color:"#222244"
        visible:true
        BusyIndicator{
            id:busyIndicator
            anchors.centerIn: parent
            running: true
        }

        Text{
            id:loadingText
            width:parent.width
            font.pointSize: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Screen.pixelDensity * 20
            text:"正在搜索Emoi设备..."
            horizontalAlignment: Text.AlignHCenter
            color:"white"
        }
    }

    Rectangle{
        id: mainRect
        visible:false
        anchors.fill: parent
        color:"#222244"

        Rectangle{
            id: colorRect
            property color darkColor: "#010101"//最暗色
            property color normalColor //正常色
            width: Screen.pixelDensity * 40
            height:width
            radius: width/2
            color:"white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Screen.pixelDensity * 10
            state:"normal"
            states:[
                State{
                    name: "normal"
                    PropertyChanges {
                        target: colorRect
                        color: normalColor
                    }
                },
                State{
                    name: "dark"
                    PropertyChanges{
                        target: colorRect
                        color: darkColor
                    }
                }
            ]
            transitions:[
                Transition {
                    from: "normal"
                    to: "dark"
                    ColorAnimation {
                        duration: breathSlider.value * 500;
                    }
                },
                Transition {
                    from: "dark"
                    to: "normal"
                    ColorAnimation {
                        duration: breathSlider.value * 500;
                    }
                }
            ]
            onColorChanged: {
                if(breathSwitch.checked)
                {
                    if(color == darkColor)
                    {
                        state = "normal"
                    }
                    if(color == normalColor)
                    {
                        state = "dark"
                    }
                }
            }
        }

        RowLayout{
            id: randomRow
            anchors.top: colorRect.bottom
            anchors.topMargin: Screen.pixelDensity * 10
            width: parent.width - Screen.pixelDensity * 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Slider{
                id: randomSlider
                Layout.fillWidth: true
                stepSize: 0.1
                from:0.1
                to:1.5
                value: 0.5;
            }

            Switch{
                id: randomSwitch
                text: "闪烁"
                checked: false
                onCheckedChanged: {
                    if(checked == true)
                    {
                        randomTimer.running = true;
                        breathSwitch.checked = false;
                        breathTimer.running = false;
                        colorRect.state = "normal"
                    }
                    else
                    {
                        randomTimer.running = false;
                    }
                }

                contentItem: Text {
                    text: randomSwitch.text
                    font: randomSwitch.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: randomSwitch.indicator.width + randomSwitch.spacing
                }
            }
        }

        RowLayout{
            id: breathRow
            anchors.top: randomRow.bottom
            anchors.topMargin: Screen.pixelDensity * 10
            width: parent.width - Screen.pixelDensity * 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Slider{
                id: breathSlider
                Layout.fillWidth: true
                stepSize: 0.1
                from:1
                to:15
                value: 2;
            }

            Switch{
                id: breathSwitch
                text: "呼吸"
                checked: false
                onCheckedChanged: {
                    if(checked == true)
                    {
                        randomSwitch.checked = false;
                        randomTimer.running = false;
                        colorRect.normalColor = colorRect.color
                        breathTimer.running = true;
                        if(colorRect.state == "dark")
                        {
                            colorRect.state = "normal"
                        }
                        else
                        {
                            colorRect.state = "dark"
                        }
                    }
                    if(checked == false)
                    {
                        breathTimer.running = false;
                    }
                }

                contentItem: Text {
                    text: breathSwitch.text
                    font: breathSwitch.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: breathSwitch.indicator.width + breathSwitch.spacing
                }
            }
        }

        Rectangle{
            id: infoRect
            width:parent.width
            height:{
                var h = parent.height - colorRect.height - randomRow.height - breathRow.height - 40 * Screen.pixelDensity;
                if(h <= Screen.pixelDensity * 50)
                {
                    return h;
                }
                else
                {
                    return Screen.pixelDensity * 50;
                }
            }

            color:"#e91e63"
            anchors.bottom: parent.bottom

            Text{
                width:parent.width - Screen.pixelDensity * 20
                height:parent.height
                color:"white"
                font.pointSize: 16
                lineHeight: 1.5
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                text:"<i>这是一款开源软件<br>项目主页: bullteacher.com/opensource<br>Develop by <b>DjangoX</b></i>"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("http://bullteacher.com/opensource");
                    }
                }
            }
        }

        RowLayout{
            id: spaceRow
            anchors.top: infoRect.top
            anchors.topMargin:0
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0
            Repeater{
                width: parent.width
                model:21
                Rectangle{
                    width: spaceRow.width/21
                    height:spaceRow.width/21
                    //radius:spaceRow.width/80
                    x: spaceRow.width/21 * index
                    color:{
                        if(index%2 == 0)
                        {
                            return "#e91e63";
                        }
                        else
                        {
                            return "#222244"
                        }
                    }
                }
            }
        }
    }


    EmoiBluetooth{
        id:emoi
        onEmoiFinded: {
            loadingText.text = "发现Emoi设备,正在连接..."
        }
        onEmoiConnected:{
            emoi.setColor();
            loadingRect.visible = false
            mainRect.visible = true
        }
        onEmoiGenColor:{
            colorRect.color = color;
        }
    }

    Timer {
        id:randomTimer
        interval: randomSlider.value * 1000;
        running: false;
        repeat: true
        onTriggered:{
            emoi.setColor();
        }
    }

    Timer {
        id:breathTimer
        interval: 10;
        running: false;
        repeat: true
        onTriggered:{
            emoi.setColor(colorRect.color);
        }
    }

}
