var client_id = "798148107527.apps.googleusercontent.com";
var client_secret = "qFgvFoLZEQpo_cgOo9umIYCE";
var redirect_uri = "http://localhost";


function urlChanged(url) {
    console.log("urlChanged!!!");
    var mUrl = url.toString();

    console.log('mUrl = ', mUrl);

    var access_token = "";
    var code = "";
    if (mUrl.indexOf(redirect_uri) > -1)
    {
        var query = mUrl.substring(mUrl.indexOf('?') + 1);
        var vars = query.split("&");
        for (var i=0;i<vars.length;i++) {
            var pair = vars[i].split("=");
            if (pair[0] === "access_token") {
                access_token = pair[1];
            }
            if (pair[0] === "code") {
                code = pair[1];
            }
        }
    }

    console.log("Found access_token = ", access_token);
    console.log("Found code = ", code);

    if(access_token != "")
    {
        google_oauth.accessToken = access_token;
    }
    if(code != "")
    {
        requestPermanentToken(code);
    }

}

function requestPermanentToken(code)
{
    var req = new XMLHttpRequest();
    req.onreadystatechange = function() {
        console.log("req.readyState", req.readyState);
        if(req.readyState == 4){
            //console.log("Status, headers", req.status, req.getAllResponseHeaders());
        }
        if (req.readyState == 4 && req.status == 200){
            //console.log("response headers:\n", req.getAllResponseHeaders());
            //console.log("req.readyState == 4", req.readyState, req.status);
            console.log("responseText", req.responseText);
            var result = eval('(' + req.responseText + ')');
            google_oauth.accessToken = result["access_token"];
            tasks.refreshToken = result["refresh_token"];
            onLoginDone()
        }
    }
    req.open("POST", "https://accounts.google.com/o/oauth2/token", true);
    req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    req.send("client_id=" + client_id +
             "&redirect_uri=" + redirect_uri +
             "&client_secret=" + client_secret +
             "&grant_type=authorization_code" +
             "&code=" + code);
}

function refreshAccessToken(refresh_token)
{
    console.log("called refreshAccessToken", refresh_token)
    var req = new XMLHttpRequest();
    req.onreadystatechange = function() {
        console.log("req.readyState", req.readyState);
        if(req.readyState == 4)
        {
            //console.log("Status, headers", req.status, req.getAllResponseHeaders());
        }
        if (req.readyState == 4 && req.status == 200)
        {
            //console.log("response headers:\n", req.getAllResponseHeaders());
            //console.log("req.readyState == 4", req.readyState, req.status);
            console.log("responseText", req.responseText);
            var result = eval('(' + req.responseText + ')');
            google_oauth.accessToken = result["access_token"];
        }
    }
    req.open("POST", "https://accounts.google.com/o/oauth2/token", true);
    req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    req.send("client_id=" + client_id +
             "&client_secret=" + client_secret +
             "&grant_type=refresh_token" +
             "&refresh_token=" + refresh_token);
}
