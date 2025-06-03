#pragma once
#include <QObject>
#include <QQmlApplicationEngine>

class ViewManager : public QObject
{
    Q_OBJECT
public:
    static ViewManager& instance();
    void setEngine(QQmlApplicationEngine* engine);
    void switchView(const QString& methodName);

private:
    ViewManager() = default;
    QQmlApplicationEngine* m_engine{nullptr};
};