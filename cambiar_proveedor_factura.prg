CLEAR ALL
SET CENTURY ON
SET DATE BRITISH
SET EXACT ON

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE cuotas_c IN 0 SHARED

m.proveedor = 26
m.tipodocu  = 8
m.nrodocu   = 10020362

SELECT cabecomp
REPLACE proveedor WITH m.proveedor FOR tipodocu = m.tipodocu AND nrodocu = m.nrodocu

SELECT detacomp
REPLACE proveedor WITH m.proveedor FOR tipodocu = m.tipodocu AND nrodocu = m.nrodocu

SELECT cuotas_c
REPLACE proveedor WITH m.proveedor FOR tipodocu = m.tipodocu AND nrodocu = m.nrodocu