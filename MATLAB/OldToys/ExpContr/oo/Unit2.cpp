//---------------------------------------------------------------------------

#include <vcl.h>
#include <math.h>
#pragma hdrstop

#include "Unit2.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
#define numpix	3648
TForm2 *Form2;
bool mStop;
bool mRescale;
/*
void OOI_Config(unsigned short spec,unsigned short adctype, unsigned short irq, unsigned short baseaddress);
*/
static void (__stdcall *POOI_Config)(unsigned short spec,unsigned short adctype, unsigned short irq, unsigned short baseaddress);
static unsigned short (__cdecl *POOI_FS_LVD_32)(unsigned long* inputParam, float* data);
static long (__cdecl *POOI_DoScan_Array_Long)(long *inputParam, float* data);
static unsigned long (__cdecl  *POOI_SetCurrentUSBSerialNumber)(char* sn);
static double (__cdecl *PHR4000_GetIntegrationClockTime)(void);
static unsigned long (__cdecl *PHR4000_GetCoefficients_LVD)(char* serial, float* coeffs, long* nlorder);
static HINSTANCE ooLib = NULL;
//---------------------------------------------------------------------------
__fastcall TForm2::TForm2(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm2::Button1Click(TObject *Sender)
{

POOI_Config=NULL;
POOI_FS_LVD_32=NULL;
POOI_SetCurrentUSBSerialNumber=NULL;
PHR4000_GetIntegrationClockTime=NULL;
PHR4000_GetCoefficients_LVD=NULL;

	LARGE_INTEGER lifreq;
	LARGE_INTEGER licnt1,licnt2;
	QueryPerformanceFrequency(&lifreq);
	mStop=false;
	mRescale=true;
	ooLib = LoadLibrary ("ooidrv32.DLL");

   if (ooLib==NULL)  {
	  /*
	   *    The LoadLibrary call failed, return with an error.
	   */
	  MessageBox(NULL,"Failed to load lib","error",MB_OK);
	  return;
   }


   /*
	*    OK, the GPIB library is loaded.  Let's get a pointer to the
	*    requested function.  If the GetProcAddress call fails, then
	*    return with an error.
	*/


   POOI_Config  = (void (__stdcall *)(unsigned short, unsigned short, unsigned short, unsigned short))GetProcAddress(ooLib, (LPCSTR)"OOI_Config_stdcall");
   POOI_FS_LVD_32 = (unsigned short (__cdecl*)(unsigned long*, float*))GetProcAddress(ooLib,(LPCSTR)"OOI_FS_LVD_32");
   POOI_SetCurrentUSBSerialNumber = (unsigned long (__cdecl*)(char*))GetProcAddress(ooLib,(LPCSTR)"OOI_SetCurrentUSBSerialNumber");
	PHR4000_GetIntegrationClockTime= (double (__cdecl*)(void))GetProcAddress(ooLib,(LPCSTR)"OOI_GetIntegrationTime");
	PHR4000_GetCoefficients_LVD= (unsigned long (__cdecl *)(char* serial, float* coeffs, long* nlorder))GetProcAddress(ooLib,(LPCSTR)"HR4000_GetCoefficients_LVD");
   if(POOI_Config==NULL){
		MessageBox(NULL,"Did not find OOI_Config","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }
   if(POOI_FS_LVD_32==NULL){
		MessageBox(NULL,"Did not find OOI_FS_LVD_32","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }
   if(POOI_SetCurrentUSBSerialNumber==NULL){
		MessageBox(NULL,"Did not find OOI_SetCurrentUSBSerialNumber","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }
   if(PHR4000_GetIntegrationClockTime==NULL){
		MessageBox(NULL,"Did not find HR4000_GetIntegrationClockTime","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }
   if(PHR4000_GetCoefficients_LVD==NULL){
		MessageBox(NULL,"Did not find HR4000_GetCoefficients_LVD","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }

	float data[numpix];
	float xx[numpix];
	float* cfs;
	long norder;

	float refdata[numpix];
	for(int i=0;i<numpix;i++){
		data[i]=0;
		refdata[i]=0;
	}
	unsigned long inppar[18];
	inppar[0]=0;	//Command
	inppar[1]=0;	//Flash delay
	inppar[2]=100;	//Sample Frequency
	inppar[3]=0;	//Boxcar smoothing width
	inppar[4]=1;	//Samples to average
	inppar[5]=0;	//Scan Dark       (bool)
	inppar[6]=0;	//Correct for electrical dark signal (bool)
	inppar[7]=0;	//external trigger
	inppar[8]=1;	//Enable Master Spectrometer (bool)
	inppar[9]=0;	//Enable Slave 1 Spectrometer (bool)
	inppar[10]=0;	//Enable Slave 2 Spectrometer (bool)
	inppar[11]=0;	//Enable Slave 3 Spectrometer (bool)
	inppar[12]=0;	//Enable Slave 4 Spectrometer (bool)
	inppar[13]=0;	//Enable Slave 5 Spectrometer (bool)
	inppar[14]=0;	//Enable Slave 6 Spectrometer (bool)
	inppar[15]=0;	//Enable Slave 7 Spectrometer (bool)
	inppar[16]=0;	//use uSec/Long Integration (bool)
	inppar[17]=30000;	//uSec/Long Integration
	int ierr=0;
	(POOI_Config)(1536,12,7,768);
	ierr=(POOI_SetCurrentUSBSerialNumber)("HR4C2050");
	norder=13;
	cfs = new float[13];
	char* sserial="HR4C2050\0";
	for(int i=0;i<13;i++)
		cfs[i]=i;
	(POOI_FS_LVD_32)(inppar,data);		
	ierr=(PHR4000_GetCoefficients_LVD)(sserial,cfs,&norder);
	for(int i=0;i<numpix;i++){
		xx[i]=0;

		xx[i]+=cfs[0] +cfs[1]*(double)i+cfs[2]*(double)i*(double)i+cfs[3]*(double)i*(double)i*(double)i;
	}
	(POOI_FS_LVD_32)(inppar,data);
	inppar[0]=0;
	(POOI_FS_LVD_32)(inppar,data);

/*
	AnsiString bb;
	double scaleX=numpix/(double)PaintBox1->Width;
	double maxVal;
	double minVal;
	double mtime;
	double scaleY=(double)PaintBox1->Height/2000;
		Button1->Enabled=false;
	mtime=(PHR4000_GetIntegrationClockTime)();
	Label2->Caption=AnsiString::FormatFloat("######0.0######",mtime);
	while(!mStop){
		QueryPerformanceCounter(&licnt1);
		(POOI_FS_LVD_32)(inppar,data);
		QueryPerformanceCounter(&licnt2);
		mtime=(double)(licnt2.QuadPart-licnt1.QuadPart)/(double)lifreq.QuadPart*1000;
		Label1->Caption=AnsiString::FormatFloat("###0.0",mtime);

		if(mRescale){
			minVal=1000000;
			maxVal=-1000000;
			for(int i=0;i<numpix;i++){
				data[i]-=refdata[i];
				if(data[i]>maxVal)
					maxVal=data[i];
				if(data[i]<minVal)
					minVal=data[i];
			}
			scaleY=(double)PaintBox1->Height/(maxVal-minVal);
		}
		PaintBox1->Canvas->Brush->Color=clBlack;
		PaintBox1->Canvas->FillRect(TRect(0,0,PaintBox1->Width,PaintBox1->Height));
		PaintBox1->Canvas->Pen->Color=clLime;
		PaintBox1->Canvas->MoveTo(0,PaintBox1->Height-data[0]*scaleY);
		for(int i=1;i<PaintBox1->Width;i++){
			PaintBox1->Canvas->LineTo(i,PaintBox1->Height-(data[(int)((double)i*scaleX)]-minVal)*scaleY);
		}
		Application->ProcessMessages();

	}
	Button1->Enabled=true;
*/

	TFileStream* tf = new TFileStream("C:\\app_junk\\oospec.xls",fmCreate);
	AnsiString bb;
	for(int i=0;i<numpix;i++){
		bb=i;
		bb+="\t";
		bb+=AnsiString::FormatFloat("#######0.0###",xx[i]);
		bb+="\t";
		bb+=AnsiString::FormatFloat("#######0.0###",data[i]);
		bb+="\r\n";
		tf->Write(bb.c_str(),bb.Length());
	}
	tf->Free();

	FreeLibrary(ooLib);
//	MessageBox(NULL,"Check the spectrum!","Okay",MB_OK);

}
//---------------------------------------------------------------------------
void __fastcall TForm2::Button2Click(TObject *Sender)
{
	mStop=true;
}
//---------------------------------------------------------------------------
void __fastcall TForm2::Button3Click(TObject *Sender)
{
	mRescale=true;
}
//---------------------------------------------------------------------------
void __fastcall TForm2::Button4Click(TObject *Sender)
{
POOI_Config=NULL;
POOI_FS_LVD_32=NULL;
POOI_DoScan_Array_Long=NULL;
	mStop=false;
	mRescale=true;
	ooLib = LoadLibrary ("ooidrv32.DLL");

   if (ooLib==NULL)  {
	  /*
	   *    The LoadLibrary call failed, return with an error.
	   */
	  MessageBox(NULL,"Failed to load lib","error",MB_OK);
	  return;
   }


   /*
	*    OK, the GPIB library is loaded.  Let's get a pointer to the
	*    requested function.  If the GetProcAddress call fails, then
	*    return with an error.
	*/


   POOI_Config  = (void (__stdcall *)(unsigned short, unsigned short, unsigned short, unsigned short))GetProcAddress(ooLib, (LPCSTR)"OOI_Config_stdcall");
   POOI_DoScan_Array_Long = (long (__cdecl *)(long*, float*))GetProcAddress(ooLib,(LPCSTR)"OOI_DoScan_Array_Long");

   if(POOI_Config==NULL){
		MessageBox(NULL,"Did not find OOI_Config","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }
   if(POOI_DoScan_Array_Long==NULL){
		MessageBox(NULL,"Did not find OOI_DoScan_Array_Long","Error",MB_OK);
		FreeLibrary(ooLib);
		return;
   }

	float data[8192];
	float refdata[8192];
	for(int i=0;i<8192;i++){
		data[i]=0;
		refdata[i]=0;
	}
	long inppar[16];
	inppar[0]=0;	//Command
	inppar[1]=0;	//Flash delay
	inppar[2]=40;	//Sample Frequency
	inppar[3]=1;	//Boxcar smoothing width
	inppar[4]=5;	//Samples to average
	inppar[5]=1;	//Enable Master Spectrometer (bool)
	inppar[6]=0;	//Enable Slave 1 Spectrometer (bool)
	inppar[7]=0;	//Enable Slave 2 Spectrometer (bool)
	inppar[8]=0;	//Enable Slave 3 Spectrometer (bool)
	inppar[9]=0;	//Enable Slave 4 Spectrometer (bool)
	inppar[10]=0;	//Enable Slave 5 Spectrometer (bool)
	inppar[11]=0;	//Enable Slave 6 Spectrometer (bool)
	inppar[12]=0;	//Enable Slave 7 Spectrometer (bool)

	(POOI_Config)(0,12,7,768);
	for(int i=0;i<15;i++){
		(POOI_DoScan_Array_Long)(inppar,data);
		for(int j=0;j<8192;j++)
			refdata[j]+=data[j]/15;

	}
	double scaleX=2048/(double)PaintBox1->Width;
	double maxVal;
	double minVal;
	double scaleY=(double)PaintBox1->Height/2000;
		Button1->Enabled=false;
	while(!mStop){

		(POOI_DoScan_Array_Long)(inppar,data);
		if(mRescale){
			minVal=1000000;
			maxVal=-1000000;
			for(int i=0;i<2048;i++){
				data[i]-=refdata[i];
				if(data[i]>maxVal)
					maxVal=data[i];
				if(data[i]<minVal)
					minVal=data[i];
			}
			scaleY=(double)PaintBox1->Height/(maxVal-minVal);
		}
		PaintBox1->Canvas->Brush->Color=clBlack;
		PaintBox1->Canvas->FillRect(TRect(0,0,PaintBox1->Width,PaintBox1->Height));
		PaintBox1->Canvas->Pen->Color=clLime;
		PaintBox1->Canvas->MoveTo(0,PaintBox1->Height-data[0]*scaleY);
		for(int i=1;i<PaintBox1->Width;i++){
			PaintBox1->Canvas->LineTo(i,PaintBox1->Height-(data[(int)((double)i*scaleX)]-minVal)*scaleY);
		}
		Application->ProcessMessages();

	}
	Button1->Enabled=true;
/*
	TFileStream* tf = new TFileStream("C:\\app_junk\\oospec.xls",fmCreate);
	AnsiString bb;
	for(int i=0;i<1100;i++){
		bb=i;
		bb+="\t";
		bb+=AnsiString::FormatFloat("#######0.0###",data[i]);
		bb+="\r\n";
		tf->Write(bb.c_str(),bb.Length());
	}
	tf->Free();
*/
	FreeLibrary(ooLib);
//	MessageBox(NULL,"Check the spectrum!","Okay",MB_OK);

}
//---------------------------------------------------------------------------
