#include <QQmlContext>
#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "tasks_data_manager.h"
#include "taskssettings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("gsdstr");
    QCoreApplication::setOrganizationDomain("gsdstr.com");
    QCoreApplication::setApplicationName("UTasks");

    TasksSettings settings;
    TasksDataManager deleteTasksDataManager;

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("settings", &settings);
    viewer.rootContext()->setContextProperty("deleteTasksDataManager", &deleteTasksDataManager);
    viewer.setMainQmlFile(QStringLiteral("qml/utasks/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
