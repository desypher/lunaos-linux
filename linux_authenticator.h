#ifndef LINUXAUTHENTICATOR_H
#define LINUXAUTHENTICATOR_H

#include <QObject>
#include <QString>

struct pam_message;
struct pam_response;

class LinuxAuthenticator : public QObject {
    Q_OBJECT
    
public:
    explicit LinuxAuthenticator(QObject *parent = nullptr);
    
    Q_INVOKABLE bool authenticateUser(const QString &username, const QString &password);
    Q_INVOKABLE bool isValidUser(const QString &username);
    Q_INVOKABLE QString getCurrentUser();
    
signals:
    void authenticationResult(bool success, const QString &message);
    
private:
    struct AuthData {
        QString username;
        QString password;
    };
    
    static int pamConversation(int num_msg, const struct pam_message **msg,
                              struct pam_response **resp, void *appdata_ptr);
};

#endif