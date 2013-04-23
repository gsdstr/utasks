#ifndef TASKSSETTINGS_H
#define TASKSSETTINGS_H

#include <QObject>
#include <QSettings>

class QSettings;

class TasksSettings : public QObject
{
    Q_OBJECT
public:
    explicit TasksSettings(QObject *parent = 0);
    
    Q_INVOKABLE
    QString getValueFor(const QString &objectName);

    Q_INVOKABLE
    void setValueFor(const QString &objectName, const QString &value);

signals:
    
public slots:
    
protected:
    QSettings _settings;
};

#endif // TASKSSETTINGS_H
