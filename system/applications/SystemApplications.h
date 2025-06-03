#ifndef SYSTEMAPPLICATIONS_H
#define SYSTEMAPPLICATIONS_H

#include <QObject>
#include <QStringList>
#include <QProcess>

class SystemApplications : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList installedApps READ installedApps NOTIFY installedAppsChanged)

public:
    explicit SystemApplications(QObject *parent = nullptr);

    QStringList installedApps() const;
    Q_INVOKABLE bool launchApplication(const QString &appName);
    Q_INVOKABLE bool installApplication(const QString &appName);

signals:
    void installedAppsChanged();

private:
    void updateInstalledApps();
    QStringList m_installedApps;
};

#endif