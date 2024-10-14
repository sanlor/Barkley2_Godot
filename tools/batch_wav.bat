echo converting *.wav to *.ogg 
for /r %%i in ( *.wav ) do ffmpeg -i "%%i" -acodec libvorbis "%%~di\%%~pi\%%~ni.ogg"