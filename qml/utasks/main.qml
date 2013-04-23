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
                tasks.refreshToken = refreshToken

                console.log("refreshToken = ", refreshToken)

                settings.setValueFor("accessToken", accessToken)
                settings.setValueFor("refreshToken", refreshToken)

                //TasksDataManager.getMyTaskLists()
            }
        }

    }

    Component.onCompleted: {
        console.log("onCompleted")
        //if (tasks.refreshToken === "") {
        if (settings.getValueFor("refreshToken") === "") {
            pageStack.push(google_oauth)
            console.log("google_oauth")
            google_oauth.login()
        } else {
            pageStack.push(tasks)
            google_oauth.refreshAccessToken(settings.getValueFor("refreshToken"))
        }
    }

}
