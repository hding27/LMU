/*
  Stepper Motor Controller SM32 v2.00 :

  Tested with Visual C++ 5.0

  (c)1997-2007 Ingenieurbuero Dipl.Ing.(FH) Robert Schoerghuber,
               Bochum/Germany, www.sm32.de
*/

#ifndef __SM32_H_INCLUDED__
#define __SM32_H_INCLUDED__

#ifdef __cplusplus
extern "C" {
#endif

/* VC++ 5.0 */
#define DllImport __declspec( dllimport )
#define _CALLSTYLE_ __stdcall
/**/

/* TC 2.01 * /
#define DllImport extern
#define _CALLSTYLE_
/**/

typedef long INT32;

DllImport INT32 _CALLSTYLE_ SM32Get(  INT32 Motor, INT32 Cmd );
DllImport void  _CALLSTYLE_ SM32Set(  INT32 Motor, INT32 Cmd, INT32 Data );

DllImport INT32 _CALLSTYLE_ SM32GetE( INT32 Motor, INT32 Cmd,
                                      INT32 ErrCtrl, INT32 *ErrCode);
DllImport void  _CALLSTYLE_ SM32SetE( INT32 Motor, INT32 Cmd, INT32 Data,
                                      INT32 ErrCtrl, INT32 *ErrCode);

DllImport INT32 _CALLSTYLE_ SM32CommErr( INT32 Key, INT32 Data );

DllImport INT32 _CALLSTYLE_ SM32Enum(    INT32 aIn, INT32 *aOut );

DllImport char* _CALLSTYLE_ SM32CmdToName( INT32  Cmd  );
DllImport INT32 _CALLSTYLE_ SM32NameToCmd( char* Name );
DllImport INT32 _CALLSTYLE_ SM32CmdFlags(  INT32  Cmd  );

DllImport INT32 _CALLSTYLE_ SM32GetTimeout(void);
DllImport INT32 _CALLSTYLE_ SM32SetTimeout( INT32 t );


typedef INT32 tSM32Motor, *pSM32Motor;

DllImport INT32 _CALLSTYLE_ SM32Init(    tSM32Motor* M, INT32 Mno, INT32 Bno   );
DllImport INT32 _CALLSTYLE_ SM32Done(    tSM32Motor* M                         );

DllImport INT32 _CALLSTYLE_ SM32Post(    tSM32Motor* M, INT32 Cmd, INT32 Data  );
DllImport INT32 _CALLSTYLE_ SM32Request( tSM32Motor* M, INT32 Cmd              );
DllImport INT32 _CALLSTYLE_ SM32Replied( tSM32Motor* M                         );
DllImport INT32 _CALLSTYLE_ SM32Fetch(   tSM32Motor* M, INT32* Data            );

DllImport INT32 _CALLSTYLE_ SM32Write(   tSM32Motor* M, INT32 Cmd, INT32  Data );
DllImport INT32 _CALLSTYLE_ SM32Read(    tSM32Motor* M, INT32 Cmd, INT32* Data );

/*-------------------------------------------------------------------------*/
/* communication result constants (mcr...= Motor Communication Result) */

#define mcrOk               0 /* operation successful                         */
#define mcrBusy             1 /* Post/Request/Received/Fetch: defered; repeat.*/

#define mcrIllegalMno      -1 /* Init: Motor number not in [1..3]   */
#define mcrIllegalBno      -2 /* Init: Board number <1 or >10       */
#define mcrIllegalAddr     -2 /* for compatibility with SM30        */

#define mcrNoSM32          -3 /* Init: No SM32 found                */
#define mcrNotInitialised  -4 /* M not linked to any motor          */
#define mcrNoRequest       -5 /* Received, Fetch: nothing Requested */
#define mcrTimeout         -6 /* Read/Write: SM32 does not react. shouldn't happen.*/
#define mcrInterference    -7 /* Received/RFetch/Read: SM32 replied other data
                                 than requested */

#define mcrTooManyHandles  -8 /* Init: more than 255 Handles requested      */
#define mcrTooManyBoards   -9 /* Init: internal error, shouln't happen      */
#define mcrNoNTDriver     -10 /* Init(WinNT): NT driver not found           */
#define mcrOldSM32        -11 /* only for compatibility with SM30; cannot occur */

/*-------------------------------------------------------------------------*/
/* communication error handling constants */

#define mcehInfo       0   /* read information   */
#define mcehCtrl       1   /* control            */

#define mcehGlobal     -1  /* use global setting */
#define mcehMessageBox 1   /* open messagebox    */
#define mcehException  2   /* throw exceptin     */

/*-------------------------------------------------------------------------*/
/* command constants (mc... = Motor Command...) */

#define mcNone         0    /* empty command                       */
#define mcCmdMin       1    /* note that not all cmd numbers within*/
#define mcCmdMax      32    /* that range are necessarely valid    */
#define mcMinCmd      mcCmdMin
#define mcMaxCmd      mcCmdMax

                            /* R  readable                         */
                            /*  W writeable                        */

        /*-- switch on/off --*/
#define mcPower       6    /* RW (all off = clear error)           */
#define   mpOff         0  /*      Motor Power : Off               */
#define   mpOn          1  /*      Motor Power : On                */
#define   mpShutdown   -1  /*      Motor Power : Shutdown          */

        /*-- general settings --*/
#define mcU           5    /* RW set nominal motor voltage         */
#define mcUhold      12    /* RW set standstill voltage in %       */
#define mcStepWidth  17    /* RW step width and direction          */
#define mcAmax        4    /* RW set maximum acceleration          */
#define mcFmax        2    /* RW set maximum speed                 */
#define mcSwitchMode 11    /* RW assign limit switches             */

        /*-- move --*/
#define mcPosMode     8    /* RW set positioning mode              */
#define   mmMove  1        /*      move with given speed           */
#define   mmPos   3        /*      move to given position          */

#define mcAbsRel     28    /* RW set absolute/relative mode        */
#define   mmAbs   0        /*      absolute positioning            */
#define   mmRel   1        /*      relative positioning            */

#define mcPosition    9    /* RW set position counter              */
#define mcA           3    /* RW set nominal acceleration          */
#define mcF           1    /* RW set nominal speed                 */
#define mcFact       26    /* R  read actual speed                 */
#define mcGo          7    /*  W go to destination                 */
#define mcGoHome     15    /*  W go home                           */

#define mcState      29    /* R  stands : 0                        */
#define   mstNone    0     /*      motor stands                    */
#define   mstMove    1     /*      motor runs (in mode mmMove)     */
#define   mstPos     3     /*      motor runs (in mode mmPos)      */
#define   mstHome    8     /*      motor performs homing           */
#define   mstBreak   9     /*      motor performs fast break       */

#define mcError      30    /* R  error message                     */
#define   meNone        0  /*      no error                        */

          /* temporary errors  */
#define   meIM1         1  /*      motor 1 exessive current        */
#define   meIM2         2  /*      motor 2 exessive current        */
#define   meIM3         4  /*      motor 3 exessive current        */
#define   meIover       8  /*      general current limiter         */
#define   meI          15  /*      any exessive current            */

          /* continuing errors */
#define   meSupply     16  /*      no 12V supply or 5V short circuited */
#define   me510V       16  /*      no 12V supply or 5V short circuited */
#define   meSwitch     32  /*      limit switch was applied in emergency stop mode */
#define   meWatchdog   64  /*      watchdog timed out              */
#define   meReset     128  /*      internal error                  */
#define   meNotFound  254  /*      SM32Init delivered FALSE        */
#define   meHalted    240  /*      any continuing error            */

#define mcSwitches   27    /* R  current switch settings           */

        /*-- other --*/
#define mcPowerMeter 22    /* R  read motor power                  */
#define mcUact       24    /* R  read actual voltage               */
#define mcBreak      16    /*  W break                             */
#define mcSwiPos     23    /* R  read last switching position      */
#define mcPhase      25    /* R  read motor phase                  */
#define mcFg         10    /* RW adjust internal control parameter */
#define mcWatchdog   18    /* RW set watchdog timeout              */
#define mcReset      19    /*  W reset to boot state               */
#define mcVersion    21    /* R  read version number               */
#define mcAuxIn      31    /* R  read auxiliary inputs             */
#define mcStoreCfg   32    /* RW store configuration               */

#ifdef __cplusplus
};
#endif

#endif /* __SM32_H_INCLUDED__ */

