#include "TextEditorBackend.h"
#include <QFile>
#include <QTextStream>

TextEditorBackend::TextEditorBackend(QObject *parent)
    : QObject(parent)
    , m_modified(false)
{
}

QString TextEditorBackend::currentFile() const
{
    return m_currentFile;
}

QString TextEditorBackend::content() const
{
    return m_content;
}

bool TextEditorBackend::isModified() const
{
    return m_modified;
}

bool TextEditorBackend::openFile(const QString &path)
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit error("Cannot open file: " + path);
        return false;
    }

    QTextStream in(&file);
    m_content = in.readAll();
    file.close();

    m_currentFile = path;
    m_modified = false;
    emit currentFileChanged();
    emit contentChanged();
    emit modifiedChanged();
    return true;
}

bool TextEditorBackend::saveFile()
{
    if (m_currentFile.isEmpty()) {
        emit error("No file name specified");
        return false;
    }
    return saveFileAs(m_currentFile);
}

bool TextEditorBackend::saveFileAs(const QString &path)
{
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        emit error("Cannot save file: " + path);
        return false;
    }

    QTextStream out(&file);
    out << m_content;
    file.close();

    m_currentFile = path;
    m_modified = false;
    emit currentFileChanged();
    emit modifiedChanged();
    return true;
}

void TextEditorBackend::setContent(const QString &content)
{
    if (m_content != content) {
        m_content = content;
        m_modified = true;
        emit contentChanged();
        emit modifiedChanged();
    }
}

void TextEditorBackend::newFile()
{
    m_currentFile.clear();
    m_content.clear();
    m_modified = false;
    emit currentFileChanged();
    emit contentChanged();
    emit modifiedChanged();
}
