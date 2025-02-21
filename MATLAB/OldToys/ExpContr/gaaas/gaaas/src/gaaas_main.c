/*
 * MATLAB Compiler: 4.13 (R2010a)
 * Date: Sun Jan 22 00:34:04 2012
 * Arguments: "-B" "macro_default" "-o" "gaaas" "-W" "WinMain:gaaas" "-T"
 * "link:exe" "-d" "C:\Documents and Settings\electrons\My
 * Documents\MATLAB\gaaas\src" "-w" "enable:specified_file_mismatch" "-w"
 * "enable:repeated_file" "-w" "enable:switch_ignored" "-w"
 * "enable:missing_lib_sentinel" "-w" "enable:demo_license" "-v" "C:\Documents
 * and Settings\electrons\My Documents\MATLAB\gas.m" "-a" "C:\Documents and
 * Settings\electrons\My Documents\MATLAB\gas.fig" "-a" "C:\Documents and
 * Settings\electrons\My Documents\MATLAB\tescom.dll" "-a" "C:\Documents and
 * Settings\electrons\My Documents\MATLAB\tescommex.m" 
 */
#include <stdio.h>
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_gaaas_component_data;

#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifndef LIB_gaaas_C_API
#define LIB_gaaas_C_API /* No special import/export declaration */
#endif

LIB_gaaas_C_API 
bool MW_CALL_CONV gaaasInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream(NULL, 
                                    82877);
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                
                                                     &__MCC_gaaas_component_data,
                                                                true, 
                                                                NoObjectType, 
                                                                ExeTarget,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream, 
                                                                82877);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_gaaas_C_API 
bool MW_CALL_CONV gaaasInitialize(void)
{
  return gaaasInitializeWithHandlers(mclDefaultErrorHandler, mclDefaultPrintHandler);
}
LIB_gaaas_C_API 
void MW_CALL_CONV gaaasTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

int run_main(int argc, const char **argv)
{
  int _retval;
  /* Generate and populate the path_to_component. */
  char path_to_component[(PATH_MAX*2)+1];
  separatePathName(argv[0], path_to_component, (PATH_MAX*2)+1);
  __MCC_gaaas_component_data.path_to_component = path_to_component; 
  if (!gaaasInitialize()) {
    return -1;
  }
  argc = mclSetCmdLineUserData(mclGetID(_mcr_inst), argc, argv);
  _retval = mclMain(_mcr_inst, argc, argv, "gas", 0);
  if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
  gaaasTerminate();
#if defined( _MSC_VER)
  PostQuitMessage(0);
#endif
  mclTerminateApplication();
  return _retval;
}

#if defined( _MSC_VER)

#define argc __argc
#define argv __argv

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow)
#else
int main(int argc, const char **argv)

#endif
{
  if (!mclInitializeApplication(
    __MCC_gaaas_component_data.runtime_options, 
    __MCC_gaaas_component_data.runtime_option_count))
    return 0;

  return mclRunMain(run_main, argc, argv);
}
