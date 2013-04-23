import QtQuick 2.0
import Ubuntu.Components 0.1

import "tasks_data_manager.js" as TasksDataManager

MainView {
    objectName: "mainView"
    applicationName: "UTasks"
    id: root

    width: units.gu(60)
    height: units.gu(80)

    PageStack {
        id: pageStack
        Component.onCompleted: push(taskLists)

        TaskLists {
            id: taskLists
            visible: false

            onItemClicked: {
                var item = taskLists.curItem
                console.log("onItemClicked: ", item)
                tasks.title = item["title"]
                TasksDataManager.getMyTasks(item["id"])
                pageStack.push(tasks)
            }
        }

        Tasks {
            id: tasks
            visible: false
        }

        GoogleOAuth {
            id: google_oauth
            visible: false

            onLoginDone: {
                pageStack.clear()
                pageStack.push(taskLists)
                console.log("Login Done")
                //tasks.refreshToken = refreshToken

                settings.setValueFor("accessToken", accessToken)
                settings.setValueFor("refreshToken", refreshToken)

                TasksDataManager.getMyTaskLists()
            }
        }

    }

    Component.onCompleted: {
        console.log("onCompleted")
        if (settings.getValueFor("refreshToken") === "") {
            pageStack.push(google_oauth)
            console.log("google_oauth")
            google_oauth.login()
        } else {
            pageStack.push(taskLists)
            google_oauth.refreshAccessToken(settings.getValueFor("refreshToken"))
        }
    }

}
