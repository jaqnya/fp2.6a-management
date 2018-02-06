**---------------------------------------------------------------------------**
** Funci¢n...: HDDSerie                                                      ** 
** Parametros: Ninguno.                                                      **
** Objetivo..: Comprobaci¢n de Derechos de Acceso al Sistema.                **
**---------------------------------------------------------------------------**

lDriveC = DskSerie('C:')

do case
   case lDriveC == "3E12-0FFC" && Development Machine.
      return .t.
   case lDriveC == "0D49-1CFF" && Development Machine  Casa Central.
      return .t.
   case lDriveC == "2A45-1AF3" && Server               Casa Central.
      return .t.
   case lDriveC == "26D9-4D03" && Work Station N§ 1    Casa Central.
      return .t.
   case lDriveC == "26B2-5ACD" && Work Station N§ 2    Casa Central.
      return .t.
   case lDriveC == "2510-1AF5" && Server               Sucursal Tres.
      return .t.
   case lDriveC == "0762-1DFE" && Work Station N§ 1    Sucursal Dos.
      return .t.
   case lDriveC == "373C-0FEE" && Server               Sucursal Uno.
      return .t.
   case lDriveC == "3738-1700" && Work Station N§ 1    Sucursal Uno.
      return .t.
   otherwise
      return .f.     
endcase


**---------------------------------------------------------------------------**
** Funci¢n...: DskSerie                                                      **   **
** Parametros: <nUnidad>                                                     **
** Objetivo..: Devuelve el n£mero de serie del volumen de la unidad especi-  **
**             ficada.                                                       **
**---------------------------------------------------------------------------**

function DskSerie
parameter tcDrive

if parameters() # 1
   ? chr(7)
   cSetCursor = set('CURSOR')
   set cursor off
   wait window 'No se han pasado suficientes parametros'  + chr(13) + ;
               '        Funcion: <  DskSerie  >        '  timeout 5

   set cursor &cSetCursor
   return .f.
endif

if empty(tcDrive)
   return ''
endif

private lcFileName, lnFile, lclinea, lcDskSerial

lcFileName = sys(3)+'.tmp' 

! vol &tcDrive > &lcFileName

lnFile = fopen(lcFileName)

if lnFile = -1
   ? chr(7)
   cSetCursor = set('CURSOR')
   set cursor off
   wait window 'Error. No se pudo verificar la serie' timeout 5
   set cursor &cSetCursor
   return
else
   do while .not. feof(lnFile)
      lclinea = upper(trim(fgets(lnFile)))
      do case
         case 'SERIAL NUMBER' $ lclinea
            lcDskSerial = right(lclinea, 9)
         case 'SERIE DEL VOLUMEN' $ lclinea
            lcDskSerial = right(lclinea, 9)
      endcase
   enddo

   = fclose(lnFile)
   delete file (lcFileName)
endif

return lcDskSerial

