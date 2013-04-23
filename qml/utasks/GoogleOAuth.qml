import QtQuick 2.0
import QtWebKit 3.0
import Ubuntu.Components 0.1
import "google_oauth.js" as OAuth

Page {
    id: google_oauth
    title: i18n.tr("Login")
    anchors.fill: parent

    property string oauth_link: "https://accounts.google.com/o/oauth2/auth?" +
                                "client_id=" + OAuth.client_id +
                                "&redirect_uri=" + OAuth.redirect_uri +
                                "&response_type=code" +
                                "&scope=https://www.googleapis.com/auth/tasks" +
                                "&access_type=offline" +
                                "&approval_prompt=force"

    property bool authorized: accessToken != ""
    property string accessToken: ""
    property string refreshToken: ""
    signal loginDone();

    onAccessTokenChanged: {
        console.log('onAccessTokenChanged');
        if(accessToken != ''){
            console.log("accessToken = ", accessToken)
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

    Flickable {
        id: web_view_window

        property bool loading:  false;
        anchors.fill: parent

        WebView {
            id: loginView
            anchors.fill: parent

            onUrlChanged: OAuth.urlChanged(url)
        }
    }

}
