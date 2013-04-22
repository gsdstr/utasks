import QtQuick 2.0
import QtWebKit 3.0
import Ubuntu.Components 0.1
import "google_oauth.js" as OAuth

Rectangle {
    id: google_oauth
    width:  400
    height: 400
    color: "#343434";
    property string oauth_link: "https://accounts.google.com/o/oauth2/auth?" +
                                "client_id=" + OAuth.client_id +
                                "&redirect_uri=" + OAuth.redirect_uri +
                                "&response_type=code" +
                                "&scope=https://www.googleapis.com/auth/tasks" +
                                "&access_type=offline" +
                                "&approval_prompt=force"

    property bool authorized: accessToken != ""
    property string accessToken: ""
    signal loginDone();

    onAccessTokenChanged: {
        console.log('onAccessTokenChanged');
        if(accessToken != '')
        {
            console.log("accessToken = ", accessToken)
            textEditToHideKeyboard.closeSoftwareInputPanel();
            loginDone();
        }
    }


    function login()
    {
        loginView.url = oauth_link
    }

    function refreshAccessToken(refresh_token)
    {
        OAuth.refreshAccessToken(refresh_token)
    }

   /* HeaderRectangle {
        id: oAuthToolbar
        anchors { left:  parent.left; right: parent.right; top: parent.top }

        TextEdit{
            id: textEditToHideKeyboard
            visible: false
            width: 40;
            height: 40
            anchors { left:hideKeyboardButton.right; verticalCenter: parent.verticalCenter}
        }

        Text {
            id: titleText
            text: "Login"
            anchors { left: parent.left; right: hideKeyboardButton.left; verticalCenter: parent.verticalCenter }
            color: "white"
            font.pixelSize: 28
            font.bold: true;
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            id: hideKeyboardButton
            text: "Hide Keyboard"
            width: 200
            height: 40
            anchors { right: closeButton.left; verticalCenter: parent.verticalCenter }
            onClicked: {
                console.log("Hide clicked");
                //textEditToHideKeyboard.focus = true;
                textEditToHideKeyboard.closeSoftwareInputPanel();
            }
        }

        Button {
            id: closeButton
            text: "Close"
            width: 120
            height: 40
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            onClicked: {
                textEditToHideKeyboard.closeSoftwareInputPanel();
                google_oauth.visible = false;
            }
        }
    }*/

    Flickable {
        id: web_view_window

        property bool loading:  false;
        anchors.fill: parent
        //anchors { top: oAuthToolbar.bottom; right: parent.right; left: parent.left; bottom: parent.bottom }

        contentWidth: Math.max(width,loginView.width)
        contentHeight: Math.max(height,loginView.height)
        clip: true

        WebView {
            id: loginView
            anchors.fill: parent

            /*preferredWidth: web_view_window.width
            preferredHeight: web_view_window.height
            contentsScale: 1.75

            url: ""*/
            onUrlChanged: OAuth.urlChanged(url)

            /*onLoadFinished: {
                console.log("onLoadFinished");
                busy_indicator.running = false;
                busy_indicator.visible = false;
            }

            onLoadStarted: {
                console.log("onLoadStarted");
                busy_indicator.running = true;
                busy_indicator.visible = true;
            }

            BusyIndicator {
                id: busy_indicator;
                running: false
                width:  100;
                height: 100;
                anchors.centerIn:  parent;
                visible: false
            }*/

        }
    }

    Component.onCompleted: {
        console.log("onCompleted")
        login()
    }

}
