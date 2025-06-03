/****************************************************************************
** Meta object code from reading C++ file 'TextEditorBackend.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.13)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../apps/texteditor/TextEditorBackend.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'TextEditorBackend.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.13. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_TextEditorBackend_t {
    QByteArrayData data[16];
    char stringdata0[165];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_TextEditorBackend_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_TextEditorBackend_t qt_meta_stringdata_TextEditorBackend = {
    {
QT_MOC_LITERAL(0, 0, 17), // "TextEditorBackend"
QT_MOC_LITERAL(1, 18, 18), // "currentFileChanged"
QT_MOC_LITERAL(2, 37, 0), // ""
QT_MOC_LITERAL(3, 38, 14), // "contentChanged"
QT_MOC_LITERAL(4, 53, 15), // "modifiedChanged"
QT_MOC_LITERAL(5, 69, 5), // "error"
QT_MOC_LITERAL(6, 75, 7), // "message"
QT_MOC_LITERAL(7, 83, 8), // "openFile"
QT_MOC_LITERAL(8, 92, 4), // "path"
QT_MOC_LITERAL(9, 97, 8), // "saveFile"
QT_MOC_LITERAL(10, 106, 10), // "saveFileAs"
QT_MOC_LITERAL(11, 117, 10), // "setContent"
QT_MOC_LITERAL(12, 128, 7), // "content"
QT_MOC_LITERAL(13, 136, 7), // "newFile"
QT_MOC_LITERAL(14, 144, 11), // "currentFile"
QT_MOC_LITERAL(15, 156, 8) // "modified"

    },
    "TextEditorBackend\0currentFileChanged\0"
    "\0contentChanged\0modifiedChanged\0error\0"
    "message\0openFile\0path\0saveFile\0"
    "saveFileAs\0setContent\0content\0newFile\0"
    "currentFile\0modified"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_TextEditorBackend[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       3,   76, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   59,    2, 0x06 /* Public */,
       3,    0,   60,    2, 0x06 /* Public */,
       4,    0,   61,    2, 0x06 /* Public */,
       5,    1,   62,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       7,    1,   65,    2, 0x0a /* Public */,
       9,    0,   68,    2, 0x0a /* Public */,
      10,    1,   69,    2, 0x0a /* Public */,
      11,    1,   72,    2, 0x0a /* Public */,
      13,    0,   75,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    6,

 // slots: parameters
    QMetaType::Bool, QMetaType::QString,    8,
    QMetaType::Bool,
    QMetaType::Bool, QMetaType::QString,    8,
    QMetaType::Void, QMetaType::QString,   12,
    QMetaType::Void,

 // properties: name, type, flags
      14, QMetaType::QString, 0x00495001,
      12, QMetaType::QString, 0x00495103,
      15, QMetaType::Bool, 0x00495001,

 // properties: notify_signal_id
       0,
       1,
       2,

       0        // eod
};

void TextEditorBackend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<TextEditorBackend *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->currentFileChanged(); break;
        case 1: _t->contentChanged(); break;
        case 2: _t->modifiedChanged(); break;
        case 3: _t->error((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 4: { bool _r = _t->openFile((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 5: { bool _r = _t->saveFile();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 6: { bool _r = _t->saveFileAs((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 7: _t->setContent((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 8: _t->newFile(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (TextEditorBackend::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TextEditorBackend::currentFileChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (TextEditorBackend::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TextEditorBackend::contentChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (TextEditorBackend::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TextEditorBackend::modifiedChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (TextEditorBackend::*)(const QString & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TextEditorBackend::error)) {
                *result = 3;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<TextEditorBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->currentFile(); break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->content(); break;
        case 2: *reinterpret_cast< bool*>(_v) = _t->isModified(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<TextEditorBackend *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 1: _t->setContent(*reinterpret_cast< QString*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject TextEditorBackend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_TextEditorBackend.data,
    qt_meta_data_TextEditorBackend,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *TextEditorBackend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *TextEditorBackend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_TextEditorBackend.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int TextEditorBackend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 3;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void TextEditorBackend::currentFileChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void TextEditorBackend::contentChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void TextEditorBackend::modifiedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void TextEditorBackend::error(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
