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


namespace windowmover
{
    public partial class Form1 : Form
    {
        [DllImport("user32.dll", SetLastError = true)]
        static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll", EntryPoint = "FindWindow", SetLastError = true)]
        static extern IntPtr FindWindowByCaption(IntPtr ZeroOnly, string lpWindowName);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowRect(IntPtr hwnd, out RECT lpRect);

        [DllImport("user32.dll", SetLastError = false)]
        static extern IntPtr GetDesktopWindow();

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
        //uFlags:
        const UInt32 SWP_NOSIZE = 0x0001;
        const UInt32 SWP_NOMOVE = 0x0002;
        const UInt32 SWP_NOZORDER = 0x0004;
        const UInt32 SWP_NOREDRAW = 0x0008;
        const UInt32 SWP_NOACTIVATE = 0x0010;
        const UInt32 SWP_FRAMECHANGED = 0x0020;  /* The frame changed: send WM_NCCALCSIZE */
        const UInt32 SWP_SHOWWINDOW = 0x0040;
        const UInt32 SWP_HIDEWINDOW = 0x0080;
        const UInt32 SWP_NOCOPYBITS = 0x0100;
        const UInt32 SWP_NOOWNERZORDER = 0x0200;  /* Don't do owner Z ordering */
        const UInt32 SWP_NOSENDCHANGING = 0x0400;  /* Don't send WM_WINDOWPOSCHANGING */
//----------------------------
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax);
//----------------------------
        [StructLayout(LayoutKind.Sequential)]
        public struct RECT
        {
            public int Left;        // x position of upper-left corner
            public int Top;         // y position of upper-left corner
            public int Right;       // x position of lower-right corner
            public int Bottom;      // y position of lower-right corner
        }
        public struct POINT
        {
            public int X;
            public int Y;
        }
        public struct MSG {
            public IntPtr   hwnd;
            public UInt32   message;
            public short wParam;
            public short lParam;
            public UInt32  time;
            public POINT  pt;
        }
        
        [DllImport("user32.dll")]
        static extern bool SetCursorPos(int X, int Y);

        [DllImport("user32.dll")]
        static extern bool GetCursorPos( out  POINT lpPoint);


//---------------------------------------------
        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
        private const int MOUSEEVENTF_LEFTDOWN = 0x02;
        private const int MOUSEEVENTF_LEFTUP = 0x04;
        private const int MOUSEEVENTF_RIGHTDOWN = 0x08;
        private const int MOUSEEVENTF_RIGHTUP = 0x10;
//---------------------------------------------

        [DllImport("user32")]
        public static extern bool IsIconic(IntPtr hwnd);

//---------------------------------------------

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool SetWindowPlacement(IntPtr hWnd, [In] ref WINDOWPLACEMENT lpwndpl);
        
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetWindowPlacement(IntPtr hWnd, ref WINDOWPLACEMENT lpwndpl);

        [StructLayout(LayoutKind.Sequential)]
        private struct WINDOWPLACEMENT
        {
            public int length;
            public int flags;
            public int showCmd;
            public System.Drawing.Point ptMinPosition;
            public System.Drawing.Point ptMaxPosition;
            public System.Drawing.Rectangle rcNormalPosition;
        }


        //Definitions For Different Window Placement Constants
        const UInt32 SW_HIDE = 0;
        const UInt32 SW_SHOWNORMAL = 1;
        const UInt32 SW_NORMAL = 1;
        const UInt32 SW_SHOWMINIMIZED = 2;
        const UInt32 SW_SHOWMAXIMIZED = 3;
        const UInt32 SW_MAXIMIZE = 3;
        const UInt32 SW_SHOWNOACTIVATE = 4;
        const UInt32 SW_SHOW = 5;
        const UInt32 SW_MINIMIZE = 6;
        const UInt32 SW_SHOWMINNOACTIVE = 7;
        const UInt32 SW_SHOWNA = 8;
        const UInt32 SW_RESTORE = 9;

//-----------------------------------------
        [DllImport("user32.dll")]
        static extern void keybd_event(byte bVk, byte bScan, uint dwFlags,  int dwExtraInfo);
        const byte VK_LWIN = 0x5B;
//----------------------------------------

        public bool mStop;
        public Form1()

        {
            InitializeComponent();
            mStop = false;
        }

        public void moveWindow(string mtitle, int xx, int yy, int nump, int mdelay)
        {
            IntPtr hwnd = FindWindowByCaption((IntPtr)0, mtitle);
            

            if (hwnd != (IntPtr)0)
            {

                RECT rct;
                GetWindowRect(hwnd, out rct);

                for (int i = 0; i < nump; i++)
                {

                    SetWindowPos(hwnd, (IntPtr)0, Convert.ToInt32(rct.Left + (double)(xx - rct.Left) / (double)(nump) * (i+1)),Convert.ToInt32( rct.Top + (double)(yy - rct.Top) / (double)nump * (i+1)), rct.Right - rct.Left, rct.Bottom - rct.Top, SWP_NOSIZE);

                    Application.DoEvents();
                    System.Threading.Thread.Sleep(mdelay);

                }
            }

        }
        public void moveMultiple(string[] titles, int[] xxs, int[] yys, int nump, int mdelay)
        {
            IntPtr[] hwnds = new IntPtr[titles.Length];
            RECT[] mrcts = new RECT[titles.Length];

            for (int i = 0; i < titles.Length; i++)
            {
                hwnds[i] = FindWindowByCaption((IntPtr)0, titles[i]);
                if(hwnds[i]!=(IntPtr)0)
                    GetWindowRect(hwnds[i], out mrcts[i]);
            }


            for (int i = 0; i < nump; i++)
            {
                for (int j = 0; j < titles.Length; j++)
                {

                    if (hwnds[j] != (IntPtr)0)
                        SetWindowPos(hwnds[j], (IntPtr)0, Convert.ToInt32(mrcts[j].Left + (double)(xxs[j] - mrcts[j].Left) / (double)(nump) * (i + 1)), Convert.ToInt32(mrcts[j].Top + (double)(yys[j] - mrcts[j].Top) / (double)nump * (i + 1)), mrcts[j].Right - mrcts[j].Left, mrcts[j].Bottom - mrcts[j].Top, SWP_NOSIZE);
                }
                Application.DoEvents();
                System.Threading.Thread.Sleep(mdelay);

            }

        }
        public int MakeLong (short lowPart, short highPart)
        {
            return (int)(((ushort)lowPart) | (uint)(highPart << 16));
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (System.IO.File.Exists(Application.StartupPath + "\\settings.txt"))
            {
                //                System.IO.FileStream fs = new System.IO.FileStream(Application.StartupPath + "\\settings.txt",System.IO.FileMode.Open);
                System.IO.StreamReader sr = new System.IO.StreamReader(Application.StartupPath + "\\settings.txt");


                textBox2.Text = sr.ReadLine();
                textBox3.Text = sr.ReadLine();


                sr.Close();
            }

            
        }

        private void Form1_Shown(object sender, EventArgs e)
        {

        }

        private void doClick()
        {
            POINT mpt;
            GetCursorPos(out mpt);
            SetCursorPos((short)(Convert.ToDouble(textBox2.Text)), (short)Convert.ToDouble(textBox3.Text));
            mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, (short)(Convert.ToDouble(textBox2.Text)), (short)Convert.ToDouble(textBox3.Text), 0, 0);
            SetCursorPos(mpt.X, mpt.Y);
        }
        private void button1_Click(object sender, EventArgs e)
        {
            this.Enabled = false;
//            GetWindowRect(hwnd, out rct);
            //MessageBox.Show("Found!"+rct.Left.ToString()+";" + rct.Top.ToString());
            doClick();
            //moveWindow(textBox1.Text, Convert.ToInt32(textBox2.Text), Convert.ToInt32(textBox3.Text),50,10);
            this.Enabled = true;
        }


        private void button6_Click(object sender, EventArgs e)
        {
            //if(System.IO.File.Exists(Application.StartupPath+"\\settings.txt")
            System.IO.StreamWriter sw = new System.IO.StreamWriter(Application.StartupPath + "\\settings.txt");


            sw.WriteLine(textBox2.Text);
            sw.WriteLine(textBox3.Text);


            sw.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            button1.Enabled = false;
            button6.Enabled = false;
            button2.Enabled = false;



            FtpWebRequest ftpreq;       // = (FtpWebRequest)FtpWebRequest.Create("ftp://130.183.92.172//dazzler_set");

            FtpWebResponse ftpresp;

            string rem_path = "ftp://" + textBox1.Text + "//";
//            string loc_path = textBox5.Text;
//            string loc_file;
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
            label5.Enabled = true;
            while (!mStop)
            {

                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "ebljied_prepare");
                ftpreq.Method = WebRequestMethods.Ftp.DownloadFile;


                try
                {
                    ftpresp = (FtpWebResponse)ftpreq.GetResponse();
                }
                catch (Exception ee)
                {

                    System.Threading.Thread.Sleep(1000);

                    if (label5.Text == "X")
                        label5.Text = "O";
                    else
                        label5.Text = "X";

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

                textBox4.Text = mCurDate;
                textBox5.Text = mRunNo;
                textBox6.Text = mShotNo;

                //Check whether local path exists:
//                if (!Directory.Exists(loc_path + mCurDate))
//                    Directory.CreateDirectory(loc_path + mCurDate);

//                if (!Directory.Exists(loc_path + mCurDate + "\\Run" + mRunNo))
//                    Directory.CreateDirectory(loc_path + mCurDate + "\\Run" + mRunNo);

//                loc_file = loc_path + mCurDate + "\\Run" + mRunNo + "\\Shot" + mShotNo + "_spectrometer.dat";
//                rem_file = rem_path + mCurDate + "//Run" + mRunNo + "//Shot" + mShotNo + "_spectrometer.dat";
                //grabSingle(false,true,loc_file);

                //-----------------------  Acquire spectrum
//                get_Y(100, ref Y_values, true);

//                mPainter.draw2d(X_values, Y_values, panel1);
                Application.DoEvents();
                doClick();
                //----------------------------------------

                //----------------------- Save locally:

//                sw = new StreamWriter(loc_file);
//                sw.WriteLine("Lambda\tI(Lambda)");
//                for (int i = 0; i < numpix; i++)
//                    sw.WriteLine(X_values[i].ToString("######0.0") + "\t" + Y_values[i].ToString("#####0.0"));
//                sw.Close();
                //---------------------------------------


                //Delete _prepare file:
                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "ebljied_prepare");
                ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
                try
                {
                    ftpreq.GetResponse().Close();
                }
                catch (Exception ee) { }
/*
                //Check whether remote path exists:
                //Date:
//                ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + mCurDate);
//                ftpreq.Method = WebRequestMethods.Ftp.MakeDirectory;
//                try
//                {
//                    ftpreq.GetResponse().Close();
//                }
//                catch (Exception ee) { }

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
                fs = new FileStream(loc_file, FileMode.Open);
                bw = new BinaryWriter(responseStream);
                br = new BinaryReader(fs);

                while (fs.Position < fs.Length)
                    bw.Write(br.ReadByte());


                br.Close();
                bw.Close();
                responseStream.Close();
                fs.Close();
 */




            }

            label5.Enabled = false;
            button1.Enabled = true;
            button2.Enabled = true;
            button6.Enabled = true;

        }

        private void button3_Click(object sender, EventArgs e)
        {
            mStop = true;
        }



    }
}
