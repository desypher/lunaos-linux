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
    // Set up environment variables for better terminal emulation
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");
    env.insert("SHELL", "/bin/bash");
    env.insert("TERM", "xterm-256color");
    env.insert("COLORTERM", "truecolor");
    env.insert("COLUMNS", "80");  // Set terminal width
    env.insert("LINES", "24");    // Set terminal height
    m_process->setProcessEnvironment(env);
    
    m_process->start("bash", QStringList() << "-l");
    
    if (m_process->waitForStarted()) {
        QString setupCommands =
            "export PS1='\\[\\033[01;32m\\]\\u@lunaos\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '\n"
            "export TERM=xterm-256color\n"
            "stty cols 80 rows 24\n"  // Set terminal size
            "clear\n"
            "echo 'Welcome to LunaOS!'\n"
            "neofetch\n";  // Remove the --ascii_distro flag to let neofetch auto-detect
        m_process->write(setupCommands.toUtf8());
    }
}

void TerminalBackend::onReadyRead()
{
    QString output = QString::fromUtf8(m_process->readAllStandardOutput());
    
    // Remove cursor positioning and control sequences
    output = output.replace(QRegularExpression("\033\\[[0-9;]*[HJKmn]"), "");
    output = output.replace(QRegularExpression("\033\\[[0-9]*[ABCD]"), ""); // Cursor movement
    output = output.replace(QRegularExpression("\033\\[s"), ""); // Save cursor
    output = output.replace(QRegularExpression("\033\\[u"), ""); // Restore cursor
    output = output.replace(QRegularExpression("\033\\[2J"), ""); // Clear screen
    output = output.replace(QRegularExpression("\033\\[H"), ""); // Home cursor
    
    // Convert common ANSI color codes to HTML
    // Reset codes
    output = output.replace(QRegularExpression("\033\\[0?m"), "</font>");
    output = output.replace(QRegularExpression("\033\\[00m"), "</font>");
    
    // Bold codes
    output = output.replace(QRegularExpression("\033\\[1m"), "<font style='font-weight:bold'>");
    output = output.replace(QRegularExpression("\033\\[01m"), "<font style='font-weight:bold'>");
    
    // Color codes
    output = output.replace(QRegularExpression("\033\\[30m"), "<font color='#45475a'>"); // Black
    output = output.replace(QRegularExpression("\033\\[31m"), "<font color='#f38ba8'>"); // Red
    output = output.replace(QRegularExpression("\033\\[32m"), "<font color='#a6e3a1'>"); // Green
    output = output.replace(QRegularExpression("\033\\[33m"), "<font color='#f9e2af'>"); // Yellow
    output = output.replace(QRegularExpression("\033\\[34m"), "<font color='#89b4fa'>"); // Blue
    output = output.replace(QRegularExpression("\033\\[35m"), "<font color='#f5c2e7'>"); // Magenta
    output = output.replace(QRegularExpression("\033\\[36m"), "<font color='#94e2d5'>"); // Cyan
    output = output.replace(QRegularExpression("\033\\[37m"), "<font color='#bac2de'>"); // White
    
    // Bright colors
    output = output.replace(QRegularExpression("\033\\[90m"), "<font color='#585b70'>"); // Bright Black
    output = output.replace(QRegularExpression("\033\\[91m"), "<font color='#f38ba8'>"); // Bright Red
    output = output.replace(QRegularExpression("\033\\[92m"), "<font color='#a6e3a1'>"); // Bright Green
    output = output.replace(QRegularExpression("\033\\[93m"), "<font color='#f9e2af'>"); // Bright Yellow
    output = output.replace(QRegularExpression("\033\\[94m"), "<font color='#89b4fa'>"); // Bright Blue
    output = output.replace(QRegularExpression("\033\\[95m"), "<font color='#f5c2e7'>"); // Bright Magenta
    output = output.replace(QRegularExpression("\033\\[96m"), "<font color='#94e2d5'>"); // Bright Cyan
    output = output.replace(QRegularExpression("\033\\[97m"), "<font color='#cdd6f4'>"); // Bright White
    
    // Bold + color combinations (common in neofetch)
    output = output.replace(QRegularExpression("\033\\[01;32m"), "<font color='#a6e3a1' style='font-weight:bold'>"); // Bold Green
    output = output.replace(QRegularExpression("\033\\[01;34m"), "<font color='#89b4fa' style='font-weight:bold'>"); // Bold Blue
    output = output.replace(QRegularExpression("\033\\[01;31m"), "<font color='#f38ba8' style='font-weight:bold'>"); // Bold Red
    output = output.replace(QRegularExpression("\033\\[01;33m"), "<font color='#f9e2af' style='font-weight:bold'>"); // Bold Yellow
    output = output.replace(QRegularExpression("\033\\[01;36m"), "<font color='#94e2d5' style='font-weight:bold'>"); // Bold Cyan
    output = output.replace(QRegularExpression("\033\\[01;35m"), "<font color='#f5c2e7' style='font-weight:bold'>"); // Bold Magenta
    
    // Remove any remaining escape sequences
    output = output.replace(QRegularExpression("\033\\[[0-9;]*m"), "");
    output = output.replace(QRegularExpression("\033\\[[0-9;]*[a-zA-Z]"), "");
    
    // Convert newlines to HTML breaks
    output = output.replace("\n", "<br>");
    
    emit outputChanged(output);
}

void TerminalBackend::onReadyReadError()
{
    // Emit error output in red text
    QString errorText = QString::fromUtf8(m_process->readAllStandardError());
    emit outputChanged("<font color='#f38ba8'>" + errorText + "</font>");
}