

%  Stepper Motor Controller SM32 v1.110:
%
%  Win32 Visual Basic Interface Module v1.110
%  Tested with VB 5.0 CCE
%
%  (c)2003 OWIS GmbH, 79219 Staufen i.Br, Germany
function par=abschwaecher(mcmd, marg)
    if(strcmp(mcmd,'moveRel'))
        moveRel(marg);
    elseif(strcmp(mcmd,'moveAbs'))
        moveAbs(marg);        
    elseif(strcmp(mcmd,'findHome'))
        findHome();
    elseif(strcmp(mcmd,'getPos'))
        par=getPos();
        
    end
    
function moveRel(nCnts)

    if(~libisloaded('motlib'))
        loadlibrary('pcism32.dll','sm32.h','alias','motlib');
    end
    hMot= libpointer('longPtr',-1313);
    hAns= libpointer('longPtr',0);
    calllib('motlib','SM32Init',hMot, 1, 1   );

    %        /*-- switch on/off --*/
%#define mcPower       6    /* RW (all off = clear error)           */
%#define   mpOff         0  /*      Motor Power : Off               */
%#define   mpOn          1  /*      Motor Power : On                */
%#define   mpShutdown   -1  /*      Motor Power : Shutdown          */    
calllib('motlib','SM32Write', hMot,6 , 1 );
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 1 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home  
    
    calllib('motlib','SM32Write', hMot,1 , sign(mCnts)*600 );
    calllib('motlib','SM32Write', hMot,7 , nCnts );
    
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.1);
        if(get(hAns,'Value')==0)
            break;
        end
    end

%DllImport long  _CALLSTYLE_ SM32Done(    tSM32Motor* M
%);    
    calllib('motlib','SM32Done', hMot);
    
    unloadlibrary('motlib');

function mpos=getPos()

    if(~libisloaded('motlib'))
        loadlibrary('pcism32.dll','sm32.h','alias','motlib');
    end
    hMot= libpointer('longPtr',-1313);
    hAns= libpointer('longPtr',0);
    hmpos= libpointer('longPtr',-1313);
    calllib('motlib','SM32Init',hMot, 1, 1   );

    %        /*-- switch on/off --*/
%#define mcPower       6    /* RW (all off = clear error)           */
%#define   mpOff         0  /*      Motor Power : Off               */
%#define   mpOn          1  /*      Motor Power : On                */
%#define   mpShutdown   -1  /*      Motor Power : Shutdown          */    
calllib('motlib','SM32Write', hMot,6 , 1 );
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
%    calllib('motlib','SM32Write', hMot,8 , 1 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
%    calllib('motlib','SM32Write', hMot,28 , 1 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home                           */    
    calllib('motlib','SM32Read', hMot,9 , hmpos );

    
%DllImport long  _CALLSTYLE_ SM32Done(    tSM32Motor* M
%);    
    calllib('motlib','SM32Done', hMot);
    
    unloadlibrary('motlib');
    
    mpos=get(hmpos,'Value');
    
function moveAbs(nCnts)

    if(~libisloaded('motlib'))
        loadlibrary('pcism32.dll','sm32.h','alias','motlib');
    end
    hMot= libpointer('longPtr',-1313);
    hAns= libpointer('longPtr',0);
    calllib('motlib','SM32Init',hMot, 1, 1   );

    %        /*-- switch on/off --*/
%#define mcPower       6    /* RW (all off = clear error)           */
%#define   mpOff         0  /*      Motor Power : Off               */
%#define   mpOn          1  /*      Motor Power : On                */
%#define   mpShutdown   -1  /*      Motor Power : Shutdown          */    
calllib('motlib','SM32Write', hMot,6 , 1 );
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 1 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 0 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home                           */    
    calllib('motlib','SM32Write', hMot,1 , 600 );
    calllib('motlib','SM32Write', hMot,7 , nCnts );
    
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.1);
        if(get(hAns,'Value')==0)
            break;
        end
    end

%DllImport long  _CALLSTYLE_ SM32Done(    tSM32Motor* M
%);    
    calllib('motlib','SM32Done', hMot);
    
    unloadlibrary('motlib');
    
function findHome()

    if(~libisloaded('motlib'))
        loadlibrary('pcism32.dll','sm32.h','alias','motlib');
    end
    hMot= libpointer('longPtr',-1313);
    hAns= libpointer('longPtr',0);
    calllib('motlib','SM32Init',hMot, 1, 1   );
    
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 1 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home                           */    
    calllib('motlib','SM32Write', hMot,1 , 600 );
    calllib('motlib','SM32Write', hMot,15 , 600 );
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.1);
        if(get(hAns,'Value')==0)
            break;
        end
    end
    %set position to 0:
   calllib('motlib','SM32Write',hMot,9,0);
%DllImport long  _CALLSTYLE_ SM32Done(    tSM32Motor* M                       );    
    calllib('motlib','SM32Done', hMot);
    
    unloadlibrary('motlib');