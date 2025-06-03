#include "systemactions.h"
#include <QProcess>
#include "../viewmanager/ViewManager.h"

SystemActions::SystemActions(QObject *parent) : QObject(parent) {}

void SystemActions::shutdown() {
    QProcess::startDetached("systemctl", QStringList() << "poweroff");
}

void SystemActions::restart() {
    QProcess::startDetached("systemctl", QStringList() << "reboot");
}

void SystemActions::logout() {
    // This may vary depending on the desktop session manager (e.g. gnome-session-quit, pkill, etc.)
    QString username = qgetenv("USER");
    QProcess::startDetached("loginctl", QStringList() << "terminate-user" << username);
    ViewManager::instance().switchView("switchToLogin");
}

void SystemActions::lock() {
    // Try common Linux lock commands. You may want to make this configurable.
    QProcess::startDetached("loginctl", QStringList() << "lock-session");
    ViewManager::instance().switchView("switchToLogin");
    // Or alternatives:
    // QProcess::startDetached("xdg-screensaver", QStringList() << "lock");
    // QProcess::startDetached("gnome-screensaver-command", QStringList() << "-l");
}
