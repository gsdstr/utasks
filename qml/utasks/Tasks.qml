import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1

Page {
    id: tasks
    title: i18n.tr("Tasks")

    property variant itemsList;

    onItemsListChanged:
    {
        tasksModel.clear()
        if(itemsList === undefined)
            return

        for(var i = 0; i < itemsList.length; ++i)
        {
            console.log("append:", itemsList[i]["title"], itemsList[i]["id"]);
            var item = itemsList[i]
            item["progression"] = true // Add arrow
            tasksModel.append( item );
        }
    }

    ListModel {
        id: tasksModel
        ListElement {
            title: "My"
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent

        Column {
            Empty {
                TextArea {
                    text: i18n.tr("text")
                    anchors {
                        margins: units.gu(1)
                        fill: parent
                    }
                }
            }
            ListView {
                model: tasksModel
                anchors.fill: parent

                delegate: Standard {
                    text: title
                    onClicked: {
                        /*caller.currencyIndex = index
                    caller.input.update()
                    hide()*/
                    }
                }
            }
        }
    }

}
