using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using System.Threading;

using System.Runtime.InteropServices;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;



namespace WindowsFormsApplication13
{

    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        int d2;
        int d3;
        int d4;
        volatile Thread recThread;
        volatile bool connected;
        volatile bool newMess;
        volatile bool mStop;
        volatile bool sock_in_use;
        volatile bool messSent;
        volatile bool receiveAgain;
        volatile bool receiveRunning;
        volatile int mainThreadId;
        //volatile bool acceptInAction;
        volatile Socket mSocket;
        volatile Socket mcSocket;
        ManualResetEvent jobDone;
        public ManualResetEvent allDone = new ManualResetEvent(false);
        public ManualResetEvent receiveDone = new ManualResetEvent(false);
        public ManualResetEvent sendDone = new ManualResetEvent(false); 
        public volatile mMessage mess = new mMessage(0,0,0);
        //public StateObject state;

        [Serializable]
        public class mMessage
        {
            public int d2;
            public int d3;
            public int d4;
            public double[] lambdas;
            public double[] phases;
            public int arr_length;

            public mMessage(int d2, int d3, int d4)
            {
                this.d2 = d2;
                this.d3 = d3;
                this.d4 = d4;
            }
            public bool mess_fromBytes(byte[] mbytes){
                
                if (mbytes.Length < 16)
                    return false;

                d2= Convert.ToInt32(BitConverter.ToDouble(mbytes, 0));
                d3 = Convert.ToInt32(BitConverter.ToDouble(mbytes, 8));
                d4 = Convert.ToInt32(BitConverter.ToDouble(mbytes, 16));
                arr_length = Convert.ToInt32(BitConverter.ToDouble(mbytes,24));

                if (mbytes.Length < 32 + arr_length * 16)
                    return false;

                lambdas = new double[arr_length];
                phases = new double[arr_length];
                for (int i = 0; i < arr_length; i++)
                {
                    lambdas[i] = BitConverter.ToDouble(mbytes, 32 + i * 16);
                    phases[i] = BitConverter.ToDouble(mbytes, 40 + i * 16);
                }
                return true;
            }

        }

        

        private static void makeByteParcel(mMessage mmess, ref byte[] letter)
        {
            MemoryStream ms = new MemoryStream();

            ms.Write(BitConverter.GetBytes(Convert.ToDouble(mmess.d2)),0,8);
            ms.Write(BitConverter.GetBytes(Convert.ToDouble(mmess.d3)),0,8);
            ms.Write(BitConverter.GetBytes(Convert.ToDouble(mmess.d4)),0,8);
            letter= ms.ToArray();
           

        }

        private static void getParcelFromBytes(mMessage mess, byte[] letter)
        {

            mess.d2=BitConverter.ToInt32(letter, 0);
            mess.d3 = BitConverter.ToInt32(letter, 4);
            mess.d4 = BitConverter.ToInt32(letter, 8);
    
        }



        public  void AcceptCallback(IAsyncResult ar)
        {
            

            while (sock_in_use)
                Thread.Sleep(0);

            sock_in_use = true;            

        
            
            StateObject state = new StateObject();
            try
            {
                mcSocket = mSocket.EndAccept(ar);
            }
            catch (Exception e)
            {
                sock_in_use = false;            
                return;
            }
            mcSocket.NoDelay = true;
            sock_in_use = false;
            mSocket.BeginAccept(new AsyncCallback(AcceptCallback), mSocket);
            connected = true;
            receiveAgain = true;
            
            
        }
        
        public  void ReadCallback(IAsyncResult ar)
        {
            StateObject state = (StateObject)ar.AsyncState;
            Socket handler = state.workSocket;

            
            int bytesRead=0;
            try
            {
                bytesRead = mcSocket.EndReceive(ar);
            }
            catch (Exception e) {
                receiveRunning = false;
                connected = false;
                return;
            }

            if (bytesRead > 0)
            {
                mess.mess_fromBytes(state.buffer);
               // getParcelFromBytes(mess, state.buffer);
                newMess = true;

            }
            else
            {
                connected = false;
            }

            sock_in_use = false;
            receiveRunning = false;
            recThread = null;
            return;

        }

        private  void Send(Socket handler, mMessage mess)
        {
            StateObject state_out = new StateObject();
            StateObject state_in = new StateObject();
            
            makeByteParcel(mess, ref state_out.buffer);
            handler.SendTimeout=1000;
            int bytesSent=0;

            try
            {
                bytesSent=handler.Send(state_out.buffer, 0,12, 0);
            }
            catch (Exception e)
            {
                connected = false;
            }
            if (bytesSent == 0)
                connected = false;
            return;
        }




        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            mStop = true;
        }
        //---------------------



        private void statusStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void toolStripStatusLabel1_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

            string mfile = Application.StartupPath + "settings.txt";
            if(File.Exists(mfile)){
                StreamReader sr = new StreamReader(mfile);

                textBox1.Text=sr.ReadLine();
                textBox2.Text=sr.ReadLine();
                textBox3.Text=sr.ReadLine();
                textBox4.Text=sr.ReadLine();
                textBox5.Text=sr.ReadLine();


                sr.Close();
            }

        }


        private void button5_Click(object sender, EventArgs e)
        {
            mStop = true;
        }

        private void textBox5_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog fbd = new FolderBrowserDialog();

            fbd.Description = "Please select to folder to lacally save logs..";
            fbd.ShowNewFolderButton = true;
            if (fbd.ShowDialog() == DialogResult.OK)
                textBox5.Text = fbd.SelectedPath;

        }

        private void button10_Click(object sender, EventArgs e)
        {
            

        }

        private void button2_Click(object sender, EventArgs e)
        {
            
            if ((textBox1.Text == "")||(textBox2.Text=="")||(textBox3.Text==""))
            {
                MessageBox.Show("Noooooo! first type in some initial values!");
                return;
            }

            textBox1.Text = (Convert.ToDouble(((Button)sender).Text) + Convert.ToInt32(textBox1.Text)).ToString();
            Application.DoEvents();
            setDazzler(Convert.ToInt32(textBox1.Text), Convert.ToInt32(textBox2.Text), Convert.ToInt32(textBox3.Text));
            textBox1.Text = d2.ToString();
            textBox2.Text = d3.ToString();
            textBox3.Text = d4.ToString();


        }

        private void button13_Click(object sender, EventArgs e)
        {
            if ((textBox1.Text == "") || (textBox2.Text == "") || (textBox3.Text == ""))
            {
                MessageBox.Show("Noooooo! first type in some initial values!");
                return;
            }

            textBox2.Text = (Convert.ToDouble(((Button)sender).Text) + Convert.ToInt32(textBox2.Text)).ToString();
            Application.DoEvents();
            setDazzler(Convert.ToInt32(textBox1.Text), Convert.ToInt32(textBox2.Text), Convert.ToInt32(textBox3.Text));
            textBox1.Text = d2.ToString();
            textBox2.Text = d3.ToString();
            textBox3.Text = d4.ToString();

        }

        private void button22_Click(object sender, EventArgs e)
        {
            if ((textBox1.Text == "") || (textBox2.Text == "") || (textBox3.Text == ""))
            {
                MessageBox.Show("Noooooo! first type in some initial values!");
                return;
            }

            textBox3.Text = (Convert.ToDouble(((Button)sender).Text) + Convert.ToInt32(textBox3.Text)).ToString();
            Application.DoEvents();
            setDazzler(Convert.ToInt32(textBox1.Text), Convert.ToInt32(textBox2.Text), Convert.ToInt32(textBox3.Text));
            textBox1.Text = d2.ToString();
            textBox2.Text = d3.ToString();
            textBox3.Text = d4.ToString();

        }

        private bool setDazzler(int d2_new, int d3_new, int d4_new)
        {
            this.BackColor = Color.RosyBrown;
            Application.DoEvents();
            


            this.Enabled = false;
            StreamWriter sw;

            sw = new StreamWriter("c:\\Program Files\\Dazzler\\wave.txt");

            sw.WriteLine("order2=" + d2_new);
            sw.WriteLine("order3=" + d3_new);
            sw.Write("order4=" + d4_new);

            sw.Close();

            sw = new StreamWriter("c:\\Program Files\\Dazzler\\request.txt");
            sw.Write("c:\\Program Files\\Dazzler\\wave.txt");
            sw.Close();

            for(int i=0;i<5;i++){

                if (!File.Exists("c:\\Program Files\\Dazzler\\request.txt"))
                {
                    d2 = d2_new;
                    d3 = d3_new;
                    d4 = d4_new;
                    this.Enabled = true;
                    this.BackColor = Color.DimGray;
                    return true;
                }
                Application.DoEvents();
                Thread.Sleep(500);

            }
            this.Enabled = true;
            
            this.BackColor = Color.DimGray;
            

            return false;
        }

        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((textBox1.Text == "") || (textBox2.Text == "") || (textBox3.Text == ""))
            {
                MessageBox.Show("Noooooo! first type in some initial values!");
                return;
            }

            if (e.KeyChar == '\r')
            {
                setDazzler(Convert.ToInt32(textBox1.Text), Convert.ToInt32(textBox2.Text), Convert.ToInt32(textBox3.Text));
                textBox1.Text = d2.ToString();
                textBox2.Text = d3.ToString();
                textBox3.Text = d4.ToString();
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {
            panel3.Enabled = false;
            button4.Enabled = false;
            textBox4.Enabled = false;
            textBox5.Enabled = false;

            FtpWebRequest ftpreq;       // = (FtpWebRequest)FtpWebRequest.Create("ftp://130.183.92.172//dazzler_set");

            FtpWebResponse ftpresp;

            string rem_path = "ftp://" + textBox4.Text + "//";
            string loc_path = textBox5.Text + "\\";
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

            int d2_new;
            int d3_new;
            int d4_new;

            mStop = false;
            label8.Enabled = true;

            //first - check wheter the flags are already there - and delete them
            ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_doit");
            ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
            try
            {
                ftpreq.GetResponse().Close();
            }
           catch (Exception ee) { ; }


            ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_prepare");
            ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
            try
            {
                ftpreq.GetResponse().Close();
            }
            catch (Exception ee) { ; }

            ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_done");
            ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
            try
            {
                ftpreq.GetResponse().Close();
            }
            catch (Exception ee) { ; }

            //----------------------------------------------------------


           while (!mStop)
            {
                while (true)//check wheter _doit exists. if yes - change values
                {
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_doit");
                    ftpreq.Method = WebRequestMethods.Ftp.DownloadFile;

                    try
                    {
                        ftpresp = (FtpWebResponse)ftpreq.GetResponse();
                    }
                    catch (Exception ee)
                    {
                        
                        break;
                        //if no _doit file - break
                    }
                    //if yes - read three numbers - d2,d3,d4 and change the values. and then make a _done flag

                    responseStream = ftpresp.GetResponseStream();
                    sr = new StreamReader(responseStream);

                    d2_new = (int)Convert.ToDouble(sr.ReadLine());
                    d3_new = (int)Convert.ToDouble(sr.ReadLine());
                    d4_new = (int)Convert.ToDouble(sr.ReadLine());

                    responseStream.Close();
                    ftpresp.Close();


                    //Delete _doit file:
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_doit");
                    ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
                    try
                    {
                        ftpreq.GetResponse().Close();
                    }
                    catch (Exception ee) { ;}


                    if(!setDazzler(d2_new, d3_new, d4_new))
                        MessageBox.Show("Dazzler not responding!");
                    //d2 = d2_new;
                    //d3 = d3_new;
                    //d4 = d4_new;

                    textBox1.Text = d2.ToString();
                    textBox2.Text = d3.ToString();
                    textBox3.Text = d4.ToString();
                    
                    sw = new StreamWriter(loc_path + "daisy_done", false);
                    sw.WriteLine(textBox1.Text);
                    sw.WriteLine(textBox2.Text);
                    sw.WriteLine(textBox3.Text);
                    sw.Close();

                    //Upload report:
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_done");
                    ftpreq.Method = WebRequestMethods.Ftp.UploadFile;
                    try
                    {
                        responseStream = ftpreq.GetRequestStream();
                    }
                    catch (Exception ee)
                    {
                        break;
                    }
//                    fs = new FileStream(loc_path + "daisy_done", FileMode.Open);
                    bw = new BinaryWriter(responseStream);
//                    br = new BinaryReader(fs);

//                    bw.Write(br.ReadBytes((int)fs.Length));
                    bw.Write(File.ReadAllBytes(loc_path+"daisy_done"));

//                    br.Close();
                    bw.Close();
                    responseStream.Close();
//                    fs.Close();

                    ftpreq.GetResponse().Close();

                    break;
                }
                while (true)   //_report case - only report current values for the next shot in a _log file
                {
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_prepare");
                    ftpreq.Method = WebRequestMethods.Ftp.DownloadFile;

                    try
                    {
                        ftpresp = (FtpWebResponse)ftpreq.GetResponse();
                    }
                    catch (Exception ee)
                    {

                        break;
                        //if no _doit file - break
                    }
                    //if yes - read three numbers - date, run and shot. display them locally and create a _log externally
                    responseStream = ftpresp.GetResponseStream();
                    sr = new StreamReader(responseStream);
                    mCurDate = sr.ReadLine();
                    mRunNo = sr.ReadLine();
                    mShotNo = sr.ReadLine();
                    mRunNo = Convert.ToInt32(mRunNo).ToString("000");
                    mShotNo = Convert.ToInt32(mShotNo).ToString("0000");
                    textBox6.Text = mCurDate;
                    textBox7.Text = mRunNo;
                    textBox8.Text = mShotNo;
                    sr.Close();
                    ftpresp.Close();

                    //Delete _prepare file:
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + "daisy_prepare");
                    ftpreq.Method = WebRequestMethods.Ftp.DeleteFile;
                    try
                    {
                        ftpreq.GetResponse().Close();
                    }
                    catch (Exception ee) { ; }

                    if (!Directory.Exists(loc_path + mCurDate))
                        Directory.CreateDirectory(loc_path + mCurDate);

                    if (!Directory.Exists(loc_path + mCurDate + "\\Run" + mRunNo))
                        Directory.CreateDirectory(loc_path + mCurDate + "\\Run" + mRunNo);

                    loc_file = loc_path + mCurDate + "\\Run" + mRunNo + "\\log_daisy.txt";
                    rem_file = rem_path + mCurDate + "//Run" + mRunNo + "//log_daisy.txt";

                    //Add values to log:
                    if (!File.Exists(loc_file))
                    {
                        sw = new StreamWriter(loc_file);
                        sw.WriteLine("shot\td2\td3\td4");
                        sw.Close();
                    }
                    sw = new StreamWriter(loc_file, true);
                    sw.WriteLine(mShotNo+"\t" +textBox1.Text + "\t" + textBox2.Text + "\t" + textBox3.Text);
                    sw.Close();
                    //---------------------------------------
                    //upload log:
                    //Check whether remote path exists:
                    //Date:
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + mCurDate);
                    ftpreq.Method = WebRequestMethods.Ftp.MakeDirectory;
                    try
                    {
                        ftpreq.GetResponse().Close();
                    }
                    catch (Exception ee) { ; }

                    //Run:
                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_path + mCurDate + "//Run" + mRunNo);
                    ftpreq.Method = WebRequestMethods.Ftp.MakeDirectory;
                    try
                    {
                        ftpreq.GetResponse().Close();
                    }
                    catch (Exception ee) { ; }

                    ftpreq = (FtpWebRequest)FtpWebRequest.Create(rem_file);
                    ftpreq.Method = WebRequestMethods.Ftp.UploadFile;
                    responseStream = ftpreq.GetRequestStream();

                    bw = new BinaryWriter(responseStream);
//                    fs = new FileStream(loc_file, FileMode.Open);
//                    br = new BinaryReader(fs);
//                    bw.Write(br.ReadBytes((int)fs.Length));
                    bw.Write(File.ReadAllBytes(loc_file));
//                    fs.Close();
//                    br.Close();
                    bw.Close();
                    responseStream.Close();

                    
                    ftpreq.GetResponse().Close();

                    break;

                }
                System.Threading.Thread.Sleep(500);

                if (label8.Text == "X")
                    label8.Text = "O";
                else
                    label8.Text = "X";

                Application.DoEvents();

            }

            panel3.Enabled = true;
            button4.Enabled = true;
            textBox4.Enabled = true;
            textBox5.Enabled = true;
            label8.Enabled = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string mfile = Application.StartupPath + "settings.txt";
            StreamWriter sw = new StreamWriter(mfile);

            sw.WriteLine(textBox1.Text);
            sw.WriteLine(textBox2.Text);
            sw.WriteLine(textBox3.Text);
            sw.WriteLine(textBox4.Text);
            sw.WriteLine(textBox5.Text);

            sw.Close();
            
        }



    }


    public class StateObject
    {
        // Client  socket.
        public Socket workSocket = null;
        // Size of receive buffer.
        public const int BufferSize = 1024;
        // Receive buffer.
        public byte[] buffer = new byte[BufferSize];
        // Received data string.
        public StringBuilder sb = new StringBuilder();
    }




}

