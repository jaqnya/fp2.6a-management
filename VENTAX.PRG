clear
push key clear
set deleted  on
set talk     off
set notify   on
set bell     off
set confirm  on
on key label 'F8' do _DeleteLine
on key label 'F4' do recn
on key label 'F3' do ren
on key label 'F9' do pl

public m.reccount
private m.exento, m.gravada, m.iva, m.subtotal, m.total
store 0 to m.exento, m.gravado, m.iva, m.subtotal, m.total
@ 19,68 get m.subtotal picture '999,999,999'
@ 21,68 get m.iva   picture '999,999,999'
@ 22,68 get m.total picture '999,999,999'

store 1 to reccount


select 1
use  maesprod.dbf alias ARTICULO
*reindex
set order to tag indice1 of maesprod.cdx
*reindex

select 2
use mecanico.dbf alias MECANICO 
reindex
set order to tag indice1 of mecanico.cdx

select 3
use detavent.dbf alias DETAVENT
zap
       
select 3
set relation to DETAVENT.articulo into ARTICULO additive
set relation to DETAVENT.mecanico into MECANICO additive


define window detalle from 08,00 to 18,79;
              title 'DETALLE';
              system;
              color scheme 10
*activate window detalle


INSERT INTO detavent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
   VALUES            (0, 0, " ", 0, 0, .F., 0, " ", 0, " ")

DO WHILE LASTKEY() # 27
   GO BOTTOM
   browse window detalle fields;
   articulo :15: h = 'C¢digo' : v = valcode(articulo):f,;
   descripcion = (articulo->nombre) :r:37: h = 'Descripci¢n',;
   cantidad :08:h = 'Cantidad' :p='9999.99':v = valcant(cantidad):f,;
   precio :r:13: h = 'Precio Unit.':p='99,999,999.99',;
   subtotal = (precio * cantidad) :r:11: h = ' Sub-Total':p='999,999,999' :v = _vldSubTotal() :f,;
   impuesto :r:08: h = 'Impuesto',;
   pimpuesto :r:06: h = '% Imp.',;
   mecanico :r:03:h = 'Mec.',;
   nomb_mec = mecanico->nombre :r:30: h = 'Nombre del Mec nico'
ENDDO

release window detalle              
set talk on              
              
procedure valcode
parameter m.codigo

  
if lastkey() == 24
   return .t.
endif   

if lastkey() == -7
   return .t.
endif   

_oldselect = select()
select ARTICULO
if seek(m.codigo)
   wait window 'found' nowait
   store ARTICULO.pventag1 to m.precio
   replace DETAVENT.precio with m.precio
   replace DETAVENT.impuesto with ARTICULO.impuesto
   replace DETAVENT.pimpuesto with ARTICULO.pimpuesto
   keyboard '{ENTER}'
   select (_oldselect)
   return .t.
else 
   wait window 'not found' nowait
   select (_oldselect)
   return .f.
endif

FUNCTION _vldSubTotal

IF LASTKEY() = 13     && Tecla ENTER presionada, agregar l¡nea de detalle.
   IF RECNO() = RECCOUNT()
      KEYBOARD "{CTRL+W}"      
      sum (precio*cantidad) to m.gravado for impuesto == .t.
      sum (precio*cantidad) to m.exento for impuesto == .f.
      m.subtotal = m.gravado + m.exento
      m.iva      = round((m.gravado * 0.1),0)
      m.total    = m.subtotal + m.iva
   
      INSERT INTO detavent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
         VALUES            (0, 0, " ", 0, 0, .F., 0, " ", 0, " ")


      m.reccount = m.reccount + 1

      @ 19,68 get m.subtotal picture '999,999,999'
      @ 21,68 get m.iva   picture '999,999,999'
      @ 22,68 get m.total picture '999,999,999'
ENDIF



procedure valcant
parameter m.cantidad

if m.cantidad = 0.00
   wait window '­ LA CANTIDAD DEBE SER MAYOR QUE CERO !' 
   return .f.
endif         

FUNCTION _DeleteLine
SELECT detavent
DELETE 
PACK
IF RECCOUNT() = 0
   INSERT INTO detavent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
      VALUES            (0, 0, " ", 0, 0, .F., 0, " ", 0, " ")
ENDIF

   sum (precio*cantidad) to m.gravado for impuesto == .t.
   sum (precio*cantidad) to m.exento for impuesto == .f.
   m.subtotal = m.gravado + m.exento
   m.iva      = round((m.gravado * 0.1),0)
   m.total    = m.subtotal + m.iva
   @ 19,68 get m.subtotal picture '999,999,999'
   @ 21,68 get m.iva   picture '999,999,999'
   @ 22,68 get m.total picture '999,999,999'
