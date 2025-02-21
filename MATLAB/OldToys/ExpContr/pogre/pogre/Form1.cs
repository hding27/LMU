using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net;
using System.IO;
using FlyCapture2Managed;

namespace pogre
{
    public partial class Form1 : Form
    {
        ManagedCamera cam;
        ManagedImage rawImage;
        ManagedImage convertedImage;
        ManagedImage bgImage;
        Bitmap mroi;
        Bitmap mfull;
        int flag_droi;
        bool mStop;
        double mScaleFull_x, mScaleFull_y;
        double mScaleRoi_x, mScaleRoi_y;
        public Form1()
        {
            InitializeComponent();
            cam = null;
            rawImage = null;
            convertedImage = null;
            bgImage = null;
            mroi = null;
            mfull = null;
            
            flag_droi = -1;

            if(System.IO.File.Exists(Application.StartupPath+"\\vals.txt")){

                System.IO.StreamReader msr = new System.IO.StreamReader(Application.StartupPath + "\\vals.txt");

                textBox1.Text=msr.ReadLine();
                textBox2.Text=msr.ReadLine();
                textBox3.Text=msr.ReadLine();
                textBox4.Text=msr.ReadLine();
                textBox5.Text=msr.ReadLine();
                textBox10.Text=msr.ReadLine();
                textBox13.Text = msr.ReadLine();
                textBox14.Text = msr.ReadLine();
                msr.Close();
            }

        }

        private void button1_Click(object sender, EventArgs e)
        {
            listCams();
        }

        public void listCams(){

            if (cam != null)
            {
                if (cam.IsConnected())
                {
                    MessageBox.Show("Cannot update camera list: camera already connected");
                    return;
                }
            }
            
            
            
            ManagedBusManager busMgr = new ManagedBusManager();
            uint numCameras = busMgr.GetNumOfCameras();
            

            StringBuilder mStr;
            ManagedPGRGuid guid;
            CameraInfo camInfo;
            

            for (uint i = 0; i < numCameras; i++)
            {
                guid = busMgr.GetCameraFromIndex(i);
                cam = new ManagedCamera();

                // Connect to a camera
                cam.Connect(guid);
                camInfo = cam.GetCameraInfo();
                cam.Disconnect();

                mStr = new StringBuilder();
                mStr.AppendFormat("Index: {0}; ", i);
                mStr.AppendFormat("Serial number: {0}; ", camInfo.serialNumber);
                mStr.AppendFormat("Camera model: {0}; ", camInfo.modelName);
                //mStr.AppendFormat("Camera vendor - {0}\t", camInfo.vendorName);
                //mStr.AppendFormat("Sensor - {0}", camInfo.sensorInfo);
                mStr.AppendFormat("Resolution: {0}", camInfo.sensorResolution);
                

                comboBox1.Items.Add(mStr);
            }
            if (comboBox1.Items.Count > 0)
                comboBox1.SelectedIndex = 0;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (comboBox1.Items.Count < 1)
            {
                MessageBox.Show("First select the camera, IDIOD!");
                return;
            }
            ManagedBusManager busMgr = new ManagedBusManager();
            ManagedPGRGuid guid = busMgr.GetCameraFromIndex((uint)comboBox1.SelectedIndex);

            if (cam == null)
                cam = new ManagedCamera();
            cam.Connect(guid);

            if (cam.IsConnected())
            {
                rawImage = new ManagedImage();
                convertedImage = new ManagedImage();
               // cam.StartCapture();
                comboBox1.Enabled = false;
                button1.Enabled = false;
                button2.Enabled = false;
                grabSingle(false);
                displayImage();
            }
            else
            {
                MessageBox.Show("Sorry, could not open camera.. keine ahnung warum..");
            }

        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (cam != null)
            {
                if (cam.IsConnected())
                {
                    //cam.StopCapture();
                    cam.Disconnect();
                    comboBox1.Enabled = true;
                    button1.Enabled = true;
                    button2.Enabled = true;
                }
            }

        }

        private bool grabSingle(bool hwTriggered)
        {
//                System.Diagnostics.Stopwatch swatch = new System.Diagnostics.Stopwatch();
            byte[] bbuff = new byte[2];
            if (cam == null)
            {
                MessageBox.Show("FIRST OPEN THE CAMERA!!");
                return false;
            }
            if (!cam.IsConnected())
            {
                MessageBox.Show("FIRST OPEN THE CAMERA!!");
                return false;
            }
                
            TriggerMode tm = new TriggerMode();
            tm=cam.GetTriggerMode();
            if (tm.onOff != hwTriggered)
            {
                
                if (hwTriggered)
                {
                    tm.onOff = true;
                    tm.parameter = 0;
                    tm.mode = 0;
                }
                else
                {
                    tm.onOff = false;
                }
                cam.SetTriggerMode(tm);            
            }

            CameraProperty camProp = new CameraProperty(PropertyType.Shutter);
            //camProp.present = true;
            camProp.onOff = true;
            camProp.autoManualMode = false;
            camProp.absControl = true;
            camProp.absValue = 100;
            cam.SetProperty(camProp);

            cam.StartCapture();
//                swatch.Start();
            cam.RetrieveBuffer(rawImage);
                // Convert the raw image
            rawImage.Convert(PixelFormat.PixelFormatBgr, convertedImage);
//                swatch.Stop();

            cam.StopCapture();
                //MessageBox.Show(swatch.ElapsedMilliseconds.ToString());
            return true;
        }
        private void doImage()
        {
            int mval;
            int mmax,mmin;
            int summ;
            int fixScale;
            double mscaleY,mscaleX;
            int nlin = Convert.ToInt32(textBox10.Text);
            
            int roi_ll = Convert.ToInt32(textBox1.Text);
            int roi_tt = Convert.ToInt32(textBox2.Text);
            int roi_rr = Convert.ToInt32(textBox3.Text);
            int roi_bb = Convert.ToInt32(textBox4.Text);
            if (((roi_bb == 0) && (roi_tt == 0)) || (roi_bb == roi_tt))
            {
                roi_tt = 0;
                roi_bb = 1;
            }
            if (((roi_ll == 0) && (roi_rr == 0)) || (roi_ll == roi_rr))
            {
                roi_ll = 0;
                roi_rr = 1;
            }
                

            mroi = new Bitmap(roi_rr - roi_ll, roi_bb - roi_tt);
            mmax=-100;
            mmin=10000;
            summ=0;
            double[] x_int = new double[roi_rr - roi_ll];
            double[] y_int = new double[roi_bb - roi_tt];
            double x_int_summ = 0, y_int_summ = 0;

            for(int i=roi_ll;i<roi_rr;i++)
                for(int j=roi_tt;j<roi_bb;j++){
                    mval=convertedImage.bitmap.GetPixel(i,j).R;
                    if(bgImage!=null)
                        mval-=bgImage.bitmap.GetPixel(i,j).R;
                    if (mval < 0)
                        mval = 0;

                    summ+=mval;
                    if(mval<mmin)
                        mmin=mval;
                    if(mval>mmax)
                        mmax=mval;
                    mroi.SetPixel(i-roi_ll,j-roi_tt,Color.FromArgb(mval,mval,mval));

                    x_int[i-roi_ll] += mval;
                    y_int[j-roi_tt] += mval;
                }
            for(int i=roi_ll;i<roi_rr;i++)
                x_int_summ+=Math.Pow(x_int[i-roi_ll],nlin);
            for (int j = roi_tt; j < roi_bb; j++)
                y_int_summ += Math.Pow(y_int[j - roi_tt],nlin);
            if (x_int_summ == 0)
                x_int_summ = 1;
            if (y_int_summ == 0)
                y_int_summ = 1;

            if (mmax == mmin)
                mmax = mmin + 1;
            //calculate positions:
            double pos_x = 0;
            double pos_y = 0;

            for (int i = 0; i < roi_rr - roi_ll; i++)
                pos_x += Convert.ToDouble(i * Math.Pow(x_int[i],nlin)) / Convert.ToDouble(x_int_summ);
            for (int i = 0; i < roi_bb - roi_tt; i++)
                pos_y += Convert.ToDouble(i * Math.Pow(y_int[i],nlin)) / Convert.ToDouble(y_int_summ);
            //calculate widths:
            double wdt_x=0, wdt_y=0;
            for (int i = 0; i < roi_rr - roi_ll; i++)
                wdt_x += Convert.ToDouble(Math.Sqrt((i - pos_x) * (i - pos_x)) * x_int[i])/Convert.ToDouble(x_int.Sum()!=0?x_int.Sum():1);
            for (int i = 0; i < roi_bb - roi_tt; i++)
                wdt_y += Convert.ToDouble(Math.Sqrt((i - pos_y) * (i - pos_y)) * y_int[i])/Convert.ToDouble(y_int.Sum()!=0?y_int.Sum():1);

            //set text boxes:
            textBox5.Text = summ.ToString();
            textBox6.Text = pos_x.ToString("####.0");
            textBox7.Text = pos_y.ToString("####.0");
            textBox8.Text = ((wdt_x + wdt_y) / 2).ToString("####.0");



            //scale:
            if(checkBox2.Checked)
                try{
                    fixScale=(int)Convert.ToDouble(textBox9.Text);
                }
                catch(Exception e){
                    fixScale=-1313;
                    MessageBox.Show("Invalid fix scale value!");
                }
            else{
                fixScale=-1313;
            }
            for(int i=0;i<roi_rr-roi_ll;i++)
                for (int j = 0; j < roi_bb-roi_tt; j++)
                {
                    mval = mroi.GetPixel(i, j).R;
                    if (fixScale == -1313)
                        mval = Convert.ToInt16(Convert.ToDouble(mval - mmin) / Convert.ToDouble(mmax - mmin) * 255);
                    else
                    {
                        if (mval > fixScale)
                            mval = fixScale;
                        mval = Convert.ToInt16(Convert.ToDouble(mval) / Convert.ToDouble(fixScale) * 255);
                    }
                    mroi.SetPixel(i, j, Color.FromArgb(mval, mval, mval));
                }


            panel1.Invalidate();
            panel3.Invalidate();

        }

        private void displayImage()
        {
            Graphics mgr = panel1.CreateGraphics();

            mgr.DrawImage(convertedImage.bitmap, 0, 0, panel1.Width, panel1.Height);

            mgr.Dispose();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (grabSingle(false))
                doImage();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            if(grabSingle(true))
                displayImage();

        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (cam != null)
                if (cam.IsConnected())
                    cam.Disconnect();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            if (convertedImage == null)
            {
                MessageBox.Show("Please first acquire an image!");
                return;
            }
            MessageBox.Show("After clicking OK here, perform the first mouse click on the top-left corner of ROI,\r\n followed by a click on the bottom-right!\r\nSO: OKAY followed by two  mouse clicks");
            flag_droi = 0;
        }

        private void button7_Click(object sender, EventArgs e)
        {
            if(grabSingle(false))
                bgImage = new ManagedImage(convertedImage);
        }

        private void button8_Click(object sender, EventArgs e)
        {
            System.IO.StreamWriter msw = new System.IO.StreamWriter(Application.StartupPath + "\\vals.txt");
            
            msw.WriteLine(textBox1.Text);
            msw.WriteLine(textBox2.Text);
            msw.WriteLine(textBox3.Text);
            msw.WriteLine(textBox4.Text);
            msw.WriteLine(textBox5.Text);
            msw.WriteLine(textBox10.Text);
            msw.WriteLine(textBox11.Text);
            msw.WriteLine(textBox13.Text);
            msw.WriteLine(textBox14.Text);
            msw.Close();
        }

        private void panel1_Click(object sender, EventArgs e)
        {
           
        }

        private void panel1_MouseClick(object sender, MouseEventArgs e)
        {
            if (flag_droi == 0)
            {
                textBox1.Text = Convert.ToInt32(Convert.ToDouble(e.X) * Convert.ToDouble(convertedImage.bitmap.Width) / Convert.ToDouble(panel1.Width)).ToString();
                textBox2.Text = Convert.ToInt32(Convert.ToDouble(e.Y) * Convert.ToDouble(convertedImage.bitmap.Height) / Convert.ToDouble(panel1.Height)).ToString();
                flag_droi++;
            }
            else if (flag_droi == 1)
            {
                textBox3.Text = Convert.ToInt32(Convert.ToDouble(e.X) * Convert.ToDouble(convertedImage.bitmap.Width) / Convert.ToDouble(panel1.Width)).ToString();
                textBox4.Text = Convert.ToInt32(Convert.ToDouble(e.Y) * Convert.ToDouble(convertedImage.bitmap.Height) / Convert.ToDouble(panel1.Height)).ToString();
                flag_droi++;
            }

        }

        private void button9_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            fbd.ShowNewFolderButton = true;
            fbd.Description = "Please select the folder to save runs and shots to";
            if (fbd.ShowDialog() == DialogResult.OK)
                textBox14.Text = fbd.SelectedPath;
        }

        private void button10_Click(object sender, EventArgs e)
        {
            if(cam==null){
                MessageBox.Show("FIRST OPEN THE CAMERA!");
                return;
            }
            if(!cam.IsConnected()){
                MessageBox.Show("FIRST OPEN THE CAMERA!");
                return;
            }
                
            button1.Enabled = false;
            button2.Enabled = false;
            button3.Enabled = false;
            button4.Enabled = false;
            button5.Enabled = false;
            button6.Enabled = false;
            button7.Enabled = false;
            button8.Enabled = false;
            button9.Enabled = false;
            button10.Enabled = false;

            string flagname = textBox11.Text;


            FtpWebRequest ftpreq;       // = (FtpWebRequest)FtpWebRequest.Create("ftp://130.183.92.172//dazzler_set");

            FtpWebResponse ftpresp;

            string rem_path = "ftp://" + textBox13.Text + "//";
            string loc_path = textBox14.Text+"\\";
            string loc_file;
            string rem_file;

            Stream responseStream;
            StreamReader sr;
            StreamWriter sw;
            FileStream fs;

            BinaryReader br;
            BinaryWriter bw;

            string mCurDate;
            string mRunNo;
            string mShotNo;

            mStop = false;
            label12.Enabled = true;

            //Delete _prepare file:
            ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + flagname + "_prepare");
            ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
            try
            {
                ftpreq.GetResponse().Close();
            }
            catch (Exception ee) { }

            k
            while (!mStop)
            {

                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + flagname+"_prepare");
                ftpreq.Method = WebRequestMethods.Ftp.DownloadFile;

                try
                {
                    ftpresp = (FtpWebResponse)ftpreq.GetResponse();
                }
                catch (Exception ee)
                {

                    System.Threading.Thread.Sleep(500);

                    if (label12.Text == "X")
                        label12.Text = "O";
                    else
                        label12.Text = "X";

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


                responseStream.Close();
                ftpresp.Close();

                textBox16.Text = mCurDate;
                textBox15.Text = mRunNo;
                textBox17.Text = mShotNo;

                //Check whether local path exists:
                if (!Directory.Exists(loc_path + mCurDate))
                    Directory.CreateDirectory(loc_path + mCurDate);

                if (!Directory.Exists(loc_path + mCurDate + "\\Run" + mRunNo))
                    Directory.CreateDirectory(loc_path + mCurDate + "\\Run" + mRunNo);

                loc_file = loc_path + mCurDate + "\\Run" + mRunNo + "\\Shot" + mShotNo ;
                rem_file = rem_path + mCurDate + "//Run" + mRunNo + "//Shot" + mShotNo ;

                grabSingle(true);
                doImage();


                Application.DoEvents();

                //----------------------- Save locally:

                //First - picture:

                convertedImage.bitmap.Save(loc_file+"_"+flagname+".bmp");

                //Second log with calculated values:
                if(!File.Exists(loc_file+"_"+flagname+"_log.txt")){
                    sw = new StreamWriter(loc_file+"_"+flagname+"_log.txt");
                    sw.WriteLine("shot\tsumm\tposx\tposy\twdt");
                    sw.Close();
                }
                sw = new StreamWriter(loc_file+"_"+flagname+"_log.txt",true);
                sw.WriteLine(textBox17.Text+"\t"+textBox5.Text+"\t"+textBox6.Text+"\t"+textBox7.Text+"\t"+textBox8.Text);
                sw.Close();
                //---------------------------------------


                //Delete _prepare file:
                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + flagname+"_prepare");
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
                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_file+"_"+flagname+".bmp");
                ftpreq.Method = WebRequestMethods.Ftp.UploadFile;
                responseStream = ftpreq.GetRequestStream();
                fs = new FileStream(loc_file+"_"+flagname+".bmp", FileMode.Open);
                bw = new BinaryWriter(responseStream);
                br = new BinaryReader(fs);

                bw.Write(br.ReadBytes((int)fs.Length));

                br.Close();
                bw.Close();
                responseStream.Close();
                fs.Close();

                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_file+"_"+flagname+"_log.txt");
                ftpreq.Method = WebRequestMethods.Ftp.UploadFile;
                responseStream = ftpreq.GetRequestStream();
                fs = new FileStream(loc_file+"_"+flagname+"_log.txt", FileMode.Open);
                bw = new BinaryWriter(responseStream);
                br = new BinaryReader(fs);

                bw.Write(br.ReadBytes((int)fs.Length));

                br.Close();
                bw.Close();
                responseStream.Close();
                fs.Close();

            }

            label12.Enabled = false;
            button1.Enabled = true;
            button2.Enabled = true;
            button3.Enabled = true;
            button4.Enabled = true;
            button5.Enabled = true;
            button6.Enabled = true;
            button7.Enabled = true;
            button8.Enabled = true;
            button9.Enabled = true;
            button10.Enabled = true;

        }

        private void button11_Click(object sender, EventArgs e)
        {
            mStop = true;
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            if (convertedImage == null)
                return;

            int roi_ll = Convert.ToInt32(textBox1.Text);
            int roi_tt = Convert.ToInt32(textBox2.Text);
            int roi_rr = Convert.ToInt32(textBox3.Text);
            int roi_bb = Convert.ToInt32(textBox4.Text);
            if (((roi_bb == 0) && (roi_tt == 0)) || (roi_bb == roi_tt))
            {
                roi_tt = 0;
                roi_bb = 1;
            }
            if (((roi_ll == 0) && (roi_rr == 0)) || (roi_ll == roi_rr))
            {
                roi_ll = 0;
                roi_rr = 1;
            }

            Graphics mgr = panel1.CreateGraphics();

            mgr.DrawImage(convertedImage.bitmap, 0, 0, panel1.Width, panel1.Height);
            double mscaleX = Convert.ToDouble(panel1.Width) / Convert.ToDouble(convertedImage.bitmap.Width);
            double mscaleY = Convert.ToDouble(panel1.Height) / Convert.ToDouble(convertedImage.bitmap.Height);

            mgr.DrawLine(new Pen(Color.Red), Convert.ToInt32(roi_ll * mscaleX), Convert.ToInt32(roi_tt * mscaleY), Convert.ToInt32(roi_rr * mscaleX), Convert.ToInt32(roi_tt * mscaleY));
            mgr.DrawLine(new Pen(Color.Red), Convert.ToInt32(roi_ll * mscaleX), Convert.ToInt32(roi_bb * mscaleY), Convert.ToInt32(roi_rr * mscaleX), Convert.ToInt32(roi_bb * mscaleY));
            mgr.DrawLine(new Pen(Color.Red), Convert.ToInt32(roi_ll * mscaleX), Convert.ToInt32(roi_bb * mscaleY), Convert.ToInt32(roi_ll * mscaleX), Convert.ToInt32(roi_tt * mscaleY));
            mgr.DrawLine(new Pen(Color.Red), Convert.ToInt32(roi_rr * mscaleX), Convert.ToInt32(roi_bb * mscaleY), Convert.ToInt32(roi_rr * mscaleX), Convert.ToInt32(roi_tt * mscaleY));

            mgr.Dispose();

        }

        private void panel3_Paint(object sender, PaintEventArgs e)
        {
            if (mroi == null)
                return;
            int roi_ll = Convert.ToInt32(textBox1.Text);
            int roi_tt = Convert.ToInt32(textBox2.Text);
            int roi_rr = Convert.ToInt32(textBox3.Text);
            int roi_bb = Convert.ToInt32(textBox4.Text);
            if (((roi_bb == 0) && (roi_tt == 0)) || (roi_bb == roi_tt))
            {
                roi_tt = 0;
                roi_bb = 1;
            }
            if (((roi_ll == 0) && (roi_rr == 0)) || (roi_ll == roi_rr))
            {
                roi_ll = 0;
                roi_rr = 1;
            }

            Graphics mgr = panel3.CreateGraphics();
            double  mscaleX = Convert.ToDouble(panel3.Width) / Convert.ToDouble(roi_rr - roi_ll);
            double mscaleY = Convert.ToDouble(panel3.Height) / Convert.ToDouble(roi_bb - roi_tt);

            double pos_x=Convert.ToDouble(textBox6.Text);
            double pos_y = Convert.ToDouble(textBox7.Text);
            double mwdt = Convert.ToDouble(textBox8.Text);

            mgr.DrawImage(mroi, 0, 0, panel3.Width, panel3.Height);
            mgr.DrawLine(new Pen(Color.Green), Convert.ToInt32(pos_x * mscaleX), 0, Convert.ToInt32(pos_x * mscaleX), panel3.Height);
            mgr.DrawLine(new Pen(Color.Green), 0, Convert.ToInt32(pos_y * mscaleY), panel3.Width, Convert.ToInt32(pos_y * mscaleY));
            mgr.DrawEllipse(new Pen(Color.Green), Convert.ToInt32((pos_x - mwdt) * mscaleX), Convert.ToInt32((pos_y - mwdt) * mscaleY), Convert.ToInt32((2 * mwdt) * mscaleX), Convert.ToInt32((2 * mwdt) * mscaleY));
            mgr.Dispose();

        }

    }
}
