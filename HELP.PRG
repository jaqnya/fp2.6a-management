ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             FOPEN()             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FOPEN(<expC> [, <expN>])

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Opens a file or communication port for use with low-level file functions.
Return value - Numeric
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Ports cannot be opened in FoxPro for Windows and FoxPro for Macintosh.

If FOPEN() successfully opens a file or communication port, the file handle number of the file or port is returned. FOPEN() returns -1 if the file or port cannot be opened.

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Tip - Assign the file handle number to a memory variable for use with other low-level file functions.
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Information about files opened with FOPEN() can be displayed or sent to a printer with DISPLAY STATUS or LIST STATUS. DISPLAY STATUS and LIST STATUS give the following information about each file opened with a low-level function:

	The drive, directory and file name

	The file handle number

	The file pointer position

	The read-write attributes

Use CLOSE ALL to close all files opened with a low-level function.

<expC>
	Include in <expC> the name of the file or communication port to open. If <expC> is a filename, it can include a path to open files in directories or drives not in the current search path. If a path isn't included, FoxPro searches for the file in the following order:

		The current directory

		The path established with SET PATH

	In FoxPro for MS-DOS, if <expC> is a communication port, the port must first be initialized with the MS-DOS MODE command. Specify the name of the port;for example, COM1 or COM2.

	Ports cannot be opened with low-level file functions in FoxPro for Windows and FoxPro for Macintosh.

<expN>
	Use <expN> to specify read-write privileges or buffering scheme for the file you open. The following table lists each number you can include in <expN>, and the read-write file privileges and buffering scheme it establishes.

			Read/Write	Buffered/
	<expN>	Privileges	Unbuffered
	ÄÄÄÄÄÄ	ÄÄÄÄÄÄÄÄÄÄ	ÄÄÄÄÄÄÄÄÄÄ

  	  0		Read Only 	Buffered
			(default)	

  	  1		Write Only	Buffered

  	  2		Read 		Buffered
			and Write
 
 	 10		Read Only	Unbuffered

 	 11		Write Only	Unbuffered

 	 12		Read		Unbuffered
			and Write

	If <expN> isn't included, or if <expN> evaluates to 0, the file is opened as read-only and is buffered. Communication ports should always be opened unbuffered.

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Example             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF FILE('errors.txt')			&& Does file exist? 
	errfile = FOPEN('errors.txt',12)	&& If so, open read-write
ELSE
	errfile = FCREATE('errors.txt')	&& If not, create it
ENDIF
IF errfile < 0					&& Check for error opening file
	WAIT 'Cannot open or create output file' WINDOW NOWAIT
ELSE							&& If no error, write to file
	=FWRITE(errfile, 'Error information to be written here')
ENDIF

=FCLOSE(errfile)				&& Close file
MODIFY FILE errors.txt NOWAIT	&& Open file in edit window


ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             FREAD()             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FREAD(<expN1>, <expN2>)

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Returns a specified number of bytes from a file or a communication port opened with a low-level function.
Return value - Character
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

<expN1>
	FREAD() returns data from the file or communication port specified by the file handle number <expN1>.

<expN2>
	The number of bytes returned by FREAD() is determined by <expN2> and the position of the file pointer. FREAD() returns data starting from the current file pointer position and continues until it returns <expN2> bytes, or until it encounters the end of the file, whichever is first.

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Example             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*** TEST.TXT must exist ***

STORE FOPEN('test.txt') TO file_handle		&& Open the file
STORE FSEEK(file_handle, 0, 2) TO ifp_size	&& Move pointer to EOF
STORE FSEEK(file_handle, 0) TO ifp_top		&& Move pointer to BOF
IF ifp_size <= 0							&& Is file empty?
	WAIT WINDOW 'This file is empty!' NOWAIT
ELSE										&& If not empty
	l_string = FREAD(file_handle, ifp_size)	&& Store to memory
	? l_string
ENDIF

= FCLOSE(file_handle)						&& Close the file


ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³            FWRITE()             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 FWRITE(<expN1>, <expC> [, <expN2>])

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Writes a character string to a file or a communication port opened with a low-level file function.
Return value - Numeric
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Unlike FPUTS(), FWRITE() doesn't place a carriage return and a linefeed at the end of the character string.

FWRITE() returns the number of bytes written to the file or communication port. If FWRITE() can't write to the file or port for any reason, 0 is returned.

<expN1>
	FWRITE() writes to the file or communication port specified by the file handle number <expN1>. 

<expC>
	FWRITE() writes the character expression <expC> to the file or port specified with <expN1>. 

<expN2>
	FWRITE() writes the entire character expression to the file or port unless <expN2> is included. When <expN2> is included, <expN2> characters are written to the file or port. If <expN2> is less than the number of characters in <expC>, only <expN2> characters are written to the file or port. All of the characters in <expC> are written to the file or port if <expN2> is equal to or greater than the number of characters in <expC>.

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             FSEEK()             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FSEEK(<expN1>, <expN2> [, <expN3>])

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Moves the file pointer in a file opened with a low-level file function.
Return value - Numeric
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

After moving the file pointer, FSEEK() returns the number of bytes the file pointer is from the beginning of the file. The file pointer can also be moved with FREAD() and FWRITE().

<expN1>
	FSEEK() moves the file pointer in the file with the file handle number <expN1>. A file handle number is returned by FCREATE() or FOPEN() when the file is created and/or opened.

<expN2>
	The number of bytes to move the file pointer is specified by <expN2>. The file pointer is moved toward the end of the file if <expN2> is positive. The file pointer is moved toward the beginning of the file if <expN2> is negative.

<expN3>
	By default, the file pointer is moved relative to the beginning of the file. You can alternatively move the file pointer relative to the beginning or the end of the file by including <expN3>. The following table lists each value for <expN3> and how it causes the file pointer to move.

				Movement 
	<expN3>		Relative to:
	ÄÄÄÄÄÄÄ		ÄÄÄÄÄÄÄÄÄÄÄÄ
	
	   0		The beginning of the file (default)

	   1		The current file pointer position

	   2		The end of the file

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Example             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
The following user-defined function uses FSEEK() to return the size of a file. If you don't pass parameters to the UDF, it returns -2. If the file cannot be found, the UDF returns -1.

FUNCTION fsize2
PARAMETERS mfile 		&& File to be checked
PRIVATE mhandle,fsize

IF PARAMETERS() = 0
	RETURN -2			&& Return -2 if no parameter passed
ELSE
	IF !FILE(mfile)
		RETURN -1		&& Return -1 if file does not exist
	ENDIF
ENDIF
mhandle = FOPEN(mfile)	&& Open file
fsize = FSEEK(mhandle,0,2)	&& Determine file size, assign to fsize
=FCLOSE(mhandle)			&& Close file
RETURN fsize				&& Return value


ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             FGETS()             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FGETS(<expN1> [, <expN2>])

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Returns a series of bytes from a file or a communication port opened with a low-level file function until it encounters a carriage return.
Return value - Character
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

You can read a file line by line by issuing a series of FGETS().

FGETS() returns a series of bytes as a character string. Data is returned starting from the current file's pointer position and continuing until a carriage return is encountered. The file pointer is then positioned on the byte immediately following the carriage return. The carriage return isn't returned as part of the string, and linefeeds are discarded. 

<expN1>
	<expN1> specifies the numeric file handle of the file or communication port from which FGETS() returns data. 

<expN2>  
	You can specify the number of bytes returned by FGETS() with <expN2>. FGETS() returns <expN2> bytes unless a carriage return is encountered first. FGETS() returns data between the starting file-pointer position and the carriage return if a carriage return is encountered within <expN2> bytes.

	If <expN2> is omitted, FGETS() by default returns a maximum of 254 bytes.

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Example             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*** TEST.TXT must exist ***

STORE FOPEN('test.txt') TO file_handle		&& Open the file
STORE FSEEK(file_handle, 0, 2) TO ifp_size	&& Move pointer to EOF
STORE FSEEK(file_handle, 0) TO ifp_top		&& Move pointer to BOF

IF ifp_size <= 0 							&& Is file empty?
	WAIT WINDOW 'This file is empty!' NOWAIT
ELSE										&& If not
	l_string = FGETS(file_handle, ifp_size) && Store contents to
											&& memory
	? l_string
ENDIF
= FCLOSE(file_handle)						&& Close the file


ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             FPUTS()             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FPUTS(<expN1>, <expC> [, <expN2>])

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Writes a character string, carriage return and linefeed to a file or a communication port opened with a low-level file function.
Return value - Numeric
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

FPUTS() returns the number of bytes written to the file or port. 0 is returned if FPUTS() can't write to the file or port for any reason.

<expN1>
	FPUTS() writes to the file or communication port specified with the file handle number <expN1>.

<expC>
	The character expression that FPUTS() writes to the file or port is specified with <expC>. 

<expN2>
	FPUTS() writes the entire character expression <expC> to the file or port unless <expN2> is included. When <expN2> is included, <expN2> characters are written to the file or port. If <expN2> is less than the number of characters in <expC>, only <expN2> characters are written to the file or port. All of <expC> is written to the file or port if <expN2> is equal to or greater than the number of characters in <expC>.

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Example             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
The following example creates and opens a temporary file. If the file is successfully created, a window is displayed in which you can enter your first name, last name and position. This information is written to the temporary file, which the FoxPro editor displays. If the file isn't created, the FoxPro editor displays the empty file.

SET TALK OFF
CLEAR
tmpfile = SYS(3)			&& Create a temporary filename
handle = FCREATE(tmpfile)	&& Open the temporary file

IF handle < 0
	DEFINE WINDOW alert FROM 7,17 TO 12,60 DOUBLE COLOR SCHEME 7

	DO CASE					&& Unable to open the temporary file.
		CASE FERROR() = 4
			reason = 'Too many files open (out of handles)'
		CASE FERROR() = 5
			reason = 'Out of memory'
		CASE FERROR() = 29
			reason = 'Disk full'
		CASE FERROR() = 31
			reason = 'General Failure'
	ENDCASE

	ACTIVATE WINDOW alert
	@ 1,7 SAY 'Unable to open file'
	@ 2,7 SAY 'Reason: ' + reason
	@ 3,7 SAY 'Press a key to exit'
	=INKEY(0)
	DEACTIVATE WINDOW alert
	CANCEL
ELSE
	STORE SPACE(15) TO fname, lname, pos
	DEFINE WINDOW wingets FROM 10,20 TO 18,60 ;
		CLOSE FLOAT SHADOW SYSTEM COLOR SCHEME 8 TITLE ' Name Entry '
	ACTIVATE WINDOW wingets
	@ 1,5 SAY 'First Name: ' GET fname
	@ 3,5 SAY 'Last Name : ' GET lname
	@ 5,5 SAY 'Position  : ' GET pos
	READ
	=FWRITE(handle,'First name: ')
	=FPUTS(handle,fname)
	=FWRITE(handle,'Last name: ')
	=FPUTS(handle,lname)
	=FWRITE(handle,'Position: ')
	=FPUTS(handle,pos)
	=FCLOSE(handle)  && Close the file
	DEACTIVATE WINDOW wingets
	WAIT 'Press a key to view the file' WINDOW
ENDIF
IF !WEXIST('wingets')
	DEFINE WINDOW wingets FROM 10,20 TO 18,60 ;
		CLOSE FLOAT SHADOW SYSTEM ;
		COLOR SCHEME 8 TITLE ' Name Entry '
ENDIF

MODIFY FILE (tmpfile) WINDOW wingets NOWAIT	&& See created file
CLEAR WINDOW
