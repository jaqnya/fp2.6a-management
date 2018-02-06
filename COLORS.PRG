* +-------------------------------------------------------------+
* |  COLOR.PRG  Release 1.0  19/08/2004                         |
* |  Copyright (C) Turtle Software Paraguay, 2000-2004          |
* |  All Rights Reserved.                                       |
* |                                                             |
* |  This Module contains Proprietary Information of            |
* |  Turtle Software Paraguay and should be treated             |
* |  as Condifential.                                           |
* +-------------------------------------------------------------+

* +-------------------------------------------------------------+
* |  Modificado:                                                |
* +-------------------------------------------------------------+

* Declaraci¢n de variables.
PUBLIC color_01, color_02, color_03, color_04, color_05, color_06, ;
       color_07, color_08, color_09

*-- User-defined window.
STORE "W/B,B/W,W/B,B/W,R/W,B/W,GR+/B,,W/B,R+/B,+" TO color_01

*-- Browse window.
STORE "W/B,B/BG,N/W,N/W,R/W,GR+/GR,B/BG,,,,+" TO color_02

*-- Alert window.
STORE "GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+" TO color_03

*-- Message window.
STORE "N/W,W+/BG,W+/W,GR+/B,R+/B,W+/G,GR+/G,N+/N,N/G,R+/B,+" TO color_04

*-- Popup window with add, delete, modify and help buttons.
STORE "N/W,,W+/W,W+/W,R/W,W+/G,GR+/G,,N/G,R/G,+" TO color_05
STORE ",N/BG,B/BG,,,BG+/B,,,,,+" TO color_06

*-- Browse window for detail.
STORE "W/B,W+/BG,N/BG,N/BG,R/BG,GR+/GR,B/W,,,,+" TO color_07

*-- Popup window for order selection.
STORE "N/W,,W+/W,N/W,R/W,W+/G,GR+/G,,N/G,,+" TO color_08
STORE ",N/BG,B/BG,,,BG+/B,,,,,+" TO color_09