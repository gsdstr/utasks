//Data              Method      REST URI relative to https://www.googleapis.com/tasks/v1        Access
//Task Collection Task Resource

//1  tasks.list        GET     /lists/tasklist/tasks            AUTHENTICATED - ok
//2  tasks.get         GET     /lists/tasklist/tasks/task       AUTHENTICATED - ok - getTask
//3  tasks.insert      POST    /lists/tasklist/tasks            AUTHENTICATED - ok - createTask
//4  tasks.update      PUT     /lists/tasklist/tasks/task       AUTHENTICATED - ok - updateTask
//5  tasks.delete      DELETE  /lists/tasklist/tasks/task       AUTHENTICATED - ok (via DeleteTasksDataManager) - deleteTask
//6  tasks.move        POST    /lists/tasklist/tasks/task/move  AUTHENTICATED - ok - moveTask
//7  tasks.clear       POST    /lists/tasklist/clear            AUTHENTICATED - ok - clearTasks

//Tasklist Collection Tasklist Resource

//8  tasklists.list     GET     /users/@me/lists                AUTHENTICATED - ok - getMyTaskLists
//9  tasklists.get      GET     /users/@me/lists/tasklist       AUTHENTICATED - untested - getTaskList (not used)
//10 tasklists.insert   POST    /users/@me/lists                AUTHENTICATED - ok - createList
//11 tasklists.update   PUT     /users/@me/lists/tasklist       AUTHENTICATED - ok - updateTaskList
//12 tasklists.delete   DELETE  /users/@me/lists/tasklist       AUTHENTICATED - ok (via DeleteTasksDataManager)  - deleteList


function handleRequest(options)
{
    var req = new XMLHttpRequest();

    req.onreadystatechange = function()
    {
        if( req.readyState == 4 )
        {
            console.log("1) response headers:\n", req.getAllResponseHeaders());
            console.log("2) responseText", req.responseText);

            if(req.status == 200)
            {
                var result = eval('(' + req.responseText + ')')
                if(result["kind"] == "error")
                {
                    console.log("Error occured", result)
                } else {
                    if( options["onload"] ) options["onload"]( result );
                    else console.log("Error occured", "options haven't function: onload");
                }
            }
            else if(req.status == 204) // No Content
            {
                if( options["onload"] ) options["onload"]();
                else console.log("Error occured", "options haven't function: onload");
            } else {
                console.log("3) response status:", req.status);
                console.log("4) status text:", req.statusText);
            }
        }
    }

    console.log("opening:", options["method"], options["url"], options["params"]);

    req.open( options["method"], options["url"], true );

    if( options["params"] !== undefined )
    {
        req.setRequestHeader("Content-Type", "application/json");
        req.setRequestHeader("Content-length", options["params"].length);
        req.setRequestHeader("Connection", "close");
    }

    req.send( options["params"] );
}


function getMyTaskLists()
{
    console.log("getMyTaskLists called");

    handleRequest({
        "method": "GET",
        "url": "https://www.googleapis.com/tasks/v1/users/@me/lists?access_token=" + google_oauth.accessToken,
        "onload": function(result) {
            taskLists.itemsList = result["items"];
        }
    });
}


function createList(listTitle)
{
    console.log("createList called");

    handleRequest({
        "method": "POST",
        "url": "https://www.googleapis.com/tasks/v1/users/@me/lists?access_token=" + google_oauth.accessToken,
        "params": "{ title: \"" + listTitle + "\" }",
        "onload": getMyTaskLists
    });
}

function deleteList(taskListID)
{
    console.log("deleteList called");

    deleteTasksDataManager.deleteList(google_oauth.accessToken, taskListID);

//    handleRequest({
//        "method": "DELETE",
//        "url": "https://www.googleapis.com/tasks/v1/users/@me/lists/" + taskListID + "?access_token=" + google_oauth.accessToken,
//        "onload": getMyTaskLists
//    });
}

function getMyTasks(taskListID)
{
    console.log("getMyTasks called");

    handleRequest({
        "method": "GET",
        "url": "https://www.googleapis.com/tasks/v1/lists/"+ taskListID +"/tasks?&access_token=" + google_oauth.accessToken,
        "onload": function(result) { tasks.itemsList = result["items"]; }
    });
}

function deleteTask(taskListID, taskID)
{
    console.log("deleteTask called");

    deleteTasksDataManager.deleteTask(google_oauth.accessToken, taskListID, taskID);

//    handleRequest({
//        "method": "DELETE",
//        "url": "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/tasks/" + taskID + "?access_token=" + google_oauth.accessToken,
//        "onload": function() { getMyTasks(taskListID); }
//    });
}

function createTask(taskListID, title, prevTaskID, parentID)
{
    console.log("createTask called");

    var url = "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/tasks?access_token=" + google_oauth.accessToken;

    if( prevTaskID !== undefined && prevTaskID.length ) url += "&previous=" + prevTaskID
    if( parentID !== undefined   && parentID.length   ) url += "&parent=" + parentID

    handleRequest({
        "method": "POST",
        "url": url,
        "onload": function() { getMyTasks(taskListID); },
        "params": "{ title: \"" + title + "\" }"
    });
}

function updateTask(taskListID, taskID, json_object)
{
    console.log("updateTask called");

    var url = "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/tasks/" + taskID + "?access_token=" + google_oauth.accessToken;

    handleRequest({
        "method": "PUT",
        "url": url,
        "onload": function(result)
        {
            if( result["kind"] == "tasks#task" )
                taskEditScreen.setItem( result ) // reload data in TaskEditScreen
            getMyTasks(taskListID); // reloading data model
        },
        "params": JSON.stringify(json_object)
    });
}

function updateTaskWithoutRefresh(taskListID, taskID, json_object)
{
    console.log("***updateTaskWithoutRefresh called");

    var url = "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/tasks/" + taskID + "?access_token=" + google_oauth.accessToken;

    handleRequest({
        "method": "PUT",
        "url": url,
        "onload": function(result) { console.log("***updateTaskWithoutRefresh callback result: ", result); },
        "params": JSON.stringify(json_object)
    });
}

function getTask(taskListID, taskID)
{
    console.log("getTask called");

    var url = "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/tasks/" + taskID + "?access_token=" + google_oauth.accessToken;
    handleRequest({
        "method": "GET",
        "url": url,
        "onload": function( result ) { taskEditScreen.setItem( result ) }
    });
}

function updateTaskList(taskListID, json_object)
{
    console.log("updateTaskList called");

    var url = "https://www.googleapis.com/tasks/v1/users/@me/lists/" + taskListID + "?access_token=" + google_oauth.accessToken;
    handleRequest({
        "method": "PUT",
        "url": url,
        "onload": getMyTaskLists,
        "params": JSON.stringify(json_object)
    });
}

function moveTask(taskListID, taskID, prevTaskID, parentID)
{
    console.log("moveTask called", taskListID, taskID, prevTaskID, parentID);

    var url = "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/tasks/" + taskID + "/move?access_token=" + google_oauth.accessToken;

    if( prevTaskID !== undefined && prevTaskID.length ) url += "&previous=" + prevTaskID
    if( parentID !== undefined   && parentID.length   ) url += "&parent=" + parentID

    handleRequest({
        "method": "POST",
        "url": url,
        "onload": function() { getMyTasks(taskListID); },
        "params": "{ king: \"tasks#tasks\" }"
    });
}

//Clears all completed tasks from the specified task list. The affected tasks are marked as hidden and are no longer returned
//by default when retrieving all tasks for a task list. Returns no data (only a status code).
function clearTasks(taskListID)
{
    console.log("clearTasks called");

    var url = "https://www.googleapis.com/tasks/v1/lists/" + taskListID + "/clear?access_token=" + google_oauth.accessToken;

    handleRequest({
        "method": "POST",
        "url": url,
        "onload": function() { listPage.showInfoMessage("List cleared") },
        "params": "{ king: \"tasks#taskList\" }"
    });
}

function getTaskList(taskListID)
{
    console.log("getTaskList called");

    var url = "https://www.googleapis.com/tasks/v1/users/@me/lists/" + taskListID + "?access_token=" + google_oauth.accessToken;
    handleRequest({
        "method": "GET",
        "url": url,
        "onload": function() { console.log("tasks_data_manager.js", "function: getTaskList(taskListID)", "onload function not specified") }
    });
}
