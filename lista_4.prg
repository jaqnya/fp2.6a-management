DO seteo
USE maesprod IN 0 SHARED
REPLACE pventag4 WITH pcostog * 1.2 FOR INLIST(codigo, "7295", "20024", "20031", "20032", "20029", "20030", "6771", "6510", "913", "929")
REPLACE pventag4 WITH pcostog * 1.2 FOR INLIST(codigo, "7073538", "6505", "1776", "6513", "965", "971", "6770", "7309", "20006", "20004")
REPLACE pventag4 WITH pcostog * 1.2 FOR INLIST(codigo, "20018", "20019", "20020", "20017", "20023", "20011", "20013", "7300", "970", "6778", "435")