#pragma once

#include <QObject>
#include <QProcess>
#include <QStringList>

class TerminalBackend : public QObject {
    Q_OBJECT
public:
    explicit TerminalBackend(QObject *parent = nullptr);

    Q_INVOKABLE void sendCommand(const QString &cmd);
    Q_INVOKABLE void startShell();

signals:
    void outputChanged(const QString &output);

private slots:
    void onReadyRead();
    void onReadyReadError();

private:
    QProcess *m_process;
};