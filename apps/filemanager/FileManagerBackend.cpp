#include "FileManagerBackend.h"
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QDebug>

FileManagerBackend::FileManagerBackend(QObject *parent)
    : QObject(parent)
    , m_currentPath(QDir::homePath())
{
    updateFileList();
}

QString FileManagerBackend::currentPath() const
{
    return m_currentPath;
}

void FileManagerBackend::setCurrentPath(const QString &path)
{
    if (m_currentPath != path) {
        QDir dir(path);
        if (dir.exists()) {
            m_currentPath = dir.absolutePath();
            updateFileList();
            emit currentPathChanged();
        } else {
            emit error("Directory does not exist: " + path);
        }
    }
}

QVariantList FileManagerBackend::fileList() const
{
    return m_fileList;
}

bool FileManagerBackend::createDirectory(const QString &name)
{
    QDir dir(m_currentPath);
    if (dir.mkdir(name)) {
        updateFileList();
        return true;
    }
    emit error("Failed to create directory: " + name);
    return false;
}

bool FileManagerBackend::removeFile(const QString &path)
{
    QFileInfo fileInfo(path);
    if (fileInfo.isDir()) {
        QDir dir(path);
        if (dir.removeRecursively()) {
            updateFileList();
            return true;
        }
    } else {
        QFile file(path);
        if (file.remove()) {
            updateFileList();
            return true;
        }
    }
    emit error("Failed to remove: " + path);
    return false;
}

bool FileManagerBackend::copyFile(const QString &source, const QString &destination)
{
    if (QFile::copy(source, destination)) {
        updateFileList();
        return true;
    }
    emit error("Failed to copy file: " + source);
    return false;
}

bool FileManagerBackend::moveFile(const QString &source, const QString &destination)
{
    if (QFile::rename(source, destination)) {
        updateFileList();
        return true;
    }
    emit error("Failed to move file: " + source);
    return false;
}

bool FileManagerBackend::rename(const QString &oldName, const QString &newName)
{
    QString oldPath = QDir(m_currentPath).filePath(oldName);
    QString newPath = QDir(m_currentPath).filePath(newName);
    
    if (QFile::rename(oldPath, newPath)) {
        updateFileList();
        return true;
    }
    emit error("Failed to rename: " + oldName);
    return false;
}

QString FileManagerBackend::getParentPath() const
{
    QDir dir(m_currentPath);
    if (dir.cdUp()) {
        return dir.absolutePath();
    }
    return m_currentPath;
}

QVariantMap FileManagerBackend::getFileInfo(const QString &path) const
{
    QFileInfo info(path);
    QVariantMap fileInfo;
    
    fileInfo["name"] = info.fileName();
    fileInfo["path"] = info.absoluteFilePath();
    fileInfo["size"] = info.size();
    fileInfo["created"] = info.birthTime();
    fileInfo["modified"] = info.lastModified();
    fileInfo["isDir"] = info.isDir();
    fileInfo["isFile"] = info.isFile();
    fileInfo["isReadable"] = info.isReadable();
    fileInfo["isWritable"] = info.isWritable();
    
    return fileInfo;
}

bool FileManagerBackend::isDirectory(const QString &path) const
{
    return QFileInfo(path).isDir();
}

void FileManagerBackend::updateFileList()
{
    QDir dir(m_currentPath);
    QFileInfoList entries = dir.entryInfoList(QDir::AllEntries | QDir::NoDot);
    
    m_fileList.clear();
    
    // Add parent directory entry (..)
    if (dir.absolutePath() != "/") {
        QVariantMap parentDir;
        parentDir["name"] = "..";
        parentDir["path"] = dir.absolutePath() + "/..";
        parentDir["isDir"] = true;
        parentDir["icon"] = "📁";
        m_fileList.append(parentDir);
    }
    
    // Add all other entries
    for (const QFileInfo &info : entries) {
        QVariantMap entry;
        entry["name"] = info.fileName();
        entry["path"] = info.absoluteFilePath();
        entry["size"] = info.size();
        entry["modified"] = info.lastModified();
        entry["isDir"] = info.isDir();
        entry["icon"] = info.isDir() ? "📁" : "📄";
        
        m_fileList.append(entry);
    }
    
    emit fileListChanged();
}