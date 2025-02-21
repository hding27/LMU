/****************************************************************************
** Meta object code from reading C++ file 'aha.h'
**
** Created: Wed 12. May 00:53:58 2010
**      by: The Qt Meta Object Compiler version 62 (Qt 4.6.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../aha.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'aha.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.6.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_aha[] = {

 // content:
       4,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
       5,    4,    4,    4, 0x08,
      13,    4,    4,    4, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_aha[] = {
    "aha\0\0slot1()\0slot2()\0"
};

const QMetaObject aha::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_aha,
      qt_meta_data_aha, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &aha::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *aha::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *aha::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_aha))
        return static_cast<void*>(const_cast< aha*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int aha::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: slot1(); break;
        case 1: slot2(); break;
        default: ;
        }
        _id -= 2;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
