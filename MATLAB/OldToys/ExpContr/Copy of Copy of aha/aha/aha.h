#ifndef AHA_H
#define AHA_H

#include <QtGui/QMainWindow>
#include "ui_aha.h"
#include <NIIMAQdx.h>
#include <nivision.h>
#include <qimage.h>
#include <qpixmap.h>
#include <qrgb.h>
#include <qcolor.h>
#include <qgraphicsscene.h>
#include <qgraphicsview.h>

class aha : public QMainWindow
{
	Q_OBJECT

public:
	aha(QWidget *parent = 0, Qt::WFlags flags = 0);
	~aha();
	ImageInfo* info0; 
	ImageInfo* info0fftrunc;
     Image* image0;
	 Image* image1;
	 Image* image0fftrunc;
     IMAQdxSession* camid0;
	 bool mStop;
	
private slots:
	 void slot1();
	void slot2();
private:
	Ui::ahaClass ui;
};

#endif // AHA_H
