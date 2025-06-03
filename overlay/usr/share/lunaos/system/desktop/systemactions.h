#ifndef SYSTEMACTIONS_H
#define SYSTEMACTIONS_H

#include <QObject>

class SystemActions : public QObject {
    Q_OBJECT
public:
    explicit SystemActions(QObject *parent = nullptr);

    Q_INVOKABLE void shutdown();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void logout();
    Q_INVOKABLE void lock();
};

#endif // SYSTEMACTIONS_H
