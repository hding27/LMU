#pragma once
#include "uEye.h"


namespace grenouille_thing {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;
	using namespace System::Net;
	using namespace System::Threading;
	using namespace System::IO;

	/// <summary>
	/// Summary for Form1
	///
	/// WARNING: If you change the name of this class, you will need to change the
	///          'Resource File Name' property for the managed resource compiler tool
	///          associated with all .resx files this class depends on.  Otherwise,
	///          the designers will not be able to interact properly with localized
	///          resources associated with this form.
	/// </summary>
	HICON	m_hIcon;

	// uEye varibles
	HIDS	m_hCam;			// handle to camera
	HWND	m_hWndDisplay;	// handle to diplay window
	INT		m_Ret;			// return value of uEye SDK functions
	INT		m_nColorMode;	// Y8/RGB16/RGB24/REG32
	INT		m_nBitsPerPixel;// number of bits needed store one pixel
	INT		m_nSizeX;		// width of video 
	INT		m_nSizeY;		// height of video
	INT		m_lMemoryId;	// grabber memory - buffer ID
	char*	m_pcImageMemory;// grabber memory - pointer to buffer
    INT     m_nRenderMode;  // render  mode

	int bla;
    INT InitCamera (HIDS *hCam, HWND hWnd);
	bool OpenCamera();
    void LoadParameters();
    void GetMaxImageSize(INT *pnSizeX, INT *pnSizeY);

	bool OpenCamera(int camId)
	{
		if ( m_hCam != 0 )
		{
		//free old image mem.
			is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
			is_ExitCamera( m_hCam );
		}

		// init camera
		m_hCam = (HIDS) camId;						// open next camera
		m_Ret = InitCamera (&m_hCam, NULL);		// init camera - no window handle required
		if( m_Ret == IS_SUCCESS )
		{	
			GetMaxImageSize(&m_nSizeX, &m_nSizeY);
			        
			// setup the color depth to the current windows setting
			is_GetColorDepth (m_hCam, &m_nBitsPerPixel, &m_nColorMode);
			is_SetColorMode (m_hCam, m_nColorMode);

			// memory initialization
			is_AllocImageMem (	m_hCam,
								m_nSizeX,
								m_nSizeY,
								m_nBitsPerPixel,
								&m_pcImageMemory,
								&m_lMemoryId);
			is_SetImageMem (m_hCam, m_pcImageMemory, m_lMemoryId);	// set memory active
	
			// display initialization
			is_SetImageSize (m_hCam, m_nSizeX, m_nSizeY);
			is_SetDisplayMode (m_hCam, IS_SET_DM_DIB);

			// enable the dialog based error report
			m_Ret = is_SetErrorReport (m_hCam, IS_ENABLE_ERR_REP); //IS_DISABLE_ERR_REP);
			if (m_Ret != IS_SUCCESS)
			{
				
				System::Windows::Forms::MessageBox::Show("ERROR: Can not enable the automatic uEye error report!");
				return false;
			}


		}
		else
		{
			System::Windows::Forms::MessageBox::Show("ERROR: Can not open uEye camera!");
			return false;
		}

		return true;
	}
	INT InitCamera (HIDS *hCam, HWND hWnd)
	{
		INT nRet = is_InitCamera (hCam, hWnd);	
		/************************************************************************************************/
		/*                                                                                              */
		/*  If the camera returns with "IS_STARTER_FW_UPLOAD_NEEDED", an upload of a new firmware       */
		/*  is necessary. This upload can take several seconds. We recommend to check the required      */
		/*  time with the function is_GetDuration().                                                    */
		/*                                                                                              */
		/*  In this case, the camera can only be opened if the flag "IS_ALLOW_STARTER_FW_UPLOAD"        */ 
		/*  is "OR"-ed to m_hCam. This flag allows an automatic upload of the firmware.                 */
		/*                                                                                              */                        
		/************************************************************************************************/
		if (nRet == IS_STARTER_FW_UPLOAD_NEEDED)
		{
	        // Time for the firmware upload = 25 seconds by default
			INT nUploadTime = 25000;
			is_GetDuration (NULL, IS_SE_STARTER_FW_UPLOAD, &nUploadTime);
			String^ mstr = gcnew String("");
			
			
			mstr = "This camera requires a new firmware. The upload will take about";
//			Str2 = "seconds. Please wait ...";
//			Str3.Format ("%s %d %s", Str1, nUploadTime / 1000, Str2);
			System::Windows::Forms::MessageBox::Show (mstr);
    
			// Set mouse to hourglass
//			SetCursor(AfxGetApp()->LoadStandardCursor(IDC_WAIT));
	
			// Try again to open the camera. This time we allow the automatic upload of the firmware by
			// specifying "IS_ALLOW_STARTER_FIRMWARE_UPLOAD"
			*hCam = (HIDS) (((INT)*hCam) | IS_ALLOW_STARTER_FW_UPLOAD); 
			nRet = is_InitCamera (hCam, hWnd);   
		}
    
		return nRet;
	}


	void GetMaxImageSize(INT *pnSizeX, INT *pnSizeY)
	{
	    // Check if the camera supports an arbitrary AOI
	    INT nAOISupported = 0;
	    BOOL bAOISupported = TRUE;
	    if (is_ImageFormat(m_hCam,
							IMGFRMT_CMD_GET_ARBITRARY_AOI_SUPPORTED, 
							(void*)&nAOISupported, 
							sizeof(nAOISupported)) == IS_SUCCESS)
		{
	        bAOISupported = (nAOISupported != 0);
	    }

	    if (bAOISupported)
	    {
			// Get maximum image size
			SENSORINFO sInfo;
			is_GetSensorInfo (m_hCam, &sInfo);
			*pnSizeX = sInfo.nMaxWidth;
			*pnSizeY = sInfo.nMaxHeight;
		}
		else
		{
	        // Get image size of the current format
			*pnSizeX = is_SetImageSize(m_hCam, IS_GET_IMAGE_SIZE_X, 0);
			*pnSizeY = is_SetImageSize(m_hCam, IS_GET_IMAGE_SIZE_Y, 0);
		}
	}


	public ref class Form1 : public System::Windows::Forms::Form
	{
	public:
		Form1(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
			m_pcImageMemory=NULL;
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~Form1()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::Button^  button1;
			 bool mStop;
	private: System::Windows::Forms::Button^  button2;
	private: System::Windows::Forms::Panel^  panel1;

	private: System::Windows::Forms::ComboBox^  comboBox1;
	private: System::Windows::Forms::Label^  label1;
	private: System::Windows::Forms::Button^  button4;
	private: System::Windows::Forms::TextBox^  textBox1;
	private: System::Windows::Forms::Label^  label2;
	private: System::Windows::Forms::Button^  button3;
	private: System::Windows::Forms::Panel^  panel2;
	private: System::Windows::Forms::Label^  label6;
	private: System::Windows::Forms::Label^  label5;
	private: System::Windows::Forms::Label^  label4;
	private: System::Windows::Forms::TextBox^  textBox5;
	private: System::Windows::Forms::TextBox^  textBox4;
	private: System::Windows::Forms::TextBox^  textBox3;
	private: System::Windows::Forms::Label^  label3;
	private: System::Windows::Forms::TextBox^  textBox2;
	private: System::Windows::Forms::Button^  button5;
	private: System::Windows::Forms::Label^  label7;
	private: System::Windows::Forms::TextBox^  textBox6;
	private: System::Windows::Forms::Button^  button7;
	private: System::Windows::Forms::Button^  button6;
	private: System::Windows::Forms::Button^  button8;
	private: System::Windows::Forms::Label^  label8;
	private: System::Windows::Forms::Button^  button9;

	protected: 

	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>
		System::ComponentModel::Container ^components;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->button1 = (gcnew System::Windows::Forms::Button());
			this->button2 = (gcnew System::Windows::Forms::Button());
			this->panel1 = (gcnew System::Windows::Forms::Panel());
			this->comboBox1 = (gcnew System::Windows::Forms::ComboBox());
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->button4 = (gcnew System::Windows::Forms::Button());
			this->textBox1 = (gcnew System::Windows::Forms::TextBox());
			this->label2 = (gcnew System::Windows::Forms::Label());
			this->button3 = (gcnew System::Windows::Forms::Button());
			this->panel2 = (gcnew System::Windows::Forms::Panel());
			this->label8 = (gcnew System::Windows::Forms::Label());
			this->button7 = (gcnew System::Windows::Forms::Button());
			this->button6 = (gcnew System::Windows::Forms::Button());
			this->button5 = (gcnew System::Windows::Forms::Button());
			this->label7 = (gcnew System::Windows::Forms::Label());
			this->textBox6 = (gcnew System::Windows::Forms::TextBox());
			this->label6 = (gcnew System::Windows::Forms::Label());
			this->label5 = (gcnew System::Windows::Forms::Label());
			this->label4 = (gcnew System::Windows::Forms::Label());
			this->textBox5 = (gcnew System::Windows::Forms::TextBox());
			this->textBox4 = (gcnew System::Windows::Forms::TextBox());
			this->textBox3 = (gcnew System::Windows::Forms::TextBox());
			this->label3 = (gcnew System::Windows::Forms::Label());
			this->textBox2 = (gcnew System::Windows::Forms::TextBox());
			this->button8 = (gcnew System::Windows::Forms::Button());
			this->button9 = (gcnew System::Windows::Forms::Button());
			this->panel2->SuspendLayout();
			this->SuspendLayout();
			// 
			// button1
			// 
			this->button1->Location = System::Drawing::Point(15, 236);
			this->button1->Name = L"button1";
			this->button1->Size = System::Drawing::Size(75, 23);
			this->button1->TabIndex = 0;
			this->button1->Text = L"start video";
			this->button1->UseVisualStyleBackColor = true;
			this->button1->Click += gcnew System::EventHandler(this, &Form1::button1_Click);
			// 
			// button2
			// 
			this->button2->Location = System::Drawing::Point(15, 265);
			this->button2->Name = L"button2";
			this->button2->Size = System::Drawing::Size(75, 23);
			this->button2->TabIndex = 1;
			this->button2->Text = L"stop video";
			this->button2->UseVisualStyleBackColor = true;
			this->button2->Click += gcnew System::EventHandler(this, &Form1::button2_Click);
			// 
			// panel1
			// 
			this->panel1->BorderStyle = System::Windows::Forms::BorderStyle::Fixed3D;
			this->panel1->Location = System::Drawing::Point(119, 100);
			this->panel1->Name = L"panel1";
			this->panel1->Size = System::Drawing::Size(359, 285);
			this->panel1->TabIndex = 2;
			// 
			// comboBox1
			// 
			this->comboBox1->FormattingEnabled = true;
			this->comboBox1->Location = System::Drawing::Point(25, 42);
			this->comboBox1->Name = L"comboBox1";
			this->comboBox1->Size = System::Drawing::Size(161, 21);
			this->comboBox1->TabIndex = 5;
			// 
			// label1
			// 
			this->label1->AutoSize = true;
			this->label1->Location = System::Drawing::Point(26, 26);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(96, 13);
			this->label1->TabIndex = 6;
			this->label1->Text = L"Available cameras:";
			// 
			// button4
			// 
			this->button4->Location = System::Drawing::Point(190, 40);
			this->button4->Name = L"button4";
			this->button4->Size = System::Drawing::Size(75, 23);
			this->button4->TabIndex = 7;
			this->button4->Text = L"refresh";
			this->button4->UseVisualStyleBackColor = true;
			this->button4->Click += gcnew System::EventHandler(this, &Form1::button4_Click);
			// 
			// textBox1
			// 
			this->textBox1->Location = System::Drawing::Point(353, 42);
			this->textBox1->Name = L"textBox1";
			this->textBox1->Size = System::Drawing::Size(100, 20);
			this->textBox1->TabIndex = 8;
			this->textBox1->Text = L"100";
			// 
			// label2
			// 
			this->label2->AutoSize = true;
			this->label2->Location = System::Drawing::Point(350, 26);
			this->label2->Name = L"label2";
			this->label2->Size = System::Drawing::Size(98, 13);
			this->label2->TabIndex = 9;
			this->label2->Text = L"Exposure time [ms]:";
			this->label2->Click += gcnew System::EventHandler(this, &Form1::label2_Click);
			// 
			// button3
			// 
			this->button3->Location = System::Drawing::Point(15, 325);
			this->button3->Name = L"button3";
			this->button3->Size = System::Drawing::Size(98, 23);
			this->button3->TabIndex = 10;
			this->button3->Text = L"grab single hw";
			this->button3->UseVisualStyleBackColor = true;
			this->button3->Click += gcnew System::EventHandler(this, &Form1::button3_Click);
			// 
			// panel2
			// 
			this->panel2->BorderStyle = System::Windows::Forms::BorderStyle::FixedSingle;
			this->panel2->Controls->Add(this->label8);
			this->panel2->Controls->Add(this->button7);
			this->panel2->Controls->Add(this->button6);
			this->panel2->Controls->Add(this->button5);
			this->panel2->Controls->Add(this->label7);
			this->panel2->Controls->Add(this->textBox6);
			this->panel2->Controls->Add(this->label6);
			this->panel2->Controls->Add(this->label5);
			this->panel2->Controls->Add(this->label4);
			this->panel2->Controls->Add(this->textBox5);
			this->panel2->Controls->Add(this->textBox4);
			this->panel2->Controls->Add(this->textBox3);
			this->panel2->Controls->Add(this->label3);
			this->panel2->Controls->Add(this->textBox2);
			this->panel2->Location = System::Drawing::Point(12, 405);
			this->panel2->Name = L"panel2";
			this->panel2->Size = System::Drawing::Size(487, 108);
			this->panel2->TabIndex = 11;
			// 
			// label8
			// 
			this->label8->BorderStyle = System::Windows::Forms::BorderStyle::Fixed3D;
			this->label8->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 24, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->label8->Location = System::Drawing::Point(444, 62);
			this->label8->Name = L"label8";
			this->label8->Size = System::Drawing::Size(35, 39);
			this->label8->TabIndex = 20;
			this->label8->Text = L"X";
			// 
			// button7
			// 
			this->button7->Location = System::Drawing::Point(358, 55);
			this->button7->Name = L"button7";
			this->button7->Size = System::Drawing::Size(75, 43);
			this->button7->TabIndex = 19;
			this->button7->Text = L"stop";
			this->button7->UseVisualStyleBackColor = true;
			this->button7->Click += gcnew System::EventHandler(this, &Form1::button7_Click);
			// 
			// button6
			// 
			this->button6->Location = System::Drawing::Point(358, 10);
			this->button6->Name = L"button6";
			this->button6->Size = System::Drawing::Size(75, 43);
			this->button6->TabIndex = 18;
			this->button6->Text = L"start daemon";
			this->button6->UseVisualStyleBackColor = true;
			this->button6->Click += gcnew System::EventHandler(this, &Form1::button6_Click);
			// 
			// button5
			// 
			this->button5->Location = System::Drawing::Point(149, 62);
			this->button5->Name = L"button5";
			this->button5->Size = System::Drawing::Size(55, 23);
			this->button5->TabIndex = 17;
			this->button5->Text = L"browse";
			this->button5->UseVisualStyleBackColor = true;
			this->button5->Click += gcnew System::EventHandler(this, &Form1::button5_Click);
			// 
			// label7
			// 
			this->label7->AutoSize = true;
			this->label7->Location = System::Drawing::Point(7, 48);
			this->label7->Name = L"label7";
			this->label7->Size = System::Drawing::Size(107, 13);
			this->label7->TabIndex = 16;
			this->label7->Text = L"Path to local storage:";
			// 
			// textBox6
			// 
			this->textBox6->Location = System::Drawing::Point(10, 64);
			this->textBox6->Name = L"textBox6";
			this->textBox6->Size = System::Drawing::Size(133, 20);
			this->textBox6->TabIndex = 15;
			this->textBox6->Text = L"D:\\DATA\\";
			// 
			// label6
			// 
			this->label6->AutoSize = true;
			this->label6->Location = System::Drawing::Point(238, 74);
			this->label6->Name = L"label6";
			this->label6->Size = System::Drawing::Size(32, 13);
			this->label6->TabIndex = 14;
			this->label6->Text = L"Shot:";
			// 
			// label5
			// 
			this->label5->AutoSize = true;
			this->label5->Location = System::Drawing::Point(240, 48);
			this->label5->Name = L"label5";
			this->label5->Size = System::Drawing::Size(30, 13);
			this->label5->TabIndex = 13;
			this->label5->Text = L"Run:";
			// 
			// label4
			// 
			this->label4->AutoSize = true;
			this->label4->Location = System::Drawing::Point(192, 22);
			this->label4->Name = L"label4";
			this->label4->Size = System::Drawing::Size(78, 13);
			this->label4->TabIndex = 12;
			this->label4->Text = L"Wrapped date:";
			// 
			// textBox5
			// 
			this->textBox5->Enabled = false;
			this->textBox5->Location = System::Drawing::Point(276, 67);
			this->textBox5->Name = L"textBox5";
			this->textBox5->Size = System::Drawing::Size(63, 20);
			this->textBox5->TabIndex = 11;
			// 
			// textBox4
			// 
			this->textBox4->Enabled = false;
			this->textBox4->Location = System::Drawing::Point(276, 41);
			this->textBox4->Name = L"textBox4";
			this->textBox4->Size = System::Drawing::Size(63, 20);
			this->textBox4->TabIndex = 10;
			// 
			// textBox3
			// 
			this->textBox3->Enabled = false;
			this->textBox3->Location = System::Drawing::Point(276, 15);
			this->textBox3->Name = L"textBox3";
			this->textBox3->Size = System::Drawing::Size(63, 20);
			this->textBox3->TabIndex = 9;
			// 
			// label3
			// 
			this->label3->AutoSize = true;
			this->label3->Location = System::Drawing::Point(7, 6);
			this->label3->Name = L"label3";
			this->label3->Size = System::Drawing::Size(78, 13);
			this->label3->TabIndex = 7;
			this->label3->Text = L"ftp server addr:";
			// 
			// textBox2
			// 
			this->textBox2->Location = System::Drawing::Point(10, 22);
			this->textBox2->Name = L"textBox2";
			this->textBox2->Size = System::Drawing::Size(104, 20);
			this->textBox2->TabIndex = 0;
			this->textBox2->Text = L"130.183.92.172";
			// 
			// button8
			// 
			this->button8->Location = System::Drawing::Point(15, 354);
			this->button8->Name = L"button8";
			this->button8->Size = System::Drawing::Size(98, 23);
			this->button8->TabIndex = 12;
			this->button8->Text = L"stop waiting";
			this->button8->UseVisualStyleBackColor = true;
			this->button8->Click += gcnew System::EventHandler(this, &Form1::button8_Click);
			// 
			// button9
			// 
			this->button9->Location = System::Drawing::Point(22, 157);
			this->button9->Name = L"button9";
			this->button9->Size = System::Drawing::Size(75, 23);
			this->button9->TabIndex = 13;
			this->button9->Text = L"service";
			this->button9->UseVisualStyleBackColor = true;
			this->button9->Click += gcnew System::EventHandler(this, &Form1::button9_Click);
			// 
			// Form1
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(511, 525);
			this->Controls->Add(this->button9);
			this->Controls->Add(this->button8);
			this->Controls->Add(this->panel2);
			this->Controls->Add(this->button3);
			this->Controls->Add(this->label2);
			this->Controls->Add(this->textBox1);
			this->Controls->Add(this->button4);
			this->Controls->Add(this->label1);
			this->Controls->Add(this->comboBox1);
			this->Controls->Add(this->panel1);
			this->Controls->Add(this->button2);
			this->Controls->Add(this->button1);
			this->Name = L"Form1";
			this->Text = L"Grenouille thing";
			this->FormClosed += gcnew System::Windows::Forms::FormClosedEventHandler(this, &Form1::Form1_FormClosed);
			this->panel2->ResumeLayout(false);
			this->panel2->PerformLayout();
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion
	private: System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) {
				 //Graphics^ gr = pictureBox1->CreateGraphics();
		mStop=false;
		double expTime=Convert::ToDouble(textBox1->Text);

		if ( m_hCam == 0 ){
			if(comboBox1->Items->Count==0)
				OpenCamera(0);
			else{
				int camId=Convert::ToInt32(comboBox1->Items[comboBox1->SelectedIndex]->ToString());
				OpenCamera(camId);
			}
		}


		if ( m_hCam != 0 )
		{
			button1->Enabled=false;
			comboBox1->Enabled=false;

			int i=0;
			is_SetExposureTime(m_hCam,expTime,&expTime);

			while(!mStop){
				if( is_FreezeVideo( m_hCam, IS_WAIT ) == IS_SUCCESS ){
					is_RenderBitmap( m_hCam, m_lMemoryId,(HWND) this->panel1->Handle.ToInt32(), IS_RENDER_NORMAL);
					this->Text=(i++).ToString();
					Application::DoEvents();
				}

			}
			button1->Enabled=true;
			comboBox1->Enabled=true;

			is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
			is_ExitCamera( m_hCam );
			m_hCam=0;

		}				 
				 
	}
	private: System::Boolean grabSingle(bool sw_triggered, bool saveToFile, String^ fname){

		double expTime=Convert::ToDouble(textBox1->Text);
		
		if ( m_hCam == 0 ){
			if(comboBox1->Items->Count==0)
				OpenCamera(0);
			else{
				int camId=Convert::ToInt32(comboBox1->Items[comboBox1->SelectedIndex]->ToString());
				OpenCamera(camId);
			}
		}


		if ( m_hCam != 0 )
		{

			
			is_SetExposureTime(m_hCam,expTime,&expTime);
			if(sw_triggered)
				is_SetExternalTrigger(m_hCam,IS_SET_TRIGGER_SOFTWARE);
			else
				is_SetExternalTrigger(m_hCam,IS_SET_TRIGGER_LO_HI);

			if( is_FreezeVideo( m_hCam, IS_WAIT ) == IS_SUCCESS ){
				is_RenderBitmap( m_hCam, m_lMemoryId,(HWND) this->panel1->Handle.ToInt32(), IS_RENDER_NORMAL);

			}
			if(saveToFile){
				saveImage(fname);
			}

			is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
			is_ExitCamera( m_hCam );
			m_hCam=0;

			return true;

		}				
		return false;
	
	}

	private: System::Void Form1_FormClosed(System::Object^  sender, System::Windows::Forms::FormClosedEventArgs^  e) {
		
		if ( grenouille_thing::m_hCam != 0 )
		{
			//free old image mem.
			is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
			is_ExitCamera( m_hCam );
		}

			 }
	private: System::Void button2_Click(System::Object^  sender, System::EventArgs^  e) {
				 mStop=true;
			 }

private: System::Void saveImage(String^ fname){

			 if(m_pcImageMemory==NULL)
				 return;
			
			 System::IO::MemoryStream^ ms = gcnew System::IO::MemoryStream();

			 array<System::Byte,1>^ marr = gcnew array<System::Byte,1>(m_nBitsPerPixel/8*m_nSizeX*m_nSizeY);
			 
			 Runtime::InteropServices::Marshal::Copy((IntPtr)m_pcImageMemory,marr,0,marr->Length);
			 
			 IO::FileStream^fs = gcnew IO::FileStream(fname,IO::FileMode::Create);
			 
			 System::IO::BinaryWriter ^br = gcnew System::IO::BinaryWriter(fs);
			 
			 br->Write(marr,0,marr->Length);
			 br->Close();
			 fs->Close();
}




		 // Get list of available cameras:
private: System::Void button4_Click(System::Object^  sender, System::EventArgs^  e) {
			
			int nCams=0;
			UEYE_CAMERA_LIST* camList;
			is_GetNumberOfCameras(&nCams);
			
			camList = (UEYE_CAMERA_LIST*) new char [sizeof (DWORD)+ nCams*sizeof (UEYE_CAMERA_INFO)];
			
			

			camList->dwCount=nCams;
			
			is_GetCameraList(camList);

			comboBox1->Items->Clear();
			
			for(int i=0;i<nCams;i++){
			
				comboBox1->Items->Add(Convert::ToString((unsigned int)camList->uci[i].dwCameraID));
			}
			
			delete[] camList;
			if(nCams>0)
				comboBox1->SelectedIndex=0;
			else
				Windows::Forms::MessageBox::Show("No cameras found;(","Sorry..");

		 }
private: System::Void label2_Click(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void button3_Click(System::Object^  sender, System::EventArgs^  e) {
			 grabSingle(true,false,"");
		 }

		 //STOP WAITING FOR TRIGGER:
private: System::Void button8_Click(System::Object^  sender, System::EventArgs^  e) {
			
			 if(m_hCam!=0){
				 is_ForceTrigger(m_hCam);
			 }

		 }
private: System::Void button5_Click(System::Object^  sender, System::EventArgs^  e) {
			 FolderBrowserDialog^ fbd = gcnew FolderBrowserDialog();

			 if(fbd->ShowDialog()==Windows::Forms::DialogResult::OK)
				 textBox6->Text=fbd->SelectedPath+"\\";
		 }



		 //START FTP DAEMON
private: System::Void button6_Click(System::Object^  sender, System::EventArgs^  e) {

            button6->Enabled = false;
            FtpWebRequest^ ftpreq;       // = (FtpWebRequest)FtpWebRequest.Create("ftp://130.183.92.172//dazzler_set");
            FtpWebResponse^ ftpresp;
            String^ rem_path="ftp://"+textBox2->Text+"//";
            String^ loc_path=textBox6->Text;
            String^ loc_file;
            String^ rem_file;

            Stream^ responseStream;
            StreamReader^ sr;
            StreamWriter^ sw;
			FileStream^ fs;

			BinaryReader^ br;
			BinaryWriter^ bw;
            
			String^ mCurDate;
			String^ mRunNo;
			String^ mShotNo;
            
            
            
            mStop = false;

            while (!mStop) {

				ftpreq=(FtpWebRequest^)FtpWebRequest::Create(rem_path+"grenouille_prepare");
				ftpreq->Method = WebRequestMethods::Ftp::DownloadFile;
				

                try
                {
                    ftpresp = (FtpWebResponse^)ftpreq->GetResponse();
                    
                }
                catch(Exception^ ee){
					
					Thread::Sleep(1000);

                    if (label8->Text == "X")
                        label8->Text = "O";
                    else
                        label8->Text = "X";
					
					Application::DoEvents();
                    continue;
                }
                
                responseStream = ftpresp->GetResponseStream();
                sr = gcnew StreamReader(responseStream);
				
				
				mCurDate=sr->ReadLine();
				mRunNo=sr->ReadLine();
				mShotNo = sr->ReadLine();
				mRunNo=Convert::ToInt32(mRunNo).ToString("000");
				mShotNo=Convert::ToInt32(mShotNo).ToString("0000");


                responseStream->Close();
                ftpresp->Close();

                textBox3->Text=mCurDate;
                textBox4->Text=mRunNo;
				textBox5->Text=mShotNo;

				//Check whether local path exists:
				if(!Directory::Exists(loc_path+mCurDate))
					Directory::CreateDirectory(loc_path+mCurDate);

				if(!Directory::Exists(loc_path+mCurDate+"\\Run"+mRunNo))
					Directory::CreateDirectory(loc_path+mCurDate+"\\Run"+mRunNo);

				loc_file=loc_path+mCurDate+"\\Run"+mRunNo+"\\Shot"+mShotNo+"_grenouille.dat";
				rem_file=rem_path+mCurDate+"//Run"+mRunNo+"//Shot"+mShotNo+"_grenouille.dat";
                //grabSingle(false,true,loc_file);
				grabSingle_test(false,true,loc_file);

				//Delete _prepare file:
				ftpreq = (FtpWebRequest^)FtpWebRequest::Create(rem_path+"grenouille_prepare");
				ftpreq->Method = WebRequestMethods::Ftp::DeleteFile;
				try{
					ftpreq->GetResponse()->Close();
				}catch(Exception^ e){}

				//Check whether remote path exists:
				//Date:
				ftpreq = (FtpWebRequest^)FtpWebRequest::Create(rem_path+mCurDate);
				ftpreq->Method=WebRequestMethods::Ftp::MakeDirectory;
				try{
					ftpreq->GetResponse()->Close();
				}catch(Exception^ e){}

				//Run:
				ftpreq = (FtpWebRequest^)FtpWebRequest::Create(rem_path+mCurDate+"//Run"+mRunNo);
				ftpreq->Method=WebRequestMethods::Ftp::MakeDirectory;
				try{
					ftpreq->GetResponse()->Close();
				}catch(Exception^ e){}

				//Upload measurement:
				ftpreq = (FtpWebRequest^)FtpWebRequest::Create(rem_file);
				ftpreq->Method = WebRequestMethods::Ftp::UploadFile;
                responseStream = ftpreq->GetRequestStream();
				fs = gcnew FileStream(loc_file,FileMode::Open);
				bw = gcnew BinaryWriter(responseStream);
				br = gcnew BinaryReader(fs);
				
				while(fs->Position<fs->Length)
					bw->Write(br->ReadByte());
                    

                br->Close();
                bw->Close();
                responseStream->Close();
				fs->Close();
				
            

                
            }


            button6->Enabled = true;


		 }
private: System::Void button7_Click(System::Object^  sender, System::EventArgs^  e) {

			 mStop=true;
		 }
private: System::Void grabSingle_test(bool sw_trigger,bool saveToFile,String^ fname){

			 Drawing::Bitmap^ mbmp = gcnew Drawing::Bitmap(600,600,Drawing::Imaging::PixelFormat::Format32bppRgb);

			 
			 Drawing::Graphics^ mgr = Drawing::Graphics::FromImage(mbmp);
			 System::Drawing::Font^ drawFont = gcnew System::Drawing::Font("Arial", 16);
			 System::Drawing::SolidBrush^ drawBrush = gcnew System::Drawing::SolidBrush(System::Drawing::Color::White);

			 mgr->DrawString(fname,drawFont,drawBrush,0,0);

			 delete mgr;

			 mbmp->Save(fname);
			 mgr = panel1->CreateGraphics();
			 mgr->DrawImage(mbmp,0,0);
			 

			 delete drawFont;
			 delete drawBrush;
			 delete mgr;
			 delete mbmp;

			 
			


		 }
private: System::Void button9_Click(System::Object^  sender, System::EventArgs^  e) {
			 grabSingle_test(false,true,"c:\\app_junk\\imim.bmp");
		 }
};
}

