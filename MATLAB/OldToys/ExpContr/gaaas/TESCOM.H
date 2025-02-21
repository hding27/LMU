/****************************************************************************
 *   FILE -      protocol.h
 *
 *   DESCRIPTION -
 *
 *       These are the prototypes of functions used when interfacing to the
 *       Tescom protocol layers (Windows version).
 *
 ****/

/******** TYPEDEFS ********/

typedef unsigned char   UCHAR;
#ifndef UINT
typedef unsigned short UINT;
#endif
/******** DEFINES ********/

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE (!FALSE)
#endif

#define LO_BYTE(x) ((UCHAR)( (x) & 0xff ) )
#define HI_BYTE(x) ( (UCHAR) ( (x) >> 8 ) )

/******** STRUCTURES ********/

struct segment_struct {  /* Used for reading/writing profile segments */
    char    type ;
    UINT    variable1 ;
    UINT    variable2 ;
};

/******** PROTOTYPES ********/


short  _stdcall   Startup(void);

short  _stdcall   Shutdown(void);

unsigned short _stdcall  ReadNetVar(unsigned short, unsigned short, unsigned short *);

unsigned short _stdcall   WriteNetVar(unsigned short, unsigned short, unsigned short);



/* TEST
UINT FAR PASCAL _export   WriteProfileSegment(UINT, 
                                              struct segment_struct FAR *, 
                                              UINT);

UINT FAR PASCAL _export   ReadProfileSegment(UINT, 
                                             struct segment_struct FAR *, 
                                             UINT);
TEST */

