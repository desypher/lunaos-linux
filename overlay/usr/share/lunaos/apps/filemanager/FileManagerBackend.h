#ifndef FILEMANAGERBACKEND_H
#define FILEMANAGERBACKEND_H

#include <QObject>
#include <QDir>
#include <QFileInfo>
#include <QDateTime>
#include <QVariantMap>
#include <QVariantList>

class FileManagerBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPath READ currentPath WRITE setCurrentPath NOTIFY currentPathChanged)
    Q_PROPERTY(QVariantList fileList READ fileList NOTIFY fileListChanged)

public:
    explicit FileManagerBackend(QObject *parent = nullptr);

    QString currentPath() const;
    QVariantList fileList() const;

public slots:
    void setCurrentPath(const QString &path);
    bool createDirectory(const QString &name);
    bool removeFile(const QString &path);
    bool copyFile(const QString &source, const QString &destination);
    bool moveFile(const QString &source, const QString &destination);
    bool rename(const QString &oldName, const QString &newName);
    QString getParentPath() const;
    QVariantMap getFileInfo(const QString &path) const;
    bool isDirectory(const QString &path) const;

signals:
    void currentPathChanged();
    void fileListChanged();
    void error(const QString &message);

private:
    void updateFileList();
    QString m_currentPath;
    QVariantList m_fileList;
};

#endif // FILEMANAGERBACKEND_H