import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    anchors.fill: parent
    color: mainPalette.listBackground

    property real sectionMargin: Math.max(2 * shadowWidth, 12)
    property real headerHeight: 32
    property real itemHeight: 64
    property real shadowWidth: 9

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        TimerView {
            Layout.fillWidth: true
            height: 64
            z: 1
        }

        ScrollView {
            id: timeEntryList
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            property real viewportWidth: viewport.width
            ListView {
                id: timeEntryListView
                model: toggl.timeEntries
                section.property: "modelData.DateHeader"
                section.delegate: TimeEntryListHeader {
                    height: headerHeight + sectionMargin
                    width: parent.width
                    Rectangle {
                        z: 1
                        anchors.fill: parent
                        visible: opacity > 0.0
                        opacity: timeEntryListView.itemExpanded ? 0.5 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }
                        color: "dark gray"
                        MouseArea { anchors.fill: parent }
                    }
                }

                function gotoIndex(idx) {
                    anim.running = false;

                    var pos = timeEntryListView.contentY;
                    var destPos;

                    timeEntryListView.positionViewAtIndex(idx, ListView.Beginning);
                    destPos = timeEntryListView.contentY;

                    anim.from = pos;
                    anim.to = destPos;
                    anim.running = true;
                }
                NumberAnimation { id: anim; target: timeEntryListView; property: "contentY"; duration: 120 }

                property bool itemExpanded: false

                delegate: TimeEntryListItem {
                    timeEntry: modelData
                    listView: timeEntryListView
                    //index: index
                }

                add: Transition {
                    id: addTransition
                    NumberAnimation {
                        properties: "y"
                        from: addTransition.ViewTransition.destination.y - itemHeight
                        duration: 120
                    }
                }
                addDisplaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 120
                    }
                }

                moveDisplaced: Transition {
                    NumberAnimation {
                        from: -height
                        properties: "y"
                        duration: 120
                    }
                }

                move: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 120
                    }
                }

                remove: Transition {
                    ParallelAnimation {
                        NumberAnimation {
                            duration: 120
                            properties: "opacity"
                            from: 1.0
                            to: 0.0
                        }
                        NumberAnimation {
                            duration: 120
                            properties: "x"
                            from: 0
                            to: width
                        }
                    }
                }
                removeDisplaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 120
                    }
                }
            }
        }
    }
}
