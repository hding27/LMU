/********************************************************************************
** Form generated from reading UI file 'aha.ui'
**
** Created: Wed 12. May 18:07:05 2010
**      by: Qt User Interface Compiler version 4.6.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_AHA_H
#define UI_AHA_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QMainWindow>
#include <QtGui/QMenuBar>
#include <QtGui/QPushButton>
#include <QtGui/QStatusBar>
#include <QtGui/QToolBar>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_ahaClass
{
public:
    QWidget *centralWidget;
    QPushButton *pushButton;
    QLabel *label;
    QPushButton *pushButton_2;
    QLabel *label_2;
    QLabel *label_3;
    QLabel *label_4;
    QLabel *label_5;
    QLabel *label_6;
    QLabel *label_7;
    QLabel *label_8;
    QLabel *label_9;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *ahaClass)
    {
        if (ahaClass->objectName().isEmpty())
            ahaClass->setObjectName(QString::fromUtf8("ahaClass"));
        ahaClass->resize(1261, 952);
        centralWidget = new QWidget(ahaClass);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        pushButton = new QPushButton(centralWidget);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setGeometry(QRect(770, 200, 75, 23));
        label = new QLabel(centralWidget);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(0, 0, 320, 240));
        pushButton_2 = new QPushButton(centralWidget);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setGeometry(QRect(770, 310, 75, 23));
        label_2 = new QLabel(centralWidget);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(510, 490, 640, 480));
        label_3 = new QLabel(centralWidget);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(325, 0, 30, 240));
        label_4 = new QLabel(centralWidget);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setGeometry(QRect(0, 245, 320, 20));
        label_5 = new QLabel(centralWidget);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setGeometry(QRect(340, 320, 491, 31));
        label_6 = new QLabel(centralWidget);
        label_6->setObjectName(QString::fromUtf8("label_6"));
        label_6->setGeometry(QRect(320, 350, 511, 31));
        label_7 = new QLabel(centralWidget);
        label_7->setObjectName(QString::fromUtf8("label_7"));
        label_7->setGeometry(QRect(470, 790, 46, 13));
        label_8 = new QLabel(centralWidget);
        label_8->setObjectName(QString::fromUtf8("label_8"));
        label_8->setGeometry(QRect(20, 400, 631, 31));
        label_9 = new QLabel(centralWidget);
        label_9->setObjectName(QString::fromUtf8("label_9"));
        label_9->setGeometry(QRect(20, 430, 661, 31));
        ahaClass->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(ahaClass);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 1261, 20));
        ahaClass->setMenuBar(menuBar);
        mainToolBar = new QToolBar(ahaClass);
        mainToolBar->setObjectName(QString::fromUtf8("mainToolBar"));
        ahaClass->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(ahaClass);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        ahaClass->setStatusBar(statusBar);

        retranslateUi(ahaClass);
        QObject::connect(pushButton, SIGNAL(clicked()), ahaClass, SLOT(slot1()));
        QObject::connect(pushButton_2, SIGNAL(clicked()), ahaClass, SLOT(slot2()));

        QMetaObject::connectSlotsByName(ahaClass);
    } // setupUi

    void retranslateUi(QMainWindow *ahaClass)
    {
        ahaClass->setWindowTitle(QApplication::translate("ahaClass", "aha", 0, QApplication::UnicodeUTF8));
        pushButton->setText(QApplication::translate("ahaClass", "PushButton", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QApplication::translate("ahaClass", "Stop bljied!", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_4->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_5->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_6->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_7->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_8->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
        label_9->setText(QApplication::translate("ahaClass", "TextLabel", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class ahaClass: public Ui_ahaClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_AHA_H
