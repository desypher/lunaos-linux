#ifndef TEXTEDITORBACKEND_H
#define TEXTEDITORBACKEND_H

#include <QObject>
#include <QString>

class TextEditorBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentFile READ currentFile NOTIFY currentFileChanged)
    Q_PROPERTY(QString content READ content WRITE setContent NOTIFY contentChanged)
    Q_PROPERTY(bool modified READ isModified NOTIFY modifiedChanged)

public:
    explicit TextEditorBackend(QObject *parent = nullptr);

    QString currentFile() const;
    QString content() const;
    bool isModified() const;

public slots:
    bool openFile(const QString &path);
    bool saveFile();
    bool saveFileAs(const QString &path);
    void setContent(const QString &content);
    void newFile();

signals:
    void currentFileChanged();
    void contentChanged();
    void modifiedChanged();
    void error(const QString &message);

private:
    QString m_currentFile;
    QString m_content;
    bool m_modified;
};

#endif // TEXTEDITORBACKEND_H
