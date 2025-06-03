#include "ViewManager.h"
#include <QDebug>

ViewManager& ViewManager::instance()
{
    static ViewManager instance;
    return instance;
}

void ViewManager::setEngine(QQmlApplicationEngine* engine)
{
    m_engine = engine;
}

void ViewManager::switchView(const QString& methodName)
{
    if (!m_engine || m_engine->rootObjects().isEmpty()) {
        qCritical() << "Engine not initialized or root object missing";
        return;
    }

    QObject* root = m_engine->rootObjects().first();
    if (!root) {
        qCritical() << "Root object is null";
        return;
    }

    bool success = QMetaObject::invokeMethod(root, methodName.toUtf8().constData());
    if (!success) {
        qCritical() << "Failed to invoke" << methodName;
    }
}