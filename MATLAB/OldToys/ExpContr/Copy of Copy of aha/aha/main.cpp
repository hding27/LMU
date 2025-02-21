#include "aha.h"
#include <QtGui/QApplication>

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	aha w;
	w.show();
	return a.exec();
}
