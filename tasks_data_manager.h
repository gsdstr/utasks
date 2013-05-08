#ifndef TASKS_DATA_MANAGER_H
#define TASKS_DATA_MANAGER_H

#include <QObject>

//#include <QVariantList>
//#include <QStringList>

#include <QNetworkReply>
#include <QNetworkAccessManager>

class TasksDataManager : public QObject
{
    Q_OBJECT
public:
    explicit TasksDataManager(QObject *parent = 0);

/*
    //Requests to Google API service.
    void getMyTaskLists(const QString& access_token);
    void getMyTasks(const QString& access_token, const QString& taskListID);
    void createTask(const QString& access_token, const QString& taskListID, const QString& title,
                    const QString& prevTaskID,   const QString& parentID);
    void updateTask(const QString& access_token, const QString& taskListID, const QString& taskID, const QVariant& json_object);
    void createList(const QString& access_token, const QString& title);

    void moveTask(
            const QString& access_token, const QString& taskListID, const QString& taskID,
            const QString& prevTaskID,   const QString& parentID);
*/
    Q_INVOKABLE
    void deleteList(const QString& access_token, const QString& taskListID);
    Q_INVOKABLE
    void deleteTask(const QString& access_token, const QString& taskListID, const QString& taskID);
/*
    //Getting currently read taskLists and tasks.
    QVariantList getTaskLists();
    QVariantList getTasks();

    void startMoving();
    void endMoving();
*/
signals:
//    void taskListsReady();
//    void tasksReady();
//    void errorOccured(const QString& error);
    void taskChanged();
    void listsChanged();

private slots:
    void replyDeleteFinished(QNetworkReply * reply);
//    void replyFinished(QNetworkReply*);

private:
//    QVariantList m_taskLists;
//    QVariantList m_tasks;
    QNetworkAccessManager * m_pNetworkAccessManager;
/*
    QStringList m_moveRequests;
    QString m_strLastMoveRequest;
    //Flag that shows that there are several move requests to be done. While moving, we do not send
    //taskChanged() signals, only accumulate requests.
    bool m_bInMoving;
*/
};

#endif // TASKS_DATA_MANAGER_H
