#include <QQmlContext>
#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "taskssettings.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("gsdstr");
    QCoreApplication::setOrganizationDomain("gsdstr.com");
    QCoreApplication::setApplicationName("UTasks");

    TasksSettings settings;

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("settings", &settings);
    viewer.setMainQmlFile(QStringLiteral("qml/utasks/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
