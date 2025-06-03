#include "TerminalBackend.h"
#include <QProcess>
#include <QRegularExpression>

TerminalBackend::TerminalBackend(QObject *parent)
    : QObject(parent), m_process(new QProcess(this))
{
    connect(m_process, &QProcess::readyReadStandardOutput, this, &TerminalBackend::onReadyRead);
    connect(m_process, &QProcess::readyReadStandardError, this, &TerminalBackend::onReadyReadError);
    
    // Set up environment variables
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");
    env.insert("SHELL", "/bin/bash");
    m_process->setProcessEnvironment(env);
}

void TerminalBackend::sendCommand(const QString &cmd)
{
    if (m_process->state() == QProcess::Running) {
        m_process->write(cmd.toUtf8() + '\n');
    }
}

void TerminalBackend::startShell()
{
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");
    env.insert("SHELL", "/bin/bash");
    env.insert("TERM", "xterm-256color");
    env.insert("FORCE_COLOR", "1");
    env.insert("COLORTERM", "truecolor");
    m_process->setProcessEnvironment(env);
    
    m_process->start("bash", QStringList() << "-l");
    
    if (m_process->waitForStarted()) {
        QString setupCommands =
            "export PS1='\\[\\033[01;32m\\]\\u@lunaos\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '\n"
            "export TERM=xterm-256color\n"
            "export FORCE_COLOR=1\n"
            "clear\n"
            "echo -e '\\033[1;33mWelcome to LunaOS!\\033[0m'\n"
            "TERM=xterm-256color neofetch --color_blocks off\n";
        m_process->write(setupCommands.toUtf8());
    }
}

void TerminalBackend::onReadyRead()
{
    QString output = QString::fromUtf8(m_process->readAllStandardOutput());
    
    // Remove cursor and terminal control sequences
    output = output.replace(QRegularExpression("\033\\[[?]?[0-9;]*[hlm]"), ""); // Handles [?25h, [?7h, etc.
    output = output.replace(QRegularExpression("\033\\[[0-9;]*[HJKn]"), "");
    output = output.replace(QRegularExpression("\033\\[[0-9]*[ABCD]"), "");
    output = output.replace(QRegularExpression("\033\\[s"), "");
    output = output.replace(QRegularExpression("\033\\[u"), "");
    output = output.replace(QRegularExpression("\033\\[2J"), "");
    output = output.replace(QRegularExpression("\033\\[H"), "");
    output = output.replace(QRegularExpression("_\\x08"), ""); // Remove underline control chars
    
    // Handle color codes first
    QMap<QString, QString> colorMap;
    colorMap["30"] = "#45475a"; // Black
    colorMap["31"] = "#f38ba8"; // Red
    colorMap["32"] = "#a6e3a1"; // Green
    colorMap["33"] = "#f9e2af"; // Yellow
    colorMap["34"] = "#89b4fa"; // Blue
    colorMap["35"] = "#f5c2e7"; // Magenta
    colorMap["36"] = "#94e2d5"; // Cyan
    colorMap["37"] = "#bac2de"; // White
    colorMap["90"] = "#585b70"; // Bright Black
    colorMap["91"] = "#f38ba8"; // Bright Red
    colorMap["92"] = "#a6e3a1"; // Bright Green
    colorMap["93"] = "#f9e2af"; // Bright Yellow
    colorMap["94"] = "#89b4fa"; // Bright Blue
    colorMap["95"] = "#f5c2e7"; // Bright Magenta
    colorMap["96"] = "#94e2d5"; // Bright Cyan
    colorMap["97"] = "#cdd6f4"; // Bright White

    // Process ANSI escape sequences
    QRegularExpression colorRegex("\\033\\[(\\d+)m");
    QRegularExpression complexColorRegex("\\033\\[([0-9;]+)m");
    
    QRegularExpressionMatchIterator i = complexColorRegex.globalMatch(output);
    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        QString codes = match.captured(1);
        QStringList codeList = codes.split(';');
        
        QString replacement = "<font";
        bool hasBold = false;
        QString color;
        
        foreach(QString code, codeList) {
            if (code == "0" || code == "00") {
                replacement = "</font>";
                break;
            }
            if (code == "1" || code == "01") {
                hasBold = true;
            }
            else if (colorMap.contains(code)) {
                color = colorMap[code];
            }
        }
        
        if (!replacement.startsWith("</")) {
            if (!color.isEmpty()) {
                replacement += QString(" color='%1'").arg(color);
            }
            if (hasBold) {
                replacement += " style='font-weight:bold'";
            }
            replacement += ">";
        }
        
        output.replace(match.captured(0), replacement);
    }

    // Convert newlines last
    output = output.replace("\n", "<br>");
    
    emit outputChanged(output);
}

void TerminalBackend::onReadyReadError()
{
    // Emit error output in red text
    QString errorText = QString::fromUtf8(m_process->readAllStandardError());
    emit outputChanged("<font color='#f38ba8'>" + errorText + "</font>");
}