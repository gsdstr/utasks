import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1

import "tasks_data_manager.js" as TasksDataManager

Page {
    id: taskLists
    title: i18n.tr("Lists")
    anchors.fill: parent

    property variant curItem;
    property variant itemsList;
    signal itemClicked();

    onItemsListChanged: {
        taskListsModel.clear()
        if(itemsList === undefined)
            return

        for(var i = 0; i < itemsList.length; ++i)
        {
            console.log("append:", itemsList[i]["title"], itemsList[i]["id"]);
            var item = itemsList[i]
            taskListsModel.append( item ); //добавляем элемент в модель
        }
    }

    ListModel {
        id: taskListsModel
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
                placeholderText: i18n.tr("New list")
                width: parent.width - addButton.width - units.gu(1)
            }

            Button {
                id: addButton
                text: i18n.tr("Add")
                onClicked: {
                    if (text === i18n.tr("Add")){
                        TasksDataManager.createList(newField.text)
                        newField.text = ''
                        TasksDataManager.getMyTaskLists()
                    } else { //edit
                        curItem.title = newField.text
                        console.log("onPressAndHold: ", curItem["title"], curItem["id"])
                        TasksDataManager.updateTaskList(curItem["id"], curItem)
                        //TasksDataManager.getMyTaskLists()

                        addButton.text = i18n.tr("Add")
                        newField.text = ''
                        curItem.selected = false
                    }
                }
            }
        }

        ListView {//лист
            id: taskListsView
            model: taskListsModel
            anchors.top: newItem.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            delegate: Editable {
                text: title //от куда берется название
                progression: true //стрелка справа
                onClicked: {
                    console.log("index: ", index);
                    taskListsView.currentIndex = index
                    curItem = taskListsModel.get(index)
                    itemClicked()
                }

                onItemRemoved: {
                    var item = taskListsModel.get(index)
                    TasksDataManager.deleteList(item["id"])
                    //TasksDataManager.getMyTaskLists()
                }
                onPressAndHold: {
                    var item = taskListsModel.get(index)
                    selected  = true
                    addButton.text = i18n.tr("Edit")
                    newField.text = title
                    curItem = taskListsModel.get(index)
                }
            }
        }
    }
}
