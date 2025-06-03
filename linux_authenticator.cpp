#include "linux_authenticator.h"
#include <QProcess>
#include <QDebug>
#include <security/pam_appl.h>
#include <pwd.h>
#include <unistd.h>
#include <cstring>
#include <cstdlib>

LinuxAuthenticator::LinuxAuthenticator(QObject *parent) : QObject(parent) {}

bool LinuxAuthenticator::authenticateUser(const QString &username, const QString &password) {
    if (username.isEmpty() || password.isEmpty()) {
        emit authenticationResult(false, "Username and password required");
        return false;
    }
    
    // Check if user exists first
    if (!isValidUser(username)) {
        emit authenticationResult(false, "User does not exist");
        return false;
    }
    
    pam_handle_t *pamh = nullptr;
    int result;
    
    AuthData authData;
    authData.username = username;
    authData.password = password;
    
    struct pam_conv conv = {
        pamConversation,
        &authData
    };
    
    // Initialize PAM
    result = pam_start("login", username.toLocal8Bit().data(), &conv, &pamh);
    if (result != PAM_SUCCESS) {
        emit authenticationResult(false, "PAM initialization failed");
        return false;
    }
    
    // Authenticate
    result = pam_authenticate(pamh, 0);
    if (result != PAM_SUCCESS) {
        pam_end(pamh, result);
        emit authenticationResult(false, "Authentication failed");
        return false;
    }
    
    // Check account validity
    result = pam_acct_mgmt(pamh, 0);
    if (result != PAM_SUCCESS) {
        pam_end(pamh, result);
        emit authenticationResult(false, "Account validation failed");
        return false;
    }
    
    pam_end(pamh, PAM_SUCCESS);
    emit authenticationResult(true, "Authentication successful");
    return true;
}

bool LinuxAuthenticator::isValidUser(const QString &username) {
    struct passwd *pwd = getpwnam(username.toLocal8Bit().data());
    return pwd != nullptr;
}

QString LinuxAuthenticator::getCurrentUser() {
    char *user = getlogin();
    if (!user) {
        qWarning() << "getlogin() returned null!";
        return QString(); // empty string
    }
    return QString::fromLocal8Bit(user);
}

int LinuxAuthenticator::pamConversation(int num_msg, const struct pam_message **msg,
                                       struct pam_response **resp, void *appdata_ptr) {
    AuthData *authData = static_cast<AuthData*>(appdata_ptr);
    
    *resp = (struct pam_response*)calloc(num_msg, sizeof(struct pam_response));
    if (*resp == nullptr) {
        return PAM_CONV_ERR;
    }
    
    for (int i = 0; i < num_msg; i++) {
        switch (msg[i]->msg_style) {
            case PAM_PROMPT_ECHO_ON: // Username
                (*resp)[i].resp = strdup(authData->username.toLocal8Bit().data());
                break;
            case PAM_PROMPT_ECHO_OFF: // Password
                (*resp)[i].resp = strdup(authData->password.toLocal8Bit().data());
                break;
            case PAM_TEXT_INFO:
            case PAM_ERROR_MSG:
                (*resp)[i].resp = nullptr;
                break;
            default:
                // Clean up on error
                for (int j = 0; j < i; j++) {
                    if ((*resp)[j].resp) {
                        free((*resp)[j].resp);
                    }
                }
                free(*resp);
                return PAM_CONV_ERR;
        }
        (*resp)[i].resp_retcode = 0;
    }
    
    return PAM_SUCCESS;
}

#include "linux_authenticator.moc"