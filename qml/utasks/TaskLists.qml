import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1

Page {
    id: taskLists
    title: i18n.tr("Lists")
    anchors.fill: parent

    property variant itemsList;

    onItemsListChanged:
    {
        taskListsModel.clear()
        if(itemsList === undefined)
            return

        for(var i = 0; i < itemsList.length; ++i)
        {
            console.log("append:", itemsList[i]["title"], itemsList[i]["id"]);
            var item = itemsList[i]
            item["progression"] = true // Add arrow
            taskListsModel.append( item );
        }
    }

    ListModel {
        id: taskListsModel
        ListElement {
            title: "My"
            rate: 1.0
        }

        function getCurrency(idx) {
            return (idx >= 0 && idx < count) ? get(idx).currency: ""
        }

        function getRate(idx) {
            return (idx >= 0 && idx < count) ? get(idx).rate: 0.0
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent

        ListView {
            model: taskListsModel
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
