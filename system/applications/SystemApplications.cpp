#include "SystemApplications.h"
#include <QDir>
#include <QDebug>

SystemApplications::SystemApplications(QObject *parent) : QObject(parent)
{
    updateInstalledApps();
}

void SystemApplications::updateInstalledApps()
{
    QStringList apps;
    
    // Read application entries from /usr/share/applications
    QDir appDir("/usr/share/applications");
    QStringList entries = appDir.entryList(QStringList() << "*.desktop", QDir::Files);
    
    for (const QString &entry : entries) {
        // Parse .desktop files to get application names
        QFile file(appDir.filePath(entry));
        if (file.open(QIODevice::ReadOnly)) {
            QString name;
            while (!file.atEnd()) {
                QString line = file.readLine();
                if (line.startsWith("Name=")) {
                    name = line.mid(5).trimmed();
                    break;
                }
            }
            if (!name.isEmpty()) {
                apps << name;
            }
        }
    }
    
    if (m_installedApps != apps) {
        m_installedApps = apps;
        emit installedAppsChanged();
    }
}

QStringList SystemApplications::installedApps() const
{
    return m_installedApps;
}

bool SystemApplications::launchApplication(const QString &appName)
{
    qDebug() << "Launching application:" << appName;
    QString command = appName.toLower();
    QStringList arguments;

    // Check if the app name contains any arguments
    if (command.contains(" ")) {
        QStringList parts = command.split(" ");
        command = parts.takeFirst();
        arguments = parts;
    }

    // Create a new process for the application
    QProcess *process = new QProcess(this);
    process->setProcessEnvironment(QProcessEnvironment::systemEnvironment());
    
    // Add X11 environment variables
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("DISPLAY", ":0");
    env.insert("QT_QPA_PLATFORM", "xcb");
    env.insert("XDG_RUNTIME_DIR", "/run/user/1000");
    process->setProcessEnvironment(env);

    // Start the process
    process->start(command, arguments);
    bool started = process->waitForStarted();

    if (started) {
        // Connect the finished signal to cleanup
        connect(process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
                [process](int, QProcess::ExitStatus) {
                    process->deleteLater();
                });
        return true;
    } else {
        delete process;
        return false;
    }
}

bool SystemApplications::installApplication(const QString &appName)
{
    QProcess process;
    process.start("sudo", QStringList() << "apt" << "install" << "-y" << appName);
    process.waitForFinished();
    updateInstalledApps();
    return process.exitCode() == 0;
}