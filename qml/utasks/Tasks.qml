import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1

import "tasks_data_manager.js" as TasksDataManager

Page {
    id: tasks
    title: i18n.tr("Tasks")

    property variant curItem;
    property variant itemsList;
    property variant listId;

    onItemsListChanged:
    {
        tasksModel.clear()
        if(itemsList === undefined)
            return

        for(var i = 0; i < itemsList.length; ++i)
        {
            console.log("append:", itemsList[i]["title"], itemsList[i]["id"]);
            var item = itemsList[i]
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
        //clip: true

        Row {
            spacing: units.gu(1)
            id: newItem
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: units.gu(1)

            TextField {
                id: newField
                placeholderText: i18n.tr("New task")
                width: parent.width - addButton.width - units.gu(1)
            }

            Button {
                id: addButton
                text: i18n.tr("Add")
                onClicked: {
                    if (text === i18n.tr("Add")){
                        TasksDataManager.createTask(listId, newField.text, undefined, undefined)
                        newField.text = ''
                        TasksDataManager.getMyTaskLists()
                    } else { //edit
                        curItem.title = newField.text
                        console.log("onPressAndHold: ", curItem["title"], curItem["id"])
                        TasksDataManager.updateTask(listId, curItem["id"], curItem)
                        //TasksDataManager.getMyTaskLists()

                        addButton.text = i18n.tr("Add")
                        newField.text = ''
                        curItem.selected = false
                    }
                }
            }
        }

        ListView {
            id: tasksView
            model: tasksModel
            anchors.top: newItem.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            delegate: Editable {
                text: title //от куда берется название
                onClicked: {
                    console.log("index: ", index);
                    tasksView.currentIndex = index
                    curItem = tasksModel.get(index)
                    itemClicked()
                }

                onItemRemoved: {
                    var item = tasksModel.get(index)
                    TasksDataManager.deleteTask(item["id"])
                }
                onPressAndHold: {
                    var item = tasksModel.get(index)
                    selected  = true
                    addButton.text = i18n.tr("Edit")
                    newField.text = title
                    curItem = tasksModel.get(index)
                }
            }
        }
    }
}
