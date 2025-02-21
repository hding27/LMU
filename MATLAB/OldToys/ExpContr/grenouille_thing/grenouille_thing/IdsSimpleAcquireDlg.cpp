//===========================================================================//
//                                                                           //
//  Copyright (C) 2004 - 2010                                                //
//  IDS Imaging GmbH                                                         //
//  Dimbacherstr. 6-8                                                        //
//  D-74182 Obersulm-Willsbach                                               //
//                                                                           //
//  The information in this document is subject to change without            //
//  notice and should not be construed as a commitment by IDS Imaging GmbH.  //
//  IDS Imaging GmbH does not assume any responsibility for any errors       //
//  that may appear in this document.                                        //
//                                                                           //
//  This document, or source code, is provided solely as an example          //
//  of how to utilize IDS software libraries in a sample application.        //
//  IDS Imaging GmbH does not assume any responsibility for the use or       //
//  reliability of any portion of this document or the described software.   //
//                                                                           //
//  General permission to copy or modify, but not for profit, is hereby      //
//  granted,  provided that the above copyright notice is included and       //
//  reference made to the fact that reproduction privileges were granted	 //
//	by IDS Imaging GmbH.				                                     //
//                                                                           //
//  IDS cannot assume any responsibility for the use or misuse of any        //
//  portion of this software for other than its intended diagnostic purpose	 //
//  in calibrating and testing IDS manufactured cameras and software.		 //
//                                                                           //
//===========================================================================//

// IdsSimpleAcquireDlg.cpp : implementation file
//

#include "stdafx.h"
#include "IdsSimpleAcquire.h"
#include "IdsSimpleAcquireDlg.h"
#include ".\idssimpleacquiredlg.h"

extern CIdsSimpleAcquireApp theApp;

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CIdsSimpleAcquireDlg dialog

CIdsSimpleAcquireDlg::CIdsSimpleAcquireDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CIdsSimpleAcquireDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CIdsSimpleAcquireDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CIdsSimpleAcquireDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CIdsSimpleAcquireDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CIdsSimpleAcquireDlg, CDialog)
	//{{AFX_MSG_MAP(CIdsSimpleAcquireDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_EXIT, OnButtonExit)
	ON_BN_CLICKED(IDC_BUTTON_ACQUIRE, OnButtonAcquire)
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_LOAD_PARAMETER, OnBnClickedButtonLoadParameter)
    ON_WM_CLOSE()
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CIdsSimpleAcquireDlg message handlers

BOOL CIdsSimpleAcquireDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

#ifndef _WIN32_WCE
	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}
#endif
	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	m_hCam = 0;	

	m_hWndDisplay = GetDlgItem( IDC_DISPLAY )->m_hWnd; // set display window handle

	m_nSizeX = 640;		//rc.right - rc.left;	// set video width  to fit into display window
	m_nSizeY = 480;		//rc.bottom - rc.top;	// set video height to fit into display window
    m_nRenderMode = IS_RENDER_FIT_TO_WINDOW;

	OpenCamera();		// open a camera handle

#ifdef _WIN32_WCE
    LoadParameters();
#endif

	return true;

}



void CIdsSimpleAcquireDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}


// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CIdsSimpleAcquireDlg::OnPaint() 
{
	if (IsIconic())
	{
#ifndef _WIN32_WCE
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
#endif
	}
	else
	{
		CDialog::OnPaint();
	}
}



// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CIdsSimpleAcquireDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}


///////////////////////////////////////////////////////////////////////////////
//
// METHOD CIdsSimpleAcquireDlg::OnButtonAcquire() 
//
// DESCRIPTION: - acquire a single frame
//				- display frame
//
///////////////////////////////////////////////////////////////////////////////
void CIdsSimpleAcquireDlg::OnButtonAcquire() 
{
	if ( m_hCam == 0 )
		OpenCamera();

	if ( m_hCam != 0 )
	{
		if( is_FreezeVideo( m_hCam, IS_WAIT ) == IS_SUCCESS )
			is_RenderBitmap( m_hCam, m_lMemoryId, m_hWndDisplay, m_nRenderMode );
	}
}


///////////////////////////////////////////////////////////////////////////////
//
// METHOD CIdsSimpleAcquireDlg::OnBnClickedButtonLoadParameter() 
//
// DESCRIPTION: - loads parameters from an ini file
//				- reallocates the memory
//
///////////////////////////////////////////////////////////////////////////////
void CIdsSimpleAcquireDlg::OnBnClickedButtonLoadParameter()
{
#ifdef _WIN32_WCE
    LoadParameters();
#else
	if ( m_hCam == 0 )
		OpenCamera();

	if ( m_hCam != 0 )
	{
		if( is_LoadParameters( m_hCam, NULL ) == IS_SUCCESS )
		{
			// realloc image mem with actual sizes and depth.
			is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
			m_nSizeX = is_SetImageSize( m_hCam, IS_GET_IMAGE_SIZE_X, 0 );
			m_nSizeY = is_SetImageSize( m_hCam, IS_GET_IMAGE_SIZE_Y, 0 );
			switch( is_SetColorMode( m_hCam, IS_GET_COLOR_MODE ) )
			{
			case IS_SET_CM_RGB32:
				m_nBitsPerPixel = 32;
				break;
			case IS_SET_CM_RGB24:
				m_nBitsPerPixel = 24;
				break;
			case IS_SET_CM_RGB16:
			case IS_SET_CM_UYVY:
				m_nBitsPerPixel = 16;
				break;
			case IS_SET_CM_RGB15:
				m_nBitsPerPixel = 15;
				break;
			case IS_SET_CM_Y8:
			case IS_SET_CM_RGB8:
			case IS_SET_CM_BAYER:
			default:
				m_nBitsPerPixel = 8;
				break;
			}

			// memory initialization
			is_AllocImageMem( m_hCam,
							m_nSizeX,
							m_nSizeY,
							m_nBitsPerPixel,
							&m_pcImageMemory,
							&m_lMemoryId);
			is_SetImageMem(m_hCam, m_pcImageMemory, m_lMemoryId );	// set memory active

			// display initialization
			is_SetImageSize(m_hCam, m_nSizeX, m_nSizeY );
		}
	}
#endif
}


///////////////////////////////////////////////////////////////////////////////
//
// METHOD CIdsSimpleAcquireDlg::OnButtonExit() 
//
// DESCRIPTION: - exit the camera
//				- quit application
//
///////////////////////////////////////////////////////////////////////////////
void CIdsSimpleAcquireDlg::OnButtonExit() 
{
	if( m_hCam != 0 )
	{
		//free old image mem.
		is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
		is_ExitCamera( m_hCam );
	}
	PostQuitMessage( 0 );
}


///////////////////////////////////////////////////////////////////////////////
//
// METHOD CIdsSimpleAcquireDlg::OpenCamera() 
//
// DESCRIPTION: - Opens a handle to a connected camera
//
///////////////////////////////////////////////////////////////////////////////
bool CIdsSimpleAcquireDlg::OpenCamera()
{
	if ( m_hCam != 0 )
	{
		//free old image mem.
		is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
		is_ExitCamera( m_hCam );
	}

	// init camera
	m_hCam = (HIDS) 0;						// open next camera
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
			AfxMessageBox( TEXT("ERROR: Can not enable the automatic uEye error report!") , MB_ICONEXCLAMATION, 0 );
			return false;
		}

#ifdef _WIN32_WCE
        LoadParameters();
#endif

	}
	else
	{
		AfxMessageBox( TEXT("ERROR: Can not open uEye camera!") , MB_ICONEXCLAMATION, 0 );
		return false;
	}

	return true;
}


void CIdsSimpleAcquireDlg::OnClose()
{
	if ( m_hCam != 0 )
	{
		//free old image mem.
		is_FreeImageMem( m_hCam, m_pcImageMemory, m_lMemoryId );
		is_ExitCamera( m_hCam );
	}

    CDialog::OnClose();
}

#define NOT_FOUND_VALUE     999999

#define READ_PROFILE_INT(_s_, _n_, _v_, _d_)     \
    {   \
        int _data_; \
        _data_ = (UINT)theApp.GetProfileInt(_T(_s_), _T(_n_), NOT_FOUND_VALUE); \
        if(_data_ == NOT_FOUND_VALUE)  \
        {   \
            theApp.WriteProfileInt(_T(_s_), _T(_n_), _d_);  \
            _v_ = _d_;  \
        }   \
        else    \
            _v_ = _data_;   \
    }


void CIdsSimpleAcquireDlg::LoadParameters()
{ 
    if(m_hCam == NULL)
        return;

    UINT nPixelClock;
    UINT nFrameRate;
    UINT nExposureTime;
    UINT nGainR, nGainG, nGainB, nGainM;
    UINT nColorCorrection;
    UINT nBayerMode;

    nGainM  = is_SetHardwareGain(m_hCam, (int)IS_GET_DEFAULT_MASTER, -1, -1, -1);
    nGainR  = is_SetHardwareGain(m_hCam, (int)IS_GET_DEFAULT_RED,    -1, -1, -1);
    nGainG  = is_SetHardwareGain(m_hCam, (int)IS_GET_DEFAULT_GREEN,  -1, -1, -1);
    nGainB  = is_SetHardwareGain(m_hCam, (int)IS_GET_DEFAULT_BLUE,   -1, -1, -1);

    READ_PROFILE_INT("MRU", "PixelClock",       nPixelClock,        10);
    READ_PROFILE_INT("MRU", "FrameRate",        nFrameRate,         5);
    READ_PROFILE_INT("MRU", "ExposureTime",     nExposureTime,      100);
    READ_PROFILE_INT("MRU", "GainMaster",       nGainM,             nGainM);
    READ_PROFILE_INT("MRU", "GainRed",          nGainR,             nGainR);
    READ_PROFILE_INT("MRU", "GainGreen",        nGainG,             nGainG);
    READ_PROFILE_INT("MRU", "GainBlue",         nGainB,             nGainB);
    READ_PROFILE_INT("MRU", "ColorCorrection",  nColorCorrection,   IS_CCOR_DISABLE);
    READ_PROFILE_INT("MRU", "BayerMode",        nBayerMode,         IS_SET_BAYER_CV_NORMAL);
    READ_PROFILE_INT("MRU", "RenderMode",       m_nRenderMode,      IS_RENDER_NORMAL);

	m_Ret = is_SetPixelClock(m_hCam, nPixelClock);
	m_Ret = is_SetFrameRate(m_hCam, (double)nFrameRate, NULL);
	m_Ret = is_SetExposureTime(m_hCam, (double)nExposureTime, NULL);
    m_Ret = is_SetHardwareGain(m_hCam, nGainM, nGainR, nGainG, nGainB);
    m_Ret = is_SetColorCorrection(m_hCam, nColorCorrection, NULL);
    m_Ret = is_SetBayerConversion(m_hCam, nBayerMode);
}


INT CIdsSimpleAcquireDlg::InitCamera (HIDS *hCam, HWND hWnd)
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
    
        CString Str1, Str2, Str3;
        Str1 = "This camera requires a new firmware. The upload will take about";
        Str2 = "seconds. Please wait ...";
        Str3.Format ("%s %d %s", Str1, nUploadTime / 1000, Str2);
        AfxMessageBox (Str3, MB_ICONWARNING);
    
        // Set mouse to hourglass
	    SetCursor(AfxGetApp()->LoadStandardCursor(IDC_WAIT));

        // Try again to open the camera. This time we allow the automatic upload of the firmware by
        // specifying "IS_ALLOW_STARTER_FIRMWARE_UPLOAD"
        *hCam = (HIDS) (((INT)*hCam) | IS_ALLOW_STARTER_FW_UPLOAD); 
        nRet = is_InitCamera (hCam, hWnd);   
    }
    
    return nRet;
}


void CIdsSimpleAcquireDlg::GetMaxImageSize(INT *pnSizeX, INT *pnSizeY)
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