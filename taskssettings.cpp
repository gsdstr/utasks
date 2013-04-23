#include "taskssettings.h"

TasksSettings::TasksSettings(QObject *parent) :
    QObject(parent){
}


QString TasksSettings::getValueFor(const QString &objectName){
    return _settings.value(objectName, "").toString();
}

void TasksSettings::setValueFor(const QString &objectName, const QString &value){
   _settings.setValue(objectName, QVariant(value));
}
