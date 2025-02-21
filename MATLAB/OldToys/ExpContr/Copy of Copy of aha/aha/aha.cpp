#include <NIIMAQdx.h>
#include <nivision.h>
#include <qimage.h>
#include <qpixmap.h>
#include <qrgb.h>
#include <qcolor.h>
#include <qgraphicsscene.h>
#include <qgraphicsview.h>
#include "aha.h"
#include <math.h>
#include <minlm.h>
#include <lsfit.h>
#include <qstring.h>
#include <qtransform.h>
#include <windows.h>
#include <winbase.h>
#include <levmar.h>
//#include <fftw3.h>

aha::aha(QWidget *parent, Qt::WFlags flags)
	: QMainWindow(parent, flags)
{
	ui.setupUi(this);
}

aha::~aha()
{

}

void gaussfunc(double *p, double *x, int m, int n, void *data)
{
register int i;

  for(i=0; i<n; ++i){
    x[i]=p[0]*exp( -1/(2*p[1]*p[1])*(i-p[2])*(i-p[2]) );
  }
}







void aha::slot1()
{
	Image* image0=imaqCreateImage(IMAQ_IMAGE_U8, 0);
    ImageInfo* info0 = new ImageInfo;
	
	Image* image1=imaqCreateImage(IMAQ_IMAGE_U8, 0);
    ImageInfo* info1 = new ImageInfo;
	
	Image* image2=imaqCreateImage(IMAQ_IMAGE_COMPLEX, 0);
	ImageInfo* infoi2 = new ImageInfo;

	Image* image3=imaqCreateImage(IMAQ_IMAGE_COMPLEX, 0);
    ImageInfo* info3 = new ImageInfo;

	Image* image4=imaqCreateImage(IMAQ_IMAGE_COMPLEX, 0);

	IMAQdxSession* camid0 = new IMAQdxSession;
    IMAQdxError rval;
	mStop=false;

		rval= IMAQdxOpenCamera ("uuid:00074801016B293F", IMAQdxCameraControlModeController,camid0);
		rval= IMAQdxConfigureAcquisition(*camid0,1,3);
	    rval= IMAQdxStartAcquisition(*camid0);
		
	double mmax=-100000;
	double mmin=100000;
	double sum=0;	
  	uInt32 buffernr;     
	int aaa;
    int yres,xres, pixelnr;
    unsigned char* pixel_address;
    bool which;
	int xx, yy;
    double buff;
	unsigned char* imstart,imstart1,imstart2;
	QImage* mimg1 = new QImage(640/2,480/2, QImage::Format_RGB32);
    QPixmap mpx1(640,480);
    QRgb *mrgb1;
    QColor mclr1;
	QImage* mimg2 = new QImage(640,480, QImage::Format_RGB32);
    QPixmap mpx2(640,480);
    QRgb *mrgb2;
    QColor mclr2;
	QImage* mimg3 = new QImage(20,480/2, QImage::Format_RGB32);
    QPixmap mpx3(20,480);
    QRgb *mrgb3;
    QColor mclr3;
	QImage* mimg4 = new QImage(20,640, QImage::Format_RGB32);
	QImage* mimg5 = new QImage(640,20, QImage::Format_RGB32);
    QPixmap mpx4(20,480);
    QRgb *mrgb4;
    QColor mclr4;

	int ret;
	const int nn=240,m=3;
	double p[m],x[nn],info[LM_INFO_SZ],opts[LM_OPTS_SZ] ;
	int ret2;
	const int nn2=320,m2=3;
	double p2[m],x2[nn2],info2[LM_INFO_SZ],opts2[LM_OPTS_SZ] ;
  
	double buffbljied;
	LARGE_INTEGER lp_ctr1, lp_ctr2;
	LARGE_INTEGER lp_freq;
	char bljiedtimer[50];
	QueryPerformanceFrequency(&lp_freq);
	
    while(!mStop)
	{

		rval= IMAQdxGetImage(*camid0,image0,IMAQdxBufferNumberModeLast,0, &buffernr);
		imaqGetImageInfo(image0,info0);
		imstart=(unsigned char*) info0->imageStart;
		 yres=info0->yRes;
         xres=info0->xRes;
		 pixelnr=info0->pixelsPerLine;
		int bbb;
		 bbb=imaqScale(image1, image0, 2, 2, IMAQ_SCALE_SMALLER, IMAQ_NO_RECT);
	/*	 imaqGetImageInfo(image1,info1);    
		 imstart1=(unsigned char*) info1->imageStart;*/

		bbb=imaqFFT(image2, image1);
QueryPerformanceCounter(&lp_ctr1);
		bbb=imaqTruncate(image3, image2, IMAQ_TRUNCATE_HIGH,10);
	//	bbb=imaqTruncate(image4, image3, IMAQ_TRUNCATE_LOW,99);
QueryPerformanceCounter(&lp_ctr2);			
		imaqGetLastError();
		bbb=imaqInverseFFT(image0,image3);

		imaqGetImageInfo(image0,info0);
		imstart=(unsigned char*) info0->imageStart;
		 yres=info0->yRes;
         xres=info0->xRes;
		 pixelnr=info0->pixelsPerLine;

	
	/*	fftw_plan p;
		fftw_complex *out;
		out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * 640*480*2);

		
		for (int i=0; i<640*480;i++)
			in[i]=(double)imstart[i];

		p=fftw_plan_dft_r2c_2d(640,480,in, out,FFTW_FORWARD);
		fftw_execute(p);*/
		
        
		

        

		
/*** Get max and min of pixel values for image , xres,yres,pixelnr ***/  

	
		mmin=100000;
		mmax=-100000;
		for(yy=0;yy<yres;yy++)
			for(xx=0;xx<xres;xx++){
				
				if (imstart[yy*pixelnr+xx]<mmin) 
					mmin=(double)imstart[yy*pixelnr+xx];
				if (imstart[yy*pixelnr+xx]>mmax)
					mmax=(double)imstart[yy*pixelnr+xx];
				
			}
		
		
	
		for( yy=0;yy<yres;yy++)
		{
           mrgb1=(QRgb*)mimg1->scanLine(yy);
           for( xx=0;xx<xres;xx++){
              
			   buff=((((double)imstart[yy*xres+xx])-mmin));
			   if (buff<(mmax-mmin)*0.1) buff=0;
			   buff=(double)(220-(double)(buff)/(mmax-mmin)*220);
			   mclr1.setHsv(buff,255,255);
               mrgb1[xx]=mclr1.rgba();
           }
        }

/*		int xpix=info0fftrunc->pixelsPerLine;
		for( yy=0;yy<yres;yy++){

           mrgb2=(QRgb*)mimg2->scanLine(yy);
		  for( xx=0;xx<2*xres;xx=xx+2){
			 /* if((xx<4)&&(yy<2)){
				   imstart2[yy*xpix*2+xx]=0;
				   imstart2[yy*xpix*2+xx+1]=0;
			   }

			  if((xx>1000)||(yy>500)){
				   imstart2[yy*xpix*2+xx]=0;
				   imstart2[yy*xpix*2+xx+1]=0;
			 }
               buffbljied= 1/sqrt((double)480*640)*sqrt(pow((double)imstart2[yy*xpix*2+xx],2)+ pow((double) imstart2[yy*xpix*2+xx+1],2));
			   buff=(unsigned char)buffbljied;
               mclr2.setHsv(buff,255,255);
               mrgb2[xx/2]=mclr2.rgba();
           }
        }
	  */
	
      

		


/** Sum ober rows **/

		mmin=100000;
		mmax=-100000;
		double sum=0;
		for(yy=0;yy<yres;yy++){
		
			for(xx=0;xx<xres;xx++)	{
				sum=(double)imstart[yy*xres+xx]+sum;
			}
			mmin=sum<mmin?sum:mmin;
			mmax=sum>mmax?sum:mmax;
			sum=0;
		}
		
		
        for( yy=0;yy<yres;yy++)
		{
			x[yy]=0;
           mrgb3=(QRgb*)mimg3->scanLine(yy);
           for( xx=0;xx<xres;xx++)
			{
			   buff=(double)imstart[yy*xres+xx];
			   sum=buff+sum;
			}
		    buff=(double)(220-(double)(sum-mmin)/(mmax-mmin)*220);
			x[yy]=sum;
			mclr3.setHsv(buff,255,255);
			for (int i=0;i<20;i++)
				mrgb3[i]=mclr3.rgba();
			sum =0;
		}


		mmin=100000;
		mmax=-100000;
		for(xx=0;xx<xres;xx++){
			for(yy=0;yy<yres;yy++){
				sum=(double)imstart[yy*xres+xx]+sum;
			}
			mmin=sum<mmin?sum:mmin;
			mmax=sum>mmax?sum:mmax;
			sum=0;
		}
		for( xx=0;xx<xres;xx++){
			x2[xx]=0;
           mrgb4=(QRgb*)mimg4->scanLine(xx);

		   for( yy=0;yy<yres;yy++){
			   
               buff=(double)imstart[yy*xres+xx];
			   sum=buff+sum;
			  
			}
		    
			buff=(double)(220-(double)(sum-mmin)/(mmax-mmin)*220);
			x2[xx]=sum;
		    mclr4.setHsv(buff,255,255);
			for (int i=0;i<20;i++){
				mrgb4[i]=mclr4.rgba();}
			sum =0;
		}


/* Fitting *******/
		double bljied=x[240];

p[0]=4000; p[1]=15; p[2]=120;

opts[0]=1E-3; opts[1]=1E-15; opts[2]=1E-15; opts[3]=1E-20;
ret=dlevmar_dif(gaussfunc, p, x, m, nn, 1000, opts, info, NULL, NULL, NULL); // without Jacobian

p2[0]=4000; p2[1]=15; p2[2]=160;

opts2[0]=1E-3; opts2[1]=1E-15; opts2[2]=1E-15; opts2[3]=1E-20;
ret=dlevmar_dif(gaussfunc, p2, x2, m2, nn2, 1000, opts2, info2, NULL, NULL, NULL); // without Jacobian

	
		
		QTransform* mat=new QTransform;
		
		*mimg5=mimg4->transformed(mat->rotate(-90));


        mpx1=QPixmap::fromImage(*mimg1);
//		mpx2=QPixmap::fromImage(*mimg2);
		mpx3=QPixmap::fromImage(*mimg3);
		mpx4=QPixmap::fromImage(*mimg5);
		

        //QGraphicsScene *scene;
		//scene->addPixmap(*mpx1);
		ui.label->setPixmap(mpx1);
		ui.label_3->setPixmap(mpx3);
		ui.label_4->setPixmap(mpx4);
		char outputstr[100];
		char out2[100];
		//sprintf((char*) outputstr,"Levenberg-Marquardt returned in %g iter, reason %g, sumsq %g [%g]\n", info[5], info[6], info[1], info[0]);
		sprintf((char*) out2,"It: %g, Fit: %.7g %.7g %.7g\n",info[5], p[0], p[1], p[2]);

		char outputstr2[100];
		char out22[100];
		/*sprintf((char*) outputstr2,"Levenberg-Marquardt returned in %g iter, reason %g, sumsq %g [%g]\n", info2[5], info2[6], info2[1], info2[0]);
		sprintf((char*) out22,"Best fit parameters: %.7g %.7g %.7g\n", p2[0], p2[1], p2[2]);*/
		//sprintf((char*) outputstr2,"IT %g iter, reason %g, sumsq %g [%g]\n", info2[5], info2[6], info2[1], info2[0]);
		sprintf((char*) out22,"It: %g, Fit: %.7g %.7g %.7g\n",info2[5], p2[0], p2[1], p2[2]);

		//sprintf((char*) outputstr, "A= %f ,1/2sigma^2= %f ,x_0= %f",c(0),c(1),c(2)); 
		//sprintf((char*) out2,"Termination type: %0ld, rms.err: %0.3lf,max.err: %0.3lf",long(info), double(rep.rmserror),double(rep.maxerror));
		//ui.label_5->setText(outputstr);
		ui.label_6->setText(out2);
		//ui.label_8->setText(outputstr2);
		ui.label_9->setText(out22);

		sprintf(bljiedtimer,"%f",(double)(lp_ctr2.QuadPart-lp_ctr1.QuadPart)/(double)lp_freq.QuadPart);
		ui.label_7->setText(bljiedtimer);

		QApplication::processEvents();
	
    /*    QApplication::processEvents();
        mStop=true;
        if(mStop)
            break;*/

	}
    IMAQdxStopAcquisition(*camid0);
	 
}


void aha::slot2(){
	mStop=true;
}