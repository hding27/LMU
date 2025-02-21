using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Net;
using System.IO;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
//                [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
//        public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);

        bool mStop;
        Bitmap mbmp;
        float[] noise_buff;
        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        public static extern void OOI_Config(ushort spec,ushort adctype,ushort irq,ushort baseaddress);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern ushort OOI_FS_LVD_32([In, Out] UInt32[] inputParam, [In,Out] float[] data);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern long OOI_DoScan_Array_Long( ref long[] inputParam, ref float[] data);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern long OOI_SetCurrentUSBSerialNumber(string sn);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern double HR4000_GetIntegrationClockTime();

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern long HR2000_GetCoefficients_LVD(string serial, ref float[] coeffs, ref long[] nlorder);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern long USB_GC_LVD(string serial, [In, Out] float[] coeffs, ref long nlorder);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern ushort OOI_GetNumberOfPixels();

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern void OOI_GetCurrentUSBSerialNumber([System.Runtime.InteropServices.MarshalAs(UnmanagedType.LPStr)]StringBuilder sn);

        [DllImport("ooidrv32.DLL", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        public static extern void OOI_SetTrigTimeout(int TimeOut);

        private string mSerial = "HR2B511";
        public Form1()
        {
            InitializeComponent();
            noise_buff = null;
        }

        private void button1_Click(object sender, EventArgs e)
        {
//            OOI_SetCurrentUSBSerialNumber(mSerial);
            int numpix = OOI_GetNumberOfPixels();
            float[] Y_values = new float[numpix];
            float[] X_values = new float[numpix];
            float m_summ;
            mStop = false;

            get_X(ref X_values, numpix);
            while (!mStop)
            {
                get_Y(100, ref Y_values,false);
                if (noise_buff != null)
                    for (int i = 0; i < numpix; i++)
                        Y_values[i] -= noise_buff[i];
                m_summ = 0;
                for (int i = 0; i < numpix; i++)
                    m_summ += Y_values[i];
                textBox6.Text = m_summ.ToString();

                mpaint(X_values, Y_values);
//                mPainter.draw2d(X_values, Y_values, panel1);
                Application.DoEvents();
            }

/*
            System.IO.StreamWriter sw = new System.IO.StreamWriter("C:\\app_junk\\spec_HR_2000.txt");
            for(int i=0;i<numpix;i++)
                sw.WriteLine(X_values[i].ToString()+"\t" + Y_values[i].ToString());

            sw.Close();
 */
            

        }
        private void mpaint(float[] xx, float[] yy)
        {
            mbmp = new Bitmap(panel1.Width, panel1.Height);
            mPainter.draw2d(xx, yy, mbmp);
            panel1.Invalidate();

        }
        private void launchHWSetup()
        {
            float[] arr = new float[10];
            UInt32[] inppar = new UInt32[18];

            inppar[0] = 1;	//Command
            inppar[1] = 0;	//Flash delay
            inppar[2] = 200;	//Sample Frequency
            inppar[3] = 0;	//Boxcar smoothing width
            inppar[4] = 1;	//Samples to average
            inppar[5] = 0;	//Scan Dark       (bool)
            inppar[6] = 0;	//Correct for electrical dark signal (bool)
            inppar[7] = 0;	//external trigger
            inppar[8] = 1;	//Enable Master Spectrometer (bool)
            inppar[9] = 0;	//Enable Slave 1 Spectrometer (bool)
            inppar[10] = 0;	//Enable Slave 2 Spectrometer (bool)
            inppar[11] = 0;	//Enable Slave 3 Spectrometer (bool)
            inppar[12] = 0;	//Enable Slave 4 Spectrometer (bool)
            inppar[13] = 0;	//Enable Slave 5 Spectrometer (bool)
            inppar[14] = 0;	//Enable Slave 6 Spectrometer (bool)
            inppar[15] = 0;	//Enable Slave 7 Spectrometer (bool)
            inppar[16] = 0;	//use uSec/Long Integration (bool)
            inppar[17] = 30000;	//uSec/Long Integration


            int bb = OOI_FS_LVD_32(inppar, arr);


            StringBuilder mserial = new StringBuilder(50);
            
            OOI_GetCurrentUSBSerialNumber(mserial);
            MessageBox.Show("Found Spectrometer serial#:"+mserial.ToString());
            mSerial = mserial.ToString();

        }
        private void get_Y(long inttime, ref float[] arr, bool hw_triggered)
        {


            //Serial HR2B511
            //OOI_SetCurrentUSBSerialNumber(mSerial);

	//	    OOI_Config(9,12,7,768);
            

            

	

	        UInt32[] inppar = new UInt32[18];
	
            inppar[0]=0;	//Command
	        inppar[1]=0;	//Flash delay
	        inppar[2]=200;	//Sample Frequency
	        inppar[3]=0;	//Boxcar smoothing width
	        inppar[4]=1;	//Samples to average
	        inppar[5]=0;	//Scan Dark       (bool)
	        inppar[6]=0;	//Correct for electrical dark signal (bool)
            inppar[7]=0;	//hw trigger
	        inppar[8]=1;	//Enable Master Spectrometer (bool)
	        inppar[9]=0;	//Enable Slave 1 Spectrometer (bool)
	        inppar[10]=0;	//Enable Slave 2 Spectrometer (bool)
	        inppar[11]=0;	//Enable Slave 3 Spectrometer (bool)
	        inppar[12]=0;	//Enable Slave 4 Spectrometer (bool)
	        inppar[13]=0;	//Enable Slave 5 Spectrometer (bool)
	        inppar[14]=0;	//Enable Slave 6 Spectrometer (bool)
	        inppar[15]=0;	//Enable Slave 7 Spectrometer (bool)
	        inppar[16]=1;	//use uSec/Long Integration (bool)
	        inppar[17]=100000;	//uSec/Long Integration

            if (hw_triggered)
            {
                OOI_SetTrigTimeout(2000);   //2s?
                inppar[7] = 1;
            }

	        int bb=OOI_FS_LVD_32(  inppar,  arr);
            button1.Text = "aa";
	//FreeLibrary(ooLib);


}

//---------------------------------------------------------------------------

     private void get_X(ref float[] arr,int numpix){




		//OOI_Config(9,12,7,768);
		//OOI_SetCurrentUSBSerialNumber(mSerial);

	

	UInt32[] inppar = new UInt32[18];
	inppar[0]=0;	//Command
	inppar[1]=0;	//Flash delay
	inppar[2]=10;	//Sample Frequency
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


	OOI_FS_LVD_32(inppar, arr);
	float[] cfs = new float[14];
	long nlorder;
         nlorder=0;
	USB_GC_LVD(mSerial, cfs, ref nlorder);
	for(int i=0;i<numpix;i++)
		arr[i]=cfs[0]+ cfs[1]*i + cfs[2]*i*i + cfs[3]*i*i*i;
	


}

     private void button2_Click(object sender, EventArgs e)
     {
         mStop = true;
         
     }

     private void button3_Click(object sender, EventArgs e)
     {
         launchHWSetup();
     }

     private void button4_Click(object sender, EventArgs e)
     {

         button1.Enabled = false;
         button3.Enabled = false;
         button4.Enabled = false;
         button6.Enabled = false;
         button7.Enabled = false;



         FtpWebRequest ftpreq;       // = (FtpWebRequest)FtpWebRequest.Create("ftp://130.183.92.172//dazzler_set");

         FtpWebResponse ftpresp;

         string rem_path = "ftp://" + textBox1.Text + "//";
         string loc_path = textBox5.Text;
         string loc_file;
         string rem_file;
         string log_loc_file;
         string log_rem_file;
         float m_summ;

         Stream responseStream;
         StreamReader sr;
         StreamWriter sw;
         FileStream fs;

         BinaryReader br;
         BinaryWriter bw;

         string mCurDate;
         string mRunNo;
         string mShotNo;


         int numpix;
         float[] Y_values;
         float[] X_values;

         OOI_SetCurrentUSBSerialNumber(mSerial);
         numpix = OOI_GetNumberOfPixels();
         Y_values = new float[numpix];
         X_values = new float[numpix];


         get_X(ref X_values, numpix);



         mStop = false;
         label2.Enabled = true;

         //first - check wheter the flags are already there - and delete them
         ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "spectrometer_prepare");
         ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
         try
         {
             ftpreq.GetResponse().Close();
         }
         catch (Exception ee) { ; }


         //----------------------------------------------------------



         while (!mStop)
         {

             ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "spectrometer_prepare");
             ftpreq.Method = WebRequestMethods.Ftp.DownloadFile;


             try
             {
                 ftpresp = (FtpWebResponse)ftpreq.GetResponse();
             }
             catch (Exception ee)
             {

                 System.Threading.Thread.Sleep(500);

                 if (label2.Text == "X")
                     label2.Text = "O";
                 else
                     label2.Text = "X";

                 Application.DoEvents();
                 continue;
             }

             responseStream = ftpresp.GetResponseStream();
             sr = new StreamReader(responseStream);

             mCurDate = sr.ReadLine();
             mRunNo = sr.ReadLine();
             mShotNo = sr.ReadLine();
             mRunNo = Convert.ToInt32(mRunNo).ToString("000");
             mShotNo = Convert.ToInt32(mShotNo).ToString("0000");

             sr.Close();
             responseStream.Close();
             ftpresp.Close();

             textBox2.Text = mCurDate;
             textBox3.Text = mRunNo;
             textBox4.Text = mShotNo;

             //Check whether local path exists:
             if (!Directory.Exists(loc_path + mCurDate))
                 Directory.CreateDirectory(loc_path + mCurDate);

             if (!Directory.Exists(loc_path + mCurDate + "\\Run" + mRunNo))
                 Directory.CreateDirectory(loc_path + mCurDate + "\\Run" + mRunNo);

             loc_file = loc_path + mCurDate + "\\Run" + mRunNo + "\\Shot" + mShotNo + "_spectrometer.dat";
             rem_file = rem_path + mCurDate + "//Run" + mRunNo + "//Shot" + mShotNo + "_spectrometer.dat";
             log_loc_file=loc_path + mCurDate + "\\Run" + mRunNo + "\\log_spectrometer.txt";
             log_rem_file = rem_path + mCurDate + "//Run" + mRunNo + "//log_spectrometer.txt";
             //grabSingle(false,true,loc_file);

             //-----------------------  Acquire spectrum
             get_Y(100, ref Y_values, true);
             if (noise_buff != null)
                 for (int i = 0; i < numpix; i++)
                     Y_values[i] -= noise_buff[i];

             m_summ = 0;
             for (int i = 0; i < numpix; i++)
                 m_summ+=Y_values[i];
             textBox6.Text = m_summ.ToString();
             mPainter.draw2d(X_values, Y_values, panel1);
             Application.DoEvents();
             //----------------------------------------

             //----------------------- Save locally:

             sw = new StreamWriter(loc_file);
             sw.WriteLine("Lambda\tI(Lambda)");
             for(int i=0;i<numpix;i++)
                 sw.WriteLine(X_values[i].ToString("######0.0")+"\t"+Y_values[i].ToString("#####0.0"));
             sw.Close();
             //---------------------------------------
             //----------------------- Update log:
             if (!File.Exists(log_loc_file))
             {
                 sw = new StreamWriter(log_loc_file);
                 sw.WriteLine("Shot#\tsumm");
                 sw.Close();
             }
             sw = new StreamWriter(log_loc_file, true);
             sw.WriteLine(mShotNo + "\t" + m_summ.ToString());
             sw.Close();
            


             //------------------------------------------


             //Delete _prepare file:
             ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "spectrometer_prepare");
             ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
             try
             {
                 ftpreq.GetResponse().Close();
             }
             catch (Exception ee) { }

             //Check whether remote path exists:
             //Date:
             ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + mCurDate);
             ftpreq.Method = WebRequestMethods.Ftp.MakeDirectory;
             try
             {
                 ftpreq.GetResponse().Close();
             }
             catch (Exception ee) { }

             //Run:
             ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + mCurDate + "//Run" + mRunNo);
             ftpreq.Method = WebRequestMethods.Ftp.MakeDirectory;
             try
             {
                 ftpreq.GetResponse().Close();
             }
             catch (Exception ee) { }

             //Upload measurement:
             ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_file);
             ftpreq.Method = WebRequestMethods.Ftp.UploadFile;
             responseStream = ftpreq.GetRequestStream();
             bw = new BinaryWriter(responseStream);
             bw.Write(File.ReadAllBytes(loc_file));

             bw.Close();
             responseStream.Close();

             //upload log:

             ftpreq = (FtpWebRequest)FtpWebRequest.Create(log_rem_file);
             ftpreq.Method = WebRequestMethods.Ftp.UploadFile;
             responseStream = ftpreq.GetRequestStream();
             bw = new BinaryWriter(responseStream);
             bw.Write(File.ReadAllBytes(log_loc_file));

             bw.Close();
             responseStream.Close();
             ftpreq.GetResponse().Close();

         }

         label2.Enabled = false;
         button1.Enabled = true;
         button3.Enabled = true;
         button4.Enabled = true;
         button6.Enabled = true;
         button7.Enabled = true;

     }

     private void button5_Click(object sender, EventArgs e)
     {
         mStop = true;
     }

     private void button7_Click(object sender, EventArgs e)
     {
         int numpix = OOI_GetNumberOfPixels();
         float[] Y_values = new float[numpix];
         float[] X_values = new float[numpix];
         float m_summ;

         get_X(ref X_values, numpix);
         get_Y(100, ref Y_values, true);
         if (noise_buff != null)
             for (int i = 0; i < numpix; i++)
                 Y_values[i] -= noise_buff[i];

         m_summ = 0;
         for (int i = 0; i < numpix; i++)
             m_summ += Y_values[i];
         textBox6.Text = m_summ.ToString();

         mPainter.draw2d(X_values, Y_values, panel1);
         Application.DoEvents();
         


     }

     private void button6_Click(object sender, EventArgs e)
     {
         FolderBrowserDialog fbd = new FolderBrowserDialog();

         if (fbd.ShowDialog() == DialogResult.OK)
             textBox5.Text = fbd.SelectedPath+"\\";
     }

     private void panel1_Paint(object sender, PaintEventArgs e)
     {
         if(mbmp!=null)
         panel1.CreateGraphics().DrawImage(mbmp, 0, 0);

     }

     private void button8_Click(object sender, EventArgs e)
     {
         int numpix = OOI_GetNumberOfPixels();
         noise_buff = new float[numpix];
         get_Y(100, ref noise_buff, true);
     } 

    }
}
