#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QQmlComponent>
#include <QSurfaceFormat>
#include <QtGui/QOpenGLContext>
#include "system/viewmanager/ViewManager.h"
#include "linux_authenticator.h"
#include "system/desktop/systemactions.h"
#include "apps/terminal/TerminalBackend.h"
#include "apps/filemanager/FileManagerBackend.h"
#include "apps/texteditor/TextEditorBackend.h"
#include "system/applications/SystemApplications.h"

class LunaOSController : public QObject
{
    Q_OBJECT
public:
    explicit LunaOSController(QQmlApplicationEngine* engine, QObject* parent = nullptr)
        : QObject(parent), m_engine(engine) {
            ViewManager::instance().setEngine(engine);
        }

public slots:
    void loginSuccess() {
        qDebug() << "Login successful, switching to desktop";
        ViewManager::instance().switchView("switchToDesktop");
    }

    void exitToLogin() {
        qDebug() << "Returning to login screen";
        ViewManager::instance().switchView("switchToLogin");
    }

private:
    QQmlApplicationEngine* m_engine;
};

int main(int argc, char *argv[])
{

    qputenv("QT_QUICK_BACKEND", "software");
    qputenv("LIBGL_ALWAYS_SOFTWARE", "1");
    qputenv("QT_QPA_PLATFORM", "xcb");

    QGuiApplication app(argc, argv);

    QSurfaceFormat format;
    format.setRenderableType(QSurfaceFormat::OpenGLES);
    format.setVersion(2, 0);
    format.setProfile(QSurfaceFormat::NoProfile);
    format.setSwapBehavior(QSurfaceFormat::DoubleBuffer);
    QSurfaceFormat::setDefaultFormat(format);

    app.setApplicationName("LunaOS");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("LunaOS Project");

    QQmlApplicationEngine engine;

    LunaOSController controller(&engine);

    qmlRegisterType<LinuxAuthenticator>("LunaOS", 1, 0, "LinuxAuthenticator");
    qmlRegisterType<SystemActions>("LunaOS", 1, 0, "SystemActions");
    qmlRegisterType<TerminalBackend>("LunaOS", 1, 0, "TerminalBackend");
    qmlRegisterType<FileManagerBackend>("LunaOS", 1, 0, "FileManagerBackend");
    qmlRegisterType<TextEditorBackend>("LunaOS", 1, 0, "TextEditorBackend");
    qmlRegisterType<SystemApplications>("LunaOS", 1, 0, "SystemApplications");
    qmlRegisterSingletonInstance("LunaOS", 1, 0, "Controller", &controller);

    engine.rootContext()->setContextProperty("LunaOS", &controller);

    engine.load(QUrl("qrc:/Main.qml"));

    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load QML root";
        return -1;
    }

    return app.exec();
}

#include "main.moc"