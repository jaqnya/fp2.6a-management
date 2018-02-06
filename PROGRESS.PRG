****************************************************************************
* PROGRESS.PRG - Progress Thermometer   v1.10
*                Displays a progress thermometer and percent complete
*                Written by Cory A. Jaeger
*       SYNTAX -  =PROGRESS(percent,message)
*
*
* FREE!!! - I wrote this program for my own use and am releasing
*           it into puplic domain on the following conditions.
*         - If you use it, PLEASE let me know.  (It's nice to know that
*           others find your work useful.)  CIS - 73424,536.
*         - A thank-you gift of $1 would be appreciated if you find that
*           you are frequently using this code either un-modified or
*           as a base for other code.  (HOWEVER, IT IS NOT REQUIRED!)
*         - I must get credit for this code if used in any publication.
*         - My name must not be removed from the comments of this code
*           as the original writer.
*         - If you release any updated/revised version, you must add
*           to these comments.  Include your name and a summary
*           of what you have fixed/added.  (Please, send me a copy of
*           the updated code.)
*
*
*  Parameters:     m.prcnt - Percent complete (0-100) [optional]
*                          - Defaults to 0, values over 100 are set to 100.
*                          - Sending negative number releases window.
*                m.message - Message to place in progress window.  [character,optional]
*                          - 58 Characters MAX  (Extra is truncated.)
*                          - Defaults to "Working"
*
***************************************************************************

PARAMETERS m.prcnt, m.message
PRIVATE old_talk, cur_win

IF SET("TALK")="ON"
   SET TALK OFF
   old_talk="ON"
ELSE
   old_talk="OFF"
ENDIF

IF EMPTY(m.message)                              && Default message
   m.message="Working"
ENDIF

m.message=LEFT(ALLTRIM(m.message),58)            && Truncate extra characters.

IF EMPTY(m.prcnt)                                && Default Percent complete to 0
   m.prcnt=0
ENDIF

IF m.prcnt<0                                     && Release & clear progress window when done.
   IF WEXIST("_THERMOM")
      RELEASE WINDOW _thermom
   ENDIF

   RETURN
ENDIF
cur_win=WOUTPUT()                                && Get current output window

IF !WEXIST("_THERMOM")                           && Define window if doesn't exist
   DEFINE WINDOW _thermom ;
      FROM 11,10 ;
      TO   15,69;
      CLOSE ;
      NOFLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR "N/W,,N/W,,,,,,," 
ENDIF

ACTIVATE WINDOW _thermom                         && Show our Thermometer bar on top.

IF m.prcnt>100                                   && Prevent >100% thermometer.
   m.prcnt=100
ENDIF

m.prcnt=ROUND(m.prcnt,0)                         && Round off any decimal places

@ 00,01 SAY PADC(m.message,58)
@ 02,01 SAY TRANSFORM(m.prcnt,"999")+"% " + ;
   REPLICATE("Û",INT(m.prcnt/2))+REPLICATE("-",50-INT(m.prcnt/2))

SET TALK &old_talk                               && Restore old SET TALK setting

IF EMPTY(cur_win)                                && Set output back to original window
   ACTIVATE SCREEN
ENDIF