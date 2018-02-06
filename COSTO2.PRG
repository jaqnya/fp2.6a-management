CLOSE ALL

STORE 0 TO msubtotal
SELECT 0
tmp_file  = "tm" + RIGHT(SYS(3), 6) 
tmp_alias = "tm" + RIGHT(SYS(3), 6)

CREATE TABLE &tmp_file (tipodocu   N(01) ,;
                        nrodocu    N(07) ,;
                        fechadocu  D(08) ,;
                        cliente    N(05) ,;
                        articulo   C(15) ,;
                        precio     N(13,4) ,;
                        salida     N(09,2) ,;
                        pcostog    N(09,2))

USE &tmp_file ALIAS (tmp_alias) EXCLUSIVE
INDEX ON articulo + DTOS(fechadocu) TAG indice1

SELECT 0
USE cabevent SHARED
SET ORDER TO TAG "indice1" OF cabevent

SELECT 0
USE detavent SHARED
SET ORDER TO TAG "indice1" OF detavent


SELECT 0
USE detavent.dbf AGAIN ALIAS detavent3
SET ORDER TO TAG "indice1" OF detavent3.cdx

SELECT cabevent
GOTO TOP

PRIVATE mbruto, mdescuento, mneto, mprecio, mporcdesc
STORE 0 TO mbruto, mdescuento, mneto, mprecio, mporcdesc

SCAN ALL
   IF importdesc > 0 .AND. porcdesc = 0
      mporcdesc = discount()
   ENDIF

   IF porcdesc > 0 .AND. importdesc > 0
      mporcdesc = porcdesc
   ENDIF

   SELECT detavent
   IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
      SCAN WHILE cabevent.tipodocu  = tipodocu .AND. ;
                 cabevent.nrodocu   = nrodocu 
         IF pdescuento > 0
            mbruto     = ROUND(precio * cantidad, 2)
            mdescuento = ROUND((mbruto * pdescuento) / 100, 2)
            mneto      = mbruto - mdescuento
            IF mporcdesc > 0
               mdescuento = ROUND((mneto * mporcdesc) / 100, 2)
               mneto      = mneto - mdescuento
            ENDIF
            mprecio = ROUND(mneto / cantidad, 4)
            mprecio = ROUND(mprecio * cabevent.tipocambio, 4)
         ELSE
            IF mporcdesc > 0
               mbruto     = ROUND(precio * cantidad, 2)
               mdescuento = ROUND((mbruto * mporcdesc) / 100, 2)
               mneto      = mbruto - mdescuento
               mprecio    = ROUND(mneto / cantidad, 4)               
               mprecio    = ROUND(mprecio * cabevent.tipocambio, 4)
            ELSE
               mprecio = ROUND(precio * cabevent.tipocambio, 4)         
            ENDIF
         ENDIF
         
         INSERT INTO (tmp_alias) (tipodocu, nrodocu, fechadocu, articulo, precio, salida) ;
            VALUE (cabevent.tipodocu, cabevent.nrodocu, cabevent.fechadocu, detavent.articulo, mprecio, detavent.cantidad)
      ENDSCAN
   ENDIF
   SELECT cabevent
ENDSCAN

SELECT (tmp_alias)
BROWSE
EXPORT TO (tmp_file) TYPE XLS

USE

DELETE FILE (tmp_file) + ".DBF"
DELETE FILE (tmp_file) + ".CDX"


FUNCTION discount
   PRIVATE mbruto, mdescuento, mneto, msubtotal, mporcdesc, m.currarea
   STORE 0 TO mbruto, mdescuento, mneto, msubtotal, mporcdesc
   m.currarea = SELECT()

   SELECT detavent2
   IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
      SCAN WHILE cabevent.tipodocu = tipodocu .AND. cabevent.nrodocu = nrodocu
         IF pdescuento > 0
            mbruto     = ROUND(precio * cantidad, 2)
            mdescuento = ROUND((mbruto * pdescuento) / 100, 2)
            mneto      = mbruto - mdescuento
            msubtotal  = msubtotal + mneto
         ELSE
            msubtotal  = msubtotal  + ROUND(precio * cantidad, 2)
         ENDIF
      ENDSCAN
      mporcdesc = ROUND((cabevent.importdesc * 100) / msubtotal, 4)
   ENDIF
   SELECT (m.currarea)

   RETURN (mporcdesc)
*ENDFUNC
