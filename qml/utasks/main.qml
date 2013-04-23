import QtQuick 2.0
import Ubuntu.Components 0.1


MainView {
    objectName: "mainView"
    applicationName: "UTasks"
    id: root

    width: units.gu(60)
    height: units.gu(80)

    PageStack {
        id: pageStack
        Component.onCompleted: push(tasks)

        Tasks {
            id: tasks
        }

        GoogleOAuth {
            id: google_oauth

            onLoginDone: {
                pageStack.push(tasks)
                console.log("Login Done")
                tasks.accessToken = google_oauth.accessToken
                TasksDataManager.getMyTaskLists()
            }
        }

    }

    Component.onCompleted: {
        console.log("onCompleted")
        if (tasks.refreshToken === "") {
            pageStack.push(google_oauth)
            console.log("google_oauth")
            google_oauth.login()
        } else {
            google_oauth.refreshAccessToken(settingsManager.refreshToken)
        }
    }

}
