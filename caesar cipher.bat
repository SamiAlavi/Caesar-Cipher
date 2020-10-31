@echo off
setlocal EnableDelayedExpansion

Rem ** Variables declaration **
set /A key=3
set encrypted=
set decrypted=

Rem ** Read text from file plaintext.txt **
for /f %%i in (plaintext.txt) do set plaintext=%%i

Rem ** Get length of text from file plaintext.txt **
FOR %%? IN (plaintext.txt) DO ( SET /A strlength=%%~z? - 1 )

Rem ** Loop over each character in plaintext, get its index in alphabets and encrypt it using key **
for /L %%i in (0,1,%strlength%) do (
	set chr=!plaintext:~%%i,1!
	CALL :indexOf !chr!, index
	CALL :encrypt !index!, %key%, echr
	set encrypted=!encrypted!!echr!
)
Rem ** Write encrypted text to file **
echo %encrypted% > encrypted.txt

Rem ** Loop over each character in encrypted text, get its index in alphabets and decrypt it using key **
for /L %%i in (0,1,%strlength%) do (
	set chr=!encrypted:~%%i,1!
	CALL :indexOf !chr!, index
	CALL :decrypt !index!, %key%, dchr
	set decrypted=!decrypted!!dchr!
)
Rem ** Write decrypted text to file **
echo %decrypted% > decrypted.txt

echo key = %key%
echo plaintext = %plaintext%
echo encrypted = %encrypted%
echo decrypted = %decrypted%

pause
EXIT /B %ERRORLEVEL%


Rem ** Get index of character in alphabets **
Rem ** Inputs chr=character **
Rem ** Ouputs index=index in alphabets **
:indexOf
set alphabets=abcdefghijklmnopqrstuvwxyz
for /L %%i in (0,1,25) do (
	set tempval=!alphabets:~%%i,1!
	if %~1==!tempval! (
		set /A %~2 = %%i
		EXIT /B 0
	)
)
EXIT /B 0

Rem ** Encrypt using key **
Rem ** Inputs index=index in alphabets, key=key for Caesar Cipher **
Rem ** Ouputs echr=encrypted character **
:encrypt
set alphabets=abcdefghijklmnopqrstuvwxyz
set /A new_index=(%~1+%~2) %% 26
set tempval=!alphabets:~%new_index%,1!
set "%~3=!tempval!"
EXIT /B 0

Rem ** Decrypt using key **
Rem ** Inputs index=index in alphabets, key=key for Caesar Cipher **
Rem ** Ouputs dchr=decrypted character **
:decrypt
set alphabets=abcdefghijklmnopqrstuvwxyz
set /A new_index=(%~1-%~2) %% 26
set tempval=!alphabets:~%new_index%,1!
set "%~3=!tempval!"
EXIT /B 0