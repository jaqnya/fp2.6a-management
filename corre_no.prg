USE cabeped2 SHARED
BROWSE FOR AT(",", nombre) > 0 AND !EMPTY(SUBSTR(nombre, AT(",", nombre) + 1, 1)) FREEZE NOMBRE