/****************************************************************************
** Meta object code from reading C++ file 'FileManagerBackend.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.13)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../apps/filemanager/FileManagerBackend.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'FileManagerBackend.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.13. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_FileManagerBackend_t {
    QByteArrayData data[23];
    char stringdata0[240];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_FileManagerBackend_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_FileManagerBackend_t qt_meta_stringdata_FileManagerBackend = {
    {
QT_MOC_LITERAL(0, 0, 18), // "FileManagerBackend"
QT_MOC_LITERAL(1, 19, 18), // "currentPathChanged"
QT_MOC_LITERAL(2, 38, 0), // ""
QT_MOC_LITERAL(3, 39, 15), // "fileListChanged"
QT_MOC_LITERAL(4, 55, 5), // "error"
QT_MOC_LITERAL(5, 61, 7), // "message"
QT_MOC_LITERAL(6, 69, 14), // "setCurrentPath"
QT_MOC_LITERAL(7, 84, 4), // "path"
QT_MOC_LITERAL(8, 89, 15), // "createDirectory"
QT_MOC_LITERAL(9, 105, 4), // "name"
QT_MOC_LITERAL(10, 110, 10), // "removeFile"
QT_MOC_LITERAL(11, 121, 8), // "copyFile"
QT_MOC_LITERAL(12, 130, 6), // "source"
QT_MOC_LITERAL(13, 137, 11), // "destination"
QT_MOC_LITERAL(14, 149, 8), // "moveFile"
QT_MOC_LITERAL(15, 158, 6), // "rename"
QT_MOC_LITERAL(16, 165, 7), // "oldName"
QT_MOC_LITERAL(17, 173, 7), // "newName"
QT_MOC_LITERAL(18, 181, 13), // "getParentPath"
QT_MOC_LITERAL(19, 195, 11), // "getFileInfo"
QT_MOC_LITERAL(20, 207, 11), // "isDirectory"
QT_MOC_LITERAL(21, 219, 11), // "currentPath"
QT_MOC_LITERAL(22, 231, 8) // "fileList"

    },
    "FileManagerBackend\0currentPathChanged\0"
    "\0fileListChanged\0error\0message\0"
    "setCurrentPath\0path\0createDirectory\0"
    "name\0removeFile\0copyFile\0source\0"
    "destination\0moveFile\0rename\0oldName\0"
    "newName\0getParentPath\0getFileInfo\0"
    "isDirectory\0currentPath\0fileList"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_FileManagerBackend[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       2,  110, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   74,    2, 0x06 /* Public */,
       3,    0,   75,    2, 0x06 /* Public */,
       4,    1,   76,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       6,    1,   79,    2, 0x0a /* Public */,
       8,    1,   82,    2, 0x0a /* Public */,
      10,    1,   85,    2, 0x0a /* Public */,
      11,    2,   88,    2, 0x0a /* Public */,
      14,    2,   93,    2, 0x0a /* Public */,
      15,    2,   98,    2, 0x0a /* Public */,
      18,    0,  103,    2, 0x0a /* Public */,
      19,    1,  104,    2, 0x0a /* Public */,
      20,    1,  107,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    5,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    7,
    QMetaType::Bool, QMetaType::QString,    9,
    QMetaType::Bool, QMetaType::QString,    7,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,   12,   13,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,   12,   13,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,   16,   17,
    QMetaType::QString,
    QMetaType::QVariantMap, QMetaType::QString,    7,
    QMetaType::Bool, QMetaType::QString,    7,

 // properties: name, type, flags
      21, QMetaType::QString, 0x00495103,
      22, QMetaType::QVariantList, 0x00495001,

 // properties: notify_signal_id
       0,
       1,

       0        // eod
};

void FileManagerBackend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<FileManagerBackend *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->currentPathChanged(); break;
        case 1: _t->fileListChanged(); break;
        case 2: _t->error((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 3: _t->setCurrentPath((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 4: { bool _r = _t->createDirectory((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 5: { bool _r = _t->removeFile((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 6: { bool _r = _t->copyFile((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 7: { bool _r = _t->moveFile((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 8: { bool _r = _t->rename((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 9: { QString _r = _t->getParentPath();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 10: { QVariantMap _r = _t->getFileInfo((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 11: { bool _r = _t->isDirectory((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (FileManagerBackend::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FileManagerBackend::currentPathChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (FileManagerBackend::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FileManagerBackend::fileListChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (FileManagerBackend::*)(const QString & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FileManagerBackend::error)) {
                *result = 2;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<FileManagerBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->currentPath(); break;
        case 1: *reinterpret_cast< QVariantList*>(_v) = _t->fileList(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<FileManagerBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setCurrentPath(*reinterpret_cast< QString*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject FileManagerBackend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_FileManagerBackend.data,
    qt_meta_data_FileManagerBackend,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *FileManagerBackend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FileManagerBackend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_FileManagerBackend.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int FileManagerBackend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 12;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 2;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void FileManagerBackend::currentPathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void FileManagerBackend::fileListChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void FileManagerBackend::error(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
