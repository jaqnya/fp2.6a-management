*
* l_20a.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de Cuadro Anual de Ventas por Vendedores y Marcas
*
* Historial de Modificacion:
* Junio 08, 2009	Jose Avilio Acuna Acosta	Creador del Programa
*

PRIVATE npeso, m.destino, mano, mopcion, mmarca
npeso = "A & A IMPORTACIONES S.R.L."

DEFINE WINDOW l_20;
   FROM 06,17;
   TO   13,61;
   TITLE " CUADRO ANUAL DE VENTAS POR VENDEDORES ";
   SHADOW

ACTIVATE WINDOW l_20

DO WHILE .T.
   mano = YEAR(DATE())
   mmarca = 0
   STORE "S" TO mopcion
   STORE SPACE(1) TO m.destino
   
   @ 01,03 SAY 'A¥O..:' GET mano PICTURE '9999'
   @ 02,03 SAY 'MARCA:' GET mmarca PICTURE '9999' VALID vldmarca()
   @ 04,03 SAY 'DESEA INCLUIR IMPUESTOS (S/N):' GET mopcion PICTURE '!'
   @ 02,16 SAY REPLICATE(CHR(32), 20) SIZE 1,20 COLOR W/N

   READ

   IF LASTKEY() = 27 THEN
      EXIT
   ENDIF

   IF !INLIST(mopcion, "S", "N") THEN
      WAIT WINDOW "LA OPCION DEBE SER: (S)I O (N)O !"
      LOOP
   ENDIF

   IF esta_correcto() THEN
      DO destino
      DO inf_02a WITH mano, mmarca, mopcion
      
      DO CASE
         CASE m.destino = "P"
            CREATE CURSOR tm_inform2 (;
               id_vendedo N(5),;
               vendedor C(30),;
               m_1  C(14),;
               m_2  C(14),;
               m_3  C(14),;
               m_4  C(14),;
               m_5  C(14),;
               m_6  C(14),;
               m_7  C(14),;
               m_8  C(14),;
               m_9  C(14),;
               m_10 C(14),;
               m_11 C(14),;
               m_12 C(14),;
               total_anyo C(14),;
               porcentaje C(6);
            )
            
            SELECT tm_informe
            SCAN ALL
               INSERT INTO tm_inform2;
                  VALUES (tm_informe.id_vendedo, tm_informe.vendedor,;
                          TRANSFORM(tm_informe.m_1, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_2, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_3, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_4, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_5, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_6, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_7, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_8, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_9, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_10, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_11, "99,999,999,999"),;
                          TRANSFORM(tm_informe.m_12, "99,999,999,999"),;
                          TRANSFORM(tm_informe.total_anyo, "99,999,999,999"),;
                          TRANSFORM(tm_informe.porcentaje, "999.99"))
            ENDSCAN
            
            SUM m_1, m_2, m_3, m_4, m_5, m_6, m_7, m_8, m_9, m_10, m_11, m_12, total_anyo TO ;
                m.m_1, m.m_2, m.m_3, m.m_4, m.m_5, m.m_6, m.m_7, m.m_8, m.m_9, m.m_10, m.m_11, m.m_12, m.total_anyo

            INSERT INTO tm_inform2;
               VALUES (0, REPLICATE("-", 30),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 14),;
                       REPLICATE("-", 06))

            INSERT INTO tm_inform2;
               VALUES (0, "T O T A L E S",;
                       TRANSFORM(m.m_1, "99,999,999,999"),;
                       TRANSFORM(m.m_2, "99,999,999,999"),;
                       TRANSFORM(m.m_3, "99,999,999,999"),;
                       TRANSFORM(m.m_4, "99,999,999,999"),;
                       TRANSFORM(m.m_5, "99,999,999,999"),;
                       TRANSFORM(m.m_6, "99,999,999,999"),;
                       TRANSFORM(m.m_7, "99,999,999,999"),;
                       TRANSFORM(m.m_8, "99,999,999,999"),;
                       TRANSFORM(m.m_9, "99,999,999,999"),;
                       TRANSFORM(m.m_10, "99,999,999,999"),;
                       TRANSFORM(m.m_11, "99,999,999,999"),;
                       TRANSFORM(m.m_12, "99,999,999,999"),;
                       TRANSFORM(m.total_anyo, "99,999,999,999"),;
                       TRANSFORM(100.00, "999.99"))

            DEFINE WINDOW brwl_20;
               FROM 01,00;
               TO   23,79;
               TITLE "< INFORME DE VENTAS POR VENDEDORES DEL " + ALLTRIM(STR(mano)) + " >";
               SYSTEM;
               CLOSE;
               FLOAT;
               GROW;
               MDI;
               NOMINIMIZE;
               SHADOW;
               ZOOM;
               COLOR SCHEME 15
   
            SELECT tm_inform2
            GOTO TOP
            
            KEYBOARD "{ENTER}"

            BROWSE WINDOW brwl_20 FIELDS;
               vendedor :R:30:H = "Vendedor",;
               m_1  :R:14:H = "         Enero",;
               m_2  :R:14:H = "       Febrero",;
               m_3  :R:14:H = "         Marzo",;
               m_4  :R:14:H = "         Abril",;
               m_5  :R:14:H = "          Mayo",;
               m_6  :R:14:H = "         Junio",;
               m_7  :R:14:H = "         Julio",;
               m_8  :R:14:H = "        Agosto",;
               m_9  :R:14:H = "     Setiembre",;
               m_10 :R:14:H = "       Octubre",;
               m_11 :R:14:H = "     Noviembre",;
               m_12 :R:14:H = "     Diciembre",;
               total_anyo :R:14:H = " Total del A¤o",;
               porcentaje :R:06:H = "   %  ";
               LOCK 1 NOAPPEND NODELETE NOMODIFY

            RELEASE WINDOW brwl_20
         CASE m.destino = "A"
            EXPORT TO c:\excel TYPE XLS
            WAIT "NOMBRE DEL ARCHIVO: EXCEL.XLS, EN C:\" WINDOW
      ENDCASE
   ENDIF
ENDDO

DEACTIVATE WINDOW l_20
RELEASE WINDOW l_20
 
*--------------------------------------------------------------------------*
PROCEDURE destino
STORE SPACE(1) TO m.destino

DO WHILE .T.
   WAIT "DESTINO: (P)ANTALLA o (A)RCHIVO" TO m.destino WINDOW
   m.destino = UPPER(m.destino)
   IF INLIST(m.destino, "P", "A") OR LASTKEY() = 27 THEN
      EXIT
   ENDIF
ENDDO

*--------------------------------------------------------------------------*
PROCEDURE esta_correcto
PRIVATE m.correcto, m.retorno
STORE SPACE(1) TO m.correcto

DO WHILE .T.
   WAIT "ESTA CORRECTO ? (S/N)" TO m.correcto WINDOW
   m.correcto = UPPER(m.correcto)
   IF INLIST(m.correcto, "S", "N") OR LASTKEY() = 27 THEN
      EXIT
   ENDIF
ENDDO

DO CASE
   CASE m.correcto = "S"
      m.retorno = .T.
   CASE m.correcto = "N" OR LASTKEY() = 27
      m.retorno = .F.
ENDCASE

RETURN (m.retorno)

*--------------------------------------------------------------------------*
PROCEDURE vldmarca

@ 02,16 SAY REPLICATE(CHR(32), 20) SIZE 1,20 COLOR W/N

IF mmarca <= 0 THEN
   DO buscmarc WITH "mmarca"
ENDIF

IF mmarca = 0
   RETURN 0
ENDIF

SELECT marcas1
SET ORDER TO 1
IF SEEK(mmarca) THEN
   @ 02,16 SAY LEFT(look_up("nombre", "marcas1", mmarca), 20) SIZE 1,20 COLOR W/N
ELSE
   WAIT "CODIGO DE MARCA INEXISTENTE !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE look_up
PARAMETER m.campo, m.tabla, m.expr_buscada

PRIVATE m.select, m.order, m.recno, m.retorno
m.select = SELECT()

SELECT (m.tabla)
m.order = VAL(SYS(21))
m.recno = IIF(EOF(), 0, RECNO())
SET ORDER TO 1

IF SEEK(m.expr_buscada) THEN
   m.retorno = &campo
ELSE
   m.retorno = " "
ENDIF

SET ORDER TO m.order
IF m.recno <> 0 THEN
   GOTO RECORD m.recno
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (m.retorno)